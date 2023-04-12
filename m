Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4786E01B3
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDLWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDLWK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:10:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C55FCF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MEwLvGlMc7gzRbiCu5rQry3t+CRh0hDHLQ1Vbcj3/hI=; b=gef2dq8AskoYeOi6X2+0qTE93D
        W4IuLcslQq28P4SbbF4iEtOvgC0hz5st9DAiS9/skawpGla9kz+BpTAlEV0Jwb+TxHaEr7ByGOVb/
        T7w/YVvfzwpV8DQMqOXalJ32C22pnffKXoUSYUWseUTZ/zsjNQNfP70fhY3lPg7mYHVg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmig3-00A8Ru-9B; Thu, 13 Apr 2023 00:10:55 +0200
Date:   Thu, 13 Apr 2023 00:10:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ron Eggler <ron.eggler@mistywest.com>
Cc:     netdev@vger.kernel.org
Subject: Re: issues to bring up two VSC8531 PHYs
Message-ID: <d40e69bc-d020-4aa0-be1a-b78bb11fe68c@lunn.ch>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 01:11:45PM -0700, Ron Eggler wrote:
> Hi,
> I am trying to bring up a pair of VSC9531 PHYs on an embedded system. I'm using a Yocto build and have altered the device tree with the following patch:
> https://github.com/MistySOM/meta-mistysom/blob/phy-enable/recipes-kernel/linux/smarc-rzg2l/0001-add-vsc8531-userspace-dts.patch

+        phy0: ethernet-phy@7 {
+                compatible = "ethernet-phy-ieee802.3-c45";
+                reg = <0>;

There is a minor DT issue here. I assume the PHY is on address 0 of
the bus? Then ethernet-phy@7 should be ethernet-phy@0. This is pretty
much cosmetic, but when you come to submit the board for inclusion in
mainline, you need to have this correct.

> I installed mdio-tools and can see the interfaces like:
> # mdio
> 11c20000.ethernet-ffffffff
> 11c30000.ethernet-ffffffff
> 
> Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
> # mdio 11c20000.ethernet-ffffffff
>  DEV      PHY-ID  LINK
> 0x00  0x00070572  up

So that matches with:

/linux/drivers/net/phy$ grep -r 000705 *
mscc/mscc.h:#define PHY_ID_VSC8531			  0x00070570

Take a look in sys/bus/mdio_bus/devices/ Any sign of the two PHYs?
 
> Yet, ifconfig doesn't show the interfaces and I get:
> # ifconfig eth0 up
> [  140.542939] ravb 11c20000.ethernet eth0: failed to connect PHY

So this is where you need to start debugging. Why cannot it find the
PHY?

Your DT patch does not show a phy-handle. Is there one inherited from
a .dtsi files? Is phy-mode also set?

    Andrew
