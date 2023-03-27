Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793466CA18B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbjC0KhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjC0KhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:37:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2702729
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:37:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP0fsWjCRvGTX8c60eiycs28tyJiyQX2MDXXePNlVjIH5uwS+4K3IP0JsTeNCEv2qnKXnSEMLwNojb7oF4R7Ggd9AFVafH9socO0Buk8gT8gjG3uWX3MJRIkntxERU6JwtvkFBLdfg1flm40Y9qPsTqIfIdGefpkV4oisxmQ089VvUHK4acegP2ZzUhc8nZLO6dARqvZVlDmNoLBLHuJnPCRhCF/ha1gKvOshc8USPvyDpI0r4B9yjZMHgexc1JkdpN1br7I7og+iz+9kgX5avjay8tKOfd2IHYxxlTvUMYQqZcpsmmvMcawK0bS7O07q8OrJKhrj9URo8Z7014gvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOn4fmGkxww3cglBmP7oBE86qadTC8AULmcpsFOm9X0=;
 b=gXfVyKkKVcjqmw5etW98iuH5kmINpMoealMWVdJe0waUxh+YYE+fgSooFdVaPSwA/VuUdv9LGlIDCEw5fUmsuCFI9oCVuLuEOKatnnzNf389tQICR6s+/7NiJ2sHGLTlx10GU1g8/QVWY3gxmRJcyfICynTfKOEpPNrYHm2wKjrMrL5H+OWEEUiEmfEMnfgwK9+fuy104GZiuxHzcleNVRv7WJWCssoz9BCJeB/41IAcZpurUQUXytai+c39BdGnXBtsXyKzXyS47cT7RnEm5BhHCq1RHA0wnflkEFWK9W1i1iT5bNr1BBfsG8lceijMds2/hoFClSIr0X+z58TxSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOn4fmGkxww3cglBmP7oBE86qadTC8AULmcpsFOm9X0=;
 b=KRequ3UKKwCArk13WOvlnD4xSJa6VpKYOimRMk7T5mUH7kOTV3iRsBVxKboUHQieZww97HX6o5HBbde7TIqnAx2w5h3qoRa1KGOxe/egdGZqdTjmiM7vXKhJjAefjL0mDkjVRZbZuxtewe4BvX5G4djmSjDxj0VohSy2R/9rnhA=
Received: from BN9PR03CA0572.namprd03.prod.outlook.com (2603:10b6:408:10d::7)
 by DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 10:37:15 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::76) by BN9PR03CA0572.outlook.office365.com
 (2603:10b6:408:10d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 10:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 10:37:14 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:12 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:37:10 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 2/6] sfc: add notion of match on enc keys to MAE machinery
Date:   Mon, 27 Mar 2023 11:36:04 +0100
Message-ID: <6753bf9b0c144635dd5ed7ff3f26270d60ec8d73.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf7f398-8b79-4b5f-8b63-08db2eaf3b29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Givc2WkgkztBX/8IZGRJaHHHnwZS1DDzoFFhjDOP/Q3ZD/CiD3SXq4FdGzxZvxoVFU0GTBzlNKwygEwvRTlet3tfJ94XHkTpDJD0TrXEzjCcUEWuQe53Bk8rwpbivW8Wg81CN+ADI8O6dZbdZNSraa3lY2fIkoH6JiPsaMUsDhOV0Uj9imuKQQicgsRQq0WXLfA3ZQYRdHJ2H6bYW6Hy3ATEStya/hVF1IHfI3rZeVKFw6lksCo31FYiInjioB5D/ewocd1FADBIlHWo87cO8QOcTQdQIh0QnabKkK2j92ZtFSY03GeBJvBouHig5om/3962xAJxPQ+KpA2xM9WC7fXmELVu2xLHcf1aJ+MN+VR4GCjCdofYE/nMGcyR2LC+26OT0siXbxQH2kkvebqHDjtYxjojUNDWGVMklZR+5KOPp6F7ExjJRAhTGslVC8tf1E/sSF5O6dCN/5V7iZ+xhc2pxndPTd2FHKWN+ypgqhch56S4pMCFyPxQGzLSdP5Q7BzlHMYOQB/bbwteIK8dtM2is66SM4TI0lw1TEe1BowQ9q4i6H8sXbb068sCZ/O50Loq+eFf+y25f0x13BCQjEKfCNfIU2npNApCVKAa8+AHqYbvjPmiNVAZP04/Rwa14XWq75SvOPVQ+yt7CIVv0pJfHT5rpeFVjsAG4sgrjfLKQU010BaqiDVKh2cguh5wF7qLWcIeUyxptjRZshjy3FhVBRYiHZEjIIcmHhuyT30=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(336012)(186003)(9686003)(4326008)(40480700001)(41300700001)(47076005)(6666004)(83380400001)(26005)(426003)(82740400003)(478600001)(316002)(110136005)(54906003)(36860700001)(40460700003)(2906002)(2876002)(8676002)(356005)(70206006)(70586007)(82310400005)(86362001)(55446002)(36756003)(81166007)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:37:14.9321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf7f398-8b79-4b5f-8b63-08db2eaf3b29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Extend the MAE caps check to validate that the hardware supports these
 outer-header matches where used by the driver.
