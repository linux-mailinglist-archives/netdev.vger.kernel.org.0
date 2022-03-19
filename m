Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F54DE841
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 15:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbiCSOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243102AbiCSOG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 10:06:29 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AB21C3481
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:05:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n15so9263224plh.2
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QqG6CZzxDth1w59RNVMmueDFSF6gkFVjXyxjL8FH2eI=;
        b=HWAChnIu0ZWewiPb3M/EdnSnZTr1cmVFJaCPIVrsqDpad+a7OAtUekAr38XtjP8eg/
         Xfi3PRbV7DKr77DmOvfhHlMT5IiQH49LLVla8t6hTXJ3hTBBTTxG0PuuPs0c6b4YDxyw
         WuXZL8wRFXo5qI6m+BvUan5wT+3GF3TukGU/2spYarRn+rInCza/8LjiWg5dUUcrGeHH
         hlXZhxRn2HThPoubAfdhCKiFUxzpNOdkVz4G8pjdli5/S86gmyvwXBUr9CCyw5IkUiDm
         JK9JwC21Hp9NYuF2ALfV7K8E3dzbD4E6x5y4KqZmBGaRDR18Jw/zwAP61P1yghRLrkHb
         tFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QqG6CZzxDth1w59RNVMmueDFSF6gkFVjXyxjL8FH2eI=;
        b=BX7/9268sJ1R+O3aubsRDi5WPlak/gQ1872YNYsRpOa1nfRtQ0AGMgnXZSm94NZ4eP
         Apx57vPKYhZS5lTRBTQ094EHiULy+af3SPuqmDWu8AfuAY52EmS/6tuZJIQ2qgUTZjj8
         SHiQ8XtzEaRiRGnE47xighjl02ztad3oaAG6ejNaty1OgORMyp6nSwf60RwX0xhQT3OM
         BDvyOJjjcaJbOTdV03iye6alEz+IC7jQTU/1UWlqWzyFELC/kVxiDfqB26mexsy9yLlH
         5xhWmvpn+Bf5978AICMfmxH/8fmwfdfpqwoPeNKoQmmnkcxd+0Zmp9IDSPe1PJwyLDF3
         4m9Q==
X-Gm-Message-State: AOAM530TBsE0IQLtNiQCP+TgkU5G1hMtG9sjvyarf3H5wU867VETbqog
        iTMSYNw2SaJ7nvKaF7C1EvM=
X-Google-Smtp-Source: ABdhPJzQQ5rmmGKu4E5ufhvT4AvlQPQMB8m6VvWIbabLBmv8ru3wjLSxusuISxFxdS7E5o7T3qJqyA==
X-Received: by 2002:a17:90b:1b0f:b0:1c6:ed78:67ad with SMTP id nu15-20020a17090b1b0f00b001c6ed7867admr1092916pjb.41.1647698707399;
        Sat, 19 Mar 2022 07:05:07 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm10168438pgh.94.2022.03.19.07.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 07:05:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        irusskikh@marvell.com, epomozov@marvell.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 3/3] net: atlantic: Implement .ndo_xdp_xmit handler
Date:   Sat, 19 Mar 2022 14:04:43 +0000
Message-Id: <20220319140443.6645-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220319140443.6645-1-ap420073@gmail.com>
References: <20220319140443.6645-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

aq_xdp_xmit() is the callback function of .ndo_xdp_xmit.
It internally calls aq_nic_xmit_xdpf() to send packet.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

V2:
 - No changed

 .../net/ethernet/aquantia/atlantic/aq_main.c  |  1 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 23 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 07b4f4ee715f..6c396927438d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -480,6 +480,7 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc = aq_ndo_setup_tc,
 	.ndo_bpf = aq_xdp,
+	.ndo_xdp_xmit = aq_xdp_xmit,
 };
 
 static int __init aq_ndev_init_module(void)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 85c3b7a9f387..5bcb999600ac 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -409,6 +409,29 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 		__skb_incr_checksum_unnecessary(skb);
 }
 
+int aq_xdp_xmit(struct net_device *dev, int num_frames,
+		struct xdp_frame **frames, u32 flags)
+{
+	struct aq_nic_s *aq_nic = netdev_priv(dev);
+	unsigned int vec, i, drop = 0;
+	int cpu = smp_processor_id();
+	struct aq_nic_cfg_s *aq_cfg;
+	struct aq_ring_s *ring;
+
+	aq_cfg = aq_nic_get_cfg(aq_nic);
+	vec = cpu % aq_cfg->vecs;
+	ring = aq_nic->aq_ring_tx[AQ_NIC_CFG_TCVEC2RING(aq_cfg, 0, vec)];
+
+	for (i = 0; i < num_frames; i++) {
+		struct xdp_frame *xdpf = frames[i];
+
+		if (aq_nic_xmit_xdpf(aq_nic, ring, xdpf) == NETDEV_TX_BUSY)
+			drop++;
+	}
+
+	return num_frames - drop;
+}
+
 static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 				       struct xdp_buff *xdp,
 				       struct aq_ring_s *rx_ring,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 6a86d9cfac35..31e19dff6c1e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -197,6 +197,8 @@ void aq_ring_update_queue_state(struct aq_ring_s *ring);
 void aq_ring_queue_wake(struct aq_ring_s *ring);
 void aq_ring_queue_stop(struct aq_ring_s *ring);
 bool aq_ring_tx_clean(struct aq_ring_s *self);
+int aq_xdp_xmit(struct net_device *dev, int num_frames,
+		struct xdp_frame **frames, u32 flags);
 int aq_ring_rx_clean(struct aq_ring_s *self,
 		     struct napi_struct *napi,
 		     int *work_done,
-- 
2.17.1

