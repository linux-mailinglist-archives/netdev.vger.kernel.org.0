Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17D85EDC89
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiI1M2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiI1M2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:28:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02965915E5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=caO/NyWvIB+GVRvWL4Vty1AZuL9FqF+80AH7f4hn/po=; b=lErWb56kbBzPhF3FSuh1BQjkW4
        01td97xiupY7pQqUF1Mw40EbyZnQkf8mQ6iWM4YnL+eBA5ou6FHC/t3mAD28mSiypZnEd+XG7WBBx
        viwuDumYwhZGBg+t4AHAlYt5UlY9OCMNXSbvd/Wf/kwhYQgHMFpD3mSd6azl4RrywfKc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odWAt-000Vfc-OL; Wed, 28 Sep 2022 14:28:27 +0200
Date:   Wed, 28 Sep 2022 14:28:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <YzQ96z73MneBIfvZ@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 01:27:13PM +0200, Michael Walle wrote:
> Hi,
> 
> There are PHYs whose firmware can be updated. Usually, they have
> an internal ROM and you can add patches on top of that, or there
> might be an external flash device which can have a more recent
> firmware version installed which can be programmed in-place
> through the PHY.
> 
> The firmware update for a PHY is usually quite simple, but there
> seems to be no infrastructure in the kernel for that. There is the
> ETHTOOL_FLASHDEV ioctl for upgrading the firmware of a NIC it seems.
> Other than that I haven't found anything. And before going in a wrong
> directions I'd like to hear your thoughts on how to do it. I.e. how
> should the interface to the userspace look like.
> 
> Also I think the PHY should be taken offline, similar to the cable
> test.

I've seen a few different ways of doing this.

One is to load the firmware from disk every boot using
request_firmware(). Then parse the header, determine if it is newer
than what the PHY is already using, and if so, upgrade the PHY. If you
do this during probe, it should be transparent, no user interaction
required.

I've also seen the FLASH made available as just another mtd
device. User space can then write to it, and then do a {cold} boot.

devlink has become the standard way for upgrading firmware on complex
network devices, like NICs and TOR switches. That is probably a good
solution here. The problem is, what devlink instance to use. Only a
few MAC drivers are using devlink, so it is unlikely the MAC driver
the PHY is attached to has a devlink instance. Do we create a devlink
instance for the PHY?

You might want to talk to Jiri about this.

The other issue is actually getting the firmware. Many manufactures
seem reluctant to allow redistribution as required by linux-firmware.
There is no point adding firmware upgrade if you cannot redistribute
the firmware.

    Andrew
