Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013E96386A4
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKYJt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiKYJsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:48:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0172A1F2E8;
        Fri, 25 Nov 2022 01:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369587; x=1700905587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M0OTgoWLHaKHX1P/U3k2lotowQtx4xagmFQ2PQc5T4Y=;
  b=S5Erw5PHLwcAmZCx319gamjbcFmzN5E9mhMuYdVYrI0LZaW8x18ztqrb
   sEghp+l2pje181R43squPUrWjwaKfKiip+vB9WwFo27PMkgnOkUzfv8E8
   iEA2f3CAR993pvoCjcKThNQQ/5lvY8e93jESAG4D7odl6bToujxP0DUPd
   z9GzyuJbLxK0Y6ANV3pFw42h43GRETm+Aapg/dQBu+hMI/OLeV7IldNUQ
   bSpq5sHnNmzM0pmshEK2bGn3Z7WDXuGf8dv1HVo4aAvlyTOdAaOGvMOCR
   wVFmDCmPqLBnhP5lDKDQFoC29oaooDsmKJGiYfLP02hxV0fu6kKLu58HK
   w==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="201371059"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:24 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 8/9] net: lan966x: Add port keyset config and callback interface
Date:   Fri, 25 Nov 2022 10:50:09 +0100
Message-ID: <20221125095010.124458-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement vcap_operations and enable default port keyset configuration
for each port. Now it is possible actually write/read/move entries in
the VCAP.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_vcap_impl.c     | 366 ++++++++++++++++++
 1 file changed, 366 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 08253dd4a306f..44f40d9149470 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -13,6 +13,13 @@
 
 #define LAN966X_IS2_LOOKUPS 2
 
+enum vcap_is2_port_sel_ipv6 {
+	VCAP_IS2_PS_IPV6_TCPUDP_OTHER,
+	VCAP_IS2_PS_IPV6_STD,
+	VCAP_IS2_PS_IPV6_IP4_TCPUDP_IP4_OTHER,
+	VCAP_IS2_PS_IPV6_MAC_ETYPE,
+};
+
 static struct lan966x_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int tgt_inst; /* hardware instance number */
@@ -73,6 +80,347 @@ static void __lan966x_vcap_range_init(struct lan966x *lan966x,
 	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
 }
 
