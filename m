Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530923EAA94
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhHLTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231898AbhHLTFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 15:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1E46108C;
        Thu, 12 Aug 2021 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628795083;
        bh=GuoG+i5K7HpqjB1DN0ZMJ6zj/UHGpaEvUeb8Lc7N6kY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbx2Qz6GvNhHcko4mq2FvjofxJhBk+C5N+Hc0uOOPdkOKx0GezKSSS9Lcamd+/IIl
         3zB+g7zJnt3/ndFity5i49Rrbz8EJ72Mq31Nh2Y0+lgNvzBlL5lv2wJIDR6/9LREsr
         udFUO46aX8YSVH5dPJvITkzx/7Buvl8qBHwYhOOaYiGUISZvc8a4RuABSQj1wze/4O
         eYQ/CHuafZfeh3jOeHlQHnisKl2fqv50HDFoZ/DllX6chCqUf3BpNbkb3y5KgojX2B
         pLgKqMdDKCk1EdNsi5CR/fMaxzWGv4rizhpZZzJvQjFpBPDvf3zfJqDx7CevohBd6R
         7ebVeELk0YHzA==
Received: by pali.im (Postfix)
        id C50107B9; Thu, 12 Aug 2021 21:04:40 +0200 (CEST)
Date:   Thu, 12 Aug 2021 21:04:40 +0200
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
Message-ID: <20210812190440.fknfthdk3mazm6px@pali>
References: <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
 <20210812182645.GA10725@pc-23.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812182645.GA10725@pc-23.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 12 August 2021 20:26:45 Guillaume Nault wrote:
> On Thu, Aug 12, 2021 at 03:48:45PM +0200, Pali Rohár wrote:
> > On Thursday 12 August 2021 11:28:47 Guillaume Nault wrote:
> > > On Wed, Aug 11, 2021 at 08:04:01PM +0200, Pali Rohár wrote:
> > > > ifname is not atomic (first it creates ppp<id> interface and later it is
> > > > renamed) and have issues. Due to bug described here:
> > > > https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/
> > > > you may get your kernel into state in which it is not possible to create
> > > > a new ppp interface. And this issue does not happen when using "unit"
> > > > argument.
> > > 
> > > This is specific to the ioctl api. Netlink doesn't have this problem.
> > 
> > netlink does not have problem with implementing ifname option
> > atomically. That is why I started looking at netlink how to avoid
> > problems with renaming. As on some systems I see that some udev rules or
> > NetworkManager tries to query newly created interfaces, but based on
> > name (not id). So early renaming cause issues to these tools...
> > 
> > But netlink is affected by above bug when "ifname" is not specified.
> 
> As disscussed in another part of the thread, let's fix that with a new
> netlink attribute.

+1

> > > > To fix above issue it is needed to migrate pppd from ioctl API to rtnl.
> > > 
> > > It would have helped a lot if you had explained that before.
> > > 
> > > > But this would be possible only after rtnl API starts providing all
> > > > features, including specifying custom "unit" argument...
> > > 
> > > You can already simulate the "unit" option by setting the interface
> > > name as "ppp${unit}" and retrieving the kernel assigned id with
> > > ioctl(PPPIOCGUNIT). What's wrong with that?
> > 
> > This is possible to implement. But then unit part from "ppp${unit}"
> > would not match PPPIOCGUNIT number - like it is currently. And it is
> > something which applications expect. Basically there is no difference
> > between ppp interface created by ioctl and ppp interface created by
> > rtnl. You can use other rtnl commands on ppp interface created by ioctl
> > and also you can use other ppp ioctls on ppp interface created by rtnl.
> 
> But the application knows if it created the ppp device with a specified
> unit id or not. So it knows if an ioctl(PPPIOCGUNIT) call is necessary
> to get the unit id. And if we allow the interface name to be unrelated
> to the unit id, the application will also know that, because it
> explicitely requested it.
> 
> > But I understand your arguments. You are looking at ppp unit id as some
> > internal kernel number; which should probably stay in kernel.
> 
> Well, it has to be exported, but it should be opaque to user space
> (appart from the ioctl() api which is established behaviour).
> 
> > My point of view is that this is legacy identifier bound to the every
> > ppp network interface, and which is exported to userspace. And because
> > there is API for userspace how userspace can force particular id for
> > particular ppp interface, it means that userspace have full control how
> > these ids are generated. Even it is "internal" kernel number. And it
> > does not matter how are ppp interfaces created, via which method. It is
> > bounded to every ppp interface independently how ppp was created.
> > 
> > By this design, userspace application may choose to create mapping
> > between /dev/ttyUSB<N> and ppp unit <id> by having <N> == <id>.
> > 
> > This ppp unit id is used for some operations, so it is required to know
> > it. And if application is doing e.g. above assumption (it does not use
> > PPPIOCGUNIT, but derive ppp unit id from /dev/ttyUSB* name) which
> > current ioctl API allows, then this application cannot be migrated from
> > ioctl to rtnl API without rewriting code which uses above assumption.
> 
> Migrating such application requires writing the netlink code for the new
> api. How could a simple ioctl(PPPIOCGUNIT) call prevent such migration?
> BTW, using PPPIOCGUNIT is much cleaner an more robust that parsing the
> device name, so it's a win in any case. And the application is still
> able to name the ppp interface ppp<N> to keep things simple for its
> users.

