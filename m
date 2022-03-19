Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19814DE7D5
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242878AbiCSMVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 08:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242882AbiCSMVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 08:21:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296852AA1AC
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:20:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z3so9117726plg.8
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JKV1y67nVcSyZ+EUnQcQZtxfYUE/KfDA7zGklcQ2Vrw=;
        b=FbAo/Lh4PKUOhFnXPTQ39YdnDkvwe6O/OKw9h4ua/gv/L+uXGU5ItSSsUx5WApl48T
         FJy1tDRM/f4T3IwgOo+Rj2t0C3l0mG9lYm4LY2m8anjVDFhp1Ro/Y9jYMbL/OpxqeRe5
         mzERJPN6HILwiwA4bSo+jq2s/52zYcDiOvnrUivuWP+3YRxnhahYKQFc4TFCGcpX2JAT
         Ppa0KPLDmRzzCECQ6PKsLZ7i/bq3RIT3p9qSAAZp1vMFdiKoQuGuhifVuJdTafx9dfnd
         LWKNcdJ0JXu4EN32z4GylCOUUFwIHHCCVBrPqkvvyC3Jaw+jKsltMgWIU2ThN6bq++/d
         HUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JKV1y67nVcSyZ+EUnQcQZtxfYUE/KfDA7zGklcQ2Vrw=;
        b=J9RTAKlgsbIPUPE6OsnupNEZH3pCssiJGXRnql8E0LknVNxGJq173TKXNsSVD/Jwud
         X4va42xZHKoIns/V5ScoeQ1Dar3JFygnmZaHi+J/gwgivWIenHuTfJyXv4f9yePw6vgh
         bG+E5WKFnDWZ5jf3t6t9VEe0c0gJurHnz6tAJer5j1b8CGrNs5SFalUv3ngmEFuxUKKR
         jqYaRUY4L1FPUMO6skwCA0ZLnkCPOrhhHysDXTlSdQa1g3b3d4l9sWugx8UZw7UdMczo
         QIKdZGI007y01ErQ/arjY343IxCpMYFD4OAGd5TTQNN9TmTig9rRzk7y8xVB35Uvz6Jq
         cz+w==
X-Gm-Message-State: AOAM531+4qfvDTr/N3muoOUstz5E8KwKJIbJaB0HTE9UWl5VSAlmbPqs
        k/d7PTrQXeWN6XS9pLvQzHjuUCaHhTovpg==
X-Google-Smtp-Source: ABdhPJwuFeEYedCZc7cXG0yXNPnuhgY/exznmjiw2mbotv0DZaAcnF8ajfJ8Jo1V2niMARkZy3jycA==
X-Received: by 2002:a17:90b:1d8b:b0:1bf:b979:bf27 with SMTP id pf11-20020a17090b1d8b00b001bfb979bf27mr26912642pjb.15.1647692424608;
        Sat, 19 Mar 2022 05:20:24 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79597000000b004fa3634907csm9485537pfj.72.2022.03.19.05.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 05:20:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        irusskikh@marvell.com, epomozov@marvell.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 3/3] net: atlantic: Implement .ndo_xdp_xmit handler
Date:   Sat, 19 Mar 2022 12:19:13 +0000
Message-Id: <20220319121913.17573-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220319121913.17573-1-ap420073@gmail.com>
References: <20220319121913.17573-1-ap420073@gmail.com>
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
index 97b02ebda3bc..7b38978ec24a 100644
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

