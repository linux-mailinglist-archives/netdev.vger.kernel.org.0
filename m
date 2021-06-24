Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC5A3B354C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhFXSK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhFXSKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:30 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B2C061760
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:03 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l2-20020ac84cc20000b029024ef0325fd0so5643446qtv.0
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7fcR2/qdqbTcb3TrV+mDXzeYTTip4kyFuH+xf9MvyCM=;
        b=Dbitr7I9VBoU98HRA3R5BXC3/k1UMd1lbqud2d6RSoioq96rs716NnfixsXva6TLMq
         bbZwtqBceFqeYXs0yrYv36qzrv0U75ZzRRlRYCTpH050Jt/oETb8JNYVXOch9kBj7gOY
         PIPOUe0iIX2qKAEeEQQJkIV4Sz5FntKPUFUmTbPse8TrIk/+mSXySDGMKNB0eZvSrnNm
         +P82y3jiM5YhKTs25hZlXNuKjPwGN525r4KIzaI9P3C6Glfq5ekew4WxftKIojeSKfiz
         JQu2TKRfxAYCzZwHLXztNCYynr5XZYtrAdhyYsQ7/MZQwiXxwxJQOhME2nfQzzt9CPxM
         AK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7fcR2/qdqbTcb3TrV+mDXzeYTTip4kyFuH+xf9MvyCM=;
        b=RAPD3WRbTopSwn01azK/MF4CQglqzCu/JbYrbqONhWkEK8ewXaRwFQSTWX3OldrQP7
         9Rz/phcOkvRq443Ns61CasdyajnfB3uGJSzAldLcqbpUAhqlueEt6kgXCScClJ0H7SSv
         zaCsyH+TSRyiFhvnswzjTDbx6DLTX/PVkAfalbWVzRWoKVOlT1wjVdrwt7be2662rYDm
         Igg7kuzYrlq+1CqzaacEu0y/slxXmfKFoJmUT6B8GNotaA4TEKAr5LEpblwAMwbwDnK8
         bP5QrX38hetA7fp9g6cfpVS3Oe3ZFtQbcxiRVXBhXh6k9/BpfOdv6scT7TeoNjDHNXcK
         52aA==
X-Gm-Message-State: AOAM531cqURWKnK/AUwabeRFvAzsYQ6vM1jE//gunqbmhDNYnqIJRX77
        uy5+QEjhcuJjVNAinvdVFuUXiPY=
X-Google-Smtp-Source: ABdhPJwNlVxuvb3Pggnz9ruG7luxxBQ9mVIwVZTZw5RpG+sAQpukCVfrYXBT/ZTuFdrVPTO/WQC8xn8=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a05:6214:1c46:: with SMTP id
 if6mr6469466qvb.41.1624558082983; Thu, 24 Jun 2021 11:08:02 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:30 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-15-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 14/16] gve: DQO: Configure interrupts on device up
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When interrupts are first enabled, we also set the ratelimits, which
will be static for the entire usage of the device.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_dqo.h  | 19 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_main.c | 16 ++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_dqo.h b/drivers/net/ethernet/google/gve/gve_dqo.h
index 9877a33ec068..3b300223ea15 100644
--- a/drivers/net/ethernet/google/gve/gve_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_dqo.h
@@ -13,6 +13,9 @@
 #define GVE_ITR_CLEAR_PBA_BIT_DQO BIT(1)
 #define GVE_ITR_NO_UPDATE_DQO (3 << 3)
 
+#define GVE_ITR_INTERVAL_DQO_SHIFT 5
+#define GVE_ITR_INTERVAL_DQO_MASK ((1 << 12) - 1)
+
 #define GVE_TX_IRQ_RATELIMIT_US_DQO 50
 #define GVE_RX_IRQ_RATELIMIT_US_DQO 20
 
@@ -38,6 +41,22 @@ gve_tx_put_doorbell_dqo(const struct gve_priv *priv,
 	iowrite32(val, &priv->db_bar2[index]);
 }
 
+/* Builds register value to write to DQO IRQ doorbell to enable with specified
+ * ratelimit.
+ */
+static inline u32 gve_set_itr_ratelimit_dqo(u32 ratelimit_us)
+{
+	u32 result = GVE_ITR_ENABLE_BIT_DQO;
+
+	/* Interval has 2us granularity. */
+	ratelimit_us >>= 1;
+
+	ratelimit_us &= GVE_ITR_INTERVAL_DQO_MASK;
+	result |= (ratelimit_us << GVE_ITR_INTERVAL_DQO_SHIFT);
+
+	return result;
+}
+
 static inline void
 gve_write_irq_doorbell_dqo(const struct gve_priv *priv,
 			   const struct gve_notify_block *block, u32 val)
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index cddf19c8cf0b..1bf446836724 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1077,14 +1077,26 @@ static void gve_turnup(struct gve_priv *priv)
 		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
 		napi_enable(&block->napi);
-		iowrite32be(0, gve_irq_doorbell(priv, block));
+		if (gve_is_gqi(priv)) {
+			iowrite32be(0, gve_irq_doorbell(priv, block));
+		} else {
+			u32 val = gve_set_itr_ratelimit_dqo(GVE_TX_IRQ_RATELIMIT_US_DQO);
+
+			gve_write_irq_doorbell_dqo(priv, block, val);
+		}
 	}
 	for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
 		int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
 		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
 		napi_enable(&block->napi);
-		iowrite32be(0, gve_irq_doorbell(priv, block));
+		if (gve_is_gqi(priv)) {
+			iowrite32be(0, gve_irq_doorbell(priv, block));
+		} else {
+			u32 val = gve_set_itr_ratelimit_dqo(GVE_RX_IRQ_RATELIMIT_US_DQO);
+
+			gve_write_irq_doorbell_dqo(priv, block, val);
+		}
 	}
 
 	gve_set_napi_enabled(priv);
-- 
2.32.0.288.g62a8d224e6-goog

