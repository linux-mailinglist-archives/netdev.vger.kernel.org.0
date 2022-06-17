Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9348354F520
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381750AbiFQKPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381614AbiFQKPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:15:39 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130094.outbound.protection.outlook.com [40.107.13.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1C76A071;
        Fri, 17 Jun 2022 03:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaH1SG5N1FkJ2pjiUEiFOnhccBB2xt12l/4Y5qlqn2vxic23Fq/2iSdNo/lj3Q3plfVP+VRlpXNMIx7EdoxD/b4HXZvCaLa78kYVfYVRCZ5zmpXD00ZIkwL6zvsORImu+YlMFh/pm+Nfpc4WsnTVsAOzM/qwMftRLi5oqaaAkDnzvKWXmxKNwNGGQyT/eOYAMScPuhXqlNNYzk3nsfIPwobxboK5/7+ry1HW/bUq21hUOneZxWd5dXZxHwZZ3AZxG57ktdAHbBJeW+JwJcP7gFOdz1n5kukebizucGqjgzRvnlQ6PLGJDGSKcu5RgNsELEQbIJbFZSbfEOkq+bobaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U67xdfdlvOmaHYZwfOI63Wt4KwdhhSX57Gcnb42lSPA=;
 b=O9TaMqRwOo1k1ZNF64/Ob0J2Wum+hQF0NZgjOsAT5yhByJDJrCwwPZMJ2EXIMDf86rZy9omQhdLUDK0UV0tGVeAaX3z2ggJjRfVL4az4o7oHsp5O+E0lNmGqTWXbbfZFeBXsbU1d4if9v1aLW+B+GLzt6PgM6bLszTdlgcoQ8igf2Gbteq4KCKRPH8lxFMrv0iQUGEbFGB3A7HfP19maXqtfWYExsBwOFcgq2Aam2N8xLe5XsKwH0ndC6cx4H2K4dHISdNMu6UT2IXVmnNWuToCcZd4u9AjJ2Ihcgd1rmh1VWDV777FRKV70ZQ6oZmAJpIud79MyMjP3WFhHFT/fTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U67xdfdlvOmaHYZwfOI63Wt4KwdhhSX57Gcnb42lSPA=;
 b=Y+VQhx8imu5f+pmpMP3Nm7jI/lQ+ZYy587iEkROtbr+NRdjTPre5OHRmbbgfU4ZHxgfv68P/ZspgdhgVtYgVUozFU89BBckMT0LVVor+ofQBoq4q5Ulw9w9jNOGNbgr/k6VNCo6GXRbGrepKn1XwC3J9JMnqzDEEpZ0faeDKi1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM4P190MB0051.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 10:15:36 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 10:15:36 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V2 net-next 2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
Date:   Fri, 17 Jun 2022 13:15:18 +0300
Message-Id: <20220617101520.19794-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
References: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b923e869-de3d-4079-40ad-08da504a526c
X-MS-TrafficTypeDiagnostic: AM4P190MB0051:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0051307CBD796C274506EF3AE4AF9@AM4P190MB0051.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5q//SF3lJNhi8kHf18FmnXM6sd7zJRl7WgzQgWNLs7vH/ZHxMK89eWgTa1d/ZlofKkdxGBM/9a3kMaO44+2iiREuwdEHAt8O3dAdngD4qn02WpbRR8ko8VF75GQw1D3ZKvdnQg7ofbRC7+954mtjBE1ftedFipVfkOyiDtS5rdpe0BWZC9SFEFAu7GSF1oHzfLRMAG/mU6AoNT2eDUmL8++MygAQtq/umuTopeRg2KPjc0yCbO5/My5axk+jg7xmROuElC9vFwXbiFHWlr35W5EutKfpN56UhhuZFEQ1GYqSErHWfmbf3PBsttWQfFKqxC+jPF0PnDqVKrlNDNk7eJqle/TC60wLYb97rMeWd29/vz42D5+yRlpUMvlYcQ7UaJ8uWzF9IB8qWYwbizdjbMHfLmRnT5ODIXx6ITOtPIiskrwBwiEaDMhN+NZI6b1ZQFEtuSio32LTjt0fCCMqUYsrHIqmPbk64404ZnR3dI5FEKVKqu8s8ad1aiNchkCAg/4Na55wRKWId5AW3E0gG7A7+Z4ZEU8ZLdx69tTyZXz2eMGf6NJra1Dus/TSMYBMQ7VYQawmsDsiO4SaS+8eqqxwPpXWtIlGCxl4G+S9xp3XiLp2o9xp0K6A+1z4zfBgTjvWDj+yKhk5M9bL0n7ctiq2HspOT7F5vtSNJARIlXCxbGTfyaS9Kus2T2QhlMfT4VSAFC1PnLBQ/Lhs8QM1BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39830400003)(366004)(44832011)(8936002)(26005)(41300700001)(83380400001)(186003)(6486002)(5660300002)(508600001)(1076003)(107886003)(52116002)(6512007)(86362001)(66574015)(66556008)(66476007)(2906002)(4326008)(2616005)(66946007)(6506007)(316002)(110136005)(38100700002)(54906003)(36756003)(8676002)(6666004)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XccGRCa2Fg8mnfNNPUhPFUk2J8eQvJV/92nRam65LPhYTyDn6sy+rnVeUC6k?=
 =?us-ascii?Q?Q8nm1cOnfNhNeNklWJsfbs74CPRuGBtc9XA25tbZXk277EdSftfQoZsYIHYl?=
 =?us-ascii?Q?KcsTDHOCm6KjxtDaBPRO1oUOWxMZYAgslHFXgL2F76VxiIPxA/EDcCrEULP3?=
 =?us-ascii?Q?eHoeDHOyqufT562eFzFatmwqH53jIlY27B6VZei7DMhJGwdiHm3Ac7lnYelO?=
 =?us-ascii?Q?fSXBQkO227Zq1eCWg1F53AWu3XHv5Ng0YFSLqTtZhMfYPbKqH7BrCTa5fcZC?=
 =?us-ascii?Q?s6uPqa98xdKuIyQlIYsY1IwY0jF34uOhPKTG/G1MNkzRzS1RIz47wKXNqf4F?=
 =?us-ascii?Q?cCYCanrYljhYqHLkUGjbc9jF5hhpI4+ow39Pz4K2Sejrh6SQt06pMhJsg+td?=
 =?us-ascii?Q?n/fgVC5KG2hAzLN/GYy8sxFsEyiXt7JlA0kunrlIgSENOEeZeDqkjKSjnQJa?=
 =?us-ascii?Q?zgcpGHrPbfF7IXiESSIarZRNMHIN/43pFYDfDxwjV6LwZt81vVBAzDYhFRXM?=
 =?us-ascii?Q?QhQZydXUvM94yakKOn2BoQtSA3yO2uQ7aMjUYKdoyg6/w1N8ybSeXiRGzSLB?=
 =?us-ascii?Q?1noNO0174TtWd07GGdTRgm2yZV3gs2MPewGDVDzVQSVg2XcoA9Zt33xG+GAU?=
 =?us-ascii?Q?8JJD4TANVVSgDNzmOVO8Wr+kX+VL2yEyZrcuvZQ0Zs9onbFPZnJfbYRDUSvQ?=
 =?us-ascii?Q?/s65pVKpwvKjx3ULL0JZCNZmE55nnMBDt9hEpXfRF87xYMkyEKc1bIQxsr+G?=
 =?us-ascii?Q?2dbinI8zUhluRlrQW6SDCHJ8X6VeriDngIoAZdmH6CwhC8G4LInbTHCgEB0L?=
 =?us-ascii?Q?mHMnE7ZWhkf3v5G+03uPFTs7tR+G9RU353i2YRgsa2RvMCfcdPvfZH7oERD6?=
 =?us-ascii?Q?ZuTOFgEFqpep+tbXnZAfvu9/KH92x6xYMlvZ2dJw/UijE0ppqh83ZYKe+Wxv?=
 =?us-ascii?Q?+0t8zQ3q7HxolnUzTVBIxpFZJTd6L2OB5cMoBJvNtwFHbZS0U1Qcv/8JMkri?=
 =?us-ascii?Q?qxizBYvdPRHNQaExPeU0y2BeoUSDja0TUFpLBzQr4VIkFC3+heTkHUykw20N?=
 =?us-ascii?Q?rgfv4NMT5KWiZ6U/RhpTdH5CLorNoVVv8UT0GNncqSdZHk10dgdIjek/B7Gk?=
 =?us-ascii?Q?Gn2X92gNOpVrVKA0nt0H5uh6vRH18hxpk6T36ieskUJvD3S7cMINZKgOZLmO?=
 =?us-ascii?Q?HgsFlJk7fEXTO6OOeEBqa6SVxfwdSU+dSmqop2SfPukAFyM2+dk9c4/JDr4R?=
 =?us-ascii?Q?VYhAmeKugY6/hAtNz42uSpQQxGPWPze8xGysS5O9EpW4jYf8f1vNeFYadBTS?=
 =?us-ascii?Q?bEmhyEVk/35ByGk18j05nieOIENYaKLCNKgLD9EufJukrgLIsuMvqgvTEXuU?=
 =?us-ascii?Q?cvrhuFefG2OdQyTfWQofiIXgU9hLlab7/7L9tBUc6pYVMaMO9H6l6yuwSzbg?=
 =?us-ascii?Q?qRueViOTozMm1zlkGJvhrEVvx48kpIbrbJl8RZ4BhEl02+cxqOYAxrGa2YN8?=
 =?us-ascii?Q?FRHTz323/Fphu0Vzj+/QTiDMfJV6lkTe2JFbvB4fOH8l7lkv2PqSLdxokSs4?=
 =?us-ascii?Q?TnjXNJ+/OwHGoZGAcp+KKSsGN5aHwehCr2XHYt8ZKKakdGwyt/0IG4E1SAUP?=
 =?us-ascii?Q?ptS9njnK7UY2d5v4iR2Fz9e53Cv+5HwsnbWyK7O7oT1zXT6rO7dpfv32Jzbg?=
 =?us-ascii?Q?j9NpLbYYWZEFScURwbfFTLzNEvhHtMXxjV4oEZki+1uZcuzimfRuxCT0Ivht?=
 =?us-ascii?Q?C8lSL1PVUCIZIthOKyLKR8rECbe1zRg=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b923e869-de3d-4079-40ad-08da504a526c
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 10:15:36.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5rJgK2vq8fcIex0tiNh+ohZhXoEg5AX8osSmjMGCiFe2oMUXZDPGlruc0VlxMZVLbyJ5x8zCNYTtVD0keoP1bPn2oXtcb3LaPx0c5rmQAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define MDB entry that can be offloaded:
  - FDB entry, that defines an multicast group to which traffic can be
    replicated to;
Define flood domain:
  - Arrangement of ports (list), that have joined multicast group, which
    would receive and replicate to multicast traffic of specified group;
Define flood domain port:
  - single flood domain list entry, that is associated with any given
    bridge port interface (could be LAG interface or physical port-member).
    Applicable to both Q and D bridges;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  | 22 ++++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 72 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   | 11 +++
 .../ethernet/marvell/prestera/prestera_main.c | 24 +++++++
 4 files changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 837e7a3b361b..9c7d59fbbc83 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -20,6 +20,26 @@ struct prestera_fw_rev {
 	u16 sub;
 };
 
+struct prestera_flood_domain {
+	struct prestera_switch *sw;
+	struct list_head flood_domain_port_list;
+	u32 idx;
+};
+
+struct prestera_mdb_entry {
+	struct prestera_switch *sw;
+	struct prestera_flood_domain *flood_domain;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+struct prestera_flood_domain_port {
+	struct prestera_flood_domain *flood_domain;
+	struct net_device *dev;
+	struct list_head flood_domain_port_node;
+	u16 vid;
+};
+
 struct prestera_port_stats {
 	u64 good_octets_received;
 	u64 bad_octets_received;
@@ -341,6 +361,8 @@ bool prestera_netdev_check(const struct net_device *dev);
 int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
 
 bool prestera_port_is_lag_member(const struct prestera_port *port);
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index b00e69fabc6b..577d3c1d76d7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -60,6 +60,14 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_CREATE = 0x700,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_DESTROY = 0x701,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_SET = 0x702,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_RESET = 0x703,
+
+	PRESTERA_CMD_TYPE_MDB_CREATE = 0x704,
+	PRESTERA_CMD_TYPE_MDB_DESTROY = 0x705,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
@@ -185,6 +193,12 @@ struct prestera_fw_event_handler {
 	void *arg;
 };
 
+enum {
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_REG_PORT = 0,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_LAG = 1,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_MAX = 2,
+};
+
 struct prestera_msg_cmd {
 	__le32 type;
 };
@@ -627,6 +641,57 @@ struct prestera_msg_event_fdb {
 	u8 dest_type;
 };
 
+struct prestera_msg_flood_domain_create_req {
+	struct prestera_msg_cmd cmd;
+};
+
+struct prestera_msg_flood_domain_create_resp {
+	struct prestera_msg_ret ret;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_ports_set_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le32 ports_num;
+};
+
+struct prestera_msg_flood_domain_ports_reset_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_port {
+	union {
+		struct {
+			__le32 port_num;
+			__le32 dev_num;
+		};
+		__le16 lag_id;
+	};
+	__le16 vid;
+	__le16 port_type;
+};
+
+struct prestera_msg_mdb_create_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_mdb_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
 static void prestera_hw_build_tests(void)
 {
 	/* check requests */
@@ -654,10 +719,17 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_req) != 36);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_create_req) != 4);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_destroy_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_set_req) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_reset_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_create_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_destroy_req) != 16);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_port) != 12);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 3eb99eb8c2da..838c02bd55fb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -143,6 +143,8 @@ struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
 struct prestera_iface;
