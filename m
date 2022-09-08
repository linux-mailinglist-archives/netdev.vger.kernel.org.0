Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586545B299F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiIHWxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIHWxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:40 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2121.outbound.protection.outlook.com [40.107.20.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC12612BFA6;
        Thu,  8 Sep 2022 15:53:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHCvE5IclU22cieBoOfBHv8IQpX7IPMinzb0RI/DlWm6jdOn3DbaZcJuyb1rsz7uRZVEug6tksQIr9MKno2OCtmZexZ3iP56R5TTNUk2mAfFbMyjBvSa37VByQj7ip6EGvl/kKP28XL8VF1AclENHi+L3cSfgz06V5n+cccIvEby66YFKkAzgsqSoqOqkcWWfast0GMNrJmDbaKjuHOU3nCIi1x6KcuJQnTJQFBK6ZwU6AmsjTOo5zl0CX6YMHlGc5Z4mCV0XqC2gHfGH0YZRD8ZANqEfTIobUB+xD4djfju4037gkKMYGIX0JT3LG46uF8wvfSv5L1bOO8T8Lu0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXLxZ1l/nXKY3g4ZvllgwiLEtUqtQ9wvfzMVgxJpM7A=;
 b=QeyGEBlqqvHUiln5VkGVQT3YG2UH8sCFTQR++xvPE9GrbXZ211BDkgRWjOsu/voPdj7wE0SxM/abeWIQ+qvSTc3dUtGAYeQBm0BvQW8HsikmFI+CVGYr00pFB5YwFucOGhrXlatCV5kU8dhygbHuUy+N1DrsQNwU5CM+BR4tGmp/xcMSoxa/MfvplEJfDBaXSrUoJ7uHiIeUsyogzMd0vFnARj3dBBkUZnG1AGcK9/LrdGKeBrHLz13L9u+0J8CbUeOfnuuuIuRvF7zjFZHykB/Xu8sxsWwzPA1bWRBL4KRkitNH3Ix+uEHWjUoIPPOEspobqSpyR9az/PmLwRDnGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXLxZ1l/nXKY3g4ZvllgwiLEtUqtQ9wvfzMVgxJpM7A=;
 b=iNmsmJVb/MkbKXmUY2BTvU0ujaCzm0o3W0/kp43P7JywfGWDQyIT9evw1XYNTOgc+aemxASAkrz12wojzZs6ZSrBlbNRs5gxDfvPzu8SgguzKLwguXC6L/2nVGHajnPezo4K7FRS1R2XrGil233sAVjp18qF+ptJPHkSnIoK0T8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:31 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v5 1/9] net: marvell: prestera: Add router nexthops ABI
