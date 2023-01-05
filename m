Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6808665E651
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjAEH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjAEH55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:57:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B863B91B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 23:57:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nH0QL9hGNyhdvEltC2F9AtqfYoVZTxnFVMIyPYad2o6g5c+fz9Q5RK9SMUIzHVp7QqWK1nVjMJXUrEpq0bwHol+9c/e6mMApeqlgnD2EvBA8IX22ld7GnxvKmV5GgUBHeHCZC+BN0mXfhTQz+qnnNB+X7Aa8Umv5ww4JceptwctpVD0dphbR38QYocOjNUkIdVBq4hoB1avHBnJmGA9K9vo2ytC1SHaSMnReTabIRiPAD3ONdDnqrfbGNRzRnQ1yfvppJFv1m0WbN58WbPtQqISpIwFg2vTkEyXI3x84WJBQGGyIV0pFVl8HGEcRmEZh3jhioqkzs0utAjCYvm5T5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=jnEviwZBqVNhI3H/uVrQywh/Jtd1B4810iLal6ley9+irB1UQjgPr/QX+vvYjU+0t/4nQDWGpwMeMZAUw2lodwzdPMKnNw9uF2LcAcACB1xFl3ALOo9ei1gXvE7WNTnVEmyXIR7kBbclb4P/0X1DjmO1el+0KM9TV4ugmj+wVYokgQtzFwScIgPLSVcy3IRKYvUtZYtcN039imemeGg2Rg++06zE+5RbzEtrRdhIiUgUz6kZKlNxTt2yNLnrN19c49Zf0FImQfOSmASLLrIPD02CnEuueboEUVnyHVfBuds7xApF3bsSLGCFqaH18NOVXam38F7SCBBtTcAbrxPspg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=NLVwjL4WbFVDZxS+6Hj/Mxp1jo33KZReJoXb04jTSSg2B0g/ZCem2ptrn3q917N9z+oGaG5UzPlXFaHBGOF7wfk1HeMTqTWsbB/laOo91CqQzvQ5TS8cNXEk4+UO/OvvU5o5cotk8mO2uJhggmq1y4EZDLqmg5ksezw+BnUIiDhrA+MF6bZk7POSd6DHrL2n1g/do/4KSxFGhG23HwuPQ2Q9Bb/+JEEb5TQ1Pu2CYoNmeX3La/oIalZWb8JBEoz2WNeMk2XVPOV8GigiSQDiUiAYHRSyN/VnlvBom9yxN+LosVFb4mXKPj4z9yDugyYvfGtmj9LwpFXSA82j8fQZ0g==
Received: from BN6PR17CA0058.namprd17.prod.outlook.com (2603:10b6:405:75::47)
 by BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 07:57:54 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::5e) by BN6PR17CA0058.outlook.office365.com
 (2603:10b6:405:75::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 07:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Thu, 5 Jan 2023 07:57:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 4 Jan 2023
 23:57:45 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 4 Jan 2023 23:57:44 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 4 Jan
 2023 23:57:42 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Thu, 5 Jan 2023 09:57:21 +0200
Message-ID: <20230105075721.17603-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230105075721.17603-1-ehakim@nvidia.com>
References: <20230105075721.17603-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|BL1PR12MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: 002fdadd-91bc-4252-84ad-08daeef28d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1sVI7OwWLS4VfzVdi8DhRPjyzoLbLo0MWBEoKEEhiyZNJY35JZiqZLuEjrZVT5QSNF0prLewiyWWKuafKZPF6kBd98/nJzmRSIL7B1euis3WwZluMoEfRVBQmmIh/qkYLq8PJcgYI32DXYnINUDUGXdlLxVEiklhztSVy3Xm7fcXuTtymQal5XTgA74ZbyGvW4GwQuYZkHBKSSkMNtRhR2AyjsCwwtY6i7V2d/KHdlP3L7WW45HfdiBhsXgxs+ICIfRwqM2B+a36qyRAoN7CILVPwC0UyoSm0Fbw9teuVNSA1ZmI8nJinQ1GLWtVhfyq30VpRXhYHSZyYAeu5MP3/Edtny5hQ5hRnSfTOEySY77c2AGcg3VSwzSPC24ruUSWUsraBzlHka27cwb5wjlj24VOCmQ9krJEpKN9UNar+8T8QbX4V3XRAYTTp0D9VPjHGXnd61LosFoEGOW5g5w936eSJ4sM3029h1lYE9CXVSS5Ta39Y47dfx8dc6jX2pkaFuX4oRwwZR6dnJltyuJKk2USx/si2jJpLdQEo2LI1GTwLYJpeuYmdvNS4cwy8cHNSmBxpTNxrOG+1ypZUYWTb0yHgUSRJoNjonr0qJTvDyCBRCk8Cr9GKFX5uIPVDLYW3MrsQSlmkork8Vx1nUb/8+Giw8NhF8y5C3/OlB0QV+LQdQg1TwajX6APNa0zA2OQ9tGp1L55yqjaYS9hX5uoQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(426003)(83380400001)(47076005)(7696005)(1076003)(26005)(6666004)(107886003)(336012)(82310400005)(40480700001)(86362001)(40460700003)(36756003)(36860700001)(356005)(82740400003)(7636003)(2616005)(186003)(316002)(4326008)(41300700001)(478600001)(8676002)(2876002)(2906002)(5660300002)(8936002)(54906003)(70206006)(70586007)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 07:57:54.1005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 002fdadd-91bc-4252-84ad-08daeef28d18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970
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

