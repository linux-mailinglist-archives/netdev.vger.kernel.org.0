Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD13A674A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhFNNDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:44 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232992AbhFNNDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdzF0utG1ohSE+R/IdZeISrqDXkB4SCRtzxRpGvKckaT4LsITcIU+WwFjJ98RMZgqCQzXIzZLF85UgJVDrgjp7ryclOgpu8dMzUgyshLW6DxHG4VOtOvqXS8RkjyjCWzTfAcUArgTdqrT7bDBrS9WHm82Q6mWKHfau+3lf11hP+ddUmTyWTgN9QWzyM+q9jSI05VkWB/cKXVZzM6vpxNdBiIK6QjRS34EtJ4ipXA8SaWyooHJIykYQEe+QmKZT6qt3XYSjtEkJ/F6Ne/nmJiNAXQqgWnaGI3kh7R0CqGrEAx0NcZUj0EUskVT9F4efSzPm3SS5h9d3k0JrFQm0wQyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK4o5aIQ7jo1S0csDb7st7QmTMF1krndvVDrHRiTHIA=;
 b=c3+GRWxQ8NtzlcJO3G9wlAZJ4YTIvhUhs5ZyuO3sNpErHaqhk0S+w7zo03R91lTTPXQBfTwCvETMDzjxb1+nw/a+wA3uv/VWaRFZn++pwnLdO0YdhCgxZ/ICFUxT4pFFdgzKvYw57D4xeVUVErGQIR5Z5RJSNyW69/GB7UqbdvH/SEs/UrI9hrXNttsFY6qXGftEPWZBG8P1o7Lq2NF3hpsEjJmX5LwYHwCfdFPrF0nM5kv0I/qtH2Go6/4OzHfK55OA2+J8KgXEk3I5/MXucs7oHjK/CLLpzHnQdQjeIVSyiUM1i+vnJARfyKpDGqQUPEmXix6r7Cd+xTVAILZZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK4o5aIQ7jo1S0csDb7st7QmTMF1krndvVDrHRiTHIA=;
 b=UR+wTfrlrJ5qUWv+FcdMvBTLlo+hW3utnFxoQ/h+13fadls0bk/eruEixoGqHFWbFe7Xy5el3SHb+vRyFYfxCeHjL+TELlteL0Dy7D8WkOLyKwi6BlyaDnU4qFugooH9oGzPZgHgmN6rsf/JlpTIx5gyRHOlq0Yb5A32KHsY4Xk=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:36 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:36 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next v2 1/7] net: core: devlink: add dropped stats traps field
