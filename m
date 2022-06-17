Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC99654F521
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381742AbiFQKPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381655AbiFQKPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:15:38 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130094.outbound.protection.outlook.com [40.107.13.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF51F6A075;
        Fri, 17 Jun 2022 03:15:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPlHAx0iGeipkI703RDUoECQj6S9yCUVFvCTqseFv1EvJmnd/4gqd9UssbMObkcLuFySfUbYi6dbJOd2ij7UiI+8Nbid5yd54P5v7xu1XK2Zq0lEYGL7qZuGfsCbkmey65e2UsZdvIC6qE40t0rvBqfDzt57qWK45BA1DTkbiRqSJHgQd43Ej0TejA2P18TCbfDkN5Wx23JwM/Edp33UdjheovE8ytnfquxgca4CBk+Il2w1bUGNZlWDDVZoogEgcV7oV1Zt2mnFWFMskq3DpqomnSKAM0P4GNmY7hZf3CJmL4LeOshzRudthkkIj6tQXfPGQ3Q19gYs/pto6q0unQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg9Nl1imXfGidgM1Rh+X6JtWKd/6sCW9a8oY/k+MOJ0=;
 b=jRQInNpoOr+ObmOvP2SOEcCcaUDU9Muh+7jy8Af1osdWjJd6By+pKzodQrilqyRqq1WYIdIBXaKXDCEfMSc/PRJrngrC9WJNBiN6H+Y1B6tQvMxfiTZlrsSAtfGKMVasGpYL2zYLTMlkihlYTHSbp2K8YRqkHseWqAnFwzcxJDOV4a1SOiI9tq/P+aO3QVmV5JTrhL6Z3briBCCxbYX/cA6UWFjTnKvjX3iN/6m+tvxNJRVzKuCtRAHnDmL5H2y1YBgY56E2vqiIGWB7NQFTpRZI/15gmPkEXZLAAYKFK/nBaqjAYX4/sLpN2n7drxVWhDu/sUEGf1mdpHVSYG4pvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg9Nl1imXfGidgM1Rh+X6JtWKd/6sCW9a8oY/k+MOJ0=;
 b=SyuLQv2cLf7PG/aZLi07aDodtcPBIN81EpcMKGFI6YM93uRPUu5H1ZLYzaWNe/NBtZPQNgvmZnI2KKDgW5wVSDy0q8R1kyYsHVTF3VLp5E7jxsu/tPK9cFOYcelVZdIo88WpcOGTfpRqFwMXr9YZFW2OqpFUM0HfvNmkDkHNk9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM4P190MB0051.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 10:15:35 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 10:15:35 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V2 net-next 1/4] net: marvell: prestera: rework bridge flags setting
