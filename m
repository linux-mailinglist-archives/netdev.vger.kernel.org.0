Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B156D06C
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGJRWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGJRWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:39 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60113.outbound.protection.outlook.com [40.107.6.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E0DBF65;
        Sun, 10 Jul 2022 10:22:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQCydQnFfpMgDLT2KCu8ufEzXuloj0Z0CXf40wSoM0LylJrWk0lzXHp90u7PTG6RHxRcW3Ck9SY74MCRB5EeYC/+bSyDzPr8QmRq2PMvnm+6w4XIxK5YKwNFLbYR8O2w5oJe0tUWzOZRx0oFUR0tx56LseabPhzCVhKNDGYsjjlzWfp3xHDNi2E8KjhhQ+0e9TlltBFHI2NTWzPojwsX3akn/dUGneXP3pqwMcCeD0N6+TvKinDUWHG6M1gQD3CBq5/Jb0Jq1HfIUigPoCQbpvZQQleCSKYFywDOKkfi6kbFQWyNm/i6wmTlfUMINjaajziE1LzkYguaq2tL1mKPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9U94BRmxfoJhqoKO3bLyoh00WLNpZ3pLUKgqVdK3o8=;
 b=QKIoZQdImL86PSNWB466tGkk0/bdYLBGkrY4ck5u0ndM/Gppg1CpQ4DC/2Yv/+4JxaL2GimgXuxRvUWsBxLG4zJDLHLEm4/6Me35QFRX6u/ge07Ckgz9UBVkazkzEOIH6xUFZRoF5G/a0ObuLTEh76AhvaWMMlKfjjLWyTz5KaShyVaSnvWeYmxczL/JHfpJno18XydXWp0TP6I33jftJzwUO9SkpjIG0T7WbdIObiAWc61UrrlzMoLU9CDU7pEDXvYWya88Al0MWE/JbWrudT+aXmp6Ew5JLvEMM+M3VZF4dAGRfwNzZ/4mmwNGBgtGeAnd5e1rwMjGwOPYOjvp5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9U94BRmxfoJhqoKO3bLyoh00WLNpZ3pLUKgqVdK3o8=;
 b=omJQqry008L28fL1jcJx8eNP49q7Ox5JUajsWM65dIxX0vNysTyYnzT4kpaIrijsPkA/NbxWOuW2ozwYfnLDBRHPm6K5jfoS1LuGlqBBg/0QjFZsq7ro7unxvy1Kx/WeLnkYsEcu4TZ+harz885xuUrWbhXtQtcijpoOi7dGOyY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:33 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:33 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] net: marvell: prestera: Add router nexthops ABI
