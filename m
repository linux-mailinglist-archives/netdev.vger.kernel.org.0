Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA31E15BDD8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgBMLj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:39:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44204 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729544AbgBMLj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581593996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BqEF/LrcXh2qjF/i27Wpc802iprcxFS6blpTU9F6sLQ=;
        b=K4y1vkGbrUVk96sUI4C4Ycg2eYHuYWrjZdwBZCJpC+qi8mleWP68ihUcZrtOm+SpUdV2DF
        BdrNcRGyrvGNT1li5Q3rsqV34r99vvkiPL7awWpZbPxVAc1fvlqFNy17x9N1Gzeaci8HXS
        or8RTsllJIUpqdiBd4gPYAAHLZFqsfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-atmhJIhtMZ-6twLbxkpwLA-1; Thu, 13 Feb 2020 06:39:52 -0500
X-MC-Unique: atmhJIhtMZ-6twLbxkpwLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97708800D53;
        Thu, 13 Feb 2020 11:39:51 +0000 (UTC)
Received: from localhost (unknown [10.36.118.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0400960499;
        Thu, 13 Feb 2020 11:39:50 +0000 (UTC)
Date:   Thu, 13 Feb 2020 11:39:49 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <20200213113949.GA544499@stefanha-x1.localdomain>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
 <20200213094130.vehzkr4a3pnoiogr@steredhat>
 <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
 <20200213102237.uyhfv5g2td5ayg2b@steredhat>
 <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
MIME-Version: 1.0
In-Reply-To: <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2020 at 10:44:18AM +0000, Boeuf, Sebastien wrote:
> On Thu, 2020-02-13 at 11:22 +0100, Stefano Garzarella wrote:
> > On Thu, Feb 13, 2020 at 09:51:36AM +0000, Boeuf, Sebastien wrote:
> > > Hi Stefano,
> > >=20
> > > On Thu, 2020-02-13 at 10:41 +0100, Stefano Garzarella wrote:
> > > > Hi Sebastien,
> > > >=20
> > > > On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien wrote:
> > > > > From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17
> > > > > 00:00:00
> > > > > 2001
> > > > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > > > Date: Thu, 13 Feb 2020 08:50:38 +0100
> > > > > Subject: [PATCH] net: virtio_vsock: Fix race condition between
> > > > > bind
> > > > > and listen
> > > > >=20
> > > > > Whenever the vsock backend on the host sends a packet through
> > > > > the
> > > > > RX
> > > > > queue, it expects an answer on the TX queue. Unfortunately,
> > > > > there
> > > > > is one
> > > > > case where the host side will hang waiting for the answer and
> > > > > will
> > > > > effectively never recover.
> > > >=20
> > > > Do you have a test case?
> > >=20
> > > Yes I do. This has been a bug we've been investigating on Kata
> > > Containers for quite some time now. This was happening when using
> > > Kata
> > > along with Cloud-Hypervisor (which rely on the hybrid vsock
> > > implementation from Firecracker). The thing is, this bug is very
> > > hard
> > > to reproduce and was happening for Kata because of the connection
> > > strategy. The kata-runtime tries to connect a million times after
> > > it
> > > started the VM, just hoping the kata-agent will start to listen
> > > from
> > > the guest side at some point.
> >=20
> > Maybe is related to something else. I tried the following which
> > should be
> > your case simplified (IIUC):
> >=20
> > guest$ python
> >     import socket
> >     s =3D socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> >     s.bind((socket.VMADDR_CID_ANY, 1234))
> >=20
> > host$ python
> >     import socket
> >     s =3D socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> >     s.connect((3, 1234))
> >=20
> > Traceback (most recent call last):
> >   File "<stdin>", line 1, in <module>
> > TimeoutError: [Errno 110] Connection timed out
>=20
> Yes this is exactly the simplified case. But that's the point, I don't
> think the timeout is the best way to go here. Because this means that
> when we run into this case, the host side will wait for quite some time
> before retrying, which can cause a very long delay before the
> communication with the guest is established. By simply answering the
> host with a RST packet, we inform it that nobody's listening on the
> guest side yet, therefore the host side will close and try again.

My expectation is that TCP/IP will produce ECONNREFUSED in this case but
I haven't checked.  Timing out is weird behavior.

In any case, the reference for virtio-vsock semantics is:
1. How does VMCI (VMware) vsock behave?  We strive to be compatible with
the VMCI transport.
2. If there is no clear VMCI behavior, then we look at TCP/IP because
those semantics are expected by most applications.

This bug needs a test case in tools/testings/vsock/ and that test case
will run against VMCI, virtio-vsock, and Hyper-V.  Doing that will
answer the question of how VMCI handles this case.

Stefan

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5FNYUACgkQnKSrs4Gr
c8hLKgf/RygSyCBQ6rxoqS3PCSKcLMIAyt1Eb/1ufx9Zu1Z6y6syD+sWmQJ6L5W+
n7Wz81H5mDwfBtw2FCp/TVdq+Gu2hrgbuisGwSz6cOTSJdD8aJ2zOvMKLFXm2HTp
Q3M5/Ucrpjxh+PxYIyURLMIhkRjlUUwxem2SDtgTALHp9KcxJ7I7NqB8CVd3YJhV
HfkAdP/QZ6Zg5DTspHbk6jaWrOeGZZL30z2KuOMN8hlpBo26aDH0rPWI7OhVehTW
sFnLVle0cbek8VkM2yCcLKOs+zWGI72qbMRYT1BUip0AN+9NZnDqTZW0rg+lAHGz
gtenHbY/qqMociY9wdP2+BynoL5OZQ==
=tDWH
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