Date:   Mon, 14 Jun 2021 16:01:12 +0300
Message-Id: <20210614130118.20395-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6cd0985-3d8f-42a4-096c-08d92f348acd
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB13965C5D0FF6A3504AEFD23FE4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QfJ1QUKXhyMsKLb47hcfqJo1nS1lpLGzXKB941fTJxKR1QEFfV9oLyRv94SBu9Gvy2lIzkfuKr5AiQlEVtQfPsqZfJ993mHufJbUTHdU82Yimw+3VfbN/GuIeIdZFPmfeOqV3opbU7Jxkw/HSA8ZNLMcvLmTKtpx+KT28N8O7nQPzykBMeyymhfqfDVyatqYEZH9HXyH08z3WiGX6NNlG52kSnXt65vXPrFZcrP9mJ5Ken1QfECCpGO9vn8aJXCYISKOQRxiMakKTvpRm/vM633Lz4RlWUrpCbj1myhsPvJwBW4rs/uNTetIiV9gO5TAD5dT0jZuoqjfQJ+FGo2hzcRqnElwe/8E7RmcrAeOwcbCD6qy0VguOFun9xSTIY0BLtkpbCmcrw4BVMZu1qOEFAccuqRsTgpw7G1ufaFy9chgp7W74X7C3PO5TCRxi2nu7YxxoqxS0IrYm0k29JMdxvnF8/g9KkY+zgmBPaMRTvahLoa2YaHnHOjsQ00HTxeZQfnmx5b4XlgrKja8U1u+aL0hIixb51JYWCyJ1JdK6YsBbCh1C2a5QLYSKunQekgLUFQ1w4SDWM7THFjlbAhXhK78PxHdYYp0MbFzbMABeTix5buv+X1CmaoD/5qOTL5EG5HWL91OTRmeqru2yJWoeaDKQCIrBIFDsVKym8R5B9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(66556008)(16526019)(186003)(83380400001)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hLcEpVrAMy3zub8AiUaZhivRR/Ud4gdFjF498elWc7lcBtsufwr7golFxWha?=
 =?us-ascii?Q?37DpyL7DQLe+WBFc65E07gEmaAyKZ6DKWT2FA9U434kC8Noz4gnd592bYRHW?=
 =?us-ascii?Q?PzoAMPzmMojV3TPJPS29vahe5+mheGZ5D/G868X2//+m0yIx1ylOTLTMV+19?=
 =?us-ascii?Q?9GF08Ya1Ha4jtZow4hhDU8x78ENr5rnrfAzWvyim7vyADGRZFHO7RTXsXKL9?=
 =?us-ascii?Q?zKp8t4zljIM8Sl/neEvPozF+XyoUIEIJRB3/bwCSj38tmTji9AGJuEzO4uJ6?=
 =?us-ascii?Q?rvkmrdH1rLlzNo8vUm/Q/FILdzhVchZIm/Ocqok85D97jnZECK0GMGO3Tupc?=
 =?us-ascii?Q?jDJ+VZ69P6WoMTuws7/LXW4yNexvuxhSyOiwnyBBjgO/oZJsG46p7AO2t+UK?=
 =?us-ascii?Q?scJmruChayRNXMDu/mWLKYCSW1gqMoiEZ225k4tFN9n9USPoXDwxI/6jj9oX?=
 =?us-ascii?Q?xsdpwyDINSXLoS052z3itkqI+NxUw+6RP5w/2xO1fLjvKecHt/n2rVSvHmeC?=
 =?us-ascii?Q?oJvQCXwsVhTuwW5Og4HRLBKZinwNxOKDNBgj5eyPsk3zxLei0qHVwYDkkPqD?=
 =?us-ascii?Q?n6wE+O8mTFCa8Q891qf9qfbDZQCf8SeO6wcJZm/Xl7jbjVysEa/xyc6l+KjU?=
 =?us-ascii?Q?k5hljyi9ggpZIgAVW6LQxXK72kwjkefvsG42tpITIiqSkW/c670J9OABQv3c?=
 =?us-ascii?Q?V+5yMI7LgYxUeW09mF2+xzN0/FSIvX423AnOxsfE1xBLuo2ygzY1XTZSIxAv?=
 =?us-ascii?Q?rt0c2H/rdUx1X/xZIWbUQ5R5rym14fik74ihJclUOAzeWdfR0Ocwl0F1g18e?=
 =?us-ascii?Q?Jz5yngnDp9NReku3gE+jWMuOe9caoc3gNrbTS4c6t66W4eayrcEIHUjW0MJ3?=
 =?us-ascii?Q?OqgZFPMepxfgZdkBfWtoDZZn0Xn3ex+tKnwWazOzQDOdI/LhrK1uMmYb0sL4?=
 =?us-ascii?Q?zBQjKtfZAnUlfa1aiWwQwFCnnyZCF5CPeVlAcJnhEbdRBof87u4+6ULloBV+?=
 =?us-ascii?Q?DfrxdUUVCMrnc8DxkEYg0eoTEPfmifJTTSBSjjpPRdA6lw4rbcyOs0pEWByq?=
 =?us-ascii?Q?Dl8dzR2XvdJWIpjROA1XECwu32RhzzQd1nVP1j5CX3yh2Ptxr07Ln+E9uti7?=
 =?us-ascii?Q?w83jVgyntYp7gxSlIt4H5BRbA7+95DTXIVHaIi1hqI1+H7j5ES0p/GrrNVaU?=
 =?us-ascii?Q?5skgcbnwauWv7Y6jAhzYxe/JFohpvF1coDzshHwvX3aiapu3bWq4tO6EZ7nf?=
 =?us-ascii?Q?dukRK7U0v6twrsUCa/srpR6BO1OtL2dO28ICIaF8iFily9u1t4kNh+yopDl+?=
 =?us-ascii?Q?eDMTAn75Uvu/A3+tO2xuFi0L?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a6cd0985-3d8f-42a4-096c-08d92f348acd
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:36.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFIHBs2HqmNsl8FUviySOOG6orszys4IBMxDnniW9vJUoaqXSmJO7W2hjK4uQwG4pyeIuJdksL1KCWqcxhyC4jw9jyFvcyVoKeN8vyl1OoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap, devlink subsystem
would also fill-in statistics 'dropped' field. This field indicates
the number of packets HW dropped and failed to report to the device driver,
and thus - to the devlink subsystem itself.
In case if device driver didn't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 include/net/devlink.h | 10 ++++++++
 net/core/devlink.c    | 53 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index eb045f1b5d1d..57b738b78073 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1347,6 +1347,16 @@ struct devlink_ops {
 				     const struct devlink_trap_group *group,
 				     enum devlink_trap_action action,
 				     struct netlink_ext_ack *extack);
+	/**
+	 * @trap_drop_counter_get: Trap drop counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets
+	 * that have been dropped, and cannot be passed to the devlink
+	 * subsystem by the underlying device.
+	 */
+	int (*trap_drop_counter_get)(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3bdb7eac730a..566ddd147633 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7519,8 +7519,9 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 	}
 }
 
-static int devlink_trap_stats_put(struct sk_buff *msg,
-				  struct devlink_stats __percpu *trap_stats)
+static int
+devlink_trap_group_stats_put(struct sk_buff *msg,
+			     struct devlink_stats __percpu *trap_stats)
 {
 	struct devlink_stats stats;
 	struct nlattr *attr;
@@ -7548,6 +7549,50 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
+				  const struct devlink_trap_item *trap_item)
+{
+	struct devlink_stats stats;
+	struct nlattr *attr;
+	u64 drops = 0;
+	int err;
+
+	if (devlink->ops->trap_drop_counter_get) {
+		err = devlink->ops->trap_drop_counter_get(devlink,
+							  trap_item->trap,
+							  &drops);
+		if (err)
+			return err;
+	}
+
+	devlink_trap_stats_read(trap_item->stats, &stats);
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (devlink->ops->trap_drop_counter_get &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
+			      stats.rx_packets, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
+			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -7585,7 +7630,7 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	err = devlink_trap_stats_put(msg, devlink, trap_item);
 	if (err)
 		goto nla_put_failure;
 
@@ -7802,7 +7847,7 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
 			group_item->policer_item->policer->id))
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, group_item->stats);
+	err = devlink_trap_group_stats_put(msg, group_item->stats);
 	if (err)
 		goto nla_put_failure;
 
-- 
2.17.1

