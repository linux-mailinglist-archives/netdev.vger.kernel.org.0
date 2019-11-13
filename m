Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB96FAC13
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfKMI3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:29:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35352 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbfKMI3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 03:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573633761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1akMTlo+i8m4HmhAJ7H+DLpdqdkV4atkZW1vivI704=;
        b=eR/R0+XXt5W1LREqJkZvCUYvQCPkFm320DpXAU3oS1XsLYr9MdIzbR++y8FQqlQe8+vGdZ
        Jw7aSJ4eGkFwYVN8S3WOe75jj9GUQ7RrKMhQDs0lXbq3PxrRpL5fRGmmU+9cHtI3bbXYIN
        uzZT+qrd7Lx+stX04PU1nqmv45wLddg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Basd25mzMJCLetYnItVzrA-1; Wed, 13 Nov 2019 03:29:20 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 042D4DBE6;
        Wed, 13 Nov 2019 08:29:19 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22C8C60C85;
        Wed, 13 Nov 2019 08:29:08 +0000 (UTC)
Date:   Wed, 13 Nov 2019 09:29:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for non-coherent devices
Message-ID: <20191113092907.569f6b8e@carbon>
In-Reply-To: <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
        <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: Basd25mzMJCLetYnItVzrA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 14:09:09 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2cbcdbdec254..defbfd90ab46 100644
[...]
> @@ -150,8 +153,8 @@ static inline void page_pool_destroy(struct page_pool=
 *pool)
>  }
> =20
>  /* Never call this directly, use helpers below */
> -void __page_pool_put_page(struct page_pool *pool,
> -=09=09=09  struct page *page, bool allow_direct);
> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> +=09=09=09  unsigned int dma_sync_size, bool allow_direct);
> =20
>  static inline void page_pool_put_page(struct page_pool *pool,
>  =09=09=09=09      struct page *page, bool allow_direct)
> @@ -160,14 +163,14 @@ static inline void page_pool_put_page(struct page_p=
ool *pool,
>  =09 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>  =09 */
>  #ifdef CONFIG_PAGE_POOL
> -=09__page_pool_put_page(pool, page, allow_direct);
> +=09__page_pool_put_page(pool, page, 0, allow_direct);
>  #endif
>  }
>  /* Very limited use-cases allow recycle direct */
>  static inline void page_pool_recycle_direct(struct page_pool *pool,
>  =09=09=09=09=09    struct page *page)
>  {
> -=09__page_pool_put_page(pool, page, true);
> +=09__page_pool_put_page(pool, page, 0, true);
>  }

We need to use another "default" value than zero for 'dma_sync_size' in
above calls.  I suggest either 0xFFFFFFFF or -1 (which unsigned is
0xFFFFFFFF).

Point is that in case caller doesn't know the length (the CPU have had
access to) then page_pool will need to sync with pool->p.max_len.

If choosing a larger value here default value your code below takes
care of it via min(dma_sync_size, pool->p.max_len).

=20
>  /* API user MUST have disconnected alloc-side (not allowed to call
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..af9514c2d15b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -112,6 +112,17 @@ static struct page
> *__page_pool_get_cached(struct page_pool *pool) return page;
>  }
> =20
> +/* Used for non-coherent devices */
> +static void page_pool_dma_sync_for_device(struct page_pool *pool,
> +=09=09=09=09=09  struct page *page,
> +=09=09=09=09=09  unsigned int dma_sync_size)
> +{
> +=09dma_sync_size =3D min(dma_sync_size, pool->p.max_len);
> +=09dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> +=09=09=09=09=09 pool->p.offset, dma_sync_size,
> +=09=09=09=09=09 pool->p.dma_dir);
> +}


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

