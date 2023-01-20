Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BCC67503A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjATJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjATJIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:08:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A00526C;
        Fri, 20 Jan 2023 01:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205726; x=1705741726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEKxm8QfgG38AHKcD/Npk5lTFUx477QmSXshg5cjmUg=;
  b=lc5STUlhxN7vkwLVJse2MS4j4sXHbwDoVfT7MyLs0V3NQBI+iWl+8/Ya
   vmhKPFxVm8UxEd/Y9JThLWKU3nwGLMPKfj37vePwC5PXHeSIn50/mrpqY
   W38AtQLNCCcGtKogR5HZD+Jer7koC0FEwc1RuFh+8ImOcse/Bm0j+xmCL
   rniIuEEvSSSoK5rxon4mHqri8dCxdd/Z5jbqesgW4HMeD8B+DicmZI504
   8EcgHL10dxujYQlvtNVUVBGUNOLZ5l7Y1z5Mwvpn6NyKcXXlG+XJa91xy
   gaF2JgcfjtJt/IJmTHJzxtT8VYVwMbgLKEf0Qndkuioa67ze9v3wrhdgf
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197598498"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:08:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:43 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:39 -0700
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
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/8] net: microchip: sparx5: Add IS0 VCAP model and updated KUNIT VCAP model
Date:   Fri, 20 Jan 2023 10:08:24 +0100
Message-ID: <20230120090831.20032-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120090831.20032-1-steen.hegelund@microchip.com>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the IS0 (Ingress Stage 0) or CLM VCAP model for Sparx5.
This VCAP provides classification actions for Sparx5.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 1110 ++++++++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  336 +--
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |    2 +-
 .../microchip/vcap/vcap_model_kunit.c         | 1994 ++---------------
 4 files changed, 1383 insertions(+), 2059 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
index 1bd987c664e8..41e50743f3ac 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
@@ -3,8 +3,8 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2022-10-13 10:04:41 +0200.
- * Commit ID: fd7cafd175899f0672c73afb3a30fc872500ae86
+/* This file is autogenerated by cml-utils 2022-12-06 12:43:54 +0100.
+ * Commit ID: 3db2ac730f134c160496f2b9f10915e347d871cb
  */
 
 #include <linux/types.h>
@@ -14,6 +14,372 @@
 #include "sparx5_vcap_ag_api.h"
 
 /* keyfields */
+static const struct vcap_field is0_normal_7tuple_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 1,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_GEN_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 12,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U72,
+		.offset = 18,
+		.width = 65,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 83,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 84,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 85,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 88,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 95,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 107,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 110,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 113,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 114,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_TPID2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 126,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 129,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI2] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 132,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 133,
+		.width = 12,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 145,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 193,
+		.width = 48,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 241,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE_LEN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 242,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 243,
+		.width = 16,
+	},
+	[VCAP_KF_IP_SNAP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 259,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 260,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 261,
+		.width = 2,
+	},
+	[VCAP_KF_L3_FRAG_INVLD_L4_LEN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 263,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 264,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 265,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 271,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 399,
+		.width = 128,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 527,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 528,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 529,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 545,
+		.width = 8,
+	},
+};
+
+static const struct vcap_field is0_normal_5tuple_ip4_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 2,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_GEN_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 5,
+		.width = 12,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U72,
+		.offset = 19,
+		.width = 65,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 84,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 85,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 86,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 89,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 92,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 96,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 108,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 111,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 114,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 115,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_TPID2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 127,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_PCP2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 130,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI2] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 133,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID2] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 134,
+		.width = 12,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 146,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 147,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 148,
+		.width = 2,
+	},
+	[VCAP_KF_L3_FRAG_INVLD_L4_LEN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 150,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 151,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 152,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 158,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 190,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 222,
+		.width = 8,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 230,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 231,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 232,
+		.width = 8,
+	},
+	[VCAP_KF_IP_PAYLOAD_5TUPLE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 240,
+		.width = 32,
+	},
+};
+
 static const struct vcap_field is2_mac_etype_keyfield[] = {
 	[VCAP_KF_TYPE] = {
 		.type = VCAP_FIELD_U32,
@@ -945,83 +1311,405 @@ static const struct vcap_field is2_ip_7tuple_keyfield[] = {
 		.offset = 538,
 		.width = 1,
 	},
-	[VCAP_KF_L4_PSH] = {
+	[VCAP_KF_L4_PSH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 539,
+		.width = 1,
+	},
+	[VCAP_KF_L4_ACK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 540,
+		.width = 1,
+	},
+	[VCAP_KF_L4_URG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 541,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PAYLOAD] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 542,
+		.width = 64,
+	},
+};
+
+/* keyfield_set */
+static const struct vcap_set is0_keyfield_set[] = {
+	[VCAP_KFS_NORMAL_7TUPLE] = {
+		.type_id = 0,
+		.sw_per_item = 12,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_NORMAL_5TUPLE_IP4] = {
+		.type_id = 2,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+};
+
+static const struct vcap_set is2_keyfield_set[] = {
+	[VCAP_KFS_MAC_ETYPE] = {
+		.type_id = 0,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_ARP] = {
+		.type_id = 3,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_TCP_UDP] = {
+		.type_id = 4,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_OTHER] = {
+		.type_id = 5,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP6_STD] = {
+		.type_id = 6,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP_7TUPLE] = {
+		.type_id = 1,
+		.sw_per_item = 12,
+		.sw_cnt = 1,
+	},
+};
+
+/* keyfield_set map */
+static const struct vcap_field *is0_keyfield_set_map[] = {
+	[VCAP_KFS_NORMAL_7TUPLE] = is0_normal_7tuple_keyfield,
+	[VCAP_KFS_NORMAL_5TUPLE_IP4] = is0_normal_5tuple_ip4_keyfield,
+};
+
+static const struct vcap_field *is2_keyfield_set_map[] = {
+	[VCAP_KFS_MAC_ETYPE] = is2_mac_etype_keyfield,
+	[VCAP_KFS_ARP] = is2_arp_keyfield,
+	[VCAP_KFS_IP4_TCP_UDP] = is2_ip4_tcp_udp_keyfield,
+	[VCAP_KFS_IP4_OTHER] = is2_ip4_other_keyfield,
+	[VCAP_KFS_IP6_STD] = is2_ip6_std_keyfield,
+	[VCAP_KFS_IP_7TUPLE] = is2_ip_7tuple_keyfield,
+};
+
+/* keyfield_set map sizes */
+static int is0_keyfield_set_map_size[] = {
+	[VCAP_KFS_NORMAL_7TUPLE] = ARRAY_SIZE(is0_normal_7tuple_keyfield),
+	[VCAP_KFS_NORMAL_5TUPLE_IP4] = ARRAY_SIZE(is0_normal_5tuple_ip4_keyfield),
+};
+
+static int is2_keyfield_set_map_size[] = {
+	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(is2_mac_etype_keyfield),
+	[VCAP_KFS_ARP] = ARRAY_SIZE(is2_arp_keyfield),
+	[VCAP_KFS_IP4_TCP_UDP] = ARRAY_SIZE(is2_ip4_tcp_udp_keyfield),
+	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(is2_ip4_other_keyfield),
+	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(is2_ip6_std_keyfield),
+	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(is2_ip_7tuple_keyfield),
+};
+
+/* actionfields */
+static const struct vcap_field is0_classification_actionfield[] = {
+	[VCAP_AF_TYPE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_AF_DSCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 1,
+		.width = 1,
+	},
+	[VCAP_AF_DSCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 6,
+	},
+	[VCAP_AF_QOS_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_AF_QOS_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 3,
+	},
+	[VCAP_AF_DP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_AF_DP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 2,
+	},
+	[VCAP_AF_DEI_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_AF_DEI_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 20,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 21,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 22,
+		.width = 3,
+	},
+	[VCAP_AF_MAP_LOOKUP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 25,
+		.width = 2,
+	},
+	[VCAP_AF_MAP_KEY] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 3,
+	},
+	[VCAP_AF_MAP_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 30,
+		.width = 9,
+	},
+	[VCAP_AF_CLS_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 39,
+		.width = 3,
+	},
+	[VCAP_AF_VID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 13,
+	},
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 68,
+		.width = 1,
+	},
+	[VCAP_AF_ISDX_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 69,
+		.width = 12,
+	},
+	[VCAP_AF_PAG_OVERRIDE_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 109,
+		.width = 8,
+	},
+	[VCAP_AF_PAG_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 117,
+		.width = 8,
+	},
+	[VCAP_AF_NXT_IDX_CTRL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 171,
+		.width = 3,
+	},
+	[VCAP_AF_NXT_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 174,
+		.width = 12,
+	},
+};
+
+static const struct vcap_field is0_full_actionfield[] = {
+	[VCAP_AF_DSCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_AF_DSCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 6,
+	},
+	[VCAP_AF_QOS_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 11,
+		.width = 1,
+	},
+	[VCAP_AF_QOS_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 12,
+		.width = 3,
+	},
+	[VCAP_AF_DP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_AF_DP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 2,
+	},
+	[VCAP_AF_DEI_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_AF_DEI_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 20,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 21,
+		.width = 3,
+	},
+	[VCAP_AF_MAP_LOOKUP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 24,
+		.width = 2,
+	},
+	[VCAP_AF_MAP_KEY] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 26,
+		.width = 3,
+	},
+	[VCAP_AF_MAP_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 9,
+	},
+	[VCAP_AF_CLS_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 38,
+		.width = 3,
+	},
+	[VCAP_AF_VID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 44,
+		.width = 13,
+	},
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 67,
+		.width = 1,
+	},
+	[VCAP_AF_ISDX_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 68,
+		.width = 12,
+	},
+	[VCAP_AF_MASK_MODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 80,
+		.width = 3,
+	},
+	[VCAP_AF_PORT_MASK] = {
+		.type = VCAP_FIELD_U72,
+		.offset = 83,
+		.width = 65,
+	},
+	[VCAP_AF_PAG_OVERRIDE_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 204,
+		.width = 8,
+	},
+	[VCAP_AF_PAG_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 212,
+		.width = 8,
+	},
+	[VCAP_AF_NXT_IDX_CTRL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 298,
+		.width = 3,
+	},
+	[VCAP_AF_NXT_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 301,
+		.width = 12,
+	},
+};
+
+static const struct vcap_field is0_class_reduced_actionfield[] = {
+	[VCAP_AF_TYPE] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 539,
+		.offset = 0,
 		.width = 1,
 	},
