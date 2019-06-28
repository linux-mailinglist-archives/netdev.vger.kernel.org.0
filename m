Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984D5598FD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfF1LGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:06:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58286 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF1LGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 07:06:39 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hgoi5-00018D-AQ; Fri, 28 Jun 2019 07:06:35 -0400
Date:   Fri, 28 Jun 2019 07:06:01 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        linux-sctp@vger.kernel.org, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net] sctp: fix error handling on stream scheduler
 initialization
Message-ID: <20190628110601.GA14635@hmswarspite.think-freely.org>
References: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 07:48:10PM -0300, Marcelo Ricardo Leitner wrote:
> It allocates the extended area for outbound streams only on sendmsg
> calls, if they are not yet allocated.  When using the priority
> stream scheduler, this initialization may imply into a subsequent
> allocation, which may fail.  In this case, it was aborting the stream
> scheduler initialization but leaving the ->ext pointer (allocated) in
> there, thus in a partially initialized state.  On a subsequent call to
> sendmsg, it would notice the ->ext pointer in there, and trip on
> uninitialized stuff when trying to schedule the data chunk.
> 
> The fix is undo the ->ext initialization if the stream scheduler
> initialization fails and avoid the partially initialized state.
> 
> Although syzkaller bisected this to commit 4ff40b86262b ("sctp: set
> chunk transport correctly when it's a new asoc"), this bug was actually
> introduced on the commit I marked below.
> 
> Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Tested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/stream.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 93ed07877337eace4ef7f4775dda5868359ada37..25946604af85c09917e63e5c4a8d7d6fa2caebc4 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>  int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
>  {
>  	struct sctp_stream_out_ext *soute;
> +	int ret;
>  
>  	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
>  	if (!soute)
>  		return -ENOMEM;
>  	SCTP_SO(stream, sid)->ext = soute;
>  
> -	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +	ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +	if (ret) {
> +		kfree(SCTP_SO(stream, sid)->ext);
> +		SCTP_SO(stream, sid)->ext = NULL;
> +	}
> +
> +	return ret;
>  }
>  
>  void sctp_stream_free(struct sctp_stream *stream)
> -- 
> 2.21.0
> 
> 
Acked-by: Neil Horman <nhorman@redhat.com>
