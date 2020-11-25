Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFBE2C4623
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgKYQ6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732288AbgKYQ6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:58:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89DD2083E;
        Wed, 25 Nov 2020 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606323530;
        bh=mgTx+VXQbRogKjojwotMsge+ajrNTc0HeXMZPC+DiTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mti7wwmPTX8jCITHtQidlNx0DlQkzwub1OjLsRnMt5FXcYR+RSskSX95sEWrNT9yA
         vqzGpAgjwZQqQaLrmq0XWNVn/U5NDrmmJfvhLmsQkGA4SW9GD886yPeGIu7uJeIBaC
         dBauyqYawa5L9CRbMsLUslhajMRJW3OA/PNdftmU=
Date:   Wed, 25 Nov 2020 08:58:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes
 poor multicast receive performance
Message-ID: <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 13:51:41 +0100 Thomas Karlsson wrote:
> Den 2020-11-23 kl. 23:30, skrev Jakub Kicinski:
> > On Mon, 23 Nov 2020 14:22:31 +0000 Thomas Karlsson wrote: =20
> >> Hello,
> >>
> >> There is a special queue handling in macvlan.c for broadcast and
> >> multicast packages that was arbitrarily set to 1000 in commit
> >> 07d92d5cc977a7fe1e683e1d4a6f723f7f2778cb . While this is probably
> >> sufficient for most uses cases it is insufficient to support high
> >> packet rates. I currently have a setup with 144=C2=A0000 multicast pac=
kets
> >> incoming per second (144 different live audio RTP streams) and suffer
> >> very frequent packet loss. With unicast this is not an issue and I
> >> can in addition to the 144kpps load the macvlan interface with
> >> another 450mbit/s using iperf.
> >>
> >> In order to verify that the queue is the problem I edited the define
> >> to 100000 and recompiled the kernel module. After replacing it with
> >> rmmod/insmod I get 0 packet loss (measured over 2 days where I before
> >> had losses every other second or so) and can also load an additional
> >> 450 mbit/s multicast traffic using iperf without losses. So basically
> >> no change in performance between unicast/multicast when it comes to
> >> lost packets on my machine.
> >>
> >> I think It would be best if this queue length was configurable
> >> somehow. Either an option when creating the macvlan (like how
> >> bridge/passthrough/etc are set) or at least when loading the module
> >> (for instance by using a config in /etc/modprobe.d). One size does
> >> not fit all in this situation. =20
> >=20
> > The former please. You can add a netlink attribute, should be
> > reasonably straightforward. The other macvlan attrs are defined
> > under "MACVLAN section" in if_link.h.
> >  =20
>=20
> I did some work towards a patch using the first option,
> by adding a netlink attribute in if_link.h as suggested.
> I agree that this was reasonably straightforward, until userspace.
>=20
> In order to use/test my new parameter I need to update iproute2 package
> as far as I understand. But then since I use the macvlan with docker
> I also need to update the docker macvlan driver to send this new
> option to the kernel module.

I wish I got a cookie every time someone said they can't do the right
thing because they'd have to update $container_system =F0=9F=98=94

> For this reason I would like to know if you would consider
> merging a patch using the module_param(...) variant instead?
>=20
> I would argue that this still makes the situation better
> and resolves the packet-loss issue, although not necessarily
> in an optimal way. However, The upside of being able to specify the
> parameter on a per macvlan interface level instead of globally is not
> that big in this situation. Normally you don't use that much
> multicast anyway so it's a parameter that only will be touched by
> a very small user base that can understand and handle the implications
> of such a global setting.

How about implementing .changelink in macvlan? That way you could
modify the macvlan device independent of Docker?=20

Make sure you only accept changes to the bc queue len if that's the
only one you act on.