-	[VCAP_KF_L4_ACK] = {
+	[VCAP_AF_QOS_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 540,
+		.offset = 5,
 		.width = 1,
 	},
-	[VCAP_KF_L4_URG] = {
+	[VCAP_AF_QOS_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 6,
+		.width = 3,
+	},
+	[VCAP_AF_DP_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 541,
+		.offset = 9,
 		.width = 1,
 	},
-	[VCAP_KF_L4_PAYLOAD] = {
-		.type = VCAP_FIELD_U64,
-		.offset = 542,
-		.width = 64,
+	[VCAP_AF_DP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 10,
+		.width = 2,
 	},
-};
-
-/* keyfield_set */
-static const struct vcap_set is2_keyfield_set[] = {
-	[VCAP_KFS_MAC_ETYPE] = {
-		.type_id = 0,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
+	[VCAP_AF_MAP_LOOKUP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 12,
+		.width = 2,
 	},
-	[VCAP_KFS_ARP] = {
-		.type_id = 3,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
+	[VCAP_AF_MAP_KEY] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 14,
+		.width = 3,
 	},
-	[VCAP_KFS_IP4_TCP_UDP] = {
-		.type_id = 4,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
+	[VCAP_AF_CLS_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 3,
 	},
-	[VCAP_KFS_IP4_OTHER] = {
-		.type_id = 5,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
+	[VCAP_AF_VID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 23,
+		.width = 13,
 	},
-	[VCAP_KFS_IP6_STD] = {
-		.type_id = 6,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 46,
+		.width = 1,
 	},
-	[VCAP_KFS_IP_7TUPLE] = {
-		.type_id = 1,
-		.sw_per_item = 12,
-		.sw_cnt = 1,
+	[VCAP_AF_ISDX_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 47,
+		.width = 12,
+	},
+	[VCAP_AF_NXT_IDX_CTRL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 90,
+		.width = 3,
+	},
+	[VCAP_AF_NXT_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 93,
+		.width = 12,
 	},
 };
 
-/* keyfield_set map */
-static const struct vcap_field *is2_keyfield_set_map[] = {
-	[VCAP_KFS_MAC_ETYPE] = is2_mac_etype_keyfield,
-	[VCAP_KFS_ARP] = is2_arp_keyfield,
-	[VCAP_KFS_IP4_TCP_UDP] = is2_ip4_tcp_udp_keyfield,
-	[VCAP_KFS_IP4_OTHER] = is2_ip4_other_keyfield,
-	[VCAP_KFS_IP6_STD] = is2_ip6_std_keyfield,
-	[VCAP_KFS_IP_7TUPLE] = is2_ip_7tuple_keyfield,
-};
-
-/* keyfield_set map sizes */
-static int is2_keyfield_set_map_size[] = {
-	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(is2_mac_etype_keyfield),
-	[VCAP_KFS_ARP] = ARRAY_SIZE(is2_arp_keyfield),
-	[VCAP_KFS_IP4_TCP_UDP] = ARRAY_SIZE(is2_ip4_tcp_udp_keyfield),
-	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(is2_ip4_other_keyfield),
-	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(is2_ip6_std_keyfield),
-	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(is2_ip_7tuple_keyfield),
-};
-
-/* actionfields */
 static const struct vcap_field is2_base_type_actionfield[] = {
 	[VCAP_AF_PIPELINE_FORCE_ENA] = {
 		.type = VCAP_FIELD_BIT,
@@ -1111,6 +1799,24 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 };
 
 /* actionfield_set */
+static const struct vcap_set is0_actionfield_set[] = {
+	[VCAP_AFS_CLASSIFICATION] = {
+		.type_id = 1,
+		.sw_per_item = 2,
+		.sw_cnt = 6,
+	},
+	[VCAP_AFS_FULL] = {
+		.type_id = -1,
+		.sw_per_item = 3,
+		.sw_cnt = 4,
+	},
+	[VCAP_AFS_CLASS_REDUCED] = {
+		.type_id = 1,
+		.sw_per_item = 1,
+		.sw_cnt = 12,
+	},
+};
+
 static const struct vcap_set is2_actionfield_set[] = {
 	[VCAP_AFS_BASE_TYPE] = {
 		.type_id = -1,
@@ -1120,16 +1826,138 @@ static const struct vcap_set is2_actionfield_set[] = {
 };
 
 /* actionfield_set map */
+static const struct vcap_field *is0_actionfield_set_map[] = {
+	[VCAP_AFS_CLASSIFICATION] = is0_classification_actionfield,
+	[VCAP_AFS_FULL] = is0_full_actionfield,
+	[VCAP_AFS_CLASS_REDUCED] = is0_class_reduced_actionfield,
+};
+
 static const struct vcap_field *is2_actionfield_set_map[] = {
 	[VCAP_AFS_BASE_TYPE] = is2_base_type_actionfield,
 };
 
 /* actionfield_set map size */
+static int is0_actionfield_set_map_size[] = {
+	[VCAP_AFS_CLASSIFICATION] = ARRAY_SIZE(is0_classification_actionfield),
+	[VCAP_AFS_FULL] = ARRAY_SIZE(is0_full_actionfield),
+	[VCAP_AFS_CLASS_REDUCED] = ARRAY_SIZE(is0_class_reduced_actionfield),
+};
+
 static int is2_actionfield_set_map_size[] = {
 	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(is2_base_type_actionfield),
 };
 
 /* Type Groups */
+static const struct vcap_typegroup is0_x12_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 5,
+		.value = 16,
+	},
+	{
+		.offset = 52,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 104,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 156,
+		.width = 3,
+		.value = 0,
+	},
+	{
+		.offset = 208,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 260,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 312,
+		.width = 4,
+		.value = 0,
+	},
+	{
+		.offset = 364,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 416,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 468,
+		.width = 3,
+		.value = 0,
+	},
+	{
+		.offset = 520,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 572,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is0_x6_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 4,
+		.value = 8,
+	},
+	{
+		.offset = 52,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 104,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 156,
+		.width = 3,
+		.value = 0,
+	},
+	{
+		.offset = 208,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 260,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is0_x3_keyfield_set_typegroups[] = {
+	{}
+};
+
+static const struct vcap_typegroup is0_x2_keyfield_set_typegroups[] = {
+	{}
+};
+
+static const struct vcap_typegroup is0_x1_keyfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup is2_x12_keyfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -1176,6 +2004,15 @@ static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup *is0_keyfield_set_typegroups[] = {
+	[12] = is0_x12_keyfield_set_typegroups,
+	[6] = is0_x6_keyfield_set_typegroups,
+	[3] = is0_x3_keyfield_set_typegroups,
+	[2] = is0_x2_keyfield_set_typegroups,
+	[1] = is0_x1_keyfield_set_typegroups,
+	[13] = NULL,
+};
+
 static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[12] = is2_x12_keyfield_set_typegroups,
 	[6] = is2_x6_keyfield_set_typegroups,
@@ -1184,6 +2021,48 @@ static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[13] = NULL,
 };
 
+static const struct vcap_typegroup is0_x3_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 3,
+		.value = 4,
+	},
+	{
+		.offset = 110,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 220,
+		.width = 2,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is0_x2_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 110,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is0_x1_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 1,
+		.value = 1,
+	},
+	{}
+};
+
 static const struct vcap_typegroup is2_x3_actionfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -1207,6 +2086,13 @@ static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup *is0_actionfield_set_typegroups[] = {
+	[3] = is0_x3_actionfield_set_typegroups,
+	[2] = is0_x2_actionfield_set_typegroups,
+	[1] = is0_x1_actionfield_set_typegroups,
+	[13] = NULL,
+};
+
 static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 	[3] = is2_x3_actionfield_set_typegroups,
 	[1] = is2_x1_actionfield_set_typegroups,
@@ -1219,24 +2105,50 @@ static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_ARP]                           =  "VCAP_KFS_ARP",
 	[VCAP_KFS_IP4_OTHER]                     =  "VCAP_KFS_IP4_OTHER",
 	[VCAP_KFS_IP4_TCP_UDP]                   =  "VCAP_KFS_IP4_TCP_UDP",
+	[VCAP_KFS_IP6_OTHER]                     =  "VCAP_KFS_IP6_OTHER",
 	[VCAP_KFS_IP6_STD]                       =  "VCAP_KFS_IP6_STD",
+	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
 	[VCAP_KFS_IP_7TUPLE]                     =  "VCAP_KFS_IP_7TUPLE",
 	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
+	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
+	[VCAP_KFS_MAC_SNAP]                      =  "VCAP_KFS_MAC_SNAP",
+	[VCAP_KFS_NORMAL_5TUPLE_IP4]             =  "VCAP_KFS_NORMAL_5TUPLE_IP4",
+	[VCAP_KFS_NORMAL_7TUPLE]                 =  "VCAP_KFS_NORMAL_7TUPLE",
+	[VCAP_KFS_OAM]                           =  "VCAP_KFS_OAM",
+	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
+	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
 };
 
 /* Actionfieldset names */
 static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_NO_VALUE]                      =  "(None)",
 	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
+	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
+	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
+	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
+	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
 };
 
 /* Keyfield names */
 static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_NO_VALUE]                       =  "(None)",
+	[VCAP_KF_8021Q_DEI0]                     =  "8021Q_DEI0",
+	[VCAP_KF_8021Q_DEI1]                     =  "8021Q_DEI1",
+	[VCAP_KF_8021Q_DEI2]                     =  "8021Q_DEI2",
 	[VCAP_KF_8021Q_DEI_CLS]                  =  "8021Q_DEI_CLS",
+	[VCAP_KF_8021Q_PCP0]                     =  "8021Q_PCP0",
+	[VCAP_KF_8021Q_PCP1]                     =  "8021Q_PCP1",
+	[VCAP_KF_8021Q_PCP2]                     =  "8021Q_PCP2",
 	[VCAP_KF_8021Q_PCP_CLS]                  =  "8021Q_PCP_CLS",
+	[VCAP_KF_8021Q_TPID0]                    =  "8021Q_TPID0",
+	[VCAP_KF_8021Q_TPID1]                    =  "8021Q_TPID1",
+	[VCAP_KF_8021Q_TPID2]                    =  "8021Q_TPID2",
+	[VCAP_KF_8021Q_VID0]                     =  "8021Q_VID0",
+	[VCAP_KF_8021Q_VID1]                     =  "8021Q_VID1",
+	[VCAP_KF_8021Q_VID2]                     =  "8021Q_VID2",
 	[VCAP_KF_8021Q_VID_CLS]                  =  "8021Q_VID_CLS",
 	[VCAP_KF_8021Q_VLAN_TAGGED_IS]           =  "8021Q_VLAN_TAGGED_IS",
+	[VCAP_KF_8021Q_VLAN_TAGS]                =  "8021Q_VLAN_TAGS",
 	[VCAP_KF_ARP_ADDR_SPACE_OK_IS]           =  "ARP_ADDR_SPACE_OK_IS",
 	[VCAP_KF_ARP_LEN_OK_IS]                  =  "ARP_LEN_OK_IS",
 	[VCAP_KF_ARP_OPCODE]                     =  "ARP_OPCODE",
@@ -1246,23 +2158,37 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
 	[VCAP_KF_ETYPE]                          =  "ETYPE",
 	[VCAP_KF_ETYPE_LEN_IS]                   =  "ETYPE_LEN_IS",
+	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
 	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
 	[VCAP_KF_IF_IGR_PORT_MASK_RNG]           =  "IF_IGR_PORT_MASK_RNG",
 	[VCAP_KF_IF_IGR_PORT_MASK_SEL]           =  "IF_IGR_PORT_MASK_SEL",
 	[VCAP_KF_IP4_IS]                         =  "IP4_IS",
+	[VCAP_KF_IP_MC_IS]                       =  "IP_MC_IS",
+	[VCAP_KF_IP_PAYLOAD_5TUPLE]              =  "IP_PAYLOAD_5TUPLE",
+	[VCAP_KF_IP_SNAP_IS]                     =  "IP_SNAP_IS",
 	[VCAP_KF_ISDX_CLS]                       =  "ISDX_CLS",
 	[VCAP_KF_ISDX_GT0_IS]                    =  "ISDX_GT0_IS",
 	[VCAP_KF_L2_BC_IS]                       =  "L2_BC_IS",
 	[VCAP_KF_L2_DMAC]                        =  "L2_DMAC",
+	[VCAP_KF_L2_FRM_TYPE]                    =  "L2_FRM_TYPE",
 	[VCAP_KF_L2_FWD_IS]                      =  "L2_FWD_IS",
+	[VCAP_KF_L2_LLC]                         =  "L2_LLC",
 	[VCAP_KF_L2_MC_IS]                       =  "L2_MC_IS",
+	[VCAP_KF_L2_PAYLOAD0]                    =  "L2_PAYLOAD0",
+	[VCAP_KF_L2_PAYLOAD1]                    =  "L2_PAYLOAD1",
+	[VCAP_KF_L2_PAYLOAD2]                    =  "L2_PAYLOAD2",
 	[VCAP_KF_L2_PAYLOAD_ETYPE]               =  "L2_PAYLOAD_ETYPE",
 	[VCAP_KF_L2_SMAC]                        =  "L2_SMAC",
+	[VCAP_KF_L2_SNAP]                        =  "L2_SNAP",
 	[VCAP_KF_L3_DIP_EQ_SIP_IS]               =  "L3_DIP_EQ_SIP_IS",
+	[VCAP_KF_L3_DSCP]                        =  "L3_DSCP",
 	[VCAP_KF_L3_DST_IS]                      =  "L3_DST_IS",
+	[VCAP_KF_L3_FRAGMENT]                    =  "L3_FRAGMENT",
 	[VCAP_KF_L3_FRAGMENT_TYPE]               =  "L3_FRAGMENT_TYPE",
 	[VCAP_KF_L3_FRAG_INVLD_L4_LEN]           =  "L3_FRAG_INVLD_L4_LEN",
+	[VCAP_KF_L3_FRAG_OFS_GT0]                =  "L3_FRAG_OFS_GT0",
 	[VCAP_KF_L3_IP4_DIP]                     =  "L3_IP4_DIP",
 	[VCAP_KF_L3_IP4_SIP]                     =  "L3_IP4_SIP",
 	[VCAP_KF_L3_IP6_DIP]                     =  "L3_IP6_DIP",
@@ -1273,6 +2199,8 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L3_RT_IS]                       =  "L3_RT_IS",
 	[VCAP_KF_L3_TOS]                         =  "L3_TOS",
 	[VCAP_KF_L3_TTL_GT0]                     =  "L3_TTL_GT0",
+	[VCAP_KF_L4_1588_DOM]                    =  "L4_1588_DOM",
+	[VCAP_KF_L4_1588_VER]                    =  "L4_1588_VER",
 	[VCAP_KF_L4_ACK]                         =  "L4_ACK",
 	[VCAP_KF_L4_DPORT]                       =  "L4_DPORT",
 	[VCAP_KF_L4_FIN]                         =  "L4_FIN",
@@ -1286,8 +2214,16 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L4_SYN]                         =  "L4_SYN",
 	[VCAP_KF_L4_URG]                         =  "L4_URG",
 	[VCAP_KF_LOOKUP_FIRST_IS]                =  "LOOKUP_FIRST_IS",
+	[VCAP_KF_LOOKUP_GEN_IDX]                 =  "LOOKUP_GEN_IDX",
+	[VCAP_KF_LOOKUP_GEN_IDX_SEL]             =  "LOOKUP_GEN_IDX_SEL",
 	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
 	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
+	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
+	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
+	[VCAP_KF_OAM_MEL_FLAGS]                  =  "OAM_MEL_FLAGS",
+	[VCAP_KF_OAM_MEPID]                      =  "OAM_MEPID",
+	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
+	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
 	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
 	[VCAP_KF_TCP_IS]                         =  "TCP_IS",
 	[VCAP_KF_TCP_UDP_IS]                     =  "TCP_UDP_IS",
@@ -1297,27 +2233,77 @@ static const char * const vcap_keyfield_names[] = {
 /* Actionfield names */
 static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_NO_VALUE]                       =  "(None)",
+	[VCAP_AF_ACL_ID]                         =  "ACL_ID",
+	[VCAP_AF_CLS_VID_SEL]                    =  "CLS_VID_SEL",
 	[VCAP_AF_CNT_ID]                         =  "CNT_ID",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
+	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
+	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
+	[VCAP_AF_DP_ENA]                         =  "DP_ENA",
+	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
+	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
+	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
+	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
+	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
 	[VCAP_AF_INTR_ENA]                       =  "INTR_ENA",
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL]           =  "ISDX_ADD_REPLACE_SEL",
+	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
+	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
+	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
+	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
+	[VCAP_AF_MAP_LOOKUP_SEL]                 =  "MAP_LOOKUP_SEL",
 	[VCAP_AF_MASK_MODE]                      =  "MASK_MODE",
 	[VCAP_AF_MATCH_ID]                       =  "MATCH_ID",
 	[VCAP_AF_MATCH_ID_MASK]                  =  "MATCH_ID_MASK",