Date:   Sun, 10 Jul 2022 20:21:59 +0300
Message-Id: <20220710172208.29851-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0e4cc25-6100-44e3-a4ee-08da6298c66f
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJwXNBKhiB6Zb6n36Zaa10wKYQHULXUyiuu0Gow0p9aW3ao8VpQuAB5ifDCDJcrXNoJlV7duFvhKFN22FzomG9cHveNkDXd/ZIggPox8LHpb4UxDpfuSgiNwAYWp2kTf7he5VGRsnTyl4mxCfawW7y5oa8OwrXs7zRcSXHLZRp4Qm5lrdLkz+Y2XivsTRhLMlo4UfTkUq+CHtSxSplKahQAjw0Ik+BlsksvP97DN1bCF4Y44sy8ecrnmNeKNugOGOoELyz562Vqd/HQyVr8Fp1rqq7NK9cYEMBF8QfloN2guQccW30nlLG+jK6B3e5gi9j9qSZVxCUy3jsP4zV7eJHrcqkPM2sZe4Wf2QP+DIuYn1eTcxMvHDpBvwMFWwhszi9On+lnJCD1AiGRsD1/H9dOd5uhKBpLpIQH48Lr/efYoKLaFVY4mMV/6aGH3YIRWdFssBgjnVv90wdKJ7x3pspaAoOqr3FS076md7wBwWE1szKZ7/CoTNY6PAF8GxOIHpwve56HL/HYRKcMD95bixA2sIV+wlZtho+OAzQzxSeFqUP2kUd3Jyu74THgtyq+LFGBmKsHBMRTL0AZMe3QRU2666i8WVZbhYnwUqlgtjNQcM8iEOgL6QfSDSxlHpsDLB396C+PSrnxV8oyJriuVUb39RPHdpLwyUHzKoSD7bExDY/PXntck4J0AQgYvmkR6Jm0+MyidglJxB2Ia9R/sB+iO3S7nJxKA1qIATxtHAgB5elFp5hZEfHh6aDHGmMSafb9vyR2HJ8rKGej2ct9S+YWCGm9ZWOCya5o07o6t73KMHiCa3kzrQOkaszM/t3jw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(30864003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Uj8jhYx2g50p70jZ87qR6hBoisYKFOTlae3oJX+7UQ5hHd1ruaJG/1u8Nje?=
 =?us-ascii?Q?P4KJJa+HClL/NXBjrjWXqbqdmstCtOnmVufFdkEtbThHDZSUkvnYEyYiHpts?=
 =?us-ascii?Q?iXCypP1GSy22h8jSil76gS+xIPszoBCnz2VUBleX8SgMhhTSfebWRq9AArEo?=
 =?us-ascii?Q?ZqJum6Z1YCerTjGVvptUbB7xxNuXcPirC48pTQdMwdAmEjTxDHqufiAJLUTg?=
 =?us-ascii?Q?LZVUqJ3BMZAA86HZ9ay//MlJRMCrkRwSl7Vr6DyJYzUiKDQ9iwCZ/lXnugY2?=
 =?us-ascii?Q?KQF+xG4gBUV8oGtC7sPFdhNOG2/Sjht7Pavn3AGKU2A0P8KFHH3x83mDpd2m?=
 =?us-ascii?Q?yqYSPtgllF/8rMw96Tthz9ooVyBKasmF1P2tO8GgvBifHh2X/18a/c3fFmbM?=
 =?us-ascii?Q?5GkQbQ8rl8LKm6Q1DWkQMuPu3bp7P0voXuSTpBCu7Xnq9nYHARsPuiLrnxSY?=
 =?us-ascii?Q?IeXTWlH9C+vdihLOvNB/aTwZdAvHhi+6JtixDcvMvdBN5kHyUWfmAxqvbqN9?=
 =?us-ascii?Q?ZbSvEttWoU4EK4+hGhnjnoFNvuJfUN6PtVlnSAKr8R8cmhDRpraiO/z5BD6J?=
 =?us-ascii?Q?oHTeAmcj0TkAYq7tc9gStPNF2FpcGrMsRVEfohp0+7rtc9D41/CC2SOatIEo?=
 =?us-ascii?Q?2fzMvtenmXQcnLVifx/Ceyrr3dq62hw935LqxjuaT3Wx1uWiKMRXsk6QO4iQ?=
 =?us-ascii?Q?AbwbwFVv6HyUVFnz40dbQZBKmL/PNTP5BfTB+4fdfe+I76k+xsV5PbYcJ+DW?=
 =?us-ascii?Q?Mkfx82ueveN3o9PEvUtG40gtd5APSFGg9AGO36IY+7Oy69Rgy4L/yLUBGOoZ?=
 =?us-ascii?Q?Rfrlal943IRQvtqaLLVpFOjaAfVEQ7yhAu/MXh9QOnvTbLpvD6uLU/PRWUPG?=
 =?us-ascii?Q?RNznNlKxxOUjfFXYCCPl7HD5xoJjP2xhAW2ejq5RaEwO3IF0sOOatm21XXtq?=
 =?us-ascii?Q?hCypJjmE9y6OrZTe+K4LIodmU9GTHHBVQkdXJmniN5I15FUcDWGgJFnvAp8j?=
 =?us-ascii?Q?QnegPCpQ5h2d7u54K3jJuEWvLJqoApn0rYl5vC0hMLno9ifu0e/auAZeHnpm?=
 =?us-ascii?Q?VZh4daRVKgKke267nfpCxrM1vkvGgmGw2E4H03QFWlYvyU51y3KN0OsIKVSA?=
 =?us-ascii?Q?vs51Hdvs4C7U1B8LfP0vBPNIn0muOblQc6zDTOZKeI4mFLch9JCEvuHhQrhx?=
 =?us-ascii?Q?lQ/7ZhCMMfQXRJXWeBX+2yA1qkht+rGyj5LiNrFOpAQpQZU/qH26noXx1qa2?=
 =?us-ascii?Q?OkufZJFOF6Yo1tuJyXJmX0IWX42XlaWUBNuJdcGCBe6iPQR5SABiZznj25As?=
 =?us-ascii?Q?BGODelVQA4+0AqRDz9awtgmKIrUIU7ddUjrkkHT82XQNkfVedEfaA8ZyxCie?=
 =?us-ascii?Q?WRWlRL2qPH2AZFj8GJli/kzYjwzmx8u0tQygFonwOYHQSQ2cP2K4xphFE9k0?=
 =?us-ascii?Q?x+hpx/az95bmJfvtoA5C82ViZQ6r1JdljsVqW8xLhN4VApYL8DorDHqyhBZP?=
 =?us-ascii?Q?i7HxnlGfevsVafnEV3Gz+cv/JoROCBSNrZ7UqNKnUKFZkWuDHoz+CNf1Wl2g?=
 =?us-ascii?Q?PkmzLLmI+yOHGgIkM2Zfs4NmsCN8ZOvmXMOFnrxkvEGfDS1uy9jhypS9v8oY?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e4cc25-6100-44e3-a4ee-08da6298c66f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:33.1677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fUF/9KTf1sFLjrdh84AUOihTPfhz8XCk7K7rGDjGaFlotnmfb2MX1s50z9XL27PDyoZo9fu7Y2TmGk1RJYP3JOVQb+bWzvT8Fw2G59Mu1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add functions to allocate/delete/set nexthop group
  - NOTE: non-ECMP nexthop is nexthop group with allocated size = 1
- Add function to read state of HW nh (if packets going through it)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   5 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 130 +++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../marvell/prestera/prestera_router.c        |  14 +-
 .../marvell/prestera/prestera_router_hw.c     | 356 +++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.h     |  74 +++-
 6 files changed, 582 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 0bb46eee46b4..7edb51f1aa45 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -276,17 +276,22 @@ struct prestera_switch {
 	struct prestera_counter *counter;
 	u8 lag_member_max;
 	u8 lag_max;
+	u32 size_tbl_router_nexthop;
 };
 
 struct prestera_router {
 	struct prestera_switch *sw;
 	struct list_head vr_list;
 	struct list_head rif_entry_list;
+	struct rhashtable nh_neigh_ht;
+	struct rhashtable nexthop_group_ht;
 	struct rhashtable fib_ht;
 	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
+	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 79fd3cac539d..ace074da7e6d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -10,11 +10,14 @@
 #include "prestera_hw.h"
 #include "prestera_acl.h"
 #include "prestera_counter.h"
+#include "prestera_router_hw.h"
 
 #define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
 
 #define PRESTERA_MIN_MTU 64
 
+#define PRESTERA_MSG_CHUNK_SIZE 1024
+
 enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_SWITCH_INIT = 0x1,
 	PRESTERA_CMD_TYPE_SWITCH_ATTR_SET = 0x2,
@@ -57,6 +60,10 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE = 0x601,
 	PRESTERA_CMD_TYPE_ROUTER_LPM_ADD = 0x610,
 	PRESTERA_CMD_TYPE_ROUTER_LPM_DELETE = 0x611,
+	PRESTERA_CMD_TYPE_ROUTER_NH_GRP_SET = 0x622,
+	PRESTERA_CMD_TYPE_ROUTER_NH_GRP_BLK_GET = 0x645,
+	PRESTERA_CMD_TYPE_ROUTER_NH_GRP_ADD = 0x623,
+	PRESTERA_CMD_TYPE_ROUTER_NH_GRP_DELETE = 0x624,
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
@@ -524,6 +531,14 @@ struct prestera_msg_ip_addr {
 	u8 __pad[3];
 };
 
+struct prestera_msg_nh {
+	struct prestera_msg_iface oif;
+	__le32 hw_id;
+	u8 mac[ETH_ALEN];
+	u8 is_active;
+	u8 pad;
+};
+
 struct prestera_msg_rif_req {
 	struct prestera_msg_cmd cmd;
 	struct prestera_msg_iface iif;
@@ -549,6 +564,34 @@ struct prestera_msg_lpm_req {
 	u8 __pad[2];
 };
 
+struct prestera_msg_nh_req {
+	struct prestera_msg_cmd cmd;
+	struct prestera_msg_nh nh[PRESTERA_NHGR_SIZE_MAX];
+	__le32 size;
+	__le32 grp_id;
+};
+
+struct prestera_msg_nh_chunk_req {
+	struct prestera_msg_cmd cmd;
+	__le32 offset;
+};
+
+struct prestera_msg_nh_chunk_resp {
+	struct prestera_msg_ret ret;
+	u8 hw_state[PRESTERA_MSG_CHUNK_SIZE];
+};
+
+struct prestera_msg_nh_grp_req {
+	struct prestera_msg_cmd cmd;
+	__le32 grp_id;
+	__le32 size;
+};
+
+struct prestera_msg_nh_grp_resp {
+	struct prestera_msg_ret ret;
+	__le32 grp_id;
+};
+
 struct prestera_msg_vr_req {
 	struct prestera_msg_cmd cmd;
 	__le16 vr_id;
@@ -654,10 +697,14 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_req) != 36);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_req) != 124);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_chunk_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_grp_req) != 12);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh) != 28);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -673,6 +720,8 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_chunk_resp) != 1032);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_grp_resp) != 12);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -950,6 +999,8 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 	sw->id = resp.switch_id;
 	sw->lag_member_max = resp.lag_member_max;
 	sw->lag_max = resp.lag_max;
