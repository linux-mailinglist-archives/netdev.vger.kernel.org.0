Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4128107D60
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 08:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKWHM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 02:12:59 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:45150 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfKWHM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 02:12:59 -0500
Received: by mail-pj1-f68.google.com with SMTP id m71so4138745pjb.12;
        Fri, 22 Nov 2019 23:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfpQmDWhPJt2vz87aoevLy9S7AKhGriCid8BaPfYIDw=;
        b=ilSml1AwJwwqqM5vQiv9YXyI4lDY/egnuAkUze6JpPj0p0K0CdidV9G2agPOgByh5G
         j52S27Cu4w2YOsGkoJQsQXCXX59zlCKP9jMsMjhVOitZv+kcIvLMzSSzl7Ti3Bs1849l
         /5QPkASbHaEciQbPmlOFpPm6o0T6pJxZgTDfPYqPTs2DB9EEuUSDKTKvPcqMbWyIi/i/
         FbA2/UlDlRUUOS6BHJBOk/H0rgzq9lSSJM6Tf3oXacW6ZDRdZapPCoVxyAFOaNRPltqo
         LuBGWtOnUztdXPATRBs5nLnQYiJpAlbFG4fArLZWgpXeThzbEXAEdxzgZHP4pWZIabZy
         UQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfpQmDWhPJt2vz87aoevLy9S7AKhGriCid8BaPfYIDw=;
        b=aLkt58Y8jZMqjFLTQI5bxCl0Zd9gJ6ruGQaowCpiBYZxbwcryeN/nFEwqyZyW8Jlrc
         SN7P5q2EATDRIeH1U9swJ/eVCKqw7ElDQ7fFgtb29pPOH1mq06yeAtskriU9rZXJSACR
         1/TBmk3LTWRTs6/tffJ8ND8kE8Yt0z8028PeV7CkJW4YhqA/wX0eoDgxGguK7+jEPTJZ
         4OSuZQy97fIY7yo5NKg5O0RLNzSfjrgXnVOkpdHQYazyrlavpovnPhu/XEji5p1iAI3l
         7CNfl3xXRey1IbJ8EfuM15N8k0iuGWYBhPYY/SBULWwHLVdJxtFJsXBQ4sh74QPvAfKL
         h5NQ==
X-Gm-Message-State: APjAAAVsz0rr+czpcHCh4KLZlVKNrFZvWgZoVO8wryY7DzUODfAN/AkH
        oUA+jF6e5CDbf2nsj+tQrjkQbgHblCGxPA==
X-Google-Smtp-Source: APXvYqw4MqM3rS+BYZAPsAldradQ4TtzSxoLd4s7sX3XdDAWBTeqD4OWTsYAnIVE1hYU49usN4B1rA==
X-Received: by 2002:a17:902:b08e:: with SMTP id p14mr107928plr.137.1574493176966;
        Fri, 22 Nov 2019 23:12:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 67sm798960pjz.27.2019.11.22.23.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 23:12:56 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
Date:   Sat, 23 Nov 2019 08:12:21 +0100
Message-Id: <20191123071226.6501-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123071226.6501-1-bjorn.topel@gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
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

Note that xdp_call() is only supported for builtin drivers. Module
builds will fallback to bpf_prog_run_xdp().

The next patch will show-case how the i40e driver uses xdp_call.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/xdp_call.h | 66 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 include/linux/xdp_call.h

diff --git a/include/linux/xdp_call.h b/include/linux/xdp_call.h
new file mode 100644
index 000000000000..69b2d325a787
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
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE) && !defined(MODULE)
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
+#else
+
+#define DEFINE_XDP_CALL(name)
+#define DECLARE_XDP_CALL(name)
+#define xdp_call_run(name, xdp_prog, xdp) bpf_prog_run_xdp(xdp_prog, xdp)
+#define xdp_call_update(name, from_xdp_prog, to_xdp_prog)
+
+#endif
+#endif /* _LINUX_XDP_CALL_H */
-- 
2.20.1

