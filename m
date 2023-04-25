Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D8A6EDA9A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 05:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjDYDVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 23:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjDYDVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 23:21:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F7EAD1F;
        Mon, 24 Apr 2023 20:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WEmClTcIG/yj2IJg2sMiouG+QJxouKRVrQEnosw5z4s=; b=lHuHBQgxtGQ7hCHiZ49FHe946W
        3+YvjIbp/kUPYSW8rNA2w6o/dbTaU1RGzEaFNqq70fbAzHQId0sA2mDQLFbQtHffsphxbRQ0nCeOr
        OlCMK6hXChNY2gokiMEfK+j5fwQHiYEjY70q5otsrSLxC+bomaXBb2E1X79/c8J+ndg0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pr9EJ-00B9Ke-UK; Tue, 25 Apr 2023 05:20:35 +0200
Date:   Tue, 25 Apr 2023 05:20:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qingfang Deng <dqfext@gmail.com>,
        SkyLake Huang <SkyLake.Huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v2] net: phy: add driver for MediaTek SoC built-in GE PHYs
Message-ID: <651ef153-7555-4ae1-a068-cbe5f0da7e34@lunn.ch>
References: <ZEPU6oahOGwknkSc@makrotopia.org>
 <20230424183755.3fac65b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424183755.3fac65b0@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:37:55PM -0700, Jakub Kicinski wrote:
> On Sat, 22 Apr 2023 13:36:58 +0100 Daniel Golle wrote:
> > Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> > PHYs which require calibration data from the SoC's efuse.
> > Despite the similar design the driver doesn't share any code with the
> > existing mediatek-ge.c, so add support for these PHYs by introducing a
> > new driver for only MediaTek's ARM64 SoCs.
> 
> Andrew, Heiner, how do you feel about this driver?

It is 95% magic values in magic registers which nobody is every going
to understand without the datasheet. Assuming any of it is actually in
the data sheet. I really think the firmware in this PHY needs a
re-write to avoid exposing all this to the OS. But i don't know if we
have that level of NACK. Having said that, there is a nice quote in
LWN from Thomas Gleixer about this:

https://lwn.net/Articles/928946/

This does seem like a case of 'throw hardware/firmware over the fence
and let software folks deal with it.' There is no other PHY like it in
Linux. So i would like to reject it, but i then suspect we are
punishing the wrong people, Daniel not MediaTek.

I would also drop the LED configuration parts. Leave it at reset
defaults for the moment. It seems like the generic support for
controlling PHY LEDs is making progress and will be merged next cycle.

	    Andrew