Extend efx_mae_populate_match_criteria() to fill in the outer rule ID
 and VNI match fields.
Nothing yet populates these match fields, nor creates outer rules.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v3: adjusted description to clarify caps check
Changed in v2: efx_mae_check_encap_match_caps now takes a `bool ipv6` rather
 than an `unsigned char ipv`, simplifying the code.
---
 drivers/net/ethernet/sfc/mae.c | 97 +++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  3 ++
 drivers/net/ethernet/sfc/tc.h  | 24 +++++++++
 3 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index c53d354c1fb2..2290a63908c5 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -254,13 +254,23 @@ static int efx_mae_get_rule_fields(struct efx_nic *efx, u32 cmd,
 	size_t outlen;
 	int rc, i;
 
+	/* AR and OR caps MCDIs have identical layout, so we are using the
+	 * same code for both.
+	 */
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_LEN(MAE_NUM_FIELDS) <
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_LEN(MAE_NUM_FIELDS));
 	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_IN_LEN);
+	BUILD_BUG_ON(MC_CMD_MAE_GET_OR_CAPS_IN_LEN);
 
 	rc = efx_mcdi_rpc(efx, cmd, NULL, 0, outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_COUNT_OFST !=
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_COUNT_OFST);
 	count = MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_COUNT);
 	memset(field_support, MAE_FIELD_UNSUPPORTED, MAE_NUM_FIELDS);
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_FIELD_FLAGS_OFST !=
+		     MC_CMD_MAE_GET_OR_CAPS_OUT_FIELD_FLAGS_OFST);
 	caps = _MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_FIELD_FLAGS);
 	/* We're only interested in the support status enum, not any other
 	 * flags, so just extract that from each entry.
@@ -278,8 +288,12 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps)
 	rc = efx_mae_get_basic_caps(efx, caps);
 	if (rc)
 		return rc;
-	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
-				       caps->action_rule_fields);
+	rc = efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
+				     caps->action_rule_fields);
+	if (rc)
+		return rc;
+	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_OR_CAPS,
+				       caps->outer_rule_fields);
 }
 
 /* Bit twiddling:
@@ -432,11 +446,67 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	    CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag) ||
 	    CHECK(RECIRC_ID, recirc_id))
 		return rc;
+	/* Matches on outer fields are done in a separate hardware table,
+	 * the Outer Rule table.  Thus the Action Rule merely does an
+	 * exact match on Outer Rule ID if any outer field matches are
+	 * present.  The exception is the VNI/VSID (enc_keyid), which is
+	 * available to the Action Rule match iff the Outer Rule matched
+	 * (and thus identified the encap protocol to use to extract it).
+	 */
+	if (efx_tc_match_is_encap(mask)) {
+		rc = efx_mae_match_check_cap_typ(
+				supported_fields[MAE_FIELD_OUTER_RULE_ID],
+				MASK_ONES);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "No support for encap rule ID matches");
+			return rc;
+		}
+		if (CHECK(ENC_VNET_ID, enc_keyid))
+			return rc;
+	} else if (mask->enc_keyid) {
+		NL_SET_ERR_MSG_MOD(extack, "Match on enc_keyid requires other encap fields");
+		return -EINVAL;
+	}
 	return 0;
 }
 #undef CHECK_BIT
 #undef CHECK
 
