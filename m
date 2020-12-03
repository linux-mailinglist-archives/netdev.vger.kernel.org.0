Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5722CD2F9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbgLCJx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:53:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388361AbgLCJx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:53:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606989121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v9EA7ZkqWocNMQm5AHpWfd2/JFrTgb4TxAWHCKNyBbI=;
        b=ipN3ubARHCZCxJg3P4sKrCJZvLpAKfpqtZhY9hqk2lczrXsTwVpVejazoouSAGif3C4VGP
        mKgOTj4bzVISVbmWKlgqGckovZzdLD1s9Yo6MDs9kGE4BuD+sstzsgj2JZi3LD9lSZ/TtH
        kyKZ/G6PK70RyLjc2ci91n2GgFGW540=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-U4VJUIxnPGCAYaLhNQTzQQ-1; Thu, 03 Dec 2020 04:51:58 -0500
X-MC-Unique: U4VJUIxnPGCAYaLhNQTzQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BBB7100C671;
        Thu,  3 Dec 2020 09:51:56 +0000 (UTC)
Received: from localhost (ovpn-115-46.ams2.redhat.com [10.36.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C61C60C8B;
        Thu,  3 Dec 2020 09:51:37 +0000 (UTC)
Date:   Thu, 3 Dec 2020 09:21:55 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
Message-ID: <20201203092155.GB687169@stefanha-x1.localdomain>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20201201152505.19445-2-andraprs@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 01, 2020 at 05:25:03PM +0200, Andra Paraschiv wrote:
> vsock enables communication between virtual machines and the host they
> are running on. With the multi transport support (guest->host and
> host->guest), nested VMs can also use vsock channels for communication.
>=20
> In addition to this, by default, all the vsock packets are forwarded to
> the host, if no host->guest transport is loaded. This behavior can be
> implicitly used for enabling vsock communication between sibling VMs.
>=20
> Add a flag field in the vsock address data structure that can be used to
> explicitly mark the vsock connection as being targeted for a certain
> type of communication. This way, can distinguish between nested VMs and
> sibling VMs use cases and can also setup them at the same time. Till
> now, could either have nested VMs or sibling VMs at a time using the
> vsock communication stack.
>=20
> Use the already available "svm_reserved1" field and mark it as a flag
> field instead. This flag can be set when initializing the vsock address
> variable used for the connect() call.
>=20
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sock=
ets.h
> index fd0ed7221645d..58da5a91413ac 100644
> --- a/include/uapi/linux/vm_sockets.h
> +++ b/include/uapi/linux/vm_sockets.h
> @@ -114,6 +114,22 @@
> =20
>  #define VMADDR_CID_HOST 2
> =20
> +/* This sockaddr_vm flag value covers the current default use case:
> + * local vsock communication between guest and host and nested VMs setup=
.
> + * In addition to this, implicitly, the vsock packets are forwarded to t=
he host
> + * if no host->guest vsock transport is set.
> + */
> +#define VMADDR_FLAG_DEFAULT_COMMUNICATION=090x0000
> +
> +/* Set this flag value in the sockaddr_vm corresponding field if the vso=
ck
> + * channel needs to be setup between two sibling VMs running on the same=
 host.
> + * This way can explicitly distinguish between vsock channels created fo=
r nested
> + * VMs (or local communication between guest and host) and the ones crea=
ted for
> + * sibling VMs. And vsock channels for multiple use cases (nested / sibl=
ing VMs)
> + * can be setup at the same time.
> + */
> +#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION=090x0001

vsock has the h2g and g2h concept. It would be more general to call this
flag VMADDR_FLAG_G2H or less cryptically VMADDR_FLAG_TO_HOST.

That way it just tells the driver in which direction to send packets
without implying that sibling communication is possible (it's not
allowed by default on any transport).

I don't have a strong opinion on this but wanted to suggest the idea.

Stefan

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/IrjMACgkQnKSrs4Gr
c8iRkQf/cLe2nGdZXOK+p6q9qHT+yuEfCIHqPuNwESMdwikDzguJGsRxF876JSnX
l6bwl/kxdRR9w/zWBswEqokg9pAC/6Pi81fdjKat0icFIVpNq7333tFKTDc1C9bs
D3aPDnN/3Jx13rCy9SsrkEy2SBz7sAQXytgOvrckvbFQ2SrzX861cigpLnwSwiG4
1MhvZixDcGtUPmlWYBTRxhf8v0zxMe1XTNo55dwUlwU60h9/hVFiSNnbHPYhfTHJ
AdcJUWHmhBE5/s11LVtTVKiigMWQh+0fbrN6Id9qTVKGHANRutBTSCo5kw6eGFhi
nB8+U4TqkIDLcxDseQHQi902x79CwA==
=1UwU
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--