Date:   Fri, 17 Jun 2022 13:15:17 +0300
Message-Id: <20220617101520.19794-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
References: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa8cd702-e7e9-4907-8e97-08da504a5150
X-MS-TrafficTypeDiagnostic: AM4P190MB0051:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0051EDFAF607B9BE51FCF478E4AF9@AM4P190MB0051.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SalDsyCXEXu28/d55Skdd+aKmsgeNWyxbLj0gmpNXvrDsZHKZB3b8qABYrgQN95e81eSnd3j5jMC+kK7GJNvwYHz/278f3TyT0/cWnr0MvNEwIUg1ungv7De46rxbCo57ungXLO/NOYBhLKh71jcVJT4HDO90hhkTYowiqPSut2a9Ng/Jczk4oFsgNvV+AFbg7bhv57Ko0uNbcyIKxRhqz9LWmr/RM87IkiARXYzHMLn28zN6g+5+E9qIswSuSVLqEEr/QwbM4FEw3MFK1z4fiCxQfstcJcC+bQ2s2qPOPtw7B/wNBpe4/AQ/C5+vRw/vUeO1bU675AS2ZSmdYIPAi1pjnW+0huOETzMbB7aJSUWUrnsC5n/vrX0IW1hHzRrjoJb4U7tHpLiZioYokxJLP5GqtYtdAxNzH7GoQFrsZB4DKIIOi9rnrubVXgmTUrMY+P5RI1zwnc02GTgzcJQ811S46enUH+Q/G/jfU1+EHSpGvB0dL4A+ZH4X8OHfOPRk8PyfMSCtnFc7kXStCwwIdABd18vNUH+qZ+tXnfkvdCmR2QiqaoG4R48V+mJSknEu3JEdKwuhzaAJmU4aW3A/UzBh/7R9kRznw6/osifcuvRPQSkw360wNO19wug7wEu7hYih2UWJXRsknStJwOjcJeNLdLlaYCOschsP2qb3TKgS6v+biIJLg3JkSxGHgLWODoEuyg2KLvahCdjhnxKsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39830400003)(366004)(44832011)(8936002)(26005)(41300700001)(83380400001)(186003)(6486002)(5660300002)(508600001)(1076003)(107886003)(52116002)(6512007)(86362001)(66556008)(66476007)(2906002)(4326008)(2616005)(66946007)(6506007)(316002)(110136005)(38100700002)(54906003)(36756003)(8676002)(6666004)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mz2YTX4DT9Du4OC+ZZ8sfyndTtLzjCpdh02ghWKGjJYWsWjRGaqJxx+Mz3nm?=
 =?us-ascii?Q?v3/UfmAVFArOcoqs/YLROeY/C/lR5l/mCt4Om8tSuoPIxlqmBMVW+MB2Oh81?=
 =?us-ascii?Q?pGT8ZVxhX98JrKT0w2hhqEwTwOU4j5uyjoTdYWgHJLm3hN9kDRz4kswAkZre?=
 =?us-ascii?Q?E6wYkwfEaQcjW6TG8xZ/ywDZSLtt3kt5RAYtOSI1FGDi32DYShIGsuuP62wS?=
 =?us-ascii?Q?OQVnqtTh0EZWTUsuVdsYW+qj2f36sxlue6Npt38nazYsQWdiGU3vaIPZx3vb?=
 =?us-ascii?Q?sxYaOV87EcNLnLIcOiitnPGbv6PiyQcrvKwpLD5fEervy3eFm1d8iHZW++wC?=
 =?us-ascii?Q?iy25tfsbzvlXfjNXv4A5gzrSDElPCVqyAM63QUiz4Oc9z0kBIQcIAkL/EkMU?=
 =?us-ascii?Q?8FpC1uQJI8uLEoQx/PUQakXJEwQW7N3sU8LfymGL7Oujc/Tj2p4aJgE1a3xR?=
 =?us-ascii?Q?OO6L8vV1JG2rAah+b+eDNCKQaw1e8GtVdK1GeJNmBhxtLzoeN4szjskyMqeq?=
 =?us-ascii?Q?h8k9cRtYlYbUXH2OiRm8qdnOpfZaMNAvF79wUmTo3XvrMXXBS6+Ub03t74J6?=
 =?us-ascii?Q?wcl90B99hBo5CV2Vp9v4PcnHS6IatccUIaXiurXpfMAmZz0zLy4htHmXi07l?=
 =?us-ascii?Q?2f9YaezTnECYbyxFKjL7CrIHX71KH0+bTD/DBRcDLxmN9hPAysi9NJwvRBpg?=
 =?us-ascii?Q?Bic8VIsNXx++u489QO5CkZ6HNfCbNmUeRglPgr0HzJ+o2T/YtgZ17YrthBMf?=
 =?us-ascii?Q?JO62ordGu8QwAhTMKfY9gQSEfBTl3CqSVmJO6xw1E0h/8MFyUxYUiTNkf/rQ?=
 =?us-ascii?Q?qrWb9xGf2E+3ezu2BySOCbYIUg4PjR6Ky77WJX+EtvC8cofY5CUAsqh8Vudc?=
 =?us-ascii?Q?2hwGSuwSLCgTzAap6ObQjA3ui+cVtMx0T/cNLaS7cRVS4dNaDQszSSuIa09t?=
 =?us-ascii?Q?ElwXdu2vh/bUj1mz4Rb3E/RCtNoLbBz4M79+dqK7F4C+4MGZYAr5DdPUdjWf?=
 =?us-ascii?Q?AnojtxDa7jGBlEMi69zbNgzaGh1fXZj1ajD5JjaWyhaGdBkdVMmRs1R0JNsd?=
 =?us-ascii?Q?Ij71VLxZCtjb8sP3nbwmAp3a0kxirUmcnHam5pb3dcLO4VoSKgTbcd8koeQ+?=
 =?us-ascii?Q?zYQXHsEt1XY68mDXpvVjczh++U5XkDBwuk5sZXhQclxjpR/c68hYb2wP+jgO?=
 =?us-ascii?Q?MwIBlNlOSrmMPYAjpVKMDuw8SCBPIXweA+K92ObUhKU+SLJe0Yj48kt3JU5c?=
 =?us-ascii?Q?peG0uZgLQmPrl1RhZWxiggPQGZqzULsozJOSy8gCC8Z34qll6wOQAtubiakT?=
 =?us-ascii?Q?tnce3jgtB0ZemvF+NtqRwwh7NOi4wB5IReyPbk02bjI9wE6q43V2twgQ2yzQ?=
 =?us-ascii?Q?dTOfdjfOyg9Sy6etuLPShUWrtQioA4+Z0NJY94rhvdQKjBYMcyuPkz63MY4+?=
 =?us-ascii?Q?kjS2JVlqBigRVy5FmtA+/GQgLqnASBzRK0oUFVELSJtpRUCtOKo8vTiyQzOl?=
 =?us-ascii?Q?yezeuUtW8pNixQjucIrKusyJJwiPDTAkOvsgbG6iKxMUwWnos3IBPqyMiu/A?=
 =?us-ascii?Q?KiB5REb5A0ji6Ua3xMS+L6OgYNJkYVFqVZent3ByPh5rg4pGFVrCy7Daj8m7?=
 =?us-ascii?Q?5uHiuBVT84u19JJMuGhMNBjJ/p4SO8E8Aj3fM633wNzNH1Qjz8wEb+vTDp4R?=
 =?us-ascii?Q?lbm8/Mbepg05qsCAIL7G0o402GnHH+SU7B9PTTJdiR6tssBPElLD0FrH0aBj?=
 =?us-ascii?Q?P26VkcbWOd+CgQ4OuOufT57abEe/kK4=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8cd702-e7e9-4907-8e97-08da504a5150
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 10:15:34.9475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQpy6npwEI+XldNoDpIKH/1xfWuzHExJULIPZqoKw16NcoDjtzoqCJGMhqgrdD4kfJpXlQQdcE+TBRm9Y/OpI6laq7Ez7l6rScKFfQrdwhU=
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
index 6f754ae2a584..837e7a3b361b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -330,6 +330,10 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
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
index 579d9ba23ffc..3eb99eb8c2da 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -178,8 +178,8 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
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

