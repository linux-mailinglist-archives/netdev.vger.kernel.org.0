Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EAB597B66
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242709AbiHRCPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiHRCPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:15:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043A9674D
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 19:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NvKfFN11W0HjsiAnViz6ptiRNsKhivEHDDZZsK3mIeg=; b=SzpZjuHp9wP6OViLF/o2m+SRyJ
        CipeSQ4yPcjdRJ2W78JBemt5i/R+f1Gaoxd59RKOUhcNac3uPp5e4UQYbuWL+y6XgqUX1IH+GcADW
        TaFynQr/YOSuhmZ0hwU7sYkxIhFCFJWcFScZBUJysr+rBR2/ByQEoEyQjI/pPkO1bMKQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOV4N-00Dh8m-NP; Thu, 18 Aug 2022 04:15:39 +0200
Date:   Thu, 18 Aug 2022 04:15:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Feiyang Chen <chris.chenfeiyang@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Feiyang Chen <chenfeiyang@loongson.cn>,
        zhangqing@loongson.cn, chenhuacai@loongson.cn,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
Subject: Re: [PATCH] stmmac: pci: Add LS7A support for dwmac-loongson
Message-ID: <Yv2gy3I+yLzU1dYH@lunn.ch>
References: <20220816102537.33986-1-chenfeiyang@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816102537.33986-1-chenfeiyang@loongson.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void loongson_gnet_fix_speed(void *priv, unsigned int speed)
> +{
> +	struct net_device *ndev = (struct net_device *)(*(unsigned long *)priv);
> +	struct stmmac_priv *ptr = netdev_priv(ndev);
> +
> +	if (speed == SPEED_1000) {
> +		if (readl(ptr->ioaddr + MAC_CTRL_REG) & (1 << 15) /* PS */) {
> +			/* reset phy */
> +			phy_set_bits(ndev->phydev, 0 /*MII_BMCR*/,
> +				     0x200 /*BMCR_ANRESTART*/);

The MAC driver should not be accessing PHY registers. Why does the PHY
need a reset? Can you call phy_stop()/phy_start()?

     Andrew
