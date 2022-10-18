Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAB602A3B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJRLc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJRLcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:32:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DB9BA26B;
        Tue, 18 Oct 2022 04:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666092756; x=1697628756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dHUj3y0Yl71+PXURB5h+sQBL/PglzB1GuFn3hCaCRtk=;
  b=0hGZtsxeMZv+XSo0KAKpqDjEBWw8A7oAwZYf+gZ0Eng8p8socifIS+kA
   t2cCt3x+8JeR3yrH8MzUeRLaGlNeWYRHJ6OxjmYbJ8OoeicBspeLZZEQ2
   VXX0Ou/qvrymEjiuq9t55yHg48eSyWT9nEtEggPOrr/twZf+zOx5dI/XQ
   D8VESLqhuIBhJR8swwDBealf4CwD2SW6PaTJDba9rQ7hYc7w2NXHnvuUG
   pmwyo0lxJUMRd5rziaslhf/hbrKSvNLPYpMVCEFDMn/fKUVJ9mTMBKpoq
   XodNi7tJ4G55/k0CABj9YchWWwvxNuVtEWOioYvonmZ4jlLj34/YK+CLt
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="179327385"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2022 04:32:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 18 Oct 2022 04:32:27 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 18 Oct 2022 04:32:25 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 5/9] net: microchip: sparx5: Adding port keyset config and callback interface
Date:   Tue, 18 Oct 2022 13:31:52 +0200
Message-ID: <20221018113156.2364533-6-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221018113156.2364533-1-steen.hegelund@microchip.com>
References: <20221018113156.2364533-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides a default port keyset configuration for the Sparx5 IS2 VCAP
where all ports and all lookups in IS2 use the same keyset (MAC_ETYPE) for
all types of traffic.

This means that no matter what frame type is received on any front port it
will generate the MAC_ETYPE keyset in the IS VCAP and any rule in the IS2
VCAP that uses this keyset will be matched against the keys in the
MAC_ETYPE keyset.

The callback interface used by the VCAP API is populated with Sparx5
specific handler functions that takes care of the actual reading and
writing to data to the Sparx5 IS2 VCAP instance.

A few functions are also added to the VCAP API to support addition of rule
fields such as the ingress port mask and the lookup bit.

The IS2 VCAP in Sparx5 is really divided in two instances with lookup 0
and 1 in the first instance and lookup 2 and 3 in the second instance.
The lookup bit selects lookup 0 or 3 in the respective instance when it is
set.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       | 345 ++++++++++++++++++
 .../net/ethernet/microchip/vcap/vcap_api.c    |  81 ++++
 .../ethernet/microchip/vcap/vcap_api_client.h |   5 +
 3 files changed, 431 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 5ec005e636aa..dbd2c2c4d346 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -22,6 +22,54 @@
 
 #define SPARX5_IS2_LOOKUPS 4
 
+/* IS2 port keyset selection control */
+
+/* IS2 non-ethernet traffic type keyset generation */
+enum vcap_is2_port_sel_noneth {
+	VCAP_IS2_PS_NONETH_MAC_ETYPE,
+	VCAP_IS2_PS_NONETH_CUSTOM_1,
+	VCAP_IS2_PS_NONETH_CUSTOM_2,
+	VCAP_IS2_PS_NONETH_NO_LOOKUP
+};
+
+/* IS2 IPv4 unicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv4_uc {
+	VCAP_IS2_PS_IPV4_UC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
+	VCAP_IS2_PS_IPV4_UC_IP_7TUPLE,
+};
+
+/* IS2 IPv4 multicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv4_mc {
+	VCAP_IS2_PS_IPV4_MC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER,
+	VCAP_IS2_PS_IPV4_MC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV4_MC_IP4_VID,
+};
+
+/* IS2 IPv6 unicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv6_uc {
+	VCAP_IS2_PS_IPV6_UC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV6_UC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV6_UC_IP6_STD,
+	VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER,
+};
+
+/* IS2 IPv6 multicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv6_mc {
+	VCAP_IS2_PS_IPV6_MC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV6_MC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV6_MC_IP6_VID,
+	VCAP_IS2_PS_IPV6_MC_IP6_STD,
+	VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER,
+};
+
+/* IS2 ARP traffic type keyset generation */
+enum vcap_is2_port_sel_arp {
+	VCAP_IS2_PS_ARP_MAC_ETYPE,
+	VCAP_IS2_PS_ARP_ARP,
+};
+
 static struct sparx5_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int vinst; /* instance number within the same type */
