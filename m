Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6D342E33
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 17:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCTQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 12:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCTQKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 12:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E51B6192A;
        Sat, 20 Mar 2021 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616256624;
        bh=vD0Wdp9YFjUQBL1Ai7L0O0WXGozIvL/TI0S31jBOuXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0rrf8vGYYZVxc9OLAT109w5DQxSkBsMlsTgxY5rQw3sjjVZe747+dhIkzEx6FVDw
         RHGu7tzh4ZtAwT3w3lH1rEM3PhiuIUHlYreji8ljcpO1XMxU9JkkPvmXPxKumTE8jK
         EAxSJIJuym/+tLjbj3+BSkTmdRzAt5sl4s70cbHUxO6fM/pHBaKLJgkSia7cp46CSM
         bg3YmVHFE1HSur37iBKG46D4qylR3XJ4GsvyHe/6Hjd7Mk37mUJBOLaaqXJecJIWQC
         m0OnsyvHzAyk9++6W9McFTvnJpsyyjKy1DMw0/WHyKMAuBafgK/Z3q3odDbib6+cT/
         qCm2wW+ZuJzcQ==
Received: by pali.im (Postfix)
        id D9E9A88D; Sat, 20 Mar 2021 17:10:21 +0100 (CET)
Date:   Sat, 20 Mar 2021 17:10:21 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Don Bollinger <don@thebollingers.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, 'Jakub Kicinski' <kuba@kernel.org>,
        arndb@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, brandon_chuang@edge-core.com,
        wally_wang@accton.com, aken_liu@edge-core.com, gulv@microsoft.com,
        jolevequ@microsoft.com, xinxliu@microsoft.com,
        'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <20210320161021.fngdgxvherg4v3lr@pali>
References: <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
 <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
 <YEL3ksdKIW7cVRh5@lunn.ch>
 <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
 <YEvILa9FK8qQs5QK@lunn.ch>
 <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
 <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFJHN+raumcJ5/7M@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Don!

I have read whole discussion and your EEPROM patch proposal. But for me
it looks like some kernel glue code for some old legacy / proprietary
access method which does not have any usage outside of that old code.

Your code does not contain any quirks which are needed to read different
EEPROMs in different SFP modules. As Andrew wrote there are lot of
broken SFPs which needs special handling and this logic is already
implemented in sfp.c and sfp-bus.c kernel drivers. These drivers then
export EEPROM content to userspace via ethtool -m API in unified way and
userspace does not implement any quirks (nor does not have to deal with
quirks).

If you try to read EEPROM "incorrectly" then SFP module with its EEPROM
chip (or emulation of chip) locks and is fully unusable after you unplug
it and plug it again. Kernel really should not export API to userspace
which can cause "damage" to SFP modules. And currently it does *not* do
it.

I have contributed code for some GPON SFP modules, so their EEPROM can
be correctly read and exported to userspace via ethtool -m. So I know
that this is very fragile area and needs to be properly handled.

So I do not see any reason why can be a new optoe method in _current_
form useful. It does not implemented required things for handling
different EEPROM modules.

I would rather suggest you to use ethtool -m IOCTL API and in case it is
not suitable for QSFP (e.g. because of paging system) then extend this
API.

There were already proposals for using netlink socket interface which is
today de-facto standard interface for new code. sysfs API for such thing
really looks like some legacy code and nowadays we have better access
methods.

If you want, I can help you with these steps and make patches to be in
acceptable state; not written in "legacy" style. As I'm working with
GPON SFP modules with different EEPROMs in them, I'm really interested
in any improvements in their EEPROM area.
