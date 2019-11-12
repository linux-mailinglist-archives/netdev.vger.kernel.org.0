Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77584F95F9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKLQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:48:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbfKLQsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573577314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f732JNmwhbqpImWTWHvuT6QvnrUR3MBrkpYYR4Ep/IU=;
        b=SvaXnnY5CBFu87W35ZKvVMsJsdHXymFfAnyEJpgE/sOgH4AJwwzyUJcgFGbOygCNwHpLHU
        GwD14X19jNdSqK596ssuOyZBOgNlbjn1NfeaUdqho+0S1vqTceO92Px+8xQcrTijIpv8SB
        fHSv2N2VczHXneVFAnfKOAPSYRLREy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-VO84zA3DM4ymHikXWnRRww-1; Tue, 12 Nov 2019 11:48:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E1D18B9FCC;
        Tue, 12 Nov 2019 16:48:30 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6472F101F6CB;
        Tue, 12 Nov 2019 16:48:23 +0000 (UTC)
Date:   Tue, 12 Nov 2019 17:48:22 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191112174822.4b635e56@carbon>
In-Reply-To: <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
        <20191112130832.6b3d69d5@carbon>
        <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: VO84zA3DM4ymHikXWnRRww-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 08:33:58 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> On 12 Nov 2019, at 4:08, Jesper Dangaard Brouer wrote:
>=20
> > On Mon, 11 Nov 2019 21:32:10 -0800
> > Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > =20
> >> The page pool keeps track of the number of pages in flight, and
> >> it isn't safe to remove the pool until all pages are returned.
> >>
> >> Disallow removing the pool until all pages are back, so the pool
> >> is always available for page producers.
> >>
> >> Make the page pool responsible for its own delayed destruction
> >> instead of relying on XDP, so the page pool can be used without
> >> xdp. =20
> >
> > Can you please change this to:
> >  [... can be used without] xdp memory model. =20
>=20
> Okay.
>=20
>=20
> >> When all pages are returned, free the pool and notify xdp if the
> >> pool is registered with the xdp memory system.  Have the callback
> >> perform a table walk since some drivers (cpsw) may share the pool
> >> among multiple xdp_rxq_info.
> >>
> >> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic=20
> >> warning")
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >> --- =20
> > [...] =20
> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index 5bc65587f1c4..bfe96326335d 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c =20
> > [...]
> >
> > Found an issue, see below.
> > =20
> >> @@ -338,31 +333,10 @@ static void __page_pool_empty_ring(struct=20
> >> page_pool *pool)
> >>  =09}
> >>  }
> >>
> >> -static void __warn_in_flight(struct page_pool *pool)
> >> +static void page_pool_free(struct page_pool *pool)
> >>  {
> >> -=09u32 release_cnt =3D atomic_read(&pool->pages_state_release_cnt);
> >> -=09u32 hold_cnt =3D READ_ONCE(pool->pages_state_hold_cnt);
> >> -=09s32 distance;
> >> -
> >> -=09distance =3D _distance(hold_cnt, release_cnt);
> >> -
> >> -=09/* Drivers should fix this, but only problematic when DMA is used=
=20
> >> */
> >> -=09WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> >> -=09     distance, hold_cnt, release_cnt);
> >> -}
> >> -
> >> -void __page_pool_free(struct page_pool *pool)
> >> -{
> >> -=09/* Only last user actually free/release resources */
> >> -=09if (!page_pool_put(pool))
> >> -=09=09return;
> >> -
> >> -=09WARN(pool->alloc.count, "API usage violation");
> >> -=09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> >> -
> >> -=09/* Can happen due to forced shutdown */
> >> -=09if (!__page_pool_safe_to_destroy(pool))
> >> -=09=09__warn_in_flight(pool);
> >> +=09if (pool->disconnect)
> >> +=09=09pool->disconnect(pool);
> >>  =09ptr_ring_cleanup(&pool->ring, NULL);
> >>
> >> @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
> >>
> >>  =09kfree(pool);
> >>  }
> >> -EXPORT_SYMBOL(__page_pool_free); =20
> >
> > I don't think this is correct according to RCU.
> >
> > Let me reproduce the resulting version of page_pool_free():
> >
> >  static void page_pool_free(struct page_pool *pool)
> >  {
> > =09if (pool->disconnect)
> > =09=09pool->disconnect(pool);
> >
> > =09ptr_ring_cleanup(&pool->ring, NULL);
> >
> > =09if (pool->p.flags & PP_FLAG_DMA_MAP)
> > =09=09put_device(pool->p.dev);
> >
> > =09kfree(pool);
> >  }
> >
> > The issue is that pool->disconnect() will call into
> > mem_allocator_disconnect() -> mem_xa_remove(), and mem_xa_remove()=20
> > does
> > a RCU delayed free.  And this function immediately does a kfree(pool).
> >
> > I do know that we can ONLY reach this page_pool_free() function, when
> > inflight =3D=3D 0, but that can happen as soon as __page_pool_clean_pag=
e()
> > does the decrement, and after this trace_page_pool_state_release()
> > still have access the page_pool object (thus, hard to catch=20
> > use-after-free). =20
>=20
> Is this an issue?  The RCU delayed free is for the xa object, it is held
> in an RCU-protected mem_id_ht, so it can't be freed until all the=20
> readers
> are complete.
>=20
> The change of &pool->pages_state_release_cnt can decrement the inflight
> pages to 0, and another thread could see inflight =3D=3D 0 and immediatel=
y
> the remove the pool.  The atomic manipulation should be the last use of
> the pool - this should be documented, I'll add that as well:
>=20
> skip_dma_unmap:
>          /* This may be the last page returned, releasing the pool, so
>           * it is not safe to reference pool afterwards.
>           */
>          count =3D atomic_inc_return(&pool->pages_state_release_cnt);
>          trace_page_pool_state_release(pool, page, count);
>=20
> The trace_page_pool_state_release() does not dereference pool, it just
> reports the pointer value, so there shouldn't be any use-after-free.

In the tracepoint we can still dereference the pool object pointer.
This is made easier via using bpftrace for example see[1] (and with BTF
this will become more common to do so).

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftra=
ce/test_tp__xdp_mem_disconnect.bt

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

