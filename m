Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC84E4C56
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504778AbfJYNeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:34:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33027 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440409AbfJYNeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572010446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vUr7sd5cAd5xQXbxvhdUz5sUq4hXZxOoI8a9Fa3b2M=;
        b=FStenOIyUL2LbgqqhyY3jhd1AmLrJh5JCCuXYC7rG7faWyOPOWqxdeQ6A69aWNEhKnxcbZ
        dChYBSMIRW5JLFUQEn4mdjQL0CqunhEVZagtzrMT0abuC7Hjt8aH3D+oE3Msvf6gQg2NL6
        q9GVvfJdR1qDXg4E3oiYNNxBGPrylMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-CZOc5lm2P9i8Igz21b50-w-1; Fri, 25 Oct 2019 09:34:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD69A1005500;
        Fri, 25 Oct 2019 13:34:01 +0000 (UTC)
Received: from carbon (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCCC819C7F;
        Fri, 25 Oct 2019 13:33:55 +0000 (UTC)
Date:   Fri, 25 Oct 2019 15:33:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-nex V2 2/3] page_pool: Don't recycle non-reusable
 pages
Message-ID: <20191025153353.606e4b0d@carbon>
In-Reply-To: <20191023193632.26917-3-saeedm@mellanox.com>
References: <20191023193632.26917-1-saeedm@mellanox.com>
        <20191023193632.26917-3-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: CZOc5lm2P9i8Igz21b50-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 19:37:00 +0000
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

Could you show us the code that disable the local page cache?


> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
>=20
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.9 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
>=20
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 3.5 Mpps  | 4  Mpps
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
> index 953af6d414fb..73e4173c4dce 100644
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

I'm afraid that we are slowly chipping away the performance benefit
with these incremental changes, adding more checks. We have an extreme
performance use-case with XDP_DROP, where we want drivers to use this
code path to hit __page_pool_recycle_direct(), that is a simple array
update (protected under NAPI) into pool->alloc.cache[].

To preserve this hot-path, you could instead flush pool->alloc.cache[]
in the call page_pool_update_nid().  And move the pool_page_reusable()
check into __page_pool_recycle_into_ring().  (Below added the '>>' with
remaining code to make this easier to see)


>  =09=09/* Read barrier done in page_ref_count / READ_ONCE */
> =20
>  =09=09if (allow_direct && in_serving_softirq())
>>=09=09=09if (__page_pool_recycle_direct(page, pool))
>>=09=09=09=09return;
>>
>>=09=09if (!__page_pool_recycle_into_ring(pool, page)) {
>>=09=09=09/* Cache full, fallback to free pages */
>>=09=09=09__page_pool_return_page(pool, page);
>>=09=09}
>>=09=09return;
>>=09}
>>=09/* Fallback/non-XDP mode: API user have elevated refcnt.


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

For easier review:

/* Only allow direct recycling in special circumstances, into the
 * alloc side cache.  E.g. during RX-NAPI processing for XDP_DROP use-case.
 *
 * Caller must provide appropriate safe context.
 */
static bool __page_pool_recycle_direct(struct page *page,
=09=09=09=09       struct page_pool *pool)
{
=09if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
=09=09return false;

=09/* Caller MUST have verified/know (page_ref_count(page) =3D=3D 1) */
=09pool->alloc.cache[pool->alloc.count++] =3D page;
=09return true;
}


