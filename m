Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6161829D585
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgJ1WEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729558AbgJ1WE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:04:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBF4C0613CF;
        Wed, 28 Oct 2020 15:04:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k25so888273lji.9;
        Wed, 28 Oct 2020 15:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJiZ9iAK7kcO+Hxs+q20RNdzcQj6XtdpNW/oWtLmq24=;
        b=uWXWua8tbEjqUBZjJLOnjBWZRD6qYpRGY59Wchjco/dQrP5K7bLZQk3BDVYiwX2s++
         ZwUKDeDvb6H3icb3lzcDx6/y4L49XZKiqWiwJb9FPyxe+nHscBiQI/q+1ReABLrxFYCd
         4bTn7K5NfPz7kkgnzI+iCP+4RQbBVBq2HUqVv0tS/jASsXLlq1yfL1/srz7cuIKLltzP
         T78ua5CI/olAesPjEDFRTQTF2b5I8WxikYaW15r/A6Ct3BY8bnTB7sGYDk4qQeyYJ98Y
         q7gnHmaZ962h/u381O5PTLMdVQmr3Ot8YtXrgyy1P4vHUqspUcar3/UELaPsJ56lMAF1
         dyaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJiZ9iAK7kcO+Hxs+q20RNdzcQj6XtdpNW/oWtLmq24=;
        b=ah7blkkptTFx/Q+MSGT3/9UwyG4jjhGa5D0lyMmmHrbPhg+U0yR17AKJnejAOuX0jZ
         0hUUkPArB+i3iZlI0YE22iyt5Zfqd2L0PYEzrcDzCC1t8N6RiPStoQTati6ZZfMcKsTW
         Vd4Y8ahHWpR7zojMx5Wzzjx/pWPUL6pbwcN6fMZgVMe6gzKqNq8BiLNXgR/v30S5dOOP
         XedRYZWg/cIKfZrHO0F+PUQs+dIYTshm1zdaqbhqvO0nGoZX7dNmlApIwTR20l3k97YV
         CV3KfTH4FV27tdbJ3rokM2R1xDK5DLdLBvVPcvlUs4eJRoxcJ3qIW47d50vUcDnWQK0X
         XYMg==
X-Gm-Message-State: AOAM533iCzoBd3nTAD58lkAJsHjKHuVl98h7q/aWmDSGybYY24v8kipi
        V44BtieEclNcXCu9ugEFEou57DrUQU6aaA==
X-Google-Smtp-Source: ABdhPJwrUA3LwVfLg0JZ7XUbmkvj7UBmZ/R/3mQ8/tdeTXv3WgSDeunVxyrdi6z74AkeWoiAXHE1eQ==
X-Received: by 2002:a5d:6cc8:: with SMTP id c8mr616045wrc.233.1603909265560;
        Wed, 28 Oct 2020 11:21:05 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id r28sm531178wrr.81.2020.10.28.11.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:21:05 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v4 2/3] net: add kcov handle to skb extensions
Date:   Wed, 28 Oct 2020 18:20:17 +0000
Message-Id: <20201028182018.1780842-3-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
In-Reply-To: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Remote KCOV coverage collection enables coverage-guided fuzzing of the
code that is not reachable during normal system call execution. It is
especially helpful for fuzzing networking subsystems, where it is
common to perform packet handling in separate work queues even for the
packets that originated directly from the user space.

Enable coverage-guided frame injection by adding kcov remote handle to
skb extensions. Default initialization in __alloc_skb and
__build_skb_around ensures that no socket buffer that was generated
during a system call will be missed.

Code that is of interest and that performs packet processing should be
annotated with kcov_remote_start()/kcov_remote_stop().

An alternative approach is to determine kcov_handle solely on the
basis of the device/interface that received the specific socket
buffer. However, in this case it would be impossible to distinguish
between packets that originated during normal background network
processes or were intentionally injected from the user space.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
v3 -> v4:
* CONFIG_SKB_EXTENSIONS is now automatically selected by CONFIG_KCOV.
* Elaborated on a minor optimization in skb_set_kcov_handle().
v2 -> v3:
* Reimplemented this change. Now kcov handle is added to skb
extensions instead of sk_buff.
v1 -> v2:
* Updated the commit message.
---
 include/linux/skbuff.h | 36 ++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |  1 +
 net/core/skbuff.c      | 11 +++++++++++
 3 files changed, 48 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a828cf99c521..d1cc1597d566 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4150,6 +4150,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+	SKB_EXT_KCOV_HANDLE,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
@@ -4605,5 +4608,38 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+#ifdef CONFIG_KCOV
+
+static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle)
+{
+	/* Do not allocate skb extensions only to set kcov_handle to zero
+	 * (as it is zero by default). However, if the extensions are
+	 * already allocated, update kcov_handle anyway since
+	 * skb_set_kcov_handle can be called to zero a previously set
+	 * value.
+	 */
+	if (skb_has_extensions(skb) || kcov_handle) {
+		u64 *kcov_handle_ptr = skb_ext_add(skb, SKB_EXT_KCOV_HANDLE);
+
+		if (kcov_handle_ptr)
+			*kcov_handle_ptr = kcov_handle;
+	}
+}
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
+{
+	u64 *kcov_handle = skb_ext_find(skb, SKB_EXT_KCOV_HANDLE);
+
+	return kcov_handle ? *kcov_handle : 0;
+}
+
+#else
+
+static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle) { }
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
+
+#endif /* CONFIG_KCOV */
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 537cf3c2937d..9df33cf81d2b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1873,6 +1873,7 @@ config KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
+	select SKB_EXTENSIONS
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ba8f0163744..c5e6c0b83a92 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -249,6 +249,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 		fclones->skb2.fclone = SKB_FCLONE_CLONE;
 	}
+
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 out:
 	return skb;
 nodata:
@@ -282,6 +285,8 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
 
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 	return skb;
 }
 
@@ -4203,6 +4208,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
+#if IS_ENABLED(CONFIG_KCOV)
+	[SKB_EXT_KCOV_HANDLE] = SKB_EXT_CHUNKSIZEOF(u64),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4219,6 +4227,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+		skb_ext_type_len[SKB_EXT_KCOV_HANDLE] +
 #endif
 		0;
 }
-- 
2.29.0.rc2.309.g374f81d7ae-goog

