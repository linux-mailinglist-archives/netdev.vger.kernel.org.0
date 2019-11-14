Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8BFD01B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKNVH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:07:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726640AbfKNVH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573765646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0ZrUjn+iDl7vfuMpGBR8EdAaGxNTP/eiIVACmS20+k=;
        b=i2NIJlFu7AQIfW4qCxlZYvjYopGMpSZ+G+ovGdUIByXhhHIoL5ajN3qYadqxUD5BryTVXF
        4pvxEfL3FMEkkWXCURi3bkhrtNnFC6fd4PMMJPVG9aLWL0E8IKX0hyvm7HrbMu93NPSwEE
        wl2WmscRtiVr+iZqw8PkR55PJkrwYtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-w5Npez7ZOb61Ywky6L42SA-1; Thu, 14 Nov 2019 16:07:23 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2403E18B5F68;
        Thu, 14 Nov 2019 21:07:22 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F306194B2;
        Thu, 14 Nov 2019 21:07:17 +0000 (UTC)
Date:   Thu, 14 Nov 2019 22:07:15 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>, <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [net-next PATCH v2 2/2] page_pool: remove hold/release count
 from tracepoints
Message-ID: <20191114220715.1ac54ddf@carbon>
In-Reply-To: <20191114163715.4184099-3-jonathan.lemon@gmail.com>
References: <20191114163715.4184099-1-jonathan.lemon@gmail.com>
        <20191114163715.4184099-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: w5Npez7ZOb61Ywky6L42SA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 08:37:15 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> When the last page is released from the page pool, it is possible
> that the delayed removal thread sees inflight =3D=3D 0, and frees the
> pool.  While the freed pointer is only copied by the tracepoint
> and not dereferenced, it really isn't correct.  Avoid this case by
> reporting the page release before releasing the page.

I don't like this patch!

I'm actually using these counters, in my current version of my bpftrace
leak detector for page_pool:

https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/p=
age_pool_track_leaks01.bt



> This also removes a second atomic operation from the release path.
>=20
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/trace/events/page_pool.h | 24 ++++++++++--------------
>  net/core/page_pool.c             |  8 +++++---
>  2 files changed, 15 insertions(+), 17 deletions(-)
[...]

> @@ -222,9 +222,11 @@ static void __page_pool_clean_page(struct page_pool =
*pool,
>  =09=09=09     DMA_ATTR_SKIP_CPU_SYNC);
>  =09page->dma_addr =3D 0;
>  skip_dma_unmap:
> +=09trace_page_pool_page_release(pool, page);
> +=09/* This may be the last page returned, releasing the pool, so
> +=09 * it is not safe to reference pool afterwards.
> +=09 */
>  =09atomic_inc(&pool->pages_state_release_cnt);
> -=09trace_page_pool_state_release(pool, page,
> -=09=09=09      atomic_read(&pool->pages_state_release_cnt));
>  }

I will prefer that you do an atomic_inc_return, and send the cnt to the
existing tracepoint.  I'm not dereferencing the pool in my tracepoint
use-case, and as Alexei wrote, this would still be 'safe' (as in not
crashing) for a tracepoint if someone do.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

