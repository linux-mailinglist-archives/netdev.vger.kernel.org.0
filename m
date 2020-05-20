Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDE1DBDD1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgETTVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:21:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FEFC061A0E;
        Wed, 20 May 2020 12:21:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w19so1736366ply.11;
        Wed, 20 May 2020 12:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=tEHMSmiqK4NVAI8piWGijTRVmY9iSVVIS7VVG4ZRBa8nRLDyjAmwvWbmMmIz/mOq4m
         uUE52maNEWPsKgQsy3DRR3GELareAU/njqF/yd5pUk0g1yOK1b8VIs8KM4ch3WeR2J1y
         iZZgf8dhNB4xGi9nNKGDM5jsZfakf6/yUi0UxUE59GhQ2NmsjBzGsctejdxX7N0+lvRr
         ukko9+b/mSbGgkbbI/0Cpi5D65bzZtXHRNg5TLDEI/URDo88TJL5kC/t/Lo8U80uC5Ul
         j+g1X8rE2529sjVgBnV7TeXDdaCHaCophWohQIZcDZGvLPY4aQjqp+X2+M2UHTKdKq0y
         lNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=hu10Nk+G0hZ6WWICRoeIaVmCEoTbUPqoH8y/4ZtzZJm7l8TAZ+UMZK4s3WLbL435Lv
         4rAeiGJnu/Xd7jAFNvDBwuOfBd16ElGRNg/J0+1B7worS0yWod9TetfwCk3jgNxvsy/A
         Vpxb+AaVBu332oX8zbXbCkuInEnjXBxecL0YKg90NO9Kw5PGoxrJFx5dsghlLVhHLz1B
         vFHFl0aCx9IMbFzQp0JAI92aOtr65gISMnOa1SH4ZWq0bW9lRT1BJVxm91GGK30EAWxv
         HMNdqpiCPtiMhUC/IPD83UVjhnNPE3Hx3ptT3TdM4hfM1Dm+iYq0ZFcDTGtEHjPpUgSz
         CjCQ==
X-Gm-Message-State: AOAM5315LWMuZj0bXTUkN5usD3x7ZHt9xwOYKeX6VQJ4sUAKXNs3udRb
        ra+5wrOW0MVvrnEBY+81Y9A=
X-Google-Smtp-Source: ABdhPJzG1aqPy5irzrkNKu6YcK4H7eFqXH78aiQnQ2f6AJgqHmg6B/NsvpVMlazrXtT623oN8fN2sg==
X-Received: by 2002:a17:902:7787:: with SMTP id o7mr1219689pll.52.1590002498966;
        Wed, 20 May 2020 12:21:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:21:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v5 04/15] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Wed, 20 May 2020 21:20:52 +0200
Message-Id: <20200520192103.355233-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Move the XSK_NEXT_PG_CONTIG_{MASK,SHIFT}, and
XDP_UMEM_USES_NEED_WAKEUP defines from xdp_sock.h to the AF_XDP
internal xsk.h file. Also, start using the BIT{,_ULL} macro instead of
explicit shifts.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 14 --------------
 net/xdp/xsk.h          | 14 ++++++++++++++
 net/xdp/xsk_queue.h    |  2 ++
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 6a986dcbc336..fb7fe3060175 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -17,13 +17,6 @@ struct net_device;
 struct xsk_queue;
 struct xdp_buff;
 
-/* Masks for xdp_umem_page flags.
- * The low 12-bits of the addr will be 0 since this is the page address, so we
- * can use them for flags.
- */
-#define XSK_NEXT_PG_CONTIG_SHIFT 0
-#define XSK_NEXT_PG_CONTIG_MASK (1ULL << XSK_NEXT_PG_CONTIG_SHIFT)
-
 struct xdp_umem_page {
 	void *addr;
 	dma_addr_t dma;
@@ -35,13 +28,6 @@ struct xdp_umem_fq_reuse {
 	u64 handles[];
 };
 
-/* Flags for the umem flags field.
- *
- * The NEED_WAKEUP flag is 1 due to the reuse of the flags field for public
- * flags. See inlude/uapi/include/linux/if_xdp.h.
- */
-#define XDP_UMEM_USES_NEED_WAKEUP (1 << 1)
-
 struct xdp_umem {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index d6a0979050e6..455ddd480f3d 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -4,6 +4,20 @@
 #ifndef XSK_H_
 #define XSK_H_
 
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
+
+/* Flags for the umem flags field.
+ *
+ * The NEED_WAKEUP flag is 1 due to the reuse of the flags field for public
+ * flags. See inlude/uapi/include/linux/if_xdp.h.
+ */
+#define XDP_UMEM_USES_NEED_WAKEUP BIT(1)
+
 struct xdp_ring_offset_v1 {
 	__u64 producer;
 	__u64 consumer;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 648733ec24ac..a322a7dac58c 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -10,6 +10,8 @@
 #include <linux/if_xdp.h>
 #include <net/xdp_sock.h>
 
+#include "xsk.h"
+
 struct xdp_ring {
 	u32 producer ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
-- 
2.25.1

