Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE37221594
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgGOTwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:52:02 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:43050 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgGOTvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:51:52 -0400
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 5268A2E137B;
        Wed, 15 Jul 2020 22:51:49 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 8ridnClXFG-pmsuJDqI;
        Wed, 15 Jul 2020 22:51:49 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594842709; bh=A3kRuO7Xlz90evll8iFzc1iluvX1ek0ZKo8bUWxoErM=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=yMfosvEE4rgtYgskdEWNTsIH/LUQla8V6Lpz78f0dT5T3piOs5B1+MhULRqub0DFq
         bdZ3tPNKbXB+eyK4EtlnT3GQJfwN+ru0d3EB9MJ198J5wE2L/k/7X0wdJSXVF/Ox1E
         WOf6Bj7LhrxZhdgFdrVQEqLdgaUC5mvdqtWCBhkE=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.121.196-vpn.dhcp.yndx.net (37.9.121.196-vpn.dhcp.yndx.net [37.9.121.196])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id kLmvqU3zdD-pmiKxZXU;
        Wed, 15 Jul 2020 22:51:48 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v3 3/4] bpf: export some cgroup storages allocation helpers for reusing
Date:   Wed, 15 Jul 2020 22:51:31 +0300
Message-Id: <20200715195132.4286-4-zeil@yandex-team.ru>
In-Reply-To: <20200715195132.4286-1-zeil@yandex-team.ru>
References: <20200715195132.4286-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exports bpf_cgroup_storages_alloc and bpf_cgroup_storages_free
helpers to the header file and reuses them in bpf_test_run.

v2:
  - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/linux/bpf-cgroup.h | 36 ++++++++++++++++++++++++++++++++++++
 kernel/bpf/cgroup.c        | 25 -------------------------
 net/bpf/test_run.c         | 16 ++++------------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2c6f266..5c10fe6 100644
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
@@ -398,6 +425,15 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 	return 0;
 }
 
+static inline void bpf_cgroup_storages_free(
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) {}
+
+static inline int bpf_cgroup_storages_alloc(
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
+	struct bpf_prog *prog) {
+	return 0;
+}
+
 #define cgroup_bpf_enabled (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
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
index 0e92973..050390d 100644
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

