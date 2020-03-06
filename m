Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8247017B3A9
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFBSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:18:36 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0714220726;
        Fri,  6 Mar 2020 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583457516;
        bh=2lC8sllfV/HqDc3ObpnsaZz9NIM/9U+UTSbCW9wVLNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sHkM/KObwGP+TUYAjTNEGRPWbNQrKRhwj1gLtR6N27Ugf1ZxYisr7s4IHgH+/A+Qm
         PG8FDEwRtW6mH+JFQnQ49EnJco5QWnj4IGKafJYRUuzfufpqRNYFuWbB4aB9hFRe89
         S4zkLX5eiUsqqHsgRTHAig/H7ZPuwSmljaFp5m7o=
Date:   Thu, 5 Mar 2020 17:18:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
Message-ID: <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
In-Reply-To: <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
        <20200305052319.14682-8-snelson@pensando.io>
        <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
        <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 16:41:48 -0800 Shannon Nelson wrote:
> On 3/5/20 2:03 PM, Jakub Kicinski wrote:
> > On Wed,  4 Mar 2020 21:23:18 -0800 Shannon Nelson wrote: =20
> >> Add support for an additional device id.
> >>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io> =20
> > I have thought about this for a while and I wanted to ask you to say
> > a bit more about the use of the management device.
> >
> > Obviously this is not just "additional device id" in the traditional
> > sense where device IDs differentiate HW SKUs or revisions. This is the
> > same exact hardware, just a different local feature (as proven by the
> > fact that you make 0 functional changes).
> >
> > In the past we (I?) rejected such extensions upstream from Netronome and
> > Cavium, because there were no clear use cases which can't be solved by
> > extending standard kernel APIs. Do you have any? =20
>=20
> Do you by chance have any references handy to such past discussions?=C2=
=A0=20
> I'd be interested in reading them to see what similarities and=20
> differences we have.

Here you go:

https://lore.kernel.org/netdev/20170718115827.7bd737f2@cakuba.netronome.com/

> The network device we present is only a portion of the DSC's functions.=
=C2=A0=20
> The device configuration and management for the various services is=20
> handled in userspace programs on the OS running inside the device.=C2=A0=
=20
> These are accessed through a secured REST API, typically through the=20
> external management ethernet port.=C2=A0 In addition to our centralized=20
> management user interface, we have a command line tool for managing the=20
> device configuration using that same REST interface.

We try to encourage vendors to create common interfaces, as you'd
understand that command line tool is raising red flags.

Admittedly most vendors have some form of command line tool which can
poke directly into registers, anyway, but IMHO we should avoid any
precedents of merging driver patches with explicit goal of enabling
such tools.

> In some configurations we make it possible to open a network connection=20
> into the device through the host PCI, just as if you were to connect=20
> through the external mgmt port.=C2=A0 This is the PCI deviceid that=20
> corresponds to that port, and allows use of the command line tool on the=
=20
> host.
>=20
> The host network driver doesn't have access to the device management=20
> commands, it only can configure the NIC portion for what it needs for=20
> passing network packets.

