Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E739F83
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfFHMGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:06:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38211 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfFHMFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so1748487wmj.3;
        Sat, 08 Jun 2019 05:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1qLTiM+yKca/eE2Qhv9w2ob4ufqQOChs5VTIl33BbI0=;
        b=Ku9mQd2H8nPKdJLvNeG8wfwhQnVBYbspsDnsLpGLVa1v80IiU0jLtd3zk9JRNRiILq
         xt4R78Meyv5Tw4/XoplH0gSzTUy86n4mjTFgyqAH2PO4prySeelC7et+G3i0Sj2nJX0I
         TLgDFxVGCGtJ6u3S2yLyjxCBqfASMV8povQygFt8Rcp4+wZrTK7cWV2S9lmQvwUB30yO
         QHkl0ad0mmiuEtNltrazINr+N4j5jhm8nUGEs9RWuzxSthYjlzg88PLI84eXSTwGOZcU
         Px1X8S8Dms9CVMoJIAmC4zqBYufQJm9I7kkbevbucnJ8u3nPLgB3Hcp+4EqSqS+Pc6AO
         3CJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1qLTiM+yKca/eE2Qhv9w2ob4ufqQOChs5VTIl33BbI0=;
        b=IhzD4LcQU1PBjYxX5evO3L2c/OZiBz0AgIEVPD/kzQnRYoW+zU+WBEUQL/qJNS+cz0
         63cOpV3r7OCjN45+BJ+JXDM6L/JJczcSA0Lei5UbpwqAGySxcsSfrXtMQHP/WUXj1yA7
         a5/pp6gUK3DOdLOkTPIYnvWXL5iQ1qGpyVrNIHUfxIEJpoLx9XsvaLFmt6sopJtW3y7+
         LAlWq8i8aVzE7Nq1L9V4C8X2ty7CnBiVyPNmg8+KNnBNQ9vPb8WD114RHtw/i2a6HihF
         1TFVro3p88V3A0g0sOLmYdHdUmhY0JuERve05FFakJMbNZX1/Yu+pW+YV7zCzJrLcp+x
         UPdw==
X-Gm-Message-State: APjAAAXwP45+ATtU2MFJ7x/KK7AiiSeySa2jVxb8bj5Gmgf2uYhpx6Ys
        Lxedv9m4ZcK7/hrXm7Ng8UBEh7VLYPg=
X-Google-Smtp-Source: APXvYqxuAEAGHnc9ESqevSv3avLS1vbMtJ8uhsVgkk9iLxtQxWk4GRtDeH1V6VWuOtmojgC+jcEWpg==
X-Received: by 2002:a7b:c057:: with SMTP id u23mr7097429wmc.29.1559995550543;
        Sat, 08 Jun 2019 05:05:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 14/17] net: dsa: sja1105: Add a global sja1105_tagger_data structure
Date:   Sat,  8 Jun 2019 15:04:40 +0300
Message-Id: <20190608120443.21889-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
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
Changes in v4:

Removed the redundant sja1105_is_link_local check from
sja1105_port_rxtstamp.

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
index d129997174bb..3c11142f1c67 100644
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
index cc4a909d1007..2c4fce4eaf0d 100644
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

