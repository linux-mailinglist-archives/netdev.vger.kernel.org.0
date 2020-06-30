Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF92320ECA8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgF3Ed5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgF3Edy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:33:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30578C061755;
        Mon, 29 Jun 2020 21:33:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 35so7976459ple.0;
        Mon, 29 Jun 2020 21:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+4fMSpntLvSOLWBtcAoJWegH80p1FYzcqwVUArAZAf0=;
        b=grTExM7XeE+zSyvhFWeiE5Ltj+VtdrxIr5b7x5lbMTkWBgG5l16fjl6AAAroHRxAAC
         5bB4hT2pz2EmT7C/TGgzozYi0iq5HQdXixVP470vkAS4FL2t+Xlqh4NJhLIufxuOramp
         ADtMtu9L8YF2IM6vbZ8E4w8fkDTbRpP+ellm8vK52YuxyM5HTw10ysz9HsNsFK0zABVN
         spEID88/y3QnrVgk2MqlM6IKeN1+Nyst/sQEaaopJPXGaveidteVGRhSv6p1K6NmW0+M
         8QKtuCRu8Dy58+2jkwnmJf/QFP9ZWkH4s/9mPj4eHTCCwB/LTUp4pteDLMGWM67PGl/C
         G+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+4fMSpntLvSOLWBtcAoJWegH80p1FYzcqwVUArAZAf0=;
        b=cSpmpeY+5UXMj22R7LC4jm39Qwo8RUXd3qdUUfh6d/9JasMl+lA6LcxMqqi2vJvsYV
         76eDS6Dke6YiMxhHubs564fPLx09B0WOJ3YJbXSHUItWoCfgpXVTDzBKcgaQWYVjqzGW
         cCTwgad/DbuPBLVQtYBL+LH7gF3EwOoA9ZUgKKOOWeYyFM3L8vpQgLG8YUH0L7S5kp8T
         uJeaoZN/ZHvE3G/totMP92E4SrW1R02wZERiYbRtB44RNaOiQ47HPmYxOBloDWRCqhCu
         v/TYg950sy3am6td5Gqi+s6opSuM9SHA16nYTO8DLW54cUvZ1UwUnHavUlOGuEXftH9m
         P0rg==
X-Gm-Message-State: AOAM531USDS1LNgYfHeZDWuumFrycNOOVrqXyZj+YizypJglolEblAaL
        5Ok7Sw6XWkB6L3mHGVhW5Mc=
X-Google-Smtp-Source: ABdhPJxTQkE/Yk3A3DX9tq1sw4QqoIGJeX+/YwThybjOFUZ08lWUovIqGZ0g7/O/Pyap4cWXKkRTbQ==
X-Received: by 2002:a17:90a:c5:: with SMTP id v5mr20781003pjd.192.1593491633715;
        Mon, 29 Jun 2020 21:33:53 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 21sm1111234pfv.43.2020.06.29.21.33.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 21:33:52 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 3/5] bpf: Add bpf_copy_from_user() helper.
Date:   Mon, 29 Jun 2020 21:33:41 -0700
Message-Id: <20200630043343.53195-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Sleepable BPF programs can now use copy_from_user() to access user memory.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 ++++++++++-
 kernel/bpf/helpers.c           | 22 ++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 11 ++++++++++-
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e2b1581b2195..c9f27d5fdb7c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1657,6 +1657,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
+extern const struct bpf_func_proto bpf_copy_from_user_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 73f9e3f84b77..6b347454dedc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3293,6 +3293,13 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3435,7 +3442,9 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(copy_from_user),		\
+	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be43ab3e619f..5cc7425ee476 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -601,6 +601,28 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_3(bpf_copy_from_user, void *, dst, u32, size,
+	   const void __user *, user_ptr)
+{
+	int ret = copy_from_user(dst, user_ptr, size);
+
+	if (unlikely(ret)) {
+		memset(dst, 0, size);
+		ret = -EFAULT;
+	}
+
+	return ret;
+}
+
+const struct bpf_func_proto bpf_copy_from_user_proto = {
+	.func		= bpf_copy_from_user,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5d59dda5f661..96121fa7f7e6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1137,6 +1137,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_ringbuf_query_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
+	case BPF_FUNC_copy_from_user:
+		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 73f9e3f84b77..6b347454dedc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3293,6 +3293,13 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3435,7 +3442,9 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(copy_from_user),		\
+	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.23.0