+static int lan966x_vcap_cid_to_lookup(int cid)
+{
+	if (cid >= LAN966X_VCAP_CID_IS2_L1 &&
+	    cid < LAN966X_VCAP_CID_IS2_MAX)
+		return 1;
+
+	return 0;
+}
+
+static int
+lan966x_vcap_is2_get_port_keysets(struct net_device *dev, int lookup,
+				  struct vcap_keyset_list *keysetlist,
+				  u16 l3_proto)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	bool found = false;
+	u32 val;
+
+	/* Check if the port keyset selection is enabled */
+	val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
+	if (!ANA_VCAP_S2_CFG_ENA_GET(val))
+		return -ENOENT;
+
+	/* Collect all keysets for the port in a list */
+	if (l3_proto == ETH_P_ALL)
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_SNAP) {
+		if (ANA_VCAP_S2_CFG_SNAP_DIS_GET(val) & (BIT(0) << lookup))
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_LLC);
+		else
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_SNAP);
+
+		found = true;
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_CFM) {
+		if (ANA_VCAP_S2_CFG_OAM_DIS_GET(val) & (BIT(0) << lookup))
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+		else
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_OAM);
+
+		found = true;
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_ARP) {
+		if (ANA_VCAP_S2_CFG_ARP_DIS_GET(val) & (BIT(0) << lookup))
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+		else
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_ARP);
+
+		found = true;
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IP) {
+		if (ANA_VCAP_S2_CFG_IP_OTHER_DIS_GET(val) & (BIT(0) << lookup))
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+		else
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+
+		if (ANA_VCAP_S2_CFG_IP_TCPUDP_DIS_GET(val) & (BIT(0) << lookup))
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+		else
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+
+		found = true;
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IPV6) {
+		switch (ANA_VCAP_S2_CFG_IP6_CFG_GET(val) & (0x3 << lookup)) {
+		case VCAP_IS2_PS_IPV6_TCPUDP_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_OTHER);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_TCP_UDP);
+			break;
+		case VCAP_IS2_PS_IPV6_STD:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_STD);
+			break;
+		case VCAP_IS2_PS_IPV6_IP4_TCPUDP_IP4_OTHER:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+			break;
+		case VCAP_IS2_PS_IPV6_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		}
+
+		found = true;
+	}
+
+	if (!found)
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+
+	return 0;
+}
+
+static enum vcap_keyfield_set
+lan966x_vcap_validate_keyset(struct net_device *dev,
+			     struct vcap_admin *admin,
+			     struct vcap_rule *rule,
+			     struct vcap_keyset_list *kslist,
+			     u16 l3_proto)
+{
+	struct vcap_keyset_list keysetlist = {};
+	enum vcap_keyfield_set keysets[10] = {};
+	int lookup;
+	int err;
+
+	if (!kslist || kslist->cnt == 0)
+		return VCAP_KFS_NO_VALUE;
+
+	lookup = lan966x_vcap_cid_to_lookup(rule->vcap_chain_id);
+	keysetlist.max = ARRAY_SIZE(keysets);
+	keysetlist.keysets = keysets;
+	err = lan966x_vcap_is2_get_port_keysets(dev, lookup, &keysetlist,
+						l3_proto);
+	if (err)
+		return VCAP_KFS_NO_VALUE;
+
+	/* Check if there is a match and return the match */
+	for (int i = 0; i < kslist->cnt; ++i)
+		for (int j = 0; j < keysetlist.cnt; ++j)
+			if (kslist->keysets[i] == keysets[j])
+				return kslist->keysets[i];
+
+	return VCAP_KFS_NO_VALUE;
+}
+
+static bool lan966x_vcap_is_first_chain(struct vcap_rule *rule)
+{
+	return (rule->vcap_chain_id >= LAN966X_VCAP_CID_IS2_L0 &&
+		rule->vcap_chain_id < LAN966X_VCAP_CID_IS2_L1);
+}
+
+static void lan966x_vcap_add_default_fields(struct net_device *dev,
+					    struct vcap_admin *admin,
+					    struct vcap_rule *rule)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0,
+			      ~BIT(port->chip_port));
+
+	if (lan966x_vcap_is_first_chain(rule))
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_1);
+	else
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_0);
+}
+
+static void lan966x_vcap_cache_erase(struct vcap_admin *admin)
+{
+	memset(admin->cache.keystream, 0, STREAMSIZE);
+	memset(admin->cache.maskstream, 0, STREAMSIZE);
+	memset(admin->cache.actionstream, 0, STREAMSIZE);
+	memset(&admin->cache.counter, 0, sizeof(admin->cache.counter));
+}
+
+static void lan966x_vcap_cache_write(struct net_device *dev,
+				     struct vcap_admin *admin,
+				     enum vcap_selection sel,
+				     u32 start,
+				     u32 count)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	u32 *keystr, *mskstr, *actstr;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		for (int i = 0; i < count; ++i) {
+			lan_wr(keystr[i] & mskstr[i], lan966x,
+			       VCAP_ENTRY_DAT(admin->tgt_inst, i));
+			lan_wr(~mskstr[i], lan966x,
+			       VCAP_MASK_DAT(admin->tgt_inst, i));
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		for (int i = 0; i < count; ++i)
+			lan_wr(actstr[i], lan966x,
+			       VCAP_ACTION_DAT(admin->tgt_inst, i));
+		break;
+	case VCAP_SEL_COUNTER:
+		admin->cache.sticky = admin->cache.counter > 0;
+		lan_wr(admin->cache.counter, lan966x,
+		       VCAP_CNT_DAT(admin->tgt_inst, 0));
+		break;
+	default:
+		break;
+	}
+}
+
+static void lan966x_vcap_cache_read(struct net_device *dev,
+				    struct vcap_admin *admin,
+				    enum vcap_selection sel,
+				    u32 start,
+				    u32 count)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int instance = admin->tgt_inst;
+	u32 *keystr, *mskstr, *actstr;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	if (sel & VCAP_SEL_ENTRY) {
+		for (int i = 0; i < count; ++i) {
+			keystr[i] =
+				lan_rd(lan966x, VCAP_ENTRY_DAT(instance, i));
+			mskstr[i] =
+				~lan_rd(lan966x, VCAP_MASK_DAT(instance, i));
+		}
+	}
+
+	if (sel & VCAP_SEL_ACTION)
+		for (int i = 0; i < count; ++i)
+			actstr[i] =
+				lan_rd(lan966x, VCAP_ACTION_DAT(instance, i));
+
+	if (sel & VCAP_SEL_COUNTER) {
+		admin->cache.counter =
+			lan_rd(lan966x, VCAP_CNT_DAT(instance, 0));
+		admin->cache.sticky = admin->cache.counter > 0;
+	}
+}
+
+static void lan966x_vcap_range_init(struct net_device *dev,
+				    struct vcap_admin *admin,
+				    u32 addr,
+				    u32 count)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	__lan966x_vcap_range_init(lan966x, admin, addr, count);
+}
+
+static void lan966x_vcap_update(struct net_device *dev,
+				struct vcap_admin *admin,
+				enum vcap_command cmd,
+				enum vcap_selection sel,
+				u32 addr)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	bool clear;
+
+	clear = (cmd == VCAP_CMD_INITIALIZE);
+
+	lan_wr(VCAP_MV_CFG_MV_NUM_POS_SET(0) |
+	       VCAP_MV_CFG_MV_SIZE_SET(0),
+	       lan966x, VCAP_MV_CFG(admin->tgt_inst));
+
+	lan_wr(VCAP_UPDATE_CTRL_UPDATE_CMD_SET(cmd) |
+	       VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS_SET((VCAP_SEL_ENTRY & sel) == 0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS_SET((VCAP_SEL_ACTION & sel) == 0) |
+	       VCAP_UPDATE_CTRL_UPDATE_CNT_DIS_SET((VCAP_SEL_COUNTER & sel) == 0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ADDR_SET(addr) |
+	       VCAP_UPDATE_CTRL_CLEAR_CACHE_SET(clear) |
+	       VCAP_UPDATE_CTRL_UPDATE_SHOT,
+	       lan966x, VCAP_UPDATE_CTRL(admin->tgt_inst));
+
+	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
+}
+
+static void lan966x_vcap_move(struct net_device *dev,
+			      struct vcap_admin *admin,
+			      u32 addr, int offset, int count)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	enum vcap_command cmd;
+	u16 mv_num_pos;
+	u16 mv_size;
+
+	mv_size = count - 1;
+	if (offset > 0) {
+		mv_num_pos = offset - 1;
+		cmd = VCAP_CMD_MOVE_DOWN;
+	} else {
+		mv_num_pos = -offset - 1;
+		cmd = VCAP_CMD_MOVE_UP;
+	}
+
+	lan_wr(VCAP_MV_CFG_MV_NUM_POS_SET(mv_num_pos) |
+	       VCAP_MV_CFG_MV_SIZE_SET(mv_size),
+	       lan966x, VCAP_MV_CFG(admin->tgt_inst));
+
+	lan_wr(VCAP_UPDATE_CTRL_UPDATE_CMD_SET(cmd) |
+	       VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_CNT_DIS_SET(0) |
+	       VCAP_UPDATE_CTRL_UPDATE_ADDR_SET(addr) |
+	       VCAP_UPDATE_CTRL_CLEAR_CACHE_SET(false) |
+	       VCAP_UPDATE_CTRL_UPDATE_SHOT,
+	       lan966x, VCAP_UPDATE_CTRL(admin->tgt_inst));
+
+	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
+}
+
+static int lan966x_vcap_port_info(struct net_device *dev,
+				  struct vcap_admin *admin,
+				  struct vcap_output_print *out)
+{
+	return 0;
+}
+
+static int lan966x_vcap_enable(struct net_device *dev,
+			       struct vcap_admin *admin,
+			       bool enable)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_rmw(ANA_VCAP_S2_CFG_ENA_SET(enable),
+		ANA_VCAP_S2_CFG_ENA,
+		lan966x, ANA_VCAP_S2_CFG(port->chip_port));
+
+	return 0;
+}
+
+static struct vcap_operations lan966x_vcap_ops = {
+	.validate_keyset = lan966x_vcap_validate_keyset,
+	.add_default_fields = lan966x_vcap_add_default_fields,
+	.cache_erase = lan966x_vcap_cache_erase,
+	.cache_write = lan966x_vcap_cache_write,
+	.cache_read = lan966x_vcap_cache_read,
+	.init = lan966x_vcap_range_init,
+	.update = lan966x_vcap_update,
+	.move = lan966x_vcap_move,
+	.port_info = lan966x_vcap_port_info,
+	.enable = lan966x_vcap_enable,
+};
+
 static void lan966x_vcap_admin_free(struct vcap_admin *admin)
 {
 	if (!admin)
@@ -98,12 +446,19 @@ lan966x_vcap_admin_alloc(struct lan966x *lan966x, struct vcap_control *ctrl,
 	mutex_init(&admin->lock);
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
+	INIT_LIST_HEAD(&admin->enabled);
+
 	admin->vtype = cfg->vtype;
 	admin->vinst = 0;
+	admin->w32be = true;
+	admin->tgt_inst = cfg->tgt_inst;
+
 	admin->lookups = cfg->lookups;
 	admin->lookups_per_instance = cfg->lookups;
+
 	admin->first_cid = cfg->first_cid;
 	admin->last_cid = cfg->last_cid;
+
 	admin->cache.keystream = kzalloc(STREAMSIZE, GFP_KERNEL);
 	admin->cache.maskstream = kzalloc(STREAMSIZE, GFP_KERNEL);
 	admin->cache.actionstream = kzalloc(STREAMSIZE, GFP_KERNEL);
@@ -135,6 +490,13 @@ static void lan966x_vcap_block_init(struct lan966x *lan966x,
 					admin->first_valid_addr);
 }
 
+static void lan966x_vcap_port_key_deselection(struct lan966x *lan966x,
+					      struct vcap_admin *admin)
+{
+	for (int p = 0; p < lan966x->num_phys_ports; ++p)
+		lan_wr(0, lan966x, ANA_VCAP_S2_CFG(p));
+}
+
 int lan966x_vcap_init(struct lan966x *lan966x)
 {
 	struct lan966x_vcap_inst *cfg;
@@ -147,6 +509,7 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 
 	ctrl->vcaps = lan966x_vcaps;
 	ctrl->stats = &lan966x_vcap_stats;
+	ctrl->ops = &lan966x_vcap_ops;
 
 	INIT_LIST_HEAD(&ctrl->list);
 	for (int i = 0; i < ARRAY_SIZE(lan966x_vcap_inst_cfg); ++i) {
@@ -157,6 +520,8 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 			return PTR_ERR(admin);
 
 		lan966x_vcap_block_init(lan966x, admin, cfg);
+		lan966x_vcap_port_key_deselection(lan966x, admin);
+
 		list_add_tail(&admin->list, &ctrl->list);
 	}
 
@@ -175,6 +540,7 @@ void lan966x_vcap_deinit(struct lan966x *lan966x)
 		return;
 
 	list_for_each_entry_safe(admin, admin_next, &ctrl->list, list) {
+		lan966x_vcap_port_key_deselection(lan966x, admin);
 		vcap_del_rules(ctrl, admin);
 		list_del(&admin->list);
 		lan966x_vcap_admin_free(admin);
-- 
2.38.0

