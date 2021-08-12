Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2923EA5FC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbhHLNtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 09:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237645AbhHLNtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 09:49:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D56560FD7;
        Thu, 12 Aug 2021 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628776128;
        bh=Y1Z2FcBBYqhkDxFsk+J9v9xsRDAKjg5jcGowz/VTiNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YQQaisKJiqy/+gtLbrR03XVr0ytqVzMlUsQjW/47lGCtCC971D3jcQmtATBTuKexT
         kuz9t4l1wHMNZH2HHOWBNUTLH5n9fAwPve77C0wTtwWI/fnM47PHxE2vmiofSAfmUZ
         hIwkYFooJ59G/xTTq+XXlvEYcz0C7TIRhugRkMgKpDCUVRxGMIlQFSCXik8+J+86Ct
         e+h1IBJagLvpxSvaw+sUNFpzJBNAfpEbV2toMW64ktxfU/hNHtSO0M5vZHzc8wLgoM
         a5qir4uf6jZJh3IJt32tqImHqVNVFMdEsTkAPlmTWbx1eFzISghcGeXY0hcjgTkFgd
         i+cctsQXfBZAw==
Received: by pali.im (Postfix)
        id 7BCDC72F; Thu, 12 Aug 2021 15:48:45 +0200 (CEST)
Date:   Thu, 12 Aug 2021 15:48:45 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210812134845.npj3m3vzkrmhx6uy@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812092847.GB3525@pc-23.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 12 August 2021 11:28:47 Guillaume Nault wrote:
> On Wed, Aug 11, 2021 at 08:04:01PM +0200, Pali Rohár wrote:
> > On Wednesday 11 August 2021 19:38:11 Guillaume Nault wrote:
> > > On Tue, Aug 10, 2021 at 02:11:11PM -0400, James Carlson wrote:
> > > > On 8/10/21 1:16 PM, Pali Rohár wrote:
> > > > > On Tuesday 10 August 2021 16:38:32 Chris Fowler wrote:
> > > > > > Isn't the UNIT ID the interface number?  As in 'unit 100' will give me ppp100?
> > > > > 
> > > > > If you do not specify pppd 'ifname' argument then pppd argument 'unit 100'
> > > > > will cause that interface name would be ppp100.
> > > > > 
> > > > > But you are free to rename interface to any string which you like, even
> > > > > to "ppp99".
> > > > > 
> > > > > But this ppp unit id is not interface number. Interface number is
> > > > > another number which has nothing with ppp unit id and is assigned to
> > > > > every network interface (even loopback). You can see them as the first
> > > > > number in 'ip -o l' output. Or you can retrieve it via if_nametoindex()
> > > > > function in C.
> > > > 
> > > > Correct; completely unrelated to the notion of "interface index."
> > > > 
> > > > > ... So if people are really using pppd's 'unit' argument then I think it
> > > > > really make sense to support it also in new rtnl interface.
> > > > 
> > > > The pppd source base is old.  It dates to the mid-80's.  So it predates not
> > > > just rename-able interfaces in Linux but Linux itself.
> > > > 
> > > > I recall supported platforms in the past (BSD-derived) that didn't support
> > > > allowing the user to specify the unit number.  In general, on those
> > > > platforms, the option was accepted and just ignored, and there were either
> > > > release notes or man page updates (on that platform) that indicated that
> > > > "unit N" wouldn't work there.
> > > > 
> > > > Are there users on Linux who make use of the "unit" option and who would
> > > > mourn its loss?  Nobody really knows.  It's an ancient feature that was
> > > > originally intended to deal with systems that couldn't rename interfaces
> > > > (where one had to make sure that the actual interface selected matched up
> > > > with pre-configured filtering rules or static routes or the like), and to
> > > > make life nice for administrators (e.g., making sure that serial port 1 maps
> > > > to ppp1, port 2 is ppp2, and so on).
> > > > 
> > > > I would think and hope most users reach for the more-flexible "ifname"
> > > > option first, but I certainly can't guarantee it.  It could be buried in a
> > > > script somewhere or (god forbid) some kind of GUI or "usability" tool.
> > > > 
> > > > If I were back at Sun, I'd probably call it suitable only for a "Major"
> > > > release, as it removes a publicly documented feature.  But I don't know what
> > > > the considerations are here.  Maybe it's just a "don't really care."
> > > 
> > > I'm pretty sure someone, somewhere, would hate us if we broke the
> > > "unit" option. The old PPP ioctl API has been there for so long,
> > > there certainly remains tons of old tools, scripts and config files
> > > that "just work" without anybody left to debug or upgrade them.
> > > 
> > > We can't just say, "starting from kernel x.y.z the unit option is a
> > > noop, use ifname instead" as affected people surely won't get the
> > > message (and there are other tools beyond pppd that may use this
> > > kernel API).
> > > 
> > > But for the netlink API, we don't have to repeat the same mistake.
> > 
> > ifname is not atomic (first it creates ppp<id> interface and later it is
> > renamed) and have issues. Due to bug described here:
> > https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/
> > you may get your kernel into state in which it is not possible to create
> > a new ppp interface. And this issue does not happen when using "unit"
> > argument.
> 
> This is specific to the ioctl api. Netlink doesn't have this problem.

