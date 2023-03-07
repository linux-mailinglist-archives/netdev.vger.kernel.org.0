Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74F6AE0F1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCGNmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCGNmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:42:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC6B7FD66;
        Tue,  7 Mar 2023 05:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678196499; x=1709732499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fLji4dHXnCuZYsTfpuhtMbbvzTNBhsv65gZkXAHwuBs=;
  b=whCn5Ei3BuTiFRt263sSH49LQayDl58ko3fKPnZ6WavUBy8t3+0ljPnm
   UNhaEsz2eQite07VSyvQsGYZQcbE+1SxPCfHRMX+P2cBG3K+zof9n8R8i
   RAY43DDPnwa774h2w3h8p8DLAuAOeN1R4qciuhL+hzF/0fBMPq6pDV05L
   oib7+yoMfV6ztb6uxZvKq9LzrcgmOMh+z3v44XeIEDN/7sQWNMSC4lz+h
   laQ+zlke8wVCRP3Y8ak9EMmyTu7JME+dZ6MPgMPKzisoJ2rMTrGfsHBk7
   9nJBpeAPVlIHcLkIcCjMe/1j8Vyw1c2CsUzsqyMvMDZi7hlM5OnRUiPA/
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,241,1673938800"; 
   d="scan'208";a="200373261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 06:41:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 06:41:31 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 06:41:27 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Qiheng Lin <linqiheng@huawei.com>,
        "Shang XiaoJing" <shangxiaojing@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/5] net: microchip: sparx5: Add port keyset changing functionality
Date:   Tue, 7 Mar 2023 14:41:02 +0100
Message-ID: <20230307134103.2042975-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307134103.2042975-1-steen.hegelund@microchip.com>
References: <20230307134103.2042975-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this its is now possible for clients (like TC) to change the port
keyset configuration in the Sparx5 VCAPs.

This is typically done per traffic class which is guided with the L3
protocol information.
Before the change the current keyset configuration is collected in a list
that is handed back to the client.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_impl.c       | 270 ++++++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.h       |   6 +
 2 files changed, 276 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index d0d4e0385ac7..187efa1fc904 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -1519,6 +1519,276 @@ static struct vcap_operations sparx5_vcap_ops = {
 	.port_info = sparx5_port_info,
 };
 
