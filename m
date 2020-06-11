Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A1D1F7004
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFKWXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgFKWXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:23:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1766CC03E96F;
        Thu, 11 Jun 2020 15:23:49 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s88so2955693pjb.5;
        Thu, 11 Jun 2020 15:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SMohPLnADyASUuCmjLLpM/fXOGnmOCBuKNzqUPCiq90=;
        b=gjX6a+CExv1cpswwvbPhDB8sUOxuozFyo6qyaEFDsLOyXhhjBuHmPE4i1bVUb5nGgg
         jRAz9X7RXrnDOz36D6MovdtP2EcAZXj+g2QtSJGrSZeNet4Te8aDQxcf6Wx3b0+orC2n
         FyDPptPnKExUZ+eZJZciluqetpjWq5DjnTnGlD0Tkvjz98OfJ+sSSjj3Onu0NwQKHkz9
         CIXUssPRvC4rY1FyslinQMmM23RaRk/YqHAwinzTL9LdKHjf8JB0WOC2xij/7UnAevmm
         ZqHXTjstszl3ULRdG4mVP7nD8ZOjFCEOs2AzRBnpZuowWp2HB7Mk3RQSmalt1QIoVTsI
         C4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SMohPLnADyASUuCmjLLpM/fXOGnmOCBuKNzqUPCiq90=;
        b=AyJmebgggafpBw1ISaz+n5Gru1ZBoiP8ZeJKoP+bJjGbkN2/+0bk7gC6BxGGIS/fy4
         MBtxOevNOp09IKaBraq9SOgWfwRRKFBD5uxAddX4URMbmudJBTxRacORGmLfj3EX1RUT
         rCXQuKXrPITGRYTG6bide1CUJSvWQDQH3eKJTDFJJzAWhPIQeDO+O44LrDyW0AMQX23T
         omH/mh0K7uHNzJ/rSh2xeETG2KDzIonoeBwiSCzo/RG/qP5+NS9HtKN9hkAIdc3xpm2b
         G+n0JJSPMJdrM1gj82OrsTmQzWGHQEeIFLYj/Z5PzYdqWdFI6K3i3Wb/tTDurLJA+0TA
         sbAA==
X-Gm-Message-State: AOAM530nOdGszRmGCEGzUgp46KQu17lJjuFS0koUVXSKdHtRxIydXsWm
        RVLXZU6hgvf6cUMh9szib9E=
X-Google-Smtp-Source: ABdhPJziPUGxYW97HwZjlG12By+DLz/gmfxn4SGIYEnOr54TzQQlDCN/n7+e9vfmwIdqIOI3AxHwkA==
X-Received: by 2002:a17:902:49:: with SMTP id 67mr8782953pla.205.1591914228594;
        Thu, 11 Jun 2020 15:23:48 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id nl11sm8660651pjb.0.2020.06.11.15.23.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 15:23:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH RFC v3 bpf-next 2/4] bpf: Add bpf_copy_from_user() helper.
Date:   Thu, 11 Jun 2020 15:23:38 -0700
Message-Id: <20200611222340.24081-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Sleepable BPF programs can now use copy_from_user() to access user memory.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 ++++++++++-
 kernel/bpf/helpers.c           | 22 ++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 11 ++++++++++-
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6819000682a5..c8c9217f3ac9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1632,6 +1632,7 @@ extern const struct bpf_func_proto bpf_ringbuf_reserve_proto;
 extern const struct bpf_func_proto bpf_ringbuf_submit_proto;
 extern const struct bpf_func_proto bpf_ringbuf_discard_proto;
 extern const struct bpf_func_proto bpf_ringbuf_query_proto;
+extern const struct bpf_func_proto bpf_copy_from_user_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0bef454c9598..a38c806d34ad 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3260,6 +3260,13 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3397,7 +3404,9 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
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
index 3744372a24e2..c1e833000fc3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1098,6 +1098,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_ringbuf_discard_proto;
 	case BPF_FUNC_ringbuf_query:
 		return &bpf_ringbuf_query_proto;
+	case BPF_FUNC_copy_from_user:
+		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0bef454c9598..a38c806d34ad 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3260,6 +3260,13 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3397,7 +3404,9 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(copy_from_user),		\
+	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.23.0