+#define CHECK(_mcdi)	({						       \
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
+					 MASK_ONES);			       \
+	if (rc)								       \
+		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
+				       "No support for field %s", #_mcdi);     \
+	rc;								       \
+})
+/* Checks that the fields needed for encap-rule matches are supported by the
+ * MAE.  All the fields are exact-match.
+ */
+int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
+				   struct netlink_ext_ack *extack)
+{
+	u8 *supported_fields = efx->tc->caps->outer_rule_fields;
+	int rc;
+
+	if (CHECK(ENC_ETHER_TYPE))
+		return rc;
+	if (ipv6) {
+		if (CHECK(ENC_SRC_IP6) ||
+		    CHECK(ENC_DST_IP6))
+			return rc;
+	} else {
+		if (CHECK(ENC_SRC_IP4) ||
+		    CHECK(ENC_DST_IP4))
+			return rc;
+	}
+	if (CHECK(ENC_L4_DPORT) ||
+	    CHECK(ENC_IP_PROTO))
+		return rc;
+	return 0;
+}
+#undef CHECK
+
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
@@ -941,6 +1011,29 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 				match->value.tcp_flags);
 	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
 				match->mask.tcp_flags);
+	/* enc-keys are handled indirectly, through encap_match ID */
+	if (match->encap) {
+		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
+				      match->encap->fw_id);
+		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
+				      U32_MAX);
+		/* enc_keyid (VNI/VSID) is not part of the encap_match */
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
+					 match->value.enc_keyid);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
+					 match->mask.enc_keyid);
+	} else if (WARN_ON_ONCE(match->mask.enc_src_ip) ||
+		   WARN_ON_ONCE(match->mask.enc_dst_ip) ||
+		   WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_src_ip6)) ||
+		   WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_dst_ip6)) ||
+		   WARN_ON_ONCE(match->mask.enc_ip_tos) ||
+		   WARN_ON_ONCE(match->mask.enc_ip_ttl) ||
+		   WARN_ON_ONCE(match->mask.enc_sport) ||
+		   WARN_ON_ONCE(match->mask.enc_dport) ||
+		   WARN_ON_ONCE(match->mask.enc_keyid)) {
+		/* No enc-keys should appear in a rule without an encap_match */
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index bec293a06733..2ccbc62d79b9 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -72,6 +72,7 @@ struct mae_caps {
 	u32 match_field_count;
 	u32 action_prios;
 	u8 action_rule_fields[MAE_NUM_FIELDS];
+	u8 outer_rule_fields[MAE_NUM_FIELDS];
 };
 
 int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
@@ -79,6 +80,8 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
+int efx_mae_check_encap_match_caps(struct efx_nic *efx, bool ipv6,
+				   struct netlink_ext_ack *extack);
 
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
 int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 542853f60c2a..c1485679507c 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -48,11 +48,35 @@ struct efx_tc_match_fields {
 	/* L4 */
 	__be16 l4_sport, l4_dport; /* Ports (UDP, TCP) */
 	__be16 tcp_flags;
+	/* Encap.  The following are *outer* fields.  Note that there are no
+	 * outer eth (L2) fields; this is because TC doesn't have them.
+	 */
+	__be32 enc_src_ip, enc_dst_ip;
+	struct in6_addr enc_src_ip6, enc_dst_ip6;
+	u8 enc_ip_tos, enc_ip_ttl;
+	__be16 enc_sport, enc_dport;
+	__be32 enc_keyid; /* e.g. VNI, VSID */
+};
+
+static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
+{
+	return mask->enc_src_ip || mask->enc_dst_ip ||
+	       !ipv6_addr_any(&mask->enc_src_ip6) ||
+	       !ipv6_addr_any(&mask->enc_dst_ip6) || mask->enc_ip_tos ||
+	       mask->enc_ip_ttl || mask->enc_sport || mask->enc_dport;
+}
+
+struct efx_tc_encap_match {
+	__be32 src_ip, dst_ip;
+	struct in6_addr src_ip6, dst_ip6;
+	__be16 udp_dport;
+	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
 struct efx_tc_match {
 	struct efx_tc_match_fields value;
 	struct efx_tc_match_fields mask;
+	struct efx_tc_encap_match *encap;
 };
 
 struct efx_tc_action_set_list {
