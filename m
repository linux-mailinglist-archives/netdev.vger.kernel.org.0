Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5367377D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjASLyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjASLxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:53:43 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A306E5CE6D
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:53:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpw2SuWUWTcow92Y/ZrTRotiPit85Zvmvx7R3VNQFJmXaC1inCxQ4YHn9es59nGPbaQei1ubjx5TDgiWXjiAPLRdTsttpEKYi6q17mTSu04t/FXAmAYmgBVzxQC7h3CM/CpkyjWe/G+9zX8N/TlZTyJX9BHmPiPQ1Kog/uCxHGqg4O+b69RoQe8wulSK7iQ9pxzeDnZ56gulC3ArDtqNOydYJaElZfwar8CCsIH0J6pMhGGTIkW1D/jjnG58//MT3I+CNusnJDkkUdrkYlS2SmJ3vl3LBS7ZlL+VQgeiDN2XkHG+Vd0mrMfecvh/BKZSVfAyP521eRs6LEJ12IuxnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/BqWs1Qi7pdhDHGUn5Ai03ZU2o1N2z2tye8TNrFyJo=;
 b=T4kDigFJLkKcp0nRdkQ8aEIbDb5+nsbbhQw7DPBma5zzzby+ChNIyw/ATLgmEkyqnLL5nFur57mM0gYqbA9IXiTnkuCOt2/cpPASQ/Q8j0jOkhesf3ocxoobSPT0gKvcj0ESy8GJyyyfbVm5b0O+uOIHyJmDkIfUmxXqGrmkzqyvSKeHnwTDNEKKAaeXXETlynpgDYDV2dq9WQ0yH51hkHA6bw2aJVkNHknZf7UsIzCTkXjSk0XN6e57wE36s9w02PcIi23KbGAHYyLWAaVn41xMsiw1Bc/SAWmKBrdMev0wLP9k2G+LJtaIkIdn+n9zG7nHrE52B9UkEw0B/Rgh0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/BqWs1Qi7pdhDHGUn5Ai03ZU2o1N2z2tye8TNrFyJo=;
 b=TdmE0yyaTAGtWONd/DKCpC3UTR253WpP3lPlGRJX1ID3lt76SuM4C80aKKgstNjHjjRafxZ4Gyk20T0O0+pitjAnZ5SGm2UIWPp2/1SdjPhHssIYoTNu1iBWwufUuoKhbWnCVkZNuoPT2AyVB0ej6DuAOrGEaDmrntEI+jsC4NTK3g9TeYk0Ng7k7OVzdFwmymKFF/ofkyJil6PyEgdQ9SVDEsCn5GveKKnJRMZ4zfSC8bdszQ0P2I2gztixR0/XgHXpjZfloNKrjGSKGcJfo6wlmPMP5mbqffwMuED6l5ZjE4awkQweE1igNa8KmAdMZaN4fPfvpWdQHnZt9OJSZQ==
Received: from MN2PR19CA0014.namprd19.prod.outlook.com (2603:10b6:208:178::27)
 by MN0PR12MB6318.namprd12.prod.outlook.com (2603:10b6:208:3c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 11:53:33 +0000
Received: from BL02EPF0000EE3E.namprd05.prod.outlook.com
 (2603:10b6:208:178:cafe::6c) by MN2PR19CA0014.outlook.office365.com
 (2603:10b6:208:178::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 11:53:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000EE3E.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 11:53:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 03:53:16 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 03:53:16 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 03:53:14 -0800
From:   <ehakim@nvidia.com>
To:     <sd@queasysnail.net>
CC:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH iproute2 1/1] macsec: Fix Macsec packet number attribute print
Date:   Thu, 19 Jan 2023 13:53:02 +0200
Message-ID: <20230119115302.28067-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3E:EE_|MN0PR12MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 301bdce2-898e-4191-3652-08dafa13ca2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XjJtTZfgDpSBNE5wfVpmXk1rv5UxBv083ptBUtr+alyuSJywatyZsSN09DTbsdHiMWTnNJFecUUrDOx0e17C1qZNCzKYZq/tv91SxO+aiWIdfx2dTQKvmJplY0NsXZnbyjYE1ij63bPMLQhDTcx+Y4SZasEt1juB8SX4WSago8h5PFazxDqrnVPgidp73atSqUClJUBieXKSOApUboVHMED23159NPYhmsRTFy+f6hPe8+0UN1VriV6dMfcuUweFHqpnj5gAA9Retd+Ph5VWYQDYSIjyplN14AuzyCtVDwFxkzmm+hTw/6QxLPISP3IxeGLD0K4sNUuaQhLTFhRGXjoUoj8cXwmpFSdQdVFNHbRQVMogdQ0uBBkQjNXxKmgGM7/6xr/d1aZZiuliJsW9E90csP7XwnfOoMEzwgwygYWBpqFAmYhKl2S2vhFs3ODSrzgE0K9ZHYa27j7fcMcg+9dE32zh/pIzIRQRmHOM3f1HDIeOyhF0tLnHGmYL2KMp9PfgVlt5QJic0vN1Ujnfx0PawxcXwzvBmeqNrC2wn879CJgdrZxwUShddnJQLuGe2+qQ+Nn2KpR6y4ihS0KIPyKtK8O3Q5W1sDkSV4NMstLLGOwwRi2w1cHhENcwa9Hes3Xnz+8sfag5nBA88j+xGCJRvlrfLpubDlxMh+CHKnGHIqfy/B1frr3WfYXbUEZzrYSNxfrWSAvmi+L09rMiw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(82310400005)(40460700003)(83380400001)(5660300002)(1076003)(47076005)(6666004)(107886003)(26005)(54906003)(186003)(426003)(7696005)(2876002)(40480700001)(2906002)(2616005)(70586007)(36860700001)(316002)(70206006)(82740400003)(478600001)(41300700001)(336012)(8676002)(356005)(8936002)(4326008)(7636003)(6916009)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:53:32.7689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 301bdce2-898e-4191-3652-08dafa13ca2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6318
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently Macsec print routines uses a 32 bit print routine
to print out the value of the packet number (PN) attribute, a
miss use of the 32 bit print routine is causing a miss print of
only the 32 least significant bit (LSB) of an extended packet
number (XPN) which is a 64 bit attribute.

Fixes: 6ce23b7c2d79 ("macsec: add Extended Packet Number support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 ip/ipmacsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 8da7c3d3..8b0d5666 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -938,8 +938,8 @@ static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
 		print_uint(PRINT_ANY, "an", "%d:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
 		if (is_xpn) {
-			print_uint(PRINT_ANY, "pn", " PN %u,",
-				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_lluint(PRINT_ANY, "pn", " PN %llu,",
+				     rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
 			print_0xhex(PRINT_ANY, "ssci",
 				    "SSCI %08x",
 				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
@@ -1015,8 +1015,8 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 		print_uint(PRINT_ANY, "an", "%u:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
 		if (is_xpn) {
-			print_uint(PRINT_ANY, "pn", " PN %u,",
-				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_lluint(PRINT_ANY, "pn", " PN %llu,",
+				     rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
 			print_0xhex(PRINT_ANY, "ssci",
 				    "SSCI %08x",
 				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
-- 
2.21.3

