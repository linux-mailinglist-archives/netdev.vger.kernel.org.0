Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA05563DDE
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiGBDCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBDCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECD2377D4;
        Fri,  1 Jul 2022 20:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7CD61903;
        Sat,  2 Jul 2022 03:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110AEC341C6;
        Sat,  2 Jul 2022 03:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656730962;
        bh=QZKkKnbfMMAAGcvlDsl6UzLYU+1c9zGZndPC4xxCHWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DSkhhUR7voEI82iNnVEEhuYItFrUt78qLJuiMf77EQdhHeUpY7aWjwHpVdSQBzjGg
         z9t3J0Qs+iW4GRZm7XjU37JcyuOSiqrv6knxWaDBxo37MfnmHprJIwYAgwfFd8epJk
         tAITY9hH/vmgCHGCb8sboE479usE1f47pbf+XOVcfH2WuYp+F5/6x5nB7o3w5OUJ5J
         E4NrzEaOhXe2gVy39juqToD++AKquSrS86/Z7vJNdBRbA0yLRM96v9P0L3nuvClSp7
         XsfAMYq5D5LbzfdkB7AHObfsNwRWVDXRaDRnRFZXrUuzMEiJy8mPT/otSlRoigA/u4
         btew7iHktCeTw==
Date:   Fri, 1 Jul 2022 20:02:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <20220701200241.388e1fd5@kernel.org>
In-Reply-To: <20220701192609.3970317-10-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
        <20220701192609.3970317-10-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 12:26:09 -0700 Colin Foster wrote:
> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
> 
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.

allmodconfig is not happy, I didn't spot that being mentioned as
expected:

ERROR: modpost: "ocelot_spi_init_regmap" [drivers/mfd/ocelot-core.ko] undefined!
WARNING: modpost: module ocelot-spi uses symbol ocelot_chip_reset from namespace MFD_OCELOT, but does not import it.
WARNING: modpost: module ocelot-spi uses symbol ocelot_core_init from namespace MFD_OCELOT, but does not import it.
make[2]: *** [../scripts/Makefile.modpost:128: modules-only.symvers] Error 1
make[1]: *** [/home/nipa/net-next/Makefile:1757: modules] Error 2
