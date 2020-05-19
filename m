Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA58F1D92B7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgESI54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESI5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:57:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30A6C061A0C;
        Tue, 19 May 2020 01:57:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w19so3550928ply.11;
        Tue, 19 May 2020 01:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=bXJwro/9lEalQOBzCcLtiUiYr+3taaZP7ihl1wl7y4k7KwgcbannApBDwcTIAMbshQ
         zWpkK6EAqAWTq4YHx9VZzOBQ7wgg//ss1+QDa661fWUy+TuMKjf8GaPp6V6turNWEUN8
         HF+vGMR6X+S4AKNOsDYhvoUpoKG5/OtiMsC0slsGlOfsDq5I/pq7YJtL9o9wqTwnUIT0
         DVe3T5jwkrGMd2XPf6MgogJp/AmlbrDXoirxBu2Z2qsj2fKteQKfQT1M+InAO2jOw43r
         OU2IfB+xZxHDiJ4IbQ2OvtLybd81GPaJdhZmIsZbpzVNTFVZYRIdX2WrA6tu10vN3G/T
         vfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=L9MyNudyCd07j193NEv9DcYlq/mu7W1iCZ6BqiuLs2wzsSqRYexcTQsEy1qfHUizdS
         Hkh0A3mfuG+aJFCg5YWy4ndW4lJGuFaYy+o88QEPEtvmDbmFl5QdMFkm6PiHBhAhhWoo
         d0g3BbPL1UM/R4DDCileIkVbYhhYpOrEUMwQ6cm9iyvODU0Lr4lw0W+PHKfWbpMvI0k+
         VykwST/776DB6We0XN6NsA1a8pE7vk6qI2lL8TVEWUsU+igfD7lbvQv18v/LSTTxHPhO
         NlgCZhvzDzISFkpbGvOAiPlBYPTU5gBMPZRkvR3WKFfqAY2y4I+EiF/5awSMJG7+62rO
         rJUQ==
X-Gm-Message-State: AOAM533UXwvU/tHkWDMOKvQMlcD7kTK7JzTYHQTcIW/55N2faOtCXbV5
        T7nE1hT9+kRKR4279ed5r3Q=
X-Google-Smtp-Source: ABdhPJwFgs04wAwzqu2ilrK73/mEWtwmoMKiV9SZKEf6pfO9VvExirDSZptaLgepSwxr6S+JlLraDw==
X-Received: by 2002:a17:90a:f2c6:: with SMTP id gt6mr3738357pjb.61.1589878675211;
        Tue, 19 May 2020 01:57:55 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id k18sm5765748pfg.217.2020.05.19.01.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 01:57:54 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v3 04/15] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Tue, 19 May 2020 10:57:13 +0200
Message-Id: <20200519085724.294949-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200519085724.294949-1-bjorn.topel@gmail.com>
References: <20200519085724.294949-1-bjorn.topel@gmail.com>
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

