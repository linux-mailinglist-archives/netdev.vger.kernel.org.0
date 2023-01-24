Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4D678DF2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjAXCIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjAXCIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:08:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E071A972;
        Mon, 23 Jan 2023 18:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7/JIwVXiCaPDOdmqesGLjJhozqxJG+q2zVApYkSIfX4=; b=Zop2DgmqOnBus6DPl8Kszy1RhW
        JjCLCtBbKDsU71zuR/kd1cB0/viMI8sfKDMrRSTOSBhUSzIqaJSL8T6Otl/vREpM58KI3sopgsHtd
        9SXT2HPDJaPm8YpY7lW0x09v68IxuCSkgyAXZk3CVgFZU9JZiJy5Y+r/t7QhxNdKcnQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK8jb-002yBh-Os; Tue, 24 Jan 2023 03:08:27 +0100
Date:   Tue, 24 Jan 2023 03:08:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        yangyingliang@huawei.com, weiyongjun1@huawei.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, lennart@lfdomain.com
Subject: Re: [net-next 1/3] net: ethernet: adi: adin1110: add PTP clock
 support
Message-ID: <Y889m+CUSTbuv9Db@lunn.ch>
References: <20230120095348.26715-1-alexandru.tachici@analog.com>
 <20230120095348.26715-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120095348.26715-2-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin1110_enable_perout(struct adin1110_priv *priv,
> +				  struct ptp_perout_request perout,
> +				  int on)
> +{
> +	u32 on_nsec;
> +	u32 phase;
> +	u32 mask;
> +	int ret;
> +
> +	if (priv->cfg->id == ADIN2111_MAC) {
> +		ret = phy_clear_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
> +					 ADIN2111_LED_CNTRL,
> +					 ADIN2111_LED_CNTRL_LED0_FUNCTION);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
> +				       ADIN2111_LED_CNTRL,
> +				       on ? ADIN2111_LED_CNTRL_TS_TIMER : 0);

I normally say a MAC driver should not be accessing PHY register...

You have the advantage of knowing it is integrated, so you know
exactly what PHY it is. But you still have a potential race condition
sometime in the future. You are not taking the phydev->lock, which is
something phylib nearly always does before accessing a PHY. If you
ever add control of the LEDs, that lack of locking could get you in
trouble.

Is this functionality always on LED0? It cannot be LED1 or LED2?

   Andrew
