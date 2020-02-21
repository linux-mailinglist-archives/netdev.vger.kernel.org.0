Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B6166BB1
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgBUAht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729365AbgBUAhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 19:37:48 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7892D207FD;
        Fri, 21 Feb 2020 00:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582245467;
        bh=XL7WQxZVUTlmWE97m7kM32+z1sfefuhUPekCihzZ3kQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQxYIwZuCEzs4j5COcQLId4zCH8WSLmGMYwdXbWXwRXZWxmJajDplboOChtzNeYaR
         4M1JjUEIoJbanlnzem+IcCMoeM5JgqMsHi5+aPImHwZcRyNPXtbd3g6AydrD/bZ4fx
         WtKu/5pvy0z1c5cAIRE+wofCg2z7g5+iuG3Faa7c=
Date:   Thu, 20 Feb 2020 16:37:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "it+linux-netdev@molgen.mpg.de" <it+linux-netdev@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [EXT] Re: bnx2x: Latest firmware requirement breaks no
 regression policy
Message-ID: <20200220163739.0bc51e4c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <DM5PR18MB221508B070C5C2DAE8ADB053C4130@DM5PR18MB2215.namprd18.prod.outlook.com>
References: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
        <MN2PR18MB2528C681601B34D05100DF89D3100@MN2PR18MB2528.namprd18.prod.outlook.com>
        <8daadcd1-3ff2-2448-7957-827a71ae4d2e@molgen.mpg.de>
        <MN2PR18MB2528EC91E410FD1BE9FC3EF5D3130@MN2PR18MB2528.namprd18.prod.outlook.com>
        <DM5PR18MB221508B070C5C2DAE8ADB053C4130@DM5PR18MB2215.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 15:40:37 +0000 Ariel Elior wrote:
> > -----Original Message-----
> > From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Sent: Thursday, February 20, 2020 11:17 AM
> > To: Paul Menzel <pmenzel@molgen.mpg.de>; Ariel Elior
> > <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-linux- =20
> > l2@marvell.com> =20
> > Cc: netdev@vger.kernel.org; LKML <linux-kernel@vger.kernel.org>; it+lin=
ux-
> > netdev@molgen.mpg.de; David S. Miller <davem@davemloft.net>
> > Subject: RE: [EXT] Re: bnx2x: Latest firmware requirement breaks no reg=
ression
> > policy
> >=20
> > Hi Paul,
> >     Bnx2x driver and the storm FW are tightly coupled, and the info is =
exchanged
> > between them via shmem (i.e., common structures which might change
> > between the releases). Also, FW provides some offset addresses to the d=
river
> > which could change between the FW releases, following is one such commi=
t,
> > 	https://www.spinics.net/lists/netdev/msg609889.html
> > Hence it's not very straight forward to provide the backward compatibil=
ity i.e.,
> > newer (updated) kernel driver with the older FW.
> > Currently we don=E2=80=99t have plans to implement the new model mentio=
ned below.
> >=20
> Hi,
> There are additional reasons why backwards/forwards compatibility conside=
rations
> are not applicable here. This Fw is not nvram based, and does not reside =
in the
> device. It is programed to the device on every driver load. The driver wi=
ll
> never face a device "already initialized" with a version of FW it is not
> familiar with.

How do you deal with VFs?

> The device also has traditional management FW in nvram in the device with=
 which
> we have a backwards and forwards compatibility mechanism, which works just
> fine.
> But the FW under discussion is fastpath Fw, used to craft every packet go=
ing out
> of the device and analyze and place every packet coming into the device.
> Supporting multiple versions of FW would be tantamount to implementing do=
zens of
> versions of start_xmit and napi_poll in the driver (not to mention multip=
le
> fastpath handles of all the offloads the device supports, roce, iscsi, fc=
oe and
> iwarp, as all of these are offloaded by the FW).
> The entire device initialization sequence also changes significantly from=
 one FW
> version to the Next. All of these differences are abstracted away in the =
FW
> file, which includes the init sequence and the compiled FW. The amount of
> changes required in driver are very significant when moving from one vers=
ion to
> the next. Trying to keep all those versions alive concurrently would caus=
e this
> already very large driver to be 20x larger.

All your points are disproved by all the devices which have drivers
upstream and don't break backward compatibility on every release.

> We don't have a method of keeping the device operational if the kernel was
> upgraded but firmware tree was not updated. The best that can be done is =
report
> the problem, which is what we do.