+	[VCAP_AF_MIRROR_ENA]                     =  "MIRROR_ENA",
 	[VCAP_AF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
+	[VCAP_AF_NXT_IDX]                        =  "NXT_IDX",
+	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
+	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
+	[VCAP_AF_PAG_VAL]                        =  "PAG_VAL",
+	[VCAP_AF_PCP_ENA]                        =  "PCP_ENA",
+	[VCAP_AF_PCP_VAL]                        =  "PCP_VAL",
 	[VCAP_AF_PIPELINE_FORCE_ENA]             =  "PIPELINE_FORCE_ENA",
 	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
+	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
+	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
+	[VCAP_AF_QOS_VAL]                        =  "QOS_VAL",
+	[VCAP_AF_REW_OP]                         =  "REW_OP",
 	[VCAP_AF_RT_DIS]                         =  "RT_DIS",
+	[VCAP_AF_TYPE]                           =  "TYPE",
+	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
 };
 
 /* VCAPs */
 const struct vcap_info sparx5_vcaps[] = {
+	[VCAP_TYPE_IS0] = {
+		.name = "is0",
+		.rows = 1024,
+		.sw_count = 12,
+		.sw_width = 52,
+		.sticky_width = 1,
+		.act_width = 110,
+		.default_cnt = 140,
+		.require_cnt_dis = 0,
+		.version = 1,
+		.keyfield_set = is0_keyfield_set,
+		.keyfield_set_size = ARRAY_SIZE(is0_keyfield_set),
+		.actionfield_set = is0_actionfield_set,
+		.actionfield_set_size = ARRAY_SIZE(is0_actionfield_set),
+		.keyfield_set_map = is0_keyfield_set_map,
+		.keyfield_set_map_size = is0_keyfield_set_map_size,
+		.actionfield_set_map = is0_actionfield_set_map,
+		.actionfield_set_map_size = is0_actionfield_set_map_size,
+		.keyfield_set_typegroups = is0_keyfield_set_typegroups,
+		.actionfield_set_typegroups = is0_actionfield_set_typegroups,
+	},
 	[VCAP_TYPE_IS2] = {
 		.name = "is2",
 		.rows = 256,
@@ -1343,7 +2329,7 @@ const struct vcap_info sparx5_vcaps[] = {
 
 const struct vcap_statistics sparx5_vcap_stats = {
 	.name = "sparx5",
-	.count = 1,
+	.count = 2,
 	.keyfield_set_names = vcap_keyfield_set_names,
 	.actionfield_set_names = vcap_actionfield_set_names,
 	.keyfield_names = vcap_keyfield_names,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index 84de2aee4169..962383f20f1b 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -3,8 +3,8 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2022-10-13 10:04:41 +0200.
- * Commit ID: fd7cafd175899f0672c73afb3a30fc872500ae86
+/* This file is autogenerated by cml-utils 2022-12-06 09:49:28 +0100.
+ * Commit ID: cd9451f1b9d8cafa58f845de66a6e373658019ef
  */
 
 #ifndef __VCAP_AG_API__
@@ -20,27 +20,24 @@ enum vcap_type {
 /* Keyfieldset names with origin information */
 enum vcap_keyfield_set {
 	VCAP_KFS_NO_VALUE,          /* initial value */
-	VCAP_KFS_ARP,               /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_ARP,               /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_ETAG,              /* sparx5 is0 X2 */
-	VCAP_KFS_IP4_OTHER,         /* sparx5 is2 X6, sparx5 es2 X6 */
-	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_IP4_OTHER,         /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
+	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_IP4_VID,           /* sparx5 es2 X3 */
-	VCAP_KFS_IP6_STD,           /* sparx5 is2 X6 */
-	VCAP_KFS_IP6_VID,           /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_IP6_OTHER,         /* lan966x is2 X4 */
+	VCAP_KFS_IP6_STD,           /* sparx5 is2 X6, lan966x is2 X2 */
+	VCAP_KFS_IP6_TCP_UDP,       /* lan966x is2 X4 */
+	VCAP_KFS_IP6_VID,           /* sparx5 es2 X6 */
 	VCAP_KFS_IP_7TUPLE,         /* sparx5 is2 X12, sparx5 es2 X12 */
 	VCAP_KFS_LL_FULL,           /* sparx5 is0 X6 */
-	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6, sparx5 es2 X6 */
-	VCAP_KFS_MLL,               /* sparx5 is0 X3 */
-	VCAP_KFS_NORMAL,            /* sparx5 is0 X6 */
-	VCAP_KFS_NORMAL_5TUPLE_IP4,  /* sparx5 is0 X6 */
-	VCAP_KFS_NORMAL_7TUPLE,     /* sparx5 is0 X12 */
-	VCAP_KFS_PURE_5TUPLE_IP4,   /* sparx5 is0 X3 */
-	VCAP_KFS_TRI_VID,           /* sparx5 is0 X2 */
+	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_MAC_LLC,           /* lan966x is2 X2 */
 	VCAP_KFS_MAC_SNAP,          /* lan966x is2 X2 */
+	VCAP_KFS_NORMAL_5TUPLE_IP4,  /* sparx5 is0 X6 */
+	VCAP_KFS_NORMAL_7TUPLE,     /* sparx5 is0 X12 */
 	VCAP_KFS_OAM,               /* lan966x is2 X2 */
-	VCAP_KFS_IP6_TCP_UDP,       /* lan966x is2 X4 */
-	VCAP_KFS_IP6_OTHER,         /* lan966x is2 X4 */
+	VCAP_KFS_PURE_5TUPLE_IP4,   /* sparx5 is0 X3 */
 	VCAP_KFS_SMAC_SIP4,         /* lan966x is2 X1 */
 	VCAP_KFS_SMAC_SIP6,         /* lan966x is2 X2 */
 };
@@ -90,7 +87,7 @@ enum vcap_keyfield_set {
  *   Second VID in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_VID2: W12, sparx5: is0
  *   Third VID in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_VID_CLS: W13, sparx5: is2/es2, lan966x is2 W12
+ * VCAP_KF_8021Q_VID_CLS: sparx5 is2 W13, sparx5 es2 W13, lan966x is2 W12
  *   Classified VID
  * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
@@ -104,7 +101,7 @@ enum vcap_keyfield_set {
  *   Set if hardware address is Ethernet
  * VCAP_KF_ARP_LEN_OK_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if hardware address length = 6 (Ethernet) and IP address length = 4 (IP).
- * VCAP_KF_ARP_OPCODE: W2, sparx5: is2/es2, lan966x: i2
+ * VCAP_KF_ARP_OPCODE: W2, sparx5: is2/es2, lan966x: is2
  *   ARP opcode
  * VCAP_KF_ARP_OPCODE_UNKNOWN_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if not one of the codes defined in VCAP_KF_ARP_OPCODE
@@ -116,23 +113,21 @@ enum vcap_keyfield_set {
  *   Target Hardware Address = SMAC (RARP)
  * VCAP_KF_COSID_CLS: W3, sparx5: es2
  *   Class of service
- * VCAP_KF_DST_ENTRY: W1, sparx5: is0
- *   Selects whether the frame’s destination or source information is used for
- *   fields L2_SMAC and L3_IP4_SIP
  * VCAP_KF_ES0_ISDX_KEY_ENA: W1, sparx5: es2
  *   The value taken from the IFH .FWD.ES0_ISDX_KEY_ENA
  * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2, lan966x: is2
  *   Ethernet type
  * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is0/is2/es2
  *   Set if frame has EtherType >= 0x600
- * VCAP_KF_ETYPE_MPLS: W2, sparx5: is0
- *   Type of MPLS Ethertype (or not)
+ * VCAP_KF_HOST_MATCH: W1, lan966x: is2
+ *   The action from the SMAC_SIP4 or SMAC_SIP6 lookups. Used for IP source
+ *   guarding.
  * VCAP_KF_IF_EGR_PORT_MASK: W32, sparx5: es2
  *   Egress port mask, one bit per port
  * VCAP_KF_IF_EGR_PORT_MASK_RNG: W3, sparx5: es2
  *   Select which 32 port group is available in IF_EGR_PORT (or virtual ports or
  *   CPU queue)
- * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9
+ * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9, lan966x is2 W4
  *   Sparx5: Logical ingress port number retrieved from
  *   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
  * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65,
@@ -152,8 +147,8 @@ enum vcap_keyfield_set {
  * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame has EtherType = 0x800 and IP version = 4
  * VCAP_KF_IP_MC_IS: W1, sparx5: is0
- *   Set if frame is IPv4 frame and frame’s destination MAC address is an IPv4
- *   multicast address (0x01005E0 /25). Set if frame is IPv6 frame and frame’s
+ *   Set if frame is IPv4 frame and frame's destination MAC address is an IPv4
+ *   multicast address (0x01005E0 /25). Set if frame is IPv6 frame and frame's
  *   destination MAC address is an IPv6 multicast address (0x3333/16).
  * VCAP_KF_IP_PAYLOAD_5TUPLE: W32, sparx5: is0
  *   Payload bytes after IP header
@@ -164,33 +159,49 @@ enum vcap_keyfield_set {
  * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if classified ISDX > 0
  * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
- *   Set if frame’s destination MAC address is the broadcast address
+ *   Set if frame's destination MAC address is the broadcast address
  *   (FF-FF-FF-FF-FF-FF).
  * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2, lan966x: is2
  *   Destination MAC address
+ * VCAP_KF_L2_FRM_TYPE: W4, lan966x: is2
+ *   Frame subtype for specific EtherTypes (MRP, DLR)
  * VCAP_KF_L2_FWD_IS: W1, sparx5: is2
  *   Set if the frame is allowed to be forwarded to front ports
- * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan9966x is2
- *   Set if frame’s destination MAC address is a multicast address (bit 40 = 1).
+ * VCAP_KF_L2_LLC: W40, lan966x: is2
+ *   LLC header and data after up to two VLAN tags and the type/length field
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ *   Set if frame's destination MAC address is a multicast address (bit 40 = 1).
+ * VCAP_KF_L2_PAYLOAD0: W16, lan966x: is2
+ *   Payload bytes 0-1 after the frame's EtherType
+ * VCAP_KF_L2_PAYLOAD1: W8, lan966x: is2
+ *   Payload byte 4 after the frame's EtherType. This is specifically for PTP
+ *   frames.
+ * VCAP_KF_L2_PAYLOAD2: W3, lan966x: is2
+ *   Bits 7, 2, and 1 from payload byte 6 after the frame's EtherType. This is
+ *   specifically for PTP frames.
  * VCAP_KF_L2_PAYLOAD_ETYPE: W64, sparx5: is2/es2
  *   Byte 0-7 of L2 payload after Type/Len field and overloading for OAM
- * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2, lan966x is2
+ * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2, lan966x: is2
  *   Source MAC address
+ * VCAP_KF_L2_SNAP: W40, lan966x: is2
+ *   SNAP header after LLC header (AA-AA-03)
  * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if Src IP matches Dst IP address
- * VCAP_KF_L3_DMAC_DIP_MATCH: W1, sparx5: is2
- *   Match found in DIP security lookup in ANA_L3
  * VCAP_KF_L3_DPL_CLS: W1, sparx5: es2
  *   The frames drop precedence level
  * VCAP_KF_L3_DSCP: W6, sparx5: is0
- *   Frame’s DSCP value
+ *   Frame's DSCP value
  * VCAP_KF_L3_DST_IS: W1, sparx5: is2
  *   Set if lookup is done for egress router leg
+ * VCAP_KF_L3_FRAGMENT: W1, lan966x: is2
+ *   Set if IPv4 frame is fragmented
  * VCAP_KF_L3_FRAGMENT_TYPE: W2, sparx5: is0/is2/es2
  *   L3 Fragmentation type (none, initial, suspicious, valid follow up)
  * VCAP_KF_L3_FRAG_INVLD_L4_LEN: W1, sparx5: is0/is2
  *   Set if frame's L4 length is less than ANA_CL:COMMON:CLM_FRAGMENT_CFG.L4_MIN_L
  *   EN
+ * VCAP_KF_L3_FRAG_OFS_GT0: W1, lan966x: is2
+ *   Set if IPv4 frame is fragmented and it is not the first fragment
  * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2, lan966x: is2
  *   Destination IPv4 Address
  * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2, lan966x: is2
@@ -205,36 +216,38 @@ enum vcap_keyfield_set {
  *   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
  * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if IPv4 frame contains options (IP len > 5)
- * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96,
- *   lan966x is2 W56
+ * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96, lan966x
+ *   is2 W56
  *   Sparx5: Payload bytes after IP header. IPv4: IPv4 options are not parsed so
  *   payload is always taken 20 bytes after the start of the IPv4 header, LAN966x:
  *   Bytes 0-6 after IP header
  * VCAP_KF_L3_RT_IS: W1, sparx5: is2/es2
  *   Set if frame has hit a router leg
- * VCAP_KF_L3_SMAC_SIP_MATCH: W1, sparx5: is2
- *   Match found in SIP security lookup in ANA_L3
  * VCAP_KF_L3_TOS: W8, sparx5: is2/es2, lan966x: is2
  *   Sparx5: Frame's IPv4/IPv6 DSCP and ECN fields, LAN966x: IP TOS field
  * VCAP_KF_L3_TTL_GT0: W1, sparx5: is2/es2, lan966x: is2
  *   Set if IPv4 TTL / IPv6 hop limit is greater than 0
+ * VCAP_KF_L4_1588_DOM: W8, lan966x: is2
+ *   PTP over UDP: domainNumber
+ * VCAP_KF_L4_1588_VER: W4, lan966x: is2
+ *   PTP over UDP: version
  * VCAP_KF_L4_ACK: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5 and LAN966x: TCP flag ACK, LAN966x only: PTP over UDP: flagField bit 2
  *   (unicastFlag)
  * VCAP_KF_L4_DPORT: W16, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP/UDP destination port. Overloading for IP_7TUPLE: Non-TCP/UDP IP
  *   frames: L4_DPORT = L3_IP_PROTO, LAN966x: TCP/UDP destination port
- * VCAP_KF_L4_FIN: W1, sparx5: is2/es2
+ * VCAP_KF_L4_FIN: W1, sparx5: is2/es2, lan966x: is2
  *   TCP flag FIN, LAN966x: TCP flag FIN, and for PTP over UDP: messageType bit 1
  * VCAP_KF_L4_PAYLOAD: W64, sparx5: is2/es2
  *   Payload bytes after TCP/UDP header Overloading for IP_7TUPLE: Non TCP/UDP
- *   frames: Payload bytes 0–7 after IP header. IPv4 options are not parsed so
+ *   frames: Payload bytes 0-7 after IP header. IPv4 options are not parsed so
  *   payload is always taken 20 bytes after the start of the IPv4 header for non
  *   TCP/UDP IPv4 frames
  * VCAP_KF_L4_PSH: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag PSH, LAN966x: TCP: TCP flag PSH. PTP over UDP: flagField bit
  *   1 (twoStepFlag)
- * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16, lan966x: is2
+ * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16, lan966x is2 W8
  *   Range checker bitmask (one for each range checker). Input into range checkers
  *   is taken from classified results (VID, DSCP) and frame (SPORT, DPORT, ETYPE,
  *   outer VID, inner VID)
@@ -263,58 +276,34 @@ enum vcap_keyfield_set {
  *   Select the mode of the Generic Index
  * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2, lan966x: is2
  *   Classified Policy Association Group: chains rules from IS1/CLM to IS2
+ * VCAP_KF_MIRROR_ENA: *** No docstring ***
  * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2/es2, lan966x: is2
  *   Dual-ended loss measurement counters in CCM frames are all zero
- * VCAP_KF_OAM_MEL_FLAGS: W7, sparx5: is0, lan966x: is2
+ * VCAP_KF_OAM_DETECTED: W1, lan966x: is2
+ *   This is missing in the datasheet, but present in the OAM keyset in XML
+ * VCAP_KF_OAM_FLAGS: W8, lan966x: is2
+ *   Frame's OAM flags
+ * VCAP_KF_OAM_MEL_FLAGS: W7, lan966x: is2
  *   Encoding of MD level/MEG level (MEL)
- * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is0/is2/es2, lan966x: is2
- *   Set if frame’s EtherType = 0x8902
+ * VCAP_KF_OAM_MEPID: W16, lan966x: is2
+ *   CCM frame's OAM MEP ID
+ * VCAP_KF_OAM_OPCODE: W8, lan966x: is2
+ *   Frame's OAM opcode
+ * VCAP_KF_OAM_VER: W5, lan966x: is2
+ *   Frame's OAM version
+ * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is2/es2, lan966x: is2
+ *   Set if frame's EtherType = 0x8902
  * VCAP_KF_PROT_ACTIVE: W1, sparx5: es2
  *   Protection is active
  * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
  *   header = 6)
- * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2
  *   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
  *   or 17)
  * VCAP_KF_TYPE: sparx5 is0 W2, sparx5 is0 W1, sparx5 is2 W4, sparx5 is2 W2,
- *   sparx5 es2 W3, lan966x: is2
+ *   sparx5 es2 W3, lan966x is2 W4, lan966x is2 W2
  *   Keyset type id - set by the API
- * VCAP_KF_HOST_MATCH: W1, lan966x: is2
- *   The action from the SMAC_SIP4 or SMAC_SIP6 lookups. Used for IP source
- *   guarding.
- * VCAP_KF_L2_FRM_TYPE: W4, lan966x: is2
- *   Frame subtype for specific EtherTypes (MRP, DLR)
- * VCAP_KF_L2_PAYLOAD0: W16, lan966x: is2
- *   Payload bytes 0-1 after the frame’s EtherType
- * VCAP_KF_L2_PAYLOAD1: W8, lan966x: is2
- *   Payload byte 4 after the frame’s EtherType. This is specifically for PTP
- *   frames.
- * VCAP_KF_L2_PAYLOAD2: W3, lan966x: is2
- *   Bits 7, 2, and 1 from payload byte 6 after the frame’s EtherType. This is
- *   specifically for PTP frames.
- * VCAP_KF_L2_LLC: W40, lan966x: is2
- *   LLC header and data after up to two VLAN tags and the type/length field
- * VCAP_KF_L3_FRAGMENT: W1, lan966x: is2
- *   Set if IPv4 frame is fragmented
- * VCAP_KF_L3_FRAG_OFS_GT0: W1, lan966x: is2
- *   Set if IPv4 frame is fragmented and it is not the first fragment
- * VCAP_KF_L2_SNAP: W40, lan966x: is2
- *   SNAP header after LLC header (AA-AA-03)
- * VCAP_KF_L4_1588_DOM: W8, lan966x: is2
- *   PTP over UDP: domainNumber
- * VCAP_KF_L4_1588_VER: W4, lan966x: is2
- *   PTP over UDP: version
- * VCAP_KF_OAM_MEPID: W16, lan966x: is2
- *   CCM frame’s OAM MEP ID
- * VCAP_KF_OAM_OPCODE: W8, lan966x: is2
- *   Frame’s OAM opcode
- * VCAP_KF_OAM_VER: W5, lan966x: is2
- *   Frame’s OAM version
- * VCAP_KF_OAM_FLAGS: W8, lan966x: is2
- *   Frame’s OAM flags
- * VCAP_KF_OAM_DETECTED: W1, lan966x: is2
- *   This is missing in the datasheet, but present in the OAM keyset in XML
  */
 
 /* Keyfield names */
@@ -352,11 +341,10 @@ enum vcap_key_field {
 	VCAP_KF_ARP_SENDER_MATCH_IS,
 	VCAP_KF_ARP_TGT_MATCH_IS,
 	VCAP_KF_COSID_CLS,
-	VCAP_KF_DST_ENTRY,
 	VCAP_KF_ES0_ISDX_KEY_ENA,
 	VCAP_KF_ETYPE,
 	VCAP_KF_ETYPE_LEN_IS,
-	VCAP_KF_ETYPE_MPLS,
+	VCAP_KF_HOST_MATCH,
 	VCAP_KF_IF_EGR_PORT_MASK,
 	VCAP_KF_IF_EGR_PORT_MASK_RNG,
 	VCAP_KF_IF_IGR_PORT,
@@ -373,17 +361,24 @@ enum vcap_key_field {
 	VCAP_KF_ISDX_GT0_IS,
 	VCAP_KF_L2_BC_IS,
 	VCAP_KF_L2_DMAC,
+	VCAP_KF_L2_FRM_TYPE,
 	VCAP_KF_L2_FWD_IS,
+	VCAP_KF_L2_LLC,
 	VCAP_KF_L2_MC_IS,
+	VCAP_KF_L2_PAYLOAD0,
+	VCAP_KF_L2_PAYLOAD1,
+	VCAP_KF_L2_PAYLOAD2,
 	VCAP_KF_L2_PAYLOAD_ETYPE,
 	VCAP_KF_L2_SMAC,
+	VCAP_KF_L2_SNAP,
 	VCAP_KF_L3_DIP_EQ_SIP_IS,
-	VCAP_KF_L3_DMAC_DIP_MATCH,
 	VCAP_KF_L3_DPL_CLS,
 	VCAP_KF_L3_DSCP,
 	VCAP_KF_L3_DST_IS,
+	VCAP_KF_L3_FRAGMENT,
 	VCAP_KF_L3_FRAGMENT_TYPE,
 	VCAP_KF_L3_FRAG_INVLD_L4_LEN,
+	VCAP_KF_L3_FRAG_OFS_GT0,
 	VCAP_KF_L3_IP4_DIP,
 	VCAP_KF_L3_IP4_SIP,
 	VCAP_KF_L3_IP6_DIP,
@@ -392,9 +387,10 @@ enum vcap_key_field {
 	VCAP_KF_L3_OPTIONS_IS,
 	VCAP_KF_L3_PAYLOAD,
 	VCAP_KF_L3_RT_IS,
-	VCAP_KF_L3_SMAC_SIP_MATCH,
 	VCAP_KF_L3_TOS,
 	VCAP_KF_L3_TTL_GT0,
+	VCAP_KF_L4_1588_DOM,
+	VCAP_KF_L4_1588_VER,
 	VCAP_KF_L4_ACK,
 	VCAP_KF_L4_DPORT,
 	VCAP_KF_L4_FIN,
@@ -413,28 +409,17 @@ enum vcap_key_field {
 	VCAP_KF_LOOKUP_PAG,
 	VCAP_KF_MIRROR_ENA,
 	VCAP_KF_OAM_CCM_CNTS_EQ0,
+	VCAP_KF_OAM_DETECTED,
+	VCAP_KF_OAM_FLAGS,
 	VCAP_KF_OAM_MEL_FLAGS,
+	VCAP_KF_OAM_MEPID,
+	VCAP_KF_OAM_OPCODE,
+	VCAP_KF_OAM_VER,
 	VCAP_KF_OAM_Y1731_IS,
 	VCAP_KF_PROT_ACTIVE,
 	VCAP_KF_TCP_IS,
 	VCAP_KF_TCP_UDP_IS,
 	VCAP_KF_TYPE,
-	VCAP_KF_HOST_MATCH,
-	VCAP_KF_L2_FRM_TYPE,
-	VCAP_KF_L2_PAYLOAD0,
-	VCAP_KF_L2_PAYLOAD1,
-	VCAP_KF_L2_PAYLOAD2,
-	VCAP_KF_L2_LLC,
-	VCAP_KF_L3_FRAGMENT,
-	VCAP_KF_L3_FRAG_OFS_GT0,
-	VCAP_KF_L2_SNAP,
-	VCAP_KF_L4_1588_DOM,
-	VCAP_KF_L4_1588_VER,
-	VCAP_KF_OAM_MEPID,
-	VCAP_KF_OAM_OPCODE,
-	VCAP_KF_OAM_VER,
-	VCAP_KF_OAM_FLAGS,
-	VCAP_KF_OAM_DETECTED,
 };
 
 /* Actionset names with origin information */
@@ -444,13 +429,15 @@ enum vcap_actionfield_set {
 	VCAP_AFS_CLASSIFICATION,    /* sparx5 is0 X2 */
 	VCAP_AFS_CLASS_REDUCED,     /* sparx5 is0 X1 */
 	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
-	VCAP_AFS_MLBS,              /* sparx5 is0 X2 */
-	VCAP_AFS_MLBS_REDUCED,      /* sparx5 is0 X1 */
-	VCAP_AFS_SMAC_SIP,          /* lan966x is2 x1 */
+	VCAP_AFS_SMAC_SIP,          /* lan966x is2 X1 */
 };
 
 /* List of actionfields with description
  *
+ * VCAP_AF_ACL_ID: W6, lan966x: is2
+ *   Logical ID for the entry. This ID is extracted together with the frame in the
+ *   CPU extraction header. Only applicable to actions with CPU_COPY_ENA or
+ *   HIT_ME_ONCE set.
  * VCAP_AF_CLS_VID_SEL: W3, sparx5: is0
  *   Controls the classified VID: 0: VID_NONE: No action. 1: VID_ADD: New VID =
  *   old VID + VID_VAL. 2: VID_REPLACE: New VID = VID_VAL. 3: VID_FIRST_TAG: New
@@ -488,6 +475,9 @@ enum vcap_actionfield_set {
  * VCAP_AF_ES2_REW_CMD: W3, sparx5: es2
  *   Command forwarded to REW: 0: No action. 1: SWAP MAC addresses. 2: Do L2CP
  *   DMAC translation when entering or leaving a tunnel.
+ * VCAP_AF_FWD_KILL_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 denies forwarding of the frame forwarding to any front
+ *   port. The frame can still be copied to the CPU by other actions.
  * VCAP_AF_FWD_MODE: W2, sparx5: es2
  *   Forward selector: 0: Forward. 1: Discard. 2: Redirect. 3: Copy.
  * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2/es2, lan966x: is2
@@ -496,6 +486,10 @@ enum vcap_actionfield_set {
  *   CPU_QUEUE_NUM. The HIT_CNT counter is then incremented and any frames that
  *   hit this action later are not copied to the CPU. To re-enable the HIT_ME_ONCE
  *   functionality, the HIT_CNT counter must be cleared.
+ * VCAP_AF_HOST_MATCH: W1, lan966x: is2
+ *   Used for IP source guarding. If set, it signals that the host is a valid (for
+ *   instance a valid combination of source MAC address and source IP address).
+ *   HOST_MATCH is input to the IS2 keys.
  * VCAP_AF_IGNORE_PIPELINE_CTRL: W1, sparx5: is2/es2
  *   Ignore ingress pipeline control. This enforces the use of the VCAP IS2 action
  *   even when the pipeline control has terminated the frame before VCAP IS2.
@@ -504,6 +498,9 @@ enum vcap_actionfield_set {
  * VCAP_AF_ISDX_ADD_REPLACE_SEL: W1, sparx5: is0
  *   Controls the classified ISDX. 0: New ISDX = old ISDX + ISDX_VAL. 1: New ISDX
  *   = ISDX_VAL.
+ * VCAP_AF_ISDX_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 causes the classified ISDX to be set to the value of
+ *   POLICE_IDX[8:0].
  * VCAP_AF_ISDX_VAL: W12, sparx5: is0
  *   See isdx_add_replace_sel
  * VCAP_AF_LRN_DIS: W1, sparx5: is2, lan966x: is2
@@ -521,31 +518,34 @@ enum vcap_actionfield_set {
  *   are applied to. 0: No changes to the QoS Mapping Table lookup. 1: Update key
  *   type and index for QoS Mapping Table lookup #0. 2: Update key type and index
  *   for QoS Mapping Table lookup #1. 3: Reserved.
- * VCAP_AF_MASK_MODE: W3, sparx5: is0/is2, lan966x is2 W2
+ * VCAP_AF_MASK_MODE: sparx5 is0 W3, sparx5 is2 W3, lan966x is2 W2
  *   Controls the PORT_MASK use. Sparx5: 0: OR_DSTMASK, 1: AND_VLANMASK, 2:
  *   REPLACE_PGID, 3: REPLACE_ALL, 4: REDIR_PGID, 5: OR_PGID_MASK, 6: VSTAX, 7:
  *   Not applicable. LAN966X: 0: No action, 1: Permit/deny (AND), 2: Policy
  *   forwarding (DMAC lookup), 3: Redirect. The CPU port is untouched by
  *   MASK_MODE.
- * VCAP_AF_MATCH_ID: W16, sparx5: is0/is2
+ * VCAP_AF_MATCH_ID: W16, sparx5: is2
  *   Logical ID for the entry. The MATCH_ID is extracted together with the frame
  *   if the frame is forwarded to the CPU (CPU_COPY_ENA). The result is placed in
  *   IFH.CL_RSLT.
- * VCAP_AF_MATCH_ID_MASK: W16, sparx5: is0/is2
+ * VCAP_AF_MATCH_ID_MASK: W16, sparx5: is2
  *   Mask used by MATCH_ID.
+ * VCAP_AF_MIRROR_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 causes frames to be mirrored to the mirror target port
+ *   (ANA::MIRRPORPORTS).
  * VCAP_AF_MIRROR_PROBE: W2, sparx5: is2
  *   Mirroring performed according to configuration of a mirror probe. 0: No
  *   mirroring. 1: Mirror probe 0. 2: Mirror probe 1. 3: Mirror probe 2
  * VCAP_AF_MIRROR_PROBE_ID: W2, sparx5: es2
  *   Signals a mirror probe to be placed in the IFH. Only possible when FWD_MODE
- *   is copy. 0: No mirroring. 1–3: Use mirror probe 0-2.
+ *   is copy. 0: No mirroring. 1-3: Use mirror probe 0-2.
  * VCAP_AF_NXT_IDX: W12, sparx5: is0
  *   Index used as part of key (field G_IDX) in the next lookup.
  * VCAP_AF_NXT_IDX_CTRL: W3, sparx5: is0
  *   Controls the generation of the G_IDX used in the VCAP CLM next lookup
  * VCAP_AF_PAG_OVERRIDE_MASK: W8, sparx5: is0
- *   Bits set in this mask will override PAG_VAL from port profile.  New PAG =
- *   (PAG (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
+ *   Bits set in this mask will override PAG_VAL from port profile. New PAG = (PAG
+ *   (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
  * VCAP_AF_PAG_VAL: W8, sparx5: is0
  *   See PAG_OVERRIDE_MASK.
  * VCAP_AF_PCP_ENA: W1, sparx5: is0
@@ -553,19 +553,22 @@ enum vcap_actionfield_set {
  *   classification is used.
  * VCAP_AF_PCP_VAL: W3, sparx5: is0
  *   See PCP_ENA.
- * VCAP_AF_PIPELINE_FORCE_ENA: sparx5 is0 W2, sparx5 is2 W1
+ * VCAP_AF_PIPELINE_FORCE_ENA: W1, sparx5: is2
  *   If set, use PIPELINE_PT unconditionally and set PIPELINE_ACT = NONE if
  *   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
- * VCAP_AF_PIPELINE_PT: W5, sparx5: is0/is2
+ * VCAP_AF_PIPELINE_PT: W5, sparx5: is2
  *   Pipeline point used if PIPELINE_FORCE_ENA is set
  * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes frames that hit this action to be policed by the
  *   ACL policer specified in POLICE_IDX. Only applies to the first lookup.
- * VCAP_AF_POLICE_IDX: W6, sparx5: is2/es2, lan966x: is2 W9
+ * VCAP_AF_POLICE_IDX: sparx5 is2 W6, sparx5 es2 W6, lan966x is2 W9
  *   Selects VCAP policer used when policing frames (POLICE_ENA)
  * VCAP_AF_POLICE_REMARK: W1, sparx5: es2
  *   If set, frames exceeding policer rates are marked as yellow but not
  *   discarded.
+ * VCAP_AF_POLICE_VCAP_ONLY: W1, lan966x: is2
+ *   Disable policing from QoS, and port policers. Only the VCAP policer selected
+ *   by POLICE_IDX is active. Only applies to the second lookup.
  * VCAP_AF_PORT_MASK: sparx5 is0 W65, sparx5 is2 W68, lan966x is2 W8
  *   Port mask applied to the forwarding decision based on MASK_MODE.
  * VCAP_AF_QOS_ENA: W1, sparx5: is0
@@ -573,6 +576,8 @@ enum vcap_actionfield_set {
  *   classification is used.
  * VCAP_AF_QOS_VAL: W3, sparx5: is0
  *   See QOS_ENA.
+ * VCAP_AF_REW_OP: W16, lan966x: is2
+ *   Rewriter operation command.
  * VCAP_AF_RT_DIS: W1, sparx5: is2
  *   If set, routing is disallowed. Only applies when IS_INNER_ACL is 0. See also
  *   IGR_ACL_ENA, EGR_ACL_ENA, and RLEG_STAT_IDX.
@@ -580,77 +585,34 @@ enum vcap_actionfield_set {
  *   Actionset type id - Set by the API
  * VCAP_AF_VID_VAL: W13, sparx5: is0
  *   New VID Value
- * VCAP_AF_MIRROR_ENA: W1, lan966x: is2
- *   Setting this bit to 1 causes frames to be mirrored to the mirror target
- *   port (ANA::MIRRPORPORTS).
- * VCAP_AF_POLICE_VCAP_ONLY: W1, lan966x: is2
- *   Disable policing from QoS, and port policers. Only the VCAP policer
- *   selected by POLICE_IDX is active. Only applies to the second lookup.
- * VCAP_AF_REW_OP: W16, lan966x: is2
- *   Rewriter operation command.
- * VCAP_AF_ISDX_ENA: W1, lan966x: is2
- *   Setting this bit to 1 causes the classified ISDX to be set to the value of
- *   POLICE_IDX[8:0].
- * VCAP_AF_ACL_ID: W6, lan966x: is2
- *   Logical ID for the entry. This ID is extracted together with the frame in
- *   the CPU extraction header. Only applicable to actions with CPU_COPY_ENA or
- *   HIT_ME_ONCE set.
- * VCAP_AF_FWD_KILL_ENA: W1, lan966x: is2
- *   Setting this bit to 1 denies forwarding of the frame forwarding to any
- *   front port. The frame can still be copied to the CPU by other actions.
- * VCAP_AF_HOST_MATCH: W1, lan966x: is2
- *  Used for IP source guarding. If set, it signals that the host is a valid
- *  (for instance a valid combination of source MAC address and source IP
- *  address). HOST_MATCH is input to the IS2 keys.
  */
 
 /* Actionfield names */
 enum vcap_action_field {
 	VCAP_AF_NO_VALUE,  /* initial value */
-	VCAP_AF_ACL_MAC,
-	VCAP_AF_ACL_RT_MODE,
+	VCAP_AF_ACL_ID,
 	VCAP_AF_CLS_VID_SEL,
 	VCAP_AF_CNT_ID,
 	VCAP_AF_COPY_PORT_NUM,
 	VCAP_AF_COPY_QUEUE_NUM,
-	VCAP_AF_COSID_ENA,
-	VCAP_AF_COSID_VAL,
 	VCAP_AF_CPU_COPY_ENA,
-	VCAP_AF_CPU_DIS,
-	VCAP_AF_CPU_ENA,
-	VCAP_AF_CPU_Q,
 	VCAP_AF_CPU_QUEUE_NUM,
-	VCAP_AF_CUSTOM_ACE_ENA,
-	VCAP_AF_CUSTOM_ACE_OFFSET,
 	VCAP_AF_DEI_ENA,
 	VCAP_AF_DEI_VAL,
-	VCAP_AF_DLB_OFFSET,
-	VCAP_AF_DMAC_OFFSET_ENA,
 	VCAP_AF_DP_ENA,
 	VCAP_AF_DP_VAL,
 	VCAP_AF_DSCP_ENA,
 	VCAP_AF_DSCP_VAL,
-	VCAP_AF_EGR_ACL_ENA,
 	VCAP_AF_ES2_REW_CMD,
-	VCAP_AF_FWD_DIS,
+	VCAP_AF_FWD_KILL_ENA,
 	VCAP_AF_FWD_MODE,
-	VCAP_AF_FWD_TYPE,
-	VCAP_AF_GVID_ADD_REPLACE_SEL,
 	VCAP_AF_HIT_ME_ONCE,
+	VCAP_AF_HOST_MATCH,
 	VCAP_AF_IGNORE_PIPELINE_CTRL,
-	VCAP_AF_IGR_ACL_ENA,
-	VCAP_AF_INJ_MASQ_ENA,
-	VCAP_AF_INJ_MASQ_LPORT,
-	VCAP_AF_INJ_MASQ_PORT,
 	VCAP_AF_INTR_ENA,
 	VCAP_AF_ISDX_ADD_REPLACE_SEL,
+	VCAP_AF_ISDX_ENA,
 	VCAP_AF_ISDX_VAL,
-	VCAP_AF_IS_INNER_ACL,
-	VCAP_AF_L3_MAC_UPDATE_DIS,
-	VCAP_AF_LOG_MSG_INTERVAL,
-	VCAP_AF_LPM_AFFIX_ENA,
-	VCAP_AF_LPM_AFFIX_VAL,
-	VCAP_AF_LPORT_ENA,
 	VCAP_AF_LRN_DIS,
 	VCAP_AF_MAP_IDX,
 	VCAP_AF_MAP_KEY,
@@ -658,78 +620,28 @@ enum vcap_action_field {
 	VCAP_AF_MASK_MODE,
 	VCAP_AF_MATCH_ID,
 	VCAP_AF_MATCH_ID_MASK,
-	VCAP_AF_MIP_SEL,
+	VCAP_AF_MIRROR_ENA,
 	VCAP_AF_MIRROR_PROBE,
 	VCAP_AF_MIRROR_PROBE_ID,
-	VCAP_AF_MPLS_IP_CTRL_ENA,
-	VCAP_AF_MPLS_MEP_ENA,
-	VCAP_AF_MPLS_MIP_ENA,
-	VCAP_AF_MPLS_OAM_FLAVOR,
-	VCAP_AF_MPLS_OAM_TYPE,
-	VCAP_AF_NUM_VLD_LABELS,
 	VCAP_AF_NXT_IDX,
 	VCAP_AF_NXT_IDX_CTRL,
-	VCAP_AF_NXT_KEY_TYPE,
-	VCAP_AF_NXT_NORMALIZE,
-	VCAP_AF_NXT_NORM_W16_OFFSET,
-	VCAP_AF_NXT_NORM_W32_OFFSET,
-	VCAP_AF_NXT_OFFSET_FROM_TYPE,
-	VCAP_AF_NXT_TYPE_AFTER_OFFSET,
-	VCAP_AF_OAM_IP_BFD_ENA,
-	VCAP_AF_OAM_TWAMP_ENA,
-	VCAP_AF_OAM_Y1731_SEL,
 	VCAP_AF_PAG_OVERRIDE_MASK,
 	VCAP_AF_PAG_VAL,
 	VCAP_AF_PCP_ENA,
 	VCAP_AF_PCP_VAL,
-	VCAP_AF_PIPELINE_ACT_SEL,
 	VCAP_AF_PIPELINE_FORCE_ENA,
 	VCAP_AF_PIPELINE_PT,
-	VCAP_AF_PIPELINE_PT_REDUCED,
 	VCAP_AF_POLICE_ENA,
 	VCAP_AF_POLICE_IDX,
 	VCAP_AF_POLICE_REMARK,
+	VCAP_AF_POLICE_VCAP_ONLY,
 	VCAP_AF_PORT_MASK,
-	VCAP_AF_PTP_MASTER_SEL,
 	VCAP_AF_QOS_ENA,
 	VCAP_AF_QOS_VAL,
-	VCAP_AF_REW_CMD,
-	VCAP_AF_RLEG_DMAC_CHK_DIS,
-	VCAP_AF_RLEG_STAT_IDX,
-	VCAP_AF_RSDX_ENA,
-	VCAP_AF_RSDX_VAL,
-	VCAP_AF_RSVD_LBL_VAL,
+	VCAP_AF_REW_OP,
 	VCAP_AF_RT_DIS,
-	VCAP_AF_RT_SEL,
-	VCAP_AF_S2_KEY_SEL_ENA,
-	VCAP_AF_S2_KEY_SEL_IDX,
-	VCAP_AF_SAM_SEQ_ENA,
-	VCAP_AF_SIP_IDX,
-	VCAP_AF_SWAP_MAC_ENA,
-	VCAP_AF_TCP_UDP_DPORT,
-	VCAP_AF_TCP_UDP_ENA,
-	VCAP_AF_TCP_UDP_SPORT,
-	VCAP_AF_TC_ENA,
-	VCAP_AF_TC_LABEL,
-	VCAP_AF_TPID_SEL,
-	VCAP_AF_TTL_DECR_DIS,
-	VCAP_AF_TTL_ENA,
-	VCAP_AF_TTL_LABEL,
-	VCAP_AF_TTL_UPDATE_ENA,
 	VCAP_AF_TYPE,
 	VCAP_AF_VID_VAL,
-	VCAP_AF_VLAN_POP_CNT,
-	VCAP_AF_VLAN_POP_CNT_ENA,
-	VCAP_AF_VLAN_PUSH_CNT,
-	VCAP_AF_VLAN_PUSH_CNT_ENA,
-	VCAP_AF_VLAN_WAS_TAGGED,
-	VCAP_AF_MIRROR_ENA,
-	VCAP_AF_POLICE_VCAP_ONLY,
-	VCAP_AF_REW_OP,
-	VCAP_AF_ISDX_ENA,
-	VCAP_AF_ACL_ID,
-	VCAP_AF_FWD_KILL_ENA,
-	VCAP_AF_HOST_MATCH,
 };
 
 #endif /* __VCAP_AG_API__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 82981176218c..a31cd08e3752 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -296,7 +296,7 @@ test_vcap_xn_rule_creator(struct kunit *test, int cid, enum vcap_user user,
 	ret = vcap_set_rule_set_keyset(rule, keyset);
 
 	/* Add rule actions : there must be at least one action */
-	ret = vcap_rule_add_action_u32(rule, VCAP_AF_COSID_VAL, 0);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_ISDX_VAL, 0);
 
 	/* Override rule actionset */
 	ret = vcap_set_rule_set_actionset(rule, actionset);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
index 5d681d2697cd..85a8d8566aa2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
@@ -10,177 +10,6 @@
 #include "vcap_model_kunit.h"
 
 /* keyfields */
-static const struct vcap_field is0_mll_keyfield[] = {
-	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 0,
-		.width = 2,
-	},
-	[VCAP_KF_LOOKUP_FIRST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 2,
-		.width = 1,
-	},
-	[VCAP_KF_IF_IGR_PORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 3,
-		.width = 7,
-	},
-	[VCAP_KF_8021Q_VLAN_TAGS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 10,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_TPID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 13,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_VID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 16,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_TPID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 28,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_VID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 31,
-		.width = 12,
-	},
-	[VCAP_KF_L2_DMAC] = {
-		.type = VCAP_FIELD_U48,
-		.offset = 43,
-		.width = 48,
-	},
-	[VCAP_KF_L2_SMAC] = {
-		.type = VCAP_FIELD_U48,
-		.offset = 91,
-		.width = 48,
-	},
-	[VCAP_KF_ETYPE_MPLS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 139,
-		.width = 2,
-	},
-	[VCAP_KF_L4_RNG] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 141,
-		.width = 8,
-	},
-};
-
-static const struct vcap_field is0_tri_vid_keyfield[] = {
-	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 0,
-		.width = 2,
-	},
-	[VCAP_KF_LOOKUP_FIRST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 2,
-		.width = 1,
-	},
-	[VCAP_KF_IF_IGR_PORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 3,
-		.width = 7,
-	},
-	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 10,
-		.width = 2,
-	},
-	[VCAP_KF_LOOKUP_GEN_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 12,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_VLAN_TAGS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 24,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_TPID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 27,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 30,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI0] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 33,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 34,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_TPID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 46,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 49,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI1] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 52,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 53,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_TPID2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 65,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 68,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI2] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 71,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 72,
-		.width = 12,
-	},
-	[VCAP_KF_L4_RNG] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 84,
-		.width = 8,
-	},
-	[VCAP_KF_OAM_Y1731_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 92,
-		.width = 1,
-	},
-	[VCAP_KF_OAM_MEL_FLAGS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 93,
-		.width = 7,
-	},
-};
-
 static const struct vcap_field is0_ll_full_keyfield[] = {
 	[VCAP_KF_TYPE] = {
 		.type = VCAP_FIELD_U32,
@@ -344,396 +173,208 @@ static const struct vcap_field is0_ll_full_keyfield[] = {
 	},
 };
 
-static const struct vcap_field is0_normal_keyfield[] = {
+static const struct vcap_field is0_normal_7tuple_keyfield[] = {
 	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_U32,
+		.type = VCAP_FIELD_BIT,
 		.offset = 0,
-		.width = 2,
+		.width = 1,
 	},
 	[VCAP_KF_LOOKUP_FIRST_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 2,
+		.offset = 1,
 		.width = 1,
 	},
 	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 3,
+		.offset = 2,
 		.width = 2,
 	},
 	[VCAP_KF_LOOKUP_GEN_IDX] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 5,
+		.offset = 4,
 		.width = 12,
 	},
 	[VCAP_KF_IF_IGR_PORT_MASK_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 17,
+		.offset = 16,
 		.width = 2,
 	},
 	[VCAP_KF_IF_IGR_PORT_MASK] = {
 		.type = VCAP_FIELD_U72,
-		.offset = 19,
+		.offset = 18,
 		.width = 65,
 	},
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 84,
+		.offset = 83,
 		.width = 1,
 	},
 	[VCAP_KF_L2_BC_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 85,
+		.offset = 84,
 		.width = 1,
 	},
 	[VCAP_KF_8021Q_VLAN_TAGS] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 86,
+		.offset = 85,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_TPID0] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 89,
+		.offset = 88,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_PCP0] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 92,
+		.offset = 91,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_DEI0] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 95,
+		.offset = 94,
 		.width = 1,
 	},
 	[VCAP_KF_8021Q_VID0] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 96,
