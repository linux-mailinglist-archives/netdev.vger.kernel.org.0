Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4BA4F9C65
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiDHSUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238478AbiDHSUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:20:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EB01A590E;
        Fri,  8 Apr 2022 11:18:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 2so9364456pjw.2;
        Fri, 08 Apr 2022 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=18I+RyxgUeMQH1gbioCsbZ117JmCwekdtCCEBKsOPhE=;
        b=FQr3WOhq72nRoN40TG6jBdn/4lORwIkEO3TFfWxyjU5xl1CgdYxOvuBxQWszFg0O/w
         8BzAnlECyZX0wlM74X8yyZqwVNUuj2YsL1QkmwOqO38PanUlAXc4UOXPaN1BkQAoBjtu
         P8LcDmcrBILVqJ409r0a/kWO++uiWDPV7eICazm2ARzdYJtxz6OtZMubgkcnEoiQcQg5
         kPgu9l8dIgiPSFNKAg0Mft5ZTrqzonbmmLJHER17TSfLvokbMI7uXnjkGjA2Ckc0QUcr
         JH2yfJvsROwnDqt5S7Jw4csmwAZaH7al3Hzkdx6tqmkZT02jPQ/XIrGHPm0QMmEUCLJb
         3Scw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=18I+RyxgUeMQH1gbioCsbZ117JmCwekdtCCEBKsOPhE=;
        b=r9o+QrNHDKuQz7/Nw2hMjYUqdDyR4iSiUcOAv2x04oI0nDJOqTPQrprcERT66DvEpd
         knWSsjRRjaRDI+tfWlYXpv4JVAC+7Qwzei9MEw0mvGco+K+r9LkoVkTfdhLaF4Janrty
         VWFhT8B4wJGvJjUsxOtxNtustq3fVFA5S7mGa4KX+H7vvH7YexMPSW87lFVNW4GnnSlx
         uvzeoOac87yI2WyXx6U3AG/qZi+iA8WTLXYqWW49iivPtHQiA1D0d1yHKdbA6NfGyThW
         JZHwPR6APKHr5Vrm6Tm462FXZyuv0RsOFbXOAA0E4cNvsgCYuZeOqIplGTpRnQDAULjy
         pLhQ==
X-Gm-Message-State: AOAM532wbDhP1MxhH2MweRDWQzckgSa5SeQ3Gmak5wwml+YrQSsmT3Oc
        7PcMb82aNWQyt30bQNJX8Yy08SWWggw=
X-Google-Smtp-Source: ABdhPJzQZgoZy5f1pyUYi5gAK1Uvyi1PY67ShSOnTC+LIaj4re4v/d0V9RNL1VnQ8W0ycGEeAQWzXA==
X-Received: by 2002:a17:90b:1e0e:b0:1c7:5b03:1d8b with SMTP id pg14-20020a17090b1e0e00b001c75b031d8bmr23009417pjb.121.1649441906611;
        Fri, 08 Apr 2022 11:18:26 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d59-20020a17090a6f4100b001cb4b786e64sm2725388pjk.28.2022.04.08.11.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:18:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v4 3/3] net: atlantic: Implement .ndo_xdp_xmit handler
Date:   Fri,  8 Apr 2022 18:17:14 +0000
Message-Id: <20220408181714.15354-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220408181714.15354-1-ap420073@gmail.com>
References: <20220408181714.15354-1-ap420073@gmail.com>
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
index d2953a84073e..e788f9095a96 100644
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

