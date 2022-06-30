Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04CE5618EB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiF3LSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiF3LSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:18:42 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130131.outbound.protection.outlook.com [40.107.13.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49874D4D1;
        Thu, 30 Jun 2022 04:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC0wDLZprUeJY0xNeKCPk9a8C/cQa9HPeb+srFet3W311zQ5jyLuc5asaFPreOJsRWAVeU5Ye9rJrN8XNUu0N+uy6pgKni6u0KcrVy5WeTTueshie3Vz+ArTdVI94yk3nohAo3p3m1D1fuur17wGDSF8aAxmFyzfFSOKU4Sa/b3bAJ2bVYpQYtWktXY/zxvM4VR8ByIHM/y/VUAp78T02uia9DCqzXFtmjm7i4BOHZ7SwRTNN2D7I3pcYYR+NrJdnU9l2Zy/BwUQgUAOfmyboBaND/XN4FmmSM2bfZHvDg8jnSzb3VVwVV4ruIzmP2x95V+4Cw7oRtnAnOv29ZPFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=VVAn1BdXYa2zQ+dQszBqLcqY6y/4lK8MGgUG23raZbKXlM/7XYP1IcrJsLiILh1acwxMorg/ax1yI2KQACGQF63SDaS5fzaCk/Xxs9j1lnXJDxrRLl8qhntLpDb1/mXWVq8kYkuXqHckzdpXIXfqpw0Bemi/Bnms/BSdXRAnw77p/PYr5p8DQSpJSY/wjuQA1kkw+p4KWAjFS84Titc8iDtd+dJyWiacW9Bvtomu/TvJmKIf82E/VJSIsPQMLISKz7L6nWTSNNE6U0eI4t9VTvGSqHjoed0oYIixzniWFXXfv1E7l5jdMlk4hwS+/WjcQiFscbr+O4Ey6VGTE9lD4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=d2nVo4qTDNa4N4pfdXg202pGLPeaQeryZCExSHyMb8/o9tKM3GlMoV+5mpPoRBM3F8jnD9u+6sdOrdRNOQnTokN+O0oFFHUFlkAzMXfnKtOkXTuMIJ+yCVU0iRDwqNlpcM7GoTPK8RWOlCll/l5EMeO/7FdEpU60/IN7hwOUS5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by HE1P190MB0489.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:60::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Thu, 30 Jun 2022 11:18:37 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 11:18:37 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Cc:     lkp@intel.com, linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V3 net-next 1/4] net: marvell: prestera: rework bridge flags setting
