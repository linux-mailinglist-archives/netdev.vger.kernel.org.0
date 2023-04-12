Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2B36E01C2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjDLWU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDLWUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:20:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1668683F7
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=VBKUsK5PWu/o8/3+bclgIEKW6XxFEzMPUWzq5XqxaDg=; b=vy
        TWUoJ5wAS8USZo8xtXW8NkHzE+F+W4O9e4Z0hDpGVlxdyobY3aq470gpiMgXgIXdSXCwTRQHqunCh
        ZMQS8uuwu0QGawA77j1VPSv61tNAaWLj22azalPoFdXZxssmaBnjV7sWEf/UulnWHLuuCLeKDDifG
        Ls/24R3j2bj2wv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmipO-00A8U0-4i; Thu, 13 Apr 2023 00:20:34 +0200
Date:   Thu, 13 Apr 2023 00:20:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Ron Eggler <ron.eggler@mistywest.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: issues to bring up two VSC8531 PHYs
Message-ID: <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
> > # mdio 11c20000.ethernet-ffffffff
> >  DEV      PHY-ID  LINK
> > 0x00  0x00070572  up
> > 
> AFAICS there's no PHY driver yet for this model. The generic driver may or may not work.
> Best add a PHY driver.

Hi Heiner

mscc.h:#define PHY_ID_VSC8531			  0x00070570

mscc_main.c:
        .phy_id         = PHY_ID_VSC8531,
        .name           = "Microsemi VSC8531",
        .phy_id_mask    = 0xfffffff0,
        /* PHY_GBIT_FEATURES */
 
> Any specific reason why you set the compatible to
> ethernet-phy-ieee802.3-c45 for a c22 PHY?

Ah, i missed that! The driver only uses phy_read/phy_write, not
phy_write_mmd() and phy_read_mmd().

Remove the compatible string. It is not needed for C22 PHYs.

       Andrew
