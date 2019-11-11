Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30954F7067
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 10:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKKJVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 04:21:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36328 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbfKKJVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 04:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573464074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JxbIgXTR6bQeWKATcv/ljlKOYJL+BoThIxLdtQrzukE=;
        b=eapJH0/CYuieClamtYuqAcjHaioKSe9UbwnsIOTE2WoXdgTfRoA4Ac2vj6q54eaeaN1PzT
        Mtlyu+RyYC9yFrmTHyTS8+LmeWBzcAVG7BLvaOzbLOld8LvY6lMghMQK0Jq1n1wCirnFNW
        gqXMEhr4Oyb9pTY8SkiWZEKIkVLZGyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-aCjYt2AzOPOzaZtSbuO5BA-1; Mon, 11 Nov 2019 04:21:12 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7755A100551A;
        Mon, 11 Nov 2019 09:21:11 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF73810001BD;
        Mon, 11 Nov 2019 09:21:05 +0000 (UTC)
Date:   Mon, 11 Nov 2019 10:21:04 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <ilias.apalodimas@linaro.org>,
        <kernel-team@fb.com>, brouer@redhat.com
Subject: Re: [RFC PATCH 1/1] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191111102104.1ac9620d@carbon>
In-Reply-To: <20191111062038.2336521-2-jonathan.lemon@gmail.com>
References: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
        <20191111062038.2336521-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: aCjYt2AzOPOzaZtSbuO5BA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 22:20:38 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 20781ad5f9c3..e334fad0a6b8 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -70,25 +70,47 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_h=
ead *rcu)
> =20
>  =09xa =3D container_of(rcu, struct xdp_mem_allocator, rcu);
> =20
> -=09/* Allocator have indicated safe to remove before this is called */
> -=09if (xa->mem.type =3D=3D MEM_TYPE_PAGE_POOL)
> -=09=09page_pool_free(xa->page_pool);
> -
>  =09/* Allow this ID to be reused */
>  =09ida_simple_remove(&mem_id_pool, xa->mem.id);
> =20
> -=09/* Poison memory */
> -=09xa->mem.id =3D 0xFFFF;
> -=09xa->mem.type =3D 0xF0F0;
> -=09xa->allocator =3D (void *)0xDEAD9001;
> -
>  =09kfree(xa);
>  }

Can you PLEASE leave the memory poisonings that I have added alone.
Removing these are irrelevant for current patch. You clearly don't like
this approach, but I've also clearly told that I disagree.  I'm the
maintainer of this code and I prefer letting them stay. I'm the one
that signed up for dealing with hard to find bugs in the code.

I'll try to explain again, hopefully one last time.  You argue that the
memory subsystem already have use-after-free detection e.g via
kmemleak.  I argue that these facilities change the timing so much,
that race condition will not be provoked when enabled.  This is not
theoretical, I've seen bugzilla cases consume a huge amount of support
and engineering resources, trying to track down bugs that would
disappear once the debug facility is enabled.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

