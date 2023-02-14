Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCC7696127
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjBNKmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjBNKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:41:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E9265B8;
        Tue, 14 Feb 2023 02:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676371283; x=1707907283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=agk284JXCde2I3EYUJysAECUhHtTiAFct0qFKTqHM1g=;
  b=LLKjl1t54greaOa5NVMgh5P2MGnm34LfPON4zy873TUN+qwnLce7ftw7
   G5sDYa9t4QKX2tJhBlSFUtdisvbyRUNW7TRc5SC0lr7AFbD+7CzyFGlLn
   BdY0VkDkj74MHz+97LaoQkmFXL8Aoobhxg+z/dh+qY7rTRcjDVtcGQVQy
   KISVOo/dr4uc+lCXyAnLaWa7XOnn0woR/zaonmoyGqEKHYFtIghADfyzH
   NOYdsK0unkZut9EmoWdCm6I/H8WgPEQKRQVYG5c5uGlCvzuIvtmiSDQug
   2hPuz84iEGrx8WIPtaMQy6muHB3yrx4owu3zzauemejIRthJRo0Mx1dFP
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="200856784"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 03:41:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 03:41:18 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 03:41:14 -0700
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
Subject: [PATCH net-next v2 06/10] net: microchip: sparx5: Add ES0 VCAP model and updated KUNIT VCAP model
Date:   Tue, 14 Feb 2023 11:40:45 +0100
Message-ID: <20230214104049.1553059-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214104049.1553059-1-steen.hegelund@microchip.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
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

This provides the VCAP model for the Sparx5 ES0 (Egress Stage 0) VCAP.

This VCAP provides rewriting functionality in the egress path.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 385 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h | 174 +++++++-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |   4 +-
 .../microchip/vcap/vcap_model_kunit.c         | 270 +++++++-----
 .../microchip/vcap/vcap_model_kunit.h         |  10 +-
 5 files changed, 721 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
index 561001ee0516..556d6ea0acd1 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
@@ -3,8 +3,8 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2023-01-17 16:55:38 +0100.
- * Commit ID: cc027a9bd71002aebf074df5ad8584fe1545e05e
+/* This file is autogenerated by cml-utils 2023-02-10 11:15:56 +0100.
+ * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
  */
 
 #include <linux/types.h>
@@ -1333,6 +1333,54 @@ static const struct vcap_field is2_ip_7tuple_keyfield[] = {
 	},
 };
 
+static const struct vcap_field es0_isdx_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_KF_IF_EGR_PORT_NO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 1,
+		.width = 7,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 8,
+		.width = 13,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 21,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_TPID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 24,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 27,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_PROT_ACTIVE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 29,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 39,
+		.width = 12,
+	},
+};
+
 static const struct vcap_field es2_mac_etype_keyfield[] = {
 	[VCAP_KF_TYPE] = {
 		.type = VCAP_FIELD_U32,
@@ -2283,6 +2331,14 @@ static const struct vcap_set is2_keyfield_set[] = {
 	},
 };
 
+static const struct vcap_set es0_keyfield_set[] = {
+	[VCAP_KFS_ISDX] = {
+		.type_id = 0,
+		.sw_per_item = 1,
+		.sw_cnt = 1,
+	},
+};
+
 static const struct vcap_set es2_keyfield_set[] = {
 	[VCAP_KFS_MAC_ETYPE] = {
 		.type_id = 0,
@@ -2331,6 +2387,10 @@ static const struct vcap_field *is2_keyfield_set_map[] = {
 	[VCAP_KFS_IP_7TUPLE] = is2_ip_7tuple_keyfield,
 };
 
+static const struct vcap_field *es0_keyfield_set_map[] = {
+	[VCAP_KFS_ISDX] = es0_isdx_keyfield,
+};
+
 static const struct vcap_field *es2_keyfield_set_map[] = {
 	[VCAP_KFS_MAC_ETYPE] = es2_mac_etype_keyfield,
 	[VCAP_KFS_ARP] = es2_arp_keyfield,
@@ -2355,6 +2415,10 @@ static int is2_keyfield_set_map_size[] = {
 	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(is2_ip_7tuple_keyfield),
 };
 
+static int es0_keyfield_set_map_size[] = {
+	[VCAP_KFS_ISDX] = ARRAY_SIZE(es0_isdx_keyfield),
+};
+
 static int es2_keyfield_set_map_size[] = {
 	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(es2_mac_etype_keyfield),
 	[VCAP_KFS_ARP] = ARRAY_SIZE(es2_arp_keyfield),
@@ -2752,6 +2816,184 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 	},
 };
 
+static const struct vcap_field es0_es0_actionfield[] = {
+	[VCAP_AF_PUSH_OUTER_TAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 2,
+	},
+	[VCAP_AF_PUSH_INNER_TAG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 2,
+		.width = 1,
+	},
+	[VCAP_AF_TAG_A_TPID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 3,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_A_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 6,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_A_PCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 8,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_A_DEI_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 11,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_B_TPID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 14,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_B_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_B_PCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 19,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_B_DEI_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 22,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_C_TPID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 25,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_C_PCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 28,
+		.width = 3,
+	},
+	[VCAP_AF_TAG_C_DEI_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 31,
+		.width = 3,
+	},
+	[VCAP_AF_VID_A_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 34,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_A_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 46,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_A_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 49,
+		.width = 1,
+	},
+	[VCAP_AF_VID_B_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 50,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_B_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 62,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_B_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 65,
+		.width = 1,
+	},
+	[VCAP_AF_VID_C_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 66,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_C_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_C_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 81,
+		.width = 1,
+	},
+	[VCAP_AF_POP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 82,
+		.width = 2,
+	},
+	[VCAP_AF_UNTAG_VID_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 84,
+		.width = 1,
+	},
+	[VCAP_AF_PUSH_CUSTOMER_TAG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 85,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_C_VID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 2,
+	},
+	[VCAP_AF_DSCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 127,
+		.width = 3,
+	},
+	[VCAP_AF_DSCP_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 130,
+		.width = 6,
+	},
+	[VCAP_AF_ESDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 323,
+		.width = 13,
+	},
+	[VCAP_AF_FWD_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 459,
+		.width = 2,
+	},
+	[VCAP_AF_CPU_QU] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 461,
+		.width = 3,
+	},
+	[VCAP_AF_PIPELINE_PT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 464,
+		.width = 2,
+	},
+	[VCAP_AF_PIPELINE_ACT] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 466,
+		.width = 1,
+	},
+	[VCAP_AF_SWAP_MACS_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 475,
+		.width = 1,
+	},
+	[VCAP_AF_LOOP_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 476,
+		.width = 1,
+	},
+};
+
 static const struct vcap_field es2_base_type_actionfield[] = {
 	[VCAP_AF_HIT_ME_ONCE] = {
 		.type = VCAP_FIELD_BIT,
@@ -2852,6 +3094,14 @@ static const struct vcap_set is2_actionfield_set[] = {
 	},
 };
 
+static const struct vcap_set es0_actionfield_set[] = {
+	[VCAP_AFS_ES0] = {
+		.type_id = -1,
+		.sw_per_item = 1,
+		.sw_cnt = 1,
+	},
+};
+
 static const struct vcap_set es2_actionfield_set[] = {
 	[VCAP_AFS_BASE_TYPE] = {
 		.type_id = -1,
@@ -2871,6 +3121,10 @@ static const struct vcap_field *is2_actionfield_set_map[] = {
 	[VCAP_AFS_BASE_TYPE] = is2_base_type_actionfield,
 };
 
+static const struct vcap_field *es0_actionfield_set_map[] = {
+	[VCAP_AFS_ES0] = es0_es0_actionfield,
+};
+
 static const struct vcap_field *es2_actionfield_set_map[] = {
 	[VCAP_AFS_BASE_TYPE] = es2_base_type_actionfield,
 };
@@ -2886,6 +3140,10 @@ static int is2_actionfield_set_map_size[] = {
 	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(is2_base_type_actionfield),
 };
 
+static int es0_actionfield_set_map_size[] = {
+	[VCAP_AFS_ES0] = ARRAY_SIZE(es0_es0_actionfield),
+};
+
 static int es2_actionfield_set_map_size[] = {
 	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(es2_base_type_actionfield),
 };
@@ -2990,10 +3248,35 @@ static const struct vcap_typegroup is0_x6_keyfield_set_typegroups[] = {
 };
 
 static const struct vcap_typegroup is0_x3_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 3,
+		.value = 4,
+	},
+	{
+		.offset = 52,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 104,
+		.width = 2,
+		.value = 0,
+	},
 	{}
 };
 
 static const struct vcap_typegroup is0_x2_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 52,
+		.width = 1,
+		.value = 0,
+	},
 	{}
 };
 
