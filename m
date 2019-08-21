Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8C496E81
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfHUAnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:43:11 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:8004 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfHUAnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:43:11 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id D07814679584F6934D3D;
        Wed, 21 Aug 2019 08:43:07 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x7L0g2Aj077465;
        Wed, 21 Aug 2019 08:42:02 +0800 (GMT-8)
        (envelope-from zhang.lin16@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019082108422087-3081849 ;
          Wed, 21 Aug 2019 08:42:20 +0800 
From:   zhanglin <zhang.lin16@zte.com.cn>
To:     davem@davemloft.net
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, willemb@google.com,
        edumazet@google.com, deepa.kernel@gmail.com, arnd@arndb.de,
        dh.herrmann@gmail.com, gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn, zhanglin <zhang.lin16@zte.com.cn>
Subject: [PATCH v2] sock: fix potential memory leak in proto_register()
Date:   Wed, 21 Aug 2019 08:42:38 +0800
Message-Id: <1566348158-43942-1-git-send-email-zhang.lin16@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-08-21 08:42:20,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-08-21 08:42:06,
        Serialize complete at 2019-08-21 08:42:06
X-MAIL: mse-fl1.zte.com.cn x7L0g2Aj077465
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If protocols registered exceeded PROTO_INUSE_NR, prot will be
added to proto_list, but no available bit left for prot in
proto_inuse_idx.

Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>
---
 net/core/sock.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bc3512f230a3..c7ae32705705 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3139,16 +3139,17 @@ static __init int net_inuse_init(void)
 
 core_initcall(net_inuse_init);
 
-static void assign_proto_idx(struct proto *prot)
+static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
 	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
-		return;
+		return -ENOSPC;
 	}
 
 	set_bit(prot->inuse_idx, proto_inuse_idx);
+	return 0;
 }
 
 static void release_proto_idx(struct proto *prot)
@@ -3157,8 +3158,9 @@ static void release_proto_idx(struct proto *prot)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-static inline void assign_proto_idx(struct proto *prot)
+static inline int assign_proto_idx(struct proto *prot)
 {
+	return 0;
 }
 
 static inline void release_proto_idx(struct proto *prot)
@@ -3243,18 +3245,24 @@ int proto_register(struct proto *prot, int alloc_slab)
 	}
 
 	mutex_lock(&proto_list_mutex);
+	if (assign_proto_idx(prot)) {
+		mutex_unlock(&proto_list_mutex);
+		goto out_free_timewait_sock_slab_name;
+	}
 	list_add(&prot->node, &proto_list);
-	assign_proto_idx(prot);
 	mutex_unlock(&proto_list_mutex);
 	return 0;
 
 out_free_timewait_sock_slab_name:
-	kfree(prot->twsk_prot->twsk_slab_name);
+	if (alloc_slab && prot->twsk_prot)
+		kfree(prot->twsk_prot->twsk_slab_name);
 out_free_request_sock_slab:
-	req_prot_cleanup(prot->rsk_prot);
+	if (alloc_slab) {
+		req_prot_cleanup(prot->rsk_prot);
 
-	kmem_cache_destroy(prot->slab);
-	prot->slab = NULL;
+		kmem_cache_destroy(prot->slab);
+		prot->slab = NULL;
+	}
 out:
 	return -ENOBUFS;
 }
-- 
2.17.1

