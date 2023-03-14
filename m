Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBFC6B9D2B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCNRgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCNRgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5429ABB1D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9R2Yw88+pjsfqewWOi0IFHCwoa/RkXieDZPJVYIXw2NEkY8cmA4b1kxzR9oxeVIRAL+lEjKmgiK0R/jwu3Xnixb0jI/mJms1dO4PEY/NtLD1tvLV1eeSB/EnFo8qSm6gz7Rimhf9RQoMPaQ7YnpcISklm35t0O+twTvL4UFJA1AqYAKv0GTTGZkOFfFWVC3WcbkWJPmhV7e29UzVv/N6ej10qQA2vG0gokJcIIKwD4oOtdu0Lg7/A/dbaKnZobVjc64EF+55t82fu05Twz9WK0YUll+yz66UlYIPx6ZM3RoIUSovkQmyBNQpS2F8H5t0uzHP1mw+ion3XgAKCDEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lU7XzEBIVeRik+74otMWpxl6K7Q5reFPSojY5FtW/Q0=;
 b=m5iVwpfNkv4+/R9vqNOUC26fzZzhbYDrBznyfBxJotQ2J3zg3WsPwNrAk0SlJ8kzNNSvWs9g39FdWRg9doccHMv7nWMuNGOw47nFCvNT9UujpchCtY7i9wcaMd4YyAAZwkTjGP3E8DSoSjt0OcPLW2YG4EZBphUMjlgH4PJhBfbZN8usHwYOP7C6S0UhpJ8RHFzlxF66zwwCfk6dP/c8y959mSm36tv6S/o4ZzQ1DLb5C0khrsJ8Lt43EAhHhG+IK73s9ZIZKGtzYSrXB9DTObPR5EmOCIrGQrkz0MNhFux0aSLPZbJeU+d1Q0LGC3zltEPhNNEfgBgyJKRaPLPs/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lU7XzEBIVeRik+74otMWpxl6K7Q5reFPSojY5FtW/Q0=;
 b=DwKDdsR0xb8DJup20nXX/T5ZFxO5UDrO+Tk8LcY2yJLvc25Fmy8NxMfFjDWiXuIWxjTN9N4Myk78VI0WLgmzQar/SA1TPGe9PL9erHER3g45JSc+IEgBOk+MAAx+8GkrDlzIN0fNx3FH+N0xOwUqcUeYzORI3tXzo2jWxQDoIDA=
Received: from BL0PR02CA0061.namprd02.prod.outlook.com (2603:10b6:207:3d::38)
 by IA1PR12MB8553.namprd12.prod.outlook.com (2603:10b6:208:44e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25; Tue, 14 Mar
 2023 17:36:35 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:207:3d:cafe::eb) by BL0PR02CA0061.outlook.office365.com
 (2603:10b6:207:3d::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 14 Mar 2023 17:36:35 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:33 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:32 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 4/5] sfc: add code to register and unregister encap matches
Date:   Tue, 14 Mar 2023 17:35:24 +0000
Message-ID: <27d54534188ab35e875d8c79daf1f59ecf66f2c5.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1678815095.git.ecree.xilinx@gmail.com>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|IA1PR12MB8553:EE_
X-MS-Office365-Filtering-Correlation-Id: c88d14da-48c2-48db-62b0-08db24b2a89b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+crs2GCRQ5Fq4asf42DGS75xqwrTyXahIClVfsZsRd7mJgSQ/z5uN/qva1apcgcpft/6iedIxyg6Wvci7o/qCCYW/ry5NJ01ztHeSXWOfeupRLNtLdsUp1DXYm8ixZFj1t81bnoBTT9v+LdU4UQxvRNFviJFU1q4MTKdZJCpGKxoSOa04lOmxRl0SGG4jduh+bW+8M4nmIWAsYarpqR64xTGXJ0C+x8MaxpLe+RUSvdsqmu2UQ53xN32fuG8WNnHchKZfRFDamegWTTZWD1SaX+8+wI4I+tLSM+tGqwmsY6HcDFO6YgA3+umRkhurr5LXoX2bEfO+uJlJIRbE6ubl9oa4+jya7aLUgqLyGfTa/L4YwGbMN5f869BgWzcffBf8R2SoxjFjXcmnSe7so2g7rOpUL/7dQR+DxIm0gIwamuh7KqUtiq9/+CxmrwyEuT0PtpA2fXvNJl0zevNElWWTp+xfryzVca+3Uz9pinvVrQYnzoX2L/U/Vxj0sVLaXkHONkerIeZERJZ7f3i60GRoGJCzcD0EyuetM33loJK1r2eo1MrO5GSGDybcYjeyOxCzhN83yczUttjoGxnuu7Cd3G4Z6omgwwJdJyLm2RIi/+k9jFkn/f3FoY0Zl23JvMWeo0yDcAxZSy+h4ngxz6tub/IX8wwpzymnmm4UzlHHvHyKu5W25VZnBxM89bR+ZSQoUzQC1IrTT9A1RlVMejasHIb/gGuh/BqXW6p7KSalhhS5L6UyLbjElZ3KC2fq42Bk2pbjCKiJ5fjCiolHwXeQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(4326008)(41300700001)(54906003)(478600001)(8936002)(110136005)(70206006)(70586007)(8676002)(55446002)(86362001)(82310400005)(81166007)(356005)(40480700001)(82740400003)(36756003)(36860700001)(9686003)(26005)(186003)(6666004)(5660300002)(2906002)(43170500006)(2876002)(426003)(316002)(83380400001)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:35.4122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c88d14da-48c2-48db-62b0-08db24b2a89b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8553
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Add a hashtable to detect duplicate and conflicting matches.  If match
 is not a duplicate, call MAE functions to add/remove it from OR table.
