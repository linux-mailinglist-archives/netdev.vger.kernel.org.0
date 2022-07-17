Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E8F577329
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiGQCV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiGQCV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:21:57 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E45415A1C
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 19:21:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bp17so13983836lfb.3
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfbUedu4wJ74Y6IvHcMhvjZA1Sj1dAg9nkDEnrvyN94=;
        b=o0eOfFuXgJp5TdrlD2AppeVgbvafy2uYrhDs33kThI+YFornqGUwDNEOicosIqueiQ
         LHKt0cg0M8Xqf8lTNhzFaGHEdabZBs7ILdgjmLbDxQdk8aeXTTrGV+qOXZ45PXN46khr
         cGqfknr4RMABio2+960FsvyyGTfrV/oGzzciSDefWL2EQy3URLZ7STdixu1BDKAvilR7
         H6wrCKPyQ0rNBxkXKl+cz1Kboq+rSyHiRPY9ZN8eI9MjO5QndxSp12MTIBrhIYrF4rBS
         5x9QA6UbRSseoAUN2YdpdNF94X62WNKfweFh9/hvb+qbFdcuwRTvy9UmUIiBXqxaJMJr
         ihdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfbUedu4wJ74Y6IvHcMhvjZA1Sj1dAg9nkDEnrvyN94=;
        b=aHZeI4amg8F2TxYNWIf3VelxKlsbuov0QdK5tdWEFHm8nuZ4CeEiWfLEaVSSLx5pw0
         dc6RSxWgQ9aEq1rLdYwnI/JA9QOM7UXa4frKVCzitPzZ2bs5x68w3/dC6IzBUgS+PtWt
         mD/WpabPdXmLkMFflnGNIjzWYe4Tddl7jAdwPyIqDONK9Ogez6Kov2HWgwl61pKoldgI
         +SmyX2ngP2IDDkH+IYIuFYmR6UpHbYPDNVF4i1JP4n1R1yPF8wMnb7cBXGNovJSb9B7d
         iQQot4CAPpzHWk02zy5EuwTuZUO/SKCmeGwQ9lt/3Uv64d2obm//aV4IvDS48n/hill3
         kstw==
X-Gm-Message-State: AJIora/fr6G+MceC9S1oxKBhGAYVeMQQOBRmmz1WzOldOj+4GlTz/aff
        7YosYT/50XgFOkmz3DjxTSRTEEJ5ddM=
X-Google-Smtp-Source: AGRyM1vcpK782FYjU5PDKgqtMIWeuAUOCopibuPEQu0XwwrNqeQU+r4/vp3kcGm5snN78atyGpWc2g==
X-Received: by 2002:a05:6512:3409:b0:489:c549:4693 with SMTP id i9-20020a056512340900b00489c5494693mr11245101lfr.26.1658024513482;
        Sat, 16 Jul 2022 19:21:53 -0700 (PDT)
Received: from localhost.localdomain ([149.62.15.87])
        by smtp.gmail.com with ESMTPSA id c28-20020ac25f7c000000b0047f750ecd8csm1767224lfc.67.2022.07.16.19.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 19:21:53 -0700 (PDT)
From:   Andrey Turkin <andrey.turkin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: [PATCH] vmxnet3: Implement ethtool's get_channels command
Date:   Sun, 17 Jul 2022 02:20:49 +0000
Message-Id: <20220717022050.822766-1-andrey.turkin@gmail.com>
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
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 38 +++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3172d46c0335..d1a7ec975b87 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1188,6 +1188,43 @@ static int vmxnet3_set_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+void vmxnet3_get_channels(struct net_device *netdev,
+			  struct ethtool_channels *ec)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+#if defined(CONFIG_PCI_MSI)
+	if (adapter->intr.type == VMXNET3_IT_MSIX) {
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
+#endif
+		ec->rx_count = 0;
+		ec->tx_count = 0;
+		ec->combined_count = 1;
+#if defined(CONFIG_PCI_MSI)
+	}
+#endif
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
@@ -1213,6 +1250,7 @@ static const struct ethtool_ops vmxnet3_ethtool_ops = {
 	.set_rxfh          = vmxnet3_set_rss,
 #endif
 	.get_link_ksettings = vmxnet3_get_link_ksettings,
+	.get_channels      = vmxnet3_get_channels,
 };
 
 void vmxnet3_set_ethtool_ops(struct net_device *netdev)

base-commit: 972a278fe60c361eb8f37619f562f092e8786d7c
-- 
2.25.1

