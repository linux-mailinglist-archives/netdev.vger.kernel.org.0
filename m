Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AFFFEBC8
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 12:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfKPLWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 06:22:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727331AbfKPLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 06:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573903366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cZKXO1RJc+PAZ3dTfkwMlfj3tGlpfNa3f7EgSQHXWUA=;
        b=DvSeyupY4LbW9Sv/rckS6Qo326qr7P6qT0qlcckL1U/R1ZHsNDFiOpkGvB98AF3HWu7ENh
        +U85y/TQ2Ta8j8A9z9q/Va/xzi25hwzPQ20POcZ+usjzsCTqfsgVkD8qzVk0Zk3Hczvyc8
        udSSwvrtg2OcfNJ91E8bpvQbwpWZddA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-7b4qcinpNtaIY4kCyro3gw-1; Sat, 16 Nov 2019 06:22:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06784477;
        Sat, 16 Nov 2019 11:22:44 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8E960132;
        Sat, 16 Nov 2019 11:22:38 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 157FB30FC1350;
        Sat, 16 Nov 2019 12:22:38 +0100 (CET)
Subject: [net-next v2 PATCH 1/3] xdp: remove memory poison on free for
 struct xdp_mem_allocator
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Sat, 16 Nov 2019 12:22:38 +0100
Message-ID: <157390335803.4062.9077462420905595048.stgit@firesoul>
In-Reply-To: <157390333500.4062.15569811103072483038.stgit@firesoul>
References: <157390333500.4062.15569811103072483038.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 7b4qcinpNtaIY4kCyro3gw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When looking at the details I realised that the memory poison in
__xdp_mem_allocator_rcu_free doesn't make sense. This is because the
SLUB allocator uses the first 16 bytes (on 64 bit), for its freelist,
which overlap with members in struct xdp_mem_allocator, that were
updated.  Thus, SLUB already does the "poisoning" for us.

I still believe that poisoning memory make sense in other cases.
Kernel have gained different use-after-free detection mechanism, but
enabling those is associated with a huge overhead. Experience is that
debugging facilities can change the timing so much, that that a race
condition will not be provoked when enabled. Thus, I'm still in favour
of poisoning memory where it makes sense.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/xdp.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 8e405abaf05a..e334fad0a6b8 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -73,11 +73,6 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head=
 *rcu)
 =09/* Allow this ID to be reused */
 =09ida_simple_remove(&mem_id_pool, xa->mem.id);
=20
-=09/* Poison memory */
-=09xa->mem.id =3D 0xFFFF;
-=09xa->mem.type =3D 0xF0F0;
-=09xa->allocator =3D (void *)0xDEAD9001;
-
 =09kfree(xa);
 }
=20

