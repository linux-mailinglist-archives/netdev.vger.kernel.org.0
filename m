Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6966C71D6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjCWUr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCWUrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AF61BAF1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:47:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmWEtAIi7Rnomp2QARsZ/VwEAQh67jip/GPYtbumquPst8OxwIQkFrzNq2HX8EKGBsX6ZSgPHKSFpxWQo711afMElFTd2caJwfQQnYwiaSITuz+Qk/n9ag/M8ea1PiSuwBg3JUkcgXa9GxJPCdSpGUduR2bLGLVpKdgUBZtc1J3sCcmjBn3ktBiLpyjD3kCiDBJP1QXjtIVWPS7fMmTlV9EJTGtAOZ0sBRMyYdpT0otwAMI7oPnpDxqG8EJwPJvbdjsfJHQmDTJ91GGo6gDFsU6PXss4YBZQvBJdRqUIwmADO4mh2I4i48yLuqAujTPuQY18H92rRudlZmiiW5eLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXq1r9A9Ie0TAP4hh8zIzNqVezLXBtkl8IVrCRSdtc4=;
 b=YFEtyKw011BNI2q8NebnbsUIA58cQux1gb1k4u8iEQ3xHdsnUZFfNVlzyM+GzywRtlkHkkkVHI5ozVJlJtHmFE/frrd9h+XogjlbMZ51IXyg+7ckPkdsa1x84sFcE0BPqYVZmLGyQ+rpOgj99vCLa3Y9nltL/od4BAvfd66H0vZiMO8PrLDqr/7T1/XBmpD5Rs8vcUWDTQ/yC1pkYYCgLtOLtFUxrIOxZ43fIEizpZen6nYMUelhqyPDBauMFEEuVHi/L6Ys5Vwr4e3yvg5lOU/1d+gpPtfHYAoWgN/LtRm2a22ff6CEC6zl732hCaZhmLVGw3uzJfVvHqSepbZXsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXq1r9A9Ie0TAP4hh8zIzNqVezLXBtkl8IVrCRSdtc4=;
 b=3thNXPqTZUpbK+ptkhHv8ceZKft0zz167XQh4sL8FVvZgsw06jj2mTJxXSEpMdGKeQPusZjC+wQsFEgL/jnXNb+U+zEl/+JE/O2QqmZavcmEQiQHCkUece5u2oHkOaeUxaTf19pr3Y0kH06awkg4L5gGLHx1+jP1U0Uusu8KR8o=
Received: from BN9PR03CA0064.namprd03.prod.outlook.com (2603:10b6:408:fc::9)
 by SN7PR12MB8603.namprd12.prod.outlook.com (2603:10b6:806:260::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 20:47:40 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::b7) by BN9PR03CA0064.outlook.office365.com
 (2603:10b6:408:fc::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 20:47:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Thu, 23 Mar 2023 20:47:39 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:39 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:39 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Mar 2023 15:47:37 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 4/6] sfc: add functions to insert encap matches into the MAE
Date:   Thu, 23 Mar 2023 20:45:12 +0000
Message-ID: <b9798c4b1f176257cb9b690d350f3a3c66c1b401.1679603051.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679603051.git.ecree.xilinx@gmail.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|SN7PR12MB8603:EE_
X-MS-Office365-Filtering-Correlation-Id: c510236f-750a-4e86-c0b1-08db2bdfd78e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1OlUiTbqde1ITM3ORIagznGECyrDTGbV/V1DZYJ4hXxiCBnW9uJxkrZWR3tAS5CULlOfaYy/h0aN0AmslwckfqnaeUyHG6s3Gg6cNLqQxqDAUcWpSxaJ1W+czq/4i0E/VTIl66/l/4NW4uP6NMfnoCJAmY8fOeBCY5RoVGtWdmYuklv+YxmaBZbqF8sgZwqmKThJxem9mOHjSD/uRrkQDvF0pmQVONyb5/XIGVD/ax5mNX+unDy5ewUTo3fm0Y3ROWomK/ayahnBSaBBqL+mgPtgAf0tB0hF0J8tNRedxx9hkLrieblnOTa/i9IHYuJ1bZw4nP+OA+pBQTzglWKOtoln8EMMb20XTU4fNfLprAdQQzJ5jwg6aBw4MVGeEu98Y++auAw4HTvDzKz9BlZHPNA1DhNhdsNoODO+xlsxQnyGndBOypiPKe/2IiGho/IbhBdMlfyMUvkpPSXJTL4EERCSLGfQSDtS19unwlj2UX1LM4ee5/l3nUm6uzER4DM1D9yom+57/ZKW4/STAqhy5Fi7BOAzTIMGmpHc1mhEGzBVwKPmWHwjtu0QCmkadU1jZJ+Pejlee9SMi3GcwFjqHiSu11uhRRH9dWLGD5WC6ugUR8SDvHJelmSUMMl7g8Ix6w8AjKWIsOAXuoeApidod/gOWMfU73mxmiE5MoIVrJHAIh+2hlZM3WQg6/meuZ8WihhhoC6CRK9VGE7l0AwbK+B0el/hM0E9Pf8CgbtPMU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(55446002)(86362001)(356005)(36860700001)(82740400003)(36756003)(81166007)(41300700001)(2876002)(40460700003)(4326008)(2906002)(5660300002)(8676002)(40480700001)(8936002)(82310400005)(426003)(9686003)(186003)(47076005)(54906003)(336012)(83380400001)(26005)(70586007)(110136005)(316002)(6666004)(70206006)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 20:47:39.6902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c510236f-750a-4e86-c0b1-08db2bdfd78e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8603
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

