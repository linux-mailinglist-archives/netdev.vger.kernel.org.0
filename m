Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55A58C4FB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfHNALa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:11:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43574 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHNAL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:11:29 -0400
Received: from cpe-2606-a000-1405-226e-0-0-0-cbf.dyn6.twc.com ([2606:a000:1405:226e::cbf] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hxgsf-00020w-Q1; Tue, 13 Aug 2019 20:11:12 -0400
Date:   Tue, 13 Aug 2019 20:10:37 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     vyasevich@gmail.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Message-ID: <20190814001037.GB11098@localhost.localdomain>
References: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:05:50PM +0800, zhengbin wrote:
> If the stream outq is not empty, need to kfree nstr_list.
> 
> Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  net/sctp/stream.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 2594660..e83cdaa 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -316,6 +316,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
>  		nstr_list[i] = htons(str_list[i]);
> 
>  	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> +		kfree(nstr_list);
>  		retval = -EAGAIN;
>  		goto out;
>  	}
> --
> 2.7.4
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