+static u32 sparx5_vcap_is0_keyset_to_etype_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_NORMAL_7TUPLE:
+		return VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE;
+	case VCAP_KFS_NORMAL_5TUPLE_IP4:
+		return VCAP_IS0_PS_ETYPE_NORMAL_5TUPLE_IP4;
+	default:
+		return VCAP_IS0_PS_ETYPE_NORMAL_7TUPLE;
+	}
+}
+
+static void sparx5_vcap_is0_set_port_keyset(struct net_device *ndev, int lookup,
+					    enum vcap_keyfield_set keyset,
+					    int l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	switch (l3_proto) {
+	case ETH_P_IP:
+		value = sparx5_vcap_is0_keyset_to_etype_ps(keyset);
+		spx5_rmw(ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL_SET(value),
+			 ANA_CL_ADV_CL_CFG_IP4_CLM_KEY_SEL,
+			 sparx5,
+			 ANA_CL_ADV_CL_CFG(portno, lookup));
+		break;
+	case ETH_P_IPV6:
+		value = sparx5_vcap_is0_keyset_to_etype_ps(keyset);
+		spx5_rmw(ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL_SET(value),
+			 ANA_CL_ADV_CL_CFG_IP6_CLM_KEY_SEL,
+			 sparx5,
+			 ANA_CL_ADV_CL_CFG(portno, lookup));
+		break;
+	default:
+		value = sparx5_vcap_is0_keyset_to_etype_ps(keyset);
+		spx5_rmw(ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL_SET(value),
+			 ANA_CL_ADV_CL_CFG_ETYPE_CLM_KEY_SEL,
+			 sparx5,
+			 ANA_CL_ADV_CL_CFG(portno, lookup));
+		break;
+	}
+}
+
+static u32 sparx5_vcap_is2_keyset_to_arp_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_ARP:
+		return VCAP_IS2_PS_ARP_ARP;
+	default:
+		return VCAP_IS2_PS_ARP_MAC_ETYPE;
+	}
+}
+
+static u32 sparx5_vcap_is2_keyset_to_ipv4_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_MAC_ETYPE:
+		return VCAP_IS2_PS_IPV4_UC_MAC_ETYPE;
+	case VCAP_KFS_IP4_OTHER:
+	case VCAP_KFS_IP4_TCP_UDP:
+		return VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER;
+	case VCAP_KFS_IP_7TUPLE:
+		return VCAP_IS2_PS_IPV4_UC_IP_7TUPLE;
+	default:
+		return VCAP_KFS_NO_VALUE;
+	}
+}
+
+static u32 sparx5_vcap_is2_keyset_to_ipv6_uc_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_MAC_ETYPE:
+		return VCAP_IS2_PS_IPV6_UC_MAC_ETYPE;
+	case VCAP_KFS_IP4_OTHER:
+	case VCAP_KFS_IP4_TCP_UDP:
+		return VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER;
+	case VCAP_KFS_IP_7TUPLE:
+		return VCAP_IS2_PS_IPV6_UC_IP_7TUPLE;
+	default:
+		return VCAP_KFS_NO_VALUE;
+	}
+}
+
+static u32 sparx5_vcap_is2_keyset_to_ipv6_mc_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_MAC_ETYPE:
+		return VCAP_IS2_PS_IPV6_MC_MAC_ETYPE;
+	case VCAP_KFS_IP4_OTHER:
+	case VCAP_KFS_IP4_TCP_UDP:
+		return VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER;
+	case VCAP_KFS_IP_7TUPLE:
+		return VCAP_IS2_PS_IPV6_MC_IP_7TUPLE;
+	default:
+		return VCAP_KFS_NO_VALUE;
+	}
+}
+
+static void sparx5_vcap_is2_set_port_keyset(struct net_device *ndev, int lookup,
+					    enum vcap_keyfield_set keyset,
+					    int l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	switch (l3_proto) {
+	case ETH_P_ARP:
+		value = sparx5_vcap_is2_keyset_to_arp_ps(keyset);
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		break;
+	case ETH_P_IP:
+		value = sparx5_vcap_is2_keyset_to_ipv4_ps(keyset);
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_IP4_UC_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_IP4_MC_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		break;
+	case ETH_P_IPV6:
+		value = sparx5_vcap_is2_keyset_to_ipv6_uc_ps(keyset);
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		value = sparx5_vcap_is2_keyset_to_ipv6_mc_ps(keyset);
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_IP6_MC_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		break;
+	default:
+		value = VCAP_IS2_PS_NONETH_MAC_ETYPE;
+		spx5_rmw(ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL_SET(value),
+			 ANA_ACL_VCAP_S2_KEY_SEL_NON_ETH_KEY_SEL,
+			 sparx5,
+			 ANA_ACL_VCAP_S2_KEY_SEL(portno, lookup));
+		break;
+	}
+}
+
+static u32 sparx5_vcap_es2_keyset_to_arp_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_ARP:
+		return VCAP_ES2_PS_ARP_ARP;
+	default:
+		return VCAP_ES2_PS_ARP_MAC_ETYPE;
+	}
+}
+
+static u32 sparx5_vcap_es2_keyset_to_ipv4_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_MAC_ETYPE:
+		return VCAP_ES2_PS_IPV4_MAC_ETYPE;
+	case VCAP_KFS_IP_7TUPLE:
+		return VCAP_ES2_PS_IPV4_IP_7TUPLE;
+	case VCAP_KFS_IP4_TCP_UDP:
+		return VCAP_ES2_PS_IPV4_IP4_TCP_UDP_OTHER;
+	case VCAP_KFS_IP4_OTHER:
+		return VCAP_ES2_PS_IPV4_IP4_OTHER;
+	default:
+		return VCAP_ES2_PS_IPV4_MAC_ETYPE;
+	}
+}
+
+static u32 sparx5_vcap_es2_keyset_to_ipv6_ps(enum vcap_keyfield_set keyset)
+{
+	switch (keyset) {
+	case VCAP_KFS_MAC_ETYPE:
+		return VCAP_ES2_PS_IPV6_MAC_ETYPE;
+	case VCAP_KFS_IP4_TCP_UDP:
+	case VCAP_KFS_IP4_OTHER:
+		return VCAP_ES2_PS_IPV6_IP4_DOWNGRADE;
+	case VCAP_KFS_IP_7TUPLE:
+		return VCAP_ES2_PS_IPV6_IP_7TUPLE;
+	case VCAP_KFS_IP6_STD:
+		return VCAP_ES2_PS_IPV6_IP6_STD;
+	default:
+		return VCAP_ES2_PS_IPV6_MAC_ETYPE;
+	}
+}
+
+static void sparx5_vcap_es2_set_port_keyset(struct net_device *ndev, int lookup,
+					    enum vcap_keyfield_set keyset,
+					    int l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	switch (l3_proto) {
+	case ETH_P_IP:
+		value = sparx5_vcap_es2_keyset_to_ipv4_ps(keyset);
+		spx5_rmw(EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_SET(value),
+			 EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL,
+			 sparx5,
+			 EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+		break;
+	case ETH_P_IPV6:
+		value = sparx5_vcap_es2_keyset_to_ipv6_ps(keyset);
+		spx5_rmw(EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_SET(value),
+			 EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL,
+			 sparx5,
+			 EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+		break;
+	case ETH_P_ARP:
+		value = sparx5_vcap_es2_keyset_to_arp_ps(keyset);
+		spx5_rmw(EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_SET(value),
+			 EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL,
+			 sparx5,
+			 EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+		break;
+	}
+}
+
+/* Change the port keyset for the lookup and protocol */
+void sparx5_vcap_set_port_keyset(struct net_device *ndev,
+				 struct vcap_admin *admin,
+				 int cid,
+				 u16 l3_proto,
+				 enum vcap_keyfield_set keyset,
+				 struct vcap_keyset_list *orig)
+{
+	struct sparx5_port *port;
+	int lookup;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		lookup = sparx5_vcap_is0_cid_to_lookup(cid);
+		if (orig)
+			sparx5_vcap_is0_get_port_keysets(ndev, lookup, orig,
+							 l3_proto);
+		sparx5_vcap_is0_set_port_keyset(ndev, lookup, keyset, l3_proto);
+		break;
+	case VCAP_TYPE_IS2:
+		lookup = sparx5_vcap_is2_cid_to_lookup(cid);
+		if (orig)
+			sparx5_vcap_is2_get_port_keysets(ndev, lookup, orig,
+							 l3_proto);
+		sparx5_vcap_is2_set_port_keyset(ndev, lookup, keyset, l3_proto);
+		break;
+	case VCAP_TYPE_ES0:
+		break;
+	case VCAP_TYPE_ES2:
+		lookup = sparx5_vcap_es2_cid_to_lookup(cid);
+		if (orig)
+			sparx5_vcap_es2_get_port_keysets(ndev, lookup, orig,
+							 l3_proto);
+		sparx5_vcap_es2_set_port_keyset(ndev, lookup, keyset, l3_proto);
+		break;
+	default:
+		port = netdev_priv(ndev);
+		sparx5_vcap_type_err(port->sparx5, admin, __func__);
+		break;
+	}
+}
+
 /* Enable IS0 lookups per port and set the keyset generation */
 static void sparx5_vcap_is0_port_key_selection(struct sparx5 *sparx5,
 					       struct vcap_admin *admin)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 3260ab5e3a82..2684d9199b05 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -195,6 +195,12 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				u16 l3_proto,
 				struct vcap_keyset_list *kslist);
 
+/* Change the port keyset for the lookup and protocol */
+void sparx5_vcap_set_port_keyset(struct net_device *ndev,
+				 struct vcap_admin *admin, int cid,
+				 u16 l3_proto, enum vcap_keyfield_set keyset,
+				 struct vcap_keyset_list *orig);
+
 /* Check if the ethertype is supported by the vcap port classification */
 bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype);
 
-- 
2.39.2

