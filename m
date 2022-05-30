Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAA7538490
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiE3PQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbiE3PQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:16:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BCD1B9FB5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 07:15:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPXD0cMJRdKKYOlz18b7Pmpe/FHh6ON7mCg2KTi9R3F7pVHmK8TQnmSefvPS04HPOdhYlnEO2yvPksmRqsq+2ntQqJ1WJukrTqnr7d8fIDgMp10uqeZLc4pfxmgQK0f3N0uMjVT1fjSaeYvyvexBxNOI1ns1RRi682jCH4KSrf4NhdKISrtpylDlj7eV4Pq1btajTK8x2ejEHPnyKsRnO5Hcy181XVptWeQ08lhpCqNndhheNu2+MROx3TmJdGXT/0/4+ub20GQ1aY9sEDHXXuoc1fRs8SJ0I1i4y2IBDB7XFnrhs7v0kuz7JngZsg1VpZPamMIkgONM9bj+9JvZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQO3iu6Dd9sc1GWcyHs3bayUu0zf5be1wWdE6mJ2Fus=;
 b=LcGzurQnTdxTWoPkVtoX2FihUceFaxCLr9aHzeV8s6FaPXCvh1+CqE4zuqekAYuwxxRzMrmvePL2zKwW4oh6jhUwkKsjgJecMde1FclpR3R18M9zigBxcGf4RTGRAqtmTuLt++fHvEbgT3jYEI4fGUOA+TCAywCqU2la/zG9MLbqFDZ5Y32JG7zIi4E2u4D2LBZNOe/wJah+F8BiNCruKqXSAPeHSu9RrEH7Wp0Lhis/bguZgiAzSR5ZR4/zE7D02rC1CJU7tRGtHW/s0+ZtRafqa4oQo60HQxNPNozGJ7uDB/Ma1aNcIgv+CkqcadmETN9e6HvjEbsIR3Ge4JcaDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQO3iu6Dd9sc1GWcyHs3bayUu0zf5be1wWdE6mJ2Fus=;
 b=GY6kGEwM7R2x0LkfTghK9d5rSCWz9EUAEI07sJF/WWjpofZHreWT3zNYnZlGppqa7jkK2ttxvKbCisBs2atYjOGpXPavjkhmMlLGmoPdYtwAvOxmQcF80m8gzUEUHAWv4Tlm9nf5E4y5JZ21JOr+YJ6aidv9q05IYRewPqEEHDyE0NRhq3USBp+0yKuZetG2nUVSgNRnj1KvUaysOXBpJgerG9+8reTTGtmu8TdLtwd043wDC2Dn4wLbgDuGFxe1V2a3Y/Bg6Do8R2Cv0OLX4OWd+f/jH2vIgtmShsen/m3swLReQHBQVrAF6LkgTPWWNZqG7BAjh1Bd0rl1rDZ7dw==
Received: from DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) by
 DM6PR12MB3372.namprd12.prod.outlook.com (2603:10b6:5:11b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.13; Mon, 30 May 2022 14:15:08 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::e3) by DM5PR05CA0010.outlook.office365.com
 (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.11 via Frontend
 Transport; Mon, 30 May 2022 14:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5293.13 via Frontend Transport; Mon, 30 May 2022 14:15:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 30 May
 2022 14:15:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 30 May
 2022 07:15:07 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 30 May
 2022 07:15:05 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS sockets
Date:   Mon, 30 May 2022 17:14:38 +0300
Message-ID: <20220530141438.2245089-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fce3a89-85f9-4efa-fb41-08da4246cd52
X-MS-TrafficTypeDiagnostic: DM6PR12MB3372:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3372FD6D7AAC0FCA3D93376DDCDD9@DM6PR12MB3372.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oVta8sWZYtZ7/ITUuuXpGBDE7h3TNE7lkTHIaR6kTR6eXdJnpvB5aG/j6Idy3Q5IkCU0UgVL29kSo16Uh2kGuaAYWW77WjJFhCDFKHl6Qnb3kS3F3Y5BxhgT6JAFm2Rcr5LFTBDatXnjx6bEzFzu1e9KL8CvIZvT2JHzkj814n6xUVkAxvKobHQ98VikBYuUb1ofebtTFvVJRcJAO5Jj69JLL23IIuzrbeEL1Pio1GqwpRDtu17VPBsM7AR1maQ/tk6D5rFdzNBpeZ+jRZMrKzvywsZShXAYcQBFds/BbUb2TmUda8CcL5XEVBsNjL6iGEPgGlodonKdlX27ZkXLcFkx0zCT8b6ZP5Ix9JVP8htSsK+EYvgxRHvULef9Sh7XbbBEl6BUGVbQSX39oiyVFP2PpgTuZrzwd6J2EVRqcBav2OtPqxwB6YVMuc43XSV5BRTVXO5i6ZTKiWVfMvVZfFsUdl7lrckBiMUTBwaZs5gbh4Pgmhfy7ySohDMElsAEnzAFFlPBYd7jHozAqWPE7CDJWdWFyJ8asGfDYgwR02XdUD+LuSbNlRl7/C3GFsF8GYSI2F8uvuKSQZwHzOtfffa7Af+RWWQb3T3TKCaMX/tJidbfLHqP7nexePI1rgMAyKTa6ZyOUBay1DvG09JjlbADVyLjdIhZNeVzDlLpb1LTQS9wA/sdmqN81u7/amAloCj5jS2At4p7VCGB42VwQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(86362001)(316002)(186003)(356005)(81166007)(7696005)(26005)(54906003)(508600001)(47076005)(8936002)(336012)(82310400005)(40460700003)(426003)(110136005)(2616005)(36860700001)(4326008)(8676002)(36756003)(2906002)(70206006)(5660300002)(83380400001)(6666004)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 14:15:08.5164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fce3a89-85f9-4efa-fb41-08da4246cd52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3372
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the activation status of zerocopy sendfile on TLS sockets.
Zerocopy sendfile was recently added to Linux and exposed via sock_diag.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/tls.h | 2 ++
 misc/ss.c                | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 3ad54af2..83a3cea4 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,6 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
+#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
@@ -160,6 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
+	TLS_INFO_ZC_SENDFILE,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/misc/ss.c b/misc/ss.c
index 4b3ca9c4..57677cf2 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2952,6 +2952,11 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 	}
 }
 
+static void tcp_tls_zc_sendfile(struct rtattr *attr)
+{
+	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
+}
+
 static void mptcp_subflow_info(struct rtattr *tb[])
 {
 	u_int32_t flags = 0;
@@ -3182,6 +3187,7 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 			tcp_tls_cipher(tlsinfo[TLS_INFO_CIPHER]);
 			tcp_tls_conf("rxconf", tlsinfo[TLS_INFO_RXCONF]);
 			tcp_tls_conf("txconf", tlsinfo[TLS_INFO_TXCONF]);
+			tcp_tls_zc_sendfile(tlsinfo[TLS_INFO_ZC_SENDFILE]);
 		}
 		if (ulpinfo[INET_ULP_INFO_MPTCP]) {
 			struct rtattr *sfinfo[MPTCP_SUBFLOW_ATTR_MAX + 1] =
-- 
2.25.1