Calling code not added yet, so mark the new functions as unused.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 176 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h |  11 +++
 2 files changed, 187 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index d683665a8d87..dc092403af12 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -57,6 +57,12 @@ static s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv
 	return mport;
 }
 
+static const struct rhashtable_params efx_tc_encap_match_ht_params = {
+	.key_len	= offsetof(struct efx_tc_encap_match, linkage),
+	.key_offset	= 0,
+	.head_offset	= offsetof(struct efx_tc_encap_match, linkage),
+};
+
 static const struct rhashtable_params efx_tc_match_action_ht_params = {
 	.key_len	= sizeof(unsigned long),
 	.key_offset	= offsetof(struct efx_tc_flow_rule, cookie),
@@ -344,6 +350,157 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	return 0;
 }
 
+__always_unused
+static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
+					    struct efx_tc_match *match,
+					    enum efx_encap_type type,
+					    struct netlink_ext_ack *extack)
+{
+	struct efx_tc_encap_match *encap, *old;
+	unsigned char ipv;
+	int rc;
+
+	/* We require that the socket-defining fields (IP addrs and UDP dest
+	 * port) are present and exact-match.  Other fields are currently not
+	 * allowed.  This meets what OVS will ask for, and means that we don't
+	 * need to handle difficult checks for overlapping matches as could
+	 * come up if we allowed masks or varying sets of match fields.
+	 */
+	if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
+		ipv = 4;
+		if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on dst IP address");
+			return -EOPNOTSUPP;
+		}
+		if (!IS_ALL_ONES(match->mask.enc_src_ip)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on src IP address");
+			return -EOPNOTSUPP;
+		}
+#ifdef CONFIG_IPV6
+		if (!ipv6_addr_any(&match->mask.enc_dst_ip6) ||
+		    !ipv6_addr_any(&match->mask.enc_src_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match on both IPv4 and IPv6, don't understand");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		ipv = 6;
+		if (!efx_ipv6_addr_all_ones(&match->mask.enc_dst_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on dst IP address");
+			return -EOPNOTSUPP;
+		}
+		if (!efx_ipv6_addr_all_ones(&match->mask.enc_src_ip6)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Egress encap match is not exact on src IP address");
+			return -EOPNOTSUPP;
+		}
+#endif
+	}
+	if (!IS_ALL_ONES(match->mask.enc_dport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_sport) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_ip_tos) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP ToS not supported");
+		return -EOPNOTSUPP;
+	}
+	if (match->mask.enc_ip_ttl) {
+		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
+		return -EOPNOTSUPP;
+	}
+
+	rc = efx_mae_check_encap_match_caps(efx, ipv, extack);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "MAE hw reports no support for IPv%d encap matches",
+				       ipv);
+		return -EOPNOTSUPP;
+	}
+
+	encap = kzalloc(sizeof(*encap), GFP_USER);
+	if (!encap)
+		return -ENOMEM;
+	switch (ipv) {
+	case 4:
+		encap->src_ip = match->value.enc_src_ip;
+		encap->dst_ip = match->value.enc_dst_ip;
+		break;
+#ifdef CONFIG_IPV6
+	case 6:
+		encap->src_ip6 = match->value.enc_src_ip6;
+		encap->dst_ip6 = match->value.enc_dst_ip6;
+		break;
+#endif
+	default: /* can't happen */
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Egress encap match on bad IP version %d",
+				       ipv);
+		rc = -EOPNOTSUPP;
+		goto fail_allocated;
+	}
+	encap->udp_dport = match->value.enc_dport;
+	encap->tun_type = type;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
+						&encap->linkage,
+						efx_tc_encap_match_ht_params);
+	if (old) {
+		/* don't need our new entry */
+		kfree(encap);
+		if (old->tun_type != type) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Egress encap match with conflicting tun_type %u != %u",
+					       old->tun_type, type);
+			return -EEXIST;
+		}
+		if (!refcount_inc_not_zero(&old->ref))
+			return -EAGAIN;
+		/* existing entry found */
+		encap = old;
+	} else {
+		rc = efx_mae_register_encap_match(efx, encap);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
+			goto fail_inserted;
+		}
+		refcount_set(&encap->ref, 1);
+	}
+	match->encap = encap;
+	return 0;
+fail_inserted:
+	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
+			       efx_tc_encap_match_ht_params);
+fail_allocated:
+	kfree(encap);
+	return rc;
+}
+
+__always_unused
+static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
+					      struct efx_tc_encap_match *encap)
+{
+	int rc;
+
+	if (!refcount_dec_and_test(&encap->ref))
+		return; /* still in use */
+
+	rc = efx_mae_unregister_encap_match(efx, encap);
+	if (rc)
+		/* Display message but carry on and remove entry from our
+		 * SW tables, because there's not much we can do about it.
+		 */
+		netif_err(efx, drv, efx->net_dev,
+			  "Failed to release encap match %#x, rc %d\n",
+			  encap->fw_id, rc);
+	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
+			       efx_tc_encap_match_ht_params);
+	kfree(encap);
+}
+
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
 	EFX_TC_AO_VLAN_POP,
