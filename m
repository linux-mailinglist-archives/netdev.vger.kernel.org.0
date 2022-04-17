Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D4504780
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiDQKPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 06:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiDQKPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 06:15:49 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4913813F67;
        Sun, 17 Apr 2022 03:13:14 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p10so10315741plf.9;
        Sun, 17 Apr 2022 03:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S7vOL6CcNagKgspC/055jOR/S+tuyBj7Z2ZOj0K9B1M=;
        b=QOqjegbGZjtPz298Nk8sb/vdQI9aRi/hJTWFm8t2+m/Vvpu5W8rGuyKumQueii5Xoi
         rnTKcjRs6D9Xh+As+tsjmxADUlAVLfLS8NMO3Rx3zszOBgK39Kn08zrOHoWthd5gJXG6
         w88jfppG0jZ6+AcV1/fIqaO7ABKCBr7nGVsc+ewuDxL2afGCuSyG1HNGTg+BfqgvALNk
         WAbKaFxmavHxfKx3ewVYtWdesRisYJZDKbmBqSiGmGbEG1K0GLVsdQMNKcgIKFJTmOVC
         YJ96GozZrvKLiO08bG+JTgGNB7guCebnGzEIxkS0AEDG2ttHa25O/teQ1Ty24fT/qf4W
         C1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S7vOL6CcNagKgspC/055jOR/S+tuyBj7Z2ZOj0K9B1M=;
        b=7dA/LfjRd8Jk9KDFNJzKPB8c3nvbbZS+u2VO4oY/vBdgaa2KYg3XFb1XrNa7WOzJwO
         Sa/q+LYvO7CMiDxsyfye6nJvrSDDMQxKOakfZKTOGuw53UMwjH55pGPH+G9NM7ylWweo
         5BhIKXOCpYWGSfttc8jJEzvDvn+le38OvlN3QmWN/u50mSOl8gvKSrwIRpmemCKjab+o
         WYreGfOxwcpSWClgi4gXutT1k3+/maYhHhkqrMNfKEKW7v/fx+AiSKZbZYEcJ9LS1u5x
         MozhPn2JkUu0dlwwqEVkZSh0i40eqsOq+q3BSKQxC9dKYk8c/252iCU6YH66oQvCtRez
         prMw==
X-Gm-Message-State: AOAM5333X3BbjZ9oT41VnZyAhg5yrbnYfLoVGm6PTaTcLdMpiJgAENVJ
        sCfyYyJNreGGU6FJIpYYdeU=
X-Google-Smtp-Source: ABdhPJzjzwA43vE76Y1KAah31MvdrJn2DALyaVfy0NAXDA7yE5Am4wahws7wEsK4Ss/ghGXNIjnRbw==
X-Received: by 2002:a17:902:8d83:b0:157:c14:12b5 with SMTP id v3-20020a1709028d8300b001570c1412b5mr6203427plo.91.1650190393640;
        Sun, 17 Apr 2022 03:13:13 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm7473760pfu.54.2022.04.17.03.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 03:13:13 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v5 3/3] net: atlantic: Implement .ndo_xdp_xmit handler
Date:   Sun, 17 Apr 2022 10:12:47 +0000
Message-Id: <20220417101247.13544-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220417101247.13544-1-ap420073@gmail.com>
References: <20220417101247.13544-1-ap420073@gmail.com>
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

v5:
 - No changed

v4:
 - No changed

v3:
 - No changed

v2:
 - No changed

 .../net/ethernet/aquantia/atlantic/aq_main.c  |  1 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 23 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e794ee25b12b..88595863d8bc 100644
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
index 9bb9b764d31c..ea740210803f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -389,6 +389,29 @@ static void aq_rx_checksum(struct aq_ring_s *self,
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
index 52f40ea3f1df..0a6c34438c1d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -199,6 +199,8 @@ void aq_ring_update_queue_state(struct aq_ring_s *ring);
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

