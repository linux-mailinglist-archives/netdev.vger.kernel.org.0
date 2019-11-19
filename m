Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752231028E7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfKSQIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:08:23 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:46297 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSQIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:08:23 -0500
Received: by mail-pj1-f68.google.com with SMTP id a16so2809115pjs.13;
        Tue, 19 Nov 2019 08:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K0ZrQzSNx++0gTcNWsr5sTYHxi0Jp8O7MVmhMwOwAMg=;
        b=N1XsKVhQzOw1/S2eW2Td57jbeXx438xtH8poBJNqyihq6R3UCSipYk9Re7oK5WW4eE
         JNeCY8BDfYdsBIGsxQWPAgdCm4LrXiXdaV/aKAW357UVQH6h7HGoIDemQ40Nd44iXTH2
         OTZA7lPkvhyyX3q9gNdjv4PDc3emWsNIwToNPXULHnYwkX6XcnN32XQmZQoEYqXoo0Rd
         AEp2iUelAorlQ3+tdXim96F9Wbwnu87bic4ZAKGiPuujQDlLSCRuceGLspGMf8sArSOY
         ci9BswNJVVE25lF53GSrRlEAflcP8qBM7qAdFvBwsSLErnE8qs3K18mbpCOSDN3pUrmt
         CJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K0ZrQzSNx++0gTcNWsr5sTYHxi0Jp8O7MVmhMwOwAMg=;
        b=eGaEnwGFfy9u4DhffAlb/WmiVlslOA3rbyXaNYZWEJD8xjfjzkUWw69p8saa1dH3Tc
         YyuDO5qwLk8djl1o/GaSVXEsesBaCyhAF7g7150LJcpWMZyKgWP5jCPIJAjxyc4iS45c
         txnFLkGYsn4oTnRGEEkltFN+Mbcv5qzd2CvP1ykOr2h8Y2pERMcf5jyctb2PEgxb+kRC
         0Ys4OEhAPHasUJbPwxUX+Ek08M302NupmnrmDUgTFspDywWAO7d7RLwV/YRyOoLvqLEs
         IrR4JrA3MTnOgFwvCBC/B9AhdJkHOLUbo6nBssEzcANoY3wyJASoLWfEa6lwlB97IbEG
         KSZw==
X-Gm-Message-State: APjAAAU07YV/4B/1EIa1KZkA8kNktwULlHj0x8dHYp71oHu2G/VV2Bg5
        YBgkOtCPr8FSnCFX2g9nDBgVjNGWsKAQ4w==
X-Google-Smtp-Source: APXvYqw0e2TaKVQR1OSIs4UFqTajbw8U/JflYQMfVbjX5VOcPbNqo5iLfRoqj1a3b+2ZF+t1nUw3xA==
X-Received: by 2002:a17:90a:eb18:: with SMTP id j24mr7716170pjz.85.1574179702603;
        Tue, 19 Nov 2019 08:08:22 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id v10sm25196949pfg.11.2019.11.19.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 08:08:21 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next 2/3] xdp: introduce xdp_call
Date:   Tue, 19 Nov 2019 17:07:56 +0100
Message-Id: <20191119160757.27714-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119160757.27714-1-bjorn.topel@gmail.com>
References: <20191119160757.27714-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xdp_call.h header wraps a more user-friendly API around the BPF
dispatcher. A user adds a trampoline/XDP caller using the
DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
xdp_call_update(). The actual dispatch is done via xdp_call().

The next patch will show-case how the i40e driver uses xdp_call.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/xdp_call.h | 66 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 include/linux/xdp_call.h

diff --git a/include/linux/xdp_call.h b/include/linux/xdp_call.h
new file mode 100644
index 000000000000..3591a834d4dd
--- /dev/null
+++ b/include/linux/xdp_call.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2019 Intel Corporation. */
+#ifndef _LINUX_XDP_CALL_H
+#define _LINUX_XDP_CALL_H
+
+#include <linux/filter.h>
+
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE)
+
+void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
+				struct bpf_prog *to);
+
+#define XDP_CALL_TRAMP(name)	____xdp_call_##name##_tramp
+
+#define DEFINE_XDP_CALL(name)						\
+	unsigned int XDP_CALL_TRAMP(name)(				\
+		const void *xdp_ctx,					\
+		const struct bpf_insn *insnsi,				\
+		unsigned int (*bpf_func)(const void *,			\
+					 const struct bpf_insn *))	\
+	{								\
+		return bpf_func(xdp_ctx, insnsi);			\
+	}
+
+#define DECLARE_XDP_CALL(name)						\
+	unsigned int XDP_CALL_TRAMP(name)(				\
+		const void *xdp_ctx,					\
+		const struct bpf_insn *insnsi,				\
+		unsigned int (*bpf_func)(const void *,			\
+					 const struct bpf_insn *))
+
+#define xdp_call_run(name, prog, ctx) ({				\
+	u32 ret;							\
+	cant_sleep();							\
+	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
+		struct bpf_prog_stats *stats;				\
+		u64 start = sched_clock();				\
+		ret = XDP_CALL_TRAMP(name)(ctx,				\
+					   (prog)->insnsi,		\
+					   (prog)->bpf_func);		\
+		stats = this_cpu_ptr((prog)->aux->stats);		\
+		u64_stats_update_begin(&stats->syncp);			\
+		stats->cnt++;						\
+		stats->nsecs += sched_clock() - start;			\
+		u64_stats_update_end(&stats->syncp);			\
+	} else {							\
+		ret = XDP_CALL_TRAMP(name)(ctx,				\
+					   (prog)->insnsi,		\
+					   (prog)->bpf_func);		\
+	}								\
+	ret; })
+
+#define xdp_call_update(name, from_xdp_prog, to_xdp_prog)	\
+	bpf_dispatcher_change_prog(&XDP_CALL_TRAMP(name),	\
+				   from_xdp_prog,		\
+				   to_xdp_prog)
+
+#else /* !defined(CONFIG_BPF_JIT) || !defined(CONFIG_RETPOLINE) */
+
+#define DEFINE_XDP_CALL(name)
+#define DECLARE_XDP_CALL(name)
+#define xdp_call_run(name, xdp_prog, xdp) bpf_prog_run_xdp(xdp_prog, xdp)
+#define xdp_call_update(name, from_xdp_prog, to_xdp_prog)
+
+#endif /* defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE) */
+#endif /* _LINUX_XDP_CALL_H */
-- 
2.20.1

