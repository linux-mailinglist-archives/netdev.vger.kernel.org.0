Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EA62E7B79
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgL3RHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgL3RHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:07:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 022D222242;
        Wed, 30 Dec 2020 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609348015;
        bh=tyoeefI2H36h9myHMJQh3g5oBVScyqy7VITngcTYzt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oj/XrdWi50i/QP1Z3kTQzqOLfDNk5waDwBPlB09ObwO3xUuN7BTpvinOLY5BGOS4Q
         hfJzSsrfHDqQNGP7nmDT0hJjsfoapvyIbDHGs3HiJ1MU4SSkEov5zKnFKiQ+s60Bxz
         8CAMs2aQDcmE8kVihFP7ihqwwWhSOmndGVFCW+8hFJhGtVkg/o2Mrpcq4ktZamwxhs
         Lk2aN4GTg9P7jX3XVEJM5xgsT1RBLQA28DP0F3LRgDZ6OoOa9wcHchkPkx3L8+lY4w
         X3wNjLzh4S8N8Q2bb4MaAZSB8Hd63Bf4HsTHHELTVIvO9IFoaMNe8Kb4scg1UP2drH
         Isfa1w2VfyTTA==
Received: by pali.im (Postfix)
        id E291A9F8; Wed, 30 Dec 2020 18:06:52 +0100 (CET)
Date:   Wed, 30 Dec 2020 18:06:52 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: sfp: allow to use also SFP modules which are
 detected as SFF
Message-ID: <20201230170652.of3m226tidtunslm@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-3-pali@kernel.org>
 <20201230161151.GS1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230161151.GS1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 16:11:51 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 04:47:53PM +0100, Pali Rohár wrote:
> > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set SFF phys_id
> > in their EEPROM. Kernel SFP subsystem currently does not allow to use
> > modules detected as SFF.
> > 
> > This change extends check for SFP modules so also those with SFF phys_id
> > are allowed. With this change also GPON SFP module Ubiquiti U-Fiber Instant
> > is recognized.
> 
> I really don't want to do this for every single module out there.
> It's likely that Ubiquiti do this crap as a vendor lock-in measure.
> Let's make it specific to Ubiquiti modules _only_ until such time
> that we know better.

Ok. This module_supported() function is called in sfp_sm_mod_probe()
function. Current code is:

	/* Check whether we support this module */
	if (!sfp->type->module_supported(&id)) {
		dev_err(sfp->dev,
			"module is not supported - phys id 0x%02x 0x%02x\n",
			sfp->id.base.phys_id, sfp->id.base.phys_ext_id);
		return -EINVAL;
	}

Do you want to change code to something like this?

	/* Check whether we support this module */
	if (!sfp->type->module_supported(&id) &&
	    (memcmp(id.base.vendor_name, "UBNT            ", 16) ||
	     memcmp(id.base.vendor_pn, "UF-INSTANT      ", 16)))
		dev_err(sfp->dev,
			"module is not supported - phys id 0x%02x 0x%02x\n",
			sfp->id.base.phys_id, sfp->id.base.phys_ext_id);
		return -EINVAL;
	}

Or do you have a better idea how to skip that module_supported check for
this UBNT SFP?