@@ -3047,6 +3330,10 @@ static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es0_x1_keyfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup es2_x12_keyfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -3086,6 +3373,11 @@ static const struct vcap_typegroup es2_x6_keyfield_set_typegroups[] = {
 };
 
 static const struct vcap_typegroup es2_x3_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 1,
+		.value = 1,
+	},
 	{}
 };
 
@@ -3110,6 +3402,11 @@ static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[13] = NULL,
 };
 
+static const struct vcap_typegroup *es0_keyfield_set_typegroups[] = {
+	[1] = es0_x1_keyfield_set_typegroups,
+	[2] = NULL,
+};
+
 static const struct vcap_typegroup *es2_keyfield_set_typegroups[] = {
 	[12] = es2_x12_keyfield_set_typegroups,
 	[6] = es2_x6_keyfield_set_typegroups,
@@ -3183,6 +3480,10 @@ static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es0_x1_actionfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup es2_x3_actionfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -3219,6 +3520,11 @@ static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 	[13] = NULL,
 };
 
+static const struct vcap_typegroup *es0_actionfield_set_typegroups[] = {
+	[1] = es0_x1_actionfield_set_typegroups,
+	[2] = NULL,
+};
+
 static const struct vcap_typegroup *es2_actionfield_set_typegroups[] = {
 	[3] = es2_x3_actionfield_set_typegroups,
 	[1] = es2_x1_actionfield_set_typegroups,
@@ -3229,18 +3535,24 @@ static const struct vcap_typegroup *es2_actionfield_set_typegroups[] = {
 static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_NO_VALUE]                      =  "(None)",
 	[VCAP_KFS_ARP]                           =  "VCAP_KFS_ARP",
+	[VCAP_KFS_ETAG]                          =  "VCAP_KFS_ETAG",
 	[VCAP_KFS_IP4_OTHER]                     =  "VCAP_KFS_IP4_OTHER",
 	[VCAP_KFS_IP4_TCP_UDP]                   =  "VCAP_KFS_IP4_TCP_UDP",
+	[VCAP_KFS_IP4_VID]                       =  "VCAP_KFS_IP4_VID",
 	[VCAP_KFS_IP6_OTHER]                     =  "VCAP_KFS_IP6_OTHER",
 	[VCAP_KFS_IP6_STD]                       =  "VCAP_KFS_IP6_STD",
 	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
+	[VCAP_KFS_IP6_VID]                       =  "VCAP_KFS_IP6_VID",
 	[VCAP_KFS_IP_7TUPLE]                     =  "VCAP_KFS_IP_7TUPLE",
+	[VCAP_KFS_ISDX]                          =  "VCAP_KFS_ISDX",
+	[VCAP_KFS_LL_FULL]                       =  "VCAP_KFS_LL_FULL",
 	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
 	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
 	[VCAP_KFS_MAC_SNAP]                      =  "VCAP_KFS_MAC_SNAP",
 	[VCAP_KFS_NORMAL_5TUPLE_IP4]             =  "VCAP_KFS_NORMAL_5TUPLE_IP4",
 	[VCAP_KFS_NORMAL_7TUPLE]                 =  "VCAP_KFS_NORMAL_7TUPLE",
 	[VCAP_KFS_OAM]                           =  "VCAP_KFS_OAM",
+	[VCAP_KFS_PURE_5TUPLE_IP4]               =  "VCAP_KFS_PURE_5TUPLE_IP4",
 	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
 	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
 };
@@ -3251,6 +3563,7 @@ static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
 	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
 	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
+	[VCAP_AFS_ES0]                           =  "VCAP_AFS_ES0",
 	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
 	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
 };
@@ -3258,6 +3571,12 @@ static const char * const vcap_actionfield_set_names[] = {
 /* Keyfield names */
 static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_NO_VALUE]                       =  "(None)",
+	[VCAP_KF_8021BR_ECID_BASE]               =  "8021BR_ECID_BASE",
+	[VCAP_KF_8021BR_ECID_EXT]                =  "8021BR_ECID_EXT",
+	[VCAP_KF_8021BR_E_TAGGED]                =  "8021BR_E_TAGGED",
+	[VCAP_KF_8021BR_GRP]                     =  "8021BR_GRP",
+	[VCAP_KF_8021BR_IGR_ECID_BASE]           =  "8021BR_IGR_ECID_BASE",
+	[VCAP_KF_8021BR_IGR_ECID_EXT]            =  "8021BR_IGR_ECID_EXT",
 	[VCAP_KF_8021Q_DEI0]                     =  "8021Q_DEI0",
 	[VCAP_KF_8021Q_DEI1]                     =  "8021Q_DEI1",
 	[VCAP_KF_8021Q_DEI2]                     =  "8021Q_DEI2",
@@ -3266,6 +3585,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_8021Q_PCP1]                     =  "8021Q_PCP1",
 	[VCAP_KF_8021Q_PCP2]                     =  "8021Q_PCP2",
 	[VCAP_KF_8021Q_PCP_CLS]                  =  "8021Q_PCP_CLS",
+	[VCAP_KF_8021Q_TPID]                     =  "8021Q_TPID",
 	[VCAP_KF_8021Q_TPID0]                    =  "8021Q_TPID0",
 	[VCAP_KF_8021Q_TPID1]                    =  "8021Q_TPID1",
 	[VCAP_KF_8021Q_TPID2]                    =  "8021Q_TPID2",
@@ -3275,6 +3595,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_8021Q_VID_CLS]                  =  "8021Q_VID_CLS",
 	[VCAP_KF_8021Q_VLAN_TAGGED_IS]           =  "8021Q_VLAN_TAGGED_IS",
 	[VCAP_KF_8021Q_VLAN_TAGS]                =  "8021Q_VLAN_TAGS",
+	[VCAP_KF_ACL_GRP_ID]                     =  "ACL_GRP_ID",
 	[VCAP_KF_ARP_ADDR_SPACE_OK_IS]           =  "ARP_ADDR_SPACE_OK_IS",
 	[VCAP_KF_ARP_LEN_OK_IS]                  =  "ARP_LEN_OK_IS",
 	[VCAP_KF_ARP_OPCODE]                     =  "ARP_OPCODE",
@@ -3283,11 +3604,13 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ARP_SENDER_MATCH_IS]            =  "ARP_SENDER_MATCH_IS",
 	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
 	[VCAP_KF_COSID_CLS]                      =  "COSID_CLS",
+	[VCAP_KF_ES0_ISDX_KEY_ENA]               =  "ES0_ISDX_KEY_ENA",
 	[VCAP_KF_ETYPE]                          =  "ETYPE",
 	[VCAP_KF_ETYPE_LEN_IS]                   =  "ETYPE_LEN_IS",
 	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
 	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
+	[VCAP_KF_IF_EGR_PORT_NO]                 =  "IF_EGR_PORT_NO",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
 	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