Date:   Thu, 30 Jun 2022 14:18:19 +0300
Message-Id: <20220630111822.26004-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
References: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 158ef6ec-abef-4b96-07c1-08da5a8a471a
X-MS-TrafficTypeDiagnostic: HE1P190MB0489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjXaXdziV4t9h3fMGtQa72m2MB8rP92gkoCEZ571fHiXENigPMRM8M7RSu/pr/kxpWV+6m1XtLzGfQoiiMC9nCnsrlXkbXaghyLf6VtkdaxBuQu1lfGX2bhyDvW4SopF0MGYjlvZ0v+NOcGUHpGG5i1t7s9bhbdfYVQhEb4O/+9VvwnbgqVLESgtsiLyiXJ+ImPSq6jd1eMwiXxsMBKH9WvhMGklPMG865j690rF/HW4Qpf7Cigzym5P6AcCrc9C/vPJZaWpV4RLM31eg6wAaWDHuAjMv2G7DBTuoNgoPj5AHZFtiWJ/SxAiaRO7H9twOdpZ73/MsqEQQeVeDw4VDeD5vQLWQUstoWezdce2EDhP4Am6bTzSm1UUTXSu/CpKJXs5kwPu5mBEiNGbaVbcm3ykEt4pzNDuwoHTkkgxNj/lasBsqoJYU8qbDC/bGY2pCLnp5HgYtjSksA6hMYD2OnQW8bXg8X+19Dehz/4NRK84KPDXUsG03rNzQDmFMMICe3e7yd3v7/4lhplNDv9nXVtTWlyxKLXgep37TMSXL8L+FWVfVm4BjOBScLNEHW74XbZf9eyrSagF80V0Bppmra3ftEjUUyiYqcNFFrbIY5iSkNw4KudMC/7DlU/MDCfNulSJJ+YI6MK9L+B3tMKPdPaQnkXKbQcAmheYRso0IOhEhFecc6uf4q6Oi/5j10rD4QWaN4OZmTKxxwGKIw65J6ec1nZHWtIhskG+Yl45hWbs5MrDf3LeHmFTDGLW/smE8qRaF9O64/LBdh495EBVsbz7DLP/pJE3bZVS4de6o8Vo/E4lS8la26c+Hn0dFNpj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39830400003)(396003)(136003)(5660300002)(86362001)(36756003)(6512007)(8936002)(6666004)(52116002)(38100700002)(2616005)(44832011)(26005)(38350700002)(66556008)(186003)(8676002)(107886003)(66476007)(478600001)(2906002)(110136005)(6486002)(4326008)(316002)(66946007)(1076003)(41300700001)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ojah/Iql/hxSe2bZr5CUmCeVot7m4NmpUbJvBs4yo4NzlokaGzU96cYQbYmN?=
 =?us-ascii?Q?hvUQRP55wZOQaDWD8YvfVuGXuO67pFVY8hWtLrUPLK058nEca5JzhUAfh8pL?=
 =?us-ascii?Q?fRzZeUMKvEbiIn+mHSW9WnHt0vPsMVPbDo7aj8NlVcM61vQm3xhF4ZQ3dJVB?=
 =?us-ascii?Q?CnzQcerE2FRr84wknde6Xk3aaE9Rf2Ckn/LrEJdFT/9ubXe9nqdN5LgeDFyT?=
 =?us-ascii?Q?xzM/nyLmIX32gUe8D7uaj582SLqNY2MmZiwn41gXUZSNIwV/g9SsCZ5TgeUD?=
 =?us-ascii?Q?YH/R5Yq8qD38g40UB52JFvtcZ381jC8t3wpp/3KWnRL0CXm3QbxO+iTnDqMG?=
 =?us-ascii?Q?6ZJpHLvB3kXhjjQ9wda91I+FuF0r1Y7+aVUjzXy9RH+FMQCTjjlxS2WVAnu3?=
 =?us-ascii?Q?0+wXhK8+Sih7KmuGpqPV8MHdvEhyR7Pj4yL8g1PuhoAt/ETg2YolOLD2K5Yn?=
 =?us-ascii?Q?FIKC6qxOZnhcpQ7jcYzailXT7GVSKZ6VHGAF3Mcnvo5RMHgYvR/5B3cfYB/7?=
 =?us-ascii?Q?gXvoQr+fiI/4Q5S12ZQw1rKLbWx7nrt+F1RF31EEg8Qum7O9I0BLzpzneroM?=
 =?us-ascii?Q?n371OlLh9ceL8C57FFks+gWYzmZ+wS2ghrNjxyJl+KZE0aoC3bHGGSlwXCFU?=
 =?us-ascii?Q?1Tq/TBVlOXp2FBWcv8myvzVV1mT4h++MCGM7loWNpN1/t45aceiUlPXJRqRG?=
 =?us-ascii?Q?gdKAcELjqu1Fr64i7s3qCZcizOO2DYBkltHjM6wnrxntGKodNSVxdcT/Tm5r?=
 =?us-ascii?Q?36M/qiX+zDBFoXzSHINsRGhrNsCYdxwVSRGneVp93fl209oTznhpAER3HIHg?=
 =?us-ascii?Q?IvEJJbUc7narQd2LgvblQ+vjkyE33HaXil7xu9rOc38N0wwaEseVrJlrvh7p?=
 =?us-ascii?Q?ZWusLtBywlI0/JIz9Z+Tkjzu2xFwhBCDR/wEA3LVDjxjgD//ZDlgB6GfUNbA?=
 =?us-ascii?Q?KmvEgRdC+3jpLdE9rveUqLCqYOVDdduYrh5MKyJM0R3aL9eRkqmTokAhyU/A?=
 =?us-ascii?Q?WZWkww/t3g5Yz2U1rt+xl7Mr/ncStalUfT+wPSVS7wVpwBaNn0c+C80p95iv?=
 =?us-ascii?Q?q8bevefFz4ZROuWDgypMzcwV89WYq9J7cOoTPVCnztCfFRXxzizjD8UaDnr0?=
 =?us-ascii?Q?ZiM2UyvlKg8vwOYM3Io2IGlHv4grP7v4hogYSv6E6oQaduO2DWWEe5KHAUqL?=
 =?us-ascii?Q?ByprhTLXpRN/aHF7eoDeMdDsscLm1tD9BA8kkR5HxoejwL2ixWKCP1d/FJix?=
 =?us-ascii?Q?cJDk2aX5Jn07phOyTyllZQ/hNaZiO3U1l1qgF5eZ+HPJfOLxo2PCtjRe4oSL?=
 =?us-ascii?Q?XKcOuWDx853hodCZsqod322gZK/UpG4CJZUYPxw4mMONRJ8QFlwzi1LnsPfz?=
 =?us-ascii?Q?/HEwb6RrqSbpL2xZImSqfX01ud5JEhUCJwvvppOd3z7KmUPXL4CUKs3t1Nfu?=
 =?us-ascii?Q?o2pEd/Cmrj96LPJl54qI29ggrwRu5hx04WjY6oDw+54C2UAH0g2j9cEHPclh?=
 =?us-ascii?Q?v6JnPUH8GA0pbi/0I3iRxGeho/AkRZKdyZmF4evHOWHHGACkpONwioxq2ViG?=
 =?us-ascii?Q?IE+wmPp6PlUnPJOweEXwqb+9jFS8nqkv0brAb+6iRlXHB07yE3S08FwHg3L4?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 158ef6ec-abef-4b96-07c1-08da5a8a471a
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:18:37.2783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2Nm7TD1zU83/a5PzQnk85avh2YViiDDJXjT4FsizMjmD0LrfgQUPM/vu823WSIb3WXfAHfjoYQ2+iRZOjS5FZ+cEQU5DvNgXiaYIBHgzyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate flags to make it possible to alter them separately;
Move bridge flags setting logic from HW API level to prestera_main
  where it belongs;
