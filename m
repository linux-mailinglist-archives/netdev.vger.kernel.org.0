Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F9761E4B4
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 18:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKFROr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 12:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiKFROd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 12:14:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24143A6
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 09:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=CYOp9TEjZPt2SFKYzNCxTI5mAGHUZfD3p7qRbjGGKAg=; b=oR
        Je1gopPlzhWnARY7Bp+5/sv6ZzCI96uvUT5vN43Bb40qgKpB2LBECE3+LfPTyz/558w8HlkD55FR8
        VFglgDJw0nEaoe8m7zhdPOQTnG/kU4WpG5l3ju68uCpQ6e6uOH+81LUKqoM4AuD2NVWBInZTDkuZO
        7K/UDCfuxiaR6vE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1orj7s-001cDX-Cd; Sun, 06 Nov 2022 18:08:04 +0100
Date:   Sun, 6 Nov 2022 18:08:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     piergiorgio.beruto@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Message-ID: <Y2fp9Eqe9icT/7DE@lunn.ch>
References: <026701d8f13d$ef0c2800$cd247800$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <026701d8f13d$ef0c2800$cd247800$@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Based on my personal experience, It looks to me that extending
> ethtool is the way to go. Maybe we should consider those as
> “tunables”?

I suggest you define new ethtool netlink messages. I don't think PHY
tunables would make a good interface, since you have multiple values
which need configuring, and you also have some status information.

So you probably want a message to set the configuration, and another
to get the current configuration. For the set, you probably want an
attribute per configuration value, and allow a subset of attributes to
be included in the message. The get configuration should by default
return all the attributes, but not enforce this, since some vendor
will implement it wrong and miss something out.

The get status message should return the PST value. This is something
you might also want to append to the linkstate message, next to the
SQI values.

What i don't see in the Open Alliance spec is anything about
interrupts. It would be interesting to see if any vendor triggers an
interrupt when PST changes. A PHY which has this should probably send
a linkstate message to userspace reporting the state change. For PHYs
without interrupts, phylib will poll the read_status method once per
second. You probably want to check the PST bit during that poll. If EN
is true, but PST is false, is the link considered down?

I would also include a check in the phylib core. If the set request
tries to set EN to true, check the current link mode and if it is not
half duplex return -EINVAL. An extack messages would be good here as
well.

For the interface between phylib and the PHY driver, you should
probably add to the struct phy_driver a set configuration method, a
get configuration method, and maybe a get status method. You can
provide implementations for these methods in phy-c45.c which any PHY
driver which conforms to the standard can use.

    Andrew
