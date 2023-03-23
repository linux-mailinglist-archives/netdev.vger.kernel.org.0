Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4136C6539
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCWKgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCWKgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:36:09 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358541F5CC;
        Thu, 23 Mar 2023 03:32:14 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id 7ED9920018;
        Thu, 23 Mar 2023 10:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679567533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXghyFKbkBEH9/EKzDk+5w9Pp/aMwqnL/aCTRT1Laoo=;
        b=E6OQP+L/ND7GZdhdmMYoIfxyMK2SDfzBBi5Fr2H9jRBWu2YblAWfptMgnUjRpTqQJcwWTZ
        rrbzT8mEpeGdGKmFpz/nynaeqhRWwku0sk/RIrQb+Xt0ODbJmEh3Bo6e68fSGjY27/f83s
        zUB1xxEwYN3rF1eXgesuUHobBUNM+pDgWyPJl7eu2T4/+a7qot0+tuCO3lma/QJavKmQ6Q
        tsPq8mRFybTI8WQX7xAxuOiwvIt9DohSVS+mVXnPmTDL+z3d2BEXRJB/gG+zKtUCSV4XnY
        vwe7OrT8uGSoc43tI8+O4Enk6zIGcNJ+HmXQmbPbaznATUhXTyeii3KP2eoiMQ==
From:   Herve Codina <herve.codina@bootlin.com>
To:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [RFC PATCH 3/4] net: wan: fsl_qmc_hdlc: Add PHY support
Date:   Thu, 23 Mar 2023 11:31:53 +0100
Message-Id: <20230323103154.264546-4-herve.codina@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323103154.264546-1-herve.codina@bootlin.com>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PHY support in the fsl_qmc_hdlc driver in order to be able to
signal carrier changes to the network stack based on the PHY status.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
---
 drivers/net/wan/fsl_qmc_hdlc.c | 152 ++++++++++++++++++++++++++++++++-
 1 file changed, 151 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/fsl_qmc_hdlc.c b/drivers/net/wan/fsl_qmc_hdlc.c
index f12d00c78497..edea0f678ffe 100644
--- a/drivers/net/wan/fsl_qmc_hdlc.c
+++ b/drivers/net/wan/fsl_qmc_hdlc.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <soc/fsl/qe/qmc.h>
@@ -27,6 +28,11 @@ struct qmc_hdlc {
 	struct device *dev;
 	struct qmc_chan *qmc_chan;
 	struct net_device *netdev;
+	struct phy *phy;
+	spinlock_t carrier_lock; /* Protect carrier detection */
+	struct notifier_block nb;
+	bool is_phy_notifier;
+	struct delayed_work phy_poll_task;
 	bool is_crc32;
 	spinlock_t tx_lock; /* Protect tx descriptors */
 	struct qmc_hdlc_desc tx_descs[8];
@@ -39,6 +45,126 @@ static inline struct qmc_hdlc *netdev_to_qmc_hdlc(struct net_device *netdev)
 	return (struct qmc_hdlc *)dev_to_hdlc(netdev)->priv;
 }
 