netlink does not have problem with implementing ifname option
atomically. That is why I started looking at netlink how to avoid
problems with renaming. As on some systems I see that some udev rules or
NetworkManager tries to query newly created interfaces, but based on
name (not id). So early renaming cause issues to these tools...

But netlink is affected by above bug when "ifname" is not specified.

> > To fix above issue it is needed to migrate pppd from ioctl API to rtnl.
> 
> It would have helped a lot if you had explained that before.
> 
> > But this would be possible only after rtnl API starts providing all
> > features, including specifying custom "unit" argument...
> 
> You can already simulate the "unit" option by setting the interface
> name as "ppp${unit}" and retrieving the kernel assigned id with
> ioctl(PPPIOCGUNIT). What's wrong with that?

This is possible to implement. But then unit part from "ppp${unit}"
would not match PPPIOCGUNIT number - like it is currently. And it is
something which applications expect. Basically there is no difference
between ppp interface created by ioctl and ppp interface created by
rtnl. You can use other rtnl commands on ppp interface created by ioctl
and also you can use other ppp ioctls on ppp interface created by rtnl.

But I understand your arguments. You are looking at ppp unit id as some
internal kernel number; which should probably stay in kernel.

My point of view is that this is legacy identifier bound to the every
ppp network interface, and which is exported to userspace. And because
there is API for userspace how userspace can force particular id for
particular ppp interface, it means that userspace have full control how
these ids are generated. Even it is "internal" kernel number. And it
does not matter how are ppp interfaces created, via which method. It is
bounded to every ppp interface independently how ppp was created.

By this design, userspace application may choose to create mapping
between /dev/ttyUSB<N> and ppp unit <id> by having <N> == <id>.

This ppp unit id is used for some operations, so it is required to know
it. And if application is doing e.g. above assumption (it does not use
PPPIOCGUNIT, but derive ppp unit id from /dev/ttyUSB* name) which
current ioctl API allows, then this application cannot be migrated from
ioctl to rtnl API without rewriting code which uses above assumption.

I'm not saying if this is a good or bad idea, just I'm describing what
ioctl API allows and what does not. (And yes, in my opinion it is a bad
idea, but ppp is designed to allow it).

If I was designing ppp again, I would have probably used interface id as
ppp unit id...

> > I hit above problem, so now I'm migrating all pppd setups from "ifname"
> > to "unit" option.
> 
> Why did you write 3125f26c51482 ("ppp: Fix generating ppp unit id when
> ifname is not specified") then?

Well, I hope that this kernel fix propagates into kernels used on
affected machines. But it will take some time. And until it happens this
migration is needed. Lets say it is workaround for unspecific time
period.
