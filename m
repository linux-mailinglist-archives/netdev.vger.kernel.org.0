Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366123B4A7F
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 00:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFYWSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYWSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 18:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABDD6162E;
        Fri, 25 Jun 2021 22:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624659380;
        bh=LkV2AhMPNnVddmnk8l0831oUro5LwhugAKsouuBuUdw=;
        h=From:To:Cc:Subject:Date:From;
        b=G1pm7FD2/K3uhAbkuaBj481xSgqkI6gloTchPpos4uR/d+1xOud64Pb6U3AZoWZS1
         P54D9NWiwETCiDnotq2rgernSCYJhfHR8D2VxYz/OAr5XZF7kSg8cIremg+7KFTVP/
         DMMs8G4ASxuU+aI1jsFoeXrMf0lqcgX0ijZGXFU926LUswQi0C8C9qxNeoYj5SNVLC
         1BKH2n+TOgHt2X5k/28yWIy6NVRpnJKD0506QZurp0u1ABg+qGmj9/LjPwccvvlu0i
         4S9O3yLKSlnnn19+qLEXrkYVU6wItnnndQ0IHbRkVuP8mKQ5mE54UMzhBYK1EbjTCk
         JE4aN2wp3qZ7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     daniel@iogearbox.net, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        davem@davemloft.net, john.fastabend@gmail.com, lorenzo@kernel.org,
        bsd@fb.com, alexanderduyck@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next] xdp: move the rxq_info.mem clearing to unreg_mem_model()
Date:   Fri, 25 Jun 2021 15:16:12 -0700
Message-Id: <20210625221612.2637086-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_rxq_info_unreg() implicitly calls xdp_rxq_info_unreg_mem_model().
This may well be confusing to the driver authors, and lead to double
free if they call xdp_rxq_info_unreg_mem_model() before
xdp_rxq_info_unreg() (when mem model type == MEM_TYPE_PAGE_POOL).

In fact error path of mvpp2_rxq_init() seems to currently do
exactly that.

The double free will result in refcount underflow
in page_pool_destroy(). Make the interface a little more
programmer friendly by clearing type and id so that
xdp_rxq_info_unreg_mem_model() can be called multiple
times.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Targeting bpf-next, the mvpp2 bug (if it's real) can be addressed
separately. IMHO it may be a little late in the cycle for
"API convenience" changes but I tested against bpf as well.

 net/core/xdp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 858276e72c68..6ea3302c42eb 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -113,8 +113,13 @@ static void mem_allocator_disconnect(void *allocator)
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 {
 	struct xdp_mem_allocator *xa;
+	int type = xdp_rxq->mem.type;
 	int id = xdp_rxq->mem.id;
 
+	/* Reset mem info to defaults */
+	xdp_rxq->mem.id = 0;
+	xdp_rxq->mem.type = 0;
+
 	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
 		WARN(1, "Missing register, driver bug");
 		return;
@@ -123,7 +128,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	if (id == 0)
 		return;
 
-	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
+	if (type == MEM_TYPE_PAGE_POOL) {
 		rcu_read_lock();
 		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
 		page_pool_destroy(xa->page_pool);
@@ -144,10 +149,6 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 
 	xdp_rxq->reg_state = REG_STATE_UNREGISTERED;
 	xdp_rxq->dev = NULL;
-
-	/* Reset mem info to defaults */
-	xdp_rxq->mem.id = 0;
-	xdp_rxq->mem.type = 0;
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg);
 
-- 
2.31.1

