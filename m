Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820033E971A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhHKRzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhHKRzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 13:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737686104F;
        Wed, 11 Aug 2021 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628704492;
        bh=adqAfFr5cwHzD3SzTDPHfxQw9t4Aa0NDSBYToUt4zMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PE05bnber9ANzF/IxHh2YHTEVansP5JavcYg1U0iQUpZFabCLfuYrV78H2SkVT8NQ
         aZWScv+Yp+CpUO/08GvJ8C0NAyjTfoi1PS5McN5hr+76Pc3q7opNO+0e2D3zLy5Ul5
         MreUVCfpo1zSSi90r3kxgsBQYd2+Moe7o6ei+cX0uHnjwSjZ8y7g8zV9IM/JV0N5U1
         kkVXSy1cJ3ziC3K6mDTn7/i1r5u3B7PARMwA7GRIe0W7GX41Afx/jVMgpTGLSUoqzO
         ofTeia0rvfLY7RxUkP8/sbAp75XBCc9TtAyTeivFCNq0O6FElHmqwvNk7xrsoSKGE/
         zkybhiIzceaEQ==
Received: by pali.im (Postfix)
        id EE1EA7AE; Wed, 11 Aug 2021 19:54:49 +0200 (CEST)
Date:   Wed, 11 Aug 2021 19:54:49 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210811175449.5hrwoevw7xv2jxxn@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <20210810160450.eluiktsp7oentxo3@pali>
 <20210811171918.GD15488@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210811171918.GD15488@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 11 August 2021 19:19:18 Guillaume Nault wrote:
> On Tue, Aug 10, 2021 at 06:04:50PM +0200, Pali Rohár wrote:
> > On Tuesday 10 August 2021 17:39:41 Guillaume Nault wrote:
> > > On Mon, Aug 09, 2021 at 09:31:09PM +0200, Pali Rohár wrote:
> > > > Better to wait. I would like hear some comments / review on this patch
> > > > if this is the correct approach as it adds a new API/ABI for userspace.
> > > 
> > > Personally I don't understand the use case for setting the ppp unit at
> > > creation time.
> > 
> > I know about two use cases:
> > 
> > * ppp unit id is used for generating network interface name. So if you
> >   want interface name ppp10 then you request for unit id 10. It is
> >   somehow common that when ppp interface has prefix "ppp" in its name
> >   then it is followed by unit id. Seems that existing ppp applications
> >   which use "ppp<num>" naming expects this. But of course you do not
> >   have to use this convention and rename interfaces as you want.
> 
> Really, with the netlink API, the interface name has to be set with
> IFLA_IFNAME. There's no point in adding a new attribute just to have a
> side effect on the device name.

Yes, if you set IFLA_IFNAME then interface has name which you set. But
if IFLA_IFNAME is not set then there is already API/ABI behavior how
this interface name is generated. And all existing ppp software depends
on it.

> > * Some of ppp ioctls use unit id. So you may want to use some specific
> >   number for some network interface. So e.g. unit id 1 will be always
> >   for /dev/ttyUSB1.
> 
> But what's the point of forcing unit id 1 for a particular interface?
> One can easily get the assigned unit id with ioctl(PPPIOCGUNIT).

Same point as ability to assign any other id to objects. It is
identifier and you may want to use specific identifier for specific
objects.

Old ioctl API provides a way how to set this custom unit id. Why should
somebody use new rtnl API if it provides only half of features? Existing
software already use this feature to allow users / administrators to
specify ids as they want.

> > > I didn't implement it on purpose when creating the
> > > netlink interface, as I didn't have any use case.
> > > 
> > > On the other hand, adding the ppp unit in the netlink dump is probably
> > > useful.
> > 
> > Yes, this could be really useful as currently if you ask netlink to
> > create a new ppp interface you have to use ioctl to retrieve this unit
> > id. But ppp currently does not provide netlink dump operation.
> > 
> > Also it could be useful for this "bug":
> > https://lore.kernel.org/netdev/20210807132703.26303-1-pali@kernel.org/t/#u
> 
> This patch itself makes sense, but how is that related to unit id?

Now I see, it does not help in this unit id scenario...

> > And with unit id there also another issue:
> > https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/t/#u
> 
> This patch shows why linking unit id and interface name are a bad idea.

Yea... It is not a good idea, but it is how ppp is implemented in
kernel since beginning. And it affects both ioctl and rtnl APIs. So we
cannot do anything with it due to backward compatibility :-(

> Instead of adding more complexity with unit id, I'd prefer to have a
> new netlink attribute that says "don't generate the interface name
> based on the unit id". That's how the original implementation worked by
> the way and I'm really sad I accepted to change it...

Main issue there is that kernel currently does not provide any way how
to retrieve interface which was created by rtnl call. So matching
interface name by string "ppp" followed by unit id is currently the only
option.

I must admit that ppp rtnl API was designed incorrectly. If it was able
to solve this issue since beginning then this unit id <--> interface
mapping did not have to been implemented in rtnl code path.

But it is too late now, if rtnl API has to be backward compatible then
its behavior needs to be as it is currently.

> > But due to how it is used we probably have to deal with it how ppp unit
> > id are defined and assigned...
> > 
> 