Move bridge flags parsing (and setting using prestera API) to
  prestera_switchdev.c - module responsible for bridge operations
  handling;

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  4 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 54 +------------
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 +-
 .../ethernet/marvell/prestera/prestera_main.c | 15 ++++
 .../marvell/prestera/prestera_switchdev.c     | 79 +++++++++++--------
 5 files changed, 67 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 0bb46eee46b4..cab80e501419 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -331,6 +331,10 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 79fd3cac539d..b00e69fabc6b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1531,7 +1531,7 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1549,7 +1549,7 @@ static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1567,56 +1567,6 @@ static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.param = {
-			.flood = flood,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val)
-{
-	int err;
-
-	if (port->sw->dev->fw_rev.maj <= 2) {
-		if (!(mask & BR_FLOOD))
-			return 0;
-
-		return prestera_hw_port_flood_set_v2(port, val & BR_FLOOD);
-	}
-
-	if (mask & BR_FLOOD) {
-		err = prestera_hw_port_uc_flood_set(port, val & BR_FLOOD);
-		if (err)
-			goto err_uc_flood;
-	}
-
-	if (mask & BR_MCAST_FLOOD) {
-		err = prestera_hw_port_mc_flood_set(port, val & BR_MCAST_FLOOD);
-		if (err)
-			goto err_mc_flood;
-	}
-
-	return 0;
-
-err_mc_flood:
-	prestera_hw_port_mc_flood_set(port, 0);
-err_uc_flood:
-	if (mask & BR_FLOOD)
-		prestera_hw_port_uc_flood_set(port, 0);
-
-	return err;
-}
-
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index aa74f668aa3c..d3fdfe244f87 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -179,8 +179,8 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val);
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..0e8eecbe13e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,21 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn)
+{
+	return prestera_hw_port_learning_set(port, learn);
+}
+
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_uc_flood_set(port, flood);
+}
+
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_mc_flood_set(port, flood);
+}
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index b4599fe4ca8d..7002c35526d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -74,6 +74,39 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static void
+prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
+			     struct prestera_port *port)
+{
+	prestera_port_uc_flood_set(port, false);
+	prestera_port_mc_flood_set(port, false);
+	prestera_port_learning_set(port, false);
+}
+
+static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
+				      struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	prestera_br_port_flags_reset(br_port, port);
+	return err;
+}
+
 static struct prestera_bridge_vlan *
 prestera_bridge_vlan_create(struct prestera_bridge_port *br_port, u16 vid)
 {
@@ -461,19 +494,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		goto err_port_flood_set;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	return 0;
 
-err_port_learning_set:
-err_port_flood_set:
+err_flags2port_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -592,8 +619,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
-	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
+	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -603,26 +629,14 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
-	int err;
 
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags.mask, flags.val);
-	if (err)
-		return err;
-
-	if (flags.mask & BR_LEARNING) {
-		err = prestera_hw_port_learning_set(port,
-						    flags.val & BR_LEARNING);
-		if (err)
-			return err;
-	}
-
-	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
-
-	return 0;
+	br_port->flags &= ~flags.mask;
+	br_port->flags |= flags.val & flags.mask;
+	return prestera_br_port_flags_set(br_port, port);
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -918,14 +932,9 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		return err;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	err = prestera_port_vid_stp_set(port, vid, br_port->stp_state);
 	if (err)
@@ -950,8 +959,8 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_bridge_vlan_get:
 	prestera_port_vid_stp_set(port, vid, BR_STATE_FORWARDING);
 err_port_vid_stp_set:
-	prestera_hw_port_learning_set(port, false);
-err_port_learning_set:
+	prestera_br_port_flags_reset(br_port, port);
+err_flags2port_set:
 	return err;
 }
 
-- 
2.17.1

