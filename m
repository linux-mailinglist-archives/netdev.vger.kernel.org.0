Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2F65E66E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjAEIFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjAEIFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:05:05 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B976117597
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oACT30nYl4xzCu6Ne+/Un4KhQNRSE1SeA8HA08zot6UbKscy27Ed6lN/uyhUZTUMg+EwfShaQ/jdWafhW7P/hFdt99bJNxHR+s64Yz2PlbE6HKCaqMTEqtXPPjRKh+HWV5/ThfW8rGm5WCDccR6zdJjsCy+uLH8E0FnYPc7yFmxWpMWpU5Da/F2FBSqU0WojhKNkwuXNj8tmJ3o74i8yuYPHW9I4lgKnbZwwpLf3jjy+ckL9XPnonz6EK9yCc6qQHZOsuGGz4UX62kM3EGVEy9bYq0Vv3n7cib3/ehJkl2sdi2jikXGOziXXEEOeDEFHL0TrdFY5eIEOzbrKgaP+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=ZsevSrLTvprsWEAzCbiHE4arPU+92JGg+D9wE91s2uFkbF7exFeDU6kMo/cfZvQDSVqWg244bSUxkGSC9BUZM2E+s1HRAwmjEJyUP1mwcn2P37NsK0CO5hSMCt6kEwzhocy4ZU7SDktMaTAWYntP6l+uNVOoovDS4XWNTdLXl4140Qu0FayAOnHSHkSt9bQW9Pn1zRInFLtXcbtCk9MTJRcTChxMokrYxFvXm9tPgnAtrGCPhe1Oo4C3TnBHjBZnCXb2gCjfGF3/HfdektXfduIfbiV+SttaWjF+22bEPbJtrVPaeKzC2V9eGwZ112G+IRCafX7r5P5dw8xX+9avSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=MjuvLMJJ1kec8Z19wORpW87XBGulaDzm+vXwz7AiHxw4ktVb6mhbjez3VBC2z97BgAiih16x5EKEPiRag5oRsO7DjfeOgHJqppvchikWMjx4KcRtaHIsOnPyBWNRXIaDibN6fTi3puybZqkuHpao56KH8oivmJqWxMWZKak3pP/tpqqrEknunGy0aEAxEjX+eegmNmzuSLIvQvWxExxF2/5wdfkES8ZL07faXBCg97flP8csoDdR8Oxvftyt9Kee6+70WFeDO93J3x6lXuGsRwUoiYk+BXak912+VSuZCgos5N4vccmtl7Jf++ckINttI/GuwQZoAsQF9Ff1JkmPRA==
Received: from DM6PR17CA0018.namprd17.prod.outlook.com (2603:10b6:5:1b3::31)
 by CH3PR12MB8212.namprd12.prod.outlook.com (2603:10b6:610:120::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 08:05:03 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:5:1b3:cafe::5d) by DM6PR17CA0018.outlook.office365.com
 (2603:10b6:5:1b3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 08:05:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.8 via Frontend Transport; Thu, 5 Jan 2023 08:05:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 00:04:55 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 5 Jan 2023 00:04:54 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 5 Jan
 2023 00:04:52 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Thu, 5 Jan 2023 10:04:42 +0200
Message-ID: <20230105080442.17873-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230105080442.17873-1-ehakim@nvidia.com>
References: <20230105080442.17873-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|CH3PR12MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: dcad426b-a4ac-4ce6-ddb7-08daeef38cb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pL+esf1UgPtYC9H/HYzyYoe12PQU7xxamAG7QOiOyZwVylMg/bie2jSoIwKr2rLO0EjR/svuST8oVlpzXDbuL5NFvQXaZQ9mJyc9ad69gNy2CkRJg1OBcbw8/nNlPKDanb/SrxiwLZumgDVkEiwmyyKIQUF9yyB+cbyXB0AHiGueISg0s+yu5MlUAEasZBOLCgJokxAwoh2KxOThoWrnpv65BwWGM1uilV7X9GvEVkZpsCWA6qOXlZpgA3Hp2kp57yV/XAs2/g7ntuUJR7qLPH6S5WbTFvcGxI/qglXsYCOQ95yrslpcLVyi5ACKK75Js094CyfaQNlrxm2us78hfe8sgVHPp+mpDllkE6LVnv7dWrODEvR9HfSYS5CLr4a+Z9dUNo7SZ0jxRWIefKblGMmMG7dfhcKMiQvA8z8Ep7cdsSO4H2GZV2i/9YuZmmg2eiapSdHYnVS6y8I5GiQIFjD1Moa4inet7gLH8qE80Y1Ngcwd91M5N+IkEor0u9QA4nFUxFzV8b6HE0T3cU1nukH2XRrGHHVLTGrYpDQJa4oQehWyvgo/Dpxg3/RJPu5hzaME4zIPysjVOpjxBVB+aeCy9wZ+/A888AXsrBU71Lh2m6SLAcutFuRBoCAiFFJPyqBt/c6SU734pq29DkqLfk6Q3wCH52TLnGjKvRdLJpNp+kgEB2BuuwXBIlQYmdCBTDy6u9dpz3U6JG9uyBTajQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(316002)(356005)(40480700001)(2616005)(26005)(478600001)(7636003)(186003)(36756003)(40460700003)(82310400005)(86362001)(5660300002)(54906003)(2876002)(7696005)(6916009)(336012)(2906002)(83380400001)(107886003)(41300700001)(8936002)(6666004)(1076003)(47076005)(82740400003)(4326008)(8676002)(36860700001)(70586007)(426003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 08:05:02.9936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcad426b-a4ac-4ce6-ddb7-08daeef38cb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8212
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

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: Update commit message
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 1974c59977aa..0cff5083e661 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4238,16 +4238,22 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
 		0;
 }
 
 static int macsec_fill_info(struct sk_buff *skb,
 			    const struct net_device *dev)
 {
-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	struct macsec_tx_sc *tx_sc;
+	struct macsec_dev *macsec;
+	struct macsec_secy *secy;
 	u64 csid;
 
+	macsec = macsec_priv(dev);
+	secy = &macsec->secy;
+	tx_sc = &secy->tx_sc;
+
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
@@ -4272,6 +4278,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

