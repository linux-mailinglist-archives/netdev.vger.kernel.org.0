Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CBD51A3E6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbiEDPZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352581AbiEDPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:25:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D2D44770;
        Wed,  4 May 2022 08:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651677703; x=1683213703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVc/+HNOqS4/r7m8XfOVVRZ+wIWothref+39qtK2eSk=;
  b=iKx2b8lx0/rW9PvVicb0of6+D4CsLHI//Ff6HrHxXUjqP8o3GSUjLGBk
   8ImH7glpoU7HRlfM27nCgKgtdL3x/qUC06Fk5jgfONEPfezu4NnueeAE7
   IiQwweCT4ufaOmKW+LE8utLDgkXUpWLoI0XEO6BZY596V/tLeH5nLHfsQ
   m6wp//PKAK95XAZIai3qBGj6aWn+6kQByNlClZff9H/yV6ZKxzAKHm8EM
   zhHpSjpe/CKEcHB9rsrKAJf6Hgp1fpNax2e7I7y8mZlp9G5Cn6y7G1+6D
   1pF2pWWVLgl818z+vbGvwEVA81i1CnS2AxQIeAl4jnssLSrnumXE3uNWw
   g==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="94541553"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:21:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:21:41 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:21:29 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [Patch net-next v13 13/13] net: dsa: microchip: add support for vlan operations
Date:   Wed, 4 May 2022 20:47:55 +0530
Message-ID: <20220504151755.11737-14-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220504151755.11737-1-arun.ramadoss@microchip.com>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Support for VLAN add, del, prepare and filtering operations.

The VLAN aware is a global setting. Mixed vlan filterings
are not supported. vlan_filtering_is_global is made as true
in lan937x_setup function.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_dev.h  |  10 ++
 drivers/net/dsa/microchip/lan937x_main.c | 186 +++++++++++++++++++++++
 2 files changed, 196 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index da8c708a03ea..2ce4d60b477e 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -104,6 +104,16 @@ struct lan_alu_struct {
 	u8	mac[ETH_ALEN];
 };
 
+struct lan937x_vlan {
+	/* entry 1 */
+	bool valid;
+	u8 fid;
+	/* entry 2 */
+	u32 untag_prtmap;
+	/* entry 3 */
+	u32 fwd_map;
+};
+
 extern const struct dsa_switch_ops lan937x_switch_ops;
 extern const struct ksz_dev_ops lan937x_dev_ops;
 extern const struct mib_names lan937x_mib_names[];
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 516ab563721d..a509f0fc6347 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -17,6 +17,14 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+static int lan937x_wait_vlan_ctrl_ready(struct ksz_device *dev)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL, val,
+					!(val & VLAN_START), 10, 1000);
+}
+
 static u8 lan937x_get_fid(u16 vid)
 {
 	if (vid > ALU_FID_SIZE)
@@ -25,6 +33,97 @@ static u8 lan937x_get_fid(u16 vid)
 		return vid;
 }
 
+static int lan937x_get_vlan_table(struct ksz_device *dev, u16 vid,
+				  struct lan937x_vlan *vlan_entry)
+{
+	u32 data;
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &data);
+	if (ret < 0)
+		goto exit;
+
+	vlan_entry->valid = !!(data & VLAN_VALID);
+	vlan_entry->fid	= data & VLAN_FID_M;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
+			 &vlan_entry->untag_prtmap);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4,
+			 &vlan_entry->fwd_map);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
+static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
+				  struct lan937x_vlan *vlan_entry)
+{
+	u32 data;
+	int ret;
+
+	mutex_lock(&dev->vlan_mutex);
+
+	data = vlan_entry->valid ? VLAN_VALID : 0;
+	data |= vlan_entry->fid;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, data);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
+			  vlan_entry->untag_prtmap);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_entry->fwd_map);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
+	if (ret < 0)
+		goto exit;
+
+	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
+	if (ret < 0)
+		goto exit;
+
+	/* wait to be cleared */
+	ret = lan937x_wait_vlan_ctrl_ready(dev);
+	if (ret < 0)
+		goto exit;
+
+exit:
+	mutex_unlock(&dev->vlan_mutex);
+
+	return ret;
+}
+
 static int lan937x_read_table(struct ksz_device *dev, u32 *table)
 {
 	int ret;
@@ -129,6 +228,90 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
 }
 
+static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
+				       bool flag,
+				       struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* enable/disable VLAN mode, once enabled, look up process starts
+	 * and then forwarding and discarding are done based on port
+	 * membership of the VLAN table
+	 */
+	return lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, flag);
+}
+
+static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct ksz_device *dev = ds->priv;
+	struct lan937x_vlan vlan_entry;
+	int ret;
+
+	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
+		return ret;
+	}
+
+	vlan_entry.fid = lan937x_get_fid(vlan->vid);
+	vlan_entry.valid = true;
+
+	/* set/clear switch port when updating vlan table registers */
+	if (untagged)
+		vlan_entry.untag_prtmap |= BIT(port);
+	else
+		vlan_entry.untag_prtmap &= ~BIT(port);
+
+	vlan_entry.fwd_map |= BIT(port);
+
+	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table");
+		return ret;
+	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
+				       vlan->vid);
+		if (ret < 0) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ksz_device *dev = ds->priv;
+	struct lan937x_vlan vlan_entry;
+	int ret;
+
+	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to get vlan table\n");
+		return ret;
+	}
+
+	/* clear port fwd map & untag entries*/
+	vlan_entry.fwd_map &= ~BIT(port);
+	vlan_entry.untag_prtmap &= ~BIT(port);
+
+	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to set vlan table\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
 				struct dsa_db db)
@@ -1030,6 +1213,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_vlan_filtering = lan937x_port_vlan_filtering,
+	.port_vlan_add = lan937x_port_vlan_add,
+	.port_vlan_del = lan937x_port_vlan_del,
 	.port_fdb_dump = lan937x_port_fdb_dump,
 	.port_fdb_add = lan937x_port_fdb_add,
 	.port_fdb_del = lan937x_port_fdb_del,
-- 
2.33.0

