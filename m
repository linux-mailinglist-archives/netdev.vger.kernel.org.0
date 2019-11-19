Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71E01022F5
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKSLYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:24:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725280AbfKSLYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574162650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZ1EHsE1uQDsa7EMidlyubvNKcMXaJrPEPXR8PNSbJk=;
        b=C7HrE8bipAPDLtez5pNztB8O38DEsmuTnfj33j47O45nphDa4Kv68yCgkEAnmZv4GRmAKb
        Zv9ZXnGbu2biwE6GiHtTD0df6Rfv17mQqWnX26dk9Aor/LIKVICojbdJjxX+lq+3FhTGJi
        beg2RII5zoO4bADn611fkwR1/gpPU6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-Y3W8lFmZM_WnVOIGB1bRDg-1; Tue, 19 Nov 2019 06:24:08 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58CB81005500;
        Tue, 19 Nov 2019 11:24:07 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 865E34D74F;
        Tue, 19 Nov 2019 11:23:59 +0000 (UTC)
Date:   Tue, 19 Nov 2019 12:23:58 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119122358.12276da4@carbon>
In-Reply-To: <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
References: <cover.1574083275.git.lorenzo@kernel.org>
        <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Y3W8lFmZM_WnVOIGB1bRDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 15:33:45 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 1121faa99c12..6f684c3a3434 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -34,8 +34,15 @@
>  #include <linux/ptr_ring.h>
>  #include <linux/dma-direction.h>
> =20
> -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap */
> -#define PP_FLAG_ALL=09PP_FLAG_DMA_MAP
> +#define PP_FLAG_DMA_MAP=09=091 /* Should page_pool do the DMA map/unmap =
*/
> +#define PP_FLAG_DMA_SYNC_DEV=092 /* if set all pages that the driver get=
s
> +=09=09=09=09   * from page_pool will be
> +=09=09=09=09   * DMA-synced-for-device according to the
> +=09=09=09=09   * length provided by the device driver.
> +=09=09=09=09   * Please note DMA-sync-for-CPU is still
> +=09=09=09=09   * device driver responsibility
> +=09=09=09=09   */
> +#define PP_FLAG_ALL=09=09(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> =20
[...]

Can you please change this to use the BIT(X) api.

#include <linux/bits.h>

#define PP_FLAG_DMA_MAP=09=09BIT(0)
#define PP_FLAG_DMA_SYNC_DEV=09BIT(1)



> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index dfc2501c35d9..4f9aed7bce5a 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
>  =09    (pool->p.dma_dir !=3D DMA_BIDIRECTIONAL))
>  =09=09return -EINVAL;
> =20
> +=09/* In order to request DMA-sync-for-device the page needs to
> +=09 * be mapped
> +=09 */
> +=09if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> +=09    !(pool->p.flags & PP_FLAG_DMA_MAP))
> +=09=09return -EINVAL;
> +

I like that you have moved this check to setup time.

There are two other parameters the DMA_SYNC_DEV depend on:

 =09struct page_pool_params pp_params =3D {
 =09=09.order =3D 0,
-=09=09.flags =3D PP_FLAG_DMA_MAP,
+=09=09.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 =09=09.pool_size =3D size,
 =09=09.nid =3D cpu_to_node(0),
 =09=09.dev =3D pp->dev->dev.parent,
 =09=09.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+=09=09.offset =3D pp->rx_offset_correction,
+=09=09.max_len =3D MVNETA_MAX_RX_BUF_SIZE,
 =09};

Can you add a check, that .max_len must not be zero.  The reason is
that I can easily see people misconfiguring this.  And the effect is
that the DMA-sync-for-device is essentially disabled, without user
realizing this. The not-realizing part is really bad, especially
because bugs that can occur from this are very rare and hard to catch.

I'm up for discussing if there should be a similar check for .offset.
IMHO we should also check .offset is configured, and then be open to
remove this check once a driver user want to use offset=3D0.  Does the
mvneta driver already have a use-case for this (in non-XDP mode)?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

