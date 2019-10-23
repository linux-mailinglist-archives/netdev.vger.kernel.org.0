Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3A5E229C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbfJWSi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:38:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729098AbfJWSi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571855935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/itk9NT3WTqhqelVjYWvcwlY7mTycaYYTUmADc+Eqw=;
        b=ZKSgvL8/dTIOxHMuPuPTuZ0G/g+MpVqGI3SsrN2HkUqEI20bJz5iA9OneGv40hV/0tm/JS
        xZWj197MyOKCMVZJtktpf0k2f+2iGV9qjJLePrSItmBNUBpUKYxJHG6wtf7EGEmv8gN/Ws
        dysGxtMcu2UwlqzWDoftGKmqk/pYkFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-xwkLqz4INBeC-MLnmXMbEg-1; Wed, 23 Oct 2019 14:38:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6B475E9;
        Wed, 23 Oct 2019 18:38:52 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C052619C78;
        Wed, 23 Oct 2019 18:38:44 +0000 (UTC)
Date:   Wed, 23 Oct 2019 20:38:41 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/4] page_pool: Don't recycle non-reusable
 pages
Message-ID: <20191023203841.21234946@carbon>
In-Reply-To: <20191022044343.6901-3-saeedm@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
        <20191022044343.6901-3-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: xwkLqz4INBeC-MLnmXMbEg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 04:44:21 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> A page is NOT reusable when at least one of the following is true:
> 1) allocated when system was under some pressure. (page_is_pfmemalloc)
> 2) belongs to a different NUMA node than pool->p.nid.
>=20
> To update pool->p.nid users should call page_pool_update_nid().
>=20
> Holding on to such pages in the pool will hurt the consumer performance
> when the pool migrates to a different numa node.
>=20
> Performance testing:
> XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
> while migrating rx ring irq from close to far numa:
>=20
> mlx5 internal page cache was locally disabled to get pure page pool
> results.
>=20
> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
>=20
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.8 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
>=20
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 4   Mpps  | 3.5  Mpps
>=20
> Improvement is about 30% drop packet rate, 15% tx packet rate for numa
> far test.
> No degradation for numa close tests.
>=20
> TCP single/multi cpu/stream:
> NUMA  | #cpu | Before  | After
> --------------------------------------
> Close | 1    | 18 Gbps | 18 Gbps
> Far   | 1    | 15 Gbps | 18 Gbps
> Close | 12   | 80 Gbps | 80 Gbps
> Far   | 12   | 68 Gbps | 80 Gbps
>=20
> In all test cases we see improvement for the far numa case, and no
> impact on the close numa case.
>=20
> The impact of adding a check per page is very negligible, and shows no
> performance degradation whatsoever, also functionality wise it seems more
> correct and more robust for page pool to verify when pages should be
> recycled, since page pool can't guarantee where pages are coming from.
>=20
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/core/page_pool.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 08ca9915c618..8120aec999ce 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -283,6 +283,17 @@ static bool __page_pool_recycle_direct(struct page *=
page,
>  =09return true;
>  }
> =20
> +/* page is NOT reusable when:
> + * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> + * 2) belongs to a different NUMA node than pool->p.nid.
> + *
> + * To update pool->p.nid users must call page_pool_update_nid.
> + */
> +static bool pool_page_reusable(struct page_pool *pool, struct page *page=
)
> +{
> +=09return !page_is_pfmemalloc(page) && page_to_nid(page) =3D=3D pool->p.=
nid;

I think we have discussed this before. You are adding the
page_is_pfmemalloc(page) memory pressure test, even-though the
allocation side of page_pool will not give us these kind of pages.

I'm going to accept this anyway, as it is a good safeguard, as it is a
very bad thing to recycle such a page.  Performance wise, you have
showed it have almost zero impact, which I guess is because we are
already reading the struct page area here.

> +}
> +
>  void __page_pool_put_page(struct page_pool *pool,
>  =09=09=09  struct page *page, bool allow_direct)
>  {
> @@ -292,7 +303,8 @@ void __page_pool_put_page(struct page_pool *pool,
>  =09 *
>  =09 * refcnt =3D=3D 1 means page_pool owns page, and can recycle it.
>  =09 */
> -=09if (likely(page_ref_count(page) =3D=3D 1)) {
> +=09if (likely(page_ref_count(page) =3D=3D 1 &&
> +=09=09   pool_page_reusable(pool, page))) {
>  =09=09/* Read barrier done in page_ref_count / READ_ONCE */
> =20
>  =09=09if (allow_direct && in_serving_softirq())



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

