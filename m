Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5873F42D787
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhJNK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230176AbhJNK5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 06:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E6F760FE8;
        Thu, 14 Oct 2021 10:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634208930;
        bh=/MnBOOloBNkoQ0639mnUn1C7Sn42XWYjpsS3RR92b4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YVdjZi8UEdWoNbDOSER/nYn8CI9Pu2C9AHqrJXR+6hioEicpNtL4+1tFCUNb/T6RD
         5bwrVMKTamkb0qvmv6FV0Q6o8RPbd1uTUirEJ0ESoH7hR+nRQCe59DdzvzPg3VHPew
         MyHyembjbheOiF25wREdLqQQ7GblUlyZDNrJls6K/0hIcVjefnKfk34t0c9oAERTI0
         udl/XTbYTo9JhRgJk0fimgUIzXyNzRxpCwlFeQ2xaBkEq920upgGQVKgn3QoatGEnj
         Z1/GdRJuJb2+ENR1U02ZyM3aniq9r6DHxHgmdTT1tvt/ZNEuTE0Y72mLaVN2OjWGBP
         L957WnIgsmelA==
Date:   Thu, 14 Oct 2021 12:55:26 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        U-Boot Mailing List <u-boot@lists.denx.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
Message-ID: <20211014125526.10d4861b@dellmb>
In-Reply-To: <857c27a6-5c4b-e0ed-a830-35762799613f@linaro.org>
References: <20211013232048.16559-1-kabel@kernel.org>
        <629c8ba1-c924-565f-0b3c-8b625f4e5fb0@linaro.org>
        <20211014120601.133e9a84@dellmb>
        <857c27a6-5c4b-e0ed-a830-35762799613f@linaro.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 11:30:13 +0100
Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

> On 14/10/2021 11:06, Marek Beh=C3=BAn wrote:
> > On Thu, 14 Oct 2021 09:26:27 +0100
> > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
> >  =20
> >> On 14/10/2021 00:20, Marek Beh=C3=BAn wrote: =20
> >>> Add device tree bindings for U-Boot environment NVMEM provider.
> >>>
> >>> U-Boot environment can be stored at a specific offset of a MTD
> >>> device, EEPROM, MMC, NAND or SATA device, on an UBI volume, or in
> >>> a file on a filesystem.
> >>>
> >>> The environment can contain information such as device's MAC
> >>> address, which should be used by the ethernet controller node.
> >>>     =20
> >>
> >> Have you looked at
> >> ./Documentation/devicetree/bindings/mtd/partitions/nvmem-cells.yaml
> >> ? =20
> >=20
> > Hello srini,
> >=20
> > yes, I have. What about it? :)
> >=20
> > That binding won't work for u-boot-env, because the data are stored
> > in a different way. A cell does not have a constant predetermined
> > offset on the MTD. =20
>=20
> Can't you dynamically update the nodes before nvmem-provider is
> registered?

Are you talking about dynamically updating nvmem-cell OF nodes, adding
reg properties with actual offsets and lengths found after parsing?

> > The variables are stored as a sequence of values of format
> > "name=3Dvalue", separated by '\0's, for example:
> >    board=3Dturris_mox\0ethaddr=3D00:11:22:33:44:55\0bootcmd=3Drun
> > distro_bootcmd\0.... Chaning lengths of values of variables, or
> > deleting variables, moves the data around. Integers and MAC
> > addresses are stored as strings, and so on.=20
>=20
> Do you already have a provider driver for handing this.

Not yet, I will send the proposal together with a driver in next
round.

> How is pre parsing cell info and post processing data planned to be
> handled?

My plan was to read the variables from the u-boot-env partition, create
a nvmem-cell for each variable, and then pair the ones mentioned in
device tree with their DT nodes, and post-process according to type
(post-processing would be done only for those mentioned in device tree,
others would be left as strings).

> Currently in nvmem core we do check for "reg" property for each cell,=20
> unless the provider driver is adding/updating dt entries dynamically=20
> before registering nvmem provider

I don't think updaring DT entries dynamically is a correct solution at
all. Is this done in Linux? Updating device properties is something
different, but changing DT properties seems wrong to me.

> It will not work as it is. Alteast this is what I suggested in similar
> case where cell information is in tlv format.

Hmm. OK, I shall try to implement a driver for this and then will
return to you.

> Secondly mac-address seems to be delimited, we recently introduced
> post processing callback for provider driver [1], which should help
> in this case.

Cool, I shall use that.

> If the nvmem-cell names are standard like "mac-address" then you do
> not need to add a new "type" binding to cell too, you can do
> post-processing based on name.

I plan to add functions
  of_nvmem_get_mac_address()
  nvmem_get_mac_address()
which would look at (in this order):
  mac-address, address, mac-address-backup
We have to keep the name "address" for backwards compatibility with one
driver that uses this (drivers/net/ethernet/ni/nixge.c)

Thanks.

Marek
