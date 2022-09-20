Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4905BE698
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiITNCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiITNCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:02:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F43A14F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE3hphcCAKsfAd2FS5oNF+xbI9MBmQrTJFJsg6MMQJ9Z2rUKB43L93fT1aoRvN8GxWujM8x4Q3WUjYY7II/0BzV0grUlE6Be4g0Rg267pCJIBb0YwJn71ylmivFhNKTRqQtudyWAbLNPoPpAKDYu9tvdSL/WTDoAvoLCfGtsJd23Hew5usXag7EHy6NWOt7EoN8jpVculUodcbD0DJlgnPITfJWOrYdecbQk1do0p+jrsFL4+oxkRv3onTf2WCzM6QAVMOEbevLUx/Pp9yzU29VG7RHGrr1Gsps3Fn5uHnvPNX6B/1D8RW78iv00dHUAcpL3ImDpasnuauhFqL0Iug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/97VQWuoB8P2zzeQDCeW7HWrkXGzmyLqx1Mw8y/mgo=;
 b=WdT8WG0TFLQghtdp1s6IQmncHJghKJCG0mAEb/qFZIP/qBoSK0ji6ReIqccTpQkqWDyctzeKrAwKpiK8YomIEFEebnNyiHT19fN1nlGHz1HQBgVFDoefMioGDjwwwsGp9SG709T0VEI4KtSh14zTgCzpYaOJi46pUafyxgqXcSlFLne4R7a9Ae0oPj2ljmzQSFv1sJ6+OyP0HF79BmS+ZoS7jsK0FOPUPIctj0pG/Rt6W7xTm+54+H5RmSAgN7AuJdCrLtlTuA4nGkfiYn47472YDnEjWjmNKoJdPtRsrz3yGnmnF+FSWskv8xgcs11ibn5iN16zbUP+AqocuORdXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/97VQWuoB8P2zzeQDCeW7HWrkXGzmyLqx1Mw8y/mgo=;
 b=t+0iyLNnfzNXKQ4NXWfYXcElYBnkbulv/PQW4qZ3rLz+0jJKKtOtHY66hbDAIwftKzUSWRFtByDpOlEzlOKptgdKa0uoLF8P9Un2FAB6J1XswL2Ctc0mRxeYwtjQAPKxbE1bj5mnvaZaOub2MYqAjMcN20nCm61DrefOO5M6Yl7a02za2ZHkWXdL38+9OK0sDpGFIT0kczrkN3NJ1U97xQx78r2CxmIs//bQ9iZGz18RuhaBUbscjGOWfzgbqSMyWLq2hYatbEVI5xB6yzEGNpP8bOatAf3XC38A8iPzUUf2YXQRmmQaRlYco/VwaAyfmVFXBaJiRGeS1FtXaOUzFg==
Received: from BN0PR04CA0039.namprd04.prod.outlook.com (2603:10b6:408:e8::14)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Tue, 20 Sep
 2022 13:02:19 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::34) by BN0PR04CA0039.outlook.office365.com
 (2603:10b6:408:e8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Tue, 20 Sep 2022 13:02:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 13:02:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 20 Sep
 2022 06:02:00 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 20 Sep
 2022 06:02:00 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Tue, 20 Sep
 2022 06:01:57 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Boris Pismenny" <borisp@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next v2 1/4] net/tls: Describe ciphers sizes by const structs
Date:   Tue, 20 Sep 2022 16:01:47 +0300
Message-ID: <20220920130150.3546-2-gal@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220920130150.3546-1-gal@nvidia.com>
References: <20220920130150.3546-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b2ffa0-efa7-427e-8280-08da9b08598e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJ0WVUxcxa36WfJaQjULym3u7kqXJYAGss3wF5IPIwFIsEhHRu08INPCXAVg6oYlVjcJebqbxT7G7a89J5BKG2iEfdLJS6zWGenwfI980hh4Fe1iNAZds8uNckqnHmSoxAgNUsyGrkrDA+loI/Qrr7r4MagyF3hPh1ajgemZnJ/9VISbDVAti7urbn52qfIQZmBFLh+sRnnQ8kST3feUbDBejZSiURDwbPFocOaztPg7jyHpBh0dKiehNRiDY+Cq0+qBqFX8F5eyodZoxawJuCTrGjr5SGSpvyZLYrBUvHkoVq7f9McfOunCWu6HfnyfyDcfUz6xoyqpYgg7V268D9IAFd9n0OQGj9W8eJ1vuQKT4d7OWkVbiZ0B07B0ojUiUQJYkMLN25ISBuoOqpw9ubSQp4Yl6hWgqR1kRa3mSqFopibr6iVQxX2hgvS5XYR1m2VucIDCjuPYERh2665utKc+TteTqbp4Cx3d1a1kKNHcz/pJ3WpH0InzXQNNVcRf4UE1HQpwKXn32RDgVkw0Okr/2CpW4R8wvcqqsiFQPWqebsFThlHoe3BAzRwkygfysVydHtFG4i7m77mHAtuZ8REpM2oI8KqKzVJ5RCt3UGzXI+cNQm5oLy3khFHS4a2L6c2TWrdLUPdm97hVO+Vcz7JjKC8B37lp3QIlxIUj1iNIgUGOyIGUwHS9RNt9aMKXEEXOrTHKp83cAp++yrQVF2ehCleOHc7Y/IZlUZuJy1Uk6goTnGFpajAke52GKnzF0OtQD4zf9OiQtDdN3N5YNg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(7636003)(2906002)(356005)(40460700003)(82740400003)(5660300002)(8936002)(478600001)(1076003)(2616005)(186003)(336012)(26005)(7696005)(41300700001)(426003)(107886003)(40480700001)(6666004)(82310400005)(47076005)(86362001)(4326008)(36756003)(70586007)(70206006)(8676002)(54906003)(110136005)(316002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 13:02:18.8870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b2ffa0-efa7-427e-8280-08da9b08598e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Introduce cipher sizes descriptor. It helps reducing the amount of code
duplications and repeated switch/cases that assigns the proper sizes
according to the cipher type.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 include/net/tls.h  | 10 ++++++++++
 net/tls/tls_main.c | 17 +++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index cb205f9d9473..154949c7b0c8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -51,6 +51,16 @@
 
 struct tls_rec;
 
+struct tls_cipher_size_desc {
+	unsigned int iv;
+	unsigned int key;
+	unsigned int salt;
+	unsigned int tag;
+	unsigned int rec_seq;
+};
+
+extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
+
 /* Maximum data size carried in a TLS record */
 #define TLS_MAX_PAYLOAD_SIZE		((size_t)1 << 14)
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 08ddf9d837ae..5cc6911cc97d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -58,6 +58,23 @@ enum {
 	TLS_NUM_PROTS,
 };
 
+#define CIPHER_SIZE_DESC(cipher) [cipher] = { \
+	.iv = cipher ## _IV_SIZE, \
+	.key = cipher ## _KEY_SIZE, \
+	.salt = cipher ## _SALT_SIZE, \
+	.tag = cipher ## _TAG_SIZE, \
+	.rec_seq = cipher ## _REC_SEQ_SIZE, \
+}
+
+const struct tls_cipher_size_desc tls_cipher_size_desc[] = {
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_128),
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_256),
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_CCM_128),
+	CIPHER_SIZE_DESC(TLS_CIPHER_CHACHA20_POLY1305),
+	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_GCM),
+	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_CCM),
+};
+
 static const struct proto *saved_tcpv6_prot;
 static DEFINE_MUTEX(tcpv6_prot_mutex);
 static const struct proto *saved_tcpv4_prot;
-- 
2.25.1

