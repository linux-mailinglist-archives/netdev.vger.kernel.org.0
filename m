Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEB4953CE
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 19:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbiATSCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 13:02:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbiATSCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 13:02:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54EF2B81E19;
        Thu, 20 Jan 2022 18:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689BCC340E0;
        Thu, 20 Jan 2022 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642701721;
        bh=xC8OW4CUchMp0erk9wqkXdiLHGoZ3LLIAA7sgkPWiP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=STqmId7/Gepb2e10OOESnjpCgVu+XYM9AIJ7eEWxDd3gFSyxf2LloLOmdjceOCH2u
         LmaFwZdvyDTJGVSiPASaMhJMInGt9tTb0JBz5T3pa+WS6Gde1JtMoVsQV+0u3+iVQ6
         AS3azklGnlI9JEVw8iJ2uFK0R6c2d3ycMqNfGKKoDYcrB1XvwjROFX/qJ+vQxBeLe6
         WQeI7glnlt9n6RBnoOT4D5T09IONYBTot49F3Xm241WTMRs2nLYNVZD3xBb96ENPD5
         y/AXWhi1jmGqlxirgROQecJ9LlqNW3tBEkYhopkYNIjdEeTKlkFOsqVpLXHnJWIQPb
         iiva4lKWR1Wiw==
Date:   Thu, 20 Jan 2022 19:01:55 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, ore@pengutronix.de,
        alexandru.tachici@analog.com
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <20220120190155.717f2d52@thinkpad>
In-Reply-To: <20220120084914.ga7o372lyynbn4ly@pengutronix.de>
References: <20220119131117.30245-1-kabel@kernel.org>
        <20220120084914.ga7o372lyynbn4ly@pengutronix.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 09:49:14 +0100
Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> On 19.01.2022 14:11:17, Marek Beh=C3=BAn wrote:
> > Common PHYs and network PCSes often have the possibility to specify
> > peak-to-peak voltage on the differential pair - the default voltage
> > sometimes needs to be changed for a particular board.
> >=20
> > Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> > purpose. The second property is needed to specify the mode for the
> > corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> > is to be used only for speficic mode. More voltage-mode pairs can be
> > specified.
> >=20
> > Example usage with only one voltage (it will be used for all supported
> > PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> > case):
> >=20
> >   tx-p2p-microvolt =3D <915000>;
> >=20
> > Example usage with voltages for multiple modes:
> >=20
> >   tx-p2p-microvolt =3D <915000>, <1100000>, <1200000>;
> >   tx-p2p-microvolt-names =3D "2500base-x", "usb", "pcie";
> >=20
> > Add these properties into a separate file phy/transmit-amplitude.yaml,
> > which should be referenced by any binding that uses it. =20
>=20
> If I understand your use-case correctly, you need different voltage p2p
> levels in the connection between the Ethernet MAC and the Ethernet
> switch or Ethernet-PHY?

This is a SerDes differential pair amplitude. So yes to your question,
if the MII interface uses differential pair, like sgmii, 10gbase-r, ...

> Some of the two wire Ethernet standards (10base-T1S, 10base-T1L,
> 100base-T1, 1000base-T1) defines several p2p voltage levels on the wire,
> i.e. between the PHYs. Alexandru has posed a series where you can
> specify the between-PHY voltage levels:
>=20
> | https://lore.kernel.org/all/20211210110509.20970-8-alexandru.tachici@an=
alog.com/

Copper ethernet is something different, so no conflict

> Can we make clear that your binding specifies the voltage level on the
> MII interface, in contrast Alexandru's binding?

The binding explicitly says "common PHY", not ethernet PHY. I don't
thing there will be any confusion. It can also be specified for USB3+
differential pairs, or PCIe differential pairs, or DisplayPort
differential pairs...

Marek