+		.offset = 95,
 		.width = 12,
 	},
 	[VCAP_KF_8021Q_TPID1] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 108,
+		.offset = 107,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_PCP1] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 111,
+		.offset = 110,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_DEI1] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 114,
+		.offset = 113,
 		.width = 1,
 	},
 	[VCAP_KF_8021Q_VID1] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 115,
+		.offset = 114,
 		.width = 12,
 	},
 	[VCAP_KF_8021Q_TPID2] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 127,
+		.offset = 126,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_PCP2] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 130,
+		.offset = 129,
 		.width = 3,
 	},
 	[VCAP_KF_8021Q_DEI2] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 133,
+		.offset = 132,
 		.width = 1,
 	},
 	[VCAP_KF_8021Q_VID2] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 134,
+		.offset = 133,
 		.width = 12,
 	},
-	[VCAP_KF_DST_ENTRY] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 146,
-		.width = 1,
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 145,
+		.width = 48,
 	},
 	[VCAP_KF_L2_SMAC] = {
 		.type = VCAP_FIELD_U48,
-		.offset = 147,
+		.offset = 193,
 		.width = 48,
 	},
 	[VCAP_KF_IP_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 195,
+		.offset = 241,
 		.width = 1,
 	},
 	[VCAP_KF_ETYPE_LEN_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 196,
+		.offset = 242,
 		.width = 1,
 	},
 	[VCAP_KF_ETYPE] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 197,
