Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7641661E4
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgBTQJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:09:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728493AbgBTQJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 11:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582214969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0UG+cOoT0dOaYOq82y8nTYuiMzBk1wCnSd0ILZAHXaM=;
        b=MwRG9lHzuB0m8Ja48nEjTj5lz9pi4ZAg0lk8WOytoy1F1FUY7p72H+5TF3JeRiDtIF6CYS
        4QPl71UzjIMhzh1j5P869QSIvb0qpmTnOoikAEzEh7c7IaXkF1jOjx5ODaZbf3FmHN5jhZ
        ZTHBYTwz80brdKjkONKxfGb4G24RsGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-bKtnoSVuPq6mhPOeJxvciA-1; Thu, 20 Feb 2020 11:09:19 -0500
X-MC-Unique: bKtnoSVuPq6mhPOeJxvciA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 305D81005512;
        Thu, 20 Feb 2020 16:09:18 +0000 (UTC)
Received: from lpt (unknown [10.43.2.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 291E260BE1;
        Thu, 20 Feb 2020 16:09:14 +0000 (UTC)
Date:   Thu, 20 Feb 2020 17:09:12 +0100
From:   =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     ted.h.kim@oracle.com, sgarzare@redhat.com, netdev@vger.kernel.org
Subject: Re: vsock CID questions
Message-ID: <20200220160912.GL3065@lpt>
References: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
 <20200219154317.GB1085125@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20200219154317.GB1085125@stefanha-x1.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HcXnUX77nabWBLF4"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--HcXnUX77nabWBLF4
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2020 at 03:43:17PM +0000, Stefan Hajnoczi wrote:
>On Tue, Feb 18, 2020 at 02:45:38PM -0800, ted.h.kim@oracle.com wrote:
>> 1. Is there an API to lookup CIDs of guests from the host side (in libvi=
rt)?
>
>I wonder if it can be queried from libvirt (at a minimum the domain XML
>might have the CID)?  I have CCed J=E1n Tomko who worked on the libvirt
>support:
>
>https://libvirt.org/formatdomain.html#vsock
>

Yes, libvirt has to know the CIDs of the guest and presents them in the
domain XML:
<domain type=3D'kvm'>
   <name>test</name>
   ...
   <devices>
     ...
     <vsock model=3D'virtio'>
       <cid auto=3D'no' address=3D'4'/>
       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x07' f=
unction=3D'0x0'/>
     </vsock>
   </devices>
</domain>

>> 2. In the vsock(7) man page, it says the CID might change upon migration=
, if
>> it is not available.
>> Is there some notification when CID reassignment happens?
>
>All established connections are reset across live migration -
>applications will notice :).
>
>Listen sockets stay open but automatically listen on the new CID.
>
>> 3. if CID reassignment happens, is this persistent? (i.e. will I see upd=
ated
>> vsock definition in XML for the guest)
>
>Another question for J=E1n.

Depends on the setting.
For <cid auto=3D'yes'/>, libvirt will try to acquire the first available CI=
D
for the guest and pass it to QEMU.
For <cid auto=3D'no'/>, no reassignment should happend and the CID
requested in the domain XML on the source will be used (or fail to be
used) on the destination.

Jano

>
>> 4. I would like to minimize the chance of CID collision. If I understand
>> correctly, the CID is a 32-bit unsigned. So for my application, it might
>> work to put an IPv4 address. But if I adopt this convention, then I need=
 to
>> look forward to possibly using IPv6. Anyway, would it be hard to potenti=
ally
>> expand the size of the CID to 64 bits or even 128?
>
>A little hard, since the struct sockaddr_vm that userspace applications
>use has a 32-bit CID field.  This is because the existing VMware VMCI
>vsock implementation has 32-bit CIDs.
>
>virtio-vsock is ready for 64-bit CIDs (the packet header fields are
>already 64-bit) but changes to net/vmw_vsock/ core code and to the
>userspace ABI would be necessary.
>
>Stefan



--HcXnUX77nabWBLF4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEQeJGMrnL0ADuclbP+YPwO/Mat50FAl5Orx0ACgkQ+YPwO/Ma
t50XvQgAoryev7ZyGjbqMqYrlkaDLSuPiYi57RbwfgrrxtCduinLS6Wi1DNPVmqA
YPVWsdz37SCCaa4PcuYQcMeBg2l3IxZHybn0s84JgEYEDqjmFXeBnX40yqXAXIIK
tiZxudfVtU9W9DRLf1JZoq0qDgwPPkT+qaDens0b0Yaf0/Di+ewrDf5fYZxij2N1
1Wbr8xKc/UdQZut/nO3neThmvD9g0eyzP9KLYyjDwSK33Q+TdK++h9iO+mfIS2PX
Ow91iZPvpWZERXaBq3u1FtFzR0PeqEEz+WvP19TZvw2+qwhryi2WVtZfjVd2VL7e
RawNom5JvZfUFkw1QhpZklkxvyZTMA==
=DrRx
-----END PGP SIGNATURE-----

--HcXnUX77nabWBLF4--

