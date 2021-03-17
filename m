Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E5A33F7FE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhCQSQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:16:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhCQSPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:15:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMahT-00BVJR-Ql; Wed, 17 Mar 2021 19:15:19 +0100
Date:   Wed, 17 Mar 2021 19:15:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, arndb@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brandon_chuang@edge-core.com, wally_wang@accton.com,
        aken_liu@edge-core.com, gulv@microsoft.com, jolevequ@microsoft.com,
        xinxliu@microsoft.com, 'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YFJHN+raumcJ5/7M@lunn.ch>
References: <YD1ScQ+w8+1H//Y+@lunn.ch>
 <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
 <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
 <YEL3ksdKIW7cVRh5@lunn.ch>
 <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
 <YEvILa9FK8qQs5QK@lunn.ch>
 <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
 <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201d719c6$6ac826c0$40587440$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have offered, in every response, to collaborate with the simple
> integration to use optoe as the default upstream driver to access the module
> EEPROMs.  optoe would be superior to the existing default routines in sfp.c

Actually, i'm not sure they would be. Since the KAPI issues are pretty
much a NACK on their own, i didn't bother raising other issues. Both
Russell King and I has issues with quirks and hotplug.

Our experience is that a number of SFPs are broken, they don't follow
the standard. Some you cannot perform more than 16 bytes reads without
them locking up. Others will perform a 16 byte read, but only give you
one useful byte of data. So you have to read enough of the EEPROM a
byte at a time to get the vendor and product strings in order to
determine what quirks need to be applied. optoe has nothing like
this. Either you don't care and only support well behaved SFPs, or you
have the quirk handling in user space, in the various vendor code
blobs, repeated again and again. To make optoe generically usable, you
are going to have to push the quirk handling into optoe. The
brokenness should be hidden from userspace.

And then you repeat all the quirk handling sfp.c has. That does not
scale, we don't want the same quirks in two different places. However,
because SFPs are hot pluggable, you need to re-evaluate the quirks
whenever there is a hot-plug event. optoe has no idea if there has
been a hotplug event, since it does not have access to the GPIOs. Your
user space vendor code might know, it has access to the GPIOs. So
maybe you could add an IOCTL call or something, to let optoe know the
module has changed and it needs to update its quirks. Or for every
user space read, you actually re-read the vendor IDs and refresh the
quirks before performing the read the user actually wants. That all
seems ugly and is missing from the current patch.

I fully agree with Jakub NACK.

  Andrew


