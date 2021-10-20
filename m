Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E34351FD
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhJTRwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:36 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231130AbhJTRwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGHbwsjsFjGE1+WIm9aubFUpzhc8RxIpHmilzFf+BYxiP1KmU5ie2UquAwZ0uabVOpe6bkToRVmyypropcyw0lwfq+aivyPwFOHiKTRDgavthV6HuuhUor9uSYMXMXTobZjAYMPP6q33qVWko7AIPNRi5RdsZtIuSZTWD4AWdnuSrSgqtAriUXE/U0Q94ucZR6Y3xwihVs/fN/K3jdommlGDWn1lXRXmFWiNOpOb4YHNL483Btxw3NZrBgYP6g2IE8gcPJZM/g1RcjzZBVLjjdJGlY2cPRyW2GScCEtX/2NXifTRLArFsn8ERbeDjXWB9YXRrpOV2L+dcs7rlYzPoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhDPqfCtMbrjhMKDsPWa6KGR4RWyVUJqTvm3fWNpQx8=;
 b=iKooLe8dyzhpDjgBraUOEAa+vZ/adHXP5//D0omMuQSX+ceoVWTGnEn3gUPs3mYL3VVjzngzxT+sTCeN1/yIrVK9jjwLWGGtdOqjSKE/h5jGFNXwVK4ULFYeTdAM6kLiSYsf8t6aH2vkvMtY9BT7sBsryX/2F7ZgmAfYiSpgtg+qN7yC9cM/FJhRP8p/mT8NVY/t+hnM5txfUHW8GSYD3A8jg7FC3mWbypvCdDL88fTnBUgU+tZ/RFDq2Up5jOw3SHupJ2OA7+b9w6x0n/PqEM7nAcDRljLC83uK6Jh7MiXCegMRrue48nbJnrQFAbZJ80L/SZUSU3vBv2J/FiPT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhDPqfCtMbrjhMKDsPWa6KGR4RWyVUJqTvm3fWNpQx8=;
 b=sVmcP3zk/hUtp7FItVCkvsMLCwWBuVtpOpxcmTbrgYS3E6xFZwgkck4I7In1uc8NW211DoJEQmqNViUlbYTGdp7pg3ukp1uAMYcd0UlNorOtf3M/x5IjNw49GmRYtUaHrDTtRxVJ0PtXRT8XW7lMeTmbQLT1yAOIkPxLLZeerXc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 3/7] net: dsa: do not open-code dsa_switch_for_each_port
Date:   Wed, 20 Oct 2021 20:49:51 +0300
Message-Id: <20211020174955.1102089-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f71b6bd-a288-4859-4998-08d993f2126a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861B46DD48223291CDEDDD2E0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: amX+zMlKAjIKQ0bgT4HG1Aw7XmzRWijuJjP2LtBHfkZ6Qmtdk9G78qErnmeHBBbBg0B7klNHY89H9FlwM8F4bIMZ3wVSi2wJ4udL5xxYAabVJ/9m2gaZATAEMhdV2HxO2cJRVfZl7neDj1u7TwdPtXm9jYsPk2Q4xEBzwCz1eDdDmIKRYK/gMbC/T99kroU4Iqd+qQsvlg7Gp/y99vaa/fOSesX8uUlmyB5eqIlrs9WQw+Os6+8D5WINNACKv2y7Tb0Jki3IfCML8Aqf2u7sf7+BPoWbTBaaTeeP6cwQWhzb8zZ64E32RO/9wzPTb94SKdnJzbGZILw1J3IrRHAWwH+Qu0ewaG+RzEbnyDWaNjn4QXxoBKzJD03c1spMSeLt/Ria6q4DribEQsKN5cTF9kZA9Q0DLfLlHRyeDNUnfjpfvKVHKVdugVDa3fF6ZQC0KbpP2NK2qOuqbejQbbk1kMjQWNnUdnAmODyCMvR3Eo9JlJnW8F36mKJVTU53v9vx+YtkxTXCBPheiu9YdBnUVU4foVmNVoCOKDa8Gq5BbOu8DDLyXE5BkeuLRQoAVykO/ILU2RaNFDpFh0A4UHhxTSDKv0UbEJFyjEne84LBdd6yT1K/xSZzBMjYxH9/EwJn2cXYDywKPxuIi6/sF7Un7jJXaUHAonc+IH+1BhSSTJIYcz4UNZg1RiUoI3AEeQgmK01L4uHhfDmDTo8mGI+Vjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b5c372ovZ5PuUpkL37Imem8WpN2c7ZqSad178lAZgqtypfOowy+PdZjR5YYe?=
 =?us-ascii?Q?Lwaumcvfbbhwk5FV6T4Y9oOkym/30lWajGfOfa0FiPbPNn2vELoYmpgxIafg?=
 =?us-ascii?Q?Ndww0KTkP84LUgL8c7ReOsiNvOra7tJxDtDMfda9ZUz8Yo5nD5ftmvTbVxNn?=
 =?us-ascii?Q?+GHrXOH5pxJiqPFmdyJhBsIDtnTrJcCnnectP1SzFHlPxn0Jfs08Mh4nIS61?=
 =?us-ascii?Q?6lpu22aWwHFLUF+M5m1wMdHNn2MmU0SxsVcIgPd7KjUiDfw2dFbKQESxwlLh?=
 =?us-ascii?Q?0+4GTfwyuPNq27a+YJFtxhGHJ+L+NAxUHUSQwTuq25ftfWfXQ34hsYVsPJn5?=
 =?us-ascii?Q?QKcORgJSxlA1TSRDFH0XMTHq5TzgStuVf/makK9unPgDyZ1g3FonQeC8rkiz?=
 =?us-ascii?Q?NcpgUo67FTHzOpSJbRSdzHi82ehrjCJJULwqz8ha0nlBNXk+eVV9bgPaNKzr?=
 =?us-ascii?Q?fU7fXOP8JJ01zPcXQclytnnfRBLHG8b8OtQWqfNvbeAKZM03/nX5hMPb2STb?=
 =?us-ascii?Q?J09JkW5XYK3ogKAwVgmw5gvyKpguaPt5/AOfFoANbCcC/kc7dh3sJfef1pFK?=
 =?us-ascii?Q?DBnPKjZ0y8ZeYy8kGRtOmOZyt+btrznHL1HFxZQYtongUdjRom4+UQ7RFWdR?=
 =?us-ascii?Q?cMvcC6Vfyw3crdRFT7AGAwvvAqm1rKp29jtOBTY4FY9ejuTUadjzA9mx+hgM?=
 =?us-ascii?Q?X7DeDYUukkvQoEGH6wCiBBrKGgpCZaXn7IZGtw0XftOfCRxvt+UYnJySr746?=
 =?us-ascii?Q?EXdiPEAk8Gs/KphBvF1D8GSWpNCwrYqITriSS/qXOSoMenKcy4A0+fk6dE2j?=
 =?us-ascii?Q?6lr+2Ks74ImwE9h4imUlHEAB/CYs3NCXcnXxKer5JaU+De3+UieDgxjULLZl?=
 =?us-ascii?Q?TxHxZakB7TvUXLmL55t3ZikNidvoYYi3jeOjzW+1qeeHg3f6+DsNJf78X3Y4?=
 =?us-ascii?Q?sI279L2nZHrFNZGHknqAl6nz1oyhSw4j0vPgVwO3a6fZ84NPiRgXJjxU+vAj?=
 =?us-ascii?Q?qiYTiyWt2vgLq81NUD0IYIC/QQKhihLDZNEoNQ7mUfFrNfJtCLHSWhjsanAI?=
 =?us-ascii?Q?5Z82q4YCvl1vyg1kR3eT+5PMsCnnSe1Mzg+jciQqhQjCpCBa8wEvP2tChrjq?=
 =?us-ascii?Q?1lvYS5Kv3yNClp9rj59fXXQP3pn4uRCPtUjNuv6tkL4Xb1KbQP8arzZoNSkC?=
 =?us-ascii?Q?zNg4nm39zFqXrPfBCo1yflWZKeu2QD75LkdG17wNUuzbBYlDxeJ+Go8uab+x?=
 =?us-ascii?Q?hbg7ei5PhH5SUfGMIVfkEQCkPUVeZV/dW/cDSR9hBuenUKMeqnexIL3seq5o?=
 =?us-ascii?Q?LC+0BetkcU0doFFMQOrNMZEB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f71b6bd-a288-4859-4998-08d993f2126a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:15.1589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFDL4rBx/9HOua5AiptZAfGVc8SGWvc4idByyvtT1/FyVoMotRAt6t5t1NczV+Rl10csPENQs62sLxQ4X7MiSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the remaining iterators over dst->ports that only filter for the
