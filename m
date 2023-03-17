Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814046BEAA7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCQODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCQODr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:03:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB0275A58;
        Fri, 17 Mar 2023 07:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E7Js/gL7fDNHxFoBAEe3ebsc95WWzM8qRUyoE8r02HY=; b=QbIEd+2HuYWiLs46y1jPNOgTcp
        LTHARoM7vQyJ2bdFSQi9JuIevpg4w5wMt7Edz4Usm6KyqHgHu0Mjc/GI/SgVL+pSUVgOHo4KKUuBP
        p2aJ2TkU+oZLtWtkIUOBkP2HiaLNb6FUvmA8duuYk+YuU9kCF3BJAjxus4dV2+ooJUdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdAg8-007cC5-OJ; Fri, 17 Mar 2023 15:03:32 +0100
Date:   Fri, 17 Mar 2023 15:03:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <f292505c-ab74-47f4-be7f-18dd4a7e2903@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-5-ansuelsmth@gmail.com>
 <ZBRtRw8pg0mcRxbZ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBRtRw8pg0mcRxbZ@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 02:38:15PM +0100, Michal Kubiak wrote:
> On Fri, Mar 17, 2023 at 03:31:15AM +0100, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > Define common binding parsing for all PHY drivers with LEDs using
> > phylib. Parse the DT as part of the phy_probe and add LEDs to the
> > linux LED class infrastructure. For the moment, provide a dummy
> > brightness function, which will later be replaced with a call into the
> > PHY driver.
> >
> 
> Hi Andrew,
> 
> Personally, I see no good reason to provide a dummy implementation
> of "phy_led_set_brightness", especially if you implement it in the next
> patch. You only use that function only the function pointer in
> "led_classdev". I think you can just skip it in this patch.

Hi Michal

The basic code for this patch has been sitting in my tree for a long
time. It used to be, if you did not have a set_brightness method in
cdev, the registration failed. That made it hard to test this patch on
its own during development work, did i have the link list correct, can
i unload the PHY driver without it exploding etc. I need to check if
it is still mandatory.

> > +static int of_phy_led(struct phy_device *phydev,
> > +		      struct device_node *led)
> > +{
> > +	struct device *dev = &phydev->mdio.dev;
> > +	struct led_init_data init_data = {};
> > +	struct led_classdev *cdev;
> > +	struct phy_led *phyled;
> > +	int err;
> > +
> > +	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
> > +	if (!phyled)
> > +		return -ENOMEM;
> > +
> > +	cdev = &phyled->led_cdev;
> > +
> > +	err = of_property_read_u32(led, "reg", &phyled->index);
> > +	if (err)
> > +		return err;
> 
> Memory leak. 'phyled' is not freed in case of error.

devm_ API, so it gets freed when the probe fails.

> > +
> > +	cdev->brightness_set_blocking = phy_led_set_brightness;
> 
> Please move this initialization to the patch where you are actually
> implementing this callback.
> 
> > +	cdev->max_brightness = 1;
> > +	init_data.devicename = dev_name(&phydev->mdio.dev);
> > +	init_data.fwnode = of_fwnode_handle(led);
> > +
> > +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
> > +	if (err)
> > +		return err;
> 
> Another memory leak.

Ah, maybe you don't know about devm_ ? devm_ allocations and actions
register an action to be taken when the device is removed, either
because the probe failed, or when the device is unregistered. For
memory allocation, the memory is freed automagically. For actions like
registering an LED, requesting an interrupt etc, an unregister/release
is performed. This makes cleanup less buggy since the core does it.

   Andrew
