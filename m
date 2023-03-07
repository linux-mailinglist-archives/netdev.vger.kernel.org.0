Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933D16AF848
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCGWKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjCGWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:09:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170898DCFB;
        Tue,  7 Mar 2023 14:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226986; x=1709762986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2P/aH5DHNCnOjjCrUgAxcSNc3k56b8E4h4hC2Uuu4GQ=;
  b=LMK7+RBBM+4W/vfKX58HtIhRHF2mu6MhaVboZgo4cdmKQIhisJb97F6Q
   +CjO+RCU5UNgE75Nv/aV4ipfjVxe7W4KeDXzY0z5sHV7o75nSwFCAr8as
   iWoq8r4pxFEpjrru/xn6sly96tsm4fVRAd8FcfE+xLzsZqF9jGj/+36Ie
   jcRNSSBkKKNxkXZ7FZnxuVCFLOyKn9/UwhneC0TdeKUngmoIn2n8dI62e
   VutMVfK0tGBiWf2DgFUoRfmhlUuooibVNNiO4AnAQlOwIltzToPckfLbJ
   1/gP+53hNlTwiAMoAGUMPG6SZaBEDvRBlKNxOWDcwuBmsBIFiIiw+/rAw
   A==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="204082654"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/5] net: lan966x: Add IS1 VCAP model
Date:   Tue, 7 Mar 2023 23:09:25 +0100
Message-ID: <20230307220929.834219-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
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

Provide IS1 (ingress stage 1) VCAP model for lan966x.
This provides classification actions for lan966x.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 1402 ++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  217 ++-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |    4 +-
 3 files changed, 1563 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
index 928e711960e6b..66400a082d029 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
@@ -6,6 +6,965 @@
 #include "lan966x_vcap_ag_api.h"
 
 /* keyfields */
