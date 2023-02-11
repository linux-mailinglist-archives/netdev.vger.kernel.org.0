Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9446931F8
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 16:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBKP3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 10:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKP3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 10:29:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E5234E5;
        Sat, 11 Feb 2023 07:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8YPAqYrXs8xgVTeNN1RVK5WeYcrdHrjBJgamcx6JiKM=; b=bPTho8JMeWATFLKUG2ByZRkvWY
        6ZE21x0qHhQ+N/jj69zQzyMjZki9BYI4hKNhn5L9nEMaVv1sKRsNiOX6OjDyC5uQpP0AHgXeFZ2nr
        0yIdHVfnmDK6J2AiFEzeAdm9QDGT9TlhFjRzSEPSSk1rUOolXjOOFxTJQ/y0aHI2PUag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQroM-004hrp-2Y; Sat, 11 Feb 2023 16:29:10 +0100
Date:   Sat, 11 Feb 2023 16:29:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Y+e0RrevtDpEMqyg@lunn.ch>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-3-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210114957.2667963-3-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 05:19:57PM +0530, MD Danish Anwar wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> This is the Ethernet driver for TI AM654 Silicon rev. 2
> with the ICSSG PRU Sub-system running dual-EMAC firmware.
> 
> The Programmable Real-time Unit and Industrial Communication Subsystem
> Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
> SoCs. This subsystem is provided for the use cases like implementation of
> custom peripheral interfaces, offloading of tasks from the other
> processor cores of the SoC, etc.
> 
> Every ICSSG core has two Programmable Real-Time Unit(PRUs),
> two auxiliary Real-Time Transfer Unit (RT_PRUs), and
> two Transmit Real-Time Transfer Units (TX_PRUs). Each one of these runs
> its own firmware. Every ICSSG core has two MII ports connect to these
> PRUs and also a MDIO port.
> 
> The cores can run different firmwares to support different protocols and
> features like switch-dev, timestamping, etc.
> 
> It uses System DMA to transfer and receive packets and
> shared memory register emulation between the firmware and
> driver for control and configuration.
> 
> This patch adds support for basic EMAC functionality with 1Gbps
> and 100Mbps link speed. 10M and half duplex mode are not supported
> currently as they require IEP, the support for which will be added later.
> Support for switch-dev, timestamp, etc. will be added later
> by subsequent patch series.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [Vignesh Raghavendra: add 10M full duplex support]
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> [Grygorii Strashko: add support for half duplex operation]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

The PHY handling looks correct now.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
