Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D269E153A9
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfEFSb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 14:31:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43021 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEFSb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 14:31:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so2009431pfa.10
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 11:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u2WJ5ZOtTqRCq2Bj3IyfnxMM9vIhsCBOCI54Jc0LH2Q=;
        b=wHqNHSAsS23xI3ZnU/TXNpgHK+naa0sZTuUJTkw5wNoYxgD4TWaLI1PobG9xOoyzxQ
         MlZh0VSWy8sGnbihqFf6QyghvhKC4Eqwjii6zk3RM5qxGJe67sI14zqOgLtNgMNcmq8G
         ES2qaktt/Ae3srP88KrdZfDDVTvJNi1fLaaxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u2WJ5ZOtTqRCq2Bj3IyfnxMM9vIhsCBOCI54Jc0LH2Q=;
        b=dVdMpWaIyDaBicLoL80qHSZnBVACf4Pi8613QMZuG04AD2A1XYTkESARLjqjTQh0qn
         Ipxd+FY1+lLjyz/85NiUUYH/cmJ0xMgMQvYR6xWQMsewQkE6iL2+i6Jbc98mmspE8xbv
         MDddWF6TdabTKfFxd5uCTOmkE7eH/beOUx4WaaQhGcu5N/7l5hQVpjBvqodgoUF5r4PL
         Ec6PtSu8XCDbgpxD/dqlJTXBeJP8J3SY2P4qjTUR2jqQA4qS1a16TnXXNsdPoxbHlnV3
         cV9FbMG03IEFvip09Yrpkw44eCZaQyqlBnTPpGrc6/Et5YmzK5Us8jAcYka9lTxSuMdz
         pPnw==
X-Gm-Message-State: APjAAAViCJ7xTIL6KZvmbMNUKW0FoLVbZ50V7vTmN4qOETopg8od/bqW
        N/a3PEgZ/PL0NVb/Q6mpYVPUgQ==
X-Google-Smtp-Source: APXvYqzCtja3Z7+DUcUlq2ExNEHUs7lMAhzHKGQIy9/x0+a2YCuTRp0jHZFxvINK29euToRW4QLdjA==
X-Received: by 2002:a63:5c1b:: with SMTP id q27mr34566094pgb.127.1557167484501;
        Mon, 06 May 2019 11:31:24 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h30sm21412414pgi.38.2019.05.06.11.31.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 11:31:23 -0700 (PDT)
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/4] bpf: Add support for reading user pointers
Date:   Mon,  6 May 2019 14:31:13 -0400
Message-Id: <20190506183116.33014-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
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
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-team@android.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
Masami, could you carry these patches in the series where are you add
probe_user_read function?

Previous submissions is here:
https://lore.kernel.org/patchwork/patch/1069552/
v1->v2: split tools uapi sync into separate commit, added deprecation
warning for old bpf_probe_read function.

 include/uapi/linux/bpf.h |  9 ++++++++-
 kernel/trace/bpf_trace.c | 22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 929c8e537a14..8146784b9fe3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2431,6 +2431,12 @@ union bpf_attr {
  *	Return
  *		A **struct bpf_sock** pointer on success, or **NULL** in
  *		case of failure.
+ *
+ * int bpf_probe_read_user(void *dst, int size, void *src)
+ *     Description
+ *             Read a userspace pointer safely.
+ *     Return
+ *             0 on success or negative error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2531,7 +2537,8 @@ union bpf_attr {
 	FN(sk_fullsock),		\
 	FN(tcp_sock),			\
 	FN(skb_ecn_set_ce),		\
-	FN(get_listener_sock),
+	FN(get_listener_sock),		\
+	FN(probe_read_user),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d64c00afceb5..7485deb0777f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -153,6 +153,26 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
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
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 	   u32, size)
 {
@@ -571,6 +591,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_delete_elem_proto;
 	case BPF_FUNC_probe_read:
 		return &bpf_probe_read_proto;
+	case BPF_FUNC_probe_read_user:
+		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_tail_call:
-- 
2.21.0.1020.gf2820cf01a-goog
