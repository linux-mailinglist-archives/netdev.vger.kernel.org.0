Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE53E58F3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbhHJLUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:44 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:44879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240064AbhHJLUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6GAAvQU+jEenjjICdH1CvMtDMsbJCU/CC7/Lpm6xeuqGk0xBytnLy4FktulQwfPsyJloDdwyyszZmIzsubEctWUSt0rM2Au8kAPVHZKq/mK9x3L38Kd0caWlgQPCwA+E7sJNGu1Qn7KpgQeBVS1fA5axOOewQhN0iW6ujuh6gizYbS2Ee2270fisNTCesYs+ajqJDGCXkLZNSUGMAsx1p5LKw9V6v6QswTxaLGdfdyUDpV38ICC7ceZC1/FW5LoyBBViQp4RcjAEX8dmECjMr3oNT4mbmjE8hstlQ/5NspGPec6vH6Vw2T3S69mAomiSuTTKD8Gz1MRrKGUyIz50A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdkZh0euA/RLFHFJHDmL7Zu2JeKDIQF1GF4gLqvHI7I=;
 b=Zqnecge5SF5ni6mQE9mst7RXOchNyxV/Fs3H8bZpXojFvZHAVubyb/baEgw7W6mGB9jL9cxb4/4RJLNXVE2hu7tRgD5K56IaH3+TesJTjl4Whp/jT5UkXsn3tyon+GG42zCGxEuOnV4ry28Yhrso4LXZWwzKzyEo2OJs18Dud15UPL5vzJPRpd16DuvgM3YxBnbFHCP4QCMXNqvVmMWPNu2ccwpvPVVaPaCmzxG3AO6AVAc+3bnLYdjzZiJ6pTMgOJ6T0FuwAHLfwrjKdC/svcZ5FP3pVgpBOwW5cECeqGL6vq4wNiCvg50Vu9ikhbn2Iqiome/NCFHCjm22lMxViQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdkZh0euA/RLFHFJHDmL7Zu2JeKDIQF1GF4gLqvHI7I=;
 b=eSS7Mht+jKF5glA6bXZra0g+2yzSoztY0Nx7ONa7Oq66JwQVbwy68gcjC997CV9nwpzGjY289wEU+rPPHi0wE45cHBfJcyYWcgftKsOA/hvpZO6bV6O5T9dodJ6poi91JA7vyFwv6RcDHYev8MYopDJuzo6tF+FPnmKSO17+i6w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:20:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:20:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: [PATCH net 2/4] net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
