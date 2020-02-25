Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480BB16BF9B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 12:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgBYLaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 06:30:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729296AbgBYLaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 06:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582630220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8wgvrETqdiZw+TCS8TmrOLHtx9YLv1MswVjc/0eKKxw=;
        b=DmD8D6lUsmHalzPWC7hK90HSnTEnJ0MhwiM/lzKMdPZxLxj9GyPfPYfBFlD52WkQyP3OVw
        23U0hlmKVtG6yxXT/m1UZFZ5voo/U9ItPGCa/DYsSIP3BD4ZegbL+vAtHjklcQ6oEejDi2
        aEkorgIgS6Bp6lEqK/qfS4yFjV0cHkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-LoNb2JGGNlGEWYPNPq9rSw-1; Tue, 25 Feb 2020 06:30:18 -0500
X-MC-Unique: LoNb2JGGNlGEWYPNPq9rSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F4028017CC;
        Tue, 25 Feb 2020 11:30:17 +0000 (UTC)
Received: from lpt (unknown [10.43.2.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6320F8B755;
        Tue, 25 Feb 2020 11:30:13 +0000 (UTC)
Date:   Tue, 25 Feb 2020 12:30:10 +0100
From:   =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
To:     ted.h.kim@oracle.com
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        netdev@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: vsock CID questions
Message-ID: <20200225113010.GH1133033@lpt>
References: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
 <20200219154317.GB1085125@stefanha-x1.localdomain>
 <20200220160912.GL3065@lpt>
 <b08eda42-9cc7-7a9a-b5b1-5adc44050896@oracle.com>
MIME-Version: 1.0
In-Reply-To: <b08eda42-9cc7-7a9a-b5b1-5adc44050896@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v2Uk6McLiE8OV1El"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--v2Uk6McLiE8OV1El
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2020 at 11:49:06AM -0800, ted.h.kim@oracle.com wrote:
>Hi Jan,
>
>Thanks for responding - let me see if I am understanding correctly.
>
>
>I think you are saying on migration the process of determining the CID=20
>assigned is the same as when you start a domain.
>
><cid auto=3D'yes'> means assignment to the first available value.
>It also seems for auto=3D'yes' that any address=3D'<value>' part of the=20
>CID definition is ignored, even as a suggested value.
>(I always get CID 3 when starting auto=3D'yes' and no other domains have=
=20
>started, even if there is an specific address in the definition, e.g.=20
>address=3D'12'.)
>
>But if auto=3D'no', either the domain gets the address field value or if=
=20
>the value is already assigned, the domain will fail to start/migrate.
>
>Is that right?
>

Yes.

>
>In cases, where auto=3D'yes', it does not seem that the host/hypervisor=20
>can find out what CID value was assigned to a domain. Even parsing the=20
>XML only reveals that it was auto-assigned and no specific value can=20
>be determined.

The value is not recorded in the inactive XML, but after domain startup,
the address should be visible in the live XML:

   <vsock model=3D"virtio">
     <cid auto=3D"yes" address=3D"3"/>
     <alias name=3D"vsock0"/>
     <address type=3D"pci" domain=3D"0x0000" bus=3D"0x07" slot=3D"0x00" fun=
ction=3D"0x0"/>
   </vsock>

>
>Is this correct?
>
>If this is the case, I would advocate for a specific API which can=20
>lookup the current CID of a domain.

This can already be queried from the XML through virDomainGetXMLDesc:
$ virsh dumpxml libvirt-fedora-31 | xmllint --xpath 'string(//cid/@address)=
' -
3

Jano

>Otherwise the host/hypervisor cannot tell which=A0 auto=3D'yes' domain is=
=20
>on the other end of the connected socket, when there is more than one.
>
>
>Thanks.
>-ted
>
>

--v2Uk6McLiE8OV1El
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEQeJGMrnL0ADuclbP+YPwO/Mat50FAl5VBT8ACgkQ+YPwO/Ma
t52mMAgAreHfNtvGp8PJAyCxCp5YqXwLisHQt8uEoXV0HHQoKglZz3U5xPSK/HqC
uC4L7VpxkR6JlFXwQjsvFv63qEoI78m2YCdmjfyOkRQZJLBrIRdeC692fzLP0tc3
No1YHLm4dg5Vs3X+YATPsl8cOGlhpr422oOmMBJGNO/TC9xvxlQ6paIFhbBL29YV
E89aM0dsoOL814qFAUDXHgwzK1BshiywJnxlkc25pTaZGtpcu/olabOcgDOMVyrH
lJ1tNE1qtYqjM08v870uzB+288S9HsxHwBda6lP8LPXUL7JOvFz7q1gOyVZzgzjb
weZ76sp6TN8hzxxXtwFXKxocKSDgMQ==
=Jwb7
-----END PGP SIGNATURE-----

--v2Uk6McLiE8OV1El--

