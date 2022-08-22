Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493EC59BFDD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiHVM4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHVM4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:56:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B9FDF04;
        Mon, 22 Aug 2022 05:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4HwX4Xt+0LlaFddOVA3H37jo/iFLtDmHfMsKNXH4QQE=; b=eAu42MNVE0/RHvTO426OcnNwWR
        Ws7oJRD7bsbY6B2+ltxRHGG2LBrF2FJg7NYKyJEDzGTK7ZAjmW0UEN8WuttHIYFstYB80+S5H/ubL
        NOnqDb4D9BfGNYZ57mkKykGDnnedm6YZOfQ5eTH96z1hNdkJjOgPu/YGzv6YxpT9V3LU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQ6yu-00EDun-VT; Mon, 22 Aug 2022 14:56:40 +0200
Date:   Mon, 22 Aug 2022 14:56:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable
 interrupt for internal phy link detection
Message-ID: <YwN9CMMhHDxB8mdj@lunn.ch>
References: <20220822092017.5671-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822092017.5671-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static irqreturn_t lan937x_switch_irq_thread(int irq, void *dev_id)
> +{
> +	struct ksz_device *dev = dev_id;
> +	irqreturn_t result = IRQ_NONE;
> +	u32 data;
> +	int ret;
> +
> +	/* Read global interrupt status register */
> +	ret = ksz_read32(dev, REG_SW_INT_STATUS__4, &data);
> +	if (ret)
> +		return result;

I don't think you can return negative error numbers here.

> +
> +	if (data & POR_READY_INT) {
> +		ret = ksz_write32(dev, REG_SW_INT_STATUS__4, POR_READY_INT);
> +		if (ret)
> +			return result;

Returning IRQ_NONE here seems wrong. You handle the interrupt, so
should probably return IRQ_HANDLED.

      Andrew
