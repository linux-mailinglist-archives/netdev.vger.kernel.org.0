Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC884A1A6
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFRNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfFRNGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:06:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64DE6300309E;
        Tue, 18 Jun 2019 13:06:10 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16DC610AFE70;
        Tue, 18 Jun 2019 13:06:09 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 41C82306665E6;
        Tue, 18 Jun 2019 15:06:08 +0200 (CEST)
Subject: [PATCH net-next v2 12/12] page_pool: make sure struct device is
 stable
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:06:08 +0200
Message-ID: <156086316820.27760.15150124176600072481.stgit@firesoul>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 18 Jun 2019 13:06:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For DMA mapping use-case the page_pool keeps a pointer
to the struct device, which is used in DMA map/unmap calls.

For our in-flight handling, we also need to make sure that
the struct device have not disappeared.  This is assured
via using get_device/put_device API.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/core/page_pool.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f55ab055d543..b366f59885c1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #include <net/page_pool.h>
 #include <linux/dma-direction.h>
@@ -48,6 +49,9 @@ static int page_pool_init(struct page_pool *pool,
 
 	atomic_set(&pool->pages_state_release_cnt, 0);
 
+	if (pool->p.flags & PP_FLAG_DMA_MAP)
+		get_device(pool->p.dev);
+
 	return 0;
 }
 
@@ -360,6 +364,10 @@ void __page_pool_free(struct page_pool *pool)
 		__warn_in_flight(pool);
 
 	ptr_ring_cleanup(&pool->ring, NULL);
+
+	if (pool->p.flags & PP_FLAG_DMA_MAP)
+		put_device(pool->p.dev);
+
 	kfree(pool);
 }
 EXPORT_SYMBOL(__page_pool_free);