An encap match corresponds to an entry in the exact-match Outer Rule
 table; the lookup response includes the encap type (protocol) allowing
 the hardware to continue parsing into the inner headers.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 105 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h |   5 ++
 drivers/net/ethernet/sfc/tc.h  |   1 +
 3 files changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 2290a63908c5..92f1383ee4b9 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -558,6 +558,20 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 	return 0;
 }
 
+static int efx_mae_encap_type_to_mae_type(enum efx_encap_type type)
+{
+	switch (type & EFX_ENCAP_TYPES_MASK) {
+	case EFX_ENCAP_TYPE_NONE:
+		return MAE_MCDI_ENCAP_TYPE_NONE;
+	case EFX_ENCAP_TYPE_VXLAN:
+		return MAE_MCDI_ENCAP_TYPE_VXLAN;
+	case EFX_ENCAP_TYPE_GENEVE:
+		return MAE_MCDI_ENCAP_TYPE_GENEVE;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -915,6 +929,97 @@ int efx_mae_free_action_set_list(struct efx_nic *efx,
 	return 0;
 }
 
+int efx_mae_register_encap_match(struct efx_nic *efx,
+				 struct efx_tc_encap_match *encap)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_INSERT_IN_LEN(MAE_ENC_FIELD_PAIRS_LEN));
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_INSERT_OUT_LEN);
+	MCDI_DECLARE_STRUCT_PTR(match_crit);
+	size_t outlen;
+	int rc;
+
+	rc = efx_mae_encap_type_to_mae_type(encap->tun_type);
+	if (rc < 0)
+		return rc;
+	match_crit = _MCDI_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_FIELD_MATCH_CRITERIA);
+	/* The struct contains IP src and dst, and udp dport.
+	 * So we actually need to filter on IP src and dst, L4 dport, and
+	 * ipproto == udp.
+	 */
+	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_ENCAP_TYPE, rc);
+#ifdef CONFIG_IPV6
+	if (encap->src_ip | encap->dst_ip) {
+#endif
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE,
+					 encap->src_ip);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE_MASK,
+					 ~(__be32)0);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE,
+					 encap->dst_ip);
+		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE_MASK,
+					 ~(__be32)0);
+		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
+					htons(ETH_P_IP));
+#ifdef CONFIG_IPV6
+	} else {
+		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE),
+		       &encap->src_ip6, sizeof(encap->src_ip6));
+		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE_MASK),
+		       0xff, sizeof(encap->src_ip6));
+		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE),
+		       &encap->dst_ip6, sizeof(encap->dst_ip6));
+		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE_MASK),
+		       0xff, sizeof(encap->dst_ip6));
+		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
+					htons(ETH_P_IPV6));
+	}
+#endif
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE_MASK,
+				~(__be16)0);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE,
+				encap->udp_dport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
+				~(__be16)0);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO, IPPROTO_UDP);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO_MASK, ~0);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_INSERT, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	encap->fw_id = MCDI_DWORD(outbuf, MAE_OUTER_RULE_INSERT_OUT_OR_ID);
+	return 0;
+}
+
+int efx_mae_unregister_encap_match(struct efx_nic *efx,
+				   struct efx_tc_encap_match *encap)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_REMOVE_IN_OR_ID, encap->fw_id);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_REMOVE, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what encap_mds exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_OUTER_RULE_REMOVE_OUT_REMOVED_OR_ID) != encap->fw_id))
+		return -EIO;
+	/* We're probably about to free @encap, but let's just make sure its
+	 * fw_id is blatted so that it won't look valid if it leaks out.
+	 */
+	encap->fw_id = MC_CMD_MAE_OUTER_RULE_INSERT_OUT_OUTER_RULE_ID_NULL;
+	return 0;
+}
+
 static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 					   const struct efx_tc_match *match)
 {
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 2ccbc62d79b9..79d315a129ab 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -94,6 +94,11 @@ int efx_mae_alloc_action_set_list(struct efx_nic *efx,
 int efx_mae_free_action_set_list(struct efx_nic *efx,
 				 struct efx_tc_action_set_list *acts);
 
+int efx_mae_register_encap_match(struct efx_nic *efx,
+				 struct efx_tc_encap_match *encap);
+int efx_mae_unregister_encap_match(struct efx_nic *efx,
+				   struct efx_tc_encap_match *encap);
+
 int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 			u32 prio, u32 acts_id, u32 *id);
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index c1485679507c..19782c9a4354 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -70,6 +70,7 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	u16 tun_type; /* enum efx_encap_type */
 	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
