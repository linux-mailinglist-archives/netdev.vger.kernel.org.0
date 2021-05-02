Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B08370F03
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 22:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhEBU3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 16:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhEBU3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 16:29:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59627C06174A;
        Sun,  2 May 2021 13:28:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldIhX-000260-Ah; Sun, 02 May 2021 22:28:27 +0200
Date:   Sun, 2 May 2021 22:28:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: ath9k_htc_rx_msg: return when sk_buff is too small
Message-ID: <20210502202827.GG975@breakpoint.cc>
References: <20210502202545.1405-1-phil@philpotter.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210502202545.1405-1-phil@philpotter.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phillip Potter <phil@philpotter.co.uk> wrote:
> At the start of ath9k_htc_rx_msg, we check to see if the skb pointer is
> valid, but what we don't do is check if it is large enough to contain a
> valid struct htc_frame_hdr. We should check for this and return, as the
> buffer is invalid in this case. Fixes a KMSAN-found uninit-value bug
> reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=7dccb7d9ad4251df1c49f370607a49e1f09644ee
> 
> Reported-by: syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  drivers/net/wireless/ath/ath9k/htc_hst.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index 510e61e97dbc..9dbfff7a388e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -403,7 +403,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>  	struct htc_endpoint *endpoint;
>  	__be16 *msg_id;
>  
> -	if (!htc_handle || !skb)
> +	if (!htc_handle || !skb || !pskb_may_pull(skb, sizeof(struct htc_frame_hdr)))
>  		return;

This leaks the skb.
