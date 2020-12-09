Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1897F2D47FD
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgLIRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730557AbgLIRbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 12:31:01 -0500
Date:   Wed, 9 Dec 2020 09:30:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607535020;
        bh=Bbrzj01ZfSyc3zurT/13804zu1FtDXKIyP3uYFUIMrk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=olfavIKOeosdwBo2O6z6nWXqXd1Rbt310WInzuv8Tqxl1uL9FnKegA8FBZDzF1Fwf
         rC/N4Uu0vgDhS9tFvwSQSYTYc/dlt1y5tP6m63/u3HArICCWHGaE/4M0RSTURt1iby
         vVxUA2ShC4gU97ubc52pB524KJcvljhQEigLtzMR6sD7biAnUpHtGkNp6u8nNY7Wlb
         e5W4mhe4vt+jvVZfIh3Ml/l6U0hpCB6jp1BHBvocVy64BsXnf9YDWK8poY+Ocj7wKf
         ko+WqWdldxM9qX3rSn8mhiSld6oaepwKvAwgVuUZiqhBKhAvT9Kz2n1sPs/T2P1n4p
         71go1ZDPEpzQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
Message-ID: <20201209093019.1caae20e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <4f2a1ac5-68c7-190f-6abf-452f67b3a7f4@amazon.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
        <20201204170235.84387-2-andraprs@amazon.com>
        <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
        <20201208104222.605bb669@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201209104806.qbuemoz3oy6d3v3b@steredhat>
        <4f2a1ac5-68c7-190f-6abf-452f67b3a7f4@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 17:17:56 +0200 Paraschiv, Andra-Irina wrote:
> > I agree that could be a problem, but here some considerations:
> > - I checked some applications (qemu-guest-agent, ncat, iperf-vsock) and
> > =C2=A0 all use the same pattern: allocate memory, initialize all the
> > =C2=A0 sockaddr_vm to zero (to be sure to initialize the svm_zero), set=
 the
> > =C2=A0 cid and port fields.
> > =C2=A0 So we should be safe, but of course it may not always be true.
> >
> > - For now the issue could affect only nested VMs. We introduced this
> > =C2=A0 support one year ago, so it's something new and maybe we don't c=
ause
> > =C2=A0 too many problems.
> >
> > As an alternative, what about using 1 or 2 bytes from svm_zero[]?
> > These must be set at zero, even if we only check the first byte in the
> > kernel. =20
>=20
> Thanks for the follow-up info.
>=20
> We can also consider the "svm_zero" option and could use 2 bytes from=20
> that field for "svm_flags", keeping the same "unsigned short" type.

Or use svm_zero as a gate for interpreting other fields?
If svm_zero[0]* =3D=3D something start checking the value of reserved1?
* in practice the name can be unioned to something more palatable ;)
