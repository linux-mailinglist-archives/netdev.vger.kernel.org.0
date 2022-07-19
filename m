Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE2F5791FD
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 06:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiGSEbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 00:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiGSEbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 00:31:04 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFFD65DD
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 21:31:02 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r9so22776543lfp.10
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 21:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GaoAM7wIk4CtgU3IfIsrGztYMXHNDF1dq7CSrqhxFE0=;
        b=H5kGffADBDoHredd2OISNUHZVn7+F6AWldNkIVTP5ycO2YFM10klTW7Ks5Ui9zrjMw
         kTvonaPw5H64Hn7wEyFnpnHYMX4T4yLgi7GuJTxj0ntEX9KlmZ8Ch/Uelw0RJEHl1ySQ
         RvIOhAFk29uYx4VLkYItqiR5Jo6tf7dNcl11i8UTldTj2bWz5kfKXtpoKu4Nifx2nHti
         n2DbZg4LghJWHHTgBsE1T6ccyH7rCE0HtzGIb0VNNoeVc+SOiifsKu9sPDFfsKdOjIB9
         SCLVYfUON+sSFxPcn/3ITGOImGHKCPZpfcJ2hU1P7LNDKtqygTdbLWwGL0CZugUe6V8l
         iI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GaoAM7wIk4CtgU3IfIsrGztYMXHNDF1dq7CSrqhxFE0=;
        b=QuE/tboWgN6O3EJngQXQtOjvcK8pzstgeO5n3RXy5e9On6yjjCigyLvBhCXSIjCvCQ
         lyT5RoOGG/Uf6dt/dNI06iOSNuaHy1TuLQFKb7gDSiFQgwH4sugG9kaLldTf/c8NQs9V
         56qS47QAL4nVymlID2bBvpwq2qgpxcaqIQFsTg1GbGEWZamJIvW46AYhUdcH+wO0gWf/
         stTDHnNaJUVXawC+cmVVW+7Hq3x0g9eeNC+1vSC2XRH/7BUJWjEmVNw+wXLmomBQ82uK
         DJk0ySNrI9SYz7KlUvM2UXjlsmWUHNDOXnDSkfq7ukokCny0G6Y/y1Z0Q4hoQH4URKAU
         J0Uw==
X-Gm-Message-State: AJIora+gpXHgdZNRLxQrm9LpdGJUJccbdhE1bNLsA4i49HWhkQNndcyE
        jQDL9q5qqWROneOe0Sbm1RzTgj8kns2HSw==
X-Google-Smtp-Source: AGRyM1vN86GpT+Zl+3fjiOg+9X5Q+Ge9PYho8wDByUiMcMb7zu+8X7aq8RxqAh6kO/pxkHhz557sng==
X-Received: by 2002:a05:6512:a87:b0:489:da5f:1f59 with SMTP id m7-20020a0565120a8700b00489da5f1f59mr17792517lfu.375.1658205060732;
        Mon, 18 Jul 2022 21:31:00 -0700 (PDT)
Received: from localhost.localdomain ([149.62.15.87])
        by smtp.gmail.com with ESMTPSA id u17-20020ac258d1000000b0047fa8ffe92csm2956223lfo.233.2022.07.18.21.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 21:31:00 -0700 (PDT)
From:   Andrey Turkin <andrey.turkin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: [PATCH v3] vmxnet3: Implement ethtool's get_channels command
Date:   Tue, 19 Jul 2022 04:29:55 +0000
Message-Id: <20220719042955.4607-1-andrey.turkin@gmail.com>
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

Notes:
    v2:
     - Replaced #ifdef with IS_ENABLED
     - Fixed a compilation warning
    v3:
     - Removed explicit 0 assignments of unused fields.

 drivers/net/vmxnet3/vmxnet3_ethtool.c | 29 +++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3172d46c0335..f2cbf502b76b 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1188,6 +1188,34 @@ static int vmxnet3_set_coalesce(struct net_device *netdev,
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
+		} else {
+			ec->rx_count = adapter->num_rx_queues;
+			ec->tx_count =
+				adapter->share_intr == VMXNET3_INTR_TXSHARE ?
+					       1 : adapter->num_tx_queues;
+		}
+	} else {
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
@@ -1213,6 +1241,7 @@ static const struct ethtool_ops vmxnet3_ethtool_ops = {
 	.set_rxfh          = vmxnet3_set_rss,
 #endif
 	.get_link_ksettings = vmxnet3_get_link_ksettings,
+	.get_channels      = vmxnet3_get_channels,
 };
 
 void vmxnet3_set_ethtool_ops(struct net_device *netdev)

base-commit: ca85855bdcae8f84f1512e88b4c75009ea17ea2f
-- 
2.25.1

