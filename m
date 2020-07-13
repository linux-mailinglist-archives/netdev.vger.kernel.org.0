Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8903821DF9A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGMSZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgGMSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:25:37 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DD6C061755;
        Mon, 13 Jul 2020 11:25:37 -0700 (PDT)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 26C412E12D7;
        Mon, 13 Jul 2020 21:25:34 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id PynIViMCjb-PXsCI05h;
        Mon, 13 Jul 2020 21:25:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594664734; bh=/Tkd3OmLu3FPpAv3WUko7xzHf9Qit7HMtTcSNe2k4iU=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=lYH6gHJBQIoVsySnle0aLtAGpVbPimBy3z1whkKbUEhJLUjZFSrbN7HFpWptvm7Sl
         GaSwRmGxSsGfIwsOe7CEyIqohQaFAmHttN1dvBcuzhFo0d/V6uc66jn/XTadUDcedh
         id4POZ4iJHNyykU5iSJREX2K2JiN13P19c3dbxAY=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.72.97-iva.dhcp.yndx.net (37.9.72.97-iva.dhcp.yndx.net [37.9.72.97])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id liA4tjrt5e-PXjqGfI8;
        Mon, 13 Jul 2020 21:25:33 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next 3/4] bpf: export some cgroup storages allocation helpers for reusing
Date:   Mon, 13 Jul 2020 21:25:19 +0300
Message-Id: <20200713182520.97606-4-zeil@yandex-team.ru>
In-Reply-To: <20200713182520.97606-1-zeil@yandex-team.ru>
References: <20200713182520.97606-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exports bpf_cgroup_storages_alloc and bpf_cgroup_storages_free
helpers to the header file and reuses them in bpf_test_run.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/linux/bpf-cgroup.h | 27 +++++++++++++++++++++++++++
 kernel/bpf/cgroup.c        | 25 -------------------------
 net/bpf/test_run.c         | 16 ++++------------
 3 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2c6f266..8bde9bb 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -175,6 +175,33 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				     void *value, u64 flags);
 
+static inline void bpf_cgroup_storages_free(struct bpf_cgroup_storage
+					    *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype)
+		bpf_cgroup_storage_free(storage[stype]);
+}
+
+static inline int bpf_cgroup_storages_alloc(struct bpf_cgroup_storage
+					    *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
+					    struct bpf_prog *prog)
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype) {
+		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
+		if (IS_ERR(storage[stype])) {
+			storage[stype] = NULL;
+			bpf_cgroup_storages_free(storage);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
 ({									      \
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ac53102..e4c2792 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -28,31 +28,6 @@ void cgroup_bpf_offline(struct cgroup *cgrp)
 	percpu_ref_kill(&cgrp->bpf.refcnt);
 }
 
-static void bpf_cgroup_storages_free(struct bpf_cgroup_storage *storages[])
-{
-	enum bpf_cgroup_storage_type stype;
-
-	for_each_cgroup_storage_type(stype)
-		bpf_cgroup_storage_free(storages[stype]);
-}
-
-static int bpf_cgroup_storages_alloc(struct bpf_cgroup_storage *storages[],
-				     struct bpf_prog *prog)
-{
-	enum bpf_cgroup_storage_type stype;
-
-	for_each_cgroup_storage_type(stype) {
-		storages[stype] = bpf_cgroup_storage_alloc(prog, stype);
-		if (IS_ERR(storages[stype])) {
-			storages[stype] = NULL;
-			bpf_cgroup_storages_free(storages);
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-
 static void bpf_cgroup_storages_assign(struct bpf_cgroup_storage *dst[],
 				       struct bpf_cgroup_storage *src[])
 {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 1e10a7e..5c4835c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -19,20 +19,13 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
-	enum bpf_cgroup_storage_type stype;
 	u64 time_start, time_spent = 0;
 	int ret = 0;
 	u32 i;
 
-	for_each_cgroup_storage_type(stype) {
-		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
-		if (IS_ERR(storage[stype])) {
-			storage[stype] = NULL;
-			for_each_cgroup_storage_type(stype)
-				bpf_cgroup_storage_free(storage[stype]);
-			return -ENOMEM;
-		}
-	}
+	ret = bpf_cgroup_storages_alloc(storage, prog);
+	if (ret)
+		return ret;
 
 	if (!repeat)
 		repeat = 1;
@@ -72,8 +65,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	do_div(time_spent, repeat);
 	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
 
-	for_each_cgroup_storage_type(stype)
-		bpf_cgroup_storage_free(storage[stype]);
+	bpf_cgroup_storages_free(storage);
 
 	return ret;
 }
-- 
2.7.4