+static int qmc_hdlc_phy_set_carrier(struct qmc_hdlc *qmc_hdlc)
+{
+	union phy_status phy_status;
+	unsigned long flags;
+	int ret;
+
+	if (!qmc_hdlc->phy)
+		return 0;
+
+	spin_lock_irqsave(&qmc_hdlc->carrier_lock, flags);
+
+	ret = phy_get_status(qmc_hdlc->phy, &phy_status);
+	if (ret) {
+		dev_err(qmc_hdlc->dev, "get PHY status failed (%d)\n", ret);
+		goto end;
+	}
+	if (phy_status.basic.link_is_on)
+		netif_carrier_on(qmc_hdlc->netdev);
+	else
+		netif_carrier_off(qmc_hdlc->netdev);
+
+end:
+	spin_unlock_irqrestore(&qmc_hdlc->carrier_lock, flags);
+	return ret;
+}
+
+static int qmc_hdlc_phy_notifier(struct notifier_block *nb, unsigned long action,
+				 void *data)
+{
+	struct qmc_hdlc *qmc_hdlc = container_of(nb, struct qmc_hdlc, nb);
+	int ret;
+
+	if (action != PHY_EVENT_STATUS)
+		return NOTIFY_DONE;
+
+	ret = qmc_hdlc_phy_set_carrier(qmc_hdlc);
+	return ret ? NOTIFY_DONE : NOTIFY_OK;
+}
+
+static void qmc_hdlc_phy_poll_task(struct work_struct *work)
+{
+	struct qmc_hdlc *qmc_hdlc = container_of(work, struct qmc_hdlc, phy_poll_task.work);
+	int ret;
+
+	ret = qmc_hdlc_phy_set_carrier(qmc_hdlc);
+	if (ret) {
+		/* Should not happened but ...
+		 * On error, force carrier on and stop scheduling this task
+		 */
+		dev_err(qmc_hdlc->dev, "set carrier failed (%d) -> force carrier on\n",
+			ret);
+		netif_carrier_on(qmc_hdlc->netdev);
+		return;
+	}
+
+	/* Re-schedule task in 1 sec */
+	queue_delayed_work(system_power_efficient_wq, &qmc_hdlc->phy_poll_task, 1 * HZ);
+}
+
+static int qmc_hdlc_phy_init(struct qmc_hdlc *qmc_hdlc)
+{
+	union phy_status phy_status;
+	int ret;
+
+	if (!qmc_hdlc->phy)
+		return 0;
+
+	ret = phy_init(qmc_hdlc->phy);
+	if (ret) {
+		dev_err(qmc_hdlc->dev, "PHY init failed (%d)\n", ret);
+		return ret;
+	}
+
+	ret = phy_power_on(qmc_hdlc->phy);
+	if (ret) {
+		dev_err(qmc_hdlc->dev, "PHY power-on failed (%d)\n", ret);
+		goto phy_exit;
+	}
+
+	/* Be sure that get_status is supported */
+	ret = phy_get_status(qmc_hdlc->phy, &phy_status);
+	if (ret) {
+		dev_err(qmc_hdlc->dev, "get PHY status failed (%d)\n", ret);
+		goto phy_power_off;
+	}
+
+	qmc_hdlc->nb.notifier_call = qmc_hdlc_phy_notifier;
+	ret = phy_atomic_notifier_register(qmc_hdlc->phy, &qmc_hdlc->nb);
+	if (ret) {
+		qmc_hdlc->is_phy_notifier = false;
+
+		/* Cannot register a PHY notifier -> Use polling */
+		INIT_DELAYED_WORK(&qmc_hdlc->phy_poll_task, qmc_hdlc_phy_poll_task);
+		queue_delayed_work(system_power_efficient_wq, &qmc_hdlc->phy_poll_task, 1 * HZ);
+	} else {
+		qmc_hdlc->is_phy_notifier = true;
+	}
+
+	return 0;
+
+phy_power_off:
+	phy_power_off(qmc_hdlc->phy);
+phy_exit:
+	phy_exit(qmc_hdlc->phy);
+	return ret;
+}
+
+static void qmc_hdlc_phy_exit(struct qmc_hdlc *qmc_hdlc)
+{
+	if (!qmc_hdlc->phy)
+		return;
+
+	if (qmc_hdlc->is_phy_notifier)
+		phy_atomic_notifier_unregister(qmc_hdlc->phy, &qmc_hdlc->nb);
+	else
+		cancel_delayed_work_sync(&qmc_hdlc->phy_poll_task);
+	phy_power_off(qmc_hdlc->phy);
+	phy_exit(qmc_hdlc->phy);
+}
+
 static int qmc_hdlc_recv_queue(struct qmc_hdlc *qmc_hdlc, struct qmc_hdlc_desc *desc, size_t size);
 
 static void qmc_hcld_recv_complete(void *context, size_t length)
@@ -192,10 +318,17 @@ static int qmc_hdlc_open(struct net_device *netdev)
 	int ret;
 	int i;
 
-	ret = hdlc_open(netdev);
+	ret = qmc_hdlc_phy_init(qmc_hdlc);
 	if (ret)
 		return ret;
 
+	ret = hdlc_open(netdev);
+	if (ret)
+		goto phy_exit;
+
+	/* Update carrier */
+	qmc_hdlc_phy_set_carrier(qmc_hdlc);
+
 	chan_param.mode = QMC_HDLC;
 	/* HDLC_MAX_MRU + 4 for the CRC
 	 * HDLC_MAX_MRU + 4 + 8 for the CRC and some extraspace needed by the QMC
@@ -245,6 +378,8 @@ static int qmc_hdlc_open(struct net_device *netdev)
 	}
 hdlc_close:
 	hdlc_close(netdev);
+phy_exit:
+	qmc_hdlc_phy_exit(qmc_hdlc);
 	return ret;
 }
 
@@ -280,6 +415,7 @@ static int qmc_hdlc_close(struct net_device *netdev)
 	}
 
 	hdlc_close(netdev);
+	qmc_hdlc_phy_exit(qmc_hdlc);
 	return 0;
 }
 
@@ -318,6 +454,7 @@ static int qmc_hdlc_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct qmc_hdlc *qmc_hdlc;
 	struct qmc_chan_info info;
+	enum phy_mode phy_mode;
 	hdlc_device *hdlc;
 	int ret;
 
@@ -327,6 +464,7 @@ static int qmc_hdlc_probe(struct platform_device *pdev)
 
 	qmc_hdlc->dev = &pdev->dev;
 	spin_lock_init(&qmc_hdlc->tx_lock);
+	spin_lock_init(&qmc_hdlc->carrier_lock);
 
 	qmc_hdlc->qmc_chan = devm_qmc_chan_get_byphandle(qmc_hdlc->dev, np, "fsl,qmc-chan");
 	if (IS_ERR(qmc_hdlc->qmc_chan)) {
@@ -348,6 +486,18 @@ static int qmc_hdlc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	qmc_hdlc->phy = devm_of_phy_optional_get(qmc_hdlc->dev, np, NULL);
+	if (IS_ERR(qmc_hdlc->phy))
+		return PTR_ERR(qmc_hdlc->phy);
+	if (qmc_hdlc->phy) {
+		phy_mode = phy_get_mode(qmc_hdlc->phy);
+		if (phy_mode != PHY_MODE_BASIC) {
+			dev_err(qmc_hdlc->dev, "Unsupported PHY mode (%d)\n",
+				phy_mode);
+			return -EINVAL;
+		}
+	}
+
 	qmc_hdlc->netdev = alloc_hdlcdev(qmc_hdlc);
 	if (!qmc_hdlc->netdev) {
 		dev_err(qmc_hdlc->dev, "failed to alloc hdlc dev\n");
-- 
2.39.2