@@ -58,6 +106,296 @@ static struct sparx5_vcap_inst {
 	},
 };
 
+/* Await the super VCAP completion of the current operation */
+static void sparx5_vcap_wait_super_update(struct sparx5 *sparx5)
+{
+	u32 value;
+
+	read_poll_timeout(spx5_rd, value,
+			  !VCAP_SUPER_CTRL_UPDATE_SHOT_GET(value), 500, 10000,
+			  false, sparx5, VCAP_SUPER_CTRL);
+}
+
+/* Initializing a VCAP address range: only IS2 for now */
+static void _sparx5_vcap_range_init(struct sparx5 *sparx5,
+				    struct vcap_admin *admin,
+				    u32 addr, u32 count)
+{
+	u32 size = count - 1;
+
+	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(0) |
+		VCAP_SUPER_CFG_MV_SIZE_SET(size),
+		sparx5, VCAP_SUPER_CFG);
+	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
+		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(true) |
+		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_SUPER_CTRL);
+	sparx5_vcap_wait_super_update(sparx5);
+}
+
+/* Initializing VCAP rule data area */
+static void sparx5_vcap_block_init(struct sparx5 *sparx5,
+				   struct vcap_admin *admin)
+{
+	_sparx5_vcap_range_init(sparx5, admin, admin->first_valid_addr,
+				admin->last_valid_addr -
+					admin->first_valid_addr);
+}
+
+/* Get the keyset name from the sparx5 VCAP model */
+static const char *sparx5_vcap_keyset_name(struct net_device *ndev,
+					   enum vcap_keyfield_set keyset)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return port->sparx5->vcap_ctrl->stats->keyfield_set_names[keyset];
+}
+
+/* Check if this is the first lookup of IS2 */
+static bool sparx5_vcap_is2_is_first_chain(struct vcap_rule *rule)
+{
+	return (rule->vcap_chain_id >= SPARX5_VCAP_CID_IS2_L0 &&
+		rule->vcap_chain_id < SPARX5_VCAP_CID_IS2_L1) ||
+		((rule->vcap_chain_id >= SPARX5_VCAP_CID_IS2_L2 &&
+		  rule->vcap_chain_id < SPARX5_VCAP_CID_IS2_L3));
+}
+
+/* Set the narrow range ingress port mask on a rule */
+static void sparx5_vcap_add_range_port_mask(struct vcap_rule *rule,
+					    struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	u32 port_mask;
+	u32 range;
+
+	range = port->portno / BITS_PER_TYPE(u32);
+	/* Port bit set to match-any */
+	port_mask = ~BIT(port->portno % BITS_PER_TYPE(u32));
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK_SEL, 0, 0xf);
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK_RNG, range, 0xf);
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0, port_mask);
+}
+
+/* Set the wide range ingress port mask on a rule */
+static void sparx5_vcap_add_wide_port_mask(struct vcap_rule *rule,
+					   struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct vcap_u72_key port_mask;
+	u32 range;
+
+	/* Port bit set to match-any */
+	memset(port_mask.value, 0, sizeof(port_mask.value));
+	memset(port_mask.mask, 0xff, sizeof(port_mask.mask));
+	range = port->portno / BITS_PER_BYTE;
+	port_mask.mask[range] = ~BIT(port->portno % BITS_PER_BYTE);
+	vcap_rule_add_key_u72(rule, VCAP_KF_IF_IGR_PORT_MASK, &port_mask);
+}
+
+/* API callback used for validating a field keyset (check the port keysets) */
+static enum vcap_keyfield_set
+sparx5_vcap_validate_keyset(struct net_device *ndev,
+			    struct vcap_admin *admin,
+			    struct vcap_rule *rule,
+			    struct vcap_keyset_list *kslist,
+			    u16 l3_proto)
+{
+	if (!kslist || kslist->cnt == 0)
+		return VCAP_KFS_NO_VALUE;
+	/* for now just return whatever the API suggests */
+	return kslist->keysets[0];
+}
+
+/* API callback used for adding default fields to a rule */
+static void sparx5_vcap_add_default_fields(struct net_device *ndev,
+					   struct vcap_admin *admin,
+					   struct vcap_rule *rule)
+{
+	const struct vcap_field *field;
+
+	field = vcap_lookup_keyfield(rule, VCAP_KF_IF_IGR_PORT_MASK);
+	if (field && field->width == SPX5_PORTS)
+		sparx5_vcap_add_wide_port_mask(rule, ndev);
+	else if (field && field->width == BITS_PER_TYPE(u32))
+		sparx5_vcap_add_range_port_mask(rule, ndev);
+	else
+		pr_err("%s:%d: %s: could not add an ingress port mask for: %s\n",
+		       __func__, __LINE__, netdev_name(ndev),
+		       sparx5_vcap_keyset_name(ndev, rule->keyset));
+	/* add the lookup bit */
+	if (sparx5_vcap_is2_is_first_chain(rule))
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
+	else
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_0);
+}
+
+/* API callback used for erasing the vcap cache area (not the register area) */
+static void sparx5_vcap_cache_erase(struct vcap_admin *admin)
+{
+	memset(admin->cache.keystream, 0, STREAMSIZE);
+	memset(admin->cache.maskstream, 0, STREAMSIZE);
+	memset(admin->cache.actionstream, 0, STREAMSIZE);
+	memset(&admin->cache.counter, 0, sizeof(admin->cache.counter));
+}
+
+/* API callback used for writing to the VCAP cache */
+static void sparx5_vcap_cache_write(struct net_device *ndev,
+				    struct vcap_admin *admin,
+				    enum vcap_selection sel,
+				    u32 start,
+				    u32 count)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		for (idx = 0; idx < count; ++idx) {
+			/* Avoid 'match-off' by setting value & mask */
+			spx5_wr(keystr[idx] & mskstr[idx], sparx5,
+				VCAP_SUPER_VCAP_ENTRY_DAT(idx));
+			spx5_wr(~mskstr[idx], sparx5,
+				VCAP_SUPER_VCAP_MASK_DAT(idx));
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		for (idx = 0; idx < count; ++idx)
+			spx5_wr(actstr[idx], sparx5,
+				VCAP_SUPER_VCAP_ACTION_DAT(idx));
+		break;
+	case VCAP_SEL_ALL:
+		pr_err("%s:%d: cannot write all streams at once\n",
+		       __func__, __LINE__);
+		break;
+	default:
+		break;
+	}
+}
+
+/* API callback used for reading from the VCAP into the VCAP cache */
+static void sparx5_vcap_cache_read(struct net_device *ndev,
+				   struct vcap_admin *admin,
+				   enum vcap_selection sel, u32 start,
+				   u32 count)
+{
+	/* this will be added later */
+}
+
+/* API callback used for initializing a VCAP address range */
+static void sparx5_vcap_range_init(struct net_device *ndev,
+				   struct vcap_admin *admin, u32 addr,
+				   u32 count)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	_sparx5_vcap_range_init(sparx5, admin, addr, count);
+}
+
+/* API callback used for updating the VCAP cache */
+static void sparx5_vcap_update(struct net_device *ndev,
+			       struct vcap_admin *admin, enum vcap_command cmd,
+			       enum vcap_selection sel, u32 addr)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	bool clear;
+
+	clear = (cmd == VCAP_CMD_INITIALIZE);
+	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(0) |
+		VCAP_SUPER_CFG_MV_SIZE_SET(0), sparx5, VCAP_SUPER_CFG);
+	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET((VCAP_SEL_ENTRY & sel) == 0) |
+		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET((VCAP_SEL_ACTION & sel) == 0) |
+		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET((VCAP_SEL_COUNTER & sel) == 0) |
+		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(clear) |
+		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_SUPER_CTRL);
+	sparx5_vcap_wait_super_update(sparx5);
+}
+
+/* API callback used for moving a block of rules in the VCAP */
+static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
+			     u32 addr, int offset, int count)
+{
+	/* this will be added later */
+}
+
+/* Provide port information via a callback interface */
+static int sparx5_port_info(struct net_device *ndev, enum vcap_type vtype,
+			    int (*pf)(void *out, int arg, const char *fmt, ...),
+			    void *out, int arg)
+{
+	/* this will be added later */
+	return 0;
+}
+
+/* API callback operations: only IS2 is supported for now */
+static struct vcap_operations sparx5_vcap_ops = {
+	.validate_keyset = sparx5_vcap_validate_keyset,
+	.add_default_fields = sparx5_vcap_add_default_fields,
+	.cache_erase = sparx5_vcap_cache_erase,
+	.cache_write = sparx5_vcap_cache_write,
+	.cache_read = sparx5_vcap_cache_read,
+	.init = sparx5_vcap_range_init,
+	.update = sparx5_vcap_update,
+	.move = sparx5_vcap_move,
+	.port_info = sparx5_port_info,
+};
+
+/* Enable lookups per port and set the keyset generation: only IS2 for now */
+static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
+					   struct vcap_admin *admin)
+{
+	int portno, lookup;
+	u32 keysel;
+
+	/* enable all 4 lookups on all ports */
+	for (portno = 0; portno < SPX5_PORTS; ++portno)
+		spx5_wr(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0xf), sparx5,
+			ANA_ACL_VCAP_S2_CFG(portno));
+
+	/* all traffic types generate the MAC_ETYPE keyset for now in all
+	 * lookups on all ports
+	 */
+	keysel = ANA_ACL_VCAP_S2_KEY_SEL_KEY_SEL_ENA_SET(true) |
+		ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_SET(VCAP_IS2_PS_NONETH_MAC_ETYPE) |
+		ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_SET(VCAP_IS2_PS_IPV4_MC_MAC_ETYPE) |
+		ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_SET(VCAP_IS2_PS_IPV4_UC_MAC_ETYPE) |
+		ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_SET(VCAP_IS2_PS_IPV6_MC_MAC_ETYPE) |
+		ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(VCAP_IS2_PS_IPV6_UC_MAC_ETYPE) |
+		ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(VCAP_IS2_PS_ARP_MAC_ETYPE);
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		for (portno = 0; portno < SPX5_PORTS; ++portno) {
+			spx5_wr(keysel, sparx5,
+				ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		}
+	}
+}
+
+/* Disable lookups per port and set the keyset generation: only IS2 for now */
+static void sparx5_vcap_port_key_deselection(struct sparx5 *sparx5,
+					     struct vcap_admin *admin)
+{
+	int portno;
+
+	for (portno = 0; portno < SPX5_PORTS; ++portno)
+		spx5_rmw(ANA_ACL_VCAP_S2_CFG_SEC_ENA_SET(0),
+			 ANA_ACL_VCAP_S2_CFG_SEC_ENA,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_CFG(portno));
+}
+
 static void sparx5_vcap_admin_free(struct vcap_admin *admin)
 {
 	if (!admin)
@@ -138,6 +476,7 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 	 *   - Lists of rules
 	 *   - Address information
 	 *   - Initialize VCAP blocks
+	 *   - Configure port keysets
 	 */
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
@@ -147,6 +486,8 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 	/* select the sparx5 VCAP model */
 	ctrl->vcaps = sparx5_vcaps;
 	ctrl->stats = &sparx5_vcap_stats;
+	/* Setup callbacks to allow the API to use the VCAP HW */
+	ctrl->ops = &sparx5_vcap_ops;
 
 	INIT_LIST_HEAD(&ctrl->list);
 	for (idx = 0; idx < ARRAY_SIZE(sparx5_vcap_inst_cfg); ++idx) {
@@ -159,6 +500,9 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 			return err;
 		}
 		sparx5_vcap_block_alloc(sparx5, admin, cfg);
+		sparx5_vcap_block_init(sparx5, admin);
+		if (cfg->vinst == 0)
+			sparx5_vcap_port_key_selection(sparx5, admin);
 		list_add_tail(&admin->list, &ctrl->list);
 	}
 
