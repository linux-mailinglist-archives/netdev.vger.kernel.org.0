Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8161A56D81C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiGKIcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiGKIcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:32:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A59DC1F630
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657528348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JjYLBUMSftH7/Ewb1QZ49Vc0Exdm+flUGINBW+1YvW0=;
        b=R9VXMZQZxbvx9qCcv8cwKgmPRPJCNwpOmdE/nl70gZurdtgIn6Pif/tiCnGRy1tLll8Wop
        o3UQnllDVLnyLD9SC1Z4gFiw6kJPyyjlm/HKGBxUT3hoSiWyljscouK+aHzIlZ7Ahi7DvD
        Zbmts1dy4rvXFXfbfsncqI5HhKmqxh4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-m3OBsIK6PtyXp0jhmv-5iQ-1; Mon, 11 Jul 2022 04:32:23 -0400
X-MC-Unique: m3OBsIK6PtyXp0jhmv-5iQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BCD8185A79C;
        Mon, 11 Jul 2022 08:32:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 096F440CF8EA;
        Mon, 11 Jul 2022 08:32:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 020A51C02A5; Mon, 11 Jul 2022 10:32:22 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
Date:   Mon, 11 Jul 2022 10:32:19 +0200
Message-Id: <20220711083220.2175036-4-asavkov@redhat.com>
In-Reply-To: <20220711083220.2175036-1-asavkov@redhat.com>
References: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper that will make the kernel panic immediately with specified
message. Using this helper requires kernel.destructive_bpf_enabled sysctl
to be enabled, BPF_F_DESTRUCTIVE flag to be supplied on program load as
well as CAP_SYS_BOOT capabilities.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 13 +++++++++++++
 kernel/bpf/verifier.c          |  7 +++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 7 files changed, 38 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 43c008e3587a..77c20ba9ca8e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2339,6 +2339,7 @@ extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_jiffies64_proto;
+extern const struct bpf_func_proto bpf_panic_proto;
 extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_event_output_data_proto;
 extern const struct bpf_func_proto bpf_ringbuf_output_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4423874b5da4..e2e2c4de44ee 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3927,6 +3927,12 @@ union bpf_attr {
  *	Return
  *		The 64 bit jiffies
  *
+ * void bpf_panic(const char *msg)
+ *	Description
+ *		Make the kernel panic immediately
+ *	Return
+ *		void
+ *
  * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
  *	Description
  *		For an eBPF program attached to a perf event, retrieve the
@@ -5452,6 +5458,7 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
+	FN(panic),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b5ffebcce6cc..0f333a0e85a5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2649,6 +2649,7 @@ const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto __weak;
 const struct bpf_func_proto bpf_spin_lock_proto __weak;
 const struct bpf_func_proto bpf_spin_unlock_proto __weak;
 const struct bpf_func_proto bpf_jiffies64_proto __weak;
+const struct bpf_func_proto bpf_panic_proto __weak;
 
 const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a1c84d256f83..5cb90208a264 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -374,6 +374,19 @@ const struct bpf_func_proto bpf_jiffies64_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_1(bpf_panic, const char *, msg)
+{
+	panic(msg);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_panic_proto = {
+	.func		= bpf_panic,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_CONST_STR,
+};
+
 #ifdef CONFIG_CGROUPS
 BPF_CALL_0(bpf_get_current_cgroup_id)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2859901ffbe3..f49c026917c5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7285,6 +7285,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 				reg_type_str(env, regs[BPF_REG_1].type));
 			return -EACCES;
 		}
+		break;
+	case BPF_FUNC_panic:
+		struct bpf_prog_aux *aux = env->prog->aux;
+		if (!aux->destructive) {
+			verbose(env, "bpf_panic() calls require BPF_F_DESTRUCTIVE flag\n");
+			return -EACCES;
+		}
 	}
 
 	if (err)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4be976cf7d63..3ee888507795 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1304,6 +1304,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_find_vma_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
+	case BPF_FUNC_panic:
+		return capable(CAP_SYS_BOOT) && destructive_ebpf_enabled() ? &bpf_panic_proto : NULL;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4423874b5da4..e2e2c4de44ee 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3927,6 +3927,12 @@ union bpf_attr {
  *	Return
  *		The 64 bit jiffies
  *
+ * void bpf_panic(const char *msg)
+ *	Description
+ *		Make the kernel panic immediately
+ *	Return
+ *		void
+ *
  * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
  *	Description
  *		For an eBPF program attached to a perf event, retrieve the
@@ -5452,6 +5458,7 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
+	FN(panic),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
-- 
2.35.3

