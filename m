Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144272405AF
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 14:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHJMSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 08:18:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbgHJMSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 08:18:15 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4D9A955539E3F4B410D8;
        Mon, 10 Aug 2020 20:18:12 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 10 Aug 2020
 20:18:02 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <kafai@fb.com>, <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <keescook@chromium.org>, <zhang.lin16@zte.com.cn>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix potential memory leak in proto_register()
Date:   Mon, 10 Aug 2020 08:16:58 -0400
Message-ID: <20200810121658.54657-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we failed to assign proto idx, we free the twsk_slab_name but forget to
free the twsk_slab. Add a helper function tw_prot_cleanup() to free these
together and also use this helper function in proto_unregister().

Fixes: b45ce32135d1 ("sock: fix potential memory leak in proto_register()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/sock.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 49cd5ffe673e..c9083ad44ea1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3406,6 +3406,16 @@ static void sock_inuse_add(struct net *net, int val)
 }
 #endif
 
+static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
+{
+	if (!twsk_prot)
+		return;
+	kfree(twsk_prot->twsk_slab_name);
+	twsk_prot->twsk_slab_name = NULL;
+	kmem_cache_destroy(twsk_prot->twsk_slab);
+	twsk_prot->twsk_slab = NULL;
+}
+
 static void req_prot_cleanup(struct request_sock_ops *rsk_prot)
 {
 	if (!rsk_prot)
@@ -3476,7 +3486,7 @@ int proto_register(struct proto *prot, int alloc_slab)
 						  prot->slab_flags,
 						  NULL);
 			if (prot->twsk_prot->twsk_slab == NULL)
-				goto out_free_timewait_sock_slab_name;
+				goto out_free_timewait_sock_slab;
 		}
 	}
 
@@ -3484,15 +3494,15 @@ int proto_register(struct proto *prot, int alloc_slab)
 	ret = assign_proto_idx(prot);
 	if (ret) {
 		mutex_unlock(&proto_list_mutex);
-		goto out_free_timewait_sock_slab_name;
+		goto out_free_timewait_sock_slab;
 	}
 	list_add(&prot->node, &proto_list);
 	mutex_unlock(&proto_list_mutex);
 	return ret;
 
-out_free_timewait_sock_slab_name:
+out_free_timewait_sock_slab:
 	if (alloc_slab && prot->twsk_prot)
-		kfree(prot->twsk_prot->twsk_slab_name);
+		tw_prot_cleanup(prot->twsk_prot);
 out_free_request_sock_slab:
 	if (alloc_slab) {
 		req_prot_cleanup(prot->rsk_prot);
@@ -3516,12 +3526,7 @@ void proto_unregister(struct proto *prot)
 	prot->slab = NULL;
 
 	req_prot_cleanup(prot->rsk_prot);
-
-	if (prot->twsk_prot != NULL && prot->twsk_prot->twsk_slab != NULL) {
-		kmem_cache_destroy(prot->twsk_prot->twsk_slab);
-		kfree(prot->twsk_prot->twsk_slab_name);
-		prot->twsk_prot->twsk_slab = NULL;
-	}
+	tw_prot_cleanup(prot->twsk_prot);
 }
 EXPORT_SYMBOL(proto_unregister);
 
-- 
2.19.1

