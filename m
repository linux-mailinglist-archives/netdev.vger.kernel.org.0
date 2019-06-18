Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900094A19C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfFRNFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28561 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfFRNFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:05:24 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD9936E764;
        Tue, 18 Jun 2019 13:05:23 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64EC81001E71;
        Tue, 18 Jun 2019 13:05:23 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 8EF2F306665E6;
        Tue, 18 Jun 2019 15:05:22 +0200 (CEST)
Subject: [PATCH net-next v2 03/12] xdp: fix leak of IDA cyclic id if
 rhashtable_insert_slow fails
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:05:22 +0200
Message-ID: <156086312251.27760.8827293997900333559.stgit@firesoul>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 18 Jun 2019 13:05:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix error handling case, where inserting ID with rhashtable_insert_slow
fails in xdp_rxq_info_reg_mem_model, which leads to never releasing the IDA
ID, as the lookup in xdp_rxq_info_unreg_mem_model fails and thus
ida_simple_remove() is never called.

Fix by releasing ID via ida_simple_remove(), and mark xdp_rxq->mem.id with
zero, which is already checked in xdp_rxq_info_unreg_mem_model().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 net/core/xdp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194f4f1f..762abeb89847 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -301,6 +301,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
 	if (IS_ERR(ptr)) {
+		ida_simple_remove(&mem_id_pool, xdp_rxq->mem.id);
+		xdp_rxq->mem.id = 0;
 		errno = PTR_ERR(ptr);
 		goto err;
 	}

