Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304C43B7921
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhF2UOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 16:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233442AbhF2UOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 16:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E2D61DB4;
        Tue, 29 Jun 2021 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624997530;
        bh=vJgx/Kpv/YPBYCZC4gZ7o9RvzZA7eqvFwhgainiaJII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=quX9F6Cy0KUe6OHItPkuiB6Jq0zW/xrLy7ZO4G0bDODqK2Of9n1NpB5D2fOswAaY3
         H95lhx564wKkjxYddGK9f+ZKNscM9qmHX5T5hA+aqe6Q4igsnebZHpHg1pffUXvRbV
         WJSU1N9hhpiMvOa4aljYMjwtVIzvneZ5cDXtOoNnyw56V/hdEohHnyyGoAtM1+D+Uu
         UnCxewVG7RIxlvt0FeBHkbAb8A+wK7yd5E5Y1mtN7zwM5Yijb+nUrr6BTMmTlNmo4D
         IXzXvyBZZfJZPf3+XTipJ6C/+1XiehWzGDyzZOxqGlBv2fXMqJ4cjDYhZNJlOGem03
         Zf4mjKOWykYnw==
Received: by pali.im (Postfix)
        id EDB31AA8; Tue, 29 Jun 2021 22:12:07 +0200 (CEST)
Date:   Tue, 29 Jun 2021 22:12:07 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, vadimp@nvidia.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <20210629201207.fvsa6iq3b7hwe7r5@pali>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
 <YNhT6aAFUwOF8qrL@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNhT6aAFUwOF8qrL@shredder>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 27 June 2021 13:33:13 Ido Schimmel wrote:
> On Thu, Jun 24, 2021 at 10:27:13PM +0200, Andrew Lunn wrote:
> > We have the choice here. We can add a write method to the kAPI, add
> > open source code to Ethtool using that API, and just accept people are
> > going to abuse the API for all sorts of horrible things in user space.
> > Or we can add more restrictive kAPIs, put more code in the kernel, and
> > probably limit user space doing horrible things. Maybe as a side
> > effect, SFP vendors contribute some open source code, rather than
> > binary blobs?
> 
> I didn't see any code or binary blobs from SFP vendors and I'm not sure
> how they can provide these either. Their goal is - I believe - to sell
> as much modules as possible to what the standard calls "systems
> manufactures" / "system integrators". Therefore, they cannot make any
> assumptions about the I2C connectivity (whether to the ASIC or the CPU),
> the operating system running on the host and the user interface (ioctl /
> netlink etc).

Hello! This is really happening in GPON world. Most GPON SFP modules are
working only in few devices with SFP cages. And it is either because
GPON SFP module vendor provided to vendor of device with SFP cage how to
"hack", initialize and use that GPON module properly or because we have
figured out how particular GPON modules violate SFF standards and added
special quirks per SFP module or per chipset in SFP module.

And the other thing which is happening. If vendor of GPON SFP module is
the same as vendor of device with SFP cage then it is doing everything
to ensure that only its GPON SFP modules would work in its devices. Or
to ensure that its OLT station (opposite end of GPON client SFP module)
would link only with its branded GPON SFP modules.

Classic vendor lockin. If ISP is using OLT station from vendor A then A
wants that you cannot use GPON SFP modules from vendor B on that
network.

You said that vendor goal is to sell as much modules as possible. Seem
that this is truth and vendors are doing it by above vendor lockin
strategy only.


So at the end I really do not like raw RW access to SFP EEPROM. This
just opens a new door for vendor lockin and vendor blob strategy.

And the last thing is that rewriting EEPROM on arbitrary SFP module may
lead to total damage of SFP. Specially on SFPs with "computer inside"
where parts of (critical) memory is shadowed in SFP EEPROM space.