@@ -954,6 +1111,18 @@ void efx_fini_tc(struct efx_nic *efx)
 	efx->tc->up = false;
 }
 
+/* At teardown time, all TC filter rules (and thus all resources they created)
+ * should already have been removed.  If we find any in our hashtables, make a
+ * cursory attempt to clean up the software side.
+ */
+static void efx_tc_encap_match_free(void *ptr, void *__unused)
+{
+	struct efx_tc_encap_match *encap = ptr;
+
+	WARN_ON(refcount_read(&encap->ref));
+	kfree(encap);
+}
+
 int efx_init_struct_tc(struct efx_nic *efx)
 {
 	int rc;
@@ -976,6 +1145,9 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	rc = efx_tc_init_counters(efx);
 	if (rc < 0)
 		goto fail_counters;
+	rc = rhashtable_init(&efx->tc->encap_match_ht, &efx_tc_encap_match_ht_params);
+	if (rc < 0)
+		goto fail_encap_match_ht;
 	rc = rhashtable_init(&efx->tc->match_action_ht, &efx_tc_match_action_ht_params);
 	if (rc < 0)
 		goto fail_match_action_ht;
@@ -988,6 +1160,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
+	rhashtable_destroy(&efx->tc->encap_match_ht);
+fail_encap_match_ht:
 	efx_tc_destroy_counters(efx);
 fail_counters:
 	mutex_destroy(&efx->tc->mutex);
@@ -1010,6 +1184,8 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
 				    efx);
+	rhashtable_free_and_destroy(&efx->tc->encap_match_ht,
+				    efx_tc_encap_match_free, NULL);
 	efx_tc_fini_counters(efx);
 	mutex_unlock(&efx->tc->mutex);
 	mutex_destroy(&efx->tc->mutex);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 19782c9a4354..d70c0ba86669 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -18,6 +18,13 @@
 
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
+#ifdef CONFIG_IPV6
+static inline bool efx_ipv6_addr_all_ones(struct in6_addr *addr)
+{
+	return !memchr_inv(addr, 0xff, sizeof(*addr));
+}
+#endif
+
 struct efx_tc_action_set {
 	u16 vlan_push:2;
 	u16 vlan_pop:2;
@@ -70,7 +77,9 @@ struct efx_tc_encap_match {
 	__be32 src_ip, dst_ip;
 	struct in6_addr src_ip6, dst_ip6;
 	__be16 udp_dport;
+	struct rhash_head linkage;
 	u16 tun_type; /* enum efx_encap_type */
+	refcount_t ref;
 	u32 fw_id; /* index of this entry in firmware encap match table */
 };
 
@@ -107,6 +116,7 @@ enum efx_tc_rule_prios {
  * @mutex: Used to serialise operations on TC hashtables
  * @counter_ht: Hashtable of TC counters (FW IDs and counter values)
  * @counter_id_ht: Hashtable mapping TC counter cookies to counters
+ * @encap_match_ht: Hashtable of TC encap matches
  * @match_action_ht: Hashtable of TC match-action rules
  * @reps_mport_id: MAE port allocated for representor RX
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
@@ -130,6 +140,7 @@ struct efx_tc_state {
 	struct mutex mutex;
 	struct rhashtable counter_ht;
 	struct rhashtable counter_id_ht;
+	struct rhashtable encap_match_ht;
 	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
