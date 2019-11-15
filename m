Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115E6FE0D5
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKOPGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:06:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40213 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727406AbfKOPGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573830371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cZKXO1RJc+PAZ3dTfkwMlfj3tGlpfNa3f7EgSQHXWUA=;
        b=dpIZYmHgui3PqQg9GwaSebzbZy3ybrh2Mi705XYvOfWwpJpjbGBmAuXqQfPiZ6hkyhjf+Y
        87A8gXu+zp3zkR4xQAgTWrGEJHeiIk5PzklO1LMN9p2FdwoPYfl0pcV69E4QkGoTU8o/xZ
        fPAeji8Wz2qNp4MBXVfgOVsHkD9jxAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-sS5vfiDXM-CTl4WosdxaRQ-1; Fri, 15 Nov 2019 10:06:07 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01F558EE2EA;
        Fri, 15 Nov 2019 15:06:06 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D72575C1B0;
        Fri, 15 Nov 2019 15:05:59 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 13D2130FC1350;
        Fri, 15 Nov 2019 16:05:59 +0100 (CET)
Subject: [net-next v1 PATCH 1/4] xdp: remove memory poison on free for
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
Date:   Fri, 15 Nov 2019 16:05:59 +0100
Message-ID: <157383035903.3173.8298685587876715302.stgit@firesoul>
In-Reply-To: <157383032789.3173.11648581637167135301.stgit@firesoul>
References: <157383032789.3173.11648581637167135301.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: sS5vfiDXM-CTl4WosdxaRQ-1
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

