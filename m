Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FFC1CFC07
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgELRVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbgELRU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF2C061A0F;
        Tue, 12 May 2020 10:20:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m12so17857832wmc.0;
        Tue, 12 May 2020 10:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hu1jVgvcMgblKlkm2NcOqo/+JvlzJVPAmJphw7Npbp4=;
        b=mfI7hRAUU6JcgRSNfuov+frHsHsC5R77uMXN7AvlrSDxXqtCVZz+2aiyvBqS8o+Mil
         wj4FtajLVrwLv7S+vOO2ollOYiWKf9XhG4GBW/KcEsg80H90/fFvUfQjbRSpkmSDe5s9
         Mk+8WpYCszn16aj5qcD5S6i13Yim9ZQTdFH5clED7I4M7c94+kuXSZsek6AsUptITPNa
         6YpKM7Gf3086TP10+6HK4xQRAZuE2vI9Nd9nncjtvW2L7vLxPP4QHQy6A35E5+3Z2rNA
         DVQ7TDFZ99dybJ+451MYnKKYsHDqO1+0wcCOeB4S5VMCOz1V2Q0D8YJX2Pg4343rdi+3
         JSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hu1jVgvcMgblKlkm2NcOqo/+JvlzJVPAmJphw7Npbp4=;
        b=rw717Rh/PfnPUd+ytVndOVIjMcPB5+Lgporf+pWJu03yh5plxr4DLqHWvnFIxRqig7
         HPNMocRsoeX3LiUjwqaRt+UYUJliDPwXVDWSaOMS3IRzIRAKRRIb+/O4O4mq6mCpOIbe
         ZikjaVdHFvFxNltxUbGljzXIfk5WRcbQCWKwOeC/4ylb5pckehr16N96+95QhjEWGPMY
         B/a0Eb+qVSzyPhCBgPa3u48Pi3Rwww5/KGzPt3hKri0nZapZTYIO/VaV8l1+VUqHaQW7
         O8UiQLjWn1WjZpHo4xlgGv4A7gV18mNIFQlY1oJAdDHn9ysrAchFtSpsy1BAv1ZGt7wz
         fpxA==
X-Gm-Message-State: AGi0PuYNVmCxBeOhJXAaUWFrMnb1fiEIR835LkspN47M7KfQkCjL8uKw
        Sfb+usB/WhiMdt3enIIIsg4=
X-Google-Smtp-Source: APiQypIlE1RDIJoI8Av/ke38zDbsEOFcsP9s0Lf+57w80KCatEKGiuwUBhyLuMrpPvHBRhRrsnZ4eA==
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr22692601wmi.110.1589304054615;
        Tue, 12 May 2020 10:20:54 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 09/15] net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs
Date:   Tue, 12 May 2020 20:20:33 +0300
Message-Id: <20200512172039.14136-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For switches that support VLAN retagging, such as sja1105, we extend
dsa_8021q by encoding a "sub-VLAN" into the remaining 3 free bits in the
dsa_8021q tag.

A sub-VLAN is nothing more than a number in the range 0-7, which serves
as an index into a per-port driver lookup table. The sub-VLAN value of
zero means that traffic is untagged (this is also backwards-compatible
with dsa_8021q without retagging).

The switch should be configured to retag VLAN-tagged traffic that gets
transmitted towards the CPU port (and towards the CPU only). Example:

bridge vlan add dev sw1p0 vid 100

The switch retags frames received on port 0, going to the CPU, and
having VID 100, to the VID of 1104 (0x0450). In dsa_8021q language:

 | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
 +-----------+-----+-----------------+-----------+-----------------------+
 |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
 +-----------+-----+-----------------+-----------+-----------------------+

0x0450 means:
 - DIR = 0b01: this is an RX VLAN
 - SUBVLAN = 0b001: this is subvlan #1
 - SWITCH_ID = 0b001: this is switch 1 (see the name "sw1p0")
 - PORT = 0b0000: this is port 0 (see the name "sw1p0")

The driver also remembers the "1 -> 100" mapping. In the hotpath, if the
sub-VLAN from the tag encodes a non-untagged frame, this mapping is used
to create a VLAN hwaccel tag, with the value of 100.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 include/linux/dsa/8021q.h | 16 +++++++++++
 net/dsa/tag_8021q.c       | 56 +++++++++++++++++++++++++++++++++------
 2 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 404bd2cce642..311aa04e7520 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -20,6 +20,8 @@ struct dsa_8021q_crosschip_link {
 	refcount_t refcount;
 };
 
