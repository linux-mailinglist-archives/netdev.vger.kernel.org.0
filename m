Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24476B9D28
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCNRgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCNRgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3882CABB30
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtZPArmB/tGwa8v50t3kew6XGR4jYI06+fdF5DKBOemM9jG/o+SBsPpd5E9ttUaLrBDhQPnSY+PcHmc3VheW1sYTqoeP93kJwKasYeTvwLEizzt7cxGXIl10Stn4tgC1w0at8EAPVNDqMXK0qhfxvjFsrMV1teGzkFUy6LyvEIm4nHRz2ImcV6yDKvhHPrV9qqNC1pQQGHydGqyFvBnewZWzOGJOnc11ewUDZg3krdPoG2LVJdDzvQk8pVaVXCykD9gkuMeHdM3WQLWvEDW4g3+xO0W/H72y+JO6P0yi8OREtlg0RAuUNVp+t8O788nxVKiQftc52ntKaE6R69tpQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXWjIIhhmG2aChWtoGHuoUT6ViSJAuRpiC4SpmGvR9g=;
 b=iXegdQMdJUv6vPtV+vg5hkHK3RFUU5c0KhT87aSIEMuUMYWZ2bSReAaIRriwdXGCiPS+xCn6Dnqo3ewXXLWhcsINKcAo5sncRfuAyRhykAyJ+8PObiOA6hhTA42jiAtDFOXMTZr4nAfOGIJPfMvjvHcexatR2G5ZHvh6Qnb/lD6k+q+0FyNP0bQaGtc1UI4K44CgQYtxDlUZyEciqE0r2fn7LN8qF5UMnBIVAEEsFOtHWERUrpKDUYAVTBL1oNcaEsF+xtyzX9NlvNUtutnFszcjHFTZ6mp+I1s37UJIRvW/OcTVaNejnAsOAkVq1Sl1F4Ok98evbrB/fO/onUJhiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXWjIIhhmG2aChWtoGHuoUT6ViSJAuRpiC4SpmGvR9g=;
 b=IM+XXk307y7T8UVckyoK0LydDNCwzwyAY+7VLWq/evoGUGf66cChW2omLFFE5C9fpgogyUk9USsEp44B5J/WnA51tpWjgiUyyhdUzF7ozm9kN3e2BihB7NkLTz9W63rRcoyBAUhWEE9oCtbtglL0+1CFIXsbejzK+kodV+kkOpw=
Received: from MN2PR06CA0026.namprd06.prod.outlook.com (2603:10b6:208:23d::31)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:36:31 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:23d:cafe::49) by MN2PR06CA0026.outlook.office365.com
 (2603:10b6:208:23d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Tue, 14 Mar 2023 17:36:31 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:31 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 10:36:30 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:29 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 2/5] sfc: handle enc keys in efx_tc_flower_parse_match()
Date:   Tue, 14 Mar 2023 17:35:22 +0000
Message-ID: <962d11de229400416804173b2ab035d73493a6b4.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1678815095.git.ecree.xilinx@gmail.com>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da2aa69-e4a2-41e4-c392-08db24b2a654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DanPH1TNUPkP6WdMTL8wtNC7D9FIa3nDGp8XaxvS5P/wTfpdEq67sbWUDvtS6nZn8N4WSWsajaP+mCo3NgZqoNjhWxcb0wb3kdLJ1JY8XJ54554cTZElQPYX59znqKgBs9u7g0arDwEZoICX10gFZ7jlgew8NYquKo82ewDErOBOIjnpyNmpOsU2BYpN0SVj2gbDYDUBTdPJtLxtTFNJrGrF6dx8CxAdlXwtSs9lRw8ochTh1KgZ6uKvpyld+7Gs1W3WowSIlc7fBsB3d3OIKgGCgYzJLg1tDJuzGhlvjmnnKpBfAwRoa2Oz9ukAKKEXCpELGEQfAWBGM6Fuqb2gfUnJr4n7/caPzyTHEq1aPz8QzvMHi4dNXAwOWmsO2aFmA2xLzmqwan+kcjo3beSr+2ZWFm9PpqfR11L8Ej3CAQjnvK+A9LcN6Atnd/YBC9AP7O5C/1bGjkZKRv7HC2akqJepWsB59EMTfC/NiICFkSrm0H7nC91R/G39EZ2ew/0leQaIwPcI3T8nBpFZFjxPbg/eNG8myyulHkc7MhDowYaR6Se7cjaNPKIwS/pvPcg+L5Egkchdo2vKCYuMAyDgX2D8m3Kv4nRuk/+XHrwEPa94M5xqYDZggbMMoCFODnaSqHqt1Zr1NNLheQlYC7cdvggG8qaZi2XlDJNWls76YM3A1qoIOr5sr2C5c25AsZxhM2VGdRJHq9djXQGgQDtUSRWCEsLKvLjr3hUQrBb6shg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(6666004)(36756003)(81166007)(316002)(110136005)(82740400003)(478600001)(54906003)(36860700001)(82310400005)(40480700001)(356005)(8936002)(55446002)(26005)(40460700003)(4326008)(186003)(9686003)(70206006)(47076005)(336012)(70586007)(86362001)(8676002)(426003)(41300700001)(2876002)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:31.5940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da2aa69-e4a2-41e4-c392-08db24b2a654
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
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

