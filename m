Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB9277867
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgIXSVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:21:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:39316 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgIXSVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:21:38 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLVs8-0003zv-Ej; Thu, 24 Sep 2020 20:21:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/6] bpf: add classid helper only based on skb->sk
Date:   Thu, 24 Sep 2020 20:21:22 +0200
Message-Id: <2e761d23d591a9536eaa3ecd4be8d78c99f00964.1600967205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1600967205.git.daniel@iogearbox.net>
References: <cover.1600967205.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to 5a52ae4e32a6 ("bpf: Allow to retrieve cgroup v1 classid
from v2 hooks"), add a helper to retrieve cgroup v1 classid solely
based on the skb->sk, so it can be used as key as part of BPF map
lookups out of tc from host ns, in particular given the skb->sk is
retained these days when crossing net ns thanks to 9c4c325252c5
("skbuff: preserve sock reference when scrubbing the skb."). This
is similar to bpf_skb_cgroup_id() which implements the same for v2.
Kubernetes ecosystem is still operating on v1 however, hence net_cls
needs to be used there until this can be dropped in with the v2
helper of bpf_skb_cgroup_id().

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/bpf.h       | 10 ++++++++++
 net/core/filter.c              | 21 +++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 10 ++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..48ecf246d047 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3586,6 +3586,15 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_skb_cgroup_classid(struct sk_buff *skb)
+ * 	Description
+ * 		See **bpf_get_cgroup_classid**\ () for the main description.
+ * 		This helper differs from **bpf_get_cgroup_classid**\ () in that
+ * 		the cgroup v1 net_cls class is retrieved only from the *skb*'s
+ * 		associated socket instead of the current process.
+ * 	Return
+ * 		The id is returned or 0 in case the id could not be retrieved.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3746,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(skb_cgroup_classid),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 6014e5f40c58..0f913755bcba 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2704,6 +2704,23 @@ static const struct bpf_func_proto bpf_get_cgroup_classid_curr_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 };
+
+BPF_CALL_1(bpf_skb_cgroup_classid, const struct sk_buff *, skb)
+{
+	struct sock *sk = skb_to_full_sk(skb);
+
+	if (!sk || !sk_fullsock(sk))
+		return 0;
+
+	return sock_cgroup_classid(&sk->sk_cgrp_data);
+}
+
+static const struct bpf_func_proto bpf_skb_cgroup_classid_proto = {
+	.func		= bpf_skb_cgroup_classid,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
 #endif
 
 BPF_CALL_1(bpf_get_cgroup_classid, const struct sk_buff *, skb)
@@ -6770,6 +6787,10 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_skb_get_xfrm_state:
 		return &bpf_skb_get_xfrm_state_proto;
 #endif
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	case BPF_FUNC_skb_cgroup_classid:
+		return &bpf_skb_cgroup_classid_proto;
+#endif
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..48ecf246d047 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3586,6 +3586,15 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_skb_cgroup_classid(struct sk_buff *skb)
+ * 	Description
+ * 		See **bpf_get_cgroup_classid**\ () for the main description.
+ * 		This helper differs from **bpf_get_cgroup_classid**\ () in that
+ * 		the cgroup v1 net_cls class is retrieved only from the *skb*'s
+ * 		associated socket instead of the current process.
+ * 	Return
+ * 		The id is returned or 0 in case the id could not be retrieved.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3746,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(skb_cgroup_classid),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.21.0