You are right and I agree with you that application with PPPIOCGUNIT is
more robust.

The point here is that there is application (pppd) which allows
specifying custom unit id as an option argument. Also it allows to call
external applications (at some events) with sharing file descriptors.
And it is one of the options how to touch part of ppp connection via
external scripts / applications. You start pppd for /dev/ttyUSB<N> with
unit id <N> and then in external script you use <N> for ioctls. And I do
not know if there is a way how to retrieve unit id in those external
scripts. There was already discussion about marking all file descriptors
in pppd as close-on-exec and it was somehow rejected as it will broke
custom scripts / applications which pppd invokes on events. So looks
like that people are using these "features" of pppd.

Option "unit" in pppd specifies ppp unit id. And if new API (rtnl) would
not provide equivalent for allowing to specify it then migrating pppd
from ioctl to rtnl is not possible without breaking compatibility.

As you already described, we can simulate setting default interface name
in pppd application. But above usage or any other which expose pppd API
to other application is not possible to simulate.


So I think we need to first decide or solve issue if rtnl ppp API should
provide same functionality as ioctl ppp API. If answer is yes, then some
kind of specifying custom ppp unit id is required. If answer is no (e.g.
because we do not want ppp unit id in rtnl API as it looks legacy and
has issues) then rtnl ppp API cannot be used by ppp as it cannot provide
all existing / supported features without breaking legacy compatibility.

I see pros & cons for both answers. Not supporting legacy code paths in
new code/API is the way how to clean up code and prevent repeating old
historic issues. But if new code/API is not fully suitable for pppd --
which is de-facto standard Linux userspace implementation -- does it
make sense to have it? Or does it mean to also implement new userspace
part of implementation (e.g. pppd2) to avoid these legacy / historic
issues? Or... is not whole ppp protocol just legacy part of our history
which should not be used in new modern setups? And for "legacy usage" is
current implementation enough and it does not make sense to invest time
into this area? I cannot answer to these questions, but I think it is
something quite important as it can show what should be direction and
future of ppp subsystem.

> > I'm not saying if this is a good or bad idea, just I'm describing what
> > ioctl API allows and what does not. (And yes, in my opinion it is a bad
> > idea, but ppp is designed to allow it).
> > 
> > If I was designing ppp again, I would have probably used interface id as
> > ppp unit id...
> 
> With all the building blocks we have now in the Linux kernel, there's
> much more that I'd change. But the landscape and constraints were
> obviously very different at the time.
> 
> > > > I hit above problem, so now I'm migrating all pppd setups from "ifname"
> > > > to "unit" option.
> > > 
> > > Why did you write 3125f26c51482 ("ppp: Fix generating ppp unit id when
> > > ifname is not specified") then?
> > 
> > Well, I hope that this kernel fix propagates into kernels used on
> > affected machines. But it will take some time. And until it happens this
> > migration is needed. Lets say it is workaround for unspecific time
> > period.
> 
> Makes sense.
> 
