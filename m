Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB128189C8C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCRNGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:06:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43128 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726836AbgCRNGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Hoi5M8jrzpBz0eRm1EPg/ttJQcIxZ+2hlA7Rs3PIMQ=;
        b=fXamj5OnV7tJysj6xvEIB1rMMqHpRnAcfBxoRzegoPPjB0d78ciiaEJq2gUXbEGYeK3t0k
        5c/XXO4mXf1TODjpYuZvTbslVzVzvP2Zul1wcdYbbk+Vk12t5SRZgD20tRec7MemwygkFB
        Dx+xcSRz4qZsV9jYz+HTqzuMX6+cbe4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-j0jJsaoRPYOnURA2S4o34Q-1; Wed, 18 Mar 2020 09:06:32 -0400
X-MC-Unique: j0jJsaoRPYOnURA2S4o34Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6971022F24;
        Wed, 18 Mar 2020 13:06:14 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89D099F56;
        Wed, 18 Mar 2020 13:06:13 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: [RFC PATCH bpf-next 1/3] bpf: introduce trace option to the BPF_PROG_TEST_RUN command API
Date:   Wed, 18 Mar 2020 13:06:11 +0000
Message-Id: <158453677145.3043.1585141550260881967.stgit@xdp-tutorial>
In-Reply-To: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a flag to the existing BPF_PROG_TEST_RUN API,
which will allow tracing for XDP programs.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/linux/filter.h         |   13 +++++++++++++
 include/uapi/linux/bpf.h       |    4 ++++
 kernel/bpf/syscall.c           |    2 +-
 net/bpf/test_run.c             |   17 +++++++++++------
 tools/include/uapi/linux/bpf.h |    4 ++++
 5 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 43b5e455d2f5..f95f9ad45ad6 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -737,6 +737,19 @@ static __always_inline u32 bpf_prog_run_xdp(const st=
ruct bpf_prog *prog,
 			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
 }
=20
+static __always_inline u32 bpf_prog_run_xdp_trace(const struct bpf_prog =
*prog,
+						  struct xdp_buff *xdp)
+{
+	/* Caller needs to hold rcu_read_lock() (!), otherwise program
+	 * can be released while still running, or map elements could be
+	 * freed early while still having concurrent users. XDP fastpath
+	 * already takes rcu_read_lock() when fetching the program, so
+	 * it's not necessary here anymore.
+	 */
+	return __BPF_PROG_RUN(prog, xdp,
+			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+}
+
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *pr=
og);
=20
 static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 40b2d9476268..ac5c89903550 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -375,6 +375,9 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* Flags for BPF_PROG_TEST_RUN. */
+#define BPF_F_TEST_ENABLE_TRACE (1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -511,6 +514,7 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32           flags;
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7ce0815793dd..9a6fae428976 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2680,7 +2680,7 @@ static int bpf_prog_query(const union bpf_attr *att=
r,
 	return cgroup_bpf_prog_query(attr, uattr);
 }
=20
-#define BPF_PROG_TEST_RUN_LAST_FIELD test.ctx_out
+#define BPF_PROG_TEST_RUN_LAST_FIELD test.flags
=20
 static int bpf_prog_test_run(const union bpf_attr *attr,
 			     union bpf_attr __user *uattr)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 4c921f5154e0..061cad840b05 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -16,7 +16,7 @@
 #include <trace/events/bpf_test_run.h>
=20
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
-			u32 *retval, u32 *time, bool xdp)
+			u32 *retval, u32 *time, bool xdp, bool trace)
 {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] =3D { N=
ULL };
 	enum bpf_cgroup_storage_type stype;
@@ -43,10 +43,14 @@ static int bpf_test_run(struct bpf_prog *prog, void *=
ctx, u32 repeat,
 	for (i =3D 0; i < repeat; i++) {
 		bpf_cgroup_storage_set(storage);
=20
-		if (xdp)
-			*retval =3D bpf_prog_run_xdp(prog, ctx);
-		else
+		if (xdp) {
+			if (trace)
+				*retval =3D bpf_prog_run_xdp_trace(prog, ctx);
+			else
+				*retval =3D bpf_prog_run_xdp(prog, ctx);
+		} else {
 			*retval =3D BPF_PROG_RUN(prog, ctx);
+		}
=20
 		if (signal_pending(current)) {
 			ret =3D -EINTR;
@@ -431,7 +435,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
 	ret =3D convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
-	ret =3D bpf_test_run(prog, skb, repeat, &retval, &duration, false);
+	ret =3D bpf_test_run(prog, skb, repeat, &retval, &duration, false, fals=
e);
 	if (ret)
 		goto out;
 	if (!is_l2) {
@@ -468,6 +472,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
 {
 	u32 size =3D kattr->test.data_size_in;
 	u32 repeat =3D kattr->test.repeat;
+	bool trace =3D kattr->test.flags & BPF_F_TEST_ENABLE_TRACE;
 	struct netdev_rx_queue *rxqueue;
 	struct xdp_buff xdp =3D {};
 	u32 retval, duration;
@@ -489,7 +494,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
 	rxqueue =3D __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev=
, 0);
 	xdp.rxq =3D &rxqueue->xdp_rxq;
 	bpf_prog_change_xdp(NULL, prog);
-	ret =3D bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+	ret =3D bpf_test_run(prog, &xdp, repeat, &retval, &duration, true, trac=
e);
 	if (ret)
 		goto out;
 	if (xdp.data !=3D data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 40b2d9476268..ac5c89903550 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -375,6 +375,9 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* Flags for BPF_PROG_TEST_RUN. */
+#define BPF_F_TEST_ENABLE_TRACE (1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY =3D 0,
@@ -511,6 +514,7 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32           flags;
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */

