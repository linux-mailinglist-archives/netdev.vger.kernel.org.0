Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050C2C186C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbgKWWaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbgKWWay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:30:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9193F206D8;
        Mon, 23 Nov 2020 22:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606170653;
        bh=zDBTVyorWOYgpDdd7NSYJ5UPoIWj0MHYNaST+LBsGnQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0uqOXnjl2BJwdjvMnAzLOGaJZXhD39ZvSRHMUBZ0C06/MO59DrlFtPck049olzXjJ
         2vzOGuT6KRDjVYSZ2BOfgpKYmXqi9SxZSjfNMZtGSDkYn4vti39u/uQZchT5gbOagE
         VD71iFBMTfvM6gHYHlFebxxs2fscqkHWIioDqQp8=
Date:   Mon, 23 Nov 2020 14:30:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes
 poor multicast receive performance
Message-ID: <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <147b704ac1d5426fbaa8617289dad648@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 14:22:31 +0000 Thomas Karlsson wrote:
> Hello,
>=20
> There is a special queue handling in macvlan.c for broadcast and
> multicast packages that was arbitrarily set to 1000 in commit
> 07d92d5cc977a7fe1e683e1d4a6f723f7f2778cb . While this is probably
> sufficient for most uses cases it is insufficient to support high
> packet rates. I currently have a setup with 144=C2=A0000 multicast packets
> incoming per second (144 different live audio RTP streams) and suffer
> very frequent packet loss. With unicast this is not an issue and I
> can in addition to the 144kpps load the macvlan interface with
> another 450mbit/s using iperf.
>=20
> In order to verify that the queue is the problem I edited the define
> to 100000 and recompiled the kernel module. After replacing it with
> rmmod/insmod I get 0 packet loss (measured over 2 days where I before
> had losses every other second or so) and can also load an additional
> 450 mbit/s multicast traffic using iperf without losses. So basically
> no change in performance between unicast/multicast when it comes to
> lost packets on my machine.
>=20
> I think It would be best if this queue length was configurable
> somehow. Either an option when creating the macvlan (like how
> bridge/passthrough/etc are set) or at least when loading the module
> (for instance by using a config in /etc/modprobe.d). One size does
> not fit all in this situation.

The former please. You can add a netlink attribute, should be
reasonably straightforward. The other macvlan attrs are defined
under "MACVLAN section" in if_link.h.