@@ -3348,6 +3671,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_LOOKUP_GEN_IDX]                 =  "LOOKUP_GEN_IDX",
 	[VCAP_KF_LOOKUP_GEN_IDX_SEL]             =  "LOOKUP_GEN_IDX_SEL",
 	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
+	[VCAP_KF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
 	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
 	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
 	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
@@ -3356,6 +3680,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
 	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
 	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
+	[VCAP_KF_PROT_ACTIVE]                    =  "PROT_ACTIVE",
 	[VCAP_KF_TCP_IS]                         =  "TCP_IS",
 	[VCAP_KF_TCP_UDP_IS]                     =  "TCP_UDP_IS",
 	[VCAP_KF_TYPE]                           =  "TYPE",
@@ -3370,16 +3695,23 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
 	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
+	[VCAP_AF_CPU_QU]                         =  "CPU_QU",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
+	[VCAP_AF_DEI_A_VAL]                      =  "DEI_A_VAL",
+	[VCAP_AF_DEI_B_VAL]                      =  "DEI_B_VAL",
+	[VCAP_AF_DEI_C_VAL]                      =  "DEI_C_VAL",
 	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
 	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
 	[VCAP_AF_DP_ENA]                         =  "DP_ENA",
 	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
 	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
+	[VCAP_AF_DSCP_SEL]                       =  "DSCP_SEL",
 	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
 	[VCAP_AF_ES2_REW_CMD]                    =  "ES2_REW_CMD",
+	[VCAP_AF_ESDX]                           =  "ESDX",
 	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
 	[VCAP_AF_FWD_MODE]                       =  "FWD_MODE",
+	[VCAP_AF_FWD_SEL]                        =  "FWD_SEL",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
 	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
@@ -3387,6 +3719,7 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_ISDX_ADD_REPLACE_SEL]           =  "ISDX_ADD_REPLACE_SEL",
 	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
 	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
+	[VCAP_AF_LOOP_ENA]                       =  "LOOP_ENA",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
 	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
 	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
@@ -3401,20 +3734,45 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
 	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
 	[VCAP_AF_PAG_VAL]                        =  "PAG_VAL",
+	[VCAP_AF_PCP_A_VAL]                      =  "PCP_A_VAL",
+	[VCAP_AF_PCP_B_VAL]                      =  "PCP_B_VAL",
+	[VCAP_AF_PCP_C_VAL]                      =  "PCP_C_VAL",
 	[VCAP_AF_PCP_ENA]                        =  "PCP_ENA",
 	[VCAP_AF_PCP_VAL]                        =  "PCP_VAL",
+	[VCAP_AF_PIPELINE_ACT]                   =  "PIPELINE_ACT",
 	[VCAP_AF_PIPELINE_FORCE_ENA]             =  "PIPELINE_FORCE_ENA",
 	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
 	[VCAP_AF_POLICE_REMARK]                  =  "POLICE_REMARK",
 	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
+	[VCAP_AF_POP_VAL]                        =  "POP_VAL",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
+	[VCAP_AF_PUSH_CUSTOMER_TAG]              =  "PUSH_CUSTOMER_TAG",
+	[VCAP_AF_PUSH_INNER_TAG]                 =  "PUSH_INNER_TAG",
+	[VCAP_AF_PUSH_OUTER_TAG]                 =  "PUSH_OUTER_TAG",
 	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
 	[VCAP_AF_QOS_VAL]                        =  "QOS_VAL",
 	[VCAP_AF_REW_OP]                         =  "REW_OP",
 	[VCAP_AF_RT_DIS]                         =  "RT_DIS",
+	[VCAP_AF_SWAP_MACS_ENA]                  =  "SWAP_MACS_ENA",
+	[VCAP_AF_TAG_A_DEI_SEL]                  =  "TAG_A_DEI_SEL",
+	[VCAP_AF_TAG_A_PCP_SEL]                  =  "TAG_A_PCP_SEL",
+	[VCAP_AF_TAG_A_TPID_SEL]                 =  "TAG_A_TPID_SEL",
+	[VCAP_AF_TAG_A_VID_SEL]                  =  "TAG_A_VID_SEL",
+	[VCAP_AF_TAG_B_DEI_SEL]                  =  "TAG_B_DEI_SEL",
+	[VCAP_AF_TAG_B_PCP_SEL]                  =  "TAG_B_PCP_SEL",
+	[VCAP_AF_TAG_B_TPID_SEL]                 =  "TAG_B_TPID_SEL",
+	[VCAP_AF_TAG_B_VID_SEL]                  =  "TAG_B_VID_SEL",
+	[VCAP_AF_TAG_C_DEI_SEL]                  =  "TAG_C_DEI_SEL",
+	[VCAP_AF_TAG_C_PCP_SEL]                  =  "TAG_C_PCP_SEL",
+	[VCAP_AF_TAG_C_TPID_SEL]                 =  "TAG_C_TPID_SEL",
+	[VCAP_AF_TAG_C_VID_SEL]                  =  "TAG_C_VID_SEL",
 	[VCAP_AF_TYPE]                           =  "TYPE",
+	[VCAP_AF_UNTAG_VID_ENA]                  =  "UNTAG_VID_ENA",
+	[VCAP_AF_VID_A_VAL]                      =  "VID_A_VAL",
+	[VCAP_AF_VID_B_VAL]                      =  "VID_B_VAL",
+	[VCAP_AF_VID_C_VAL]                      =  "VID_C_VAL",
 	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
 };
 
@@ -3462,6 +3820,27 @@ const struct vcap_info sparx5_vcaps[] = {
 		.keyfield_set_typegroups = is2_keyfield_set_typegroups,
 		.actionfield_set_typegroups = is2_actionfield_set_typegroups,
 	},
