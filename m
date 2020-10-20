Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79A529450F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbgJTWTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389624AbgJTWTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 18:19:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA84B2225C;
        Tue, 20 Oct 2020 22:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603232355;
        bh=/taDXiY8UUHlh1x63Vf9ft/Q3Ozy2Ix7UBX4wQf5eAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NR0XswTzQJge+jdYIneCWofI2fSEWW6yoy7uzh38S4Cz9yw35DueVhu20tRXc4EJ0
         ZJeXIbZ6LvzT6649zw0TvaAKUmeDuuBcDKd+cFLDGSKUH+0e5Yg0MZRaxDqj9n8vgb
         kEL6kUc2XruFO1YsJfvCxD92pAyDQaD64jPtzK/E=
Date:   Tue, 20 Oct 2020 15:19:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
Message-ID: <20201020151913.3bfc8edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8AEE4003-FA15-4D69-9355-F15E1B737C0F@linux.vnet.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
        <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
        <20201020143352.04cee401@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8AEE4003-FA15-4D69-9355-F15E1B737C0F@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:07:38 -0500 Lijun Pan wrote:
> > Please read my reply carefully.
> >=20
> > What's the call path that leads to the address being wrong? If you set
> > the address via ifconfig it will call ibmvnic_set_mac() of the driver.
> > ibmvnic_set_mac() does the copy.
> >=20
> > But it doesn't validate the address, which it should. =20
>=20
> Sorry about that. The mac addr validation is performed on vios side when =
it receives the
> change request. That=E2=80=99s why there is no mac validation code in vni=
c driver.=20

The problem is that there is validation in the driver:

static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
{
	struct ibmvnic_adapter *adapter =3D netdev_priv(netdev);
	union ibmvnic_crq crq;
	int rc;

	if (!is_valid_ether_addr(dev_addr)) {
		rc =3D -EADDRNOTAVAIL;
		goto err;
	}

And ibmvnic_set_mac() does this:

	ether_addr_copy(adapter->mac_addr, addr->sa_data);
	if (adapter->state !=3D VNIC_PROBED)
		rc =3D __ibmvnic_set_mac(netdev, addr->sa_data);

So if state =3D=3D VNIC_PROBED, the user can assign an invalid address to
adapter->mac_addr, and ibmvnic_set_mac() will still return 0.

That's a separate issue, for a separate patch, though, so you can send=20
a v2 of this patch regardless.

> In handle_change_mac_rsp(), &crq->change_mac_addr_rsp.mac_addr[0]
> contains the current valid mac address, which may be different than the r=
equested one,=20
> that is &crq->change_mac_addr.mac_addr[0].
> crq->change_mac_addr.mac_addr is the requested one.
> crq->change_mac_addr_rsp.mac_addr is the returned valid one.
>=20
> Hope the above answers your doubt.

Oh! The address in reply can be different than the requested one?
Please add a comment stating that in the code.
