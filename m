Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF630E2D4
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhBCSvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231149AbhBCSvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:51:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6852364F7C;
        Wed,  3 Feb 2021 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612378263;
        bh=TdxVZ2G73584xRXDaoV0L00v+3CJN5sZ8D+K02FYf4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OB5HautGtJ19BMhW51eHZaLdsGrW9HEj+pgq09AiW82n9eYZHG6FAaM470RK2ikNp
         reRAAj1uHdMF2pZfINCUvoCL/C7fD514Vt7Hi+yImNvvuYEuKn3pytZKkKPEowKeJ0
         ZE2d7WAka3yDSg7OO0bgtcgp1OZoI2EMsUk/8sOGx4UoGhsu5whvp9UbPJ/pXU1/la
         es7cjbeaE3WNKDyasDbYawGHyNV/yV+rL55imBZKJ7RXjW1yGrFKCUx2CxiS8k1shx
         2Z94kAHbP+4ex5ZSpGJxiOAttuZh0fKA8vXJR0YWSttPcpN9dD77eCvKROFVMdiFkc
         KttuHLyMP+8ZA==
Date:   Wed, 3 Feb 2021 10:51:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: Add port function attribute to
 enable/disable roce
Message-ID: <20210203105102.71e6fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d01dfcc6f46f2c70c4921139543e5823582678c8.camel@kernel.org>
References: <20210201175152.11280-1-yishaih@nvidia.com>
        <20210202181401.66f4359f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d01dfcc6f46f2c70c4921139543e5823582678c8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Feb 2021 20:13:48 -0800 Saeed Mahameed wrote:
> On Tue, 2021-02-02 at 18:14 -0800, Jakub Kicinski wrote:
> > On Mon, 1 Feb 2021 19:51:50 +0200 Yishai Hadas wrote: =20
> > > Currently mlx5 PCI VF and SF are enabled by default for RoCE
> > > functionality.
> > >=20
> > > Currently a user does not have the ability to disable RoCE for a
> > > PCI
> > > VF/SF device before such device is enumerated by the driver.
> > >=20
> > > User is also incapable to do such setting from smartnic scenario
> > > for a
> > > VF from the smartnic.
> > >=20
> > > Current 'enable_roce' device knob is limited to do setting only at
> > > driverinit time. By this time device is already created and
> > > firmware has
> > > already allocated necessary system memory for supporting RoCE.
> > >=20
> > > When a RoCE is disabled for the PCI VF/SF device, it saves 1 Mbyte
> > > of
> > > system memory per function. Such saving is helpful when running on
> > > low
> > > memory embedded platform with many VFs or SFs.
> > >=20
> > > Therefore, it is desired to empower user to disable RoCE
> > > functionality
> > > before a PCI SF/VF device is enumerated. =20
> >=20
> > You say that the user on the VF/SF side wants to save memory, yet
> > the control knob is on the eswitch instance side, correct?
> >  =20
>=20
> yes, user in this case is the admin, who controls the provisioned
> network function SF/VFs.. by turning off this knob it allows to create
> more of that resource in case the user/admin is limited by memory.

Ah, so in case of the SmartNIC this extra memory is allocated on the
control system, not where the function resides?

My next question is regarding the behavior on the target system - what
does "that user" see? Can we expect they will understand that the
limitation was imposed by the admin and not due to some initialization
failure or SW incompatibility?

> > > This is achieved by extending existing 'port function' object to
> > > control
> > > capabilities of a function. This enables users to control
> > > capability of
> > > the device before enumeration.
> > >=20
> > > Examples when user prefers to disable RoCE for a VF when using
> > > switchdev
> > > mode:
> > >=20
> > > $ devlink port show pci/0000:06:00.0/1
> > > pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller
> > > 0
> > > pfnum 0 vfnum 0 external false splittable false
> > > =C2=A0 function:
> > > =C2=A0=C2=A0=C2=A0 hw_addr 00:00:00:00:00:00 roce on
> > >=20
> > > $ devlink port function set pci/0000:06:00.0/1 roce off
> > > =C2=A0=20
> > > $ devlink port show pci/0000:06:00.0/1
> > > pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller
> > > 0
> > > pfnum 0 vfnum 0 external false splittable false
> > > =C2=A0 function:
> > > =C2=A0=C2=A0=C2=A0 hw_addr 00:00:00:00:00:00 roce off
> > >=20
> > > FAQs:
> > > -----
> > > 1. What does roce on/off do?
> > > Ans: It disables RoCE capability of the function before its
> > > enumerated,
> > > so when driver reads the capability from the device firmware, it is
> > > disabled.
> > > At this point RDMA stack will not be able to create UD, QP1, RC,
> > > XRC
> > > type of QPs. When RoCE is disabled, the GID table of all ports of
> > > the
> > > device is disabled in the device and software stack.
> > >=20
> > > 2. How is the roce 'port function' option different from existing
> > > devlink param?
> > > Ans: RoCE attribute at the port function level disables the RoCE
> > > capability at the specific function level; while enable_roce only
> > > does
> > > at the software level.
> > >=20
> > > 3. Why is this option for disabling only RoCE and not the whole
> > > RDMA
> > > device?
> > > Ans: Because user still wants to use the RDMA device for non RoCE
> > > commands in more memory efficient way. =20
> >=20
> > What are those "non-RoCE commands" that user may want to use "in a
> > more
> > efficient way"? =20
>=20
> RAW eth QP, i think you already know this one, it is a very thin layer
> that doesn't require the whole rdma stack.

Sorry for asking a leading question. You know how we'll feel about
that one, do we need to talk this out or can we save ourselves the
battle? :S
