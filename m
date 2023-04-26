Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551576EFCA7
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbjDZVwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjDZVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 17:52:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805471FF9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 14:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u6KRxAuP892pwEwzbMbLD1F8QfXT6RRvQwIHUE4p3Bs=; b=VNuduJlmxKLaaFRIgoNXjO+nep
        rom3Hyb7Xjm6lbO7N2vhzn8WsZW+P/4HrgosXMHvEANQu3Dr/q+w40xCD0fH5QWR2EWx/Bro+vc54
        LLqGnz4bOAqh+3bte3gmX1fEafOf1PKyiqIzrkMpWPAZRzh6Y26kyBz+HQJPASLfbpPg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prn3g-00BJ4l-Kf; Wed, 26 Apr 2023 23:52:16 +0200
Date:   Wed, 26 Apr 2023 23:52:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jan.huber@microchip.com, thorsten.kummermehr@microchip.com,
        ramon.nordin.rodriguez@ferroamp.se
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <c9d06cfe-8834-4ffa-81a8-097c883cc960@lunn.ch>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -#define LAN867X_REG_IRQ_1_CTL 0x001C
> -#define LAN867X_REG_IRQ_2_CTL 0x001D
> +#define LAN86XX_REG_IRQ_1_CTL 0x001C
> +#define LAN86XX_REG_IRQ_2_CTL 0x001D

This patch is pretty big. Please split to LAN867X to LAN86XX rename
out, to make the patches smaller and easier to review.

> +static int lan865x_revb0_plca_set_cfg(struct phy_device *phydev,
> +				      const struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +
> +	ret = genphy_c45_plca_set_cfg(phydev, plca_cfg);
> +	if (ret)
> +		return ret;
> +
> +	/* Disable the collision detection when PLCA is enabled and enable
> +	 * collision detection when CSMA/CD mode is enabled.
> +	 */
> +	if (plca_cfg->enabled)
> +		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0000);
> +	else
> +		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0083);
> +}
> +

This could be in a patch of its own, with a good commit message
explaining why it is needed.

Once you replace the magic numbers with #defines, the comment becomes
pointless. But what is missing is the answer to the question Why?

	   Andrew

