Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56072D1B8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfE1WuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:50:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55570 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfE1WuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:50:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id u78so214471wmu.5
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZcKQzeRrGqEtX0enX1a2gnbGz8wi0WaL1BLD3OQJD4k=;
        b=rhiMpTgZ+qKVv3MhxQXH9XKA7KAJdXZXylchrQSybZHbzUrriDDUCM1Lbzezq8xFgS
         P81bdb8aGI2Fz+7WRGRuUXoOyXn7Vgjza5ZNLRP6XZStnHZ0UzhEBtZnZS10xUspZUky
         MnuAoU2fP8KboWyScWQyWfWWTPfgvt52NNfkBDUGB+TTFOfQdAtbHnKPFgSALATX75o/
         C54xPx0mXdGKDHcceu2coGVQunQG4PK6QXW2wfKSIB9qAjSyl4wqzZs33UpH9hFo06Db
         4+k48MIp/5YxQ+yE8KZsulzebrPiWZ+tk+mCJ0j2Wud8SK5ViXL7rYXWazqKr2E+Hjmr
         Lgcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZcKQzeRrGqEtX0enX1a2gnbGz8wi0WaL1BLD3OQJD4k=;
        b=b4ZDGiVHQxNSgkx64s9MjxuNF7dPc++WUNw0MsS9IlU73OL+hNv241YSW4R7A+nWTF
         OGVvlILBgIkUpWGzvvirtUBg74WkmOwVwnEmN6t48rqJs+JbJQeyqsgp9pFPzoQ/th2m
         JN4i9uDJs2O55RfF3ucHvC0BnQa9q5yJhDgiOiFuyIL9zfP83HPz3I8fsjW87cV8alh5
         P3ALoiq/wlXRv4luFMCtJ9COxNXCHUPzKJmWXMI2p/5trCsZo2j8O4BWV5yM/rVbqQyR
         q9UEYoO6B5rH18MetwrJozyKP1fzGvu75r0O9pAd3lFr3ZOb150E2cC1RIYU6iXJE/PM
         SKKA==
X-Gm-Message-State: APjAAAUdyzHSc8ggY9kXVpXUekw2cg3qpmGfitTixkpJSAgs7TBCu88p
        L43CxM0Vppn4xV8R0nEROis=
X-Google-Smtp-Source: APXvYqzz4VjCh/HDtZDrTHoLwCNO5LztCF/oZ1Eaarc2Mr2xK2ihwbg2DbUEOb3SK7F6ZUGn+yfA+A==
X-Received: by 2002:a1c:c016:: with SMTP id q22mr5037997wmf.6.1559083814329;
        Tue, 28 May 2019 15:50:14 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm6623658wrq.48.2019.05.28.15.50.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 15:50:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/2] net: dsa: tag_8021q: Create a stable binary format
Date:   Wed, 29 May 2019 01:50:05 +0300
Message-Id: <20190528225005.10628-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528225005.10628-1-olteanv@gmail.com>
References: <20190528225005.10628-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tools like tcpdump need to be able to decode the significance of fake
VLAN headers that DSA uses to separate switch ports.

But currently these have no global significance - they are simply an
ordered list of DSA_MAX_SWITCHES x DSA_MAX_PORTS numbers ending at 4095.

The reason why this is submitted as a fix is that the existing mapping
of VIDs should not enter into a stable kernel, so we can pretend that
only the new format exists. This way tcpdump won't need to try to make
something out of the VLAN tags on 5.2 kernels.

Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_8021q.c | 54 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4adec6bbfe59..4c2c70ce5d54 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -11,20 +11,54 @@
 
 #include "dsa_priv.h"
 
-/* Allocating two VLAN tags per port - one for the RX VID and
- * the other for the TX VID - see below
+/* Binary structure of the fake 12-bit VID field (when the TPID is
+ * ETH_P_DSA_8021Q):
+ *
+ * +-----+------+-----------------+------+-----------------------------+-----+
+ * | DIR | RSVD |    SWITCH_ID    | RSVD |             PORT            | MBZ |
+ * +-----+------+-----------------+------+-----------------------------+-----+
+ * 12    11     10                7      6                             1     0
+ *
+ * DIR - VID[11]:
+ *	Direction flag. 0 for RX VLAN, 1 for TX VLAN
+ *
+ * RSVD - VID[10]:
+ *	To be used for further expansion of SWITCH_ID or for other purposes.
+ *
+ * SWITCH_ID - VID[9:7]:
+ *	Index of switch within DSA tree. Must be between 0 and
+ *	DSA_MAX_SWITCHES - 1.
+ *
+ * RSVD - VID[6]:
+ *	To be used for further expansion of PORT or for other purposes.
+ *
+ * PORT - VID[5:1]:
+ *	Index of switch port. Must be between 0 and DSA_MAX_PORTS - 1.
+ *
+ * MBZ - VID[0]:
+ *	Must be zero. This makes the special VIDs of 0, 1 and 4095 to be left
+ *	unused by this coding scheme.
  */
-#define DSA_8021Q_VID_RANGE	(DSA_MAX_SWITCHES * DSA_MAX_PORTS)
-#define DSA_8021Q_VID_BASE	(VLAN_N_VID - 2 * DSA_8021Q_VID_RANGE - 1)
-#define DSA_8021Q_RX_VID_BASE	(DSA_8021Q_VID_BASE)
-#define DSA_8021Q_TX_VID_BASE	(DSA_8021Q_VID_BASE + DSA_8021Q_VID_RANGE)
+
+#define DSA_8021Q_DIR_TX		BIT(11)
+
+#define DSA_8021Q_SWITCH_ID_SHIFT	7
+#define DSA_8021Q_SWITCH_ID_MASK	GENMASK(9, 7)
+#define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
+						 DSA_8021Q_SWITCH_ID_MASK)
+
+#define DSA_8021Q_PORT_MASK		GENMASK(5, 1)
+#define DSA_8021Q_PORT_SHIFT		1
+#define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
+						 DSA_8021Q_PORT_MASK)
 
 /* Returns the VID to be inserted into the frame from xmit for switch steering
  * instructions on egress. Encodes switch ID and port ID.
  */
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
 {
-	return DSA_8021Q_TX_VID_BASE + (DSA_MAX_PORTS * ds->index) + port;
+	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(ds->index) |
+	       DSA_8021Q_PORT(port);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
 
@@ -33,21 +67,21 @@ EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
  */
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 {
-	return DSA_8021Q_RX_VID_BASE + (DSA_MAX_PORTS * ds->index) + port;
+	return DSA_8021Q_SWITCH_ID(ds->index) | DSA_8021Q_PORT(port);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
 
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
 {
-	return ((vid - DSA_8021Q_RX_VID_BASE) / DSA_MAX_PORTS);
+	return (vid & DSA_8021Q_SWITCH_ID_MASK) >> DSA_8021Q_SWITCH_ID_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_switch_id);
 
 /* Returns the decoded port ID from the RX VID. */
 int dsa_8021q_rx_source_port(u16 vid)
 {
-	return ((vid - DSA_8021Q_RX_VID_BASE) % DSA_MAX_PORTS);
+	return (vid & DSA_8021Q_PORT_MASK) >> DSA_8021Q_PORT_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
-- 
2.17.1

