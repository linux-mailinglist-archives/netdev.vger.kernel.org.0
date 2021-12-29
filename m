Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5E8481609
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhL2SS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:18:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhL2SS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 13:18:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2086EB819CD;
        Wed, 29 Dec 2021 18:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535BDC36AE7;
        Wed, 29 Dec 2021 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640801903;
        bh=vCthyItRqvizxx+azzolTtTuoxGMbjuUmtjnpPICm/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZQXOI5B+oIETYvasY8oymoljGcK/VvE4fSWsWOyEPFTzVu2ksCWiYMwb+YoqJMvUZ
         er/mnKq1Zvj+eVYLy5cJ7IgSu6jzAiFiCmfiDIIh2PXBsiQhvoxQJ4eTD12t5qs9Zd
         mKQZsK75Kkx6ncoUUnAX0H1+ZWX3GXof1a26a+Ob/d0sFd7fZpaK266D7hdgrFE4ti
         ainu63KDMVgNDYVKk3/AF6ZeBgUxhaXUOkmh1OOSUvlztccLE+LFhPuwVv7vFEn/1t
         1GEuAw6gi3ljFSMJaT9HHaqWe8RbzwhgJJGM213jYewNzEwSzq9Ly9tRKR12kpehJJ
         Oshf3SSSZX4Fg==
Date:   Wed, 29 Dec 2021 10:18:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     zajec5@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, rafal@milecki.pl, robh+dt@kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] of: net: support NVMEM cells with MAC in text format
Message-ID: <20211229101822.7a740aed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229124047.1286965-1-michael@walle.cc>
References: <20211223122747.30448-1-zajec5@gmail.com>
        <20211229124047.1286965-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 13:40:47 +0100 Michael Walle wrote:
> > Some NVMEM devices have text based cells. In such cases MAC is stored in
> > a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
> > support those NVMEM cells. This is required to support e.g. a very
> > popular U-Boot and its environment variables.
> >=20
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> > ---
> > Please let me know if checking NVMEM cell length (6 B vs. 17 B) can be
> > considered a good enough solution. Alternatively we could use some DT
> > property to make it explicity, e.g. something like:
> >=20
> > ethernet@18024000 {
> > 	compatible =3D "brcm,amac";
> > 	reg =3D <0x18024000 0x800>;
> >=20
> > 	nvmem-cells =3D <&mac_addr>;
> > 	nvmem-cell-names =3D "mac-address";
> > 	nvmem-mac-format =3D "text";
> > }; =20
>=20
> Please note, that there is also this proposal, which had such a conversion
> in mind:
> https://lore.kernel.org/linux-devicetree/20211228142549.1275412-1-michael=
@walle.cc/
>=20
> With this patch, there are now two different places where a mac address
> format is converted. In of_get_mac_addr_nvmem() and in the imx otp driver.
> And both have their shortcomings and aren't really flexible. Eg. this one
> magically detects the format by comparing the length, but can't be used f=
or
> to swap bytes (because the length is also ETH_ALEN), which apparently is a
> use case in the imx otp driver. And having the conversion in an nvmem
> provider device driver is still a bad thing IMHO.
>=20
> I'd really like to see all these kind of transformations in one place.

FWIW offsetting from a common base address is relatively common, that's
why we have:

/**
 * eth_hw_addr_gen - Generate and assign Ethernet address to a port
 * @dev: pointer to port's net_device structure
 * @base_addr: base Ethernet address
 * @id: offset to add to the base address
 *
 * Generate a MAC address using a base address and an offset and assign it
 * to a net_device. Commonly used by switch drivers which need to compute
 * addresses for all their ports. addr_assign_type is not changed.
 */
static inline void eth_hw_addr_gen(struct net_device *dev, const u8 *base_a=
ddr,
				   unsigned int id)
