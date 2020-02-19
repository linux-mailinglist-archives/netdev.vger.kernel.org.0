Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48B9164D28
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBSR6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:58:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25522 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726609AbgBSR6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582135095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LKDutra/o/+z8ZhmALRmpbiOcJAVWuAQ1eDc4vKGtuo=;
        b=chPWWvH3GiutxiVLdJwR3yIH2w3E4zg4klTqiDEzgAHraeh5B2OMdZAHIm1yxmQVEY+3Jb
        si3wfovqRh/mMxnfB6JO9yQHhHdKk2apUUeU3BJJEJ0sK9JjIYHujp4PimROaolOS7k2I/
        eMFRQdtL+ZPhopFj+BX8jXzumyBYZiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-0ccbkxvDOaKJCtmg5XZO-Q-1; Wed, 19 Feb 2020 12:58:08 -0500
X-MC-Unique: 0ccbkxvDOaKJCtmg5XZO-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7C68189F762;
        Wed, 19 Feb 2020 17:58:05 +0000 (UTC)
Received: from localhost (unknown [10.36.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5C85C8A6;
        Wed, 19 Feb 2020 17:58:05 +0000 (UTC)
Date:   Wed, 19 Feb 2020 15:43:17 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     ted.h.kim@oracle.com
Cc:     sgarzare@redhat.com, netdev@vger.kernel.org,
        =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Subject: Re: vsock CID questions
Message-ID: <20200219154317.GB1085125@stefanha-x1.localdomain>
References: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
MIME-Version: 1.0
In-Reply-To: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2020 at 02:45:38PM -0800, ted.h.kim@oracle.com wrote:
> 1. Is there an API to lookup CIDs of guests from the host side (in libvir=
t)?

I wonder if it can be queried from libvirt (at a minimum the domain XML
might have the CID)?  I have CCed J=E1n Tomko who worked on the libvirt
support:

https://libvirt.org/formatdomain.html#vsock

> 2. In the vsock(7) man page, it says the CID might change upon migration,=
 if
> it is not available.
> Is there some notification when CID reassignment happens?

All established connections are reset across live migration -
applications will notice :).

Listen sockets stay open but automatically listen on the new CID.

> 3. if CID reassignment happens, is this persistent? (i.e. will I see upda=
ted
> vsock definition in XML for the guest)

Another question for J=E1n.

> 4. I would like to minimize the chance of CID collision. If I understand
> correctly, the CID is a 32-bit unsigned. So for my application, it might
> work to put an IPv4 address. But if I adopt this convention, then I need =
to
> look forward to possibly using IPv6. Anyway, would it be hard to potentia=
lly
> expand the size of the CID to 64 bits or even 128?

A little hard, since the struct sockaddr_vm that userspace applications
use has a 32-bit CID field.  This is because the existing VMware VMCI
vsock implementation has 32-bit CIDs.

virtio-vsock is ready for 64-bit CIDs (the packet header fields are
already 64-bit) but changes to net/vmw_vsock/ core code and to the
userspace ABI would be necessary.

Stefan

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5NV5UACgkQnKSrs4Gr
c8jKrggAlMuF11eyO9PrRXk5NgUCcSAc4DTrbClxRoZcRUmaB4a0+2AdDay0jwyU
ON3Xs6NrOmK1psje6xdSZcvUV0JXG3FL3oDm2qpQqu96Ejh6iTLXJMIgTRHYEYN1
a+b7QEp5URa84kXnPzbJcuYilb27MMVJyyo6p+jwnLy1BhR3EMuf+QsZ/Ojylsi+
Y4NfNxuYs8ikLWtzcmNzZXIq2vqPZmBtL4q65CHACjaO/m+tgaWshOwuURW5MA1x
qwa76SAg8cqbGPi/VwaYHzVzFVPDuBwJKXkvjQEcT/5Rht8sSv5sLUuLrc3F8z1o
xbl+gBdnIZiXqIgS6U5/mJQw1ZBMMg==
=QsCK
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--