Translate the fields from flow dissector into struct efx_tc_match.
In efx_tc_flower_replace(), reject filters that match on them, because
 only 'foreign' filters (i.e. those for which the ingress dev is not
 the sfc netdev or any of its representors, e.g. a tunnel netdev) can
 use them.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c | 65 +++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 2b07bb2fd735..d683665a8d87 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -193,6 +193,11 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_TCP) |
 	      BIT(FLOW_DISSECTOR_KEY_IP))) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
@@ -280,6 +285,61 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	MAP_KEY_AND_MASK(PORTS, ports, src, l4_sport);
 	MAP_KEY_AND_MASK(PORTS, ports, dst, l4_dport);
 	MAP_KEY_AND_MASK(TCP, tcp, flags, tcp_flags);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control fm;
+
+		flow_rule_match_enc_control(rule, &fm);
+		if (fm.mask->flags) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on enc_control.flags %#x",
+					       fm.mask->flags);
+			return -EOPNOTSUPP;
+		}
+		if (!IS_ALL_ONES(fm.mask->addr_type)) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported enc addr_type mask %u (key %u)",
+					       fm.mask->addr_type,
+					       fm.key->addr_type);
+			return -EOPNOTSUPP;
+		}
+		switch (fm.key->addr_type) {
+		case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
+			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
+					     src, enc_src_ip);
+			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
+					     dst, enc_dst_ip);
+			break;
+#ifdef CONFIG_IPV6
+		case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
+					     src, enc_src_ip6);
+			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
+					     dst, enc_dst_ip6);
+			break;
+#endif
+		default:
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Unsupported enc addr_type %u (supported are IPv4, IPv6)",
+					       fm.key->addr_type);
+			return -EOPNOTSUPP;
+		}
+#if !defined(EFX_USE_KCOMPAT) || defined(EFX_HAVE_FLOW_DISSECTOR_KEY_ENC_IP)
+		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, tos, enc_ip_tos);
+		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, ttl, enc_ip_ttl);
+#endif
+		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, src, enc_sport);
+		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, dst, enc_dport);
+		MAP_ENC_KEY_AND_MASK(KEYID, enc_keyid, enc_keyid, keyid, enc_keyid);
+	} else if (dissector->used_keys &
+		   (BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+#if !defined(EFX_USE_KCOMPAT) || defined(EFX_HAVE_FLOW_DISSECTOR_KEY_ENC_IP)
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
+#endif
+		    BIT(FLOW_DISSECTOR_KEY_ENC_PORTS))) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Flower enc keys require enc_control (keys: %#x)",
+				       dissector->used_keys);
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
@@ -373,6 +433,11 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	rc = efx_tc_flower_parse_match(efx, fr, &match, extack);
 	if (rc)
 		return rc;
+	if (efx_tc_match_is_encap(&match.mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "Ingress enc_key matches not supported");
+		rc = -EOPNOTSUPP;
+		goto release;
+	}
 
 	if (tc->common.chain_index) {
 		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
