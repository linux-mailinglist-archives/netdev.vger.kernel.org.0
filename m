Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6758A195A7B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgC0P70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:50934 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgC0P7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:15 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO5-0007nK-Il; Fri, 27 Mar 2020 16:59:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 4/7] bpf: allow to retrieve cgroup v1 classid from v2 hooks
Date:   Fri, 27 Mar 2020 16:58:53 +0100
Message-Id: <555e1c69db7376c0947007b4951c260e1074efc3.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1585323121.git.daniel@iogearbox.net>
References: <cover.1585323121.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today, Kubernetes is still operating on cgroups v1, however, it is
possible to retrieve the task's classid based on 'current' out of
connect(), sendmsg(), recvmsg() and bind-related hooks for orchestrators
which attach to the root cgroup v2 hook in a mixed env like in case
of Cilium, for example, in order to then correlate certain pod traffic
and use it as part of the key for BPF map lookups.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/cls_cgroup.h |  7 ++++++-
 net/core/filter.c        | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 4295de3e6a4b..7e78e7d6f015 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -45,9 +45,14 @@ static inline void sock_update_classid(struct sock_cgroup_data *skcd)
 	sock_cgroup_set_classid(skcd, classid);
 }
 
+static inline u32 __task_get_classid(struct task_struct *task)
+{
+	return task_cls_state(task)->classid;
+}
+
 static inline u32 task_get_classid(const struct sk_buff *skb)
 {
-	u32 classid = task_cls_state(current)->classid;
+	u32 classid = __task_get_classid(current);
 
 	/* Due to the nature of the classifier it is required to ignore all
 	 * packets originating from softirq context as accessing `current'
diff --git a/net/core/filter.c b/net/core/filter.c
index e249a499cbe5..3083c7746ee0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2642,6 +2642,19 @@ static const struct bpf_func_proto bpf_msg_pop_data_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+#ifdef CONFIG_CGROUP_NET_CLASSID
+BPF_CALL_0(bpf_get_cgroup_classid_curr)
+{
+	return __task_get_classid(current);
+}
+
+static const struct bpf_func_proto bpf_get_cgroup_classid_curr_proto = {
+	.func		= bpf_get_cgroup_classid_curr,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+#endif
+
 BPF_CALL_1(bpf_get_cgroup_classid, const struct sk_buff *, skb)
 {
 	return task_get_classid(skb);
@@ -6005,6 +6018,10 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_netns_cookie_sock_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_event_output_data_proto;
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	case BPF_FUNC_get_cgroup_classid:
+		return &bpf_get_cgroup_classid_curr_proto;
+#endif
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6035,6 +6052,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_event_output_data_proto;
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	case BPF_FUNC_get_cgroup_classid:
+		return &bpf_get_cgroup_classid_curr_proto;
+#endif
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_tcp:
 		return &bpf_sock_addr_sk_lookup_tcp_proto;
-- 
2.21.0