+	[VCAP_TYPE_ES0] = {
+		.name = "es0",
+		.rows = 4096,
+		.sw_count = 1,
+		.sw_width = 52,
+		.sticky_width = 1,
+		.act_width = 489,
+		.default_cnt = 70,
+		.require_cnt_dis = 0,
+		.version = 1,
+		.keyfield_set = es0_keyfield_set,
+		.keyfield_set_size = ARRAY_SIZE(es0_keyfield_set),
+		.actionfield_set = es0_actionfield_set,
+		.actionfield_set_size = ARRAY_SIZE(es0_actionfield_set),
+		.keyfield_set_map = es0_keyfield_set_map,
+		.keyfield_set_map_size = es0_keyfield_set_map_size,
+		.actionfield_set_map = es0_actionfield_set_map,
+		.actionfield_set_map_size = es0_actionfield_set_map_size,
+		.keyfield_set_typegroups = es0_keyfield_set_typegroups,
+		.actionfield_set_typegroups = es0_actionfield_set_typegroups,
+	},
 	[VCAP_TYPE_ES2] = {
 		.name = "es2",
 		.rows = 1024,
@@ -3487,7 +3866,7 @@ const struct vcap_info sparx5_vcaps[] = {
 
 const struct vcap_statistics sparx5_vcap_stats = {
 	.name = "sparx5",
-	.count = 3,
+	.count = 4,
 	.keyfield_set_names = vcap_keyfield_set_names,
 	.actionfield_set_names = vcap_actionfield_set_names,
 	.keyfield_names = vcap_keyfield_names,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index 9c6766c4b75d..0844fcaeee68 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -3,14 +3,15 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2023-01-17 16:52:16 +0100.
- * Commit ID: 229ec79be5df142c1f335a01d0e63232d4feb2ba
+/* This file is autogenerated by cml-utils 2023-02-10 11:15:56 +0100.
+ * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
  */
 
 #ifndef __VCAP_AG_API__
 #define __VCAP_AG_API__
 
 enum vcap_type {
+	VCAP_TYPE_ES0,
 	VCAP_TYPE_ES2,
 	VCAP_TYPE_IS0,
 	VCAP_TYPE_IS2,
@@ -26,10 +27,11 @@ enum vcap_keyfield_set {
 	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_IP4_VID,           /* sparx5 es2 X3 */
 	VCAP_KFS_IP6_OTHER,         /* lan966x is2 X4 */
-	VCAP_KFS_IP6_STD,           /* sparx5 is2 X6, lan966x is2 X2 */
+	VCAP_KFS_IP6_STD,           /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_IP6_TCP_UDP,       /* lan966x is2 X4 */
 	VCAP_KFS_IP6_VID,           /* sparx5 es2 X6 */
 	VCAP_KFS_IP_7TUPLE,         /* sparx5 is2 X12, sparx5 es2 X12 */
+	VCAP_KFS_ISDX,              /* sparx5 es0 X1 */
 	VCAP_KFS_LL_FULL,           /* sparx5 is0 X6 */
 	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6, sparx5 es2 X6, lan966x is2 X2 */
 	VCAP_KFS_MAC_LLC,           /* lan966x is2 X2 */
@@ -75,6 +77,8 @@ enum vcap_keyfield_set {
  *   Third PCP in multiple vlan tags (not always available)
  * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2, lan966x: is2
  *   Classified PCP
+ * VCAP_KF_8021Q_TPID: W3, sparx5: es0
+ *   TPID for outer tag: 0: Customer TPID 1: Service TPID (88A8 or programmable)
  * VCAP_KF_8021Q_TPID0: W3, sparx5: is0
  *   First TPIC in multiple vlan tags (outer tag or default port tag)
  * VCAP_KF_8021Q_TPID1: W3, sparx5: is0
@@ -87,7 +91,8 @@ enum vcap_keyfield_set {
  *   Second VID in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_VID2: W12, sparx5: is0
  *   Third VID in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_VID_CLS: sparx5 is2 W13, sparx5 es2 W13, lan966x is2 W12
+ * VCAP_KF_8021Q_VID_CLS: sparx5 is2 W13, sparx5 es0 W13, sparx5 es2 W13,
+ *   lan966x is2 W12
  *   Classified VID
  * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
@@ -111,7 +116,7 @@ enum vcap_keyfield_set {
  *   Sender Hardware Address = SMAC (ARP)
  * VCAP_KF_ARP_TGT_MATCH_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Target Hardware Address = SMAC (RARP)
- * VCAP_KF_COSID_CLS: W3, sparx5: es2
+ * VCAP_KF_COSID_CLS: W3, sparx5: es0/es2
  *   Class of service
  * VCAP_KF_ES0_ISDX_KEY_ENA: W1, sparx5: es2
  *   The value taken from the IFH .FWD.ES0_ISDX_KEY_ENA
@@ -127,6 +132,8 @@ enum vcap_keyfield_set {
  * VCAP_KF_IF_EGR_PORT_MASK_RNG: W3, sparx5: es2
  *   Select which 32 port group is available in IF_EGR_PORT (or virtual ports or
  *   CPU queue)
+ * VCAP_KF_IF_EGR_PORT_NO: W7, sparx5: es0
+ *   Egress port number
  * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9, lan966x is2 W4
  *   Sparx5: Logical ingress port number retrieved from
  *   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
@@ -154,9 +161,9 @@ enum vcap_keyfield_set {
  *   Payload bytes after IP header
  * VCAP_KF_IP_SNAP_IS: W1, sparx5: is0
  *   Set if frame is IPv4, IPv6, or SNAP frame
- * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es2
+ * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es0/es2
  *   Classified ISDX
- * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es2, lan966x: is2
+ * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es0/es2, lan966x: is2
  *   Set if classified ISDX > 0
  * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame's destination MAC address is the broadcast address
@@ -187,7 +194,7 @@ enum vcap_keyfield_set {
  *   SNAP header after LLC header (AA-AA-03)
  * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if Src IP matches Dst IP address
- * VCAP_KF_L3_DPL_CLS: W1, sparx5: es2
+ * VCAP_KF_L3_DPL_CLS: W1, sparx5: es0/es2
  *   The frames drop precedence level
  * VCAP_KF_L3_DSCP: W6, sparx5: is0
  *   Frame's DSCP value
@@ -216,8 +223,8 @@ enum vcap_keyfield_set {
  *   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
  * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if IPv4 frame contains options (IP len > 5)
- * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96, lan966x
- *   is2 W56
+ * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96, sparx5
+ *   es2 W40, lan966x is2 W56
  *   Sparx5: Payload bytes after IP header. IPv4: IPv4 options are not parsed so
  *   payload is always taken 20 bytes after the start of the IPv4 header, LAN966x:
  *   Bytes 0-6 after IP header
@@ -294,7 +301,7 @@ enum vcap_keyfield_set {
  *   Frame's OAM version
  * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if frame's EtherType = 0x8902
- * VCAP_KF_PROT_ACTIVE: W1, sparx5: es2
+ * VCAP_KF_PROT_ACTIVE: W1, sparx5: es0/es2
  *   Protection is active
  * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
@@ -303,7 +310,7 @@ enum vcap_keyfield_set {
  *   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
  *   or 17)
  * VCAP_KF_TYPE: sparx5 is0 W2, sparx5 is0 W1, sparx5 is2 W4, sparx5 is2 W2,
- *   sparx5 es2 W3, lan966x is2 W4, lan966x is2 W2
+ *   sparx5 es0 W1, sparx5 es2 W3, lan966x is2 W4, lan966x is2 W2
  *   Keyset type id - set by the API
  */
 
@@ -324,6 +331,7 @@ enum vcap_key_field {
 	VCAP_KF_8021Q_PCP1,
 	VCAP_KF_8021Q_PCP2,
 	VCAP_KF_8021Q_PCP_CLS,
+	VCAP_KF_8021Q_TPID,
 	VCAP_KF_8021Q_TPID0,
 	VCAP_KF_8021Q_TPID1,
 	VCAP_KF_8021Q_TPID2,
@@ -348,6 +356,7 @@ enum vcap_key_field {
 	VCAP_KF_HOST_MATCH,
 	VCAP_KF_IF_EGR_PORT_MASK,
 	VCAP_KF_IF_EGR_PORT_MASK_RNG,
+	VCAP_KF_IF_EGR_PORT_NO,
 	VCAP_KF_IF_IGR_PORT,
 	VCAP_KF_IF_IGR_PORT_MASK,
 	VCAP_KF_IF_IGR_PORT_MASK_L3,
@@ -429,6 +438,7 @@ enum vcap_actionfield_set {
 	VCAP_AFS_BASE_TYPE,         /* sparx5 is2 X3, sparx5 es2 X3, lan966x is2 X2 */
 	VCAP_AFS_CLASSIFICATION,    /* sparx5 is0 X2 */
 	VCAP_AFS_CLASS_REDUCED,     /* sparx5 is0 X1 */
+	VCAP_AFS_ES0,               /* sparx5 es0 X1 */
 	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
 	VCAP_AFS_SMAC_SIP,          /* lan966x is2 X1 */
 };
@@ -456,8 +466,16 @@ enum vcap_actionfield_set {
  * VCAP_AF_CPU_COPY_ENA: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes all frames that hit this action to be copied to
  *   the CPU extraction queue specified in CPU_QUEUE_NUM.
+ * VCAP_AF_CPU_QU: W3, sparx5: es0
+ *   CPU extraction queue. Used when FWD_SEL >0 and PIPELINE_ACT = XTR.
  * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2/es2, lan966x: is2
  *   CPU queue number. Used when CPU_COPY_ENA is set.
+ * VCAP_AF_DEI_A_VAL: W1, sparx5: es0
+ *   DEI used in ES0 tag A. See TAG_A_DEI_SEL.
+ * VCAP_AF_DEI_B_VAL: W1, sparx5: es0
+ *   DEI used in ES0 tag B. See TAG_B_DEI_SEL.
+ * VCAP_AF_DEI_C_VAL: W1, sparx5: es0
+ *   DEI used in ES0 tag C. See TAG_C_DEI_SEL.
  * VCAP_AF_DEI_ENA: W1, sparx5: is0
  *   If set, use DEI_VAL as classified DEI value. Otherwise, DEI from basic
  *   classification is used
@@ -471,16 +489,28 @@ enum vcap_actionfield_set {
  * VCAP_AF_DSCP_ENA: W1, sparx5: is0
  *   If set, use DSCP_VAL as classified DSCP value. Otherwise, DSCP value from
  *   basic classification is used.
- * VCAP_AF_DSCP_VAL: W6, sparx5: is0
+ * VCAP_AF_DSCP_SEL: W3, sparx5: es0
+ *   Selects source for DSCP. 0: Controlled by port configuration and IFH. 1:
+ *   Classified DSCP via IFH. 2: DSCP_VAL. 3: Reserved. 4: Mapped using mapping
+ *   table 0, otherwise use DSCP_VAL. 5: Mapped using mapping table 1, otherwise
+ *   use mapping table 0. 6: Mapped using mapping table 2, otherwise use DSCP_VAL.
+ *   7: Mapped using mapping table 3, otherwise use mapping table 2
+ * VCAP_AF_DSCP_VAL: W6, sparx5: is0/es0
  *   See DSCP_ENA.
  * VCAP_AF_ES2_REW_CMD: W3, sparx5: es2
  *   Command forwarded to REW: 0: No action. 1: SWAP MAC addresses. 2: Do L2CP
  *   DMAC translation when entering or leaving a tunnel.
+ * VCAP_AF_ESDX: W13, sparx5: es0
+ *   Egress counter index. Used to index egress counter set as defined in
+ *   REW::STAT_CFG.
  * VCAP_AF_FWD_KILL_ENA: W1, lan966x: is2
  *   Setting this bit to 1 denies forwarding of the frame forwarding to any front
  *   port. The frame can still be copied to the CPU by other actions.
  * VCAP_AF_FWD_MODE: W2, sparx5: es2
  *   Forward selector: 0: Forward. 1: Discard. 2: Redirect. 3: Copy.
+ * VCAP_AF_FWD_SEL: W2, sparx5: es0
+ *   ES0 Forward selector. 0: No action. 1: Copy to loopback interface. 2:
+ *   Redirect to loopback interface. 3: Discard
  * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes the first frame that hits this action where the
  *   HIT_CNT counter is zero to be copied to the CPU extraction queue specified in
@@ -504,6 +534,8 @@ enum vcap_actionfield_set {
  *   POLICE_IDX[8:0].
  * VCAP_AF_ISDX_VAL: W12, sparx5: is0
  *   See isdx_add_replace_sel
+ * VCAP_AF_LOOP_ENA: W1, sparx5: es0
+ *   0: Forward based on PIPELINE_PT and FWD_SEL
  * VCAP_AF_LRN_DIS: W1, sparx5: is2, lan966x: is2
  *   Setting this bit to 1 disables learning of frames hitting this action.
  * VCAP_AF_MAP_IDX: W9, sparx5: is0
@@ -549,15 +581,24 @@ enum vcap_actionfield_set {
  *   (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
  * VCAP_AF_PAG_VAL: W8, sparx5: is0
  *   See PAG_OVERRIDE_MASK.
+ * VCAP_AF_PCP_A_VAL: W3, sparx5: es0
+ *   PCP used in ES0 tag A. See TAG_A_PCP_SEL.
+ * VCAP_AF_PCP_B_VAL: W3, sparx5: es0
+ *   PCP used in ES0 tag B. See TAG_B_PCP_SEL.
+ * VCAP_AF_PCP_C_VAL: W3, sparx5: es0
+ *   PCP used in ES0 tag C. See TAG_C_PCP_SEL.
  * VCAP_AF_PCP_ENA: W1, sparx5: is0
  *   If set, use PCP_VAL as classified PCP value. Otherwise, PCP from basic
  *   classification is used.
  * VCAP_AF_PCP_VAL: W3, sparx5: is0
  *   See PCP_ENA.
+ * VCAP_AF_PIPELINE_ACT: W1, sparx5: es0
+ *   Pipeline action when FWD_SEL > 0. 0: XTR. CPU_QU selects CPU extraction queue
+ *   1: LBK_ASM.
  * VCAP_AF_PIPELINE_FORCE_ENA: W1, sparx5: is2
  *   If set, use PIPELINE_PT unconditionally and set PIPELINE_ACT = NONE if
  *   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
- * VCAP_AF_PIPELINE_PT: W5, sparx5: is2
+ * VCAP_AF_PIPELINE_PT: sparx5 is2 W5, sparx5 es0 W2
  *   Pipeline point used if PIPELINE_FORCE_ENA is set
  * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes frames that hit this action to be policed by the
@@ -570,8 +611,23 @@ enum vcap_actionfield_set {
  * VCAP_AF_POLICE_VCAP_ONLY: W1, lan966x: is2
  *   Disable policing from QoS, and port policers. Only the VCAP policer selected
  *   by POLICE_IDX is active. Only applies to the second lookup.
+ * VCAP_AF_POP_VAL: W2, sparx5: es0
+ *   Controls popping of Q-tags. The final number of Q-tags popped is calculated
+ *   as shown in section 4.28.7.2 VLAN Pop Decision.
  * VCAP_AF_PORT_MASK: sparx5 is0 W65, sparx5 is2 W68, lan966x is2 W8
  *   Port mask applied to the forwarding decision based on MASK_MODE.
+ * VCAP_AF_PUSH_CUSTOMER_TAG: W2, sparx5: es0
+ *   Selects tag C mode: 0: Do not push tag C. 1: Push tag C if
+ *   IFH.VSTAX.TAG.WAS_TAGGED = 1. 2: Push tag C if IFH.VSTAX.TAG.WAS_TAGGED = 0.
+ *   3: Push tag C if UNTAG_VID_ENA = 0 or (C-TAG.VID ! = VID_C_VAL).
+ * VCAP_AF_PUSH_INNER_TAG: W1, sparx5: es0
+ *   Controls inner tagging. 0: Do not push ES0 tag B as inner tag. 1: Push ES0
+ *   tag B as inner tag.
+ * VCAP_AF_PUSH_OUTER_TAG: W2, sparx5: es0
+ *   Controls outer tagging. 0: No ES0 tag A: Port tag is allowed if enabled on
+ *   port. 1: ES0 tag A: Push ES0 tag A. No port tag. 2: Force port tag: Always
+ *   push port tag. No ES0 tag A. 3: Force untag: Never push port tag or ES0 tag
+ *   A.
  * VCAP_AF_QOS_ENA: W1, sparx5: is0
  *   If set, use QOS_VAL as classified QoS class. Otherwise, QoS class from basic
  *   classification is used.
@@ -582,8 +638,65 @@ enum vcap_actionfield_set {
  * VCAP_AF_RT_DIS: W1, sparx5: is2
  *   If set, routing is disallowed. Only applies when IS_INNER_ACL is 0. See also
  *   IGR_ACL_ENA, EGR_ACL_ENA, and RLEG_STAT_IDX.
+ * VCAP_AF_SWAP_MACS_ENA: W1, sparx5: es0
+ *   This setting is only active when FWD_SEL = 1 or FWD_SEL = 2 and PIPELINE_ACT
+ *   = LBK_ASM. 0: No action. 1: Swap MACs and clear bit 40 in new SMAC.
+ * VCAP_AF_TAG_A_DEI_SEL: W3, sparx5: es0
+ *   Selects PCP for ES0 tag A. 0: Classified DEI. 1: DEI_A_VAL. 2: DP and QoS
+ *   mapped to PCP (per port table). 3: DP.
+ * VCAP_AF_TAG_A_PCP_SEL: W3, sparx5: es0
+ *   Selects PCP for ES0 tag A. 0: Classified PCP. 1: PCP_A_VAL. 2: DP and QoS
+ *   mapped to PCP (per port table). 3: QoS class.
+ * VCAP_AF_TAG_A_TPID_SEL: W3, sparx5: es0
+ *   Selects TPID for ES0 tag A: 0: 0x8100. 1: 0x88A8. 2: Custom
+ *   (REW:PORT:PORT_VLAN_CFG.PORT_TPID). 3: If IFH.TAG_TYPE = 0 then 0x8100 else
+ *   custom.
+ * VCAP_AF_TAG_A_VID_SEL: W2, sparx5: es0
+ *   Selects VID for ES0 tag A. 0: Classified VID + VID_A_VAL. 1: VID_A_VAL.
+ * VCAP_AF_TAG_B_DEI_SEL: W3, sparx5: es0
+ *   Selects PCP for ES0 tag B. 0: Classified DEI. 1: DEI_B_VAL. 2: DP and QoS
+ *   mapped to PCP (per port table). 3: DP.
+ * VCAP_AF_TAG_B_PCP_SEL: W3, sparx5: es0
+ *   Selects PCP for ES0 tag B. 0: Classified PCP. 1: PCP_B_VAL. 2: DP and QoS
+ *   mapped to PCP (per port table). 3: QoS class.
+ * VCAP_AF_TAG_B_TPID_SEL: W3, sparx5: es0
+ *   Selects TPID for ES0 tag B. 0: 0x8100. 1: 0x88A8. 2: Custom
+ *   (REW:PORT:PORT_VLAN_CFG.PORT_TPID). 3: If IFH.TAG_TYPE = 0 then 0x8100 else
+ *   custom.
+ * VCAP_AF_TAG_B_VID_SEL: W2, sparx5: es0
+ *   Selects VID for ES0 tag B. 0: Classified VID + VID_B_VAL. 1: VID_B_VAL.
+ * VCAP_AF_TAG_C_DEI_SEL: W3, sparx5: es0
+ *   Selects DEI source for ES0 tag C. 0: Classified DEI. 1: DEI_C_VAL. 2:
+ *   REW::DP_MAP.DP [IFH.VSTAX.QOS.DP]. 3: DEI of popped VLAN tag if available
+ *   (IFH.VSTAX.TAG.WAS_TAGGED = 1 and tot_pop_cnt>0) else DEI_C_VAL. 4: Mapped
+ *   using mapping table 0, otherwise use DEI_C_VAL. 5: Mapped using mapping table
+ *   1, otherwise use mapping table 0. 6: Mapped using mapping table 2, otherwise
+ *   use DEI_C_VAL. 7: Mapped using mapping table 3, otherwise use mapping table
+ *   2.
+ * VCAP_AF_TAG_C_PCP_SEL: W3, sparx5: es0
+ *   Selects PCP source for ES0 tag C. 0: Classified PCP. 1: PCP_C_VAL. 2:
+ *   Reserved. 3: PCP of popped VLAN tag if available (IFH.VSTAX.TAG.WAS_TAGGED=1
+ *   and tot_pop_cnt>0) else PCP_C_VAL. 4: Mapped using mapping table 0, otherwise
+ *   use PCP_C_VAL. 5: Mapped using mapping table 1, otherwise use mapping table
+ *   0. 6: Mapped using mapping table 2, otherwise use PCP_C_VAL. 7: Mapped using
+ *   mapping table 3, otherwise use mapping table 2.
+ * VCAP_AF_TAG_C_TPID_SEL: W3, sparx5: es0
+ *   Selects TPID for ES0 tag C. 0: 0x8100. 1: 0x88A8. 2: Custom 1. 3: Custom 2.
+ *   4: Custom 3. 5: See TAG_A_TPID_SEL.
+ * VCAP_AF_TAG_C_VID_SEL: W2, sparx5: es0
+ *   Selects VID for ES0 tag C. The resulting VID is termed C-TAG.VID. 0:
+ *   Classified VID. 1: VID_C_VAL. 2: IFH.ENCAP.GVID. 3: Reserved.
  * VCAP_AF_TYPE: W1, sparx5: is0
  *   Actionset type id - Set by the API
+ * VCAP_AF_UNTAG_VID_ENA: W1, sparx5: es0
+ *   Controls insertion of tag C. Untag or insert mode can be selected. See
+ *   PUSH_CUSTOMER_TAG.
+ * VCAP_AF_VID_A_VAL: W12, sparx5: es0
+ *   VID used in ES0 tag A. See TAG_A_VID_SEL.
+ * VCAP_AF_VID_B_VAL: W12, sparx5: es0
+ *   VID used in ES0 tag B. See TAG_B_VID_SEL.
+ * VCAP_AF_VID_C_VAL: W12, sparx5: es0
+ *   VID used in ES0 tag C. See TAG_C_VID_SEL.
  * VCAP_AF_VID_VAL: W13, sparx5: is0
  *   New VID Value
  */
@@ -597,16 +710,23 @@ enum vcap_action_field {
 	VCAP_AF_COPY_PORT_NUM,
 	VCAP_AF_COPY_QUEUE_NUM,
 	VCAP_AF_CPU_COPY_ENA,
+	VCAP_AF_CPU_QU,
 	VCAP_AF_CPU_QUEUE_NUM,
+	VCAP_AF_DEI_A_VAL,
+	VCAP_AF_DEI_B_VAL,
+	VCAP_AF_DEI_C_VAL,
 	VCAP_AF_DEI_ENA,
 	VCAP_AF_DEI_VAL,
 	VCAP_AF_DP_ENA,
 	VCAP_AF_DP_VAL,
 	VCAP_AF_DSCP_ENA,
+	VCAP_AF_DSCP_SEL,
 	VCAP_AF_DSCP_VAL,
 	VCAP_AF_ES2_REW_CMD,
+	VCAP_AF_ESDX,
 	VCAP_AF_FWD_KILL_ENA,
 	VCAP_AF_FWD_MODE,
+	VCAP_AF_FWD_SEL,
 	VCAP_AF_HIT_ME_ONCE,
 	VCAP_AF_HOST_MATCH,
 	VCAP_AF_IGNORE_PIPELINE_CTRL,
@@ -614,6 +734,7 @@ enum vcap_action_field {
 	VCAP_AF_ISDX_ADD_REPLACE_SEL,
 	VCAP_AF_ISDX_ENA,
 	VCAP_AF_ISDX_VAL,
+	VCAP_AF_LOOP_ENA,
 	VCAP_AF_LRN_DIS,
 	VCAP_AF_MAP_IDX,
 	VCAP_AF_MAP_KEY,
@@ -628,20 +749,45 @@ enum vcap_action_field {
 	VCAP_AF_NXT_IDX_CTRL,
 	VCAP_AF_PAG_OVERRIDE_MASK,
 	VCAP_AF_PAG_VAL,
+	VCAP_AF_PCP_A_VAL,
+	VCAP_AF_PCP_B_VAL,
+	VCAP_AF_PCP_C_VAL,
 	VCAP_AF_PCP_ENA,
 	VCAP_AF_PCP_VAL,
+	VCAP_AF_PIPELINE_ACT,
 	VCAP_AF_PIPELINE_FORCE_ENA,
 	VCAP_AF_PIPELINE_PT,
 	VCAP_AF_POLICE_ENA,
 	VCAP_AF_POLICE_IDX,
 	VCAP_AF_POLICE_REMARK,
 	VCAP_AF_POLICE_VCAP_ONLY,
+	VCAP_AF_POP_VAL,
 	VCAP_AF_PORT_MASK,
+	VCAP_AF_PUSH_CUSTOMER_TAG,
+	VCAP_AF_PUSH_INNER_TAG,
+	VCAP_AF_PUSH_OUTER_TAG,
 	VCAP_AF_QOS_ENA,
 	VCAP_AF_QOS_VAL,
 	VCAP_AF_REW_OP,
 	VCAP_AF_RT_DIS,
+	VCAP_AF_SWAP_MACS_ENA,
+	VCAP_AF_TAG_A_DEI_SEL,
+	VCAP_AF_TAG_A_PCP_SEL,
+	VCAP_AF_TAG_A_TPID_SEL,
+	VCAP_AF_TAG_A_VID_SEL,
+	VCAP_AF_TAG_B_DEI_SEL,
+	VCAP_AF_TAG_B_PCP_SEL,
+	VCAP_AF_TAG_B_TPID_SEL,
+	VCAP_AF_TAG_B_VID_SEL,
+	VCAP_AF_TAG_C_DEI_SEL,
+	VCAP_AF_TAG_C_PCP_SEL,
+	VCAP_AF_TAG_C_TPID_SEL,
+	VCAP_AF_TAG_C_VID_SEL,
 	VCAP_AF_TYPE,
+	VCAP_AF_UNTAG_VID_ENA,
+	VCAP_AF_VID_A_VAL,
+	VCAP_AF_VID_B_VAL,
+	VCAP_AF_VID_C_VAL,
 	VCAP_AF_VID_VAL,
 };
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index b9c1c9d5eee8..0de3f677135a 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -387,7 +387,7 @@ static const char * const test_admin_info_expect[] = {
 	"default_cnt: 73\n",
 	"require_cnt_dis: 0\n",
 	"version: 1\n",
-	"vtype: 2\n",
+	"vtype: 3\n",
 	"vinst: 0\n",
 	"ingress: 1\n",
 	"first_cid: 10000\n",
@@ -435,7 +435,7 @@ static const char * const test_admin_expect[] = {
 	"default_cnt: 73\n",
 	"require_cnt_dis: 0\n",
 	"version: 1\n",
-	"vtype: 2\n",
+	"vtype: 3\n",
 	"vinst: 0\n",
 	"ingress: 1\n",
 	"first_cid: 8000000\n",
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
index 6d5d73d00562..5dbfc0d0c369 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
@@ -1,6 +1,10 @@
 // SPDX-License-Identifier: BSD-3-Clause
-/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
- * Microchip VCAP API Test VCAP Model Data
+/* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP test model interface for kunit testing
+ */
+
+/* This file is autogenerated by cml-utils 2023-02-10 11:16:00 +0100.
+ * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
  */
 
 #include <linux/types.h>
@@ -1619,16 +1623,6 @@ static const struct vcap_field es2_mac_etype_keyfield[] = {
 		.offset = 3,
 		.width = 1,
 	},
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
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 13,
@@ -1704,16 +1698,6 @@ static const struct vcap_field es2_mac_etype_keyfield[] = {
 		.offset = 95,
 		.width = 1,
 	},
-	[VCAP_KF_ES0_ISDX_KEY_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 96,
-		.width = 1,
-	},
-	[VCAP_KF_MIRROR_PROBE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 97,
-		.width = 2,
-	},
 	[VCAP_KF_L2_DMAC] = {
 		.type = VCAP_FIELD_U48,
 		.offset = 99,
@@ -1762,16 +1746,6 @@ static const struct vcap_field es2_arp_keyfield[] = {
 		.offset = 3,
 		.width = 1,
 	},
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
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 13,
@@ -1842,16 +1816,6 @@ static const struct vcap_field es2_arp_keyfield[] = {
 		.offset = 94,
 		.width = 1,
 	},
-	[VCAP_KF_ES0_ISDX_KEY_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 95,
-		.width = 1,
-	},
-	[VCAP_KF_MIRROR_PROBE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 96,
-		.width = 2,
-	},
 	[VCAP_KF_L2_SMAC] = {
 		.type = VCAP_FIELD_U48,
 		.offset = 98,
@@ -1920,16 +1884,6 @@ static const struct vcap_field es2_ip4_tcp_udp_keyfield[] = {
 		.offset = 3,
 		.width = 1,
 	},
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
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 13,
@@ -2005,16 +1959,6 @@ static const struct vcap_field es2_ip4_tcp_udp_keyfield[] = {
 		.offset = 95,
 		.width = 1,
 	},
-	[VCAP_KF_ES0_ISDX_KEY_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 96,
-		.width = 1,
-	},
-	[VCAP_KF_MIRROR_PROBE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 97,
-		.width = 2,
-	},
 	[VCAP_KF_IP4_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 99,
@@ -2133,16 +2077,6 @@ static const struct vcap_field es2_ip4_other_keyfield[] = {
 		.offset = 3,
 		.width = 1,
 	},
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
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 13,
@@ -2218,16 +2152,6 @@ static const struct vcap_field es2_ip4_other_keyfield[] = {
 		.offset = 95,
 		.width = 1,
 	},
-	[VCAP_KF_ES0_ISDX_KEY_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 96,
-		.width = 1,
-	},
-	[VCAP_KF_MIRROR_PROBE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 97,
-		.width = 2,
-	},
 	[VCAP_KF_IP4_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 99,
@@ -2286,16 +2210,6 @@ static const struct vcap_field es2_ip_7tuple_keyfield[] = {
 		.offset = 0,
 		.width = 1,
 	},
-	[VCAP_KF_ACL_GRP_ID] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 1,
-		.width = 8,
-	},
-	[VCAP_KF_PROT_ACTIVE] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 9,
-		.width = 1,
-	},
 	[VCAP_KF_L2_MC_IS] = {
 		.type = VCAP_FIELD_BIT,
 		.offset = 10,
@@ -2371,16 +2285,6 @@ static const struct vcap_field es2_ip_7tuple_keyfield[] = {
 		.offset = 92,
 		.width = 1,
 	},
-	[VCAP_KF_ES0_ISDX_KEY_ENA] = {
-		.type = VCAP_FIELD_BIT,
-		.offset = 93,
-		.width = 1,
-	},
-	[VCAP_KF_MIRROR_PROBE] = {
-		.type = VCAP_FIELD_U32,
-		.offset = 94,
-		.width = 2,
-	},
 	[VCAP_KF_L2_DMAC] = {
 		.type = VCAP_FIELD_U48,
 		.offset = 96,
@@ -2493,6 +2397,124 @@ static const struct vcap_field es2_ip_7tuple_keyfield[] = {
 	},
 };
 
+static const struct vcap_field es2_ip6_std_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
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
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 99,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 100,
+		.width = 128,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 228,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 229,
+		.width = 8,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 237,
+		.width = 16,
+	},
+	[VCAP_KF_L3_PAYLOAD] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 253,
+		.width = 40,
+	},
+};
+
 static const struct vcap_field es2_ip4_vid_keyfield[] = {
 	[VCAP_KF_LOOKUP_FIRST_IS] = {
 		.type = VCAP_FIELD_BIT,
@@ -2752,6 +2774,11 @@ static const struct vcap_set es2_keyfield_set[] = {
 		.sw_per_item = 12,
 		.sw_cnt = 1,
 	},
+	[VCAP_KFS_IP6_STD] = {
+		.type_id = 4,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
 	[VCAP_KFS_IP4_VID] = {
 		.type_id = -1,
 		.sw_per_item = 3,
@@ -2788,6 +2815,7 @@ static const struct vcap_field *es2_keyfield_set_map[] = {
 	[VCAP_KFS_IP4_TCP_UDP] = es2_ip4_tcp_udp_keyfield,
 	[VCAP_KFS_IP4_OTHER] = es2_ip4_other_keyfield,
 	[VCAP_KFS_IP_7TUPLE] = es2_ip_7tuple_keyfield,
+	[VCAP_KFS_IP6_STD] = es2_ip6_std_keyfield,
 	[VCAP_KFS_IP4_VID] = es2_ip4_vid_keyfield,
 	[VCAP_KFS_IP6_VID] = es2_ip6_vid_keyfield,
 };
@@ -2816,6 +2844,7 @@ static int es2_keyfield_set_map_size[] = {
 	[VCAP_KFS_IP4_TCP_UDP] = ARRAY_SIZE(es2_ip4_tcp_udp_keyfield),
 	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(es2_ip4_other_keyfield),
 	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(es2_ip_7tuple_keyfield),
+	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(es2_ip6_std_keyfield),
 	[VCAP_KFS_IP4_VID] = ARRAY_SIZE(es2_ip4_vid_keyfield),
 	[VCAP_KFS_IP6_VID] = ARRAY_SIZE(es2_ip6_vid_keyfield),
 };
@@ -3724,6 +3753,7 @@ static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_IP6_TCP_UDP]                   =  "VCAP_KFS_IP6_TCP_UDP",
 	[VCAP_KFS_IP6_VID]                       =  "VCAP_KFS_IP6_VID",
 	[VCAP_KFS_IP_7TUPLE]                     =  "VCAP_KFS_IP_7TUPLE",
+	[VCAP_KFS_ISDX]                          =  "VCAP_KFS_ISDX",
 	[VCAP_KFS_LL_FULL]                       =  "VCAP_KFS_LL_FULL",
 	[VCAP_KFS_MAC_ETYPE]                     =  "VCAP_KFS_MAC_ETYPE",
 	[VCAP_KFS_MAC_LLC]                       =  "VCAP_KFS_MAC_LLC",
@@ -3742,6 +3772,7 @@ static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
 	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
 	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
+	[VCAP_AFS_ES0]                           =  "VCAP_AFS_ES0",
 	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
 	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
 };
@@ -3763,6 +3794,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_8021Q_PCP1]                     =  "8021Q_PCP1",
 	[VCAP_KF_8021Q_PCP2]                     =  "8021Q_PCP2",
 	[VCAP_KF_8021Q_PCP_CLS]                  =  "8021Q_PCP_CLS",
+	[VCAP_KF_8021Q_TPID]                     =  "8021Q_TPID",
 	[VCAP_KF_8021Q_TPID0]                    =  "8021Q_TPID0",
 	[VCAP_KF_8021Q_TPID1]                    =  "8021Q_TPID1",
 	[VCAP_KF_8021Q_TPID2]                    =  "8021Q_TPID2",
@@ -3787,6 +3819,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
 	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
+	[VCAP_KF_IF_EGR_PORT_NO]                 =  "IF_EGR_PORT_NO",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
 	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
@@ -3871,16 +3904,23 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
 	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
+	[VCAP_AF_CPU_QU]                         =  "CPU_QU",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
+	[VCAP_AF_DEI_A_VAL]                      =  "DEI_A_VAL",
+	[VCAP_AF_DEI_B_VAL]                      =  "DEI_B_VAL",
+	[VCAP_AF_DEI_C_VAL]                      =  "DEI_C_VAL",
 	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
 	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
 	[VCAP_AF_DP_ENA]                         =  "DP_ENA",
 	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
 	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
+	[VCAP_AF_DSCP_SEL]                       =  "DSCP_SEL",
 	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
 	[VCAP_AF_ES2_REW_CMD]                    =  "ES2_REW_CMD",
+	[VCAP_AF_ESDX]                           =  "ESDX",
 	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
 	[VCAP_AF_FWD_MODE]                       =  "FWD_MODE",
+	[VCAP_AF_FWD_SEL]                        =  "FWD_SEL",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
 	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
@@ -3888,6 +3928,7 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_ISDX_ADD_REPLACE_SEL]           =  "ISDX_ADD_REPLACE_SEL",
 	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
 	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
+	[VCAP_AF_LOOP_ENA]                       =  "LOOP_ENA",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
 	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
 	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
@@ -3902,20 +3943,45 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
 	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
 	[VCAP_AF_PAG_VAL]                        =  "PAG_VAL",
+	[VCAP_AF_PCP_A_VAL]                      =  "PCP_A_VAL",
+	[VCAP_AF_PCP_B_VAL]                      =  "PCP_B_VAL",
+	[VCAP_AF_PCP_C_VAL]                      =  "PCP_C_VAL",
 	[VCAP_AF_PCP_ENA]                        =  "PCP_ENA",
 	[VCAP_AF_PCP_VAL]                        =  "PCP_VAL",
+	[VCAP_AF_PIPELINE_ACT]                   =  "PIPELINE_ACT",
 	[VCAP_AF_PIPELINE_FORCE_ENA]             =  "PIPELINE_FORCE_ENA",
 	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
 	[VCAP_AF_POLICE_REMARK]                  =  "POLICE_REMARK",
 	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
+	[VCAP_AF_POP_VAL]                        =  "POP_VAL",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
+	[VCAP_AF_PUSH_CUSTOMER_TAG]              =  "PUSH_CUSTOMER_TAG",
+	[VCAP_AF_PUSH_INNER_TAG]                 =  "PUSH_INNER_TAG",
+	[VCAP_AF_PUSH_OUTER_TAG]                 =  "PUSH_OUTER_TAG",
 	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
 	[VCAP_AF_QOS_VAL]                        =  "QOS_VAL",
 	[VCAP_AF_REW_OP]                         =  "REW_OP",
 	[VCAP_AF_RT_DIS]                         =  "RT_DIS",
+	[VCAP_AF_SWAP_MACS_ENA]                  =  "SWAP_MACS_ENA",
+	[VCAP_AF_TAG_A_DEI_SEL]                  =  "TAG_A_DEI_SEL",
+	[VCAP_AF_TAG_A_PCP_SEL]                  =  "TAG_A_PCP_SEL",
+	[VCAP_AF_TAG_A_TPID_SEL]                 =  "TAG_A_TPID_SEL",
+	[VCAP_AF_TAG_A_VID_SEL]                  =  "TAG_A_VID_SEL",
+	[VCAP_AF_TAG_B_DEI_SEL]                  =  "TAG_B_DEI_SEL",
+	[VCAP_AF_TAG_B_PCP_SEL]                  =  "TAG_B_PCP_SEL",
+	[VCAP_AF_TAG_B_TPID_SEL]                 =  "TAG_B_TPID_SEL",
+	[VCAP_AF_TAG_B_VID_SEL]                  =  "TAG_B_VID_SEL",
+	[VCAP_AF_TAG_C_DEI_SEL]                  =  "TAG_C_DEI_SEL",
+	[VCAP_AF_TAG_C_PCP_SEL]                  =  "TAG_C_PCP_SEL",
+	[VCAP_AF_TAG_C_TPID_SEL]                 =  "TAG_C_TPID_SEL",
+	[VCAP_AF_TAG_C_VID_SEL]                  =  "TAG_C_VID_SEL",
 	[VCAP_AF_TYPE]                           =  "TYPE",
+	[VCAP_AF_UNTAG_VID_ENA]                  =  "UNTAG_VID_ENA",
+	[VCAP_AF_VID_A_VAL]                      =  "VID_A_VAL",
+	[VCAP_AF_VID_B_VAL]                      =  "VID_B_VAL",
+	[VCAP_AF_VID_C_VAL]                      =  "VID_C_VAL",
 	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
 };
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h
index b5a74f0eef9b..55762f24e196 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h
@@ -1,10 +1,18 @@
 /* SPDX-License-Identifier: BSD-3-Clause */
-/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+/* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
  * Microchip VCAP test model interface for kunit testing
  */
 
+/* This file is autogenerated by cml-utils 2023-02-10 11:16:00 +0100.
+ * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
+ */
+
 #ifndef __VCAP_MODEL_KUNIT_H__
 #define __VCAP_MODEL_KUNIT_H__
+
+/* VCAPs */
 extern const struct vcap_info kunit_test_vcaps[];
 extern const struct vcap_statistics kunit_test_vcap_stats;
+
 #endif /* __VCAP_MODEL_KUNIT_H__ */
+
-- 
2.39.1