+	sw->size_tbl_router_nexthop =
+		__le32_to_cpu(resp.size_tbl_router_nexthop);
 
 	return 0;
 }
@@ -1982,6 +2033,85 @@ int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
 			    sizeof(req));
 }
 
+int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
+			       struct prestera_neigh_info *nhs, u32 grp_id)
+{
+	struct prestera_msg_nh_req req = { .size = __cpu_to_le32((u32)count),
+			.grp_id = __cpu_to_le32(grp_id) };
+	int i, err;
+
+	for (i = 0; i < count; i++) {
+		req.nh[i].is_active = nhs[i].connected;
+		memcpy(&req.nh[i].mac, nhs[i].ha, ETH_ALEN);
+		err = prestera_iface_to_msg(&nhs[i].iface, &req.nh[i].oif);
+		if (err)
+			return err;
+	}
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_NH_GRP_SET, &req.cmd,
+			    sizeof(req));
+}
+
+int prestera_hw_nhgrp_blk_get(struct prestera_switch *sw,
+			      u8 *hw_state, u32 buf_size /* Buffer in bytes */)
+{
+	struct prestera_msg_nh_chunk_req req;
+	static struct prestera_msg_nh_chunk_resp resp;
+	int err;
+	u32 buf_offset;
+
+	memset(&hw_state[0], 0, buf_size);
+	buf_offset = 0;
+	while (1) {
+		if (buf_offset >= buf_size)
+			break;
+
+		memset(&req, 0, sizeof(req));
+		req.offset = __cpu_to_le32(buf_offset * 8); /* 8 bits in u8 */
+		err = prestera_cmd_ret(sw,
+				       PRESTERA_CMD_TYPE_ROUTER_NH_GRP_BLK_GET,
+				       &req.cmd, sizeof(req), &resp.ret,
+				       sizeof(resp));
+		if (err)
+			return err;
+
+		memcpy(&hw_state[buf_offset], &resp.hw_state[0],
+		       buf_offset + PRESTERA_MSG_CHUNK_SIZE > buf_size ?
+			buf_size - buf_offset : PRESTERA_MSG_CHUNK_SIZE);
+		buf_offset += PRESTERA_MSG_CHUNK_SIZE;
+	}
+
+	return err;
+}
+
+int prestera_hw_nh_group_create(struct prestera_switch *sw, u16 nh_count,
+				u32 *grp_id)
+{
+	struct prestera_msg_nh_grp_req req = { .size = __cpu_to_le32((u32)nh_count) };
+	struct prestera_msg_nh_grp_resp resp;
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_NH_GRP_ADD,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*grp_id = __le32_to_cpu(resp.grp_id);
+	return err;
+}
+
+int prestera_hw_nh_group_delete(struct prestera_switch *sw, u16 nh_count,
+				u32 grp_id)
+{
+	struct prestera_msg_nh_grp_req req = {
+	    .grp_id = __cpu_to_le32(grp_id),
+	    .size = __cpu_to_le32(nh_count)
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_NH_GRP_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index aa74f668aa3c..963d95bd50b0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -144,6 +144,7 @@ struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
 struct prestera_iface;
+struct prestera_neigh_info;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -261,6 +262,16 @@ int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
 int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
 			__be32 dst, u32 dst_len);
 
+/* NH API */
+int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
+			       struct prestera_neigh_info *nhs, u32 grp_id);
+int prestera_hw_nhgrp_blk_get(struct prestera_switch *sw,
+			      u8 *hw_state, u32 buf_size /* Buffer in bytes */);
+int prestera_hw_nh_group_create(struct prestera_switch *sw, u16 nh_count,
+				u32 *grp_id);
+int prestera_hw_nh_group_delete(struct prestera_switch *sw, u16 nh_count,
+				u32 grp_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 3c8116f16b4d..e9b08b541aba 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -191,7 +191,7 @@ static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
 		return 0;
 
 	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
-					    fc->lpm_info.fib_type);
+					    fc->lpm_info.fib_type, NULL);
 
 	if (!fib_node) {
 		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
@@ -537,7 +537,7 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
-	int err;
+	int err, nhgrp_cache_bytes;
 
 	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
 	if (!router)
@@ -555,6 +555,13 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_kern_fib_cache_ht_init;
 
+	nhgrp_cache_bytes = sw->size_tbl_router_nexthop / 8 + 1;
+	router->nhgrp_hw_state_cache = kzalloc(nhgrp_cache_bytes, GFP_KERNEL);
+	if (!router->nhgrp_hw_state_cache) {
+		err = -ENOMEM;
+		goto err_nh_state_cache_alloc;
+	}
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -578,6 +585,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	kfree(router->nhgrp_hw_state_cache);
+err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_fib_cache_ht);
 err_kern_fib_cache_ht_init:
 	prestera_router_hw_fini(sw);
