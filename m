Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D45285CB3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgJGKSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgJGKR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:17:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B714C061755;
        Wed,  7 Oct 2020 03:17:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id n6so1198256wrm.13;
        Wed, 07 Oct 2020 03:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZnoEU+XnxcTdbsZWvSC6xxdTYFozxJsTcCIM0ht4gOc=;
        b=UPwpJB6Xrb/lRL+4XumO6Cd7zTUZucpNOQtXKr+bnDtg/+zEJSaHM0P4SZXzDzlpnd
         RKaTKZOYBbG/H19MHorGTcThuduVyL+yoSS6Oo1jTfLKZ5J0HYfopqraOFK/Aex50Z1D
         RQvQ52JUshOwtGzM16Iy+6I9JaUpHvyO9zmXN+CKKQ73Mq92GXfVvXjH1+Z7Yxq6DLr9
         Mkj4z4XZ5SBuT1FVpZWJik2WrEdSTA4/RNdw361J7vJ2IVrocDH806zHcVFuLvxc3QCD
         J1cJEuHUkgBkgOx1Dpym4Vp2cUpdRfinuU3672sI8fTm1J21cdnlZ0t4cbEYvN7Syw+n
         MBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZnoEU+XnxcTdbsZWvSC6xxdTYFozxJsTcCIM0ht4gOc=;
        b=a7RirAZBh5+AJRsicTa8kDYDpeFdei838hd2B8uYPhDtu1DDV1wvD6UALdM8bE6fT5
         ayPT7M+pD5QZ/EhzLplOkjovn4xas1J6F32QUOIcGoEn+XH0k9VloD259WnxRGLxMB9/
         fEqg7KKtG6OCPE6J8Yx312igKzP4KoUFPy+3ZK3YCNB6LfR2l+XG+zgfi5R/osU8590H
         YoZ4rRRLoA8/b45xgTiMj3hwe3LhmzgrGF0nHdlyctiLuahsZy6/kGYXMlFSO8lw+6+J
         sXPJzrLxfSPiPLshpD6IEsZtBFSlMZ0nx5EULuwNIOwn1wI0WpS1S8RC+DcVfpUlp+fA
         GArQ==
X-Gm-Message-State: AOAM532Y7Hejo2CYpUHXQb4mgqDmiBKBt14cD4N1nfwIEAPGxp2zQ7Cx
        HJhTS2xB8K1DJcG6moB/LZg=
X-Google-Smtp-Source: ABdhPJyYx+CDMq3a+Cdff8hs5IPV3mVv8/gKgVjSK1WkVzZ8olHrdSua4z7Ho5CPdpsmZamqzP2Dxw==
X-Received: by 2002:a05:6000:1633:: with SMTP id v19mr812389wrb.147.1602065877045;
        Wed, 07 Oct 2020 03:17:57 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id u12sm2249168wrt.81.2020.10.07.03.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:17:56 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH 1/2] net: store KCOV remote handle in sk_buff
Date:   Wed,  7 Oct 2020 10:17:25 +0000
Message-Id: <20201007101726.3149375-2-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20201007101726.3149375-1-a.nogikh@gmail.com>
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
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

Enable coverage-guided frame injection by adding a kcov_handle
parameter to sk_buff structure. Initialization in __alloc_skb ensures
that no socket buffer that was generated during a system call will be
missed.

Code that is of interest and that performs packet processing should be
annotated with kcov_remote_start()/kcov_remote_stop().

An alternative approach is to determine kcov_handle solely on the
basis of the device/interface that received the specific socket
buffer. However, in this case it would be impossible to distinguish
between packets that originated from normal background network
processes and those that were intentionally injected from the user
space.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
 include/linux/skbuff.h | 21 +++++++++++++++++++++
 net/core/skbuff.c      |  1 +
 2 files changed, 22 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a828cf99c521..5639f27e05ef 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -701,6 +701,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@transport_header: Transport layer header
  *	@network_header: Network layer header
  *	@mac_header: Link layer header
+ *	@kcov_handle: KCOV remote handle for remote coverage collection
  *	@tail: Tail pointer
  *	@end: End pointer
  *	@head: Head of buffer
@@ -904,6 +905,10 @@ struct sk_buff {
 	__u16			network_header;
 	__u16			mac_header;
 
+#ifdef CONFIG_KCOV
+	u64			kcov_handle;
+#endif
+
 	/* private: */
 	__u32			headers_end[0];
 	/* public: */
@@ -4605,5 +4610,21 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle)
+{
+#ifdef CONFIG_KCOV
+	skb->kcov_handle = kcov_handle;
+#endif
+}
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
+{
+#ifdef CONFIG_KCOV
+	return skb->kcov_handle;
+#else
+	return 0;
+#endif
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f67631faa9aa..e7acd7d45b03 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	skb->end = skb->tail + size;
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
+	skb_set_kcov_handle(skb, kcov_common_handle());
 
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
-- 
2.28.0.806.g8561365e88-goog

