Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938F5660160
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbjAFNgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbjAFNg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:36:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC6C1114
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTGCj8/Bq3yvSZ/g5goT36gF7LkplDHJXYxdH3mCNGegvxYGCAn3r1/K4vyIjmZc0+ljIT9vQ+hIpz6U0Susrs0i2wuvBl6N/HJ7zIWPTGsNDm0BjPbKG8ZdSLP6LoGok9A8h1P7SKKjEclhaKfyqAlcQVNR8M3/OwWzm9rqert5Q4vHis6AuzhH1FYB4I9yAH8JKhORhjrdFxVBgDW/OquMsAh8u8uxFLA8uhSn+n5ppxK51FyXRWgLOYWs+mpUDZph7qFfNW9FXIqgGuT0O3+mi159+LOEZSKD7FtudgVVWxfWv8ArnUr6C1uP3QqNKCM6a9yIFBezsmgZeaPAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=bdME/CRRf6w3uQpfCvKwL/6is2m6H4upN809ww75GhDPLM/njBaySKkoDjBLDwi1gEAqm0Wdt0CGBvphMiijXrGnpc64nXL87Y26LwjJzRBe8sQ1O7oBVOegY+RWMMJAixWg19zIhZWGh+hdLtzxQU++WsDN4PFHpssDrw8Q4+ykcslE2II1GRSE4H23h1mRdxuu3PJfoiIif5F+WgLK0oiJJS4axLQMF1i2BwOktOOGAmrtJFLYxSZo/KahrNOF5VPBfRdY70xLrF2+RglB2qIQUPLoW7KFVDE90kyA1DJTPT9+p7nHr9OEnLOYdZofOXHs56kGcezbXE9RY8Xe7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBs2QJdCz/art+qlcoc8F+OZ2x1iBkoNoIgw6+LNKNg=;
 b=GRJbZ7UjkN9FpGlFjRTSxYYD/P62r/s/bRbKqSrRSk+8dy7rwcdN/cG1diJ8NqchAexE62pox0lUM2/Xd6+GB3gvVvLXkxl1CAHua7l9p/7QKOOectnqHkTKwwrS65KA2Q1BAofgQA5q5JmaSKPwISyUmtERrzQFMLPEFWOjj/e2JN32ZckQxV435Nl6KrsIVjH05lxIW5ZQ+iL6dsAPTuA4IKrLFp5IIvfUoC0I2tR+FfRO0B+hzN2iTERva+5yO79dddmNqVPgY7JX+YYvcijDCjqWc8M6o0zjNeDs2jRlJDg7uU3Y3PaT6PE9dJaxmBeEi8q/KTomQ5DEFOklSQ==
Received: from MW4PR03CA0331.namprd03.prod.outlook.com (2603:10b6:303:dc::6)
 by MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 13:36:23 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::ca) by MW4PR03CA0331.outlook.office365.com
 (2603:10b6:303:dc::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 13:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.6 via Frontend Transport; Fri, 6 Jan 2023 13:36:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:36:15 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:36:15 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 6 Jan
 2023 05:36:12 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Fri, 6 Jan 2023 15:35:51 +0200
Message-ID: <20230106133551.31940-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230106133551.31940-1-ehakim@nvidia.com>
References: <20230106133551.31940-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT041:EE_|MN2PR12MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ed8c5c-349f-49d5-2250-08daefeb00b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: neBKfqZh+1Om99rHITSDFnh9dK92HGqSICHj+yA9rp2y9ts2FgXy4Fvs/0dRG/6i8A0Nv/+nINXaat3Oqz3e9YJV2H8fxE4T36kTvfzyX5RLAuIB5LiU9ArCn6nksogyaar0URpHhadgz+xvRsgCpiYbIHc353z9keBZ/1xRksnxT4ufnfImOuH+RHgUUxLpBRcf5OrC/mzW9zw2djADfHGLU8fP41ElfN97npfKenK47xrS7oUh7VcDo8T60oNDfF9AM7cIBqWqs8u/rdGlYBgDlhAYVAywQ2QgO+hBZE4TVP0sKc049pyNcFqK0O7v8VEA0B9uYBI7w4ZEiM3Og7mQWNZ0LpM6V1AZKtAFsP274iat5lApv+oATM48RVJjQG+VhL5YfaSjKIswad7mcU5znXzgbz1sCdfpiI0pPCN4j3ylQidU9WIRyjqpJ0n5IfLgtkxm3exiMSL5Cpd9SunroO96BznztUvmcfn4fOnzaxB9BmmKcdfJ06qtD+cv/Piid0khsar52A3sx1YdMNo39UJlNkHanVtpQeLVnmgfAR8dW4al/WiMjPeB9dY0CY47Bd/ual6OLowVJ47hEPSk7SZAHGF8sOsTg3ZoFXMf2KoRD3zhE7YIIQCtl2LfY6l2r6d92rF3emiEXAZk2M8CIfacha9Rv5R4rf9YJw2y7CiBDIc/YEerIOcDrk/RGg+RjzFk+HEk4k/LXSjz8Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(83380400001)(426003)(1076003)(47076005)(7696005)(26005)(6666004)(336012)(107886003)(82310400005)(40480700001)(40460700003)(86362001)(36756003)(36860700001)(356005)(7636003)(82740400003)(186003)(2616005)(316002)(478600001)(4326008)(41300700001)(8676002)(2876002)(2906002)(5660300002)(8936002)(54906003)(70206006)(6916009)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 13:36:23.3426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ed8c5c-349f-49d5-2250-08daefeb00b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206
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

