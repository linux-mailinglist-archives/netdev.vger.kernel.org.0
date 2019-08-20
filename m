Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2F95976
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfHTI2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfHTI2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 04:28:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 368D4300180E;
        Tue, 20 Aug 2019 08:28:30 +0000 (UTC)
Received: from localhost (ovpn-117-123.ams2.redhat.com [10.36.117.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A490C5D9D5;
        Tue, 20 Aug 2019 08:28:29 +0000 (UTC)
Date:   Tue, 20 Aug 2019 09:28:28 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] vsock_test: wait for the remote to close the
 connection
Message-ID: <20190820082828.GA9855@stefanha-x1.localdomain>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-12-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20190801152541.245833-12-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 20 Aug 2019 08:28:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2019 at 05:25:41PM +0200, Stefano Garzarella wrote:
> +/* Wait for the remote to close the connection */
> +void vsock_wait_remote_close(int fd)
> +{
> +	struct epoll_event ev;
> +	int epollfd, nfds;
> +
> +	epollfd =3D epoll_create1(0);
> +	if (epollfd =3D=3D -1) {
> +		perror("epoll_create1");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ev.events =3D EPOLLRDHUP | EPOLLHUP;
> +	ev.data.fd =3D fd;
> +	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1) {
> +		perror("epoll_ctl");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	nfds =3D epoll_wait(epollfd, &ev, 1, TIMEOUT * 1000);
> +	if (nfds =3D=3D -1) {
> +		perror("epoll_wait");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (nfds =3D=3D 0) {
> +		fprintf(stderr, "epoll_wait timed out\n");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	assert(nfds =3D=3D 1);
> +	assert(ev.events & (EPOLLRDHUP | EPOLLHUP));
> +	assert(ev.data.fd =3D=3D fd);
> +
> +	close(epollfd);
> +}

Please use timeout_begin()/timeout_end() so that the test cannot hang.

> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock=
_test.c
> index 64adf45501ca..a664675bec5a 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -84,6 +84,11 @@ static void test_stream_client_close_server(const stru=
ct test_opts *opts)
> =20
>  	control_expectln("CLOSED");
> =20
> +	/* Wait for the remote to close the connection, before check
> +	 * -EPIPE error on send.
> +	 */
> +	vsock_wait_remote_close(fd);

Is control_expectln("CLOSED") still necessary now that we're waiting for
the poll event?  The control message was an attempt to wait until the
other side closed the socket.

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1brywACgkQnKSrs4Gr
c8he/ggAs417RXraEFHwXmiz0k0MOniGzChyB01FvERBmU5Q3lFaA9yTm3CfBmeM
dsWmGaQ+UcV0T+BvE+Y+oUV6lspdjNMX2D02+Xfl9SNwKh1CGxmipyRSsITapVXg
9wFwZzD/+IJ6bSzUxyYpPZhb0n1cZNnMnB0hpTFGSvJMrbk/phSv3NVd7LrJVuM2
uTYaoaFXQ4QTPnnVO7JonGbeHJuinIleByziLGaCCDgeEan9gf48eQPsN1Pvhf+g
/YjmlJEqbpekU8wpwggoRFZ9UlkbiLhbCtZdvE7Kzj9PaS1DSF+AWLdL9fOa+N1K
jNvf8bhepUvIw0MgGeM/Az9vsHfFZw==
=E1TQ
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