@@ -591,6 +600,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
 	kfree(sw->router);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 5b0cf3be9a9e..b5407bb88d51 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -8,10 +8,17 @@
 #include "prestera_router_hw.h"
 #include "prestera_acl.h"
 
-/*            +--+
- *   +------->|vr|<-+
- *   |        +--+  |
- *   |              |
+/*
+ *                                Nexthop is pointed
+ *                                to port (not rif)
+ *                                +-------+
+ *                              +>|nexthop|
+ *                              | +-------+
+ *                              |
+ *            +--+        +-----++
+ *   +------->|vr|<-+   +>|nh_grp|
+ *   |        +--+  |   | +------+
+ *   |              |   |
  * +-+-------+   +--+---+-+
  * |rif_entry|   |fib_node|
  * +---------+   +--------+
@@ -23,6 +30,8 @@
 
 #define PRESTERA_NHGR_UNUSED (0)
 #define PRESTERA_NHGR_DROP (0xFFFFFFFF)
+/* Need to merge it with router_manager */
+#define PRESTERA_NH_ACTIVE_JIFFER_FILTER 3000 /* ms */
 
 static const struct rhashtable_params __prestera_fib_ht_params = {
 	.key_offset  = offsetof(struct prestera_fib_node, key),
@@ -31,10 +40,44 @@ static const struct rhashtable_params __prestera_fib_ht_params = {
 	.automatic_shrinking = true,
 };
 
+static const struct rhashtable_params __prestera_nh_neigh_ht_params = {
+	.key_offset  = offsetof(struct prestera_nh_neigh, key),
+	.key_len     = sizeof(struct prestera_nh_neigh_key),
+	.head_offset = offsetof(struct prestera_nh_neigh, ht_node),
+};
+
+static const struct rhashtable_params __prestera_nexthop_group_ht_params = {
+	.key_offset  = offsetof(struct prestera_nexthop_group, key),
+	.key_len     = sizeof(struct prestera_nexthop_group_key),
+	.head_offset = offsetof(struct prestera_nexthop_group, ht_node),
+};
+
+static int prestera_nexthop_group_set(struct prestera_switch *sw,
+				      struct prestera_nexthop_group *nh_grp);
+static bool
+prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
+				     struct prestera_nexthop_group *nh_grp);
+
+/* TODO: move to router.h as macros */
+static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
+{
+	return memchr_inv(key, 0, sizeof(*key)) ? true : false;
+}
+
 int prestera_router_hw_init(struct prestera_switch *sw)
 {
 	int err;
 
+	err = rhashtable_init(&sw->router->nh_neigh_ht,
+			      &__prestera_nh_neigh_ht_params);
+	if (err)
+		goto err_nh_neigh_ht_init;
+
+	err = rhashtable_init(&sw->router->nexthop_group_ht,
+			      &__prestera_nexthop_group_ht_params);
+	if (err)
+		goto err_nexthop_grp_ht_init;
+
 	err = rhashtable_init(&sw->router->fib_ht,
 			      &__prestera_fib_ht_params);
 	if (err)
@@ -43,7 +86,13 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 	INIT_LIST_HEAD(&sw->router->vr_list);
 	INIT_LIST_HEAD(&sw->router->rif_entry_list);
 
+	return 0;
+
 err_fib_ht_init:
+	rhashtable_destroy(&sw->router->nexthop_group_ht);
+err_nexthop_grp_ht_init:
+	rhashtable_destroy(&sw->router->nh_neigh_ht);
+err_nh_neigh_ht_init:
 	return 0;
 }
 