@@ -174,6 +518,7 @@ void sparx5_vcap_destroy(struct sparx5 *sparx5)
 		return;
 
 	list_for_each_entry_safe(admin, admin_next, &ctrl->list, list) {
+		sparx5_vcap_port_key_deselection(sparx5, admin);
 		list_del(&admin->list);
 		sparx5_vcap_admin_free(admin);
 	}
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index aa6b451d79a6..d929d2d00b6c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -21,6 +21,17 @@ struct vcap_rule_internal {
 	u32 addr; /* address in the VCAP at insertion */
 };
 
+/* Return the list of keyfields for the keyset */
+static const struct vcap_field *vcap_keyfields(struct vcap_control *vctrl,
+					       enum vcap_type vt,
+					       enum vcap_keyfield_set keyset)
+{
+	/* Check that the keyset exists in the vcap keyset list */
+	if (keyset >= vctrl->vcaps[vt].keyfield_set_size)
+		return NULL;
+	return vctrl->vcaps[vt].keyfield_set_map[keyset];
+}
+
 /* Update the keyset for the rule */
 int vcap_set_rule_set_keyset(struct vcap_rule *rule,
 			     enum vcap_keyfield_set keyset)
@@ -227,6 +238,24 @@ int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id)
 }
 EXPORT_SYMBOL_GPL(vcap_del_rule);
 
