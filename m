Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2988D2B9955
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgKSRbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbgKSRbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:31:11 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645CA208B6;
        Thu, 19 Nov 2020 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605807071;
        bh=yeykAMFKBu2nzLe6DBblFnq3bjKL5vPe7etKdVATJso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EeVWmSXxKuDkryGXZngzjxauWVXdBK311KY9GacpXEtrY0ZeR21deA+S9Sgg2A6BV
         gxLMaIAKWtD0ReTMmvhuKK2aqf5Kb0bnKAcVTO6S95Kem9dZ9iVEeajNH8lUJlFN0M
         tdHgk8x8HySTyvo93IO7hrrJDIO4RbmXo129mVQ8=
Date:   Thu, 19 Nov 2020 09:31:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Markus =?UTF-8?B?QmzDtmNobA==?= <Markus.Bloechl@ipetronik.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201119093109.1b5c9cd8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119153751.ix73o5h4n6dgv4az@ipetronik.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
        <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
        <20201111164727.pqecvbnhk4qgantt@skbuf>
        <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
        <20201114181103.2eeh3eexcdnbcfj2@skbuf>
        <20201119153751.ix73o5h4n6dgv4az@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 16:37:51 +0100 Markus Bl=C3=B6chl wrote:
> Implementation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I then tried to come up with a solution in net/core that would
> universally disable vlan filtering in promiscuous mode.

Thanks for taking a look!

> Removing the features in `netdev_fix_features` is easily done, but
> updating the active set of features whenever IFF_PROMISC changes
> seems hard.
>=20
> `__dev_set_promiscuity` is often called in atomic context but
> `.ndo_set_features` can sleep in many drivers.

Are there paths other than __dev_set_rx_mode() which would call
__dev_set_promiscuity() in atomic context? The saving grace about=20
__dev_set_rx_mode() is that it sets promisc explicitly to disable=20
unicast filtering (dev->uc_promisc), so IMO that case
(dev->promiscuity =3D=3D dev->uc_promisc) does not need to disable VLAN
filtering.

But IDK if that's the only atomic path.

> Adding a work_queue or similar to every net_device seems clumsy and
> inappropriate.
>=20
> Rewriting ndo_set_features of all drivers to be atomic is not a task
> you should ask from me...
>=20
> Calling `netdev_update_features` after every entrypoint that locks
> the rtnl seems too error-prone and also clumsy.
>=20
> Only updating the features when promiscuity was explicitly requested
> by userspace in `dev_change_flags` might leave the device in a
> weird inconsistent state.
>=20
> Continue to let each driver enforce the kernels definition of
> promiscuity. They know how to update the features atomically.
> Then I am back at my original patch...
>=20
> I'm afraid, I might need some guidance on how to approach this.

