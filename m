Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5DBFE0D8
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfKOPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:06:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42083 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727406AbfKOPGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:06:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573830380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEoADvgaKujrzAwcDz61IYBwPQPfY7EoI/V7vorZMEg=;
        b=DzRqqoEs9MOjle6a91tSXt7JhkPJlrDmlZqtnCV6PY5NS7hNLtrIuwgK8iIpiUdbEL90kt
        b2iFQVr4yYbTik/gjYtl3LwijBAEoqVfIs/C4KOVBNj0S+gvur9ONKXGBNFBLPCaOYzWWM
        zZKubhA+pWGYeElqVAKUHLP4Y6+es4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-HKmYisMANbChaLNVll9eOQ-1; Fri, 15 Nov 2019 10:06:17 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C28CD18B5F7F;
        Fri, 15 Nov 2019 15:06:15 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F20525E263;
        Fri, 15 Nov 2019 15:06:09 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2E4F930FC1350;
        Fri, 15 Nov 2019 16:06:09 +0100 (CET)
Subject: [net-next v1 PATCH 3/4] page_pool: block alloc cache during shutdown
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
Date:   Fri, 15 Nov 2019 16:06:09 +0100
Message-ID: <157383036914.3173.12541360542055110975.stgit@firesoul>
In-Reply-To: <157383032789.3173.11648581637167135301.stgit@firesoul>
References: <157383032789.3173.11648581637167135301.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: HKmYisMANbChaLNVll9eOQ-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is documented that driver API users, have to disconnect
the page_pool, before starting shutdown phase, but is it only
documentation, there is not code catching such violations.

Given (in page_pool_empty_alloc_cache_once) alloc cache is only
flushed once, there is now an opportunity to catch this case.

This patch blocks the RX/alloc-side cache, via pretending it is
full and poison last element.  This code change will enforce that
drivers cannot use alloc cache during shutdown phase.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e28db2ef8e12..b31f3bb7818d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -364,6 +364,10 @@ static void page_pool_empty_alloc_cache_once(struct pa=
ge_pool *pool)
 =09=09page =3D pool->alloc.cache[--pool->alloc.count];
 =09=09__page_pool_return_page(pool, page);
 =09}
+
+=09/* Block alloc cache, pretend it's full and poison last element */
+=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
+=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE;
 }
=20
 static void page_pool_scrub(struct page_pool *pool)