+#define DSA_8021Q_N_SUBVLAN			8
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -42,10 +44,14 @@ u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan);
+
 int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
+u16 dsa_8021q_rx_subvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -88,6 +94,11 @@ u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 	return 0;
 }
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
+{
+	return 0;
+}
+
 int dsa_8021q_rx_switch_id(u16 vid)
 {
 	return 0;
@@ -98,6 +109,11 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
+u16 dsa_8021q_rx_subvlan(u16 vid)
+{
+	return 0;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3236fbbf85b9..3052da668156 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -17,7 +17,7 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | RSV |    SWITCH_ID    |    RSV    |          PORT         |
+ * |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
  * DIR - VID[11:10]:
@@ -27,17 +27,24 @@
  *	These values make the special VIDs of 0, 1 and 4095 to be left
  *	unused by this coding scheme.
  *
- * RSV - VID[9]:
- *	To be used for further expansion of SWITCH_ID or for other purposes.
- *	Must be transmitted as zero and ignored on receive.
+ * SVL/SUBVLAN - { VID[9], VID[5:4] }:
+ *	Sub-VLAN encoding. Valid only when DIR indicates an RX VLAN.
+ *	* 0 (0b000): Field does not encode a sub-VLAN, either because
+ *	received traffic is untagged, PVID-tagged or because a second
+ *	VLAN tag is present after this tag and not inside of it.
+ *	* 1 (0b001): Received traffic is tagged with a VID value private
+ *	to the host. This field encodes the index in the host's lookup
+ *	table through which the value of the ingress VLAN ID can be
+ *	recovered.
+ *	* 2 (0b010): Field encodes a sub-VLAN.
+ *	...
+ *	* 7 (0b111): Field encodes a sub-VLAN.
+ *	When DIR indicates a TX VLAN, SUBVLAN must be transmitted as zero
+ *	(by the host) and ignored on receive (by the switch).
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
  *
- * RSV - VID[5:4]:
- *	To be used for further expansion of PORT or for other purposes.
- *	Must be transmitted as zero and ignored on receive.
- *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and 15.
  */
@@ -54,6 +61,18 @@
 #define DSA_8021Q_SWITCH_ID(x)		(((x) << DSA_8021Q_SWITCH_ID_SHIFT) & \
 						 DSA_8021Q_SWITCH_ID_MASK)
 
+#define DSA_8021Q_SUBVLAN_HI_SHIFT	9
+#define DSA_8021Q_SUBVLAN_HI_MASK	GENMASK(9, 9)
+#define DSA_8021Q_SUBVLAN_LO_SHIFT	4
+#define DSA_8021Q_SUBVLAN_LO_MASK	GENMASK(4, 3)
+#define DSA_8021Q_SUBVLAN_HI(x)		(((x) & GENMASK(2, 2)) >> 2)
+#define DSA_8021Q_SUBVLAN_LO(x)		((x) & GENMASK(1, 0))
+#define DSA_8021Q_SUBVLAN(x)		\
+		(((DSA_8021Q_SUBVLAN_LO(x) << DSA_8021Q_SUBVLAN_LO_SHIFT) & \
+		  DSA_8021Q_SUBVLAN_LO_MASK) | \
+		 ((DSA_8021Q_SUBVLAN_HI(x) << DSA_8021Q_SUBVLAN_HI_SHIFT) & \
+		  DSA_8021Q_SUBVLAN_HI_MASK))
+
 #define DSA_8021Q_PORT_SHIFT		0
 #define DSA_8021Q_PORT_MASK		GENMASK(3, 0)
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
@@ -79,6 +98,13 @@ u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
 
+u16 dsa_8021q_rx_vid_subvlan(struct dsa_switch *ds, int port, u16 subvlan)
+{
+	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
+	       DSA_8021Q_PORT(port) | DSA_8021Q_SUBVLAN(subvlan);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid_subvlan);
+
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
 {
@@ -93,6 +119,20 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+/* Returns the decoded subvlan from the RX VID. */
+u16 dsa_8021q_rx_subvlan(u16 vid)
+{
+	u16 svl_hi, svl_lo;
+
+	svl_hi = (vid & DSA_8021Q_SUBVLAN_HI_MASK) >>
+		 DSA_8021Q_SUBVLAN_HI_SHIFT;
+	svl_lo = (vid & DSA_8021Q_SUBVLAN_LO_MASK) >>
+		 DSA_8021Q_SUBVLAN_LO_SHIFT;
+
+	return (svl_hi << 2) | svl_lo;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-- 
2.17.1

