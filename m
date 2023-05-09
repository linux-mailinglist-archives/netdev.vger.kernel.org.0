Return-Path: <netdev+bounces-1055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BE46FC06A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D625C281163
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB94011187;
	Tue,  9 May 2023 07:27:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9458AD31
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:27:01 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAA49E6;
	Tue,  9 May 2023 00:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683617218; x=1715153218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRUkUYnc+8xTekZnYPspesKZs9NIUTdTYiUhc1lgC3g=;
  b=UCYpUfyB+r6wI1bZtAt19OJkEHwcMIJikGj9ErLaNj6gJBef/WdlqZN3
   vPvvlsVD1Y6v6CBHrXEPjikTttgbHEMwGmkRA7Vg9lyUAPxKo9XnFqgdi
   YWl94/NKMyjeEEsLiivlUPYlnTAKtuNZNP73oO5cwPbEJu4PMb1eGsqj+
   5sTGwC/mb8dRaYgSAdEhwUrTNAItQtLcDrtkcCD1o2bnhDGlSpRYnnQoz
   eVQy9O+je5YOKSCwacMm8bDebqt7E4MINp6GAlEJ0ZGtynilIXs9V7C3x
   R6BNl0D+w1bU0NhDEVr7ITguf9xaxAzCGkzp1zsPVb2F8PRM2gRlK75of
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,261,1677567600"; 
   d="scan'208";a="212523839"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 00:26:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 00:26:56 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 9 May 2023 00:26:54 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lars.povlsen@microchip.com>,
	<Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
	<UNGLinuxDriver@microchip.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/3] net: lan966x: Add ES0 VCAP model
Date: Tue, 9 May 2023 09:26:43 +0200
Message-ID: <20230509072645.3245949-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
References: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide ES0 (egress stage 0) VCAP model for lan966x.
This provides rewriting functionality in the gress path.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 264 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  67 +++--
 2 files changed, 301 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
index 66400a082d029..fb6851b94528c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
@@ -2121,6 +2121,69 @@ static const struct vcap_field is2_smac_sip6_keyfield[] = {
 	},
 };
 