+		.offset = 243,
 		.width = 16,
 	},
 	[VCAP_KF_IP_SNAP_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 213,
+		.offset = 259,
 		.width = 1,
 	},
 	[VCAP_KF_IP4_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 214,
+		.offset = 260,
 		.width = 1,
 	},
 	[VCAP_KF_L3_FRAGMENT_TYPE] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 215,
+		.offset = 261,
 		.width = 2,
 	},
 	[VCAP_KF_L3_FRAG_INVLD_L4_LEN] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 217,
+		.offset = 263,
 		.width = 1,
 	},
 	[VCAP_KF_L3_OPTIONS_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 218,
+		.offset = 264,
 		.width = 1,
 	},
 	[VCAP_KF_L3_DSCP] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 219,
+		.offset = 265,
 		.width = 6,
 	},
-	[VCAP_KF_L3_IP4_SIP] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 225,
-		.width = 32,
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 271,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 399,
+		.width = 128,
 	},
 	[VCAP_KF_TCP_UDP_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 257,
+		.offset = 527,
 		.width = 1,
 	},
 	[VCAP_KF_TCP_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 258,
+		.offset = 528,
 		.width = 1,
 	},
 	[VCAP_KF_L4_SPORT] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 259,
+		.offset = 529,
 		.width = 16,
 	},
 	[VCAP_KF_L4_RNG] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 275,
+		.offset = 545,
 		.width = 8,
 	},
 };
 
