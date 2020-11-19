Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9E2B9411
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgKSOEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbgKSOEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605794646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5i0QQLQYjbLsqpaS34Eui+z4V/aK5oQzbMdDLABiWqk=;
        b=UYrsF5wU+5fkOfmtigTy/pY+OIGuPNAYZ/0LE+FnETTqPTzTqAfnBvz0PjjUNA6gn7VX67
        UGJs29lwqkMNOUPWMtkgW0UT5AGW4cfLHMxkYIiv+D3xQnFoYKqDXSF/qp/5QbAOVdyf7z
        +xR7FuDYYW6PGzihnANWZEqJK0kR4EQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-3e9V50SVNvWmnv3lUDd_rQ-1; Thu, 19 Nov 2020 09:04:04 -0500
X-MC-Unique: 3e9V50SVNvWmnv3lUDd_rQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38165107ACE3;
        Thu, 19 Nov 2020 14:04:02 +0000 (UTC)
Received: from localhost (ovpn-115-68.ams2.redhat.com [10.36.115.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A9ED19D80;
        Thu, 19 Nov 2020 14:04:00 +0000 (UTC)
Date:   Thu, 19 Nov 2020 14:03:59 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Anthony Liguori <aliguori@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Graf <graf@amazon.de>
Subject: Re: [PATCH net] vsock: forward all packets to the host when no H2G
 is registered
Message-ID: <20201119140359.GE838210@stefanha-x1.localdomain>
References: <20201112133837.34183-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201112133837.34183-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 02:38:37PM +0100, Stefano Garzarella wrote:
> Before commit c0cfa2d8a788 ("vsock: add multi-transports support"),
> if a G2H transport was loaded (e.g. virtio transport), every packets
> was forwarded to the host, regardless of the destination CID.
> The H2G transports implemented until then (vhost-vsock, VMCI) always
> responded with an error, if the destination CID was not
> VMADDR_CID_HOST.
>=20
> From that commit, we are using the remote CID to decide which
> transport to use, so packets with remote CID > VMADDR_CID_HOST(2)
> are sent only through H2G transport. If no H2G is available, packets
> are discarded directly in the guest.
>=20
> Some use cases (e.g. Nitro Enclaves [1]) rely on the old behaviour
> to implement sibling VMs communication, so we restore the old
> behavior when no H2G is registered.
> It will be up to the host to discard packets if the destination is
> not the right one. As it was already implemented before adding
> multi-transport support.
>=20
> Tested with nested QEMU/KVM by me and Nitro Enclaves by Andra.
>=20
> [1] Documentation/virt/ne_overview.rst
>=20
> Cc: Jorgen Hansen <jhansen@vmware.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-by: Andra Paraschiv <andraprs@amazon.com>
> Tested-by: Andra Paraschiv <andraprs@amazon.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+2e08ACgkQnKSrs4Gr
c8jnpAf/ZlfAs5UL1VEQIlS5BEGEE+bicGoAleU1Yh5k7eUzzORP8xdTs4yYcgFL
/xMVz10txbvI76GY3XmqVo6Ozo59vb6fpitwugFkKaj68PtFvrtYphdEEcbr8zXz
K6/5OXeODb/V+7ZGTmXaJbBwQt7gUpTPaDdIqRVg+IPySeVPFv3AFuO8CnUb9h6u
zJ+ApyCa286w8y8ZuUv14QZ2hVxh6GxSt7VM8Z0iMCLzv3HwQc/esv1A2Hpx+OFv
qAaR8olM9gZ4jdWMBWaPL6pWQ2EPqeLCsb4bAOfGdb2+4oVyk/Um/AKiOaCzt+D1
3aEgST74NbQjYmSzdWDr9pknnxCeyw==
=YQlg
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--