+static const struct vcap_field es0_vid_keyfield[] = {
+	[VCAP_KF_IF_EGR_PORT_NO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 4,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 4,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 8,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 9,
+		.width = 8,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 17,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 18,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 19,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 31,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 32,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 35,
+		.width = 1,
+	},
+	[VCAP_KF_RTP_ID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 36,
+		.width = 10,
+	},
+	[VCAP_KF_PDU_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 46,
+		.width = 4,
+	},
+};
+
 /* keyfield_set */
 static const struct vcap_set is1_keyfield_set[] = {
 	[VCAP_KFS_NORMAL] = {
@@ -2228,6 +2291,14 @@ static const struct vcap_set is2_keyfield_set[] = {
 	},
 };
 
+static const struct vcap_set es0_keyfield_set[] = {
+	[VCAP_KFS_VID] = {
+		.type_id = -1,
+		.sw_per_item = 1,
+		.sw_cnt = 1,
+	},
+};
+
 /* keyfield_set map */
 static const struct vcap_field *is1_keyfield_set_map[] = {
 	[VCAP_KFS_NORMAL] = is1_normal_keyfield,
@@ -2255,6 +2326,10 @@ static const struct vcap_field *is2_keyfield_set_map[] = {
 	[VCAP_KFS_SMAC_SIP6] = is2_smac_sip6_keyfield,
 };
 
+static const struct vcap_field *es0_keyfield_set_map[] = {
+	[VCAP_KFS_VID] = es0_vid_keyfield,
+};
+
 /* keyfield_set map sizes */
 static int is1_keyfield_set_map_size[] = {
 	[VCAP_KFS_NORMAL] = ARRAY_SIZE(is1_normal_keyfield),
@@ -2282,6 +2357,10 @@ static int is2_keyfield_set_map_size[] = {
 	[VCAP_KFS_SMAC_SIP6] = ARRAY_SIZE(is2_smac_sip6_keyfield),
 };
 
+static int es0_keyfield_set_map_size[] = {
+	[VCAP_KFS_VID] = ARRAY_SIZE(es0_vid_keyfield),
+};
+
 /* actionfields */
 static const struct vcap_field is1_s1_actionfield[] = {
 	[VCAP_AF_TYPE] = {
@@ -2522,6 +2601,94 @@ static const struct vcap_field is2_smac_sip_actionfield[] = {
 	},
 };
 
+static const struct vcap_field es0_vid_actionfield[] = {
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
+		.width = 2,
+	},
+	[VCAP_AF_TAG_A_VID_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 5,
+		.width = 1,
+	},
+	[VCAP_AF_TAG_A_PCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 6,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_A_DEI_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 8,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_B_TPID_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 10,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_B_VID_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_AF_TAG_B_PCP_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 2,
+	},
+	[VCAP_AF_TAG_B_DEI_SEL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 15,
+		.width = 2,
+	},
+	[VCAP_AF_VID_A_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 17,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_A_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_A_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 32,
+		.width = 1,
+	},
+	[VCAP_AF_VID_B_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 33,
+		.width = 12,
+	},
+	[VCAP_AF_PCP_B_VAL] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 3,
+	},
+	[VCAP_AF_DEI_B_VAL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 48,
+		.width = 1,
+	},
+	[VCAP_AF_ESDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 49,
+		.width = 8,
+	},
+};
+
 /* actionfield_set */
 static const struct vcap_set is1_actionfield_set[] = {
 	[VCAP_AFS_S1] = {
@@ -2544,6 +2711,14 @@ static const struct vcap_set is2_actionfield_set[] = {
 	},
 };
 
+static const struct vcap_set es0_actionfield_set[] = {
+	[VCAP_AFS_VID] = {
+		.type_id = -1,
+		.sw_per_item = 1,
+		.sw_cnt = 1,
+	},
+};
+
 /* actionfield_set map */
 static const struct vcap_field *is1_actionfield_set_map[] = {
 	[VCAP_AFS_S1] = is1_s1_actionfield,
@@ -2554,6 +2729,10 @@ static const struct vcap_field *is2_actionfield_set_map[] = {
 	[VCAP_AFS_SMAC_SIP] = is2_smac_sip_actionfield,
 };
 
+static const struct vcap_field *es0_actionfield_set_map[] = {
+	[VCAP_AFS_VID] = es0_vid_actionfield,
+};
+
 /* actionfield_set map size */
 static int is1_actionfield_set_map_size[] = {
 	[VCAP_AFS_S1] = ARRAY_SIZE(is1_s1_actionfield),
@@ -2564,6 +2743,10 @@ static int is2_actionfield_set_map_size[] = {
 	[VCAP_AFS_SMAC_SIP] = ARRAY_SIZE(is2_smac_sip_actionfield),
 };
 
+static int es0_actionfield_set_map_size[] = {
+	[VCAP_AFS_VID] = ARRAY_SIZE(es0_vid_actionfield),
+};
+
 /* Type Groups */
 static const struct vcap_typegroup is1_x4_keyfield_set_typegroups[] = {
 	{
@@ -2659,6 +2842,10 @@ static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es0_x1_keyfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup *is1_keyfield_set_typegroups[] = {
 	[4] = is1_x4_keyfield_set_typegroups,
 	[2] = is1_x2_keyfield_set_typegroups,
@@ -2673,6 +2860,11 @@ static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[5] = NULL,
 };
 
+static const struct vcap_typegroup *es0_keyfield_set_typegroups[] = {
+	[1] = es0_x1_keyfield_set_typegroups,
+	[2] = NULL,
+};
+
 static const struct vcap_typegroup is1_x1_actionfield_set_typegroups[] = {
 	{}
 };
@@ -2700,6 +2892,10 @@ static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es0_x1_actionfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup *is1_actionfield_set_typegroups[] = {
 	[1] = is1_x1_actionfield_set_typegroups,
 	[5] = NULL,
@@ -2711,6 +2907,11 @@ static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 	[5] = NULL,
 };
 
+static const struct vcap_typegroup *es0_actionfield_set_typegroups[] = {
+	[1] = es0_x1_actionfield_set_typegroups,
+	[2] = NULL,
+};
+
 /* Keyfieldset names */
 static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_NO_VALUE]                      =  "(None)",
@@ -2743,6 +2944,7 @@ static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_RT]                            =  "VCAP_KFS_RT",
 	[VCAP_KFS_SMAC_SIP4]                     =  "VCAP_KFS_SMAC_SIP4",
 	[VCAP_KFS_SMAC_SIP6]                     =  "VCAP_KFS_SMAC_SIP6",
+	[VCAP_KFS_VID]                           =  "VCAP_KFS_VID",
 };
 
 /* Actionfieldset names */
@@ -2751,9 +2953,11 @@ static const char * const vcap_actionfield_set_names[] = {
 	[VCAP_AFS_BASE_TYPE]                     =  "VCAP_AFS_BASE_TYPE",
 	[VCAP_AFS_CLASSIFICATION]                =  "VCAP_AFS_CLASSIFICATION",
 	[VCAP_AFS_CLASS_REDUCED]                 =  "VCAP_AFS_CLASS_REDUCED",
+	[VCAP_AFS_ES0]                           =  "VCAP_AFS_ES0",
 	[VCAP_AFS_FULL]                          =  "VCAP_AFS_FULL",
 	[VCAP_AFS_S1]                            =  "VCAP_AFS_S1",
 	[VCAP_AFS_SMAC_SIP]                      =  "VCAP_AFS_SMAC_SIP",
+	[VCAP_AFS_VID]                           =  "VCAP_AFS_VID",
 };
 
 /* Keyfield names */
@@ -2774,6 +2978,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_8021Q_PCP1]                     =  "8021Q_PCP1",
 	[VCAP_KF_8021Q_PCP2]                     =  "8021Q_PCP2",
 	[VCAP_KF_8021Q_PCP_CLS]                  =  "8021Q_PCP_CLS",
+	[VCAP_KF_8021Q_TPID]                     =  "8021Q_TPID",
 	[VCAP_KF_8021Q_TPID0]                    =  "8021Q_TPID0",
 	[VCAP_KF_8021Q_TPID1]                    =  "8021Q_TPID1",
 	[VCAP_KF_8021Q_TPID2]                    =  "8021Q_TPID2",
@@ -2799,6 +3004,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
 	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
+	[VCAP_KF_IF_EGR_PORT_NO]                 =  "IF_EGR_PORT_NO",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
 	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
@@ -2873,7 +3079,9 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_OAM_OPCODE]                     =  "OAM_OPCODE",
 	[VCAP_KF_OAM_VER]                        =  "OAM_VER",
 	[VCAP_KF_OAM_Y1731_IS]                   =  "OAM_Y1731_IS",
+	[VCAP_KF_PDU_TYPE]                       =  "PDU_TYPE",
 	[VCAP_KF_PROT_ACTIVE]                    =  "PROT_ACTIVE",
+	[VCAP_KF_RTP_ID]                         =  "RTP_ID",
 	[VCAP_KF_RT_FRMID]                       =  "RT_FRMID",
 	[VCAP_KF_RT_TYPE]                        =  "RT_TYPE",
 	[VCAP_KF_RT_VLAN_IDX]                    =  "RT_VLAN_IDX",
@@ -2891,18 +3099,25 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
 	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
+	[VCAP_AF_CPU_QU]                         =  "CPU_QU",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
 	[VCAP_AF_CUSTOM_ACE_TYPE_ENA]            =  "CUSTOM_ACE_TYPE_ENA",
+	[VCAP_AF_DEI_A_VAL]                      =  "DEI_A_VAL",
+	[VCAP_AF_DEI_B_VAL]                      =  "DEI_B_VAL",
+	[VCAP_AF_DEI_C_VAL]                      =  "DEI_C_VAL",
 	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
 	[VCAP_AF_DEI_VAL]                        =  "DEI_VAL",
 	[VCAP_AF_DLR_SEL]                        =  "DLR_SEL",
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
@@ -2912,6 +3127,7 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_ISDX_ENA]                       =  "ISDX_ENA",
 	[VCAP_AF_ISDX_REPLACE_ENA]               =  "ISDX_REPLACE_ENA",
 	[VCAP_AF_ISDX_VAL]                       =  "ISDX_VAL",
+	[VCAP_AF_LOOP_ENA]                       =  "LOOP_ENA",
 	[VCAP_AF_LRN_DIS]                        =  "LRN_DIS",
 	[VCAP_AF_MAP_IDX]                        =  "MAP_IDX",
 	[VCAP_AF_MAP_KEY]                        =  "MAP_KEY",
@@ -2928,15 +3144,23 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_OAM_SEL]                        =  "OAM_SEL",
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
@@ -2945,7 +3169,24 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_SFID_VAL]                       =  "SFID_VAL",
 	[VCAP_AF_SGID_ENA]                       =  "SGID_ENA",
 	[VCAP_AF_SGID_VAL]                       =  "SGID_VAL",
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
 	[VCAP_AF_VID_REPLACE_ENA]                =  "VID_REPLACE_ENA",
 	[VCAP_AF_VID_VAL]                        =  "VID_VAL",
 	[VCAP_AF_VLAN_POP_CNT]                   =  "VLAN_POP_CNT",
