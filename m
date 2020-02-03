Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6176A150EF9
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgBCRx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgBCRx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:53:27 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4530B2087E;
        Mon,  3 Feb 2020 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580752406;
        bh=+F911pBIa8UlZE0vunHO6BITHlbAp/snKVv81Rwfgu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yZNSUeOU9BuVDZG2NfZ2Cjbin6LdM35W5BRwsUTgG2fMGQpmbEIRG55wlqFO2Q1vb
         KZ03OAq6Q/zN85eIgsgOpx1N/Aw2Rg4CgvUUg7goyX16hRidDcTC32/9skI+kg/PKA
         XdgO+q/Pevl+hIOGqxPWBzNuO70YsRXXDwtYhRI8=
Date:   Mon, 3 Feb 2020 09:53:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate
 ioctl for device
Message-ID: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <9624aebf-edb9-a3b0-1a29-b61df6b7ba2f@xenosoft.de>
References: <20200126115247.13402-1-mpe@ellerman.id.au>
        <CAPDyKFrbYmV6_nV6psVLq6VRKMXf0PXpemBbj48yjOr3P130BA@mail.gmail.com>
        <58a6d45c-0712-18df-1b14-2f04cf12a1cb@xenosoft.de>
        <75aab3c9-1cb6-33bf-5de1-e05bbd98b6fb@c-s.fr>
        <9624aebf-edb9-a3b0-1a29-b61df6b7ba2f@xenosoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 16:02:18 +0100, Christian Zigotzky wrote:
> On 02 February 2020 at 09:19 am, Christophe Leroy wrote:
> > Hello,
> >
> > Le 02/02/2020 =C3=A0 01:08, Christian Zigotzky a =C3=A9crit=C2=A0: =20
> >> Hello,
> >>
> >> We regularly compile and test Linux kernels every day during the=20
> >> merge window. Since Thuesday we have very high CPU loads because of=20
> >> the avahi daemon on our desktop Linux systems (Ubuntu, Debian etc).
> >>
> >> Error message: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for=20
> >> device =20
> >
> > Do you know which ioctl, on which device ?
> > Can you take a trace of running avahi-daemon with 'strace' ?
> >
> > Can you bisect ?
> >
> > Christophe =20
> Hi Christophe,
> Hi All,
>=20
> I figured out that the avahi-daemon has a problem with the IPv6 address=20
> of a network interface since the Git kernel from Thursday. (Log attached)
> This generates high CPU usage because the avahi-daemon tries to access=20
> the IPv6 address again and again and thereby it produces a lot of log=20
> messages.
>=20
> We figured out that the networking updates aren't responsible for this=20
> issue because we created a test kernel on Wednesday. The issue is=20
> somewhere in the commits from Wednesday night to Thursday (CET).

FWIW Thursday is when the latest networking pull came in, so could well
be networking related..

> Please compile the latest Git kernel and test it with a desktop linux=20
> distribution for example Ubuntu. In my point of view there are many=20
> desktop machines affected. Many server systems don't use the avahi=20
> daemon so they aren't affected.
>=20
> It's possible to deactivate the access to the IPv6 address with the=20
> following line in the file "/etc/avahi/avahi-daemon.conf":
>=20
> use-ipv6=3Dno
>=20
> After a reboot the CPU usage is normal again. This is only a temporary=20
> solution.
>=20
> Unfortunately I don't have the time for bisecting next week. I have a=20
> lot of other work to do. In my point of view it is very important that=20
> you also compile the latest Git kernels. Then you will see the issue and=
=20
> then you have a better possibility to fix the issue.