ports belonging to a certain switch, and replace those with the
dsa_switch_for_each_port helper that we have now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1c09182b3644..2a339fb09f4e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -399,11 +399,8 @@ static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
 		if (!dsa_port_is_cpu(cpu_dp))
 			continue;
 
-		list_for_each_entry(dp, &dst->ports, list) {
-			/* Prefer a local CPU port */
-			if (dp->ds != cpu_dp->ds)
-				continue;
-
+		/* Prefer a local CPU port */
+		dsa_switch_for_each_port(dp, cpu_dp->ds) {
 			/* Prefer the first local CPU port found */
 			if (dp->cpu_dp)
 				continue;
@@ -852,12 +849,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	/* Setup devlink port instances now, so that the switch
 	 * setup() can register regions etc, against the ports
 	 */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds == ds) {
-			err = dsa_port_devlink_setup(dp);
-			if (err)
-				goto unregister_devlink_ports;
-		}
+	dsa_switch_for_each_port(dp, ds) {
+		err = dsa_port_devlink_setup(dp);
+		if (err)
+			goto unregister_devlink_ports;
 	}
 
 	err = dsa_switch_register_notifier(ds);
@@ -901,9 +896,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
-	list_for_each_entry(dp, &ds->dst->ports, list)
-		if (dp->ds == ds)
-			dsa_port_devlink_teardown(dp);
+	dsa_switch_for_each_port(dp, ds)
+		dsa_port_devlink_teardown(dp);
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
 	return err;
@@ -931,9 +925,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->devlink) {
-		list_for_each_entry(dp, &ds->dst->ports, list)
-			if (dp->ds == ds)
-				dsa_port_devlink_teardown(dp);
+		dsa_switch_for_each_port(dp, ds)
+			dsa_port_devlink_teardown(dp);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
 	}
@@ -1180,8 +1173,8 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp;
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds == ds && dp->index == index)
+	dsa_switch_for_each_port(dp, ds)
+		if (dp->index == index)
 			return dp;
 
 	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
@@ -1522,12 +1515,9 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 
 static void dsa_switch_release_ports(struct dsa_switch *ds)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *next;
 
-	list_for_each_entry_safe(dp, next, &dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
+	dsa_switch_for_each_port_safe(dp, next, ds) {
 		list_del(&dp->list);
 		kfree(dp);
 	}
@@ -1619,13 +1609,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	mutex_lock(&dsa2_mutex);
 	rtnl_lock();
 
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
-
-		if (!dsa_port_is_user(dp))
-			continue;
-
+	dsa_switch_for_each_user_port(dp, ds) {
 		master = dp->cpu_dp->master;
 		slave_dev = dp->slave;
 
-- 
2.25.1

