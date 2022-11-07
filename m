Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7161FFE8
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiKGU5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiKGU5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:57:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED682B622
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 12:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667854567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=p+9lgL7H2RIGtfkSoGTjpiKZE0I9zaPI5GTcWtttsjQ=;
        b=F48/G5PzftlLgn2qXwxQF06kFU8UMfaGneeWnl3NsEUgvlE7YtQFhdn/cc8nXflxk5mYEP
        81Nf2+5OeEJTOrmhTPupm58CELFeJeeVXi4c6WqbYANzYXZk+371qvpcn4Nn//MDBs1qG5
        hX4o3hkqs+kwbsHM8x/W34ocQRkNP08=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-iEq1w5kIOlK6GvW4vDu2-w-1; Mon, 07 Nov 2022 15:56:04 -0500
X-MC-Unique: iEq1w5kIOlK6GvW4vDu2-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A2D93833287;
        Mon,  7 Nov 2022 20:56:03 +0000 (UTC)
Received: from localhost (unknown [10.39.194.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E64F140EBF5;
        Mon,  7 Nov 2022 20:56:02 +0000 (UTC)
Date:   Mon, 7 Nov 2022 15:56:01 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Message-ID: <Y2lw4Qc1uI+Ep+2C@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XyBYP9056XoM9x6e"
Content-Disposition: inline
In-Reply-To: <20221030220203.31210-1-axboe@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XyBYP9056XoM9x6e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jens,
NICs and storage controllers have interrupt mitigation/coalescing
mechanisms that are similar.

NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
(counter) value. When a completion occurs, the device waits until the
timeout or until the completion counter value is reached.

If I've read the code correctly, min_wait is computed at the beginning
of epoll_wait(2). NVMe's Aggregation Time is computed from the first
completion.

It makes me wonder which approach is more useful for applications. With
the Aggregation Time approach applications can control how much extra
latency is added. What do you think about that approach?

Stefan

--XyBYP9056XoM9x6e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNpcOEACgkQnKSrs4Gr
c8gDagf/YbI6zJoHxLPIL1cGSlayG7NOYya+8Vp+4dfv13V7/ZD6T/RQLJ0xhPhL
OZZ7TJ0zdOQL7a0J3RxUElcs06gIh7IHupL0YvX9ng0mVNl8DwkfsuLWdxj5Z2x/
gLD1YjCPHHAEwzHOcma7QR1I36SfxJhXSiyCUNhB3VF4jl9EZV2LIrA1fEUD4MBY
PNqILWWv81tm93jAFe1JrT/Ak20psPMXRIBfIkWkZfeH4totmbcUEoZLgV8HS4kF
kEodTyZGwS6kUt7512BC/CDXaiMi3XinLwjqJ42vq+jIHWxEfjwcEMa7KJpL6dg5
ULilMUkNtaXoeqzicuOv2m+qm3TqxQ==
=lz3z
-----END PGP SIGNATURE-----

--XyBYP9056XoM9x6e--

