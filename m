Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1977E577A30
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 06:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiGREwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 00:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiGREwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 00:52:17 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF56C11174
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:52:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id by8so8676775ljb.13
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmsaqclXF3nFmah9Svs326cs5HmZm8/ddwum3JQjypQ=;
        b=jmEPw0YLzzPXQbVXZeJerypCVz80P46Nke+qQzZ7mFYUarWed8flgnJTSb3G5VRB4k
         VBCej4IaEj+EJCNPTFPCzYghaEioMOVYmvbPuGiv7Q4MmU5l8O8X3bnNSItvuSultKIi
         PBaMk2ElnwfDZ96IkyWM6INHvMg2ppWXKBTaVCHTKI8Gnnju+0ig/Aps5DBCMSZNtN73
         0dp2AREz0/RhXtdTCRRLprfKSSphWPhGQTZ0zzcBspxidsGKmR7fLOjW2Vg9uew8d95x
         pAkNy+ZizJgNbtN13Bi+ZFzD67WTFDA+h9AXP2d04wJeLXWCcbUu9n1Rn4sNJvVym1Cz
         Htzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmsaqclXF3nFmah9Svs326cs5HmZm8/ddwum3JQjypQ=;
        b=u1keYf98Oyp8fWYbDhAtiYbUNm4YdRa9K0y9jOFWsnyHsXAXXX3D97yWKQpWvxMbtG
         5abzcuyTQUwr92IF5VCe0MCYk3JG+G54WetHCaIVw8WYyW3Ulwp2FLai6f21JbsaBk5B
         yyqwOv2fgKKOW8mOhBGYKNsoBFvSNllUu26ELfv+RRq/gf9bzwuu/5VPyImCazKrhfTV
         IfyC2OiQrJATspVunPtSYvTLseQm/LmHlcncXivo8HzIqKyhkLAgXAh8sK55y17oUPWb
         B0nIyGNZttdcWyrPd/iSeHekMYK+lchgwtTA4IBvNiCf2tZ4UwuM7RF/aYmEPydHptWY
         wN7g==
X-Gm-Message-State: AJIora+VXvUgdzFb/IP0d6zUhpuIHvbHXzdPJObFNY2CT9rhBupCOPS0
        NhbjL2s09g8MLpKAeFjZlBWV9EqVyZs=
X-Google-Smtp-Source: AGRyM1vgBAT4rVUwMgIkEWYyabb+5bXdiSpHwrghEXF3RyXVUo4wTXk8KJlcv3Fj2M6R2GCLjT1FWA==
X-Received: by 2002:a05:651c:a0c:b0:25d:7468:f9b6 with SMTP id k12-20020a05651c0a0c00b0025d7468f9b6mr11440753ljq.306.1658119934829;
        Sun, 17 Jul 2022 21:52:14 -0700 (PDT)
Received: from localhost.localdomain ([149.62.15.87])
        by smtp.gmail.com with ESMTPSA id h28-20020a0565123c9c00b00489da512f5asm2406710lfv.86.2022.07.17.21.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 21:52:14 -0700 (PDT)
From:   Andrey Turkin <andrey.turkin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: [PATCH v2] vmxnet3: Implement ethtool's get_channels command
Date:   Mon, 18 Jul 2022 04:51:10 +0000
Message-Id: <20220718045110.2633-1-andrey.turkin@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some tools (e.g. libxdp) use that information.

Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3172d46c0335..cb1caff93367 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1188,6 +1188,39 @@ static int vmxnet3_set_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+static void vmxnet3_get_channels(struct net_device *netdev,
+				 struct ethtool_channels *ec)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI) && adapter->intr.type == VMXNET3_IT_MSIX) {
+		if (adapter->share_intr == VMXNET3_INTR_BUDDYSHARE) {
+			ec->combined_count = adapter->num_tx_queues;
+			ec->rx_count = 0;
+			ec->tx_count = 0;
+		} else {
+			ec->combined_count = 0;
+			ec->rx_count = adapter->num_rx_queues;
+			ec->tx_count =
+				adapter->share_intr == VMXNET3_INTR_TXSHARE ?
+					       1 : adapter->num_tx_queues;
+		}
+	} else {
+		ec->rx_count = 0;
+		ec->tx_count = 0;
+		ec->combined_count = 1;
+	}
+
+	ec->other_count = 1;
+
+	/* Number of interrupts cannot be changed on the fly */
+	/* Just set maximums to actual values */
+	ec->max_rx = ec->rx_count;
+	ec->max_tx = ec->tx_count;
+	ec->max_combined = ec->combined_count;
+	ec->max_other = ec->other_count;
+}
+
 static const struct ethtool_ops vmxnet3_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1213,6 +1246,7 @@ static const struct ethtool_ops vmxnet3_ethtool_ops = {
 	.set_rxfh          = vmxnet3_set_rss,
 #endif
 	.get_link_ksettings = vmxnet3_get_link_ksettings,
+	.get_channels      = vmxnet3_get_channels,
 };
 
 void vmxnet3_set_ethtool_ops(struct net_device *netdev)

base-commit: ff6992735ade75aae3e35d16b17da1008d753d28
-- 
2.25.1