+struct prestera_flood_domain;
+struct prestera_mdb_entry;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -301,4 +303,13 @@ int prestera_hw_policer_release(struct prestera_switch *sw,
 int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
 				   u32 policer_id, u64 cir, u32 cbs);
 
+/* Flood domain / MDB API */
+int prestera_hw_flood_domain_create(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_destroy(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_set(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_reset(struct prestera_flood_domain *domain);
+
+int prestera_hw_mdb_create(struct prestera_mdb_entry *mdb);
+int prestera_hw_mdb_destroy(struct prestera_mdb_entry *mdb);
+
 #endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 0e8eecbe13e1..4b95ef393b6e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -600,6 +600,30 @@ static struct prestera_lag *prestera_lag_by_dev(struct prestera_switch *sw,
 	return NULL;
 }
 
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id)
+{
+	struct prestera_lag *lag;
+	int free_id = -1;
+	int id;
+
+	for (id = 0; id < sw->lag_max; id++) {
+		lag = prestera_lag_by_id(sw, id);
+		if (lag->member_count) {
+			if (lag->dev == lag_dev) {
+				*lag_id = id;
+				return 0;
+			}
+		} else if (free_id < 0) {
+			free_id = id;
+		}
+	}
+	if (free_id < 0)
+		return -ENOSPC;
+	*lag_id = free_id;
+	return 0;
+}
+
 static struct prestera_lag *prestera_lag_create(struct prestera_switch *sw,
 						struct net_device *lag_dev)
 {
-- 
2.17.1