@@ -2996,11 +3237,32 @@ const struct vcap_info lan966x_vcaps[] = {
 		.keyfield_set_typegroups = is2_keyfield_set_typegroups,
 		.actionfield_set_typegroups = is2_actionfield_set_typegroups,
 	},
+	[VCAP_TYPE_ES0] = {
+		.name = "es0",
+		.rows = 256,
+		.sw_count = 1,
+		.sw_width = 96,
+		.sticky_width = 1,
+		.act_width = 65,
+		.default_cnt = 8,
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
 };
 
 const struct vcap_statistics lan966x_vcap_stats = {
 	.name = "lan966x",
-	.count = 2,
+	.count = 3,
 	.keyfield_set_names = vcap_keyfield_set_names,
 	.actionfield_set_names = vcap_actionfield_set_names,
 	.keyfield_names = vcap_keyfield_names,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index a556c4419986e..c3569a4c7b695 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -3,8 +3,8 @@
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2023-02-16 11:41:14 +0100.
- * Commit ID: be85f176b3a151fa748dcaf97c8824a5c2e065f3
+/* This file is autogenerated by cml-utils 2023-03-13 10:16:42 +0100.
+ * Commit ID: 259f0efd6d6d91bfbf62858de153cc757b6bffa3 (dirty)
  */
 
 #ifndef __VCAP_AG_API__
@@ -51,6 +51,7 @@ enum vcap_keyfield_set {
 	VCAP_KFS_RT,                /* lan966x is1 X1 */
 	VCAP_KFS_SMAC_SIP4,         /* lan966x is2 X1 */
 	VCAP_KFS_SMAC_SIP6,         /* lan966x is2 X2 */
+	VCAP_KFS_VID,               /* lan966x es0 X1 */
 };
 
 /* List of keyfields with description
@@ -79,7 +80,7 @@ enum vcap_keyfield_set {
  *   Second DEI in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_DEI2: W1, sparx5: is0
  *   Third DEI in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2, lan966x: is2
+ * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2, lan966x: is2/es0
  *   Classified DEI
  * VCAP_KF_8021Q_PCP0: W3, sparx5: is0, lan966x: is1
  *   First PCP in multiple vlan tags (outer tag or default port tag)
@@ -87,7 +88,7 @@ enum vcap_keyfield_set {
  *   Second PCP in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_PCP2: W3, sparx5: is0
  *   Third PCP in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2, lan966x: is2
+ * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2, lan966x: is2/es0
  *   Classified PCP
  * VCAP_KF_8021Q_TPID: W3, sparx5: es0
  *   TPID for outer tag: 0: Customer TPID 1: Service TPID (88A8 or programmable)
@@ -104,7 +105,7 @@ enum vcap_keyfield_set {
  * VCAP_KF_8021Q_VID2: W12, sparx5: is0
  *   Third VID in multiple vlan tags (not always available)
  * VCAP_KF_8021Q_VID_CLS: sparx5 is2 W13, sparx5 es0 W13, sparx5 es2 W13,
- *   lan966x is2 W12
+ *   lan966x is2 W12, lan966x es0 W12
  *   Classified VID
  * VCAP_KF_8021Q_VLAN_DBL_TAGGED_IS: W1, lan966x: is1
  *   Set if frame has two or more Q-tags. Independent of port VLAN awareness
@@ -146,10 +147,10 @@ enum vcap_keyfield_set {
  * VCAP_KF_IF_EGR_PORT_MASK_RNG: W3, sparx5: es2
  *   Select which 32 port group is available in IF_EGR_PORT (or virtual ports or
  *   CPU queue)
- * VCAP_KF_IF_EGR_PORT_NO: W7, sparx5: es0
+ * VCAP_KF_IF_EGR_PORT_NO: sparx5 es0 W7, lan966x es0 W4
  *   Egress port number
  * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9, lan966x is1 W3, lan966x
- *   is2 W4
+ *   is2 W4, lan966x es0 W4
  *   Sparx5: Logical ingress port number retrieved from
  *   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
  * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65,
@@ -178,11 +179,12 @@ enum vcap_keyfield_set {
  *   Payload after IPv6 header
  * VCAP_KF_IP_SNAP_IS: W1, sparx5: is0, lan966x: is1
  *   Set if frame is IPv4, IPv6, or SNAP frame
- * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es0/es2
+ * VCAP_KF_ISDX_CLS: sparx5 is2 W12, sparx5 es0 W12, sparx5 es2 W12, lan966x es0
+ *   W8
  *   Classified ISDX
- * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es0/es2, lan966x: is2
+ * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es0/es2, lan966x: is2/es0
  *   Set if classified ISDX > 0
- * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
+ * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2/es0
  *   Set if frame's destination MAC address is the broadcast address
  *   (FF-FF-FF-FF-FF-FF).
  * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2, lan966x: is1/is2
@@ -195,7 +197,7 @@ enum vcap_keyfield_set {
  *   LLC header and data after up to two VLAN tags and the type/length field
  * VCAP_KF_L2_MAC: W48, lan966x: is1
  *   MAC address (FIRST=1: SMAC, FIRST=0: DMAC)
- * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan966x: is1/is2/es0
  *   Set if frame's destination MAC address is a multicast address (bit 40 = 1).
  * VCAP_KF_L2_PAYLOAD0: W16, lan966x: is2
  *   Payload bytes 0-1 after the frame's EtherType
@@ -213,7 +215,7 @@ enum vcap_keyfield_set {
  *   SNAP header after LLC header (AA-AA-03)
  * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if Src IP matches Dst IP address
- * VCAP_KF_L3_DPL_CLS: W1, sparx5: es0/es2
+ * VCAP_KF_L3_DPL_CLS: W1, sparx5: es0/es2, lan966x: es0
  *   The frames drop precedence level
  * VCAP_KF_L3_DSCP: W6, sparx5: is0, lan966x: is1
  *   Frame's DSCP value
@@ -330,8 +332,12 @@ enum vcap_keyfield_set {
  *   Frame's OAM version
  * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if frame's EtherType = 0x8902
+ * VCAP_KF_PDU_TYPE: W4, lan966x: es0
+ *   PDU type value (none, OAM CCM, MRP, DLR, RTE, IPv4, IPv6, OAM non-CCM)
  * VCAP_KF_PROT_ACTIVE: W1, sparx5: es0/es2
  *   Protection is active
+ * VCAP_KF_RTP_ID: W10, lan966x: es0
+ *   Classified RTP_ID
  * VCAP_KF_RT_FRMID: W32, lan966x: is1
  *   Profinet or OPC-UA FrameId
  * VCAP_KF_RT_TYPE: W2, lan966x: is1
@@ -470,7 +476,9 @@ enum vcap_key_field {
 	VCAP_KF_OAM_OPCODE,
 	VCAP_KF_OAM_VER,
 	VCAP_KF_OAM_Y1731_IS,
+	VCAP_KF_PDU_TYPE,
 	VCAP_KF_PROT_ACTIVE,
+	VCAP_KF_RTP_ID,
 	VCAP_KF_RT_FRMID,
 	VCAP_KF_RT_TYPE,
 	VCAP_KF_RT_VLAN_IDX,
@@ -489,6 +497,7 @@ enum vcap_actionfield_set {
 	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
 	VCAP_AFS_S1,                /* lan966x is1 X1 */
 	VCAP_AFS_SMAC_SIP,          /* lan966x is2 X1 */
+	VCAP_AFS_VID,               /* lan966x es0 X1 */
 };
 
 /* List of actionfields with description
@@ -523,9 +532,9 @@ enum vcap_actionfield_set {
  *   while bits 1:0 control first lookup. Encoding per lookup: 0: Disabled.  1:
  *   Extract 40 bytes after position corresponding to the location of the IPv4
  *   header and use as key.  2: Extract 40 bytes after SMAC and use as key
- * VCAP_AF_DEI_A_VAL: W1, sparx5: es0
+ * VCAP_AF_DEI_A_VAL: W1, sparx5: es0, lan966x: es0
  *   DEI used in ES0 tag A. See TAG_A_DEI_SEL.
- * VCAP_AF_DEI_B_VAL: W1, sparx5: es0
+ * VCAP_AF_DEI_B_VAL: W1, sparx5: es0, lan966x: es0
  *   DEI used in ES0 tag B. See TAG_B_DEI_SEL.
  * VCAP_AF_DEI_C_VAL: W1, sparx5: es0
  *   DEI used in ES0 tag C. See TAG_C_DEI_SEL.
@@ -556,7 +565,7 @@ enum vcap_actionfield_set {
  * VCAP_AF_ES2_REW_CMD: W3, sparx5: es2
  *   Command forwarded to REW: 0: No action. 1: SWAP MAC addresses. 2: Do L2CP
  *   DMAC translation when entering or leaving a tunnel.
- * VCAP_AF_ESDX: W13, sparx5: es0
+ * VCAP_AF_ESDX: sparx5 es0 W13, lan966x es0 W8
  *   Egress counter index. Used to index egress counter set as defined in
  *   REW::STAT_CFG.
  * VCAP_AF_FWD_KILL_ENA: W1, lan966x: is2
@@ -652,9 +661,9 @@ enum vcap_actionfield_set {
  *   (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
  * VCAP_AF_PAG_VAL: W8, sparx5: is0, lan966x: is1
  *   See PAG_OVERRIDE_MASK.
- * VCAP_AF_PCP_A_VAL: W3, sparx5: es0
+ * VCAP_AF_PCP_A_VAL: W3, sparx5: es0, lan966x: es0
  *   PCP used in ES0 tag A. See TAG_A_PCP_SEL.
- * VCAP_AF_PCP_B_VAL: W3, sparx5: es0
+ * VCAP_AF_PCP_B_VAL: W3, sparx5: es0, lan966x: es0
  *   PCP used in ES0 tag B. See TAG_B_PCP_SEL.
  * VCAP_AF_PCP_C_VAL: W3, sparx5: es0
  *   PCP used in ES0 tag C. See TAG_C_PCP_SEL.
@@ -691,10 +700,10 @@ enum vcap_actionfield_set {
  *   Selects tag C mode: 0: Do not push tag C. 1: Push tag C if
  *   IFH.VSTAX.TAG.WAS_TAGGED = 1. 2: Push tag C if IFH.VSTAX.TAG.WAS_TAGGED = 0.
  *   3: Push tag C if UNTAG_VID_ENA = 0 or (C-TAG.VID ! = VID_C_VAL).
- * VCAP_AF_PUSH_INNER_TAG: W1, sparx5: es0
+ * VCAP_AF_PUSH_INNER_TAG: W1, sparx5: es0, lan966x: es0
  *   Controls inner tagging. 0: Do not push ES0 tag B as inner tag. 1: Push ES0
  *   tag B as inner tag.
- * VCAP_AF_PUSH_OUTER_TAG: W2, sparx5: es0
+ * VCAP_AF_PUSH_OUTER_TAG: W2, sparx5: es0, lan966x: es0
  *   Controls outer tagging. 0: No ES0 tag A: Port tag is allowed if enabled on
  *   port. 1: ES0 tag A: Push ES0 tag A. No port tag. 2: Force port tag: Always
  *   push port tag. No ES0 tag A. 3: Force untag: Never push port tag or ES0 tag
@@ -720,29 +729,29 @@ enum vcap_actionfield_set {
  * VCAP_AF_SWAP_MACS_ENA: W1, sparx5: es0
  *   This setting is only active when FWD_SEL = 1 or FWD_SEL = 2 and PIPELINE_ACT
  *   = LBK_ASM. 0: No action. 1: Swap MACs and clear bit 40 in new SMAC.
- * VCAP_AF_TAG_A_DEI_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_A_DEI_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects PCP for ES0 tag A. 0: Classified DEI. 1: DEI_A_VAL. 2: DP and QoS
  *   mapped to PCP (per port table). 3: DP.
- * VCAP_AF_TAG_A_PCP_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_A_PCP_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects PCP for ES0 tag A. 0: Classified PCP. 1: PCP_A_VAL. 2: DP and QoS
  *   mapped to PCP (per port table). 3: QoS class.
- * VCAP_AF_TAG_A_TPID_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_A_TPID_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects TPID for ES0 tag A: 0: 0x8100. 1: 0x88A8. 2: Custom
  *   (REW:PORT:PORT_VLAN_CFG.PORT_TPID). 3: If IFH.TAG_TYPE = 0 then 0x8100 else
  *   custom.
- * VCAP_AF_TAG_A_VID_SEL: W2, sparx5: es0
+ * VCAP_AF_TAG_A_VID_SEL: sparx5 es0 W2, lan966x es0 W1
  *   Selects VID for ES0 tag A. 0: Classified VID + VID_A_VAL. 1: VID_A_VAL.
- * VCAP_AF_TAG_B_DEI_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_B_DEI_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects PCP for ES0 tag B. 0: Classified DEI. 1: DEI_B_VAL. 2: DP and QoS
  *   mapped to PCP (per port table). 3: DP.
- * VCAP_AF_TAG_B_PCP_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_B_PCP_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects PCP for ES0 tag B. 0: Classified PCP. 1: PCP_B_VAL. 2: DP and QoS
  *   mapped to PCP (per port table). 3: QoS class.
- * VCAP_AF_TAG_B_TPID_SEL: W3, sparx5: es0
+ * VCAP_AF_TAG_B_TPID_SEL: sparx5 es0 W3, lan966x es0 W2
  *   Selects TPID for ES0 tag B. 0: 0x8100. 1: 0x88A8. 2: Custom
  *   (REW:PORT:PORT_VLAN_CFG.PORT_TPID). 3: If IFH.TAG_TYPE = 0 then 0x8100 else
  *   custom.
- * VCAP_AF_TAG_B_VID_SEL: W2, sparx5: es0
+ * VCAP_AF_TAG_B_VID_SEL: sparx5 es0 W2, lan966x es0 W1
  *   Selects VID for ES0 tag B. 0: Classified VID + VID_B_VAL. 1: VID_B_VAL.
  * VCAP_AF_TAG_C_DEI_SEL: W3, sparx5: es0
  *   Selects DEI source for ES0 tag C. 0: Classified DEI. 1: DEI_C_VAL. 2:
@@ -770,9 +779,9 @@ enum vcap_actionfield_set {
  * VCAP_AF_UNTAG_VID_ENA: W1, sparx5: es0
  *   Controls insertion of tag C. Untag or insert mode can be selected. See
  *   PUSH_CUSTOMER_TAG.
- * VCAP_AF_VID_A_VAL: W12, sparx5: es0
+ * VCAP_AF_VID_A_VAL: W12, sparx5: es0, lan966x: es0
  *   VID used in ES0 tag A. See TAG_A_VID_SEL.
- * VCAP_AF_VID_B_VAL: W12, sparx5: es0
+ * VCAP_AF_VID_B_VAL: W12, sparx5: es0, lan966x: es0
  *   VID used in ES0 tag B. See TAG_B_VID_SEL.
  * VCAP_AF_VID_C_VAL: W12, sparx5: es0
  *   VID used in ES0 tag C. See TAG_C_VID_SEL.
-- 
2.38.0