Date:   Tue, 10 Aug 2021 14:19:54 +0300
Message-Id: <20210810111956.1609499-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
References: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0007.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 11:20:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b19a552-f3af-4973-179b-08d95bf0d11f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686E787E93E0F4BB4F30661E0F79@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwyM5/LK4Eb6ywj5w5cxmvhaB5J/9WkmTS83Far+ljIIlGNdxZzF5//7ybS3pJRUqx/uhoseYZ8Fd8CrHFwwI8prjf5Pi9aKfCPswkyw3WnWGkDYUiPPN5ZnHdd0lMC2i0XU9lvKlpdERGR2WbKkWHoWJqY+OMQUeZKx4bTlXvS4OR7JWCPGMNKEAhVAEiDGmbczwGgJOs1zORzm4VuOnOovWoRLLLUt7RQCiNHJr2DVj1D7R8faeQirpXOrtV/UMLEwyMTv+JzHYac2EExGhTZMST7HwfJ9UQR77dOXufShx84cKtejdRwihzOddd4WSFVjrzT+qFLVeebN40nBHXY7tV1G2dZLHsx5cDjfCmguHnIiSEf1o3o5BIbDhZ8uhepW0ib48yGnabMfrabhUU9fEKjd+3eCbuuxDA1uAEGJkJUPIQIAodHK9QmDZsX5G3sr1JPU+PSSWNCkQFvV3Sa4F5joduskyDwSb58QZb8uyJUKCX6hRrBqY7m29ET5gOOfB77JUqMUPktI+reBGo5s6g/WhER64YgaUIT5wHS5/h2N+8ci6pGimgNJSK2eXrPW4W1wmksBGXCx9nz2ag1A8XfF0C7AURzKJmQrsfEJhKwR/SBv37UMTwtOpFtQMjkJLZnqTFM+86iwFZGSr6V/XeCDKsQLJOcsftIvE9t/LK+bNF6j6pm0+sh+EKUdaFLywOdVVhJyZb7WZAzWYPOy7t/+58DHB/Ubai5NLDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(7416002)(86362001)(6486002)(6512007)(36756003)(956004)(44832011)(2616005)(8676002)(316002)(4326008)(6506007)(66476007)(52116002)(66556008)(66946007)(26005)(186003)(478600001)(38350700002)(38100700002)(2906002)(1076003)(8936002)(5660300002)(110136005)(54906003)(6666004)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JA5R9yhH36iN4yFfEWHjLdsaYkk6X5cbnCgHUGHoEBCEM27j2UFkXIGn0gE6?=
 =?us-ascii?Q?dXLiJn6Pvs0LUrSxepJWsug787VVb3ApNYf1IioXkjErd2gDUxEfhykjE8/4?=
 =?us-ascii?Q?UEzzx8fRJnw2g0mmJyvGnLz9op0gOe7pgXwFXg/sxt8A9C3rRcEBJuAZOwTU?=
 =?us-ascii?Q?4Jha3+JL0cy6B5kx8CklpFyYAwyYlbk2SFgAbecV5MNpMhkYvzkRSNt083ku?=
 =?us-ascii?Q?RYjxACAwJTaKUqlFIhMnYPliJhCLOD8F1HmWTx5+oR4Sj7s0iCpJ++jHYgrE?=
 =?us-ascii?Q?5TAfz4TySIwpYJY5qrCqBd+Uk3L+7Hu4LwluPQCSDNqcw5tPCCcC6uWwWrW4?=
 =?us-ascii?Q?QWOmCa/IFsX6WPDwCouPb7TJsWnr+hCWeGK2dhon0j6dt3r9K65FtnJlgqM0?=
 =?us-ascii?Q?uzqXu1SoOVzTGswP1S2gbDruxBZ3OXCXoH/iOIDIO9MuLIda0VxjIMu6EmIU?=
 =?us-ascii?Q?qkpF4I90dfD1mGMU6YII4rk/el2AXRs2kA39Vhij3VxBsieZ7aQDoglSYwOE?=
 =?us-ascii?Q?4cda+Ka99RtxejhuDcz0x6ueHutnbfsc/BTIltdWTkAkxf1g4okiQmPilXvJ?=
 =?us-ascii?Q?HAtu4lQoCASq61mmnycFfMRcMQHNY0PSqNAmdhxtDJ9cFmTobj6ygrqYGtPU?=
 =?us-ascii?Q?TuPJV1tAL0myvpAqoAElyNgj6bR5FRKpuF9nifgvyvRUZ9EMjf1MvlqFWepR?=
 =?us-ascii?Q?O5uMAsYc+1UAtVHwjT9KIbJOfEh/TxYrRs1USz8J48Cp4HsEMjX7gsJDF0K9?=
 =?us-ascii?Q?w1YLLDfh23KNgj2bFPfZlamFrkxku2VHIbkgMie+NwlYlkaJSjHdeg0df9HA?=
 =?us-ascii?Q?HO6pDe52x96WyP+rT6U5iKXrCBsbKt+PVLYSbZNCMA094Xp033rR4vgKXp4A?=
 =?us-ascii?Q?zN5UE4crMrTqqQzWAyz2IX5ctnnlxoDMOrOs8NB4fdvhHZpMZU2NUx6yjr5w?=
 =?us-ascii?Q?6C0+iE6pZJxuPHodZTqln0dIjrF5YMUV9SGUjx2el5peYxABlMEqSJqEmb/V?=
 =?us-ascii?Q?P5vzt8YX9vM/tJx7cdShyCP1QxSIGnGD4g26jtqWPDF+gL+6I7qBtF1VXM/3?=
 =?us-ascii?Q?GgZrud9pdfPs4030tQsj4lhnzu3VKKqDNpbt3cyCWzZ2s6cT7FpNjirIiAe3?=
 =?us-ascii?Q?Z2C8mxYn7h14rcIhcAO7vigkmeSI2NYhsVUrKf2Ei1mf4M0qgrDFVxsYqbe8?=
 =?us-ascii?Q?oGVdF6oeoQmJjQfD9ylbNaMYKNZAdelp2DcfRyTmrKwK8lLYSTgCgWtDOtKm?=
 =?us-ascii?Q?X/f4s7IZsJuQN5JuK2b4vZyoy32dQxF7oN3Tx1c1ZJtsnFNKoLpPgqiI+Zif?=
 =?us-ascii?Q?5D+o6GSb/Y+ybrFz24SXWVCM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b19a552-f3af-4973-179b-08d95bf0d11f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:20:10.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SGjEBlluf5UObhIW+q2GZoG6wyeWXXOUsNm1nMHNdv3XENUvCZWV/MZklhscKs4s80z0OcSyo/Srt8YZ0v1Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
multiple netlink skbs if the buffer provided by user space is too small
(one buffer will typically handle a few hundred FDB entries).

