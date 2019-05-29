Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1493C2E790
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfE2VnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:43:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42616 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfE2VnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:43:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id l2so2751540wrb.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wUUmCCXi1a8Nxpkcvz0+HU7PaBHRY1/8NWD51n100OI=;
        b=mfpgOGzEV2TGDhxVv2plEyT94i/eHWEmKv+YacB3ybugRLhhTx6KUVbWndkBsy7Yvj
         lAAYmQtYF6eMu2AH1L0Oply5a47Gemz37LFjmDkoYqfLjVyNoPYHo8HcjrH2+Ldz7DK8
         Ey0L0mFhQeQEJP4OAZusGzv75k7h6YBtIGHHA5pKGUjFBv0pBSPeWkUdk2C2d3TF0U/+
         QJNSSLIHJfRPS8Ssy74kkL6xIr3KhDSUiAqI32hFbIGLFBnchJsSBC6rlfM9RAjlNQn8
         dc+rCH79tBwc1UEJ6+za8o2XbQKMIX2Tsq45zUw8L8gpDA3235o3XGrfBL0EAg9bea+m
         hGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wUUmCCXi1a8Nxpkcvz0+HU7PaBHRY1/8NWD51n100OI=;
        b=E5q/l0g2jx3urT4gT1ZrvF9tdLzqxfs7hafSy2IgdHWBkJMcP8W/7MbRP2VbBXzhwJ
         O1rPBn1xDoypVM/5rRdLY35qLMYI0fgSTk2FoJXCBYCasuY6xA30Us7OsSVHuEkj0azy
         CUyRIgf9GF6DhOG9kdA03C/eJj4pomF6KWxtpFNMUazM2IbxOuPyyV1U3rUK1Ny4AvXY
         ZdW1cub9chRtTRot0xUzqqUMC+DDrxzCa7ovX8rh8NT/CxKAYzlhuJiXc75VBedj1av9
         h2BG5nnfSmf8T95HFmCzIKEwTo5UG1REC0PBCRCavUuXNGb309/GApWwC3OVVQkPj0Nu
         xwOQ==
X-Gm-Message-State: APjAAAWzG+spMfCbdnNehZoZre6T8q7cX/MbsiYDEYqfSmJjw4kkLLo8
        re3I4zIlXD2aF5mSG/+s3n76RVXmj9c=
X-Google-Smtp-Source: APXvYqwFfJoPJfPyXUB7PDrHnT+wAUp1LW1y4koycMS6/0yNqaQeY0RbI0YzuJceVeNTMg92FtlNiQ==
X-Received: by 2002:a5d:658b:: with SMTP id q11mr154900wru.130.1559166179351;
        Wed, 29 May 2019 14:42:59 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id u19sm1421060wmu.41.2019.05.29.14.42.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:42:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 2/2] net: dsa: tag_8021q: Create a stable binary format
Date:   Thu, 30 May 2019 00:42:31 +0300
Message-Id: <20190529214231.10485-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529214231.10485-1-olteanv@gmail.com>
References: <20190529214231.10485-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

The MBZ bit didn't actually prevent the VID from taking the reserved
value of 0, so I replaced it with a two-bit DIR flag that really
accomplishes this purpose.
I also made the PORT field only 4 bits wide, with 2 bits for expansion
in the future.

 net/dsa/tag_8021q.c | 60 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4adec6bbfe59..65a35e976d7b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -11,20 +11,59 @@
 
 #include "dsa_priv.h"
 
-/* Allocating two VLAN tags per port - one for the RX VID and
- * the other for the TX VID - see below
+/* Binary structure of the fake 12-bit VID field (when the TPID is
+ * ETH_P_DSA_8021Q):
+ *
+ * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
+ * +-----------+-----+-----------------+-----------+-----------------------+
+ * |    DIR    | RSV |    SWITCH_ID    |    RSV    |          PORT         |
+ * +-----------+-----+-----------------+-----------+-----------------------+
+ *
+ * DIR - VID[11:10]:
+ *	Direction flags.
+ *	* 1 (0b01) for RX VLAN,
+ *	* 2 (0b10) for TX VLAN.
+ *	These values make the special VIDs of 0, 1 and 4095 to be left
+ *	unused by this coding scheme.
+ *
+ * RSV - VID[9]:
+ *	To be used for further expansion of SWITCH_ID or for other purposes.
+ *
+ * SWITCH_ID - VID[8:6]:
+ *	Index of switch within DSA tree. Must be between 0 and
+ *	DSA_MAX_SWITCHES - 1.
+ *
+ * RSV - VID[5:4]:
+ *	To be used for further expansion of PORT or for other purposes.
+ *
+ * PORT - VID[3:0]:
+ *	Index of switch port. Must be between 0 and DSA_MAX_PORTS - 1.
  */
-#define DSA_8021Q_VID_RANGE	(DSA_MAX_SWITCHES * DSA_MAX_PORTS)
-#define DSA_8021Q_VID_BASE	(VLAN_N_VID - 2 * DSA_8021Q_VID_RANGE - 1)
-#define DSA_8021Q_RX_VID_BASE	(DSA_8021Q_VID_BASE)
-#define DSA_8021Q_TX_VID_BASE	(DSA_8021Q_VID_BASE + DSA_8021Q_VID_RANGE)
+
+#define DSA_8021Q_DIR_SHIFT		10
+#define DSA_8021Q_DIR_MASK		GENMASK(11, 10)
+#define DSA_8021Q_DIR(x)		(((x) << DSA_8021Q_DIR_SHIFT) & \
+						 DSA_8021Q_DIR_MASK)
+#define DSA_8021Q_DIR_RX		DSA_8021Q_DIR(1)
+#define DSA_8021Q_DIR_TX		DSA_8021Q_DIR(2)
+
+#define DSA_8021Q_SWITCH_ID_SHIFT	6
+#define DSA_8021Q_SWITCH_ID_MASK	GENMASK(8, 6)
+#define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
+						 DSA_8021Q_SWITCH_ID_MASK)
+
+#define DSA_8021Q_PORT_SHIFT		0
+#define DSA_8021Q_PORT_MASK		GENMASK(3, 0)
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
 
@@ -33,21 +72,22 @@ EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
  */
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 {
-	return DSA_8021Q_RX_VID_BASE + (DSA_MAX_PORTS * ds->index) + port;
+	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
+	       DSA_8021Q_PORT(port);
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

