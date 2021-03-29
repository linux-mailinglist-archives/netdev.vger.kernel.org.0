Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5164434D9FB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhC2WOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231358AbhC2WNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8BCA60C3D;
        Mon, 29 Mar 2021 22:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056026;
        bh=pIvJhplpG2d3EF5cSVe/y6AaUP1mMmv3flDur+3XMSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mSzrpaJZG2PkfUzBZsgeoExguvRxOKYrA0pSPUSz1jh3inuEyMcxaKxsrisrv+jnS
         gWOQJAiIKxNV0/VifQiR33oaXkLKSoSXXW0mdDIVvVL4opwmVEkcJ1/xZZG0YsLCL+
         2DTnwJco03BBPewevXNx9mUuCDw9hIalQAifeE9mUCaZB2KUkUf4mraiUgcB4clnrJ
         6rnl0zXFzUGgOsRv06jBCQROiL09N14ExybRprMpfZBJwiI/Pzgg9FezskgFiwC1I6
         RK8XNJQwVWD1PJeXBhFEshBVf90mIBaYfPCGeJ43ld0m/Oxgh9Y6BqWjxwfO/YzknA
         l1HM8UTofqBCg==
Received: by pali.im (Postfix)
        id 4BE72A79; Tue, 30 Mar 2021 00:13:43 +0200 (CEST)
Date:   Tue, 30 Mar 2021 00:13:43 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Andrew Lunn' <andrew@lunn.ch>, 'Jakub Kicinski' <kuba@kernel.org>,
        arndb@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, brandon_chuang@edge-core.com,
        wally_wang@accton.com, aken_liu@edge-core.com, gulv@microsoft.com,
        jolevequ@microsoft.com, xinxliu@microsoft.com,
        'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <20210329221343.ohj7dtaicfvbjlna@pali>
References: <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
 <YEL3ksdKIW7cVRh5@lunn.ch>
 <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
 <YEvILa9FK8qQs5QK@lunn.ch>
 <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
 <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
 <20210320161021.fngdgxvherg4v3lr@pali>
 <011401d7226f$df50aec0$9df20c40$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011401d7226f$df50aec0$9df20c40$@thebollingers.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 26 March 2021 11:43:10 Don Bollinger wrote:
> > Hello Don!
> > 
> > I have read whole discussion and your EEPROM patch proposal. But for me it
> > looks like some kernel glue code for some old legacy / proprietary access
> > method which does not have any usage outside of that old code.
> 
> I don't know if 'kernel glue code' is good or bad.  It is a driver.  It
> locks access to a device so it can perform multiple accesses without
> interference.  It organizes the data on a weird device into a simple linear
> address space that can be accessed with open(), seek(), read() and write()
> calls.
> 
> As for 'old code', this code and variations of it are under active
> development by multiple Network OS vendors and multiple switch vendors, and
> in production on hundreds of thousands of switches with millions of
> SFP/QSFP/CMIS devices.  This stuff is running the biggest clouds in the
> world.
> 
> > 
> > Your code does not contain any quirks which are needed to read different
> > EEPROMs in different SFP modules. As Andrew wrote there are lot of broken
> > SFPs which needs special handling and this logic is already implemented in
> > sfp.c and sfp-bus.c kernel drivers. These drivers then export EEPROM
> > content to userspace via ethtool -m API in unified way and userspace does
> > not implement any quirks (nor does not have to deal with quirks).
> 
> As a technical matter, you handle those quirks in the code that interprets
> EEPROM data.  You have figured out what devices have what quirks, then coded
> up solutions to make them work.  Then, after all the quirk handling is done,
> you call the actual access routines (sfp_i2c_read() and sfp_i2c_write()) to
> access the module EEPROMs.  My code works the same way, except in my
> community all the interpretation of EEPROM data is done in user space.  You
> may not like that, but it is not clear why you should care how my community
> chooses to handle the data.  In this architecture, the only thing needed
> from the kernel is the equivalent of sfp_i2c_read() and sfp_i2c_write, which
> optoe provides.  The key point here is that my community wants the kernel to
> just access the data.  No interpretation, no identification, no special
> cases.
> 
> > 
> > If you try to read EEPROM "incorrectly" then SFP module with its EEPROM
> > chip (or emulation of chip) locks and is fully unusable after you unplug
> it and
> > plug it again. Kernel really should not export API to userspace which can
> > cause "damage" to SFP modules. And currently it does *not* do it.
> 
> In my community, such devices are not tolerated.  Modules which can be
> "damaged" should be thrown away.

Well, those tested / problematic modules are not damaged by real. They
just stop working until you do power off / on cycle and unplug / plug
them again.

But I agree with you. Russel wrote about those SFP modules that they
should have biohazard label :-)

The best would be if those modules disappear, but that would not happen
in near future.

These modules are already used by lot of users and users wanted support
for them. Hence we wrote what was possible.

The main issue is that we do know know any well-behaved GPON SFP module.

GPON is now very common technology for internet access, so it is not
obvious that more people are asking about support for GPON HW compatible
with Linux kernel.