-static const struct vcap_field is0_normal_7tuple_keyfield[] = {
+static const struct vcap_field is0_normal_5tuple_ip4_keyfield[] = {
 	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_BIT,
+		.type = VCAP_FIELD_U32,
 		.offset = 0,
-		.width = 1,
+		.width = 2,
 	},
 	[VCAP_KF_LOOKUP_FIRST_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 1,
-		.width = 1,
-	},
-	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 2,
-		.width = 2,
-	},
-	[VCAP_KF_LOOKUP_GEN_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 4,
-		.width = 12,
-	},
-	[VCAP_KF_IF_IGR_PORT_MASK_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 16,
-		.width = 2,
-	},
-	[VCAP_KF_IF_IGR_PORT_MASK] = {
-		.type = VCAP_FIELD_U72,
-		.offset = 18,
-		.width = 65,
-	},
-	[VCAP_KF_L2_MC_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 83,
-		.width = 1,
-	},
-	[VCAP_KF_L2_BC_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 84,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VLAN_TAGS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 85,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_TPID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 88,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 91,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI0] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 94,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID0] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 95,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_TPID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 107,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 110,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI1] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 113,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID1] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 114,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_TPID2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 126,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_PCP2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 129,
-		.width = 3,
-	},
-	[VCAP_KF_8021Q_DEI2] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 132,
-		.width = 1,
-	},
-	[VCAP_KF_8021Q_VID2] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 133,
-		.width = 12,
-	},
-	[VCAP_KF_L2_DMAC] = {
-		.type = VCAP_FIELD_U48,
-		.offset = 145,
-		.width = 48,
-	},
-	[VCAP_KF_L2_SMAC] = {
-		.type = VCAP_FIELD_U48,
-		.offset = 193,
-		.width = 48,
-	},
-	[VCAP_KF_IP_MC_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 241,
-		.width = 1,
-	},
-	[VCAP_KF_ETYPE_LEN_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 242,
-		.width = 1,
-	},
-	[VCAP_KF_ETYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 243,
-		.width = 16,
-	},
-	[VCAP_KF_IP_SNAP_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 259,
-		.width = 1,
-	},
-	[VCAP_KF_IP4_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 260,
-		.width = 1,
-	},
-	[VCAP_KF_L3_FRAGMENT_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 261,
-		.width = 2,
-	},
-	[VCAP_KF_L3_FRAG_INVLD_L4_LEN] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 263,
-		.width = 1,
-	},
-	[VCAP_KF_L3_OPTIONS_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 264,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DSCP] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 265,
-		.width = 6,
-	},
-	[VCAP_KF_L3_IP6_DIP] = {
-		.type = VCAP_FIELD_U128,
-		.offset = 271,
-		.width = 128,
-	},
-	[VCAP_KF_L3_IP6_SIP] = {
-		.type = VCAP_FIELD_U128,
-		.offset = 399,
-		.width = 128,
-	},
-	[VCAP_KF_TCP_UDP_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 527,
-		.width = 1,
-	},
-	[VCAP_KF_TCP_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 528,
-		.width = 1,
-	},
-	[VCAP_KF_L4_SPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 529,
-		.width = 16,
-	},
-	[VCAP_KF_L4_RNG] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 545,
-		.width = 8,
-	},
-};
-
-static const struct vcap_field is0_normal_5tuple_ip4_keyfield[] = {
-	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 0,
-		.width = 2,
-	},
-	[VCAP_KF_LOOKUP_FIRST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 2,
+		.offset = 2,
 		.width = 1,
 	},
 	[VCAP_KF_LOOKUP_GEN_IDX_SEL] = {
@@ -1095,16 +736,6 @@ static const struct vcap_field is2_mac_etype_keyfield[] = {
 		.offset = 85,
 		.width = 1,
 	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 86,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 87,
-		.width = 1,
-	},
 	[VCAP_KF_L3_RT_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 88,
@@ -1381,16 +1012,6 @@ static const struct vcap_field is2_ip4_tcp_udp_keyfield[] = {
 		.offset = 85,
 		.width = 1,
 	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 86,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 87,
-		.width = 1,
-	},
 	[VCAP_KF_L3_RT_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 88,
@@ -1594,16 +1215,6 @@ static const struct vcap_field is2_ip4_other_keyfield[] = {
 		.offset = 85,
 		.width = 1,
 	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 86,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 87,
-		.width = 1,
-	},
 	[VCAP_KF_L3_RT_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 88,
@@ -1757,26 +1368,11 @@ static const struct vcap_field is2_ip6_std_keyfield[] = {
 		.offset = 85,
 		.width = 1,
 	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 86,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 87,
-		.width = 1,
-	},
 	[VCAP_KF_L3_RT_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 88,
 		.width = 1,
 	},
-	[VCAP_KF_L3_DST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 89,
-		.width = 1,
-	},
 	[VCAP_KF_L3_TTL_GT0] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 90,
@@ -1890,16 +1486,6 @@ static const struct vcap_field is2_ip_7tuple_keyfield[] = {
 		.offset = 116,
 		.width = 1,
 	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 117,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 118,
-		.width = 1,
-	},
 	[VCAP_KF_L3_RT_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 119,
@@ -2022,91 +1608,28 @@ static const struct vcap_field is2_ip_7tuple_keyfield[] = {
 	},
 };
 
-static const struct vcap_field is2_ip6_vid_keyfield[] = {
+static const struct vcap_field es2_mac_etype_keyfield[] = {
 	[VCAP_KF_TYPE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 0,
-		.width = 4,
+		.width = 3,
 	},
 	[VCAP_KF_LOOKUP_FIRST_IS] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 4,
+		.offset = 3,
 		.width = 1,
 	},
-	[VCAP_KF_LOOKUP_PAG] = {
+	[VCAP_KF_ACL_GRP_ID] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 5,
+		.offset = 4,
 		.width = 8,
 	},
-	[VCAP_KF_ISDX_GT0_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 13,
-		.width = 1,
-	},
-	[VCAP_KF_ISDX_CLS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 14,
-		.width = 12,
-	},
-	[VCAP_KF_8021Q_VID_CLS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 26,
-		.width = 13,
-	},
-	[VCAP_KF_L3_SMAC_SIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 39,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DMAC_DIP_MATCH] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 40,
-		.width = 1,
-	},
-	[VCAP_KF_L3_RT_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 41,
-		.width = 1,
-	},
-	[VCAP_KF_L3_DST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 42,
-		.width = 1,
-	},
-	[VCAP_KF_L3_IP6_DIP] = {
-		.type = VCAP_FIELD_U128,
-		.offset = 43,
-		.width = 128,
-	},
-	[VCAP_KF_L3_IP6_SIP] = {
-		.type = VCAP_FIELD_U128,
-		.offset = 171,
-		.width = 128,
-	},
-};
-
-static const struct vcap_field es2_mac_etype_keyfield[] = {
-	[VCAP_KF_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 0,
-		.width = 3,
-	},
-	[VCAP_KF_LOOKUP_FIRST_IS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 3,
-		.width = 1,
-	},
-	[VCAP_KF_ACL_GRP_ID] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 4,
-		.width = 8,
-	},
-	[VCAP_KF_PROT_ACTIVE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 12,
-		.width = 1,
-	},
-	[VCAP_KF_L2_MC_IS] = {
+	[VCAP_KF_PROT_ACTIVE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 13,
 		.width = 1,
@@ -3143,26 +2666,11 @@ static const struct vcap_field es2_ip6_vid_keyfield[] = {
 
 /* keyfield_set */
 static const struct vcap_set is0_keyfield_set[] = {
-	[VCAP_KFS_MLL] = {
-		.type_id = 0,
-		.sw_per_item = 3,
-		.sw_cnt = 4,
-	},
-	[VCAP_KFS_TRI_VID] = {
-		.type_id = 0,
-		.sw_per_item = 2,
-		.sw_cnt = 6,
-	},
 	[VCAP_KFS_LL_FULL] = {
 		.type_id = 0,
 		.sw_per_item = 6,
 		.sw_cnt = 2,
 	},
-	[VCAP_KFS_NORMAL] = {
-		.type_id = 1,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
-	},
 	[VCAP_KFS_NORMAL_7TUPLE] = {
 		.type_id = 0,
 		.sw_per_item = 12,
@@ -3216,11 +2724,6 @@ static const struct vcap_set is2_keyfield_set[] = {
 		.sw_per_item = 12,
 		.sw_cnt = 1,
 	},
-	[VCAP_KFS_IP6_VID] = {
-		.type_id = 9,
-		.sw_per_item = 6,
-		.sw_cnt = 2,
-	},
 };
 
 static const struct vcap_set es2_keyfield_set[] = {
@@ -3263,10 +2766,7 @@ static const struct vcap_set es2_keyfield_set[] = {
 
 /* keyfield_set map */
 static const struct vcap_field *is0_keyfield_set_map[] = {
-	[VCAP_KFS_MLL] = is0_mll_keyfield,
-	[VCAP_KFS_TRI_VID] = is0_tri_vid_keyfield,
 	[VCAP_KFS_LL_FULL] = is0_ll_full_keyfield,
-	[VCAP_KFS_NORMAL] = is0_normal_keyfield,
 	[VCAP_KFS_NORMAL_7TUPLE] = is0_normal_7tuple_keyfield,
 	[VCAP_KFS_NORMAL_5TUPLE_IP4] = is0_normal_5tuple_ip4_keyfield,
 	[VCAP_KFS_PURE_5TUPLE_IP4] = is0_pure_5tuple_ip4_keyfield,
@@ -3280,7 +2780,6 @@ static const struct vcap_field *is2_keyfield_set_map[] = {
 	[VCAP_KFS_IP4_OTHER] = is2_ip4_other_keyfield,
 	[VCAP_KFS_IP6_STD] = is2_ip6_std_keyfield,
 	[VCAP_KFS_IP_7TUPLE] = is2_ip_7tuple_keyfield,
-	[VCAP_KFS_IP6_VID] = is2_ip6_vid_keyfield,
 };
 
 static const struct vcap_field *es2_keyfield_set_map[] = {
@@ -3295,10 +2794,7 @@ static const struct vcap_field *es2_keyfield_set_map[] = {
 
 /* keyfield_set map sizes */
 static int is0_keyfield_set_map_size[] = {
-	[VCAP_KFS_MLL] = ARRAY_SIZE(is0_mll_keyfield),
-	[VCAP_KFS_TRI_VID] = ARRAY_SIZE(is0_tri_vid_keyfield),
 	[VCAP_KFS_LL_FULL] = ARRAY_SIZE(is0_ll_full_keyfield),
-	[VCAP_KFS_NORMAL] = ARRAY_SIZE(is0_normal_keyfield),
 	[VCAP_KFS_NORMAL_7TUPLE] = ARRAY_SIZE(is0_normal_7tuple_keyfield),
 	[VCAP_KFS_NORMAL_5TUPLE_IP4] = ARRAY_SIZE(is0_normal_5tuple_ip4_keyfield),
 	[VCAP_KFS_PURE_5TUPLE_IP4] = ARRAY_SIZE(is0_pure_5tuple_ip4_keyfield),
@@ -3312,7 +2808,6 @@ static int is2_keyfield_set_map_size[] = {
 	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(is2_ip4_other_keyfield),
 	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(is2_ip6_std_keyfield),
 	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(is2_ip_7tuple_keyfield),
-	[VCAP_KFS_IP6_VID] = ARRAY_SIZE(is2_ip6_vid_keyfield),
 };
 
 static int es2_keyfield_set_map_size[] = {
@@ -3326,1027 +2821,226 @@ static int es2_keyfield_set_map_size[] = {
 };
 
 /* actionfields */
-static const struct vcap_field is0_mlbs_actionfield[] = {
+static const struct vcap_field is0_classification_actionfield[] = {
 	[VCAP_AF_TYPE] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 0,
 		.width = 1,
 	},
-	[VCAP_AF_COSID_ENA] = {
+	[VCAP_AF_DSCP_ENA] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 1,
 		.width = 1,
 	},
-	[VCAP_AF_COSID_VAL] = {
+	[VCAP_AF_DSCP_VAL] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 2,
-		.width = 3,
+		.width = 6,
 	},
 	[VCAP_AF_QOS_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 5,
+		.offset = 12,
 		.width = 1,
 	},
 	[VCAP_AF_QOS_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 6,
+		.offset = 13,
 		.width = 3,
 	},
 	[VCAP_AF_DP_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 9,
+		.offset = 16,
 		.width = 1,
 	},
 	[VCAP_AF_DP_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 10,
+		.offset = 17,
 		.width = 2,
 	},
+	[VCAP_AF_DEI_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_AF_DEI_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 20,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 21,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 22,
+		.width = 3,
+	},
 	[VCAP_AF_MAP_LOOKUP_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 12,
+		.offset = 25,
 		.width = 2,
 	},
 	[VCAP_AF_MAP_KEY] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 14,
+		.offset = 27,
 		.width = 3,
 	},
 	[VCAP_AF_MAP_IDX] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 17,
+		.offset = 30,
 		.width = 9,
 	},
 	[VCAP_AF_CLS_VID_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 26,
-		.width = 3,
-	},
-	[VCAP_AF_GVID_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 29,
+		.offset = 39,
 		.width = 3,
 	},
 	[VCAP_AF_VID_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 32,
+		.offset = 45,
 		.width = 13,
 	},
 	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 45,
+		.offset = 68,
 		.width = 1,
 	},
 	[VCAP_AF_ISDX_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 46,
+		.offset = 69,
 		.width = 12,
 	},
-	[VCAP_AF_FWD_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 58,
-		.width = 1,
+	[VCAP_AF_PAG_OVERRIDE_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 109,
+		.width = 8,
 	},
-	[VCAP_AF_CPU_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 59,
-		.width = 1,
+	[VCAP_AF_PAG_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 117,
+		.width = 8,
 	},
-	[VCAP_AF_CPU_Q] = {
+	[VCAP_AF_NXT_IDX_CTRL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 60,
+		.offset = 171,
 		.width = 3,
 	},
-	[VCAP_AF_OAM_Y1731_SEL] = {
+	[VCAP_AF_NXT_IDX] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 63,
-		.width = 3,
+		.offset = 174,
+		.width = 12,
 	},
-	[VCAP_AF_OAM_TWAMP_ENA] = {
+};
+
+static const struct vcap_field is0_full_actionfield[] = {
+	[VCAP_AF_DSCP_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 66,
+		.offset = 0,
 		.width = 1,
 	},
-	[VCAP_AF_OAM_IP_BFD_ENA] = {
+	[VCAP_AF_DSCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 6,
+	},
+	[VCAP_AF_QOS_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 67,
+		.offset = 11,
 		.width = 1,
 	},
-	[VCAP_AF_TC_LABEL] = {
+	[VCAP_AF_QOS_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 68,
+		.offset = 12,
 		.width = 3,
 	},
-	[VCAP_AF_TTL_LABEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 71,
-		.width = 3,
+	[VCAP_AF_DP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
 	},
-	[VCAP_AF_NUM_VLD_LABELS] = {
+	[VCAP_AF_DP_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 74,
+		.offset = 16,
 		.width = 2,
 	},
-	[VCAP_AF_FWD_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 76,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_OAM_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 79,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_MEP_ENA] = {
+	[VCAP_AF_DEI_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 82,
+		.offset = 18,
 		.width = 1,
 	},
-	[VCAP_AF_MPLS_MIP_ENA] = {
+	[VCAP_AF_DEI_VAL] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 83,
+		.offset = 19,
 		.width = 1,
 	},
-	[VCAP_AF_MPLS_OAM_FLAVOR] = {
+	[VCAP_AF_PCP_ENA] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 84,
+		.offset = 20,
 		.width = 1,
 	},
-	[VCAP_AF_MPLS_IP_CTRL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 85,
-		.width = 1,
+	[VCAP_AF_PCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 21,
+		.width = 3,
 	},
-	[VCAP_AF_PAG_OVERRIDE_MASK] = {
+	[VCAP_AF_MAP_LOOKUP_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 86,
-		.width = 8,
+		.offset = 24,
+		.width = 2,
 	},
-	[VCAP_AF_PAG_VAL] = {
+	[VCAP_AF_MAP_KEY] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 94,
-		.width = 8,
+		.offset = 26,
+		.width = 3,
 	},
-	[VCAP_AF_S2_KEY_SEL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 102,
-		.width = 1,
+	[VCAP_AF_MAP_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 9,
 	},
-	[VCAP_AF_S2_KEY_SEL_IDX] = {
+	[VCAP_AF_CLS_VID_SEL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 103,
-		.width = 6,
+		.offset = 38,
+		.width = 3,
 	},
-	[VCAP_AF_PIPELINE_FORCE_ENA] = {
+	[VCAP_AF_VID_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 109,
-		.width = 2,
+		.offset = 44,
+		.width = 13,
 	},
-	[VCAP_AF_PIPELINE_ACT_SEL] = {
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
 		.type = VCAP_FIELD_BIT,
-		.offset = 111,
+		.offset = 67,
 		.width = 1,
 	},
-	[VCAP_AF_PIPELINE_PT] = {
+	[VCAP_AF_ISDX_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 112,
-		.width = 5,
+		.offset = 68,
+		.width = 12,
 	},
-	[VCAP_AF_NXT_KEY_TYPE] = {
+	[VCAP_AF_MASK_MODE] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 117,
-		.width = 5,
+		.offset = 80,
+		.width = 3,
+	},
+	[VCAP_AF_PORT_MASK] = {
+		.type = VCAP_FIELD_U72,
+		.offset = 83,
+		.width = 65,
 	},
-	[VCAP_AF_NXT_NORM_W16_OFFSET] = {
+	[VCAP_AF_PAG_OVERRIDE_MASK] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 122,
-		.width = 5,
+		.offset = 204,
+		.width = 8,
 	},
-	[VCAP_AF_NXT_OFFSET_FROM_TYPE] = {
+	[VCAP_AF_PAG_VAL] = {
 		.type = VCAP_FIELD_U32,
-		.offset = 127,
-		.width = 2,
+		.offset = 212,
+		.width = 8,
 	},
-	[VCAP_AF_NXT_TYPE_AFTER_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 129,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_NORMALIZE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 131,
-		.width = 1,
-	},
-	[VCAP_AF_NXT_IDX_CTRL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 132,
-		.width = 3,
-	},
-	[VCAP_AF_NXT_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 135,
-		.width = 12,
-	},
-};
-
-static const struct vcap_field is0_mlbs_reduced_actionfield[] = {
-	[VCAP_AF_TYPE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 0,
-		.width = 1,
-	},
-	[VCAP_AF_COSID_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 1,
-		.width = 1,
-	},
-	[VCAP_AF_COSID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 2,
-		.width = 3,
-	},
-	[VCAP_AF_QOS_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 5,
-		.width = 1,
-	},
-	[VCAP_AF_QOS_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 6,
-		.width = 3,
-	},
-	[VCAP_AF_DP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 9,
-		.width = 1,
-	},
-	[VCAP_AF_DP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 10,
-		.width = 2,
-	},
-	[VCAP_AF_MAP_LOOKUP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 12,
-		.width = 2,
-	},
-	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 14,
-		.width = 1,
-	},
-	[VCAP_AF_ISDX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 15,
-		.width = 12,
-	},
-	[VCAP_AF_FWD_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 27,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 28,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_Q] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 29,
-		.width = 3,
-	},
-	[VCAP_AF_TC_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 32,
-		.width = 1,
-	},
-	[VCAP_AF_TTL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 33,
-		.width = 1,
-	},
-	[VCAP_AF_FWD_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 34,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_OAM_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 37,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_MEP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 40,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_MIP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 41,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_OAM_FLAVOR] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 42,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_IP_CTRL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 43,
-		.width = 1,
-	},
-	[VCAP_AF_PIPELINE_FORCE_ENA] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 44,
-		.width = 2,
-	},
-	[VCAP_AF_PIPELINE_ACT_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 46,
-		.width = 1,
-	},
-	[VCAP_AF_PIPELINE_PT_REDUCED] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 47,
-		.width = 3,
-	},
-	[VCAP_AF_NXT_KEY_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 50,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_NORM_W32_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 55,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_TYPE_AFTER_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 57,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_NORMALIZE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 59,
-		.width = 1,
-	},
-	[VCAP_AF_NXT_IDX_CTRL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 60,
-		.width = 3,
-	},
-	[VCAP_AF_NXT_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 63,
-		.width = 12,
-	},
-};
-
-static const struct vcap_field is0_classification_actionfield[] = {
-	[VCAP_AF_TYPE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 0,
-		.width = 1,
-	},
-	[VCAP_AF_DSCP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 1,
-		.width = 1,
-	},
-	[VCAP_AF_DSCP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 2,
-		.width = 6,
-	},
-	[VCAP_AF_COSID_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 8,
-		.width = 1,
-	},
-	[VCAP_AF_COSID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 9,
-		.width = 3,
-	},
-	[VCAP_AF_QOS_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 12,
-		.width = 1,
-	},
-	[VCAP_AF_QOS_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 13,
-		.width = 3,
-	},
-	[VCAP_AF_DP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 16,
-		.width = 1,
-	},
-	[VCAP_AF_DP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 17,
-		.width = 2,
-	},
-	[VCAP_AF_DEI_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 19,
-		.width = 1,
-	},
-	[VCAP_AF_DEI_VAL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 20,
-		.width = 1,
-	},
-	[VCAP_AF_PCP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 21,
-		.width = 1,
-	},
-	[VCAP_AF_PCP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 22,
-		.width = 3,
-	},
-	[VCAP_AF_MAP_LOOKUP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 25,
-		.width = 2,
-	},
-	[VCAP_AF_MAP_KEY] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 27,
-		.width = 3,
-	},
-	[VCAP_AF_MAP_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 30,
-		.width = 9,
-	},
-	[VCAP_AF_CLS_VID_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 39,
-		.width = 3,
-	},
-	[VCAP_AF_GVID_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 42,
-		.width = 3,
-	},
-	[VCAP_AF_VID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 45,
-		.width = 13,
-	},
-	[VCAP_AF_VLAN_POP_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 58,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_POP_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 59,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 61,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 62,
-		.width = 2,
-	},
-	[VCAP_AF_TPID_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 64,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_WAS_TAGGED] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 66,
-		.width = 2,
-	},
-	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 68,
-		.width = 1,
-	},
-	[VCAP_AF_ISDX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 69,
-		.width = 12,
-	},
-	[VCAP_AF_RT_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 81,
-		.width = 2,
-	},
-	[VCAP_AF_LPM_AFFIX_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 83,
-		.width = 1,
-	},
-	[VCAP_AF_LPM_AFFIX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 84,
-		.width = 10,
-	},
-	[VCAP_AF_RLEG_DMAC_CHK_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 94,
-		.width = 1,
-	},
-	[VCAP_AF_TTL_DECR_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 95,
-		.width = 1,
-	},
-	[VCAP_AF_L3_MAC_UPDATE_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 96,
-		.width = 1,
-	},
-	[VCAP_AF_FWD_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 97,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 98,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_Q] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 99,
-		.width = 3,
-	},
-	[VCAP_AF_MIP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 102,
-		.width = 2,
-	},
-	[VCAP_AF_OAM_Y1731_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 104,
-		.width = 3,
-	},
-	[VCAP_AF_OAM_TWAMP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 107,
-		.width = 1,
-	},
-	[VCAP_AF_OAM_IP_BFD_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 108,
-		.width = 1,
-	},
-	[VCAP_AF_PAG_OVERRIDE_MASK] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 109,
-		.width = 8,
-	},
-	[VCAP_AF_PAG_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 117,
-		.width = 8,
-	},
-	[VCAP_AF_S2_KEY_SEL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 125,
-		.width = 1,
-	},
-	[VCAP_AF_S2_KEY_SEL_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 126,
-		.width = 6,
-	},
-	[VCAP_AF_INJ_MASQ_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 132,
-		.width = 1,
-	},
-	[VCAP_AF_INJ_MASQ_PORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 133,
-		.width = 7,
-	},
-	[VCAP_AF_LPORT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 140,
-		.width = 1,
-	},
-	[VCAP_AF_INJ_MASQ_LPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 141,
-		.width = 7,
-	},
-	[VCAP_AF_PIPELINE_FORCE_ENA] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 148,
-		.width = 2,
-	},
-	[VCAP_AF_PIPELINE_ACT_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 150,
-		.width = 1,
-	},
-	[VCAP_AF_PIPELINE_PT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 151,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_KEY_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 156,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_NORM_W16_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 161,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_OFFSET_FROM_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 166,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_TYPE_AFTER_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 168,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_NORMALIZE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 170,
-		.width = 1,
-	},
-	[VCAP_AF_NXT_IDX_CTRL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 171,
-		.width = 3,
-	},
-	[VCAP_AF_NXT_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 174,
-		.width = 12,
-	},
-};
-
-static const struct vcap_field is0_full_actionfield[] = {
-	[VCAP_AF_DSCP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 0,
-		.width = 1,
-	},
-	[VCAP_AF_DSCP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 1,
-		.width = 6,
-	},
-	[VCAP_AF_COSID_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 7,
-		.width = 1,
-	},
-	[VCAP_AF_COSID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 8,
-		.width = 3,
-	},
-	[VCAP_AF_QOS_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 11,
-		.width = 1,
-	},
-	[VCAP_AF_QOS_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 12,
-		.width = 3,
-	},
-	[VCAP_AF_DP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 15,
-		.width = 1,
-	},
-	[VCAP_AF_DP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 16,
-		.width = 2,
-	},
-	[VCAP_AF_DEI_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 18,
-		.width = 1,
-	},
-	[VCAP_AF_DEI_VAL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 19,
-		.width = 1,
-	},
-	[VCAP_AF_PCP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 20,
-		.width = 1,
-	},
-	[VCAP_AF_PCP_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 21,
-		.width = 3,
-	},
-	[VCAP_AF_MAP_LOOKUP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 24,
-		.width = 2,
-	},
-	[VCAP_AF_MAP_KEY] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 26,
-		.width = 3,
-	},
-	[VCAP_AF_MAP_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 29,
-		.width = 9,
-	},
-	[VCAP_AF_CLS_VID_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 38,
-		.width = 3,
-	},
-	[VCAP_AF_GVID_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 41,
-		.width = 3,
-	},
-	[VCAP_AF_VID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 44,
-		.width = 13,
-	},
-	[VCAP_AF_VLAN_POP_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 57,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_POP_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 58,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 60,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 61,
-		.width = 2,
-	},
-	[VCAP_AF_TPID_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 63,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_WAS_TAGGED] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 65,
-		.width = 2,
-	},
-	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 67,
-		.width = 1,
-	},
-	[VCAP_AF_ISDX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 68,
-		.width = 12,
-	},
-	[VCAP_AF_MASK_MODE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 80,
-		.width = 3,
-	},
-	[VCAP_AF_PORT_MASK] = {
-		.type = VCAP_FIELD_U72,
-		.offset = 83,
-		.width = 65,
-	},
-	[VCAP_AF_RT_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 148,
-		.width = 2,
-	},
-	[VCAP_AF_LPM_AFFIX_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 150,
-		.width = 1,
-	},
-	[VCAP_AF_LPM_AFFIX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 151,
-		.width = 10,
-	},
-	[VCAP_AF_RLEG_DMAC_CHK_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 161,
-		.width = 1,
-	},
-	[VCAP_AF_TTL_DECR_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 162,
-		.width = 1,
-	},
-	[VCAP_AF_L3_MAC_UPDATE_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 163,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 164,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_Q] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 165,
-		.width = 3,
-	},
-	[VCAP_AF_MIP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 168,
-		.width = 2,
-	},
-	[VCAP_AF_OAM_Y1731_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 170,
-		.width = 3,
-	},
-	[VCAP_AF_OAM_TWAMP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 173,
-		.width = 1,
-	},
-	[VCAP_AF_OAM_IP_BFD_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 174,
-		.width = 1,
-	},
-	[VCAP_AF_RSVD_LBL_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 175,
-		.width = 4,
-	},
-	[VCAP_AF_TC_LABEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 179,
-		.width = 3,
-	},
-	[VCAP_AF_TTL_LABEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 182,
-		.width = 3,
-	},
-	[VCAP_AF_NUM_VLD_LABELS] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 185,
-		.width = 2,
-	},
-	[VCAP_AF_FWD_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 187,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_OAM_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 190,
-		.width = 3,
-	},
-	[VCAP_AF_MPLS_MEP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 193,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_MIP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 194,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_OAM_FLAVOR] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 195,
-		.width = 1,
-	},
-	[VCAP_AF_MPLS_IP_CTRL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 196,
-		.width = 1,
-	},
-	[VCAP_AF_CUSTOM_ACE_ENA] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 197,
-		.width = 5,
-	},
-	[VCAP_AF_CUSTOM_ACE_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 202,
-		.width = 2,
-	},
-	[VCAP_AF_PAG_OVERRIDE_MASK] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 204,
-		.width = 8,
-	},
-	[VCAP_AF_PAG_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 212,
-		.width = 8,
-	},
-	[VCAP_AF_S2_KEY_SEL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 220,
-		.width = 1,
-	},
-	[VCAP_AF_S2_KEY_SEL_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 221,
-		.width = 6,
-	},
-	[VCAP_AF_INJ_MASQ_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 227,
-		.width = 1,
-	},
-	[VCAP_AF_INJ_MASQ_PORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 228,
-		.width = 7,
-	},
-	[VCAP_AF_LPORT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 235,
-		.width = 1,
-	},
-	[VCAP_AF_INJ_MASQ_LPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 236,
-		.width = 7,
-	},
-	[VCAP_AF_MATCH_ID] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 243,
-		.width = 16,
-	},
-	[VCAP_AF_MATCH_ID_MASK] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 259,
-		.width = 16,
-	},
-	[VCAP_AF_PIPELINE_FORCE_ENA] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 275,
-		.width = 2,
-	},
-	[VCAP_AF_PIPELINE_ACT_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 277,
-		.width = 1,
-	},
-	[VCAP_AF_PIPELINE_PT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 278,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_KEY_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 283,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_NORM_W16_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 288,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_OFFSET_FROM_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 293,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_TYPE_AFTER_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 295,
-		.width = 2,
-	},
-	[VCAP_AF_NXT_NORMALIZE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 297,
-		.width = 1,
-	},
-	[VCAP_AF_NXT_IDX_CTRL] = {
+	[VCAP_AF_NXT_IDX_CTRL] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 298,
 		.width = 3,
@@ -4364,16 +3058,6 @@ static const struct vcap_field is0_class_reduced_actionfield[] = {
 		.offset = 0,
 		.width = 1,
 	},
-	[VCAP_AF_COSID_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 1,
-		.width = 1,
-	},
-	[VCAP_AF_COSID_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 2,
-		.width = 3,
-	},
 	[VCAP_AF_QOS_ENA] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 5,
@@ -4409,46 +3093,11 @@ static const struct vcap_field is0_class_reduced_actionfield[] = {
 		.offset = 17,
 		.width = 3,
 	},
-	[VCAP_AF_GVID_ADD_REPLACE_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 20,
-		.width = 3,
-	},
 	[VCAP_AF_VID_VAL] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 23,
 		.width = 13,
 	},
-	[VCAP_AF_VLAN_POP_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 36,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_POP_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 37,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 39,
-		.width = 1,
-	},
-	[VCAP_AF_VLAN_PUSH_CNT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 40,
-		.width = 2,
-	},
-	[VCAP_AF_TPID_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 42,
-		.width = 2,
-	},
-	[VCAP_AF_VLAN_WAS_TAGGED] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 44,
-		.width = 2,
-	},
 	[VCAP_AF_ISDX_ADD_REPLACE_SEL] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 46,
@@ -4459,61 +3108,6 @@ static const struct vcap_field is0_class_reduced_actionfield[] = {
 		.offset = 47,
 		.width = 12,
 	},
-	[VCAP_AF_FWD_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 59,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 60,
-		.width = 1,
-	},
-	[VCAP_AF_CPU_Q] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 61,
-		.width = 3,
-	},
-	[VCAP_AF_MIP_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 64,
-		.width = 2,
-	},
-	[VCAP_AF_OAM_Y1731_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 66,
-		.width = 3,
-	},
-	[VCAP_AF_LPORT_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 69,
-		.width = 1,
-	},
-	[VCAP_AF_INJ_MASQ_LPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 70,
-		.width = 7,
-	},
-	[VCAP_AF_PIPELINE_FORCE_ENA] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 77,
-		.width = 2,
-	},
-	[VCAP_AF_PIPELINE_ACT_SEL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 79,
-		.width = 1,
-	},
-	[VCAP_AF_PIPELINE_PT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 80,
-		.width = 5,
-	},
-	[VCAP_AF_NXT_KEY_TYPE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 85,
-		.width = 5,
-	},
 	[VCAP_AF_NXT_IDX_CTRL] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 90,
@@ -4527,11 +3121,6 @@ static const struct vcap_field is0_class_reduced_actionfield[] = {
 };
 
 static const struct vcap_field is2_base_type_actionfield[] = {
-	[VCAP_AF_IS_INNER_ACL] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 0,
-		.width = 1,
-	},
 	[VCAP_AF_PIPELINE_FORCE_ENA] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 1,
@@ -4562,11 +3151,6 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 		.offset = 10,
 		.width = 3,
 	},
-	[VCAP_AF_CPU_DIS] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 13,
-		.width = 1,
-	},
 	[VCAP_AF_LRN_DIS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 14,
@@ -4592,11 +3176,6 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 		.offset = 23,
 		.width = 1,
 	},
-	[VCAP_AF_DLB_OFFSET] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 24,
-		.width = 3,
-	},
 	[VCAP_AF_MASK_MODE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 27,
@@ -4607,51 +3186,11 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 		.offset = 30,
 		.width = 68,
 	},