@@ -52,6 +101,8 @@ void prestera_router_hw_fini(struct prestera_switch *sw)
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
+	rhashtable_destroy(&sw->router->nexthop_group_ht);
+	rhashtable_destroy(&sw->router->nh_neigh_ht);
 }
 
 static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
@@ -232,6 +283,286 @@ prestera_rif_entry_create(struct prestera_switch *sw,
 	return NULL;
 }
 
+static void __prestera_nh_neigh_destroy(struct prestera_switch *sw,
+					struct prestera_nh_neigh *neigh)
+{
+	rhashtable_remove_fast(&sw->router->nh_neigh_ht,
+			       &neigh->ht_node,
+			       __prestera_nh_neigh_ht_params);
+	kfree(neigh);
+}
+
+static struct prestera_nh_neigh *
+__prestera_nh_neigh_create(struct prestera_switch *sw,
+			   struct prestera_nh_neigh_key *key)
+{
+	struct prestera_nh_neigh *neigh;
+	int err;
+
+	neigh = kzalloc(sizeof(*neigh), GFP_KERNEL);
+	if (!neigh)
+		goto err_kzalloc;
+
+	memcpy(&neigh->key, key, sizeof(*key));
+	neigh->info.connected = false;
+	INIT_LIST_HEAD(&neigh->nexthop_group_list);
+	err = rhashtable_insert_fast(&sw->router->nh_neigh_ht,
+				     &neigh->ht_node,
+				     __prestera_nh_neigh_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	return neigh;
+
+err_rhashtable_insert:
+	kfree(neigh);
+err_kzalloc:
+	return NULL;
+}
+
+struct prestera_nh_neigh *
+prestera_nh_neigh_find(struct prestera_switch *sw,
+		       struct prestera_nh_neigh_key *key)
+{
+	struct prestera_nh_neigh *nh_neigh;
+
+	nh_neigh = rhashtable_lookup_fast(&sw->router->nh_neigh_ht,
+					  key, __prestera_nh_neigh_ht_params);
+	return IS_ERR(nh_neigh) ? NULL : nh_neigh;
+}
+
+struct prestera_nh_neigh *
+prestera_nh_neigh_get(struct prestera_switch *sw,
+		      struct prestera_nh_neigh_key *key)
+{
+	struct prestera_nh_neigh *neigh;
+
+	neigh = prestera_nh_neigh_find(sw, key);
+	if (!neigh)
+		return __prestera_nh_neigh_create(sw, key);
+
+	return neigh;
+}
+
+void prestera_nh_neigh_put(struct prestera_switch *sw,
+			   struct prestera_nh_neigh *neigh)
+{
+	if (list_empty(&neigh->nexthop_group_list))
+		__prestera_nh_neigh_destroy(sw, neigh);
+}
+
+/* Updates new prestera_neigh_info */
+int prestera_nh_neigh_set(struct prestera_switch *sw,
+			  struct prestera_nh_neigh *neigh)
+{
+	struct prestera_nh_neigh_head *nh_head;
+	struct prestera_nexthop_group *nh_grp;
+	int err;
+
+	list_for_each_entry(nh_head, &neigh->nexthop_group_list, head) {
+		nh_grp = nh_head->this;
+		err = prestera_nexthop_group_set(sw, nh_grp);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+bool prestera_nh_neigh_util_hw_state(struct prestera_switch *sw,
+				     struct prestera_nh_neigh *nh_neigh)
+{
+	bool state;
+	struct prestera_nh_neigh_head *nh_head, *tmp;
+
+	state = false;
+	list_for_each_entry_safe(nh_head, tmp,
+				 &nh_neigh->nexthop_group_list, head) {
+		state = prestera_nexthop_group_util_hw_state(sw, nh_head->this);
+		if (state)
+			goto out;
+	}
+
+out:
+	return state;
+}
+
+static struct prestera_nexthop_group *
+__prestera_nexthop_group_create(struct prestera_switch *sw,
+				struct prestera_nexthop_group_key *key)
+{
+	struct prestera_nexthop_group *nh_grp;
+	struct prestera_nh_neigh *nh_neigh;
+	int nh_cnt, err, gid;
+
+	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
+	if (!nh_grp)
+		goto err_kzalloc;
+
+	memcpy(&nh_grp->key, key, sizeof(*key));
+	for (nh_cnt = 0; nh_cnt < PRESTERA_NHGR_SIZE_MAX; nh_cnt++) {
+		if (!prestera_nh_neigh_key_is_valid(&nh_grp->key.neigh[nh_cnt]))
+			break;
+
+		nh_neigh = prestera_nh_neigh_get(sw,
+						 &nh_grp->key.neigh[nh_cnt]);
+		if (!nh_neigh)
+			goto err_nh_neigh_get;
+
+		nh_grp->nh_neigh_head[nh_cnt].neigh = nh_neigh;
+		nh_grp->nh_neigh_head[nh_cnt].this = nh_grp;
+		list_add(&nh_grp->nh_neigh_head[nh_cnt].head,
+			 &nh_neigh->nexthop_group_list);
+	}
+
+	err = prestera_hw_nh_group_create(sw, nh_cnt, &nh_grp->grp_id);
+	if (err)
+		goto err_nh_group_create;
+
+	err = prestera_nexthop_group_set(sw, nh_grp);
+	if (err)
+		goto err_nexthop_group_set;
+
+	err = rhashtable_insert_fast(&sw->router->nexthop_group_ht,
+				     &nh_grp->ht_node,
+				     __prestera_nexthop_group_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	/* reset cache for created group */
+	gid = nh_grp->grp_id;
+	sw->router->nhgrp_hw_state_cache[gid / 8] &= ~BIT(gid % 8);
+
+	return nh_grp;
+
+err_ht_insert:
+err_nexthop_group_set:
+	prestera_hw_nh_group_delete(sw, nh_cnt, nh_grp->grp_id);
+err_nh_group_create:
+err_nh_neigh_get:
+	for (nh_cnt--; nh_cnt >= 0; nh_cnt--) {
+		list_del(&nh_grp->nh_neigh_head[nh_cnt].head);
+		prestera_nh_neigh_put(sw, nh_grp->nh_neigh_head[nh_cnt].neigh);
+	}
+
+	kfree(nh_grp);
+err_kzalloc:
+	return NULL;
+}
+
+static void
+__prestera_nexthop_group_destroy(struct prestera_switch *sw,
+				 struct prestera_nexthop_group *nh_grp)
+{
+	struct prestera_nh_neigh *nh_neigh;
+	int nh_cnt;
+
+	rhashtable_remove_fast(&sw->router->nexthop_group_ht,
+			       &nh_grp->ht_node,
+			       __prestera_nexthop_group_ht_params);
+
+	for (nh_cnt = 0; nh_cnt < PRESTERA_NHGR_SIZE_MAX; nh_cnt++) {
+		nh_neigh = nh_grp->nh_neigh_head[nh_cnt].neigh;
+		if (!nh_neigh)
+			break;
+
+		list_del(&nh_grp->nh_neigh_head[nh_cnt].head);
+		prestera_nh_neigh_put(sw, nh_neigh);
+	}
+
+	prestera_hw_nh_group_delete(sw, nh_cnt, nh_grp->grp_id);
+	kfree(nh_grp);
+}
+
+static struct prestera_nexthop_group *
+__prestera_nexthop_group_find(struct prestera_switch *sw,
+			      struct prestera_nexthop_group_key *key)
+{
+	struct prestera_nexthop_group *nh_grp;
+
+	nh_grp = rhashtable_lookup_fast(&sw->router->nexthop_group_ht,
+					key, __prestera_nexthop_group_ht_params);
+	return IS_ERR(nh_grp) ? NULL : nh_grp;
+}
+
+static struct prestera_nexthop_group *
+prestera_nexthop_group_get(struct prestera_switch *sw,
+			   struct prestera_nexthop_group_key *key)
+{
+	struct prestera_nexthop_group *nh_grp;
+
+	nh_grp = __prestera_nexthop_group_find(sw, key);
+	if (nh_grp) {
+		refcount_inc(&nh_grp->refcount);
+	} else {
+		nh_grp = __prestera_nexthop_group_create(sw, key);
+		if (IS_ERR(nh_grp))
+			return ERR_CAST(nh_grp);
+
+		refcount_set(&nh_grp->refcount, 1);
+	}
+
+	return nh_grp;
+}
+
+static void prestera_nexthop_group_put(struct prestera_switch *sw,
+				       struct prestera_nexthop_group *nh_grp)
+{
+	if (refcount_dec_and_test(&nh_grp->refcount))
+		__prestera_nexthop_group_destroy(sw, nh_grp);
+}
+
+/* Updates with new nh_neigh's info */
+static int prestera_nexthop_group_set(struct prestera_switch *sw,
+				      struct prestera_nexthop_group *nh_grp)
+{
+	struct prestera_neigh_info info[PRESTERA_NHGR_SIZE_MAX];
+	struct prestera_nh_neigh *neigh;
+	int nh_cnt;
+
+	memset(&info[0], 0, sizeof(info));
+	for (nh_cnt = 0; nh_cnt < PRESTERA_NHGR_SIZE_MAX; nh_cnt++) {
+		neigh = nh_grp->nh_neigh_head[nh_cnt].neigh;
+		if (!neigh)
+			break;
+
+		memcpy(&info[nh_cnt], &neigh->info, sizeof(neigh->info));
+	}
+
+	return prestera_hw_nh_entries_set(sw, nh_cnt, &info[0], nh_grp->grp_id);
+}
+
+static bool
+prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
+				     struct prestera_nexthop_group *nh_grp)
+{
+	int err;
+	u32 buf_size = sw->size_tbl_router_nexthop / 8 + 1;
+	u32 gid = nh_grp->grp_id;
+	u8 *cache = sw->router->nhgrp_hw_state_cache;
+
+	/* Antijitter
+	 * Prevent situation, when we read state of nh_grp twice in short time,
+	 * and state bit is still cleared on second call. So just stuck active
+	 * state for PRESTERA_NH_ACTIVE_JIFFER_FILTER, after last occurred.
+	 */
+	if (!time_before(jiffies, sw->router->nhgrp_hw_cache_kick +
+			msecs_to_jiffies(PRESTERA_NH_ACTIVE_JIFFER_FILTER))) {
+		err = prestera_hw_nhgrp_blk_get(sw, cache, buf_size);
+		if (err) {
+			pr_err("Failed to get hw state nh_grp's");
+			return false;
+		}
+
+		sw->router->nhgrp_hw_cache_kick = jiffies;
+	}
+
+	if (cache[gid / 8] & BIT(gid % 8))
+		return true;
+
+	return false;
+}
+
 struct prestera_fib_node *
 prestera_fib_node_find(struct prestera_switch *sw, struct prestera_fib_key *key)
 {
@@ -251,6 +582,9 @@ static void __prestera_fib_node_destruct(struct prestera_switch *sw,
 	prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
 			    fib_node->key.prefix_len);
 	switch (fib_node->info.type) {
+	case PRESTERA_FIB_TYPE_UC_NH:
+		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
+		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		break;
 	case PRESTERA_FIB_TYPE_DROP:
@@ -275,7 +609,8 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-			 enum prestera_fib_type fib_type)
+			 enum prestera_fib_type fib_type,
+			 struct prestera_nexthop_group_key *nh_grp_key)
 {
 	struct prestera_fib_node *fib_node;
 	u32 grp_id;
@@ -302,6 +637,14 @@ prestera_fib_node_create(struct prestera_switch *sw,
 	case PRESTERA_FIB_TYPE_DROP:
 		grp_id = PRESTERA_NHGR_DROP;
 		break;
+	case PRESTERA_FIB_TYPE_UC_NH:
+		fib_node->info.nh_grp = prestera_nexthop_group_get(sw,
+								   nh_grp_key);
+		if (!fib_node->info.nh_grp)
+			goto err_nh_grp_get;
+
+		grp_id = fib_node->info.nh_grp->grp_id;
+		break;
 	default:
 		pr_err("Unsupported fib_type %d", fib_type);
 		goto err_nh_grp_get;
@@ -323,6 +666,9 @@ prestera_fib_node_create(struct prestera_switch *sw,
 	prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
 			    key->prefix_len);
 err_lpm_add:
+	if (fib_type == PRESTERA_FIB_TYPE_UC_NH) {
+		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
+	}
 err_nh_grp_get:
 	prestera_vr_put(sw, vr);
 err_vr_get:
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 67dbb49c8bd4..43bad23f38ec 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -33,6 +33,61 @@ struct prestera_ip_addr {
 	} v;
 };
 
+struct prestera_nh_neigh_key {
+	struct prestera_ip_addr addr;
+	/* Seems like rif is obsolete, because there is iface in info ?
+	 * Key can contain functional fields, or fields, which is used to
+	 * filter duplicate objects on logical level (before you pass it to
+	 * HW)... also key can be used to cover hardware restrictions.
+	 * In our case rif - is logical interface (even can be VLAN), which
+	 * is used in combination with IP address (which is also not related to
+	 * hardware nexthop) to provide logical compression of created nexthops.
+	 * You even can imagine, that rif+IPaddr is just cookie.
+	 */
+	/* struct prestera_rif *rif; */
+	/* Use just as cookie, to divide ARP domains (in order with addr) */
+	void *rif;
+};
+
+/* Used for hw call */
+struct prestera_neigh_info {
+	struct prestera_iface iface;
+	unsigned char ha[ETH_ALEN];
+	u8 connected; /* bool. indicate, if mac/oif valid */
+	u8 __pad[1];
+};
+
+/* Used to notify nh about neigh change */
+struct prestera_nh_neigh {
+	struct prestera_nh_neigh_key key;
+	struct prestera_neigh_info info;
+	struct rhash_head ht_node; /* node of prestera_vr */
+	struct list_head nexthop_group_list;
+};
+
+#define PRESTERA_NHGR_SIZE_MAX 4
+
+struct prestera_nexthop_group {
+	struct prestera_nexthop_group_key {
+		struct prestera_nh_neigh_key neigh[PRESTERA_NHGR_SIZE_MAX];
+	} key;
+	/* Store intermediate object here.
+	 * This prevent overhead kzalloc call.
+	 */
+	/* nh_neigh is used only to notify nexthop_group */
+	struct prestera_nh_neigh_head {
+		struct prestera_nexthop_group *this;
+		struct list_head head;
+		/* ptr to neigh is not necessary.
+		 * It used to prevent lookup of nh_neigh by key (n) on destroy
+		 */
+		struct prestera_nh_neigh *neigh;
+	} nh_neigh_head[PRESTERA_NHGR_SIZE_MAX];
+	struct rhash_head ht_node; /* node of prestera_vr */
+	refcount_t refcount;
+	u32 grp_id; /* hw */
+};
+
 struct prestera_fib_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -44,12 +99,16 @@ struct prestera_fib_info {
 	struct list_head vr_node;
 	enum prestera_fib_type {
 		PRESTERA_FIB_TYPE_INVALID = 0,
+		/* must be pointer to nh_grp id */
+		PRESTERA_FIB_TYPE_UC_NH,
 		/* It can be connected route
 		 * and will be overlapped with neighbours
 		 */
 		PRESTERA_FIB_TYPE_TRAP,
 		PRESTERA_FIB_TYPE_DROP
 	} type;
+	/* Valid only if type = UC_NH*/
+	struct prestera_nexthop_group *nh_grp;
 };
 
 struct prestera_fib_node {
@@ -67,6 +126,18 @@ struct prestera_rif_entry *
 prestera_rif_entry_create(struct prestera_switch *sw,
 			  struct prestera_rif_entry_key *k,
 			  u32 tb_id, const unsigned char *addr);
+struct prestera_nh_neigh *
+prestera_nh_neigh_find(struct prestera_switch *sw,
+		       struct prestera_nh_neigh_key *key);
+struct prestera_nh_neigh *
+prestera_nh_neigh_get(struct prestera_switch *sw,
+		      struct prestera_nh_neigh_key *key);
+void prestera_nh_neigh_put(struct prestera_switch *sw,
+			   struct prestera_nh_neigh *neigh);
+int prestera_nh_neigh_set(struct prestera_switch *sw,
+			  struct prestera_nh_neigh *neigh);
+bool prestera_nh_neigh_util_hw_state(struct prestera_switch *sw,
+				     struct prestera_nh_neigh *nh_neigh);
 struct prestera_fib_node *prestera_fib_node_find(struct prestera_switch *sw,
 						 struct prestera_fib_key *key);
 void prestera_fib_node_destroy(struct prestera_switch *sw,
@@ -74,7 +145,8 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-			 enum prestera_fib_type fib_type);
+			 enum prestera_fib_type fib_type,
+			 struct prestera_nexthop_group_key *nh_grp_key);
 int prestera_router_hw_init(struct prestera_switch *sw);
 void prestera_router_hw_fini(struct prestera_switch *sw);
 
-- 
2.17.1