> Please be clear, I am not disagreeing with your implementation.  For your
> GPON devices, you handle this in kernel code.  Cool.  Keep it that way.
> Just don't make my community implement that where it is not needed and not
> wanted.  Optoe just accesses the device.  Other layers handle interpretation
> and quirks.  Your handling is in sfp.c, mine is in user space.  Not right or
> wrong, just different.  Both work.
> 
> > 
> > I have contributed code for some GPON SFP modules, so their EEPROM can
> > be correctly read and exported to userspace via ethtool -m. So I know that
> > this is very fragile area and needs to be properly handled.
> 
> My code is in use in cloud datacenters and campus switches around the world.
> I know it needs to be properly handled.
> 
> > 
> > So I do not see any reason why can be a new optoe method in _current_
> > form useful. It does not implemented required things for handling
> different
> > EEPROM modules.
> 
> optoe would be useful in your current environment as a replacement for
> sfp_i2c_read() and sfp_i2c_write().  Those routines just access the EEPROM.
> They don't identify or interpret or implement quirk handling.  Neither does
> optoe.

Now that we know that there are SFP modules which needs special handling
without it they lock themselves on i2c bus, we really cannot export to
userspace interface which allows this locking.

I understand that you do not care for these broken GPON SFP modules, but
"generic" API which would be part of mainline kernel really cannot have
known issue that can cause some modules to lock by just simple "read"
operation.

> AND, optoe is useful to my community.  An ethtool -m solution could of
> course be implemented, and all of the user space code that currently
> accesses module EEPROM could be rewritten, but there would be no value in
> that to my community.  What they have works just fine.

I understand that your API is useful for you and your existing projects.

> > 
> > I would rather suggest you to use ethtool -m IOCTL API and in case it is
> not
> > suitable for QSFP (e.g. because of paging system) then extend this API.
> 
> optoe already handles QSFP and CMIS just fine.  The API does not need to be
> extended for pages.  Indeed, the ethtool API has already implemented the
> same linear address space to flatten out the two i2c addresses plus pages in
> the various SFP/QSFP/CMIS specs.  optoe flattens the same way.
> 
> > 
> > There were already proposals for using netlink socket interface which is
> > today de-facto standard interface for new code. sysfs API for such thing
> > really looks like some legacy code and nowadays we have better access
> > methods.
> 
> netlink is the de-facto standard interface for kernel networking.  My
> community does not have kernel networking (except for a puny management
> port).  All of the switch networking is handled by the switch ASIC, and in
> user space network management software.  Which is 'better' is complicated,
> depending on the needs and requirements of the application.  A large and
> vibrant community is using a different architecture.  All I am asking for is
> to submit a simple kernel driver that this community has found useful.

I think that this is the main issue here. You are proposing a new API
for kernel networking code without being user of kernel networking
subsystem. Obviously your code is not directly designed for kernel
networking (as you do not use it and do not need it) and that is why
proposed new API looks like it is -- it perfectly fits your usage.

But for those who are using kernel networking code, proposed new API
does not "fit" into existing networking APIs.

Proposing merging a new API, which is going to replace some existing
API, needs very good arguments. Existing API in this case is ethtool -m.
Replacing it by optoe needs to explain in details why ethtool -m API
cannot be extended for a new functionality which is provided by optoe.

Kernel really do not need two APIs for userspace which provides same set
of functionality.

But I think that main issue is here the fact, that you have a lot of
userspace code already in production which is using this proposed kernel
API and you do not have capacity to change existing code in production
to use different kernel API.

Note that having something in production for years and baked by lot of
vendors, does not mean that would be automatically merged into mainline
kernel.

Anyway, kernel has already API for 'network switching in ASIC' with any
other HW offloading (vlan tagging, ...), so it is possible to use kernel
code and kernel drivers to manage big data center switches. IIRC this
DSA switch architecture was developed initially for Marvell switches.

> > 
> > If you want, I can help you with these steps and make patches to be in
> > acceptable state; not written in "legacy" style. As I'm working with GPON
> SFP
> > modules with different EEPROMs in them, I'm really interested in any
> > improvements in their EEPROM area.
> 
> You will find this odd, but I don't actually have any way to test anything
> using the kernel network stack with these devices.  The only hardware I have
> treats SFP/QSFP/CMIS devices as i2c addresses.  There is no concept of these
> being network devices in the linux kernels I'm running.  So, I'll turn your
> offer around...  I can help you improve your EEPROM access code, unless you
> already have all the good stuff.  The things optoe does that
> sfp_i2c_read/write() don't do are:
> 
> Page support:  Check whether pages are supported, then lock the device,
> write the page register as needed, and return it to 0 when finished.
> Check legal access:  Based on page support, and which spec (SFP, QSFP,
> CMIS), figure out if the offset and length are legal.  This is more
> interesting when flattening to a linear address space, less interesting in
> the new API with i2c_addr, page, bank, offset, len all specified.
> Support all 256 architected pages:  There are interesting capabilities that
> vendors provide in spec-approved 'proprietary' pages.  Don't ask, don't
> interpret, don't deny access.  Just execute the requested read/write.
> 
> Don
> 
