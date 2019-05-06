Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB49153B2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfEFSbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 14:31:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35803 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfEFSb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 14:31:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id h1so6883738pgs.2
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 11:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xhmLyaLAyu6ZncCjM6Pqxqgn8DvO3yzF5Ng7O6wfqzc=;
        b=xbBnkKUCkXZY8xbWHpA3tGU2J7SUUx7/NLgLAt3tyGUz03dKifE0RSHJtvpC+RPCPv
         IBlhboZr1JR6xw9oxPJLxTvvJ748640oM2RDzJFONho4jUOlkEZD8ihYogfdw8deWRWT
         /FwK3KlFafEFliWQl5Icqlt4W/GFxdGVylpIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xhmLyaLAyu6ZncCjM6Pqxqgn8DvO3yzF5Ng7O6wfqzc=;
        b=kvj9JX1buEW44c/5JmcwcHcRVAUAGQxZMv8c1+a15FPVSVHzH9rB+N6vmL08EgUJEq
         Y0Mhd4eLwN7XYgU+wZy0p7qfZDHbj+L4UdEkSSSGI8/dcRufYmUKH2u4zxvlQ5GvJOcW
         03WS9bpB9vJ4sr5vOiPWqC99pQJPbfUqd1yLqzXXB17SKV6pMxVQ2EJx6Si4ppZpSp/3
         CX6jlZfIZUsPOaI/PnQ14o5b+M6HQV0BZa5QBiSSeaJ3Yv9ZoGRhBC1+U+bGnxT2ajki
         z30p8dWnCG3HcJTavDiOcIi6R1ovp9mUuCVEtZ/v5irfb9ByThmRv/iZJlozeUAkgbSw
         5CaA==
X-Gm-Message-State: APjAAAWGOy005iJSXFGhk0c3HmG+KWIBZhWWp1ctuBpLK/8+mvu5ktjY
        B85uhi4so6DewHog54r44s0pHw==
X-Google-Smtp-Source: APXvYqwcC5Kplq4r8tbbGJ9eiRVDoJAXyJYR3TAcvVzM6mKAQaUCaRbQ9kZ6/gmln3JqJYWTMS9nww==
X-Received: by 2002:a63:d345:: with SMTP id u5mr32124227pgi.83.1557167487924;
        Mon, 06 May 2019 11:31:27 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h30sm21412414pgi.38.2019.05.06.11.31.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 11:31:27 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf@vger.kernel.org, Brendan Gregg <brendan.d.gregg@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, netdev@vger.kernel.org,
        Peter Ziljstra <peterz@infradead.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v2 2/4] bpf: Add support for reading kernel pointers
Date:   Mon,  6 May 2019 14:31:14 -0400
Message-Id: <20190506183116.33014-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190506183116.33014-1-joel@joelfernandes.org>
References: <20190506183116.33014-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_probe_read function is ambiguous in whether the pointer being
read is a kernel or user one. Add a specific function for kernel pointer
in this patch. Previous patches add it for userspace pointers.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/uapi/linux/bpf.h |  9 ++++++++-
 kernel/trace/bpf_trace.c | 22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8146784b9fe3..05af4e1151d3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2437,6 +2437,12 @@ union bpf_attr {
  *             Read a userspace pointer safely.
  *     Return
  *             0 on success or negative error
+ *
+ * int bpf_probe_read_kernel(void *dst, int size, void *src)
+ *     Description
+ *             Read a kernel pointer safely.
+ *     Return
+ *             0 on success or negative error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2538,7 +2544,8 @@ union bpf_attr {
 	FN(tcp_sock),			\
 	FN(skb_ecn_set_ce),		\
 	FN(get_listener_sock),		\
-	FN(probe_read_user),
+	FN(probe_read_user),		\
+	FN(probe_read_kernel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7485deb0777f..99dc354fd62b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -153,6 +153,26 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size, const void *, unsafe_ptr)
+{
+	int ret;
+
+	ret = probe_kernel_read(dst, unsafe_ptr, size);
+	if (unlikely(ret < 0))
+		memset(dst, 0, size);
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
+	.func		= bpf_probe_read_kernel,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size, const void *, unsafe_ptr)
 {
 	int ret;
@@ -593,6 +613,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_probe_read_proto;
 	case BPF_FUNC_probe_read_user:
 		return &bpf_probe_read_user_proto;
+	case BPF_FUNC_probe_read_kernel:
+		return &bpf_probe_read_kernel_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_tail_call:
-- 
2.21.0.1020.gf2820cf01a-goog

