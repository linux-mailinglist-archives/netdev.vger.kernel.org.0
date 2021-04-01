Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31729351F47
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhDATEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbhDATDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C402C0F26EE
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so3485747pjc.2
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7QmnBG0pTePDt842nweNMSdTAO53eyMxLkJlDiWzq7E=;
        b=0tKvGnQ695EPgsLypOyYXiWFTNlQ/xpRL0fmwvjIhUhh4o4PTboQgxTL3ov6ooaaJx
         Su0UK6zL6QHG5IfpAwySRElTnvyOAMzE0GK+R8O5HrxIJwgJEgQFiD6ol3BlmC+kTvnq
         m3SwMzy+Jrvsir4nO+Rcpf1AXgJbhP4Y1auXrcMSGCP5uYQieQtsHpCmj2bccIHPRPUE
         FJOY8+yWYOgA6PQsnHRJbAeB8bHFA/LGwnK/IvSEOP+uo1u+Fb64R5lyyisw83k+Drtj
         T9mt/MVQrGIWpl0u4NCTmyfQAu11nGTc90w64HI7hfSYozXjiA+mt5h9UaNQ4blploC/
         /g6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7QmnBG0pTePDt842nweNMSdTAO53eyMxLkJlDiWzq7E=;
        b=uoJYOQwcUyDRGYLEUzY410aFpsEDTbuxOFiVlNIUCL9C62IiBuQuoz9/XVDGi60/SL
         G69xRFYUPriG0YTre5lfhnkNM1lY12S4vnYXO5waQG8Tv4z3HPo5SNmd/XlX3uorBp48
         4dPRQidfQhNCh3PUl3PZgWNvUgBXDT8H4AKSK0u+Q+NVMJ8J9MSGAHTite5/Mo+LLnGP
         s9eJXYxNqTIMbUTX9+8Og5UFanngkY912mbDfeISu8lF3ufh2gEotIIPFgkdezEAc19r
         7dBc05ierv2ZR8KpZewvHHV7n+ccf1zrP4TICVUNlOPxugK4Dsv4bBhYHGuLOV8eIlzd
         rHGA==
X-Gm-Message-State: AOAM530RXiYFy/VtAomodIL6wmpZF+uFx3h0h0t9i2DTC91GU4fmH9vr
        hP1nLj+6Wktpm6Yf/r5oHtGxBYLzIPSzjA==
X-Google-Smtp-Source: ABdhPJyvZLXcW0O3iPsc1OKbJbbp4GqDuU/JTdk60nqb/sKSK+V9+kEepY7tI7EMfe3PbGGCH8z0CA==
X-Received: by 2002:a17:902:820e:b029:e6:f006:fcff with SMTP id x14-20020a170902820eb02900e6f006fcffmr8917301pln.60.1617299781906;
        Thu, 01 Apr 2021 10:56:21 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 01/12] ionic: add new queue features to interface
Date:   Thu,  1 Apr 2021 10:55:59 -0700
Message-Id: <20210401175610.44431-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add queue feature extensions to prepare for features that
can be queue specific, in addition to the general queue
features already defined.  While we're here, change the
existing feature ids from #defines to enum.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 27 ++++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +++
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 0c0533737b2b..68e5e7a97801 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -222,6 +222,7 @@ struct ionic_queue {
 	u64 stop;
 	u64 wake;
 	u64 drop;
+	u64 features;
 	struct ionic_dev *idev;
 	unsigned int type;
 	unsigned int hw_index;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 88210142395d..23043ce0a5d8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -345,6 +345,23 @@ enum ionic_logical_qtype {
 	IONIC_QTYPE_MAX     = 16,
 };
 
+/**
+ * enum ionic_q_feature - Common Features for most queue types
+ *
+ * Common features use bits 0-15. Per-queue-type features use higher bits.
+ *
+ * @IONIC_QIDENT_F_CQ:      Queue has completion ring
+ * @IONIC_QIDENT_F_SG:      Queue has scatter/gather ring
+ * @IONIC_QIDENT_F_EQ:      Queue can use event queue
+ * @IONIC_QIDENT_F_CMB:     Queue is in cmb bar
+ */
+enum ionic_q_feature {
+	IONIC_QIDENT_F_CQ		= BIT_ULL(0),
+	IONIC_QIDENT_F_SG		= BIT_ULL(1),
+	IONIC_QIDENT_F_EQ		= BIT_ULL(2),
+	IONIC_QIDENT_F_CMB		= BIT_ULL(3),
+};
+
 /**
  * struct ionic_lif_logical_qtype - Descriptor of logical to HW queue type
  * @qtype:          Hardware Queue Type
@@ -529,7 +546,7 @@ struct ionic_q_identify_comp {
  * union ionic_q_identity - queue identity information
  *     @version:        Queue type version that can be used with FW
  *     @supported:      Bitfield of queue versions, first bit = ver 0
- *     @features:       Queue features
+ *     @features:       Queue features (enum ionic_q_feature, etc)
  *     @desc_sz:        Descriptor size
  *     @comp_sz:        Completion descriptor size
  *     @sg_desc_sz:     Scatter/Gather descriptor size
@@ -541,10 +558,6 @@ union ionic_q_identity {
 		u8      version;
 		u8      supported;
 		u8      rsvd[6];
-#define IONIC_QIDENT_F_CQ	0x01	/* queue has completion ring */
-#define IONIC_QIDENT_F_SG	0x02	/* queue has scatter/gather ring */
-#define IONIC_QIDENT_F_EQ	0x04	/* queue can use event queue */
-#define IONIC_QIDENT_F_CMB	0x08	/* queue is in cmb bar */
 		__le64  features;
 		__le16  desc_sz;
 		__le16  comp_sz;
@@ -585,6 +598,7 @@ union ionic_q_identity {
  * @ring_base:    Queue ring base address
  * @cq_ring_base: Completion queue ring base address
  * @sg_ring_base: Scatter/Gather ring base address
+ * @features:     Mask of queue features to enable, if not in the flags above.
  */
 struct ionic_q_init_cmd {
 	u8     opcode;
@@ -608,7 +622,8 @@ struct ionic_q_init_cmd {
 	__le64 ring_base;
 	__le64 cq_ring_base;
 	__le64 sg_ring_base;
-	u8     rsvd2[20];
+	u8     rsvd2[12];
+	__le64 features;
 } __packed;
 
 /**
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a51be25723a5..1b89549b243b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -731,6 +731,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.ring_base = cpu_to_le64(q->base_pa),
 			.cq_ring_base = cpu_to_le64(cq->base_pa),
 			.sg_ring_base = cpu_to_le64(q->sg_base_pa),
+			.features = cpu_to_le64(q->features),
 		},
 	};
 	unsigned int intr_index;
@@ -791,6 +792,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.ring_base = cpu_to_le64(q->base_pa),
 			.cq_ring_base = cpu_to_le64(cq->base_pa),
 			.sg_ring_base = cpu_to_le64(q->sg_base_pa),
+			.features = cpu_to_le64(q->features),
 		},
 	};
 	int err;
@@ -2214,6 +2216,7 @@ static const struct net_device_ops ionic_netdev_ops = {
 static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 {
 	/* only swapping the queues, not the napi, flags, or other stuff */
+	swap(a->q.features,   b->q.features);
 	swap(a->q.num_descs,  b->q.num_descs);
 	swap(a->q.base,       b->q.base);
 	swap(a->q.base_pa,    b->q.base_pa);
-- 
2.17.1