+static const struct vcap_field is1_normal_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 19,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 31,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 32,
+		.width = 3,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 35,
+		.width = 48,
+	},
+	[VCAP_KF_ETYPE_LEN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 83,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 84,
+		.width = 16,
+	},
+	[VCAP_KF_IP_SNAP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 100,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 101,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 102,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 103,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 104,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 105,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 111,
+		.width = 32,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 143,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 144,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 145,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 161,
+		.width = 8,
+	},
+};
+
+static const struct vcap_field is1_5tuple_ip4_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 19,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 31,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 32,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 35,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 36,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 48,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 49,
+		.width = 3,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 52,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 53,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 54,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 55,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 56,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 62,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 94,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 126,
+		.width = 8,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 134,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 135,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 136,
+		.width = 8,
+	},
+	[VCAP_KF_IP_PAYLOAD_5TUPLE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 144,
+		.width = 32,
+	},
+};
+
+static const struct vcap_field is1_normal_ip6_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 32,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 33,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 36,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 37,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 49,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 50,
+		.width = 3,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 53,
+		.width = 48,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 101,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 107,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 235,
+		.width = 8,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 243,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 244,
+		.width = 8,
+	},
+	[VCAP_KF_IP_PAYLOAD_S1_IP6] = {
+		.type = VCAP_FIELD_U112,
+		.offset = 252,
+		.width = 112,
+	},
+};
+
+static const struct vcap_field is1_7tuple_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 32,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 33,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 36,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 37,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 49,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 50,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 53,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 101,
+		.width = 48,
+	},
+	[VCAP_KF_ETYPE_LEN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 149,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 150,
+		.width = 16,
+	},
+	[VCAP_KF_IP_SNAP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 166,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 167,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 168,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 169,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 170,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 171,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP6_DIP_MSB] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 177,
+		.width = 16,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 193,
+		.width = 64,
+	},
+	[VCAP_KF_L3_IP6_SIP_MSB] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 257,
+		.width = 16,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 273,
+		.width = 64,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 337,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 338,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 339,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 355,
+		.width = 8,
+	},
+};
+
+static const struct vcap_field is1_5tuple_ip6_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 32,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 33,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 36,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 37,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 49,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 50,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 53,
+		.width = 6,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 59,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 187,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 315,
+		.width = 8,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 323,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 324,
+		.width = 8,
+	},
+	[VCAP_KF_IP_PAYLOAD_5TUPLE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 332,
+		.width = 32,
+	},
+};
+
+static const struct vcap_field is1_dbl_vid_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 9,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_IP_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 19,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 32,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 33,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 36,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 37,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI1] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 49,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP1] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 50,
+		.width = 3,
+	},
+	[VCAP_KF_ETYPE_LEN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 53,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 54,
+		.width = 16,
+	},
+	[VCAP_KF_IP_SNAP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 70,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 71,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 72,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAG_OFS_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 73,
+		.width = 1,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 74,
+		.width = 1,
+	},
+	[VCAP_KF_L3_DSCP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 75,
+		.width = 6,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 81,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 82,
+		.width = 1,
+	},
+};
+
+static const struct vcap_field is1_rt_keyfield[] = {
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
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 3,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 6,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 7,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 8,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 9,
+		.width = 48,
+	},
+	[VCAP_KF_RT_VLAN_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 57,
+		.width = 3,
+	},
+	[VCAP_KF_RT_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 60,
+		.width = 2,
+	},
+	[VCAP_KF_RT_FRMID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 62,
+		.width = 32,
+	},
+};
+
+static const struct vcap_field is1_dmac_vid_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_KF_LOOKUP_INDEX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_KF_IF_IGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 9,
+	},
+	[VCAP_KF_8021CB_R_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_TPID0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 16,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 29,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP0] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 30,
+		.width = 3,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 33,
+		.width = 48,
+	},
+};
+
 static const struct vcap_field is2_mac_etype_keyfield[] = {
 	[VCAP_KF_TYPE] = {
 		.type = VCAP_FIELD_U32,
@@ -1163,6 +2122,49 @@ static const struct vcap_field is2_smac_sip6_keyfield[] = {
 };
 
 /* keyfield_set */
+static const struct vcap_set is1_keyfield_set[] = {
+	[VCAP_KFS_NORMAL] = {
+		.type_id = 0,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_5TUPLE_IP4] = {
+		.type_id = 1,
+		.sw_per_item = 2,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_NORMAL_IP6] = {
+		.type_id = 0,
+		.sw_per_item = 4,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_7TUPLE] = {
+		.type_id = 1,
+		.sw_per_item = 4,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_5TUPLE_IP6] = {
+		.type_id = 2,
+		.sw_per_item = 4,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_DBL_VID] = {
+		.type_id = 0,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+	[VCAP_KFS_RT] = {
+		.type_id = 1,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+	[VCAP_KFS_DMAC_VID] = {
+		.type_id = 2,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+};
+
 static const struct vcap_set is2_keyfield_set[] = {
 	[VCAP_KFS_MAC_ETYPE] = {
 		.type_id = 0,
@@ -1227,6 +2229,17 @@ static const struct vcap_set is2_keyfield_set[] = {
 };
 
 /* keyfield_set map */
+static const struct vcap_field *is1_keyfield_set_map[] = {
+	[VCAP_KFS_NORMAL] = is1_normal_keyfield,
+	[VCAP_KFS_5TUPLE_IP4] = is1_5tuple_ip4_keyfield,
+	[VCAP_KFS_NORMAL_IP6] = is1_normal_ip6_keyfield,
+	[VCAP_KFS_7TUPLE] = is1_7tuple_keyfield,
+	[VCAP_KFS_5TUPLE_IP6] = is1_5tuple_ip6_keyfield,
+	[VCAP_KFS_DBL_VID] = is1_dbl_vid_keyfield,
+	[VCAP_KFS_RT] = is1_rt_keyfield,
+	[VCAP_KFS_DMAC_VID] = is1_dmac_vid_keyfield,
+};
+
 static const struct vcap_field *is2_keyfield_set_map[] = {
 	[VCAP_KFS_MAC_ETYPE] = is2_mac_etype_keyfield,
 	[VCAP_KFS_MAC_LLC] = is2_mac_llc_keyfield,
@@ -1243,6 +2256,17 @@ static const struct vcap_field *is2_keyfield_set_map[] = {
 };
 
 /* keyfield_set map sizes */
+static int is1_keyfield_set_map_size[] = {
+	[VCAP_KFS_NORMAL] = ARRAY_SIZE(is1_normal_keyfield),
+	[VCAP_KFS_5TUPLE_IP4] = ARRAY_SIZE(is1_5tuple_ip4_keyfield),
+	[VCAP_KFS_NORMAL_IP6] = ARRAY_SIZE(is1_normal_ip6_keyfield),
+	[VCAP_KFS_7TUPLE] = ARRAY_SIZE(is1_7tuple_keyfield),
+	[VCAP_KFS_5TUPLE_IP6] = ARRAY_SIZE(is1_5tuple_ip6_keyfield),
+	[VCAP_KFS_DBL_VID] = ARRAY_SIZE(is1_dbl_vid_keyfield),
+	[VCAP_KFS_RT] = ARRAY_SIZE(is1_rt_keyfield),
+	[VCAP_KFS_DMAC_VID] = ARRAY_SIZE(is1_dmac_vid_keyfield),
+};
+
 static int is2_keyfield_set_map_size[] = {
 	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(is2_mac_etype_keyfield),
 	[VCAP_KFS_MAC_LLC] = ARRAY_SIZE(is2_mac_llc_keyfield),
@@ -1259,6 +2283,154 @@ static int is2_keyfield_set_map_size[] = {
 };
 
 /* actionfields */
+static const struct vcap_field is1_s1_actionfield[] = {
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
+		.offset = 8,
+		.width = 1,
+	},
+	[VCAP_AF_QOS_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 9,
+		.width = 3,
+	},
+	[VCAP_AF_DP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_AF_DP_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_AF_PAG_OVERRIDE_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 14,
+		.width = 8,
+	},
+	[VCAP_AF_PAG_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 22,
+		.width = 8,
+	},
+	[VCAP_AF_ISDX_REPLACE_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 30,
+		.width = 1,
+	},
+	[VCAP_AF_ISDX_ADD_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 31,
+		.width = 8,
+	},
+	[VCAP_AF_VID_REPLACE_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 39,
+		.width = 1,
+	},
+	[VCAP_AF_VID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 40,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 67,
+		.width = 1,
+	},
+	[VCAP_AF_PCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 68,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 71,
+		.width = 1,
+	},
+	[VCAP_AF_DEI_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 72,
+		.width = 1,
+	},
+	[VCAP_AF_VLAN_POP_CNT_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 73,
+		.width = 1,
+	},
+	[VCAP_AF_VLAN_POP_CNT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 74,
+		.width = 2,
+	},
+	[VCAP_AF_CUSTOM_ACE_TYPE_ENA] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 76,
+		.width = 4,
+	},
+	[VCAP_AF_SFID_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 80,
+		.width = 1,
+	},
+	[VCAP_AF_SFID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 81,
+		.width = 8,
+	},
+	[VCAP_AF_SGID_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 89,
+		.width = 1,
+	},
+	[VCAP_AF_SGID_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 90,
+		.width = 8,
+	},
+	[VCAP_AF_POLICE_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 98,
+		.width = 1,
+	},
+	[VCAP_AF_POLICE_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 99,
+		.width = 9,
+	},
+	[VCAP_AF_OAM_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 108,
+		.width = 3,
+	},
+	[VCAP_AF_MRP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 111,
+		.width = 2,
+	},
+	[VCAP_AF_DLR_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 113,
+		.width = 2,
+	},
+};
+
 static const struct vcap_field is2_base_type_actionfield[] = {
 	[VCAP_AF_HIT_ME_ONCE] = {
 		.type = VCAP_FIELD_BIT,
@@ -1351,6 +2523,14 @@ static const struct vcap_field is2_smac_sip_actionfield[] = {
 };
 
 /* actionfield_set */
+static const struct vcap_set is1_actionfield_set[] = {
+	[VCAP_AFS_S1] = {
+		.type_id = 0,
+		.sw_per_item = 1,
+		.sw_cnt = 4,
+	},
+};
+
 static const struct vcap_set is2_actionfield_set[] = {
 	[VCAP_AFS_BASE_TYPE] = {
 		.type_id = -1,
@@ -1365,18 +2545,73 @@ static const struct vcap_set is2_actionfield_set[] = {
 };
 
 /* actionfield_set map */
+static const struct vcap_field *is1_actionfield_set_map[] = {
+	[VCAP_AFS_S1] = is1_s1_actionfield,
+};
+
 static const struct vcap_field *is2_actionfield_set_map[] = {
 	[VCAP_AFS_BASE_TYPE] = is2_base_type_actionfield,
 	[VCAP_AFS_SMAC_SIP] = is2_smac_sip_actionfield,
 };
 
 /* actionfield_set map size */
+static int is1_actionfield_set_map_size[] = {
+	[VCAP_AFS_S1] = ARRAY_SIZE(is1_s1_actionfield),
+};
+
 static int is2_actionfield_set_map_size[] = {
 	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(is2_base_type_actionfield),
 	[VCAP_AFS_SMAC_SIP] = ARRAY_SIZE(is2_smac_sip_actionfield),
 };
 
 /* Type Groups */
+static const struct vcap_typegroup is1_x4_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 3,
+		.value = 4,
+	},
+	{
+		.offset = 96,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 192,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 288,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is1_x2_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 96,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup is1_x1_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 1,
+		.value = 1,
+	},
+	{}
+};
+
 static const struct vcap_typegroup is2_x4_keyfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -1424,6 +2659,13 @@ static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup *is1_keyfield_set_typegroups[] = {
+	[4] = is1_x4_keyfield_set_typegroups,
+	[2] = is1_x2_keyfield_set_typegroups,
+	[1] = is1_x1_keyfield_set_typegroups,
+	[5] = NULL,
+};
+
 static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[4] = is2_x4_keyfield_set_typegroups,
 	[2] = is2_x2_keyfield_set_typegroups,
@@ -1431,6 +2673,10 @@ static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[5] = NULL,
 };
 
+static const struct vcap_typegroup is1_x1_actionfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup is2_x2_actionfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -1454,6 +2700,11 @@ static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup *is1_actionfield_set_typegroups[] = {
+	[1] = is1_x1_actionfield_set_typegroups,
+	[5] = NULL,
+};
+
 static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 	[2] = is2_x2_actionfield_set_typegroups,
 	[1] = is2_x1_actionfield_set_typegroups,
@@ -1463,16 +2714,33 @@ static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 /* Keyfieldset names */
 static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_NO_VALUE]                      =  "(None)",
+	[VCAP_KFS_5TUPLE_IP4]                    =  "VCAP_KFS_5TUPLE_IP4",
+	[VCAP_KFS_5TUPLE_IP6]                    =  "VCAP_KFS_5TUPLE_IP6",
+	[VCAP_KFS_7TUPLE]                        =  "VCAP_KFS_7TUPLE",
 	[VCAP_KFS_ARP]                           =  "VCAP_KFS_ARP",
+	[VCAP_KFS_DBL_VID]                       =  "VCAP_KFS_DBL_VID",
+	[VCAP_KFS_DMAC_VID]                      =  "VCAP_KFS_DMAC_VID",
+	[VCAP_KFS_ETAG]                          =  "VCAP_KFS_ETAG",
 	[VCAP_KFS_IP4_OTHER]                     =  "VCAP_KFS_IP4_OTHER",
 	[VCAP_KFS_IP4_TCP_UDP]                   =  "VCAP_KFS_IP4_TCP_UDP",
+	[VCAP_KFS_IP4_VID]                       =  "VCAP_KFS_IP4_VID",
 	[VCAP_KFS_IP6_OTHER]                     =  "VCAP_KFS_IP6_OTHER",
 	[VCAP_KFS_IP6_STD]                       =  "VCAP_KFS_IP6_STD",
 	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
+	[VCAP_KFS_IP6_VID]                       =  "VCAP_KFS_IP6_VID",
+	[VCAP_KFS_IP_7TUPLE]                     =  "VCAP_KFS_IP_7TUPLE",
+	[VCAP_KFS_ISDX]                          =  "VCAP_KFS_ISDX",
+	[VCAP_KFS_LL_FULL]                       =  "VCAP_KFS_LL_FULL",
 	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
 	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
 	[VCAP_KFS_MAC_SNAP]                      =  "VCAP_KFS_MAC_SNAP",
+	[VCAP_KFS_NORMAL]                        =  "VCAP_KFS_NORMAL",
+	[VCAP_KFS_NORMAL_5TUPLE_IP4]             =  "VCAP_KFS_NORMAL_5TUPLE_IP4",
+	[VCAP_KFS_NORMAL_7TUPLE]                 =  "VCAP_KFS_NORMAL_7TUPLE",
+	[VCAP_KFS_NORMAL_IP6]                    =  "VCAP_KFS_NORMAL_IP6",
 	[VCAP_KFS_OAM]                           =  "VCAP_KFS_OAM",
+	[VCAP_KFS_PURE_5TUPLE_IP4]               =  "VCAP_KFS_PURE_5TUPLE_IP4",
+	[VCAP_KFS_RT]                            =  "VCAP_KFS_RT",
 	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
 	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
 };
@@ -1481,16 +2749,42 @@ static const char * const vcap_keyfield_set_names[] = {
 static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_NO_VALUE]                      =  "(None)",
 	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
+	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
+	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
+	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
+	[VCAP_AFS_S1]                            =  "VCAP_AFS_S1",
 	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
 };
 
 /* Keyfield names */
 static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_NO_VALUE]                       =  "(None)",
+	[VCAP_KF_8021BR_ECID_BASE]               =  "8021BR_ECID_BASE",
+	[VCAP_KF_8021BR_ECID_EXT]                =  "8021BR_ECID_EXT",
+	[VCAP_KF_8021BR_E_TAGGED]                =  "8021BR_E_TAGGED",
+	[VCAP_KF_8021BR_GRP]                     =  "8021BR_GRP",
+	[VCAP_KF_8021BR_IGR_ECID_BASE]           =  "8021BR_IGR_ECID_BASE",
+	[VCAP_KF_8021BR_IGR_ECID_EXT]            =  "8021BR_IGR_ECID_EXT",
+	[VCAP_KF_8021CB_R_TAGGED_IS]             =  "8021CB_R_TAGGED_IS",
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
+	[VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS]       =  "8021Q_VLAN_DBL_TAGGED_IS",
 	[VCAP_KF_8021Q_VLAN_TAGGED_IS]           =  "8021Q_VLAN_TAGGED_IS",
+	[VCAP_KF_8021Q_VLAN_TAGS]                =  "8021Q_VLAN_TAGS",
+	[VCAP_KF_ACL_GRP_ID]                     =  "ACL_GRP_ID",
 	[VCAP_KF_ARP_ADDR_SPACE_OK_IS]           =  "ARP_ADDR_SPACE_OK_IS",
 	[VCAP_KF_ARP_LEN_OK_IS]                  =  "ARP_LEN_OK_IS",
 	[VCAP_KF_ARP_OPCODE]                     =  "ARP_OPCODE",
@@ -1498,32 +2792,57 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ARP_PROTO_SPACE_OK_IS]          =  "ARP_PROTO_SPACE_OK_IS",
 	[VCAP_KF_ARP_SENDER_MATCH_IS]            =  "ARP_SENDER_MATCH_IS",
 	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
+	[VCAP_KF_COSID_CLS]                      =  "COSID_CLS",
+	[VCAP_KF_ES0_ISDX_KEY_ENA]               =  "ES0_ISDX_KEY_ENA",
 	[VCAP_KF_ETYPE]                          =  "ETYPE",
+	[VCAP_KF_ETYPE_LEN_IS]                   =  "ETYPE_LEN_IS",
 	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
+	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
+	[VCAP_KF_IF_IGR_PORT_MASK_RNG]           =  "IF_IGR_PORT_MASK_RNG",
+	[VCAP_KF_IF_IGR_PORT_MASK_SEL]           =  "IF_IGR_PORT_MASK_SEL",
+	[VCAP_KF_IF_IGR_PORT_SEL]                =  "IF_IGR_PORT_SEL",
 	[VCAP_KF_IP4_IS]                         =  "IP4_IS",
+	[VCAP_KF_IP_MC_IS]                       =  "IP_MC_IS",
+	[VCAP_KF_IP_PAYLOAD_5TUPLE]              =  "IP_PAYLOAD_5TUPLE",
+	[VCAP_KF_IP_PAYLOAD_S1_IP6]              =  "IP_PAYLOAD_S1_IP6",
+	[VCAP_KF_IP_SNAP_IS]                     =  "IP_SNAP_IS",
+	[VCAP_KF_ISDX_CLS]                       =  "ISDX_CLS",
 	[VCAP_KF_ISDX_GT0_IS]                    =  "ISDX_GT0_IS",
 	[VCAP_KF_L2_BC_IS]                       =  "L2_BC_IS",
 	[VCAP_KF_L2_DMAC]                        =  "L2_DMAC",
 	[VCAP_KF_L2_FRM_TYPE]                    =  "L2_FRM_TYPE",
+	[VCAP_KF_L2_FWD_IS]                      =  "L2_FWD_IS",
 	[VCAP_KF_L2_LLC]                         =  "L2_LLC",
+	[VCAP_KF_L2_MAC]                         =  "L2_MAC",
 	[VCAP_KF_L2_MC_IS]                       =  "L2_MC_IS",
 	[VCAP_KF_L2_PAYLOAD0]                    =  "L2_PAYLOAD0",
 	[VCAP_KF_L2_PAYLOAD1]                    =  "L2_PAYLOAD1",
 	[VCAP_KF_L2_PAYLOAD2]                    =  "L2_PAYLOAD2",
+	[VCAP_KF_L2_PAYLOAD_ETYPE]               =  "L2_PAYLOAD_ETYPE",
 	[VCAP_KF_L2_SMAC]                        =  "L2_SMAC",
 	[VCAP_KF_L2_SNAP]                        =  "L2_SNAP",
 	[VCAP_KF_L3_DIP_EQ_SIP_IS]               =  "L3_DIP_EQ_SIP_IS",
+	[VCAP_KF_L3_DPL_CLS]                     =  "L3_DPL_CLS",
+	[VCAP_KF_L3_DSCP]                        =  "L3_DSCP",
+	[VCAP_KF_L3_DST_IS]                      =  "L3_DST_IS",
 	[VCAP_KF_L3_FRAGMENT]                    =  "L3_FRAGMENT",
+	[VCAP_KF_L3_FRAGMENT_TYPE]               =  "L3_FRAGMENT_TYPE",
+	[VCAP_KF_L3_FRAG_INVLD_L4_LEN]           =  "L3_FRAG_INVLD_L4_LEN",
 	[VCAP_KF_L3_FRAG_OFS_GT0]                =  "L3_FRAG_OFS_GT0",
 	[VCAP_KF_L3_IP4_DIP]                     =  "L3_IP4_DIP",
 	[VCAP_KF_L3_IP4_SIP]                     =  "L3_IP4_SIP",
 	[VCAP_KF_L3_IP6_DIP]                     =  "L3_IP6_DIP",
+	[VCAP_KF_L3_IP6_DIP_MSB]                 =  "L3_IP6_DIP_MSB",
 	[VCAP_KF_L3_IP6_SIP]                     =  "L3_IP6_SIP",
+	[VCAP_KF_L3_IP6_SIP_MSB]                 =  "L3_IP6_SIP_MSB",
 	[VCAP_KF_L3_IP_PROTO]                    =  "L3_IP_PROTO",
 	[VCAP_KF_L3_OPTIONS_IS]                  =  "L3_OPTIONS_IS",
 	[VCAP_KF_L3_PAYLOAD]                     =  "L3_PAYLOAD",
+	[VCAP_KF_L3_RT_IS]                       =  "L3_RT_IS",
 	[VCAP_KF_L3_TOS]                         =  "L3_TOS",
 	[VCAP_KF_L3_TTL_GT0]                     =  "L3_TTL_GT0",
 	[VCAP_KF_L4_1588_DOM]                    =  "L4_1588_DOM",
@@ -1531,6 +2850,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L4_ACK]                         =  "L4_ACK",
 	[VCAP_KF_L4_DPORT]                       =  "L4_DPORT",
 	[VCAP_KF_L4_FIN]                         =  "L4_FIN",
+	[VCAP_KF_L4_PAYLOAD]                     =  "L4_PAYLOAD",
 	[VCAP_KF_L4_PSH]                         =  "L4_PSH",
 	[VCAP_KF_L4_RNG]                         =  "L4_RNG",
 	[VCAP_KF_L4_RST]                         =  "L4_RST",
@@ -1540,7 +2860,11 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L4_SYN]                         =  "L4_SYN",
 	[VCAP_KF_L4_URG]                         =  "L4_URG",
 	[VCAP_KF_LOOKUP_FIRST_IS]                =  "LOOKUP_FIRST_IS",
+	[VCAP_KF_LOOKUP_GEN_IDX]                 =  "LOOKUP_GEN_IDX",
+	[VCAP_KF_LOOKUP_GEN_IDX_SEL]             =  "LOOKUP_GEN_IDX_SEL",
+	[VCAP_KF_LOOKUP_INDEX]                   =  "LOOKUP_INDEX",
 	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
+	[VCAP_KF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
 	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
 	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
 	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
@@ -1549,7 +2873,12 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
 	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
 	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
+	[VCAP_KF_PROT_ACTIVE]                    =  "PROT_ACTIVE",
+	[VCAP_KF_RT_FRMID]                       =  "RT_FRMID",
+	[VCAP_KF_RT_TYPE]                        =  "RT_TYPE",
+	[VCAP_KF_RT_VLAN_IDX]                    =  "RT_VLAN_IDX",
 	[VCAP_KF_TCP_IS]                         =  "TCP_IS",
+	[VCAP_KF_TCP_UDP_IS]                     =  "TCP_UDP_IS",
 	[VCAP_KF_TYPE]                           =  "TYPE",
 };
 
@@ -1557,24 +2886,95 @@ static const char * const vcap_keyfield_names[] = {
 static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_NO_VALUE]                       =  "(None)",
 	[VCAP_AF_ACL_ID]                         =  "ACL_ID",
+	[VCAP_AF_CLS_VID_SEL]                    =  "CLS_VID_SEL",
+	[VCAP_AF_CNT_ID]                         =  "CNT_ID",
+	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
+	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
+	[VCAP_AF_CUSTOM_ACE_TYPE_ENA]            =  "CUSTOM_ACE_TYPE_ENA",
+	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
+	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
+	[VCAP_AF_DLR_SEL]                        =  "DLR_SEL",
+	[VCAP_AF_DP_ENA]                         =  "DP_ENA",
+	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
+	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
+	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
+	[VCAP_AF_ES2_REW_CMD]                    =  "ES2_REW_CMD",
 	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
+	[VCAP_AF_FWD_MODE]                       =  "FWD_MODE",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
 	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
+	[VCAP_AF_INTR_ENA]                       =  "INTR_ENA",
+	[VCAP_AF_ISDX_ADD_REPLACE_SEL]           =  "ISDX_ADD_REPLACE_SEL",
+	[VCAP_AF_ISDX_ADD_VAL]                   =  "ISDX_ADD_VAL",
 	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
+	[VCAP_AF_ISDX_REPLACE_ENA]               =  "ISDX_REPLACE_ENA",
+	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
+	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
+	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
+	[VCAP_AF_MAP_LOOKUP_SEL]                 =  "MAP_LOOKUP_SEL",
 	[VCAP_AF_MASK_MODE]                      =  "MASK_MODE",
+	[VCAP_AF_MATCH_ID]                       =  "MATCH_ID",
+	[VCAP_AF_MATCH_ID_MASK]                  =  "MATCH_ID_MASK",
 	[VCAP_AF_MIRROR_ENA]                     =  "MIRROR_ENA",
+	[VCAP_AF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
+	[VCAP_AF_MIRROR_PROBE_ID]                =  "MIRROR_PROBE_ID",
+	[VCAP_AF_MRP_SEL]                        =  "MRP_SEL",
+	[VCAP_AF_NXT_IDX]                        =  "NXT_IDX",
+	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
+	[VCAP_AF_OAM_SEL]                        =  "OAM_SEL",
+	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
+	[VCAP_AF_PAG_VAL]                        =  "PAG_VAL",
+	[VCAP_AF_PCP_ENA]                        =  "PCP_ENA",
+	[VCAP_AF_PCP_VAL]                        =  "PCP_VAL",
+	[VCAP_AF_PIPELINE_FORCE_ENA]             =  "PIPELINE_FORCE_ENA",
+	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
+	[VCAP_AF_POLICE_REMARK]                  =  "POLICE_REMARK",
 	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
+	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
+	[VCAP_AF_QOS_VAL]                        =  "QOS_VAL",
 	[VCAP_AF_REW_OP]                         =  "REW_OP",
+	[VCAP_AF_RT_DIS]                         =  "RT_DIS",
+	[VCAP_AF_SFID_ENA]                       =  "SFID_ENA",
+	[VCAP_AF_SFID_VAL]                       =  "SFID_VAL",
+	[VCAP_AF_SGID_ENA]                       =  "SGID_ENA",
+	[VCAP_AF_SGID_VAL]                       =  "SGID_VAL",
+	[VCAP_AF_TYPE]                           =  "TYPE",
+	[VCAP_AF_VID_REPLACE_ENA]                =  "VID_REPLACE_ENA",
+	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
+	[VCAP_AF_VLAN_POP_CNT]                   =  "VLAN_POP_CNT",
+	[VCAP_AF_VLAN_POP_CNT_ENA]               =  "VLAN_POP_CNT_ENA",
 };
 
 /* VCAPs */
 const struct vcap_info lan966x_vcaps[] = {
+	[VCAP_TYPE_IS1] = {
+		.name = "is1",
+		.rows = 192,
+		.sw_count = 4,
+		.sw_width = 96,
+		.sticky_width = 32,
+		.act_width = 123,
+		.default_cnt = 0,
+		.require_cnt_dis = 1,
+		.version = 1,
+		.keyfield_set = is1_keyfield_set,
+		.keyfield_set_size = ARRAY_SIZE(is1_keyfield_set),
+		.actionfield_set = is1_actionfield_set,
+		.actionfield_set_size = ARRAY_SIZE(is1_actionfield_set),
+		.keyfield_set_map = is1_keyfield_set_map,
+		.keyfield_set_map_size = is1_keyfield_set_map_size,
+		.actionfield_set_map = is1_actionfield_set_map,
+		.actionfield_set_map_size = is1_actionfield_set_map_size,
+		.keyfield_set_typegroups = is1_keyfield_set_typegroups,
+		.actionfield_set_typegroups = is1_actionfield_set_typegroups,
+	},
 	[VCAP_TYPE_IS2] = {
 		.name = "is2",
 		.rows = 64,
@@ -1600,7 +3000,7 @@ const struct vcap_info lan966x_vcaps[] = {
 
 const struct vcap_statistics lan966x_vcap_stats = {
 	.name = "lan966x",
-	.count = 1,
+	.count = 2,
 	.keyfield_set_names = vcap_keyfield_set_names,
 	.actionfield_set_names = vcap_actionfield_set_names,
 	.keyfield_names = vcap_keyfield_names,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index 0844fcaeee689..a556c4419986e 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -3,8 +3,8 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2023-02-10 11:15:56 +0100.
- * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
+/* This file is autogenerated by cml-utils 2023-02-16 11:41:14 +0100.
+ * Commit ID: be85f176b3a151fa748dcaf97c8824a5c2e065f3
  */
 
 #ifndef __VCAP_AG_API__
@@ -14,6 +14,7 @@ enum vcap_type {
 	VCAP_TYPE_ES0,
 	VCAP_TYPE_ES2,
 	VCAP_TYPE_IS0,
+	VCAP_TYPE_IS1,
 	VCAP_TYPE_IS2,
 	VCAP_TYPE_MAX
 };
@@ -21,7 +22,12 @@ enum vcap_type {
 /* Keyfieldset names with origin information */
 enum vcap_keyfield_set {
 	VCAP_KFS_NO_VALUE,          /* initial value */
+	VCAP_KFS_5TUPLE_IP4,        /* lan966x is1 X2 */
+	VCAP_KFS_5TUPLE_IP6,        /* lan966x is1 X4 */
+	VCAP_KFS_7TUPLE,            /* lan966x is1 X4 */
 	VCAP_KFS_ARP,               /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
+	VCAP_KFS_DBL_VID,           /* lan966x is1 X1 */
+	VCAP_KFS_DMAC_VID,          /* lan966x is1 X1 */
 	VCAP_KFS_ETAG,              /* sparx5 is0 X2 */
 	VCAP_KFS_IP4_OTHER,         /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
@@ -36,10 +42,13 @@ enum vcap_keyfield_set {
 	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_MAC_LLC,           /* lan966x is2 X2 */
 	VCAP_KFS_MAC_SNAP,          /* lan966x is2 X2 */
+	VCAP_KFS_NORMAL,            /* lan966x is1 X2 */
 	VCAP_KFS_NORMAL_5TUPLE_IP4,  /* sparx5 is0 X6 */
 	VCAP_KFS_NORMAL_7TUPLE,     /* sparx5 is0 X12 */
+	VCAP_KFS_NORMAL_IP6,        /* lan966x is1 X4 */
 	VCAP_KFS_OAM,               /* lan966x is2 X2 */
 	VCAP_KFS_PURE_5TUPLE_IP4,   /* sparx5 is0 X3 */
+	VCAP_KFS_RT,                /* lan966x is1 X1 */
 	VCAP_KFS_SMAC_SIP4,         /* lan966x is2 X1 */
 	VCAP_KFS_SMAC_SIP6,         /* lan966x is2 X2 */
 };
@@ -61,17 +70,20 @@ enum vcap_keyfield_set {
  *   Used by 802.1BR Bridge Port Extension in an E-Tag
  * VCAP_KF_8021BR_IGR_ECID_EXT: W8, sparx5: is0
  *   Used by 802.1BR Bridge Port Extension in an E-Tag
- * VCAP_KF_8021Q_DEI0: W1, sparx5: is0
+ * VCAP_KF_8021CB_R_TAGGED_IS: W1, lan966x: is1
+ *   Set if frame contains an RTAG: IEEE 802.1CB (FRER Redundancy tag, Ethertype
+ *   0xf1c1)
+ * VCAP_KF_8021Q_DEI0: W1, sparx5: is0, lan966x: is1
  *   First DEI in multiple vlan tags (outer tag or default port tag)
- * VCAP_KF_8021Q_DEI1: W1, sparx5: is0
+ * VCAP_KF_8021Q_DEI1: W1, sparx5: is0, lan966x: is1
  *   Second DEI in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_DEI2: W1, sparx5: is0
  *   Third DEI in multiple vlan tags (not always available)
  * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2, lan966x: is2
  *   Classified DEI
- * VCAP_KF_8021Q_PCP0: W3, sparx5: is0
+ * VCAP_KF_8021Q_PCP0: W3, sparx5: is0, lan966x: is1
  *   First PCP in multiple vlan tags (outer tag or default port tag)
- * VCAP_KF_8021Q_PCP1: W3, sparx5: is0
+ * VCAP_KF_8021Q_PCP1: W3, sparx5: is0, lan966x: is1
  *   Second PCP in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_PCP2: W3, sparx5: is0
  *   Third PCP in multiple vlan tags (not always available)
@@ -79,22 +91,24 @@ enum vcap_keyfield_set {
  *   Classified PCP
  * VCAP_KF_8021Q_TPID: W3, sparx5: es0
  *   TPID for outer tag: 0: Customer TPID 1: Service TPID (88A8 or programmable)
- * VCAP_KF_8021Q_TPID0: W3, sparx5: is0
+ * VCAP_KF_8021Q_TPID0: sparx5 is0 W3, lan966x is1 W1
  *   First TPIC in multiple vlan tags (outer tag or default port tag)
- * VCAP_KF_8021Q_TPID1: W3, sparx5: is0
+ * VCAP_KF_8021Q_TPID1: sparx5 is0 W3, lan966x is1 W1
  *   Second TPID in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_TPID2: W3, sparx5: is0
  *   Third TPID in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_VID0: W12, sparx5: is0
+ * VCAP_KF_8021Q_VID0: W12, sparx5: is0, lan966x: is1
  *   First VID in multiple vlan tags (outer tag or default port tag)
- * VCAP_KF_8021Q_VID1: W12, sparx5: is0
+ * VCAP_KF_8021Q_VID1: W12, sparx5: is0, lan966x: is1
  *   Second VID in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_VID2: W12, sparx5: is0
  *   Third VID in multiple vlan tags (not always available)
  * VCAP_KF_8021Q_VID_CLS: sparx5 is2 W13, sparx5 es0 W13, sparx5 es2 W13,
  *   lan966x is2 W12
  *   Classified VID
- * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2, lan966x: is2
+ * VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS: W1, lan966x: is1
+ *   Set if frame has two or more Q-tags. Independent of port VLAN awareness
+ * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2, lan966x: is1/is2
  *   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
  *   one or more Q-tags. Independent of port VLAN awareness
  * VCAP_KF_8021Q_VLAN_TAGS: W3, sparx5: is0
@@ -120,9 +134,9 @@ enum vcap_keyfield_set {
  *   Class of service
  * VCAP_KF_ES0_ISDX_KEY_ENA: W1, sparx5: es2
  *   The value taken from the IFH .FWD.ES0_ISDX_KEY_ENA
- * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Ethernet type
- * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is0/is2/es2, lan966x: is1
  *   Set if frame has EtherType >= 0x600
  * VCAP_KF_HOST_MATCH: W1, lan966x: is2
  *   The action from the SMAC_SIP4 or SMAC_SIP6 lookups. Used for IP source
@@ -134,11 +148,12 @@ enum vcap_keyfield_set {
  *   CPU queue)
  * VCAP_KF_IF_EGR_PORT_NO: W7, sparx5: es0
  *   Egress port number
- * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9, lan966x is2 W4
+ * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9, lan966x is1 W3, lan966x
+ *   is2 W4
  *   Sparx5: Logical ingress port number retrieved from
  *   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
  * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65,
- *   lan966x is2 W9
+ *   lan966x is1 W9, lan966x is2 W9
  *   Ingress port mask, one bit per port/erleg
  * VCAP_KF_IF_IGR_PORT_MASK_L3: W1, sparx5: is2
  *   If set, IF_IGR_PORT_MASK, IF_IGR_PORT_MASK_RNG, and IF_IGR_PORT_MASK_SEL are
@@ -151,24 +166,26 @@ enum vcap_keyfield_set {
  *   Mapping: 0: DEFAULT 1: LOOPBACK 2: MASQUERADE 3: CPU_VD
  * VCAP_KF_IF_IGR_PORT_SEL: W1, sparx5: es2
  *   Selector for IF_IGR_PORT: physical port number or ERLEG
- * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Set if frame has EtherType = 0x800 and IP version = 4
- * VCAP_KF_IP_MC_IS: W1, sparx5: is0
+ * VCAP_KF_IP_MC_IS: W1, sparx5: is0, lan966x: is1
  *   Set if frame is IPv4 frame and frame's destination MAC address is an IPv4
  *   multicast address (0x01005E0 /25). Set if frame is IPv6 frame and frame's
  *   destination MAC address is an IPv6 multicast address (0x3333/16).
- * VCAP_KF_IP_PAYLOAD_5TUPLE: W32, sparx5: is0
+ * VCAP_KF_IP_PAYLOAD_5TUPLE: W32, sparx5: is0, lan966x: is1
  *   Payload bytes after IP header
- * VCAP_KF_IP_SNAP_IS: W1, sparx5: is0
+ * VCAP_KF_IP_PAYLOAD_S1_IP6: W112, lan966x: is1
+ *   Payload after IPv6 header
+ * VCAP_KF_IP_SNAP_IS: W1, sparx5: is0, lan966x: is1
  *   Set if frame is IPv4, IPv6, or SNAP frame
  * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es0/es2
  *   Classified ISDX
  * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es0/es2, lan966x: is2
  *   Set if classified ISDX > 0
- * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Set if frame's destination MAC address is the broadcast address
  *   (FF-FF-FF-FF-FF-FF).
- * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Destination MAC address
  * VCAP_KF_L2_FRM_TYPE: W4, lan966x: is2
  *   Frame subtype for specific EtherTypes (MRP, DLR)
@@ -176,7 +193,9 @@ enum vcap_keyfield_set {
  *   Set if the frame is allowed to be forwarded to front ports
  * VCAP_KF_L2_LLC: W40, lan966x: is2
  *   LLC header and data after up to two VLAN tags and the type/length field
- * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L2_MAC: W48, lan966x: is1
+ *   MAC address (FIRST=1: SMAC, FIRST=0: DMAC)
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Set if frame's destination MAC address is a multicast address (bit 40 = 1).
  * VCAP_KF_L2_PAYLOAD0: W16, lan966x: is2
  *   Payload bytes 0-1 after the frame's EtherType
@@ -188,7 +207,7 @@ enum vcap_keyfield_set {
  *   specifically for PTP frames.
  * VCAP_KF_L2_PAYLOAD_ETYPE: W64, sparx5: is2/es2
  *   Byte 0-7 of L2 payload after Type/Len field and overloading for OAM
- * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Source MAC address
  * VCAP_KF_L2_SNAP: W40, lan966x: is2
  *   SNAP header after LLC header (AA-AA-03)
@@ -196,32 +215,38 @@ enum vcap_keyfield_set {
  *   Set if Src IP matches Dst IP address
  * VCAP_KF_L3_DPL_CLS: W1, sparx5: es0/es2
  *   The frames drop precedence level
- * VCAP_KF_L3_DSCP: W6, sparx5: is0
+ * VCAP_KF_L3_DSCP: W6, sparx5: is0, lan966x: is1
  *   Frame's DSCP value
  * VCAP_KF_L3_DST_IS: W1, sparx5: is2
  *   Set if lookup is done for egress router leg
- * VCAP_KF_L3_FRAGMENT: W1, lan966x: is2
+ * VCAP_KF_L3_FRAGMENT: W1, lan966x: is1/is2
  *   Set if IPv4 frame is fragmented
  * VCAP_KF_L3_FRAGMENT_TYPE: W2, sparx5: is0/is2/es2
  *   L3 Fragmentation type (none, initial, suspicious, valid follow up)
  * VCAP_KF_L3_FRAG_INVLD_L4_LEN: W1, sparx5: is0/is2
  *   Set if frame's L4 length is less than ANA_CL:COMMON:CLM_FRAGMENT_CFG.L4_MIN_L
  *   EN
- * VCAP_KF_L3_FRAG_OFS_GT0: W1, lan966x: is2
+ * VCAP_KF_L3_FRAG_OFS_GT0: W1, lan966x: is1/is2
  *   Set if IPv4 frame is fragmented and it is not the first fragment
- * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Destination IPv4 Address
- * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Source IPv4 Address
- * VCAP_KF_L3_IP6_DIP: W128, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_IP6_DIP: sparx5 is0 W128, sparx5 is2 W128, sparx5 es2 W128,
+ *   lan966x is1 W64, lan966x is1 W128, lan966x is2 W128
  *   Sparx5: Full IPv6 DIP, LAN966x: Either Full IPv6 DIP or a subset depending on
  *   frame type
- * VCAP_KF_L3_IP6_SIP: W128, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_IP6_DIP_MSB: W16, lan966x: is1
+ *   MS 16bits of IPv6 DIP
+ * VCAP_KF_L3_IP6_SIP: sparx5 is0 W128, sparx5 is2 W128, sparx5 es2 W128,
+ *   lan966x is1 W128, lan966x is1 W64, lan966x is2 W128
  *   Sparx5: Full IPv6 SIP, LAN966x: Either Full IPv6 SIP or a subset depending on
  *   frame type
- * VCAP_KF_L3_IP_PROTO: W8, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_IP6_SIP_MSB: W16, lan966x: is1
+ *   MS 16bits of IPv6 DIP
+ * VCAP_KF_L3_IP_PROTO: W8, sparx5: is0/is2/es2, lan966x: is1/is2
  *   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
- * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Set if IPv4 frame contains options (IP len > 5)
  * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96, sparx5
  *   es2 W40, lan966x is2 W56
@@ -254,7 +279,8 @@ enum vcap_keyfield_set {
  * VCAP_KF_L4_PSH: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag PSH, LAN966x: TCP: TCP flag PSH. PTP over UDP: flagField bit
  *   1 (twoStepFlag)
- * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16, lan966x is2 W8
+ * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16, lan966x is1
+ *   W8, lan966x is2 W8
  *   Range checker bitmask (one for each range checker). Input into range checkers
  *   is taken from classified results (VID, DSCP) and frame (SPORT, DPORT, ETYPE,
  *   outer VID, inner VID)
@@ -264,7 +290,7 @@ enum vcap_keyfield_set {
  * VCAP_KF_L4_SEQUENCE_EQ0_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if TCP sequence number is 0, LAN966x: Overlayed with PTP over UDP:
  *   messageType bit 0
- * VCAP_KF_L4_SPORT: W16, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_L4_SPORT: W16, sparx5: is0/is2/es2, lan966x: is1/is2
  *   TCP/UDP source port
  * VCAP_KF_L4_SPORT_EQ_DPORT_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if UDP or TCP source port equals UDP or TCP destination port
@@ -274,13 +300,16 @@ enum vcap_keyfield_set {
  * VCAP_KF_L4_URG: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag URG, LAN966x: TCP: TCP flag URG. PTP over UDP: flagField bit
  *   7 (reserved)
- * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Selects between entries relevant for first and second lookup. Set for first
  *   lookup, cleared for second lookup.
  * VCAP_KF_LOOKUP_GEN_IDX: W12, sparx5: is0
  *   Generic index - for chaining CLM instances
  * VCAP_KF_LOOKUP_GEN_IDX_SEL: W2, sparx5: is0
  *   Select the mode of the Generic Index
+ * VCAP_KF_LOOKUP_INDEX: W2, lan966x: is1
+ *   0: First lookup, 1: Second lookup, 2: Third lookup, Similar to VCAP_KF_FIRST
+ *   but with extra info
  * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2, lan966x: is2
  *   Classified Policy Association Group: chains rules from IS1/CLM to IS2
  * VCAP_KF_MIRROR_PROBE: W2, sparx5: es2
@@ -303,14 +332,22 @@ enum vcap_keyfield_set {
  *   Set if frame's EtherType = 0x8902
  * VCAP_KF_PROT_ACTIVE: W1, sparx5: es0/es2
  *   Protection is active
- * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
+ * VCAP_KF_RT_FRMID: W32, lan966x: is1
+ *   Profinet or OPC-UA FrameId
+ * VCAP_KF_RT_TYPE: W2, lan966x: is1
+ *   Encoding of frame's EtherType: 0: Other, 1: Profinet, 2: OPC-UA, 3: Custom
+ *   (ANA::RT_CUSTOM)
+ * VCAP_KF_RT_VLAN_IDX: W3, lan966x: is1
+ *   Real-time VLAN index from ANA::RT_VLAN_PCP
+ * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
  *   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
  *   header = 6)
- * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2, lan966x: is1
  *   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
  *   or 17)
  * VCAP_KF_TYPE: sparx5 is0 W2, sparx5 is0 W1, sparx5 is2 W4, sparx5 is2 W2,
- *   sparx5 es0 W1, sparx5 es2 W3, lan966x is2 W4, lan966x is2 W2
+ *   sparx5 es0 W1, sparx5 es2 W3, lan966x is1 W1, lan966x is1 W2, lan966x is2 W4,
+ *   lan966x is2 W2
  *   Keyset type id - set by the API
  */
 
@@ -323,6 +360,7 @@ enum vcap_key_field {
 	VCAP_KF_8021BR_GRP,
 	VCAP_KF_8021BR_IGR_ECID_BASE,
 	VCAP_KF_8021BR_IGR_ECID_EXT,
+	VCAP_KF_8021CB_R_TAGGED_IS,
 	VCAP_KF_8021Q_DEI0,
 	VCAP_KF_8021Q_DEI1,
 	VCAP_KF_8021Q_DEI2,
@@ -339,6 +377,7 @@ enum vcap_key_field {
 	VCAP_KF_8021Q_VID1,
 	VCAP_KF_8021Q_VID2,
 	VCAP_KF_8021Q_VID_CLS,
+	VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS,
 	VCAP_KF_8021Q_VLAN_TAGGED_IS,
 	VCAP_KF_8021Q_VLAN_TAGS,
 	VCAP_KF_ACL_GRP_ID,
@@ -366,6 +405,7 @@ enum vcap_key_field {
 	VCAP_KF_IP4_IS,
 	VCAP_KF_IP_MC_IS,
 	VCAP_KF_IP_PAYLOAD_5TUPLE,
+	VCAP_KF_IP_PAYLOAD_S1_IP6,
 	VCAP_KF_IP_SNAP_IS,
 	VCAP_KF_ISDX_CLS,
 	VCAP_KF_ISDX_GT0_IS,
@@ -374,6 +414,7 @@ enum vcap_key_field {
 	VCAP_KF_L2_FRM_TYPE,
 	VCAP_KF_L2_FWD_IS,
 	VCAP_KF_L2_LLC,
+	VCAP_KF_L2_MAC,
 	VCAP_KF_L2_MC_IS,
 	VCAP_KF_L2_PAYLOAD0,
 	VCAP_KF_L2_PAYLOAD1,
@@ -392,7 +433,9 @@ enum vcap_key_field {
 	VCAP_KF_L3_IP4_DIP,
 	VCAP_KF_L3_IP4_SIP,
 	VCAP_KF_L3_IP6_DIP,
+	VCAP_KF_L3_IP6_DIP_MSB,
 	VCAP_KF_L3_IP6_SIP,
+	VCAP_KF_L3_IP6_SIP_MSB,
 	VCAP_KF_L3_IP_PROTO,
 	VCAP_KF_L3_OPTIONS_IS,
 	VCAP_KF_L3_PAYLOAD,
@@ -416,6 +459,7 @@ enum vcap_key_field {
 	VCAP_KF_LOOKUP_FIRST_IS,
 	VCAP_KF_LOOKUP_GEN_IDX,
 	VCAP_KF_LOOKUP_GEN_IDX_SEL,
+	VCAP_KF_LOOKUP_INDEX,
 	VCAP_KF_LOOKUP_PAG,
 	VCAP_KF_MIRROR_PROBE,
 	VCAP_KF_OAM_CCM_CNTS_EQ0,
@@ -427,6 +471,9 @@ enum vcap_key_field {
 	VCAP_KF_OAM_VER,
 	VCAP_KF_OAM_Y1731_IS,
 	VCAP_KF_PROT_ACTIVE,
+	VCAP_KF_RT_FRMID,
+	VCAP_KF_RT_TYPE,
+	VCAP_KF_RT_VLAN_IDX,
 	VCAP_KF_TCP_IS,
 	VCAP_KF_TCP_UDP_IS,
 	VCAP_KF_TYPE,
@@ -440,6 +487,7 @@ enum vcap_actionfield_set {
 	VCAP_AFS_CLASS_REDUCED,     /* sparx5 is0 X1 */
 	VCAP_AFS_ES0,               /* sparx5 es0 X1 */
 	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
+	VCAP_AFS_S1,                /* lan966x is1 X1 */
 	VCAP_AFS_SMAC_SIP,          /* lan966x is2 X1 */
 };
 
@@ -470,23 +518,31 @@ enum vcap_actionfield_set {
  *   CPU extraction queue. Used when FWD_SEL >0 and PIPELINE_ACT = XTR.
  * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2/es2, lan966x: is2
  *   CPU queue number. Used when CPU_COPY_ENA is set.
+ * VCAP_AF_CUSTOM_ACE_TYPE_ENA: W4, lan966x: is1
+ *   Enables use of custom keys in IS2. Bits 3:2 control second lookup in IS2
+ *   while bits 1:0 control first lookup. Encoding per lookup: 0: Disabled.  1:
+ *   Extract 40 bytes after position corresponding to the location of the IPv4
+ *   header and use as key.  2: Extract 40 bytes after SMAC and use as key
  * VCAP_AF_DEI_A_VAL: W1, sparx5: es0
  *   DEI used in ES0 tag A. See TAG_A_DEI_SEL.
  * VCAP_AF_DEI_B_VAL: W1, sparx5: es0
  *   DEI used in ES0 tag B. See TAG_B_DEI_SEL.
  * VCAP_AF_DEI_C_VAL: W1, sparx5: es0
  *   DEI used in ES0 tag C. See TAG_C_DEI_SEL.
- * VCAP_AF_DEI_ENA: W1, sparx5: is0
+ * VCAP_AF_DEI_ENA: W1, sparx5: is0, lan966x: is1
  *   If set, use DEI_VAL as classified DEI value. Otherwise, DEI from basic
  *   classification is used
- * VCAP_AF_DEI_VAL: W1, sparx5: is0
+ * VCAP_AF_DEI_VAL: W1, sparx5: is0, lan966x: is1
  *   See DEI_ENA
- * VCAP_AF_DP_ENA: W1, sparx5: is0
+ * VCAP_AF_DLR_SEL: W2, lan966x: is1
+ *   0: No changes to port-based selection in ANA:PORT:OAM_CFG.DLR_ENA.  1: Enable
+ *   DLR frame processing 2: Disable DLR processing
+ * VCAP_AF_DP_ENA: W1, sparx5: is0, lan966x: is1
  *   If set, use DP_VAL as classified drop precedence level. Otherwise, drop
  *   precedence level from basic classification is used.
- * VCAP_AF_DP_VAL: W2, sparx5: is0
+ * VCAP_AF_DP_VAL: sparx5 is0 W2, lan966x is1 W1
  *   See DP_ENA.
- * VCAP_AF_DSCP_ENA: W1, sparx5: is0
+ * VCAP_AF_DSCP_ENA: W1, sparx5: is0, lan966x: is1
  *   If set, use DSCP_VAL as classified DSCP value. Otherwise, DSCP value from
  *   basic classification is used.
  * VCAP_AF_DSCP_SEL: W3, sparx5: es0
@@ -495,7 +551,7 @@ enum vcap_actionfield_set {
  *   table 0, otherwise use DSCP_VAL. 5: Mapped using mapping table 1, otherwise
  *   use mapping table 0. 6: Mapped using mapping table 2, otherwise use DSCP_VAL.
  *   7: Mapped using mapping table 3, otherwise use mapping table 2
- * VCAP_AF_DSCP_VAL: W6, sparx5: is0/es0
+ * VCAP_AF_DSCP_VAL: W6, sparx5: is0/es0, lan966x: is1
  *   See DSCP_ENA.
  * VCAP_AF_ES2_REW_CMD: W3, sparx5: es2
  *   Command forwarded to REW: 0: No action. 1: SWAP MAC addresses. 2: Do L2CP
@@ -529,9 +585,16 @@ enum vcap_actionfield_set {
  * VCAP_AF_ISDX_ADD_REPLACE_SEL: W1, sparx5: is0
  *   Controls the classified ISDX. 0: New ISDX = old ISDX + ISDX_VAL. 1: New ISDX
  *   = ISDX_VAL.
+ * VCAP_AF_ISDX_ADD_VAL: W8, lan966x: is1
+ *   If ISDX_REPLACE_ENA is set, ISDX_ADD_VAL is used directly as the new ISDX.
+ *   Encoding: ISDX_REPLACE_ENA=0, ISDX_ADD_VAL=0: Disabled ISDX_EPLACE_ENA=0,
+ *   ISDX_ADD_VAL>0: Add value to classified ISDX. ISDX_REPLACE_ENA=1: Replace
+ *   with ISDX_ADD_VAL value.
  * VCAP_AF_ISDX_ENA: W1, lan966x: is2
  *   Setting this bit to 1 causes the classified ISDX to be set to the value of
  *   POLICE_IDX[8:0].
+ * VCAP_AF_ISDX_REPLACE_ENA: W1, lan966x: is1
+ *   If set, classified ISDX is set to ISDX_ADD_VAL.
  * VCAP_AF_ISDX_VAL: W12, sparx5: is0
  *   See isdx_add_replace_sel
  * VCAP_AF_LOOP_ENA: W1, sparx5: es0
@@ -572,14 +635,22 @@ enum vcap_actionfield_set {
  * VCAP_AF_MIRROR_PROBE_ID: W2, sparx5: es2
  *   Signals a mirror probe to be placed in the IFH. Only possible when FWD_MODE
  *   is copy. 0: No mirroring. 1-3: Use mirror probe 0-2.
+ * VCAP_AF_MRP_SEL: W2, lan966x: is1
+ *   0: No changes to port-based selection in ANA:PORT:OAM_CFG.MRP_ENA.  1: Enable
+ *   MRP frame processing 2: Disable MRP processing
  * VCAP_AF_NXT_IDX: W12, sparx5: is0
  *   Index used as part of key (field G_IDX) in the next lookup.
  * VCAP_AF_NXT_IDX_CTRL: W3, sparx5: is0
  *   Controls the generation of the G_IDX used in the VCAP CLM next lookup
- * VCAP_AF_PAG_OVERRIDE_MASK: W8, sparx5: is0
+ * VCAP_AF_OAM_SEL: W3, lan966x: is1
+ *   0: No changes to port-based selection in ANA:PORT:OAM_CFG.OAM_CFG 1: Enable
+ *   OAM frame processing for untagged frames 2: Enable OAM frame processing for
+ *   single frames 3: Enable OAM frame processing for double frames 4: Disable OAM
+ *   frame processing
+ * VCAP_AF_PAG_OVERRIDE_MASK: W8, sparx5: is0, lan966x: is1
  *   Bits set in this mask will override PAG_VAL from port profile. New PAG = (PAG
  *   (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
- * VCAP_AF_PAG_VAL: W8, sparx5: is0
+ * VCAP_AF_PAG_VAL: W8, sparx5: is0, lan966x: is1
  *   See PAG_OVERRIDE_MASK.
  * VCAP_AF_PCP_A_VAL: W3, sparx5: es0
  *   PCP used in ES0 tag A. See TAG_A_PCP_SEL.
@@ -587,10 +658,10 @@ enum vcap_actionfield_set {
  *   PCP used in ES0 tag B. See TAG_B_PCP_SEL.
  * VCAP_AF_PCP_C_VAL: W3, sparx5: es0
  *   PCP used in ES0 tag C. See TAG_C_PCP_SEL.
- * VCAP_AF_PCP_ENA: W1, sparx5: is0
+ * VCAP_AF_PCP_ENA: W1, sparx5: is0, lan966x: is1
  *   If set, use PCP_VAL as classified PCP value. Otherwise, PCP from basic
  *   classification is used.
- * VCAP_AF_PCP_VAL: W3, sparx5: is0
+ * VCAP_AF_PCP_VAL: W3, sparx5: is0, lan966x: is1
  *   See PCP_ENA.
  * VCAP_AF_PIPELINE_ACT: W1, sparx5: es0
  *   Pipeline action when FWD_SEL > 0. 0: XTR. CPU_QU selects CPU extraction queue
@@ -600,11 +671,11 @@ enum vcap_actionfield_set {
  *   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
  * VCAP_AF_PIPELINE_PT: sparx5 is2 W5, sparx5 es0 W2
  *   Pipeline point used if PIPELINE_FORCE_ENA is set
- * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2, lan966x: is2
- *   Setting this bit to 1 causes frames that hit this action to be policed by the
- *   ACL policer specified in POLICE_IDX. Only applies to the first lookup.
- * VCAP_AF_POLICE_IDX: sparx5 is2 W6, sparx5 es2 W6, lan966x is2 W9
- *   Selects VCAP policer used when policing frames (POLICE_ENA)
+ * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2, lan966x: is1/is2
+ *   If set, POLICE_IDX is used to lookup ANA::POL.
+ * VCAP_AF_POLICE_IDX: sparx5 is2 W6, sparx5 es2 W6, lan966x is1 W9, lan966x is2
+ *   W9
+ *   Policer index.
  * VCAP_AF_POLICE_REMARK: W1, sparx5: es2
  *   If set, frames exceeding policer rates are marked as yellow but not
  *   discarded.
@@ -628,16 +699,24 @@ enum vcap_actionfield_set {
  *   port. 1: ES0 tag A: Push ES0 tag A. No port tag. 2: Force port tag: Always
  *   push port tag. No ES0 tag A. 3: Force untag: Never push port tag or ES0 tag
  *   A.
- * VCAP_AF_QOS_ENA: W1, sparx5: is0
+ * VCAP_AF_QOS_ENA: W1, sparx5: is0, lan966x: is1
  *   If set, use QOS_VAL as classified QoS class. Otherwise, QoS class from basic
  *   classification is used.
- * VCAP_AF_QOS_VAL: W3, sparx5: is0
+ * VCAP_AF_QOS_VAL: W3, sparx5: is0, lan966x: is1
  *   See QOS_ENA.
  * VCAP_AF_REW_OP: W16, lan966x: is2
  *   Rewriter operation command.
  * VCAP_AF_RT_DIS: W1, sparx5: is2
  *   If set, routing is disallowed. Only applies when IS_INNER_ACL is 0. See also
  *   IGR_ACL_ENA, EGR_ACL_ENA, and RLEG_STAT_IDX.
+ * VCAP_AF_SFID_ENA: W1, lan966x: is1
+ *   If set, SFID_VAL is used to lookup ANA::SFID.
+ * VCAP_AF_SFID_VAL: W8, lan966x: is1
+ *   Stream filter identifier.
+ * VCAP_AF_SGID_ENA: W1, lan966x: is1
+ *   If set, SGID_VAL is used to lookup ANA::SGID.
+ * VCAP_AF_SGID_VAL: W8, lan966x: is1
+ *   Stream gate identifier.
  * VCAP_AF_SWAP_MACS_ENA: W1, sparx5: es0
  *   This setting is only active when FWD_SEL = 1 or FWD_SEL = 2 and PIPELINE_ACT
  *   = LBK_ASM. 0: No action. 1: Swap MACs and clear bit 40 in new SMAC.
@@ -686,7 +765,7 @@ enum vcap_actionfield_set {
  * VCAP_AF_TAG_C_VID_SEL: W2, sparx5: es0
  *   Selects VID for ES0 tag C. The resulting VID is termed C-TAG.VID. 0:
  *   Classified VID. 1: VID_C_VAL. 2: IFH.ENCAP.GVID. 3: Reserved.
- * VCAP_AF_TYPE: W1, sparx5: is0
+ * VCAP_AF_TYPE: W1, sparx5: is0, lan966x: is1
  *   Actionset type id - Set by the API
  * VCAP_AF_UNTAG_VID_ENA: W1, sparx5: es0
  *   Controls insertion of tag C. Untag or insert mode can be selected. See
@@ -697,8 +776,19 @@ enum vcap_actionfield_set {
  *   VID used in ES0 tag B. See TAG_B_VID_SEL.
  * VCAP_AF_VID_C_VAL: W12, sparx5: es0
  *   VID used in ES0 tag C. See TAG_C_VID_SEL.
- * VCAP_AF_VID_VAL: W13, sparx5: is0
+ * VCAP_AF_VID_REPLACE_ENA: W1, lan966x: is1
+ *   Controls the classified VID: VID_REPLACE_ENA=0: Add VID_ADD_VAL to basic
+ *   classified VID and use result as new classified VID. VID_REPLACE_ENA = 1:
+ *   Replace basic classified VID with VID_VAL value and use as new classified
+ *   VID.
+ * VCAP_AF_VID_VAL: sparx5 is0 W13, lan966x is1 W12
  *   New VID Value
+ * VCAP_AF_VLAN_POP_CNT: W2, lan966x: is1
+ *   See VLAN_POP_CNT_ENA
+ * VCAP_AF_VLAN_POP_CNT_ENA: W1, lan966x: is1
+ *   If set, use VLAN_POP_CNT as the number of VLAN tags to pop from the incoming
+ *   frame. This number is used by the Rewriter. Otherwise, VLAN_POP_CNT from
+ *   ANA:PORT:VLAN_CFG.VLAN_POP_CNT is used
  */
 
 /* Actionfield names */
@@ -712,11 +802,13 @@ enum vcap_action_field {
 	VCAP_AF_CPU_COPY_ENA,
 	VCAP_AF_CPU_QU,
 	VCAP_AF_CPU_QUEUE_NUM,
+	VCAP_AF_CUSTOM_ACE_TYPE_ENA,
 	VCAP_AF_DEI_A_VAL,
 	VCAP_AF_DEI_B_VAL,
 	VCAP_AF_DEI_C_VAL,
 	VCAP_AF_DEI_ENA,
 	VCAP_AF_DEI_VAL,
+	VCAP_AF_DLR_SEL,
 	VCAP_AF_DP_ENA,
 	VCAP_AF_DP_VAL,
 	VCAP_AF_DSCP_ENA,
@@ -732,7 +824,9 @@ enum vcap_action_field {
 	VCAP_AF_IGNORE_PIPELINE_CTRL,
 	VCAP_AF_INTR_ENA,
 	VCAP_AF_ISDX_ADD_REPLACE_SEL,
+	VCAP_AF_ISDX_ADD_VAL,
 	VCAP_AF_ISDX_ENA,
+	VCAP_AF_ISDX_REPLACE_ENA,
 	VCAP_AF_ISDX_VAL,
 	VCAP_AF_LOOP_ENA,
 	VCAP_AF_LRN_DIS,
@@ -745,8 +839,10 @@ enum vcap_action_field {
 	VCAP_AF_MIRROR_ENA,
 	VCAP_AF_MIRROR_PROBE,
 	VCAP_AF_MIRROR_PROBE_ID,
+	VCAP_AF_MRP_SEL,
 	VCAP_AF_NXT_IDX,
 	VCAP_AF_NXT_IDX_CTRL,
+	VCAP_AF_OAM_SEL,
 	VCAP_AF_PAG_OVERRIDE_MASK,
 	VCAP_AF_PAG_VAL,
 	VCAP_AF_PCP_A_VAL,
@@ -770,6 +866,10 @@ enum vcap_action_field {
 	VCAP_AF_QOS_VAL,
 	VCAP_AF_REW_OP,
 	VCAP_AF_RT_DIS,
+	VCAP_AF_SFID_ENA,
+	VCAP_AF_SFID_VAL,
+	VCAP_AF_SGID_ENA,
+	VCAP_AF_SGID_VAL,
 	VCAP_AF_SWAP_MACS_ENA,
 	VCAP_AF_TAG_A_DEI_SEL,
 	VCAP_AF_TAG_A_PCP_SEL,
@@ -788,7 +888,10 @@ enum vcap_action_field {
 	VCAP_AF_VID_A_VAL,
 	VCAP_AF_VID_B_VAL,
 	VCAP_AF_VID_C_VAL,
+	VCAP_AF_VID_REPLACE_ENA,
 	VCAP_AF_VID_VAL,
+	VCAP_AF_VLAN_POP_CNT,
+	VCAP_AF_VLAN_POP_CNT_ENA,
 };
 
 #endif /* __VCAP_AG_API__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index 0de3f677135a8..b23c11b0647c9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -387,7 +387,7 @@ static const char * const test_admin_info_expect[] = {
 	"default_cnt: 73\n",
 	"require_cnt_dis: 0\n",
 	"version: 1\n",
-	"vtype: 3\n",
+	"vtype: 4\n",
 	"vinst: 0\n",
 	"ingress: 1\n",
 	"first_cid: 10000\n",
@@ -435,7 +435,7 @@ static const char * const test_admin_expect[] = {
 	"default_cnt: 73\n",
 	"require_cnt_dis: 0\n",
 	"version: 1\n",
-	"vtype: 3\n",
+	"vtype: 4\n",
 	"vinst: 0\n",
 	"ingress: 1\n",
 	"first_cid: 8000000\n",
-- 
2.38.0

