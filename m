Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2D6A70A
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfGPLKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:10:02 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37697 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733200AbfGPLKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:10:02 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hnLL9-0007ym-9m; Tue, 16 Jul 2019 07:09:58 -0400
Date:   Tue, 16 Jul 2019 07:09:17 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: fix warning "NULL check before some freeing
 functions is not needed"
Message-ID: <20190716110917.GA1498@hmswarspite.think-freely.org>
References: <20190716022002.GA19592@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716022002.GA19592@hari-Inspiron-1545>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 07:50:02AM +0530, Hariprasad Kelam wrote:
> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ed39396..36bd8a6e 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2582,8 +2582,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len =
>  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> -		if (asoc->peer.cookie)
> -			kfree(asoc->peer.cookie);
> +		kfree(asoc->peer.cookie);
>  		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			retval = 0;
> @@ -2648,8 +2647,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's random parameter */
> -		if (asoc->peer.peer_random)
> -			kfree(asoc->peer.peer_random);
> +		kfree(asoc->peer.peer_random);
>  		asoc->peer.peer_random = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_random) {
> @@ -2663,8 +2661,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's HMAC list */
> -		if (asoc->peer.peer_hmacs)
> -			kfree(asoc->peer.peer_hmacs);
> +		kfree(asoc->peer.peer_hmacs);
>  		asoc->peer.peer_hmacs = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_hmacs) {
> @@ -2680,8 +2677,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  		if (!ep->auth_enable)
>  			goto fall_through;
>  
> -		if (asoc->peer.peer_chunks)
> -			kfree(asoc->peer.peer_chunks);
> +		kfree(asoc->peer.peer_chunks);
>  		asoc->peer.peer_chunks = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_chunks)
> -- 
> 2.7.4
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
