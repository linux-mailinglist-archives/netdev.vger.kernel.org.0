Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3AE77323
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfGZVCr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Jul 2019 17:02:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:02:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EE3912665347;
        Fri, 26 Jul 2019 14:02:46 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:02:45 -0700 (PDT)
Message-Id: <20190726.140245.129199617321965171.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, matthias.bgg@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: ethernet: mediatek: Add basic
 PHYLINK support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724192340.18978-1-opensource@vdorst.com>
References: <20190724192340.18978-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:02:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Wed, 24 Jul 2019 21:23:40 +0200

> @@ -186,165 +187,219 @@ static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
>  	mtk_w32(eth, val, TRGMII_TCK_CTRL);
>  }
>  
> -static void mtk_phy_link_adjust(struct net_device *dev)
> +static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
> +			   const struct phylink_link_state *state)
>  {
> -	struct mtk_mac *mac = netdev_priv(dev);
> -	u16 lcl_adv = 0, rmt_adv = 0;
> -	u8 flowctrl;
> -	u32 mcr = MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG |
> -		  MAC_MCR_FORCE_MODE | MAC_MCR_TX_EN |
> -		  MAC_MCR_RX_EN | MAC_MCR_BACKOFF_EN |
> -		  MAC_MCR_BACKPR_EN;
> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
> +					   phylink_config);
> +	struct mtk_eth *eth = mac->hw;
>  
> -	if (unlikely(test_bit(MTK_RESETTING, &mac->hw->state)))
> -		return;
> +	u32 ge_mode = 0, val, mcr_cur, mcr_new;

Please elminiate the empty line in the middle of the local variabel
declarations and adhere to reverse christmas tree ordering.
> @@ -1798,6 +1853,13 @@ static int mtk_open(struct net_device *dev)
>  {
>  	struct mtk_mac *mac = netdev_priv(dev);
>  	struct mtk_eth *eth = mac->hw;
> +	int err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);

Reverse christmas tree please.

> @@ -2375,9 +2407,10 @@ static const struct net_device_ops mtk_netdev_ops = {
>  
>  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  {
> +	struct phylink *phylink;
>  	struct mtk_mac *mac;
>  	const __be32 *_id = of_get_property(np, "reg", NULL);
> -	int id, err;
> +	int phy_mode, id, err;

While you are here please fix up the reverse christmas tree ordering, and
definitely don't make it worse :)
