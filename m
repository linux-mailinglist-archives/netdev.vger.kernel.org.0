Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3BB59C048
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiHVNMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiHVNMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:12:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE4533E3A;
        Mon, 22 Aug 2022 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Pmaf/7Gcj7yUXj9lfFijn0lHnAtMyFGBEGv7jKC4glY=; b=VnJFQ/GqGILH+2rdH6itFRAGSC
        t+CAGFHwsZHEpc2+rLLnHKJO8AcBu7Bkz/zVbbedoZW3xnc0JQgkfY7cdeXGJhmvPKZpcXj9v4iaE
        iaKe79K8QNuEtyf8+C2amwgJJ87YGAQK6OJ5ftv0P4RacuXG2iz9ecXxyz6v1a7zIaqc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQ7EM-00EDzw-L8; Mon, 22 Aug 2022 15:12:38 +0200
Date:   Mon, 22 Aug 2022 15:12:38 +0200
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
Message-ID: <YwOAxh7Bc12OornD@lunn.ch>
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

On Mon, Aug 22, 2022 at 02:50:17PM +0530, Arun Ramadoss wrote:
> This patch enables the interrupts for internal phy link detection for
> LAN937x. The interrupt enable bits are active low. It first enables port
> interrupt and then port phy interrupt. Also patch register the irq
> thread and in the ISR routine it clears the POR_READY_STS bit.
> POR_READY_STS bit is write one clear bit and all other bit in the
> register are read only. Since phy interrupts are handled by the lan937x
> phy layer, switch interrupt routine does not read the phy layer
> interrupts.

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
> +
> +	if (data & POR_READY_INT) {
> +		ret = ksz_write32(dev, REG_SW_INT_STATUS__4, POR_READY_INT);
> +		if (ret)
> +			return result;
> +	}
> +
> +	return result;
> +}

I don't understand how this all fits together. How do you get from
this interrupt handler into the PHY interrupt handler?

The hardware looks similar to the mv88e6xxx driver. You have a top
level interrupt controller which indicates a port has some sort of
interrupt handler. This is the mv88e6xxx_g1_irq_thread_work(). It
finds which port triggered the interrupt and then hands the interrupt
off to the nested interrupt handler.

mv88e6xxx_g2_irq_thread_fn() is the nested per port interrupt
handler. It reads the per port interrupt status register, find the
interrupt handler and calls the nested interrupt handler.

This all glues together because phylib does a request_threaded_irq()
for the PHY interrupt, so this last nested interrupt handler is in
phylib.

	Andrew
