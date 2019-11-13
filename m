Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FDEFBA32
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKMUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:48:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39933 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKMUsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:48:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so2443805pfo.6;
        Wed, 13 Nov 2019 12:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RDqExjLSfa62qPvgMCMSCU7ZsksGthSKOKxyyHhHC1g=;
        b=h0ZELYWtAaPORy0Z8QXqOtjTwfEid9xamAbfY0h99lpF703hzanlWGCcwRaOKKPIDx
         6+TgbgdVGWdne9EdwtnVyii84ECPlZb08MXwY0WctH+2fT46+zA1yi8BTKR12oSwnMeY
         OT8W3EfOJ8Dy1IpX9W8hvVtAKzcQ3mNdZL6D2hoRvcucYBWM5q0JfxhGHgRFehDhL43n
         83xiNjVAC0t/c8LpJKKFqmxg8FoIPBb6VTEbYGarmPGvAvplLxBjcg86l+XRr1wZQyal
         Uy8tVQqXXBPAJZ2ZRZSdMHoJb2J4AnUTfKWUIGnqGRVbMvRLp4I0X26wB1DOib3HQBEZ
         KMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RDqExjLSfa62qPvgMCMSCU7ZsksGthSKOKxyyHhHC1g=;
        b=BKFaL8O2rD3N9fYD4lGjrmY0mX6ap1r8vrmxAt6Ouokt6NUjr7x644F1sJsH/fA7Km
         DWu2QFJMuImDnvcha/sbKqk0TFV34T1slYcQyR21MZC9cH8T4juSi4v0C4dRLC+E3Boo
         blyXM/nK3EgPQoktItxj6DqQJ9N9PVsG/KkjWkhXMn6b+lZdfH7U4jYvl5zf1x965u3o
         lHHP6a9cDCHw5PHeJMKZtk7q1xACIRa7XRWIZ6qMq+TuCVu3mWCzYjsDWdbKDxxanzpY
         Zf+cNirop4T+lGwxikPIf1Y0CwellDkuTDrtMh7J0C3VZfFq0li7/bbrvKplqjACSfgE
         kVqA==
X-Gm-Message-State: APjAAAVHA0HwKTsyIsN/MM33q0i9lFmC5N9iwilLPoRoZAKUbXeg/4Kw
        kEUz6IfxGRe7IrHl3PfITTurS4Dz4qE=
X-Google-Smtp-Source: APXvYqyjOEo10AadQlUUJTqPlEV605cRIZlVXbSPOYcf7uj1iq3BVOCI6GkLoA+PFFo/mh/qdjebrg==
X-Received: by 2002:a62:8013:: with SMTP id j19mr5136727pfd.220.1573678088018;
        Wed, 13 Nov 2019 12:48:08 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g20sm3235861pgk.46.2019.11.13.12.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:48:07 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 3/4] xdp: introduce xdp_call
Date:   Wed, 13 Nov 2019 21:47:36 +0100
Message-Id: <20191113204737.31623-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113204737.31623-1-bjorn.topel@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
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

The next commit will show-case how the i40e uses xdp_call.

When static_call, especially the inlined version, is upstreamed it
will be used by xdp_call.h.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/xdp_call.h | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 include/linux/xdp_call.h

diff --git a/include/linux/xdp_call.h b/include/linux/xdp_call.h
new file mode 100644
index 000000000000..e736a4d3c961
--- /dev/null
+++ b/include/linux/xdp_call.h
@@ -0,0 +1,49 @@
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
+#define xdp_call_run(name, xdp_prog, xdp)				\
+	XDP_CALL_TRAMP(name)(xdp, xdp_prog->insnsi,			\
+			     xdp_prog->bpf_func)
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

