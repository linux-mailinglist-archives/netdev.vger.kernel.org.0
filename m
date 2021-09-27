Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36C3419191
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 11:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhI0JfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 05:35:02 -0400
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:44702
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233587AbhI0JfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 05:35:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB/jtikJDOpUY67nznnsWIPtsImlOJgYHLL38u2tGrr26RjeGxYS/dJQ47doHz+clFlBwOyZ+S4uPROzxNOd/EJvT9irva7KzARcndxGHagImx0KlwvVk3/KXippaxlDP3gAyGOymPvvlXwbjYlJjN2zoI72Zl33ytY6pgyWYvPRWoAHjl41TbJW/YHDCJj3EC0KUCeCVdGLGJOAA/1OGxyBOSCnEU5UHs/4WO2+HXpkJ5j+SG5bCBYMYDc7SDx9jxTU4wwwFKEo84bS67ly8V+pkBUuhyOVAkNtpyjKQvuhRPuKPOtHvYyNCzLVgbyRp87Y6oZo0h2cWnLEVHPrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=g3x1h2RgIPyjwTEp8lyf37ZCTfk0Pu1+VsBcjmLN4aw=;
 b=oAzIDBpTlb5TLCYbLVj29ndeKj0n1l9Wq7dl7xJ21m9irEjlZRNLInCsGJ+mGYYLLd/WIDGC5xOOq6yPn5Eyu1KP/D+Jr+VwI9nzH7gQ8sTOG4MDUX7x6QT7jRYtZ+qR6iH/8E/LdDUjJyi+XhXnafU5ONOxOM6gIsSpMzJMmCV7yaLmyJJHAWWhdFkmsDIfYfE/dHEGQFKrqLdG4VwRcLgraosDvkj48ww8c0tATFvnRrN/nNoxYdb1kgJcv3U3ah6HdJVBFPmDCdBYtBXiSXAhXYx/U9FTj2coos6yG3jHKD5gOJSvbOAy46ZqBLnlbqVtTdcDyxPKRx+57HyUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3x1h2RgIPyjwTEp8lyf37ZCTfk0Pu1+VsBcjmLN4aw=;
 b=EjHPzZgZaPnKJAeI0Gd8NmsM+16lVT/fnKZh0O+sra5G03m/MtzBK3q/Z/c+0bNSW5UwhESU4YCpf72gNDif26uDsuO1Xcg+ie0+s4855tDS+Q7b5aQipLbrixv6y5hlJ2tNSzYWmlvCWgC90iO+ql7oJ9+u7O+hwe54eKKn2ms=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR0401MB2493.eurprd04.prod.outlook.com
 (2603:10a6:800:58::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Mon, 27 Sep
 2021 09:33:18 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 09:33:18 +0000
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangbo.lu@nxp.com
Cc:     yannick.vignon@oss.nxp.com, rui.sousa@oss.nxp.com
Subject: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Date:   Mon, 27 Sep 2021 11:32:50 +0200
Message-Id: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0129.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::46) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (84.102.252.120) by AM0PR10CA0129.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 09:33:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a96c0c1e-67da-4694-0935-08d98199d6a6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2493:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB24930150E8D18E54C3F67249CDA79@VI1PR0401MB2493.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCDx78bxFJeqPTG/MAze7IkyQP2dNrbTYKZLOgriM7cWDoNEfWx4kLNrUm7QnQsf4ZGaML9TJvs76nh49v3NCjy1vZJXnYfKsO7LYhlSM2bLcY5RTovmqnqmNkkFlC9E/WIUrTCkZBo+CK9GHGOoMQR5yCuJfZ5+SIgkiFwz1ilmCgHf9Y7O70Z7L0VK62cM4WhsE/tqiUUTzNTW4KwjLiHvODWf2CL15kf3hc4k3wHa/WRQtFEOO1gbGc2mVg11+ECdft+nI74uuqNQ1bYLr2Rbl10/QagbMboaI8uHxVouRyav7vxaslS0i0Df3mEfnOipQHHgbhUIxqZlZJkuCm/ZyaDvkE6iw/KFX93M0V0arxqqi67GayAvx+ja+AwBu1b43NUsf1yPMl9u5/ruHrRkBtJPUWNbHrlxxrBTgi+6U082blCD8uxbwdlrXdPBz37S3KAaa1IH+EkfGZuKZJ4TrpLmY9jt4IZiofzAi6jm9Rls4kQdd8+7+FitF5hK52ZAzGEJSjD2iEcp/FYLxztZ/HMDdMuwKt3TV7FGoOJ0y+owu3jqdltNETJjnyux/Q+BGZTDZhEtV+t4/bEHggpIxaDiQhs8TT8HWOu3ka5z4G2gw70vOxegMbtNtvSng6qyuev8YoNJFncfWL9t7zicHeYpDHl9Q5EtOZ2vVW2gjFM+OXWPDivklCnvko+egdJdQS2dONVfhPc3cFgtqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(26005)(6486002)(44832011)(86362001)(66946007)(38100700002)(66556008)(8676002)(38350700002)(66476007)(1076003)(6506007)(8936002)(186003)(2616005)(4326008)(6512007)(956004)(83380400001)(5660300002)(52116002)(508600001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rYctlM/ChoznVRqpcuZCy90zY9QrAavFpnoIVHEGUxj9GNGEFo2f6tc8VTII?=
 =?us-ascii?Q?/9axHr7M5NjVfsq4UbdzmaTiHeyVGn7aevesZqeShRgSIV526aQ6fwBfSKcu?=
 =?us-ascii?Q?9sp14u7aI0bCOWFayePzEypOqb7yz1yxO27jMwZmdiwAH+Fcj2qZgWQxQCCN?=
 =?us-ascii?Q?wZkyuM8lQwn/5fANWqxHagZl3ObTsmt7ryomNtpdJw1xWt9db746owY06BwV?=
 =?us-ascii?Q?RSTOiYO8jSrp9Tgml5Aj56J5dVOAPhpEnk+O1l5lRT2EFVTfQxOlXjkOz3ID?=
 =?us-ascii?Q?Nfy4WHUJZSEtP/sowI6YskpmAiX8d5XyRbFvdw4xoGwa3qHQI7EmUidlqeLk?=
 =?us-ascii?Q?rogBPAKld33tDhKYdW0hGzD+hXDmmRbnAXgIQJOzmGUKH29b5aT3SnpEgjVL?=
 =?us-ascii?Q?P9k7MPDhhAkmyA7eZWLX+ID4aNWW5Jf2AivboHYISXNOCII6jIwkutTWR1tK?=
 =?us-ascii?Q?EZeQ8AzgXlrsLDYyAo4LYxRILjmgld4iaY+hxqILBXqtBjicaKmsWQFRkrOy?=
 =?us-ascii?Q?0Iw7u2qepgboH04gzJaKBc+KP8t+quShkxEzghGxZdGZFATwIZU3XSAzs+rA?=
 =?us-ascii?Q?XgprlfvlcauVWElEQcyrszy2SzN3M6qRN6QWXD+GBAPMi6Td2pSQGzb33XdP?=
 =?us-ascii?Q?cj3uAtjoJStLCLh2tuptKBrU6HtUNjDj4Qv69GuP2CS8o4to2IVLK+C3UkL4?=
 =?us-ascii?Q?qf46dss8fwUaNXj5vMWkcb6/P2eaL3z7XwW1M7+3/dRkkIvsEePxX3P3Rl/P?=
 =?us-ascii?Q?qdXEJ1+594T5r6YB78O/NiG8OANOmEvCR8898XWFy9aAN1/c5ZN+lk+abrg4?=
 =?us-ascii?Q?wWFWxQLrvCISalz4vJa7rPVi91F/hxLXiDPSEwDZWEcel5pc6BqkaNq5eq54?=
 =?us-ascii?Q?wI4ZNe2cptiIAOAP2CdcvkCIfzy108531Lfni5e/232a/UAcx7eAKKSY5cn2?=
 =?us-ascii?Q?E1bLa9pYBEQnB4EtYqZQeWT6xxt61WGbl4lpbdbaOB9KTN+caz/OC4pgtR+R?=
 =?us-ascii?Q?x90DrObFycyYfDbn2xMr9AXnc1kG5NsiFW2FyjIukOqyYO3pcw33AcX2do/s?=
 =?us-ascii?Q?VijZO3uDhlUcyoiu5NvAgkV2WWYCnhi7Wd750xF+ajVeVo94mOYD4l4h8x9x?=
 =?us-ascii?Q?Q9aGJ/pr/Xefo66yu18cQ4nM8La71tmHuIdqJSjQq4sSAmAZ40mln1oo8Lsd?=
 =?us-ascii?Q?wIgXXFSX0bg1zrHq5xCvnro2juhdPdwHnpaF713IZjzIq0kHZpFWy178BlMn?=
 =?us-ascii?Q?Ht3f5mHTX5Z8iWy9We9MbT2hanBOOPA4ibL13dQyVGMv/eujAiwUxW8QlwXV?=
 =?us-ascii?Q?beJpzuBT+36mTAUeyr/nSOV9?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96c0c1e-67da-4694-0935-08d98199d6a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 09:33:18.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZyrZ8y/DznMDHXNUsRFDDJaMT8J8k2bAXNnAAqZD+5OCslJGl5tjaNbi1L4OpvQLp6grPp441YoBs6QhpOqgxW7rsL095wmlIWWm4n2vPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seb Laveze <sebastien.laveze@nxp.com>

Add an IOCTL to perform per-timestamp conversion, as an extension of the
ptp virtual framework introduced in commit 5d43f951b1ac ("ptp: add ptp
virtual clock driver framework").

The original implementation allows binding a socket to a given virtual
clock to perform the timestamps conversions. Commit 5d43f951b1ac ("ptp:
add ptp virtual clock driver framework").

This binding works well if the application requires all timestamps in the
same domain but is not convenient when multiple domains need to be
supported using a single socket.

Typically, IEEE 802.1AS-2020 can be implemented using a single socket,
the CMLDS layer using raw PHC timestamps and the domain specific
timestamps converted in the appropriate gPTP domain using this IOCTL.

Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
---
 drivers/ptp/ptp_chardev.c      | 24 ++++++++++++++++++++++++
 include/uapi/linux/ptp_clock.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index af3bc65c4595..28c13098fcba 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -118,10 +118,13 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	struct ptp_clock_request req;
 	struct ptp_clock_caps caps;
 	struct ptp_clock_time *pct;
+	struct ptp_vclock *vclock;
 	unsigned int i, pin_index;
 	struct ptp_pin_desc pd;
 	struct timespec64 ts;
+	unsigned long flags;
 	int enable, err = 0;
+	s64 ns;
 
 	switch (cmd) {
 
@@ -418,6 +421,27 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		mutex_unlock(&ptp->pincfg_mux);
 		break;
 
+	case PTP_VCLOCK_CONV_TS:
+		if (!ptp->is_virtual_clock)
+			return -EINVAL;
+
+		vclock = info_to_vclock(ptp->info);
+
+		if (get_timespec64(&ts, (void __user *)arg))
+			return -EFAULT;
+
+		ns = timespec64_to_ns(&ts);
+
+		spin_lock_irqsave(&vclock->lock, flags);
+		ns = timecounter_cyc2time(&vclock->tc, ns);
+		spin_unlock_irqrestore(&vclock->lock, flags);
+
+		ts = ns_to_timespec64(ns);
+
+		if (put_timespec64(&ts, (void __user *)arg))
+			return -EFAULT;
+		break;
+
 	default:
 		err = -ENOTTY;
 		break;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1d108d597f66..13147d454aa8 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -223,6 +223,7 @@ struct ptp_pin_desc {
 	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
 #define PTP_SYS_OFFSET_EXTENDED2 \
 	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
+#define PTP_VCLOCK_CONV_TS  _IOWR(PTP_CLK_MAGIC, 19, struct __kernel_timespec)
 
 struct ptp_extts_event {
 	struct ptp_clock_time t; /* Time event occured. */
-- 
2.25.1