Date:   Fri,  9 Sep 2022 01:52:03 +0300
Message-Id: <20220908225211.31482-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75e59fd2-9403-4da7-61ca-08da91ecf39e
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HzQF0+6K/3lB3NBMpqwPvulYRT7cRiyI0aDWHfFeH6xvuA/yeBuyUY3v496nR7BMuE5XfPWG2XDbIAKip0YwYfuhL3G4B8pozbBFMHyV9ERUiiQDTk5Y9QajS5lvgIWl1UxEGJJIEVKkXRu8DRwMGgRqKySTN4rwIhQgRdBTyvWVJoSUnsnlDEUswoPqcU3XbZ6U14rcpbY8J9EkhJ6MjuNDI3o7tQsp/L8mfZ4GR0xEbVVD1RXub4KVyXTzGCmBYFgmvIa71vKTIbV+IfZRZBwAtrbFUxoTYfaiidars24bou9Zpe8u9cScNrSnkcZTAycZF9sX/1JCqtqVVyfZevZaT/s9hQFzDyXYh3HiGxYnTPLf/Jm7w9TCDUbfl0z6zSuxaEtU2WFBb1n1eLBzryLyqC0PqiANcRKfJ1LZfWqKBqhCep9EvEgJ7wDSEU9y+2bcV0HFdNwdUU+ZNhBbyPnruBSZAqIiKbW1Ub1q8bgYhtv3rL4fVbvhvwxsl0+p4i8Wp/i31etLaPKoU3x7+ZcRVDIDst2wHVYZcZfTz5oSQIqMVYebf7xuWURZfoGIC9OvN+Dl5X6kYWknsCSLezHFTQDXXsWzxsbttzrTQzyZzlB7rLsDnyGo7Zby81pO9vHkDhZNZSaPxNf3Eum4EWmAL4NGYZbN0s9ZhqjPMOD0pake+FT4arHdlE1xRaYcB2VEfecmJCPW6a7lsf8weyIRiu/HcUZTaZcNNwbBTsClDgu/YXJDASgcv551JKy0yr9Wi07D6xihEIFFJbpqJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(30864003)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wz8xgo9TarGVIM2oUKz4Q5xvsCmzpOYTqUhxUskSXwuyt9i4DT7qgHFQQRV0?=
 =?us-ascii?Q?MP2ljU98/zWAyekiY7nP5HTTDjZB5de/Cpp6XIWZd7Vu8se3w1bIKlo7mPTo?=
 =?us-ascii?Q?Kov/o3m5vIMw3oSfm2eHwPYkCnNBR57K+b/bcYoPEwvXhMHwtN+PKEKMOe3O?=
 =?us-ascii?Q?/gzJIyorrWOfbq2wCWf4DUxUOHynnEw0QaWESKTX+pNpb9+5LjAof6tklpg1?=
 =?us-ascii?Q?jmElg+RbCM4dTX3GPlir0P2zckCSJ92KwYLUZMAYM7hXC1T9Vlj/xBlhoxgw?=
 =?us-ascii?Q?zuEAfNwyoOBYlRNGBXYKAJy/8E58hQ3PnfjW/PeHlNfktFtsm9lyatsjtjFn?=
 =?us-ascii?Q?a4yp2huo9dUGQ66+euHHyb5cZpCl5cK/CE7t98fbQEDc9h7I4mCL89N1/XtW?=
 =?us-ascii?Q?rJWIrS3HepUKV+6QAXrSygebWzAuOCarYncyEmzgwuIzXZOSOVwyErlzTtnA?=
 =?us-ascii?Q?gUaizk6ZAk5FfotEbPYSGeCqgiF7YjT/08Kfj+fh4KdLl1Ho/bmhFLxWZjt9?=
 =?us-ascii?Q?5HlD/a4G1+rUnokEneuDBHVRl7SZ72vu3PGrLGYjeFy9CqTrKDY+6dIrsn8l?=
 =?us-ascii?Q?nh3HcBR3okt7vNz1OjavynFpmoHHhiyS2RYMRmvD/9f5M5pJwCBAW2MwO28Q?=
 =?us-ascii?Q?+I4aLsvcEHCH/xMZpaE5mJ4Pc/dbStIebVoGlHdvKZfm8ElnpdEVXtmCfN/4?=
 =?us-ascii?Q?2cjZFwC6Tktf3eAlCc0tQKVFpFSwlX80qjiFIZH6hXNKF4ywQK6Xjx7jJIAV?=
 =?us-ascii?Q?vJiTugD1p6VICu08QoEfSRk0jfwx+C3Ly2bENIzCtmPn2Y7iroJMXx9ZfNwe?=
 =?us-ascii?Q?OEipeCnZjEvhpb56EMlKaQioIR8WIORuuvHNzSBj0m6a/SuP2+S608nHEhrZ?=
 =?us-ascii?Q?+gFzTpLlr1bc31bN49TJxLconSKRf60cgPyBIFFYzqSLKLA6cmzGdxi4uKWf?=
 =?us-ascii?Q?3ha0KIfF9mZ34M80+0tjorIpcNxIHruXe/IkhEraEt+pcIQlpnhYiMXtobuu?=
 =?us-ascii?Q?w3lX32uCGQE4G30XWauwJ2e3Oxa6wn8QrWj+r3H1gUcKh2i/qCgVBSIbWDUT?=
 =?us-ascii?Q?FRYh30usxror77/Lm2QCRNl5q3hRkxBG9wu1W7RcCJo9faEb/QjXVfxItnaW?=
 =?us-ascii?Q?d4DVwsvQeARZAs42ckdky0DP6pZm3RDLSSzd9PTzdOXbr0d+FXNL5K0NqsjB?=
 =?us-ascii?Q?o6ZbhGwfdwYnsg1TzSmWq3hs0GxrSD7IhrW47bWwsC7lBMjKQzoGzoSR32OI?=
 =?us-ascii?Q?7DOsfCaZXWxOADYg8Y4MJ2cRe4RPV+hMEwULayYxH5Hy0y9G8xd8S1rztk90?=
 =?us-ascii?Q?kSyxKzxZyjJ1DQa/4sssvag34a71RrIoxSLO7ac1AMsqdotOuZb+ot71G8yO?=
 =?us-ascii?Q?FYxQUIn+C+ruX+QyZlr85+KvgWtfAJnsGxXJ+YalRX7fwHqVeQDG7bbGtQw1?=
 =?us-ascii?Q?8RBqOJ2nzQvW3cUkkf+YmmEXQo//OKWO10KrnRc63Ncr9Vs/evdLToOrvlxT?=
 =?us-ascii?Q?pmFyxB72G2RpOcdqQqPvc5IvVE1U1JusU5pkqZIMRnHA+L95r9wpVNoXefu+?=
 =?us-ascii?Q?SiFv8TwxS7RHR4pfnJjq0kwujcpLwptVWS1kiabEZmQbsVhjOyGE7ukoSIGk?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e59fd2-9403-4da7-61ca-08da91ecf39e
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:31.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaItDR/Njf/mkJu68f6Wiris7dUXU4ISVef1wI2YMGXIXLbe0oQaF8XTU+2tf0vIUhPqL+9YGwUzGKi1OlRq2uZJjy7fhWsBpU+cyWY9otE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
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
 .../marvell/prestera/prestera_router.c        |  16 +-
 .../marvell/prestera/prestera_router_hw.c     | 354 +++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.h     |  74 +++-
 6 files changed, 582 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index e5a4381a88b3..903e2e13e687 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -306,17 +306,22 @@ struct prestera_switch {
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
index 5803a28050e1..2bc348b1d5b5 100644
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
 
@@ -542,6 +549,14 @@ struct prestera_msg_ip_addr {
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
@@ -567,6 +582,34 @@ struct prestera_msg_lpm_req {
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
@@ -729,11 +772,15 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_reset_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_create_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_destroy_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_req) != 124);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_chunk_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_grp_req) != 12);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_port) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh) != 28);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -750,6 +797,8 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_create_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_chunk_resp) != 1032);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_nh_grp_resp) != 12);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1027,6 +1076,8 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 	sw->id = resp.switch_id;
 	sw->lag_member_max = resp.lag_member_max;
 	sw->lag_max = resp.lag_max;
