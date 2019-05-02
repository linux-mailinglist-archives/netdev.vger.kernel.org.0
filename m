Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537C712399
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEBUuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:50:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42497 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:50:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id 13so1400664pfw.9
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqK4F74BYTnxDF6DGnM76VZNOXm63oX3OibjNAJ2G0w=;
        b=lRkBHX5u0n7NOju/0lB03GeOHhl0aQfQGoYpmBgwxU6KQ8bORcYAdbW7HYy5E2kr3V
         35XxBirWrHyGREnXPnC0DENRt2Qg2uqlT+lb7+NvvyFODoAJXXWEji/UaTxwbItvTbx/
         xox33FKUuqLTkyvBiFzZMGqzSt4RzSoXulD08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqK4F74BYTnxDF6DGnM76VZNOXm63oX3OibjNAJ2G0w=;
        b=CoCh2cqyt1Yk4nD60IxWLd6mUkdgZSVPRusvxbFtWFZ9C8QEff7mIyL+dBMuReTMvV
         hYFHsS5lGzIpCeD+z1XIDSGdQp5weBaTP/r1x0z664+oBxKTPi0k76tjcbvuh0Jn45kx
         eL4lkVbUY4lC7iibN222Domixb4zWirqWOHkVIlIi3T875YhxtJmhmrSfqH7tKPK0uip
         RsfeuNOP1KoMj56Xupd681FCUmDccK2N+7nqwaBCFnJ92g6asRD9BFW0cYc9NzcRFKPR
         YTvo/admjA6iMS9+IxUoP/IX52HzTbFV0w83TtM6uG03qI1HdtJJwoqptBIyN9IO7JaU
         YpXA==
X-Gm-Message-State: APjAAAW1HNpfWDpXiy7Oh7Ou7SHQty51YAx3p4rgUZFjfRdGnWFHGTaH
        CiHdeGuq0AScnEGtS5tByrzLNA==
X-Google-Smtp-Source: APXvYqw5siQvRctLR91lPY6JCCdXuw5iDjWFgINmHitghfuAOiZa2Kefd9YmDcfT3G02+zGCS/6bTg==
X-Received: by 2002:a63:c702:: with SMTP id n2mr6099216pgg.255.1556830207779;
        Thu, 02 May 2019 13:50:07 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id i129sm51334pfc.163.2019.05.02.13.50.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:50:06 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC] bpf: Add support for reading user pointers
Date:   Thu,  2 May 2019 16:49:58 -0400
Message-Id: <20190502204958.7868-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF based opensnoop tool fails to read the file path string passed
to the do_sys_open function. This is because it is a pointer to
userspace address and causes an -EFAULT when read with
probe_kernel_read. This is not an issue when running the tool on x86 but
is an issue on arm64. This patch adds a new bpf function call based
which calls the recently proposed probe_user_read function [1].
Using this function call from opensnoop fixes the issue on arm64.

[1] https://lore.kernel.org/patchwork/patch/1051588/

Cc: Michal Gregorczyk <michalgr@live.com>
Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
Cc: Mohammad Husain <russoue@gmail.com>
Cc: Qais Yousef <qais.yousef@arm.com>
Cc: Srinivas Ramana <sramana@codeaurora.org>
Cc: duyuchao <yuchao.du@unisoc.com>
Cc: Manjo Raja Rao <linux@manojrajarao.com>
Cc: Karim Yaghmour <karim.yaghmour@opersys.com>
Cc: Tamir Carmeli <carmeli.tamir@gmail.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Ziljstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-team@android.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/uapi/linux/bpf.h       |  7 ++++++-
 kernel/trace/bpf_trace.c       | 22 ++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++++-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e99e3e6f8b37..6fec701eaa46 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -539,6 +539,10 @@ union bpf_attr {
  *     @mode: operation mode (enum bpf_adj_room_mode)
  *     @flags: reserved for future use
  *     Return: 0 on success or negative error code
+ *
+ * int bpf_probe_read_user(void *dst, int size, void *src)
+ *     Read a userspace pointer safely.
+ *     Return: 0 on success or negative error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -591,7 +595,8 @@ union bpf_attr {
 	FN(get_socket_uid),		\
 	FN(set_hash),			\
 	FN(setsockopt),			\
-	FN(skb_adjust_room),
+	FN(skb_adjust_room),		\
+	FN(probe_read_user),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index dc498b605d5d..1e1a11d9faa8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -81,6 +81,26 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size, const void *, unsafe_ptr)
+{
+	int ret;
+
+	ret = probe_user_read(dst, unsafe_ptr, size);
+	if (unlikely(ret < 0))
+		memset(dst, 0, size);
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_user_proto = {
+	.func		= bpf_probe_read_user,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 	   u32, size)
 {
@@ -459,6 +479,8 @@ static const struct bpf_func_proto *tracing_func_proto(enum bpf_func_id func_id)
 		return &bpf_map_delete_elem_proto;
 	case BPF_FUNC_probe_read:
 		return &bpf_probe_read_proto;
+	case BPF_FUNC_probe_read_user:
+		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_tail_call:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e99e3e6f8b37..6fec701eaa46 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -539,6 +539,10 @@ union bpf_attr {
  *     @mode: operation mode (enum bpf_adj_room_mode)
  *     @flags: reserved for future use
  *     Return: 0 on success or negative error code
+ *
+ * int bpf_probe_read_user(void *dst, int size, void *src)
+ *     Read a userspace pointer safely.
+ *     Return: 0 on success or negative error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -591,7 +595,8 @@ union bpf_attr {
 	FN(get_socket_uid),		\
 	FN(set_hash),			\
 	FN(setsockopt),			\
-	FN(skb_adjust_room),
+	FN(skb_adjust_room),		\
+	FN(probe_read_user),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.21.0.593.g511ec345e18-goog