-	[VCAP_AF_RSDX_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 98,
-		.width = 1,
-	},
-	[VCAP_AF_RSDX_VAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 99,
-		.width = 12,
-	},
 	[VCAP_AF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 111,
 		.width = 2,
 	},
-	[VCAP_AF_REW_CMD] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 113,
-		.width = 11,
-	},
-	[VCAP_AF_TTL_UPDATE_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 124,
-		.width = 1,
-	},
-	[VCAP_AF_SAM_SEQ_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 125,
-		.width = 1,
-	},
-	[VCAP_AF_TCP_UDP_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 126,
-		.width = 1,
-	},
-	[VCAP_AF_TCP_UDP_DPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 127,
-		.width = 16,
-	},
-	[VCAP_AF_TCP_UDP_SPORT] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 143,
-		.width = 16,
-	},
 	[VCAP_AF_MATCH_ID] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 159,
@@ -4667,56 +3206,6 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 		.offset = 191,
 		.width = 12,
 	},
-	[VCAP_AF_SWAP_MAC_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 203,
-		.width = 1,
-	},
-	[VCAP_AF_ACL_RT_MODE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 204,
-		.width = 4,
-	},
-	[VCAP_AF_ACL_MAC] = {
-		.type = VCAP_FIELD_U48,
-		.offset = 208,
-		.width = 48,
-	},
-	[VCAP_AF_DMAC_OFFSET_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 256,
-		.width = 1,
-	},
-	[VCAP_AF_PTP_MASTER_SEL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 257,
-		.width = 2,
-	},
-	[VCAP_AF_LOG_MSG_INTERVAL] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 259,
-		.width = 4,
-	},
-	[VCAP_AF_SIP_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 263,
-		.width = 5,
-	},
-	[VCAP_AF_RLEG_STAT_IDX] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 268,
-		.width = 3,
-	},
-	[VCAP_AF_IGR_ACL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 271,
-		.width = 1,
-	},
-	[VCAP_AF_EGR_ACL_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 272,
-		.width = 1,
-	},
 };
 
 static const struct vcap_field es2_base_type_actionfield[] = {
@@ -4794,16 +3283,6 @@ static const struct vcap_field es2_base_type_actionfield[] = {
 
 /* actionfield_set */
 static const struct vcap_set is0_actionfield_set[] = {
-	[VCAP_AFS_MLBS] = {
-		.type_id = 0,
-		.sw_per_item = 2,
-		.sw_cnt = 6,
-	},
-	[VCAP_AFS_MLBS_REDUCED] = {
-		.type_id = 0,
-		.sw_per_item = 1,
-		.sw_cnt = 12,
-	},
 	[VCAP_AFS_CLASSIFICATION] = {
 		.type_id = 1,
 		.sw_per_item = 2,
@@ -4839,8 +3318,6 @@ static const struct vcap_set es2_actionfield_set[] = {
 
 /* actionfield_set map */
 static const struct vcap_field *is0_actionfield_set_map[] = {
-	[VCAP_AFS_MLBS] = is0_mlbs_actionfield,
-	[VCAP_AFS_MLBS_REDUCED] = is0_mlbs_reduced_actionfield,
 	[VCAP_AFS_CLASSIFICATION] = is0_classification_actionfield,
 	[VCAP_AFS_FULL] = is0_full_actionfield,
 	[VCAP_AFS_CLASS_REDUCED] = is0_class_reduced_actionfield,
@@ -4856,8 +3333,6 @@ static const struct vcap_field *es2_actionfield_set_map[] = {
 
 /* actionfield_set map size */
 static int is0_actionfield_set_map_size[] = {
-	[VCAP_AFS_MLBS] = ARRAY_SIZE(is0_mlbs_actionfield),
-	[VCAP_AFS_MLBS_REDUCED] = ARRAY_SIZE(is0_mlbs_reduced_actionfield),
 	[VCAP_AFS_CLASSIFICATION] = ARRAY_SIZE(is0_classification_actionfield),
 	[VCAP_AFS_FULL] = ARRAY_SIZE(is0_full_actionfield),
 	[VCAP_AFS_CLASS_REDUCED] = ARRAY_SIZE(is0_class_reduced_actionfield),
@@ -5244,17 +3719,21 @@ static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_IP4_OTHER]                     =  "VCAP_KFS_IP4_OTHER",
 	[VCAP_KFS_IP4_TCP_UDP]                   =  "VCAP_KFS_IP4_TCP_UDP",
 	[VCAP_KFS_IP4_VID]                       =  "VCAP_KFS_IP4_VID",
+	[VCAP_KFS_IP6_OTHER]                     =  "VCAP_KFS_IP6_OTHER",
 	[VCAP_KFS_IP6_STD]                       =  "VCAP_KFS_IP6_STD",
+	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
 	[VCAP_KFS_IP6_VID]                       =  "VCAP_KFS_IP6_VID",
 	[VCAP_KFS_IP_7TUPLE]                     =  "VCAP_KFS_IP_7TUPLE",
 	[VCAP_KFS_LL_FULL]                       =  "VCAP_KFS_LL_FULL",
 	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
-	[VCAP_KFS_MLL]                           =  "VCAP_KFS_MLL",
-	[VCAP_KFS_NORMAL]                        =  "VCAP_KFS_NORMAL",
+	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
+	[VCAP_KFS_MAC_SNAP]                      =  "VCAP_KFS_MAC_SNAP",
 	[VCAP_KFS_NORMAL_5TUPLE_IP4]             =  "VCAP_KFS_NORMAL_5TUPLE_IP4",
 	[VCAP_KFS_NORMAL_7TUPLE]                 =  "VCAP_KFS_NORMAL_7TUPLE",
+	[VCAP_KFS_OAM]                           =  "VCAP_KFS_OAM",
 	[VCAP_KFS_PURE_5TUPLE_IP4]               =  "VCAP_KFS_PURE_5TUPLE_IP4",
-	[VCAP_KFS_TRI_VID]                       =  "VCAP_KFS_TRI_VID",
+	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
+	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
 };
 
 /* Actionfieldset names */
@@ -5264,8 +3743,7 @@ static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
 	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
 	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
-	[VCAP_AFS_MLBS]                          =  "VCAP_AFS_MLBS",
-	[VCAP_AFS_MLBS_REDUCED]                  =  "VCAP_AFS_MLBS_REDUCED",
+	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
 };
 
 /* Keyfield names */
@@ -5303,11 +3781,10 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ARP_SENDER_MATCH_IS]            =  "ARP_SENDER_MATCH_IS",
 	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
 	[VCAP_KF_COSID_CLS]                      =  "COSID_CLS",
-	[VCAP_KF_DST_ENTRY]                      =  "DST_ENTRY",
 	[VCAP_KF_ES0_ISDX_KEY_ENA]               =  "ES0_ISDX_KEY_ENA",
 	[VCAP_KF_ETYPE]                          =  "ETYPE",
 	[VCAP_KF_ETYPE_LEN_IS]                   =  "ETYPE_LEN_IS",
-	[VCAP_KF_ETYPE_MPLS]                     =  "ETYPE_MPLS",
+	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
 	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
@@ -5324,17 +3801,24 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ISDX_GT0_IS]                    =  "ISDX_GT0_IS",
 	[VCAP_KF_L2_BC_IS]                       =  "L2_BC_IS",
 	[VCAP_KF_L2_DMAC]                        =  "L2_DMAC",
+	[VCAP_KF_L2_FRM_TYPE]                    =  "L2_FRM_TYPE",
 	[VCAP_KF_L2_FWD_IS]                      =  "L2_FWD_IS",
+	[VCAP_KF_L2_LLC]                         =  "L2_LLC",
 	[VCAP_KF_L2_MC_IS]                       =  "L2_MC_IS",
+	[VCAP_KF_L2_PAYLOAD0]                    =  "L2_PAYLOAD0",
+	[VCAP_KF_L2_PAYLOAD1]                    =  "L2_PAYLOAD1",
+	[VCAP_KF_L2_PAYLOAD2]                    =  "L2_PAYLOAD2",
 	[VCAP_KF_L2_PAYLOAD_ETYPE]               =  "L2_PAYLOAD_ETYPE",
 	[VCAP_KF_L2_SMAC]                        =  "L2_SMAC",
+	[VCAP_KF_L2_SNAP]                        =  "L2_SNAP",
 	[VCAP_KF_L3_DIP_EQ_SIP_IS]               =  "L3_DIP_EQ_SIP_IS",
-	[VCAP_KF_L3_DMAC_DIP_MATCH]              =  "L3_DMAC_DIP_MATCH",
 	[VCAP_KF_L3_DPL_CLS]                     =  "L3_DPL_CLS",
 	[VCAP_KF_L3_DSCP]                        =  "L3_DSCP",
 	[VCAP_KF_L3_DST_IS]                      =  "L3_DST_IS",
+	[VCAP_KF_L3_FRAGMENT]                    =  "L3_FRAGMENT",
 	[VCAP_KF_L3_FRAGMENT_TYPE]               =  "L3_FRAGMENT_TYPE",
 	[VCAP_KF_L3_FRAG_INVLD_L4_LEN]           =  "L3_FRAG_INVLD_L4_LEN",
+	[VCAP_KF_L3_FRAG_OFS_GT0]                =  "L3_FRAG_OFS_GT0",
 	[VCAP_KF_L3_IP4_DIP]                     =  "L3_IP4_DIP",
 	[VCAP_KF_L3_IP4_SIP]                     =  "L3_IP4_SIP",
 	[VCAP_KF_L3_IP6_DIP]                     =  "L3_IP6_DIP",
@@ -5343,9 +3827,10 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L3_OPTIONS_IS]                  =  "L3_OPTIONS_IS",
 	[VCAP_KF_L3_PAYLOAD]                     =  "L3_PAYLOAD",
 	[VCAP_KF_L3_RT_IS]                       =  "L3_RT_IS",
-	[VCAP_KF_L3_SMAC_SIP_MATCH]              =  "L3_SMAC_SIP_MATCH",
 	[VCAP_KF_L3_TOS]                         =  "L3_TOS",
 	[VCAP_KF_L3_TTL_GT0]                     =  "L3_TTL_GT0",
+	[VCAP_KF_L4_1588_DOM]                    =  "L4_1588_DOM",
+	[VCAP_KF_L4_1588_VER]                    =  "L4_1588_VER",
 	[VCAP_KF_L4_ACK]                         =  "L4_ACK",
 	[VCAP_KF_L4_DPORT]                       =  "L4_DPORT",
 	[VCAP_KF_L4_FIN]                         =  "L4_FIN",
@@ -5364,7 +3849,12 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
 	[VCAP_KF_MIRROR_ENA]                     =  "MIRROR_ENA",
 	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
+	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
+	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
 	[VCAP_KF_OAM_MEL_FLAGS]                  =  "OAM_MEL_FLAGS",
+	[VCAP_KF_OAM_MEPID]                      =  "OAM_MEPID",
+	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
+	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
 	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
 	[VCAP_KF_PROT_ACTIVE]                    =  "PROT_ACTIVE",
 	[VCAP_KF_TCP_IS]                         =  "TCP_IS",
@@ -5375,50 +3865,29 @@ static const char * const vcap_keyfield_names[] = {
 /* Actionfield names */
 static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_NO_VALUE]                       =  "(None)",
-	[VCAP_AF_ACL_MAC]                        =  "ACL_MAC",
-	[VCAP_AF_ACL_RT_MODE]                    =  "ACL_RT_MODE",
+	[VCAP_AF_ACL_ID]                         =  "ACL_ID",
 	[VCAP_AF_CLS_VID_SEL]                    =  "CLS_VID_SEL",
 	[VCAP_AF_CNT_ID]                         =  "CNT_ID",
 	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
 	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
-	[VCAP_AF_COSID_ENA]                      =  "COSID_ENA",
-	[VCAP_AF_COSID_VAL]                      =  "COSID_VAL",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
-	[VCAP_AF_CPU_DIS]                        =  "CPU_DIS",
-	[VCAP_AF_CPU_ENA]                        =  "CPU_ENA",
-	[VCAP_AF_CPU_Q]                          =  "CPU_Q",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
-	[VCAP_AF_CUSTOM_ACE_ENA]                 =  "CUSTOM_ACE_ENA",
-	[VCAP_AF_CUSTOM_ACE_OFFSET]              =  "CUSTOM_ACE_OFFSET",
 	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
 	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
-	[VCAP_AF_DLB_OFFSET]                     =  "DLB_OFFSET",
-	[VCAP_AF_DMAC_OFFSET_ENA]                =  "DMAC_OFFSET_ENA",
 	[VCAP_AF_DP_ENA]                         =  "DP_ENA",
 	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
 	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
 	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
-	[VCAP_AF_EGR_ACL_ENA]                    =  "EGR_ACL_ENA",
 	[VCAP_AF_ES2_REW_CMD]                    =  "ES2_REW_CMD",
-	[VCAP_AF_FWD_DIS]                        =  "FWD_DIS",
+	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
 	[VCAP_AF_FWD_MODE]                       =  "FWD_MODE",
-	[VCAP_AF_FWD_TYPE]                       =  "FWD_TYPE",
-	[VCAP_AF_GVID_ADD_REPLACE_SEL]           =  "GVID_ADD_REPLACE_SEL",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
+	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
-	[VCAP_AF_IGR_ACL_ENA]                    =  "IGR_ACL_ENA",
-	[VCAP_AF_INJ_MASQ_ENA]                   =  "INJ_MASQ_ENA",
-	[VCAP_AF_INJ_MASQ_LPORT]                 =  "INJ_MASQ_LPORT",
-	[VCAP_AF_INJ_MASQ_PORT]                  =  "INJ_MASQ_PORT",
 	[VCAP_AF_INTR_ENA]                       =  "INTR_ENA",
 	[VCAP_AF_ISDX_ADD_REPLACE_SEL]           =  "ISDX_ADD_REPLACE_SEL",
+	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
 	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
-	[VCAP_AF_IS_INNER_ACL]                   =  "IS_INNER_ACL",
-	[VCAP_AF_L3_MAC_UPDATE_DIS]              =  "L3_MAC_UPDATE_DIS",
-	[VCAP_AF_LOG_MSG_INTERVAL]               =  "LOG_MSG_INTERVAL",
-	[VCAP_AF_LPM_AFFIX_ENA]                  =  "LPM_AFFIX_ENA",
-	[VCAP_AF_LPM_AFFIX_VAL]                  =  "LPM_AFFIX_VAL",
-	[VCAP_AF_LPORT_ENA]                      =  "LPORT_ENA",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
 	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
 	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
@@ -5426,71 +3895,28 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_MASK_MODE]                      =  "MASK_MODE",
 	[VCAP_AF_MATCH_ID]                       =  "MATCH_ID",
 	[VCAP_AF_MATCH_ID_MASK]                  =  "MATCH_ID_MASK",
-	[VCAP_AF_MIP_SEL]                        =  "MIP_SEL",
+	[VCAP_AF_MIRROR_ENA]                     =  "MIRROR_ENA",
 	[VCAP_AF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
 	[VCAP_AF_MIRROR_PROBE_ID]                =  "MIRROR_PROBE_ID",
-	[VCAP_AF_MPLS_IP_CTRL_ENA]               =  "MPLS_IP_CTRL_ENA",
-	[VCAP_AF_MPLS_MEP_ENA]                   =  "MPLS_MEP_ENA",
-	[VCAP_AF_MPLS_MIP_ENA]                   =  "MPLS_MIP_ENA",
-	[VCAP_AF_MPLS_OAM_FLAVOR]                =  "MPLS_OAM_FLAVOR",
-	[VCAP_AF_MPLS_OAM_TYPE]                  =  "MPLS_OAM_TYPE",
-	[VCAP_AF_NUM_VLD_LABELS]                 =  "NUM_VLD_LABELS",
 	[VCAP_AF_NXT_IDX]                        =  "NXT_IDX",
 	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
-	[VCAP_AF_NXT_KEY_TYPE]                   =  "NXT_KEY_TYPE",
-	[VCAP_AF_NXT_NORMALIZE]                  =  "NXT_NORMALIZE",
-	[VCAP_AF_NXT_NORM_W16_OFFSET]            =  "NXT_NORM_W16_OFFSET",
-	[VCAP_AF_NXT_NORM_W32_OFFSET]            =  "NXT_NORM_W32_OFFSET",
-	[VCAP_AF_NXT_OFFSET_FROM_TYPE]           =  "NXT_OFFSET_FROM_TYPE",
-	[VCAP_AF_NXT_TYPE_AFTER_OFFSET]          =  "NXT_TYPE_AFTER_OFFSET",
-	[VCAP_AF_OAM_IP_BFD_ENA]                 =  "OAM_IP_BFD_ENA",
-	[VCAP_AF_OAM_TWAMP_ENA]                  =  "OAM_TWAMP_ENA",
-	[VCAP_AF_OAM_Y1731_SEL]                  =  "OAM_Y1731_SEL",
 	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
 	[VCAP_AF_PAG_VAL]                        =  "PAG_VAL",
 	[VCAP_AF_PCP_ENA]                        =  "PCP_ENA",
 	[VCAP_AF_PCP_VAL]                        =  "PCP_VAL",
-	[VCAP_AF_PIPELINE_ACT_SEL]               =  "PIPELINE_ACT_SEL",
 	[VCAP_AF_PIPELINE_FORCE_ENA]             =  "PIPELINE_FORCE_ENA",
 	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
-	[VCAP_AF_PIPELINE_PT_REDUCED]            =  "PIPELINE_PT_REDUCED",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
 	[VCAP_AF_POLICE_REMARK]                  =  "POLICE_REMARK",
+	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
-	[VCAP_AF_PTP_MASTER_SEL]                 =  "PTP_MASTER_SEL",
 	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
 	[VCAP_AF_QOS_VAL]                        =  "QOS_VAL",
-	[VCAP_AF_REW_CMD]                        =  "REW_CMD",
-	[VCAP_AF_RLEG_DMAC_CHK_DIS]              =  "RLEG_DMAC_CHK_DIS",
-	[VCAP_AF_RLEG_STAT_IDX]                  =  "RLEG_STAT_IDX",
-	[VCAP_AF_RSDX_ENA]                       =  "RSDX_ENA",
-	[VCAP_AF_RSDX_VAL]                       =  "RSDX_VAL",
-	[VCAP_AF_RSVD_LBL_VAL]                   =  "RSVD_LBL_VAL",
+	[VCAP_AF_REW_OP]                         =  "REW_OP",
 	[VCAP_AF_RT_DIS]                         =  "RT_DIS",
-	[VCAP_AF_RT_SEL]                         =  "RT_SEL",
-	[VCAP_AF_S2_KEY_SEL_ENA]                 =  "S2_KEY_SEL_ENA",
-	[VCAP_AF_S2_KEY_SEL_IDX]                 =  "S2_KEY_SEL_IDX",
-	[VCAP_AF_SAM_SEQ_ENA]                    =  "SAM_SEQ_ENA",
-	[VCAP_AF_SIP_IDX]                        =  "SIP_IDX",
-	[VCAP_AF_SWAP_MAC_ENA]                   =  "SWAP_MAC_ENA",
-	[VCAP_AF_TCP_UDP_DPORT]                  =  "TCP_UDP_DPORT",
-	[VCAP_AF_TCP_UDP_ENA]                    =  "TCP_UDP_ENA",
-	[VCAP_AF_TCP_UDP_SPORT]                  =  "TCP_UDP_SPORT",
-	[VCAP_AF_TC_ENA]                         =  "TC_ENA",
-	[VCAP_AF_TC_LABEL]                       =  "TC_LABEL",
-	[VCAP_AF_TPID_SEL]                       =  "TPID_SEL",
-	[VCAP_AF_TTL_DECR_DIS]                   =  "TTL_DECR_DIS",
-	[VCAP_AF_TTL_ENA]                        =  "TTL_ENA",
-	[VCAP_AF_TTL_LABEL]                      =  "TTL_LABEL",
-	[VCAP_AF_TTL_UPDATE_ENA]                 =  "TTL_UPDATE_ENA",
 	[VCAP_AF_TYPE]                           =  "TYPE",
 	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
-	[VCAP_AF_VLAN_POP_CNT]                   =  "VLAN_POP_CNT",
-	[VCAP_AF_VLAN_POP_CNT_ENA]               =  "VLAN_POP_CNT_ENA",
-	[VCAP_AF_VLAN_PUSH_CNT]                  =  "VLAN_PUSH_CNT",
-	[VCAP_AF_VLAN_PUSH_CNT_ENA]              =  "VLAN_PUSH_CNT_ENA",
-	[VCAP_AF_VLAN_WAS_TAGGED]                =  "VLAN_WAS_TAGGED",
 };
 
 /* VCAPs */
-- 
2.39.1

