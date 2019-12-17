Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E854122AB0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLQLzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:55:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50139 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQLzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:55:19 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1ihBRa-0008NY-6H; Tue, 17 Dec 2019 06:55:16 -0500
Date:   Tue, 17 Dec 2019 06:55:13 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream
 initialization
Message-ID: <20191217115513.GB730@hmswarspite.think-freely.org>
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:01:16PM -0300, Marcelo Ricardo Leitner wrote:
> syzbot reported a memory leak when an allocation fails within
> genradix_prealloc() for output streams. That's because
> genradix_prealloc() leaves initialized members initialized when the
> issue happens and SCTP stack will abort the current initialization but
> without cleaning up such members.
> 
> The fix here is to always call genradix_free() when genradix_prealloc()
> fails, for output and also input streams, as it suffers from the same
> issue.
> 
> Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> Fixes: 2075e50caf5e ("sctp: convert to genradix")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/stream.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index df60b5ef24cbf5c6f628ab8ed88a6faaaa422b6d..e0b01bf912b3f3cdbc3f713bcfa50868e4802929 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>  		return 0;
>  
>  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> -	if (ret)
> +	if (ret) {
> +		genradix_free(&stream->out);
>  		return ret;
> +	}
>  
>  	stream->outcnt = outcnt;
>  	return 0;
> @@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
>  		return 0;
>  
>  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> -	if (ret)
> +	if (ret) {
> +		genradix_free(&stream->in);
>  		return ret;
> +	}
>  
>  	stream->incnt = incnt;
>  	return 0;
> -- 
> 2.23.0
> 
> 
As mentioned in the other thread, shouldn't genradix_prealloc clean this up
internal to its function.  It seems odd having to free memory allocated on
error.

Neil

