Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC1D3EA63B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbhHLOJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235263AbhHLOJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 10:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394246103E;
        Thu, 12 Aug 2021 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628777361;
        bh=aQ47d5YlVySZNXPNcA6Ef4BYQj2TbtNuZ997hYOG4tA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMeA8eQgYaXAYeDX3QXpVozkdY40gObR/Js01KQMoeHKSXLiV1BBQBPEFPxoxDlDZ
         AXQyCcaTVmzLW10tQOQvNMRgURX637yhvopTXKHuabl2QQVP+Ra56b5S59umS3TO+/
         bd0BBRXjhNdgzu8EKjSzBBLc+CcO5XPnAo86wRlYo2jmZWCKfQ69/24+nQxTFtkpWj
         50LSW3FyG2mOdLj5ivEbwYYwNrLCOSTA6kreritvBBnKQoXdrxt7Ip6JW533dvqCyH
         4KH7RE6MYlQeFGhh5rn1vDW2lBjk1cQq0YBAe+8yyrbPKtBY/XrDUSbY17dPB0aVGl
         oPuS2RUvgF/Pg==
Received: by pali.im (Postfix)
        id BFB5872F; Thu, 12 Aug 2021 16:09:18 +0200 (CEST)
Date:   Thu, 12 Aug 2021 16:09:18 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210812140918.lfll55przd4ajtc7@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <20210810160450.eluiktsp7oentxo3@pali>
 <20210811171918.GD15488@pc-32.home>
 <20210811175449.5hrwoevw7xv2jxxn@pali>
 <20210812091941.GA3525@pc-23.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812091941.GA3525@pc-23.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 12 August 2021 11:19:41 Guillaume Nault wrote:
> On Wed, Aug 11, 2021 at 07:54:49PM +0200, Pali Rohár wrote:
> > On Wednesday 11 August 2021 19:19:18 Guillaume Nault wrote:
> > > On Tue, Aug 10, 2021 at 06:04:50PM +0200, Pali Rohár wrote:
> > > > On Tuesday 10 August 2021 17:39:41 Guillaume Nault wrote:
> > > > > On Mon, Aug 09, 2021 at 09:31:09PM +0200, Pali Rohár wrote:
> > > > > > Better to wait. I would like hear some comments / review on this patch
> > > > > > if this is the correct approach as it adds a new API/ABI for userspace.
> > > > > 
> > > > > Personally I don't understand the use case for setting the ppp unit at
> > > > > creation time.
> > > > 
> > > > I know about two use cases:
> > > > 
> > > > * ppp unit id is used for generating network interface name. So if you
> > > >   want interface name ppp10 then you request for unit id 10. It is
> > > >   somehow common that when ppp interface has prefix "ppp" in its name
> > > >   then it is followed by unit id. Seems that existing ppp applications
> > > >   which use "ppp<num>" naming expects this. But of course you do not
> > > >   have to use this convention and rename interfaces as you want.
> > > 
> > > Really, with the netlink API, the interface name has to be set with
> > > IFLA_IFNAME. There's no point in adding a new attribute just to have a
> > > side effect on the device name.
> > 
> > Yes, if you set IFLA_IFNAME then interface has name which you set. But
> > if IFLA_IFNAME is not set then there is already API/ABI behavior how
> > this interface name is generated. And all existing ppp software depends
> > on it.
> 
> They depend on the ioctl api, which is not going to change.
> The netlink api on the other hand is free to avoid propagating mistakes
> from the past.
> 
> > > > * Some of ppp ioctls use unit id. So you may want to use some specific
> > > >   number for some network interface. So e.g. unit id 1 will be always
> > > >   for /dev/ttyUSB1.
> > > 
> > > But what's the point of forcing unit id 1 for a particular interface?
> > > One can easily get the assigned unit id with ioctl(PPPIOCGUNIT).
> > 
> > Same point as ability to assign any other id to objects. It is
> > identifier and you may want to use specific identifier for specific
> > objects.
> 
> Again, what's the use case? Unit ids are kernel internal identifiers.
> The only purpose of setting them from user space was to influence the
> name of the ppp device for legacy systems that couldn't do that in a
> clean way. But any system with the netlink interface won't need this
> work around.
> 
> > Old ioctl API provides a way how to set this custom unit id. Why should
> > somebody use new rtnl API if it provides only half of features?
> 
> You still haven't provided any use case for setting the unit id in user
> space, appart for influencing the interface name. Netlink also allows
> to set the interface name and provides much more features (like
> creating the device in a different netns).
> 
> > Existing
> > software already use this feature to allow users / administrators to
> > specify ids as they want.
> 
> And that was a mistake, as you realised when working on
> https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/t/#u.
> 
> > > > And with unit id there also another issue:
> > > > https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/t/#u
> > > 
> > > This patch shows why linking unit id and interface name are a bad idea.
> > 
> > Yea... It is not a good idea, but it is how ppp is implemented in
> > kernel since beginning. And it affects both ioctl and rtnl APIs. So we
> > cannot do anything with it due to backward compatibility :-(
> 
> Sorry, but I still hardly see the problem with the netlink api.

The problem is that ppp from rtnl is of the same class as ppp from
ioctl. And if you want to use ppp, you still have to use lot of ioctl
calls as rtnl does not implement them. And these ioctl calls use ppp
unit id, not interface id / interface name.

So in the end you can use RTM_NEWLINK and then control ppp via ioctls.
And for controlling you have to known that ppp unit id.

If you are using ppp over serial devices, you can "simplify" it by
forcing mapping that serial number device matches ppp unit id. And then
you do not have to use dynamic ids (and need for call PPPIOCGUNIT).

With dynamic unit id allocation (which is currently the only option when
creating ppp via rtnl) for single ppp connection you need to know:
* id of serial tty device
* id of channel bound to tty device
* id of network interface
* id of ppp unit bound to network interface

> I shouldn't have accepted to let the unit id influence the interface
> name, true.

I agree here. But it is too late.

> But that doesn't seem to be what you're complaining about.
> Also, it could be useful to add the unit id in netlink dumps. But we
> already agreed on that.

Yes!

> > > Instead of adding more complexity with unit id, I'd prefer to have a
> > > new netlink attribute that says "don't generate the interface name
> > > based on the unit id". That's how the original implementation worked by
> > > the way and I'm really sad I accepted to change it...
> > 
> > Main issue there is that kernel currently does not provide any way how
> > to retrieve interface which was created by rtnl call. So matching
> > interface name by string "ppp" followed by unit id is currently the only
> > option.
> 
> Yes, that's an old limitation of rtnl. But it's a much more general
> problem. A work around is to set the interface name in the netlink
> request. I can't see how forcing the unit id could ever help.
> 
> > I must admit that ppp rtnl API was designed incorrectly. If it was able
> > to solve this issue since beginning then this unit id <--> interface
> > mapping did not have to been implemented in rtnl code path.
> 
> As I already proposed, we can add an attribute to make the interface
> name independant from the unit id.
> 
> > But it is too late now, if rtnl API has to be backward compatible then
> > its behavior needs to be as it is currently.
> 
> Adding a new attribute is always possible.

I agree, that above proposal with a new attribute which makes interface
name independent from the ppp unit id is a good idea. Probably it should
have been default rtnl behavior (but now it is too late for changing
default behavior).

But prior adding this attribute, we first need a way how to retrieve
interface name of newly created interface. Which we agreed that
NLM_F_ECHO for RTM_NEWLINK/NLM_F_CREATE is needed.

> > > > But due to how it is used we probably have to deal with it how ppp unit
> > > > id are defined and assigned...
> > > > 
> > > 
> > 
> 