+/* Find information on a key field in a rule */
+const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
+					      enum vcap_key_field key)
+{
+	struct vcap_rule_internal *ri = (struct vcap_rule_internal *)rule;
+	enum vcap_keyfield_set keyset = rule->keyset;
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_field *fields;
+
+	if (keyset == VCAP_KFS_NO_VALUE)
+		return NULL;
+	fields = vcap_keyfields(ri->vctrl, vt, keyset);
+	if (!fields)
+		return NULL;
+	return &fields[key];
+}
+EXPORT_SYMBOL_GPL(vcap_lookup_keyfield);
+
 static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
 					   struct vcap_client_keyfield *field,
 					   struct vcap_client_keyfield_data *data)
@@ -253,6 +282,47 @@ static int vcap_rule_add_key(struct vcap_rule *rule,
 	return 0;
 }
 
+static void vcap_rule_set_key_bitsize(struct vcap_u1_key *u1, enum vcap_bit val)
+{
+	switch (val) {
+	case VCAP_BIT_0:
+		u1->value = 0;
+		u1->mask = 1;
+		break;
+	case VCAP_BIT_1:
+		u1->value = 1;
+		u1->mask = 1;
+		break;
+	case VCAP_BIT_ANY:
+		u1->value = 0;
+		u1->mask = 0;
+		break;
+	}
+}
+
+/* Add a bit key with value and mask to the rule */
+int vcap_rule_add_key_bit(struct vcap_rule *rule, enum vcap_key_field key,
+			  enum vcap_bit val)
+{
+	struct vcap_client_keyfield_data data;
+
+	vcap_rule_set_key_bitsize(&data.u1, val);
+	return vcap_rule_add_key(rule, key, VCAP_FIELD_BIT, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_key_bit);
+
+/* Add a 32 bit key field with value and mask to the rule */
+int vcap_rule_add_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 value, u32 mask)
+{
+	struct vcap_client_keyfield_data data;
+
+	data.u32.value = value;
+	data.u32.mask = mask;
+	return vcap_rule_add_key(rule, key, VCAP_FIELD_U32, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_key_u32);
+
 /* Add a 48 bit key with value and mask to the rule */
 int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
 			  struct vcap_u48_key *fieldval)
