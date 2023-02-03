Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DDD689B3A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjBCONJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjBCOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:12:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7E924CAE
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/CYFAXTsmKqeYzJLJiyVuokZQ3dJLjVY4LZ2WTOiZlY=; b=LE
        dmkw2nNgUoEd+DFJeyMUktgfZkHmM4Sr21XaxemclJe0yesAVScuxtyuRmIILsXFhMHsi5rhXZrUw
        mxwdkg6qeJ2QduZXMt7FWjCEOLX9pk8iPsAC1crfCVqS6Jhys5mcu1pQgQZu3z9GeJ7zT80FIkT1g
        CRagTTR2Ga+b5iI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwW3-0040Ih-MP; Fri, 03 Feb 2023 14:54:11 +0100
Date:   Fri, 3 Feb 2023 14:54:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Valek, Andrej" <andrej.valek@siemens.com>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Message-ID: <Y90SA/8RzaRCvna8@lunn.ch>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
 <Y9vfLYtio1fbZvfW@lunn.ch>
 <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
 <Y9v8fBxpO19jr9+9@lunn.ch>
 <05f695cd76ffcc885e6ea70c58d0a07dbc48a341.camel@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05f695cd76ffcc885e6ea70c58d0a07dbc48a341.camel@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > This looks promising. So I have to just move the "reset-gpios" DTB
> > > entry from switch to mdio section. But which driver handles it,
> > > drivers/net/phy/mdio_bus.c,
> > 
> > Yes.
> > 
> > > > mdio {
> > > >         #address-cells = <1>;
> > > >         #size-cells = 0>;
> > > while here is no compatible part... .
> > 
> > It does not need a compatible, because it is part of the FEC, and the
> > FEC has a compatible. Remember this is device tree, sometimes you need
> > to go up the tree towards the root to find the actual device with a
> > compatible.
> > 
> >     Andrew
> I tried put the "reset-gpios" and "reset-delay-us" into multiple mdio locations, but nothing has been working. DTB looks like that:
> 
> > &fec1 {
> > 	pinctrl-names = "default";
> > 	pinctrl-0 = <&pinctrl_fec1>;
> > 	phy-mode = "rgmii-id";
> > 	tx-internal-delay-ps = <2000>;
> > 	rx-internal-delay-ps = <2000>;
> > 	slaves = <1>;			// use only one emac if
> > 	status = "okay";
> > 	mac-address = [ 00 00 00 00 00 00 ]; // Filled in by U-Boot
> >
> > 	// #### 3. try ####
> > 	//phy-reset-gpios = <&lsio_gpio0 13 GPIO_ACTIVE_LOW>;
> > 	//reset-delay-us = <10000>;
> >
> > 	fixed-link {
> > 		speed = <1000>;
> > 		full-duplex;
> > 	};
> >
> > 	mdio {
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> >
> > 		// 1. try
> > 		reset-gpios = <&lsio_gpio0 13 GPIO_ACTIVE_LOW>;
> > 		reset-delay-us = <10000>;

This looks like the correct location. Have you put a printk() after
https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/mdio_bus.c#L569
to make sure it has found it?

You might also need a post reset delay. I'm not sure the device will
answer if it is still busy reading the EEPROM. Which is why the
mv88e6xxx hardware reset does some polling before continuing.

	  Andrew
