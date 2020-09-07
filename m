Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA7825FAB2
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgIGMuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 08:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgIGMtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 08:49:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F063C061573;
        Mon,  7 Sep 2020 05:49:07 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599482944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wSCREh0pNY9JSAg70DitlNBTbCDJhi06/83bdxxq5sA=;
        b=XVKMcknnSeZ8lX9ZlkpE0aPjZ5/SszUrtYohy6bkIBk+Qa1ebK16FohHosRi8ppDp6DXuw
        4r3ehFKbQ3DfvkQXUiSbvxhMOWkH6NZJ7ZfF76PuPFc/LtzjxyvzPJjE3rx8VaWqblE5dI
        9KNoCKZdcCYXDN+56YZkbJLAp6IWues8s8ItAwwFwjPqjDAMZfddHF+TOENNrQjl7tlpiR
        RWQXP2qwm52E2F8s2Grv6knMRdHUbFB8xhQDHjGLd46KLufWUDNec5IcJmmTFllj/C/Gvl
        deD17RN80+U3plL4tbPFYXOFZ8Z3zo3HfVcgKSHseVP0A9twK2r7irPoOx+gpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599482944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wSCREh0pNY9JSAg70DitlNBTbCDJhi06/83bdxxq5sA=;
        b=kpIdtAeJLNYh/7di8g0+tCyprE9jO9n1U38sQ4lrvy6wrazEaR5VkbPCgzXmFTMGPYzhmO
        Ts5t4spxv33gHrBQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200907104821.kvu7bxvzwazzg7cv@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de> <20200904062739.3540-3-kurt@linutronix.de> <20200905204235.f6b5til4sc3hoglr@skbuf> <875z8qazq2.fsf@kurt> <20200907104821.kvu7bxvzwazzg7cv@skbuf>
Date:   Mon, 07 Sep 2020 14:49:03 +0200
Message-ID: <87eendah1c.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Sep 07 2020, Vladimir Oltean wrote:
> On Mon, Sep 07, 2020 at 08:05:25AM +0200, Kurt Kanzenbach wrote:
>> Well, that depends on whether hellcreek_vlan_add() is called for
>> creating that vlan interfaces. In general: As soon as both ports are
>> members of the same vlan that traffic is switched.
>
> That's indeed what I would expect.
> Not only that, but with your pvid-based setup, you only ensure port
> separation for untagged traffic anyway.

Why? Tagged traffic is dropped unless the vlan is configured somehow. By
default, I've configured vlan 2 and 3 to reflect the port separation for
DSA. At reset the ports aren't members of any vlan.

We could also skip the initial VLAN configuration completely. At the end
of the day it's a TSN switch and the user will setup the vlan
configuration anyway.

> I don't think you even need to call hellcreek_vlan_add() for VID 100
> to be switched between ports, because your .port_vlan_filtering
> callback does not in fact disable VLAN awareness, it just configures
> the ports to not drop unknown VLANs. So, arguably, VLAN classification
> is still performed. An untagged packet is classified to the PVID, a
> tagged packet is classified to the VID in the packet. So tagged
> packets bypass the separation.
>
> So, I think that's not ok. I think the only proper way to solve this is
> to inform the IP designers that VLANs are no substitute for a port
> forwarding matrix (a lookup table that answers the question "can port i
> forward to port j"). Switch ports that are individually addressable by
> the network stack are a fundamental assumption of the switchdev
> framework.

As I said before, there is no port forwarding matrix. There are only
vlans and the fdb. There's also a global flag for setting vlan unaware
mode and a port option for vlan tag required. That's it. I guess, we
have to deal with it somehow.

>
>> > I remember asking in Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
>> > whether it would be possible for you to set
>> > ds->configure_vlan_while_not_filtering = true during hellcreek_setup.
>> > Did anything unexpected happen while trying that?
>>
>> No, that comment got lost.
>>
>> So looking at the flag: Does it mean the driver can receive vlan
>> configurations when a bridge without vlan filtering is used? That might
>> be problematic as this driver uses vlans for the port separation by
>> default. This is undone when vlan filtering is set to 1 meaning vlan
>> configurations can be received without any problems.
>
> Yes.
> Generally speaking, the old DSA behavior is something that we're trying
> to get rid of, once all drivers set the option to true. So a new driver
> should not rely on it even if it needs something like that.

OK. when a new driver should set the flag, then I'll set it. So, all
vlan requests programming requests should be "buffered" and executed
when vlan filtering is enabled? What is it good for?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9WLD8ACgkQeSpbgcuY
8KalchAAo8Fp+CjT6AQwdXwvGEDKmh45HMMQiumZmkKrpwUJXMOHoXjC2jz3DHk5
rRAU+wq4FerngEkaHpGz7lJ6BXyDW7wISLb0LRUyZlLRL5u7pHnOPfMOuX09TIVJ
i3r07/hU1u9s2nC7TUouLXmIgZZylOFJGa4KPotnPX5m21xH31dMsGs7MpZDcBwK
RQB7jO+Vky5rYHq1fKxy0Aj1mHZssjs/RTiu0txwcn+f8YiURpwgygCm4Il0a1AM
pjSoFMgcfTIe+uCdHjbZWmz8FPClEhJGABOB0RNsaC0mDBLOY2zQ3qfFRoEmYJiB
S16hfxjp8epqdeggCSUI0KsOsprx1SQ10toCmFY1ovFud95LJwQZtfsCfL8ir954
Hwj2KrhT/QokNgVWY3sB37Gd4pPviJreVFpHVM0lN4JSOFIv0LnxK8kKjRY8RiZo
+DfEYQwDCsNxRCLBWtMesD9aKOFrj4zEpnoTUbeZWURQy9xh6Mn1HaiqYEEVFTjb
ZCepEmJhOinJK4wSnqDycdjmib6Ajag47CMJ+IlmIOJWiE7rcVtk7tJj+CXP7cEd
aW+bcGh2vWZzGCOTaFoyiHTwlT4OcgnWxMiPg2nq0x/LgIpi5GFuhTqrBLmhYt4S
fenoW3voeP6XY8cXz5Hi13HFvG8dcuY/D7L+PYzWC61A0hSVClU=
=2puc
-----END PGP SIGNATURE-----
--=-=-=--
