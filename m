Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2088339F9D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFHMOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:14:35 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:46199 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfFHMOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:14:34 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jun 2019 08:14:33 EDT
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.91)
        (envelope-from <daniel@makrotopia.org>)
        id 1hZZtO-0007F8-Sa; Sat, 08 Jun 2019 13:52:15 +0200
Date:   Sat, 8 Jun 2019 13:51:59 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>,
        netdev@vger.kernel.org, Vitaly Chekryzhev <13hakta@gmail.com>
Subject: Re: [OpenWrt-Devel] Using ethtool or swconfig to change link
 settings for mt7620a?
Message-ID: <20190608115159.GA1559@makrotopia.org>
References: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Sat, Jun 08, 2019 at 04:06:54AM -0500, Daniel Santos wrote:
> Hello,
> 
> I need to change auto-negotiate, speed and duplex for a port on my
> mt7620a-based device, but I'm not quite certain that I understand the
> structure here.  When using ethtool on eth0 I always get ENODEV,
> apparently because priv->phy_dev is always NULL in fe_get_link_ksettings
> of drivers/net/ethernet/mtk/ethtool.c.  But I'm being told that eth0 is
> only an internal device between the µC and the switch hardware, so it
> isn't even the one I need to change.

That's correct.

> If this is true, then it looks like I will need to implement a
> get_port_link function for struct switch_dev_ops?  Can anybody confirm
> this to be the case?  Also, are there any examples aside from the
> Broadcom drivers?  I have the mt7620 programmer's guide and it specifies
> the registers I need to change.

Currently MT7620 still uses our legacy swconfig switch driver, which
also doesn't support setting autoneg, speed and duplex. However, rather
than implementing it there, it'd be great to add support for the FE-
version of the MT7530 swtich found in the MT7620(A/N) WiSoC to the now
upstream DSA driver[1]. While this driver was originally intended for
use with standalone MT7530 GE switch chip or the ARM-based MT7623 SoC,
the same switch fabric is also implemented in MT7621 and support for
that chip was added to the driver recently[2]. MT7620 basically also
features the same switch internally, however, it comes with only one
CPU port, supports only FastEthernet and lacks some of the management
counters.

Assuming your MT7620 datasheet includes the decription of the MT7530
switch registers, it'd be great if you can help working on supporting
MT7620 in the DSA driver as well -- gaining per-port ethtool support
as a reward :)


Cheers


Daniel


[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/mt7530.c
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ddda1ac116c852bb969541ed53cffef7255c4961
