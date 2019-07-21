Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB36F260
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 11:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfGUJNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 05:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGUJM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 05:12:59 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7717BC036744;
        Sun, 21 Jul 2019 09:12:59 +0000 (UTC)
Received: from maya.cloud.tilaa.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33E1B60497;
        Sun, 21 Jul 2019 09:12:59 +0000 (UTC)
Received: from elisabeth (055-041-157-037.ip-addr.inexio.net [37.157.41.55])
        by maya.cloud.tilaa.com (Postfix) with ESMTPSA id 365394007B;
        Sun, 21 Jul 2019 11:12:58 +0200 (CEST)
Date:   Sun, 21 Jul 2019 11:12:56 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rat_cs: Remove duplicate code
Message-ID: <20190721111256.708f4cfa@elisabeth>
In-Reply-To: <20190720174613.GA31062@hari-Inspiron-1545>
References: <20190720174613.GA31062@hari-Inspiron-1545>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sun, 21 Jul 2019 09:12:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jul 2019 23:16:47 +0530
Hariprasad Kelam <hariprasad.kelam@gmail.com> wrote:

> Code is same if translate is true/false in case invalid packet is
> received.So remove else part.
> 
> Issue identified with coccicheck
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  drivers/net/wireless/ray_cs.c | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
> index cf37268..a51bbe7 100644
> --- a/drivers/net/wireless/ray_cs.c
> +++ b/drivers/net/wireless/ray_cs.c
> @@ -2108,29 +2108,16 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
>  #endif
>  
>  	if (!sniffer) {
> -		if (translate) {
>  /* TBD length needs fixing for translated header */
> -			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
> -			    rx_len >
> -			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
> -			     FCS_LEN)) {
> -				pr_debug(
> -				      "ray_cs invalid packet length %d received\n",
> -				      rx_len);
> -				return;
> -			}
> -		} else { /* encapsulated ethernet */
> -
> -			if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
> -			    rx_len >
> -			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
> -			     FCS_LEN)) {
> -				pr_debug(
> -				      "ray_cs invalid packet length %d received\n",
> -				      rx_len);
> -				return;
> +		if (rx_len < (ETH_HLEN + RX_MAC_HEADER_LENGTH) ||
> +		    rx_len >
> +		    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
> +		     FCS_LEN)) {
> +			pr_debug(
> +			      "ray_cs invalid packet length %d received\n",
> +			      rx_len);
> +			return;
>  			}
> -		}

NACK. The TBD comment makes no sense anymore if you remove one of the
branches. Believe me or not, I have one of those cards, a (yes, 22
years old) Buslink Raytheon model 24020. That check needed (for sure)
and needs (maybe) to be fixed.

Besides, patch subject and resulting coding style are also wrong.

-- 
Stefano
