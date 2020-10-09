Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5331288F80
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390121AbgJIRCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390097AbgJIRCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:02:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC198C0613D5;
        Fri,  9 Oct 2020 10:02:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g12so11013269wrp.10;
        Fri, 09 Oct 2020 10:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HR1csYALqNVbMtUVDiaNlzvED0SHVfHnv16440TYZV0=;
        b=GVQP7OQii4vNJLZshY9gLFxRrrof0aroC7wtRUcdB+TUKc5w2F9W574Ur1sdF5McpA
         FMNuCENvUMaMaxPXIN5RCVODEQbPBTOcS3E7Q8A8RdmQlfl9XUjufZOj38ptw0fzkfvF
         qZiNgrMU7S4c8A7TqMOvAcznH3BQbFmTx5V+RhSAe1hCX3RRRcUOp6bp7+Dov77B9dFu
         eHBOhRPdQ+wGkUVbjbupWVnpHzvDR4HR/MmB+6S9NujCboTJ4smnyPY+aKKf/BJB10lp
         Pt+5eOGxo7kB829k85aHYTNDUVGHtrPjfCEUFLAnifIEgV14lwosRizTgww+Og8CSRIB
         0kDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HR1csYALqNVbMtUVDiaNlzvED0SHVfHnv16440TYZV0=;
        b=tPkiR8z0dY7RsHcfGi5K688saGyMD9kgahEUOoey8hG6tb6iNmEeLyYBD8O3HTzPom
         6FfVH99bvQOpHp1evgn6KA0gY1vY6S0sJsy+Y2TFFNra/CYUpYFF/ULHmYKcdokF4Czh
         HbqKos4zEzputxiOvClK59mjwEf5Ra0pRtN4Ami4+uSZ2+MhPP26UC/pexzTqiP01ftq
         abhiNGau3ETPBb16qzS2SF7A1iqShM/yuZzvgSsvH/QIsXX+a/Buj2yH+nLh2iduexvk
         0UOKrid5dQDIIqdVaPFIp71TpI3xxWdB8ywcl0aphAufZKbU7RPJx93PD1f8AoN8/36q
         Hgog==
X-Gm-Message-State: AOAM532trm7zuNKiJFce6Kc5IsccVJISMJgEjslbzh+W06ew2Pt6zxiE
        vX6ACHleUFzGvWaMk+F4Fk0=
X-Google-Smtp-Source: ABdhPJyIgnBC5YaLOtqcsGMghxQSaITFs+HI88lNk67nbO3WIVDGGhd2qLeJUYL3992byDXOn0XiBQ==
X-Received: by 2002:a5d:4a06:: with SMTP id m6mr15667171wrq.209.1602262936531;
        Fri, 09 Oct 2020 10:02:16 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s6sm13211092wrg.92.2020.10.09.10.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:02:15 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH v2 2/3] net: store KCOV remote handle in sk_buff
Date:   Fri,  9 Oct 2020 17:02:01 +0000
Message-Id: <20201009170202.103512-3-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
In-Reply-To: <20201009170202.103512-1-a.nogikh@gmail.com>
References: <20201009170202.103512-1-a.nogikh@gmail.com>
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
packets that originated directly from the user space. More details can
be found in Documentation/dev-tools/kcov.rst.

Enable coverage-guided frame injection by adding a kcov_handle
parameter to sk_buff structure. Initializate this field in __alloc_skb
to kcov_common_handle() so that no socket buffer that was generated
during a system call is missed. For sk_buffs that were allocated in an
interrupt context, kcov_handle will be initialized to 0.

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
v2:
* Updated the commit message.
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
2.28.0.1011.ga647a8990f-goog

