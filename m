Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D034621484
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiKHOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbiKHOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:01:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C564E66C8E
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667916057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CRc6Q92Am3gX3kuAaNMjQgOFTnjBAQmsAw/cb2BaoNM=;
        b=PMAODJ4vks8a/KiLrIet6CscRz/gjNsiLyxL/hNajIPx0V70ilfktqvtHh6Z+qHMs7JNKL
        TKn0dtenE/XG2Vr6KCHYoSjbMVPboW0XYCy6zkVwzkSciBamoREQlop+cCHyJLt6DwuRy5
        DWdLDKtuz6M6jUtrJEejpWze+TWLZas=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-FRVtsv-OPXWPTNkXvXuYkw-1; Tue, 08 Nov 2022 09:00:54 -0500
X-MC-Unique: FRVtsv-OPXWPTNkXvXuYkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9563D100EDC3;
        Tue,  8 Nov 2022 14:00:53 +0000 (UTC)
Received: from localhost (unknown [10.39.195.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C41E340C94AD;
        Tue,  8 Nov 2022 14:00:52 +0000 (UTC)
Date:   Tue, 8 Nov 2022 09:00:49 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Message-ID: <Y2phEZKYuSmPL5B5@fedora>
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hTnBuHsELfudnVi0"
Content-Disposition: inline
In-Reply-To: <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hTnBuHsELfudnVi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
> > Hi Jens,
> > NICs and storage controllers have interrupt mitigation/coalescing
> > mechanisms that are similar.
>=20
> Yep
>=20
> > NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
> > (counter) value. When a completion occurs, the device waits until the
> > timeout or until the completion counter value is reached.
> >=20
> > If I've read the code correctly, min_wait is computed at the beginning
> > of epoll_wait(2). NVMe's Aggregation Time is computed from the first
> > completion.
> >=20
> > It makes me wonder which approach is more useful for applications. With
> > the Aggregation Time approach applications can control how much extra
> > latency is added. What do you think about that approach?
>=20
> We only tested the current approach, which is time noted from entry, not
> from when the first event arrives. I suspect the nvme approach is better
> suited to the hw side, the epoll timeout helps ensure that we batch
> within xx usec rather than xx usec + whatever the delay until the first
> one arrives. Which is why it's handled that way currently. That gives
> you a fixed batch latency.

min_wait is fine when the goal is just maximizing throughput without any
latency targets.

The min_wait approach makes it hard to set a useful upper bound on
latency because unlucky requests that complete early experience much
more latency than requests that complete later.

Stefan

--hTnBuHsELfudnVi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNqYREACgkQnKSrs4Gr
c8j6IAgAm0QuhdsF3vs+1ncuRN5NYEZR5+zZERrQFEnMQhQmAHn/muP+4tm7MlIT
LTqG5r89ymGz+LSyEUPJ8T9NnoLBoyyrTtrz9TpCk9SICPO7jPgiPTMf69quEO6j
h0pRVntr50Q9neNYG5J+zErj9TYz6cO1qAwm3903cmGti1I8IM4fjKCN+cPQmqoJ
rkfmh4PKOYxfNLVmKjSrdlF47ouFpRV3mpIZYJbejmg0CzSPwZ1is2slHVptRhsX
6HhnxvExdDKsjFORf6boC/Z/YodUbAzdMo+9B6uZH9BEz52EXFK+Inn4Kan0yvT2
vbeMPMmnzuCjpKMv5E2VMClg0EtBZg==
=Bq7R
-----END PGP SIGNATURE-----

--hTnBuHsELfudnVi0--