+	sw->size_tbl_router_nexthop =
+		__le32_to_cpu(resp.size_tbl_router_nexthop);
 
 	return 0;
 }
@@ -2037,6 +2088,85 @@ int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
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
index 21078a2256b2..0a929279e1ce 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -146,6 +146,7 @@ struct prestera_counter_stats;
 struct prestera_iface;
 struct prestera_flood_domain;
 struct prestera_mdb_entry;
+struct prestera_neigh_info;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -266,6 +267,16 @@ int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
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
index 58f4e44d5ad7..a8548b9f9cf1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -191,7 +191,7 @@ static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
 		return 0;
 
 	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
-					    fc->lpm_info.fib_type);
+					    fc->lpm_info.fib_type, NULL);
 
 	if (!fib_node) {
 		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
@@ -220,6 +220,8 @@ static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
 	}
 
 	switch (fc->lpm_info.fib_type) {
+	case PRESTERA_FIB_TYPE_UC_NH:
+		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
 						     false, fc->reachable);
@@ -537,7 +539,7 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
-	int err;
+	int err, nhgrp_cache_bytes;
 
 	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
 	if (!router)
@@ -555,6 +557,13 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -578,6 +587,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	kfree(router->nhgrp_hw_state_cache);
+err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_fib_cache_ht);
 err_kern_fib_cache_ht_init:
 	prestera_router_hw_fini(sw);
@@ -591,6 +602,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
 	kfree(sw->router);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 5b0cf3be9a9e..db9d2e9d9904 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -8,10 +8,16 @@
 #include "prestera_router_hw.h"
 #include "prestera_acl.h"
 
-/*            +--+
- *   +------->|vr|<-+
- *   |        +--+  |
- *   |              |
+/*                                Nexthop is pointed
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
@@ -23,6 +29,8 @@
 
 #define PRESTERA_NHGR_UNUSED (0)
 #define PRESTERA_NHGR_DROP (0xFFFFFFFF)
+/* Need to merge it with router_manager */
+#define PRESTERA_NH_ACTIVE_JIFFER_FILTER 3000 /* ms */
 
 static const struct rhashtable_params __prestera_fib_ht_params = {
 	.key_offset  = offsetof(struct prestera_fib_node, key),
@@ -31,10 +39,44 @@ static const struct rhashtable_params __prestera_fib_ht_params = {
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
@@ -43,7 +85,13 @@ int prestera_router_hw_init(struct prestera_switch *sw)
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
 
@@ -52,6 +100,8 @@ void prestera_router_hw_fini(struct prestera_switch *sw)
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
+	rhashtable_destroy(&sw->router->nexthop_group_ht);
+	rhashtable_destroy(&sw->router->nh_neigh_ht);
 }
 
 static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
@@ -232,6 +282,286 @@ prestera_rif_entry_create(struct prestera_switch *sw,
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
@@ -251,6 +581,9 @@ static void __prestera_fib_node_destruct(struct prestera_switch *sw,
 	prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
 			    fib_node->key.prefix_len);
 	switch (fib_node->info.type) {
+	case PRESTERA_FIB_TYPE_UC_NH:
+		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
+		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		break;
 	case PRESTERA_FIB_TYPE_DROP:
@@ -275,7 +608,8 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-			 enum prestera_fib_type fib_type)
+			 enum prestera_fib_type fib_type,
+			 struct prestera_nexthop_group_key *nh_grp_key)
 {
 	struct prestera_fib_node *fib_node;
 	u32 grp_id;
@@ -302,6 +636,14 @@ prestera_fib_node_create(struct prestera_switch *sw,
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
@@ -323,6 +665,8 @@ prestera_fib_node_create(struct prestera_switch *sw,
 	prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
 			    key->prefix_len);
 err_lpm_add:
+	if (fib_type == PRESTERA_FIB_TYPE_UC_NH)
+		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
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

