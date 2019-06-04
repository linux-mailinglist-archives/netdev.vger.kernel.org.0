Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D515A34E61
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfFDRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51243 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfFDRIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id f10so860790wmb.1;
        Tue, 04 Jun 2019 10:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cdR9+19rqt8mVDkA7SdejRTjk4bLstkTdSyyt6NsVN8=;
        b=ASU4LimIVWiE+/zW/TSNsh2sE6BbK5q+UzQSueVMBQrM9YpY/u0p9xw80Z05eKguUv
         fDMJUWx/cSRAWvHv1zJcrB4dNDU6gDFw8Hsh0qjbn511wMx29x5Nm3ZCytzwi3uvUWZ4
         l82FXG/42KziklVm/be6uS7FPbPWloLMORXUwaBoz6fSTjSFoPMhkH7nNeQdRX537t1P
         XjzR3tvMGNCEidYnnBAvSb09KrVSUa/cl9XZNHBWQN+KiOCYXKT0wIRW3WuH+ddB1Hbn
         +NosgD28SnvBN4G/hz+aLrR7zvdn4dPs/bIujueONb+8gOv6lHd6LUNrlUIOLa4Bvn2c
         NI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cdR9+19rqt8mVDkA7SdejRTjk4bLstkTdSyyt6NsVN8=;
        b=E4bqoIvSnY58cTHnB0/uKEd1U04KiwqqSZc9E8eIfB1JUhsnFaM7g9fJ+uOM7VZIPP
         07c+WCG/Dna4xsqk90id/m5mq7bJY8Y6TYoeyxevzps57zHVNU2WmGgHlge9FCEKHXcu
         MGcltkGRTtoMqqaJhHGvl4RRZ7x578A6X5rrnlAyoBJXb0Pq/uuy3vQzihYj0/r3XurO
         r6rXw4yQybCHvXKnwFPH6iLycOSllHKcCjIrK2HUuVHAKpJmQax0SAjeipJFbg8zG2zw
         SfNUABaCIXFcuMP/AI6TcTZduHyWYBjWQGeMduOzAwQC1KldzU9j2RpD8bKfGJXe7r4Y
         iFDg==
X-Gm-Message-State: APjAAAX12t85dmm8gVHIXn2+J9ndTAHEyeqYzQtMH9PLJXQmbmO6HthM
        olKB4fhme2AHuzo4xACIU+Y=
X-Google-Smtp-Source: APXvYqy1Gsnn0r0rChBmmm7gL2FIAYoL3t/RuNaJ6Z0L9OLVa/A1ZA64X5Ut3SmBagkAB1+OBuyIzg==
X-Received: by 2002:a7b:c344:: with SMTP id l4mr18136934wmj.59.1559668098961;
        Tue, 04 Jun 2019 10:08:18 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 14/17] net: dsa: sja1105: Add a global sja1105_tagger_data structure
Date:   Tue,  4 Jun 2019 20:07:53 +0300
Message-Id: <20190604170756.14338-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to keep state for RX timestamping. It is global
because the switch serializes timestampable and meta frames when
trapping them towards the CPU port (lower port indices have higher
priority) and therefore having one state machine per port would create
unnecessary complications.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c |  5 +++++
 include/linux/dsa/sja1105.h            | 15 +++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 5a4f83a3417b..0fc6fe9ada87 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -103,6 +103,7 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	struct sja1105_tagger_data tagger_data;
 };
 
 #include "sja1105_dynamic_config.h"
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f83f924c0833..9dd2ab2725b6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1828,6 +1828,7 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 
 static int sja1105_probe(struct spi_device *spi)
 {
+	struct sja1105_tagger_data *tagger_data;
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
 	struct dsa_switch *ds;
@@ -1882,12 +1883,16 @@ static int sja1105_probe(struct spi_device *spi)
 	ds->priv = priv;
 	priv->ds = ds;
 
+	tagger_data = &priv->tagger_data;
+	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
+
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		struct sja1105_port *sp = &priv->ports[i];
 
 		ds->ports[i].priv = sp;
 		sp->dp = &ds->ports[i];
+		sp->data = tagger_data;
 	}
 	mutex_init(&priv->mgmt_lock);
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index b9619d9fca4c..b83f6e428e5d 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -31,7 +31,22 @@
 #define SJA1105_META_SMAC			0x222222222222ull
 #define SJA1105_META_DMAC			0x0180C200000Eull
 
+/* Global tagger data: each struct sja1105_port has a reference to
+ * the structure defined in struct sja1105_private.
+ */
+struct sja1105_tagger_data {
+	struct sk_buff_head skb_rxtstamp_queue;
+	struct work_struct rxtstamp_work;
+	struct sk_buff *stampable_skb;
+	/* Protects concurrent access to the meta state machine
+	 * from taggers running on multiple ports on SMP systems
+	 */
+	spinlock_t meta_lock;
+	bool hwts_rx_en;
+};
+
 struct sja1105_port {
+	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
 	int mgmt_slot;
-- 
2.17.1

