Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1565F3D4F67
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 20:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGYRek convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Jul 2021 13:34:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:60882 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhGYRej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 13:34:39 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GXrnR3D0qzBCT7;
        Sun, 25 Jul 2021 20:15:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Sq9mXGMKc0Gf; Sun, 25 Jul 2021 20:15:07 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GXrnR26f4zBCSl;
        Sun, 25 Jul 2021 20:15:07 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 8F1B6F6; Sun, 25 Jul 2021 20:20:24 +0200 (CEST)
Received: from 37-165-12-41.coucou-networks.fr
 (37-165-12-41.coucou-networks.fr [37.165.12.41]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 25 Jul 2021 20:20:24 +0200
Date:   Sun, 25 Jul 2021 20:20:24 +0200
Message-ID: <20210725202024.Horde.ny_SOmXxQaV1anUeTSqDWQ2@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 04/10] net/ps3_gelic: Add new macro BUG_ON_DEBUG
References: <cover.1627068552.git.geoff@infradead.org>
 <bc659850d4eec3b2358c1ccb0e00952ceaa6012f.1627068552.git.geoff@infradead.org>
In-Reply-To: <bc659850d4eec3b2358c1ccb0e00952ceaa6012f.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> Add a new preprocessor macro BUG_ON_DEBUG, that expands to BUG_ON when
> the preprocessor macro DEBUG is defined, or to WARN_ON when DEBUG is not
> defined.  Also, replace all occurrences of BUG_ON with BUG_ON_DEBUG.

Why is BUG_ON() needed at all if WARN_ON() is enough ?

You just have to set panic_on_warn  to get the system to stop at first  
warning.

BUG_ON() should be avoided unless vital.

Please read  
https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on

Christophe


>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c  
> b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index ded467d81f36..946e9bfa071b 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -44,6 +44,13 @@ MODULE_AUTHOR("SCE Inc.");
>  MODULE_DESCRIPTION("Gelic Network driver");
>  MODULE_LICENSE("GPL");
>
> +#define BUG_ON_DEBUG(_cond) do { \
> +	if (__is_defined(DEBUG)) \
> +		BUG_ON(_cond); \
> +	else \
> +		WARN_ON(_cond); \
> +} while (0)
> +
>  int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask)
>  {
>  	struct device *dev = ctodev(card);
> @@ -505,7 +512,7 @@ static void gelic_descr_release_tx(struct  
> gelic_card *card,
>  	struct sk_buff *skb = descr->skb;
>  	struct device *dev = ctodev(card);
>
> -	BUG_ON(!(be32_to_cpu(descr->hw_regs.data_status) &
> +	BUG_ON_DEBUG(!(be32_to_cpu(descr->hw_regs.data_status) &
>  		GELIC_DESCR_TX_TAIL));
>
>  	dma_unmap_single(dev, be32_to_cpu(descr->hw_regs.payload.dev_addr),
> @@ -1667,7 +1674,7 @@ static void gelic_card_get_vlan_info(struct  
> gelic_card *card)
>  	}
>
>  	if (card->vlan[GELIC_PORT_ETHERNET_0].tx) {
> -		BUG_ON(!card->vlan[GELIC_PORT_WIRELESS].tx);
> +		BUG_ON_DEBUG(!card->vlan[GELIC_PORT_WIRELESS].tx);
>  		card->vlan_required = 1;
>  	} else
>  		card->vlan_required = 0;
> @@ -1709,7 +1716,7 @@ static int ps3_gelic_driver_probe(struct  
> ps3_system_bus_device *sb_dev)
>  	if (result) {
>  		dev_err(dev, "%s:%d: ps3_dma_region_create failed: %d\n",
>  			__func__, __LINE__, result);
> -		BUG_ON("check region type");
> +		BUG_ON_DEBUG("check region type");
>  		goto fail_dma_region;
>  	}
>
> --
> 2.25.1


