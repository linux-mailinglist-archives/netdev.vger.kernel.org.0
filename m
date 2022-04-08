Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA584F9B3C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiDHRCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbiDHRC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:02:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF24932037E;
        Fri,  8 Apr 2022 10:00:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso10256902pjh.3;
        Fri, 08 Apr 2022 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8c+XxETKL0bPVGVuW43Ae98PJcI56RAkjrCPDvBpHPs=;
        b=lvS3N6hXpebqq6dNJM0QwNdHvs+Wrx+cSYKNLok7FU/AjWfVmCUfFEoL58pMhGb5Cs
         TDxaFrieQs7p/GHjuUDpAR+nEOsssKxHBUFF+wEwm84JX/GAQc0KC8SdZHeyQHEIe707
         TvGo95xnVVxxX2qNCC6pVv+akHnQ5SEd1ipAIAMhYxA/5T9hCZXpubmcnHBob94rCoCq
         ZEOEgYpZ2nXlskev1qVGc+lKAdxrdE5zKh7mB7pWU4oLp62iHNfClJDpLg+ODNwkLHua
         o+2niMZaM1tTIcetcV9af6GIfnoqrfei+mQvQe8AH+kk26SMg5S5TD5eDkCX2fX9TQ0i
         ofFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8c+XxETKL0bPVGVuW43Ae98PJcI56RAkjrCPDvBpHPs=;
        b=zjJkICr5xOhflIKArB5WChB5iJpRbjd7b3h5c7JjLf34SfNds4AGtMGc65L6KuX+0J
         r5uDBSkYgmJWsm5Jrv/X+jHEmxmJYKbTCBwK+wUSeMaUhP7xnM7k6Z6JJM7JWbq+JmWW
         dDJO9+hlVZ5g/tZQA+fbAy5K2iZKgwEk1aaOc469foO4mzaXxr0iBM7eJX1CFqNq050E
         RxifBVwZh8YD2YCM3vZqySv25P+q7FsQlTxT+diyr6j/Pm/+1K5PIWSD/jNaO6EASfXc
         cl3hAzvwP2oNIcywk8qaNmy19G8SnnjsQ0ra2u5HU+/8X7ssW3ewGC6w6ipHiaYsGCtk
         C2wg==
X-Gm-Message-State: AOAM5311faK1TpUtQ2It6jWSTEr6Ek5g8jHDZuCRhDYS9esxqHVI31od
        3KkBWqUBTTyvZvhKfMfkX3g=
X-Google-Smtp-Source: ABdhPJwqIJ7/2DDTDHOQk/1/QOlU/ydMFksUqP6cve2ZUQUv4Gtou6oQDFdGkQn5FGYa2FkSjxPYFw==
X-Received: by 2002:a17:90a:d3d1:b0:1bb:fdc5:182 with SMTP id d17-20020a17090ad3d100b001bbfdc50182mr23008990pjw.206.1649437218193;
        Fri, 08 Apr 2022 10:00:18 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78d18000000b0050564584660sm6513479pfe.32.2022.04.08.10.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:00:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v3 3/3] net: atlantic: Implement .ndo_xdp_xmit handler
Date:   Fri,  8 Apr 2022 16:59:50 +0000
Message-Id: <20220408165950.10515-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220408165950.10515-1-ap420073@gmail.com>
References: <20220408165950.10515-1-ap420073@gmail.com>
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

v3:
 - No changed

v2:
 - No changed

 .../net/ethernet/aquantia/atlantic/aq_main.c  |  1 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 23 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 43012648a351..a0c428db886f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -508,6 +508,7 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc = aq_ndo_setup_tc,
 	.ndo_bpf = aq_xdp,
+	.ndo_xdp_xmit = aq_xdp_xmit,
 };
 
 static int __init aq_ndev_init_module(void)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 4c3bfb686d5a..589eb129f6ee 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -401,6 +401,29 @@ static void aq_rx_checksum(struct aq_ring_s *self,
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