@@ -264,6 +334,17 @@ int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_add_key_u48);
 
+/* Add a 72 bit key with value and mask to the rule */
+int vcap_rule_add_key_u72(struct vcap_rule *rule, enum vcap_key_field key,
+			  struct vcap_u72_key *fieldval)
+{
+	struct vcap_client_keyfield_data data;
+
+	memcpy(&data.u72, fieldval, sizeof(data.u72));
+	return vcap_rule_add_key(rule, key, VCAP_FIELD_U72, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_key_u72);
+
 static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
 					      struct vcap_client_actionfield *field,
 					      struct vcap_client_actionfield_data *data)
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 2c4fd9d022f9..b0a2eae81dbe 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -173,6 +173,8 @@ int vcap_rule_add_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 			  u32 value, u32 mask);
 int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
 			  struct vcap_u48_key *fieldval);
+int vcap_rule_add_key_u72(struct vcap_rule *rule, enum vcap_key_field key,
+			  struct vcap_u72_key *fieldval);
 int vcap_rule_add_action_bit(struct vcap_rule *rule,
 			     enum vcap_action_field action, enum vcap_bit val);
 int vcap_rule_add_action_u32(struct vcap_rule *rule,
@@ -181,6 +183,9 @@ int vcap_rule_add_action_u32(struct vcap_rule *rule,
 /* VCAP lookup operations */
 /* Lookup a vcap instance using chain id */
 struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid);
+/* Find information on a key field in a rule */
+const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
+					      enum vcap_key_field key);
 /* Find a rule id with a provided cookie */
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
 
-- 
2.38.0