When the current buffer becomes full, nlmsg_put() in
dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
point, and then the dump resumes on the same port with a new skb, and
FDB entries up to the saved index are simply skipped.

Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
drivers, then drivers must check for the -EMSGSIZE error code returned
by it. Otherwise, when a netlink skb becomes full, DSA will no longer
save newly dumped FDB entries to it, but the driver will continue
dumping. So FDB entries will be missing from the dump.

Fix the broken backpressure by propagating the "cb" return code and
allow rtnl_fdb_dump() to restart the FDB dump with a new skb.

Fixes: ab335349b852 ("net: dsa: lan9303: Add port_fast_age and port_fdb_dump methods")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lan9303-core.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 344374025426..d7ce281570b5 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -557,12 +557,12 @@ static int lan9303_alr_make_entry_raw(struct lan9303 *chip, u32 dat0, u32 dat1)
 	return 0;
 }
 
-typedef void alr_loop_cb_t(struct lan9303 *chip, u32 dat0, u32 dat1,
-			   int portmap, void *ctx);
+typedef int alr_loop_cb_t(struct lan9303 *chip, u32 dat0, u32 dat1,
+			  int portmap, void *ctx);
 
-static void lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
+static int lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
 {
-	int i;
+	int ret = 0, i;
 
 	mutex_lock(&chip->alr_mutex);
 	lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD,
@@ -582,13 +582,17 @@ static void lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
 						LAN9303_ALR_DAT1_PORT_BITOFFS;
 		portmap = alrport_2_portmap[alrport];
 
-		cb(chip, dat0, dat1, portmap, ctx);
+		ret = cb(chip, dat0, dat1, portmap, ctx);
+		if (ret)
+			break;
 
 		lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD,
 					 LAN9303_ALR_CMD_GET_NEXT);
 		lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD, 0);
 	}
 	mutex_unlock(&chip->alr_mutex);
+
+	return ret;
 }
 
 static void alr_reg_to_mac(u32 dat0, u32 dat1, u8 mac[6])
@@ -606,18 +610,20 @@ struct del_port_learned_ctx {
 };
 
 /* Clear learned (non-static) entry on given port */
-static void alr_loop_cb_del_port_learned(struct lan9303 *chip, u32 dat0,
-					 u32 dat1, int portmap, void *ctx)
+static int alr_loop_cb_del_port_learned(struct lan9303 *chip, u32 dat0,
+					u32 dat1, int portmap, void *ctx)
 {
 	struct del_port_learned_ctx *del_ctx = ctx;
 	int port = del_ctx->port;
 
 	if (((BIT(port) & portmap) == 0) || (dat1 & LAN9303_ALR_DAT1_STATIC))
-		return;
+		return 0;
 
 	/* learned entries has only one port, we can just delete */
 	dat1 &= ~LAN9303_ALR_DAT1_VALID; /* delete entry */
 	lan9303_alr_make_entry_raw(chip, dat0, dat1);
+
+	return 0;
 }
 
 struct port_fdb_dump_ctx {
@@ -626,19 +632,19 @@ struct port_fdb_dump_ctx {
 	dsa_fdb_dump_cb_t *cb;
 };
 
-static void alr_loop_cb_fdb_port_dump(struct lan9303 *chip, u32 dat0,
-				      u32 dat1, int portmap, void *ctx)
+static int alr_loop_cb_fdb_port_dump(struct lan9303 *chip, u32 dat0,
+				     u32 dat1, int portmap, void *ctx)
 {
 	struct port_fdb_dump_ctx *dump_ctx = ctx;
 	u8 mac[ETH_ALEN];
 	bool is_static;
 
 	if ((BIT(dump_ctx->port) & portmap) == 0)
-		return;
+		return 0;
 
 	alr_reg_to_mac(dat0, dat1, mac);
 	is_static = !!(dat1 & LAN9303_ALR_DAT1_STATIC);
-	dump_ctx->cb(mac, 0, is_static, dump_ctx->data);
+	return dump_ctx->cb(mac, 0, is_static, dump_ctx->data);
 }
 
 /* Set a static ALR entry. Delete entry if port_map is zero */
@@ -1210,9 +1216,7 @@ static int lan9303_port_fdb_dump(struct dsa_switch *ds, int port,
 	};
 
 	dev_dbg(chip->dev, "%s(%d)\n", __func__, port);
-	lan9303_alr_loop(chip, alr_loop_cb_fdb_port_dump, &dump_ctx);
-
-	return 0;
+	return lan9303_alr_loop(chip, alr_loop_cb_fdb_port_dump, &dump_ctx);
 }
 
 static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
-- 
2.25.1

