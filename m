Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0464227EC35
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgI3PS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:18:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:51228 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgI3PS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:18:27 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNds9-0002xq-81; Wed, 30 Sep 2020 17:18:25 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 1/6] bpf: add classid helper only based on skb->sk
Date:   Wed, 30 Sep 2020 17:18:15 +0200
Message-Id: <ed633cf27a1c620e901c5aa99ebdefb028dce600.1601477936.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601477936.git.daniel@iogearbox.net>
References: <cover.1601477936.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25943/Wed Sep 30 15:54:21 2020)
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h       | 10 ++++++++++
 net/core/filter.c              | 21 +++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 10 ++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2b1d3f16cbd1..6116a7f54c8f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3643,6 +3643,15 @@ union bpf_attr {
  *		*flags* are identical to those used for bpf_snprintf_btf.
  *	Return
  *		0 on success or a negative error in case of failure.
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
@@ -3796,6 +3805,7 @@ union bpf_attr {
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
 	FN(seq_printf_btf),		\
+	FN(skb_cgroup_classid),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index af88935e24b1..fa01c697977d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2707,6 +2707,23 @@ static const struct bpf_func_proto bpf_get_cgroup_classid_curr_proto = {
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
@@ -6772,6 +6789,10 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 2b1d3f16cbd1..6116a7f54c8f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3643,6 +3643,15 @@ union bpf_attr {
  *		*flags* are identical to those used for bpf_snprintf_btf.
  *	Return
  *		0 on success or a negative error in case of failure.
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
@@ -3796,6 +3805,7 @@ union bpf_attr {
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
 	FN(seq_printf_btf),		\
+	FN(skb_cgroup_classid),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.21.0

