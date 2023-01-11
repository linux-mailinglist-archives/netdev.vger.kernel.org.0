Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948E9665535
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 08:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjAKHdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 02:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbjAKHd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 02:33:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64702EE2C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 23:33:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkQXnQwZ+u9VhRfWX4nCJPOGiQ/v2wkLnoEF0wCzvJnvZJGmzMu2Y63aCVsgbu+v7FrPUCAdCW59+2OU1IvXV37R8vPq3K51QcBQpXqXTyAjIu6dKvEeC17fuHYwW9I3r/AWkMqTPwvQkM0RBR6VJtRgyh6a8dZXcFJ2N7Q5aWYx7n1NewF9XN8iqvDLUCE4ixw2nyWS7D3xGRfUSE0p2eKg763ZiqzEYu80hK6NgMUmWmpewzk06dG8EzCUJkwhtMbcsFiK05afOXl1HBfHW5UiyZsMU84K6O9D0s2naPfvQ4u2vOluh2xWSxMiEQaezQvg65bS6mwZJ7YdHhDCcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMaqJPlydk5OaKrjvasOHSZ6snIUlpiHVIKxcF6ccao=;
 b=Li7a1aWjHrtJBVNV/9uvPgD0EiAecdl0+NANbGKBVG90sw0mKuOrtUcc3Ijy8kumeC+hFG7LT4RC+yq+owoman9lu+xRxBamLw6EwpUCS6utxKT5teAyj5KAvhha2aVorf3eRDl2EeoJUkaZEnJXPtlvepQCc0JDf5gQuyyN+LV2AdnhsEjJppoE1+4G+dHPH0GsffvLG6qMJlskgxRY+jWQ1sLW9PGNVSE0BUEfb+QDgE6VlF2W8kEsw8z0eUlhGXFzAiHENuIHS9BGSKJcQIph0RJlb/R8dlwGjzHGflS5+N7xWftfTUmSQHPwYq4pF+OL25y0ozvEkvquYYo/nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMaqJPlydk5OaKrjvasOHSZ6snIUlpiHVIKxcF6ccao=;
 b=SEDDAvxdZdJJvWpCAicx5uFW8TnBYu4F7TWHnILTojaglP6j3Q2PLKgkTDUsDUwurwtBKqJpqU7/mDcqdywwbAgMdO0Cs+WjNeBk0DfC3k4MFU18qWXDhp3Luca5+aIUuSTpSOt+Vi9ZDXZhtMXUPbecEIo33YTwT0h4JA4JoJ+Y7jMcu5U98xMuhu3BRwh/TSVLMTbQOSaYVqP0uK9udkFR1v48R/3wbcc8FTL+ayaenkWBifCJ90Lw28do9ZVQNw6g2O6P5sYcF6fqeF2IBOocWqJFbPVS13T+XAe1jKrMOsxJrnSn0VPKn9y1Q5xPw50eDgTyfKM23l2TZyMAdQ==
Received: from BN1PR12CA0030.namprd12.prod.outlook.com (2603:10b6:408:e1::35)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 07:33:22 +0000
Received: from BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::80) by BN1PR12CA0030.outlook.office365.com
 (2603:10b6:408:e1::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12 via Frontend
 Transport; Wed, 11 Jan 2023 07:33:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT102.mail.protection.outlook.com (10.13.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 07:33:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 23:33:08 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 10 Jan 2023 23:33:08 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 23:33:07 -0800
From:   <ehakim@nvidia.com>
To:     <sd@queasysnail.net>
CC:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH iproute2 v3 1/1] macsec: Fix Macsec replay protection
Date:   Wed, 11 Jan 2023 09:32:59 +0200
Message-ID: <20230111073259.19723-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT102:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 222016b7-5ab9-4b98-ac4f-08daf3a61e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17jdpzvyhwOxSkk6Yq/OIcbUDypgKVvAlCPdbD63dtCXBfhlT8nH4RZy/HdvKSFDFNIzO+ZbNOQwzaWpD9vxcp8+brL991+WBchD5R49zhhS+IIG3uSZeGsg4zq+kNciQSL1Fbacq2l+4pFDY3j/UKtDTJMU9DP9tOvyZROW+Ez48Jw1S6eHqZaWRvPNL0WcwEeI5nVfDD6M61r5vsr0xhUijDJiZPWjieu/TRtJmf9PlMfu/ss1QNoYQf4VtGQMmaY4QZIJeo0PTpCCC6hrSWgFG5MGG3UWvpt5ci142SAnoSCPrCMHdxRg1n7uj3O6W9E2or2LCEgS8ntoQ6PzlDueuqCr+fzcPhHDRb9tn69lrOa54EBivnxRkDZYMwbD9qTR88q0hBDfoqZGl8ZpJtMdW9Zh2KanOBEjfOIsR2lF4dsJs+R5Lynx9HpJLC/0DoEq86ddD5SIFWoeV0k9PWrBdZt+a5xaA1PmNZDDbK/CJO51SVy1p6orQQdGbWEuHG1Uxf8IrBHA53ihGgPpysgict5xt5o448Swo7fXcF//zQwUyYPIctvAtbQE8bxlnQOMFq0ZiC16EAIBcwzCGVQuuhMu5WfoDpue6sju6CnGBvPnXLwLJ5EpSM97SV984IJnD8dcjOyWd0OAe0vJmy3SmlcK/qK73jNAjnr6Q6qejtJUn5Mxcz/LOidcpL1fBY4GolJLmBvyZbqnEhkyag==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(47076005)(8936002)(2876002)(2906002)(5660300002)(41300700001)(7636003)(426003)(70206006)(7696005)(4326008)(316002)(6916009)(70586007)(8676002)(356005)(54906003)(26005)(82740400003)(1076003)(40480700001)(2616005)(40460700003)(86362001)(186003)(336012)(36860700001)(83380400001)(107886003)(36756003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 07:33:22.0901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222016b7-5ab9-4b98-ac4f-08daf3a61e2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently when configuring macsec with replay protection,
replay protection and window gets a default value of -1,
the above is leading to passing replay protection and
replay window attributes to the kernel while replay is
explicitly set to off, leading for an invalid argument
error when configured with extended packet number (XPN).
since the default window value which is 0xFFFFFFFF is
passed to the kernel and while XPN is configured the above
value is an invalid window value.

Example:
ip link add link eth2 macsec0 type macsec sci 1 cipher
gcm-aes-xpn-128 replay off

RTNETLINK answers: Invalid argument

Fix by passing the window attribute to the kernel only if replay is on

Fixes: b26fc590ce62 ("ip: add MACsec support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V2 -> V3: - Add iproute2 to the subject to clarify where this patch is targeted.
V1 -> V2: - Dont use boolean variable for replay protect since it will
            silently break disabling replay protection on an existing device.
          - Update commit message.
 ip/ipmacsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 6dd73827..d96d69f1 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1517,7 +1517,8 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			  &cipher.icv_len, sizeof(cipher.icv_len));
 
 	if (replay_protect != -1) {
-		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
+		if (replay_protect)
+			addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
 		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
 			 replay_protect);
 	}
-- 
2.21.3

