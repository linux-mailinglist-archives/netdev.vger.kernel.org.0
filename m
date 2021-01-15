Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C768E2F7508
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbhAOJQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbhAOJQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:16:12 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D851C061757;
        Fri, 15 Jan 2021 01:15:32 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l0LCa-006aJa-Lt; Fri, 15 Jan 2021 10:15:29 +0100
Message-ID: <4fffb82632f2b52e4a06d95881dcbb3a01f99ce6.camel@sipsolutions.net>
Subject: Re: [PATCH 17/18] net: iosm: readme file
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Lunn <andrew@lunn.ch>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        krishna.c.sudi@intel.com
Date:   Fri, 15 Jan 2021 10:15:27 +0100
In-Reply-To: <X/eJ/rl4U6edWr3i@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
         <20210107170523.26531-18-m.chetan.kumar@intel.com>
         <X/eJ/rl4U6edWr3i@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, all,

> > +For example, adding a link for a MBIM IP session with SessionId 5:
> > +
> > +  ip link add link wwan0 name wwan0.<name> type vlan id 5
> 
> So, this is what all the Ethernet nonsense is all about. You have a
> session ID you need to somehow represent to user space. And you
> decided to use VLANs. But to use VLANs, you need an Ethernet
> header. So you added a bogus Ethernet header.

So yeah, I don't think anyone likes that. I had half-heartedly started
working on a replacement framework (*1), but then things happened and I
didn't really have much time, and you also reviewed it and had some
comments but when I looked the component framework really didn't seem
appropriate, but didn't really have time to do anything on this either.

(*1) https://lore.kernel.org/netdev/20200225100053.16385-1-johannes@sipsolutions.net/


In the mean time, the team doing this driver (I'm not directly involved,
just helping them out with upstream processes) really needed/wanted to
continue on this, and this is what they had already, more or less.

Now, the question here at this point of course is they already had it
that way. But that's easily explained - that's how it works upstream
today, unfortunately, cf. for example drivers/net/usb/cdc_mbim.c.

Now, granted, some of the newer ones such as drivers/net/ipa/ _don't_
things that way and come out with ARPHRD_RAWIP, but that requires
userspace to actually be aware of this, and know how to create the
necessary channels etc. For IPA this is handled by 'rmnet', but rmnet is
just Qualcomm's proprietary protocol exposed as an rtnetlink type, so is
rather unsuitable for this driver.


Hence originally the thought we could come up with a generic framework
to handle this all. Unfortunately, I never had the time to follow up on
everything there.

T be honest I also lost interest when IPA got merged without any
thoughts given to unifying this, despite my involvement in the reviews
and time spent on trying to make a suitable framework that would serve
both IPA and this IOSM driver.


> Is any of this VLAN stuff required by MBIM?

Yes and no. It's not required to do _VLAN_ stuff, but that's one of the
few ways that userspace currently knows of. Note that as far as I can
tell Qualcomm (with rmnet/IPA etc.) has basically "reinvented" the world
here - requiring the use of either their proprietary modem stack, or
libqmi that knows specifically how to drive their modems.

This was something we wanted to avoid (unless perhaps we could arrive at
a standardised solution, see above) - thus being left with the VLAN
method that's used elsewhere in the kernel.

> Linux allows you to dynamically create/destroy network
> interfaces. So you want to do something like
> 
> ip link add link wwan0 name wwan42 type mbim id 42
> 
> Which will create a new mbim netdev interface using session id 42 on
> top of the device which provides wwan0. I don't actually like this
> last bit, but you somehow need to indicate on which MBIM transport you
> want to create the new session, since you could have multiple bits of
> hardware providing MBIM services.

I don't even like the fact that 'wwan0' exists there in the first place
(or how it exists in this driver), because it cannot ever actually
transport traffic since it's just the root device of sorts.

Hence the proposal to have - similar what we do in wifi - a separate
abstraction of what a modem device is, and then just allow channels to
be created on it, and those channels are exposed as netdevs.



In any case - I'm not sure how we resolve this.

On the one hand, as a technical person going for the most technically
correct solution, I'd say you're completely right and this should expose
pure IP netdevs, and have a (custom or not) way to configure channels.
That still leaves the "dead" wwan0 interface that can't do anything, but
at least it's better for the channel netdevs.
Perhaps like with the framework I was trying to do. We could even
initially side-step the issue with the component framework and simply
not allow that in the framework from the start.

However, I'm not sure of the value of this. Qualcomm's newer stuff is
already locked in to their custom APIs in rmnet and IPA, with QMI etc.

If we're honest with ourselves, older stuff that exists in the kernel
today is highly unlikely to be converted since it works now and very few
people really care about anything else.


Which basically leaves only this driver
 - either doing some old-fashioned way like it is now, or
 - doing its own custom way like rmnet/IPA, or
 - coming with a framework that pretends to be more general than rmnet
   but really is only used for this driver.

The later two choices both require significant investment on the
userspace side, so I don't think it's any wonder the first is what the
driver chose, especially after my more or less failed attempt at getting
traction for the common framework (before IPA got merged, after all.)


Also, non-technically speaking, I'm really not sure as to what we can
and should require from a single driver like this in terms of "cleaning
up the ecosystem". Yes, having a common framework would be nice, but if
nobody's going to use it, what's the point? And we didn't require such
from IPA. Now, granted, IPA already ships with a slightly better way of
doing things than ethernet+802.1q, but there's precedent for that as
well...

johannes

