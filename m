Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB3396140
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhEaOhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:37:43 -0400
Received: from mail-am6eur05on2090.outbound.protection.outlook.com ([40.107.22.90]:62668
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233550AbhEaOfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 10:35:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+yAnc74zxRl03p83g5z3k7zFO8vTN65xeTZWcT7X98t6oAUVEKbPT9UFJQUJ6hKijN9CRvLOYqQSF9pl1xOamy9tCsCJx/C6Vh0oxOXiQYFn567fuQG8PzH1TMV8fNRPluktDuKMcJN5reZsbVlJrR6laVaCOYJMeMFTFEJw18+cDmbQYzu2z0XAc5CBzxXtHRkG/kQYCm0liQBexGQm7EvtTgqBWG8AwiBpNWCeSK3v/C/7XNNr8XbMjZNmf2wmyzAx045I1gO9umSxSeymVqWWqwThKJKICD6S1xPp+Er45gOcExSgWVJonHkHxBbiEqeeEG7RqOqWlkac7eGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8bp5vVsYCRNZgSkqz9f+7TdXrBaQ2RlSE6aJGIpDuw=;
 b=gZGwfonV1hZgeJ15FTkyMhbF/rueppwUwkYWODEqDWN6ekHcuhelvH/nAR4Nyj1hjjOt54/7KXI5DNcg9wI6pN4akcGL3iH3kvI+W9kUc9FD93OnaxH5k99k8efuOTBqu5MF3c1U1czNeZmVSut15LDF5MLxFgmpcYR2Z1PjOvjwRw83k0QH+LCrj2+c2ghC6mo+DXtbhzgGgRMknir1M8y8Mtmw3ROMujeZ4VP0tdZWol9OpfpBRRFaTuf7UN6F684LGzvxQw3Ryy3G991P685IJuD19ro68FkjwooKG6Y6g0t1ctPyHlXJy8fuNcxTLGDD1DHx/jHBFH605Jb/3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8bp5vVsYCRNZgSkqz9f+7TdXrBaQ2RlSE6aJGIpDuw=;
 b=qS4C/z1UObBrKxmSoE/iJJsBY928igPZcKyBk8+QPu5NVNHjm+PO8un3dwtYdTLuhIUpaE5ee11nLlJL+gGQWAn1NxWLGM1JS9n9FCtOgY842JNHeeBPRrCpnBlhg7xfsHpnav00kVOihHko1l1juwYQXlBXgv027+StGQZjDhk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.29; Mon, 31 May 2021 14:33:25 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:33:25 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 1/4] net: marvell: prestera: disable events interrupt while handling
Date:   Mon, 31 May 2021 17:32:43 +0300
Message-Id: <20210531143246.24202-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210531143246.24202-1-vadym.kochan@plvision.eu>
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Mon, 31 May 2021 14:33:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32f730ab-07ba-49e7-1d72-08d924410c7d
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB045940C71DDEB6650B6E6385953F9@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+v8XAz257chLszrR7uCWRKoJjWxquN39g5uf3KLQL48B8j2ffcWQcFnNX1a7vvTGMlw6R/bg0dmLTV21OFA+/TCuxD+s3Oi8Af8uqladj0kIJPNJbXgx7b4gLXsOXQcSc2Z7Fn23tGRb6b5Rb1hayZA4feG/mjMk9YrSFE5QBIWc9UEB1l5cmGI8Q0828Y3V+Da9mJQ/hEM7Qqj3pNzDT8/8vTJ9gWq1JF8/+l2CAbW2Du9l4jy0BeYFgE8zACspZVl48NZ/JTipnk/GIFrk4uI0u1KoXnDWWwMRz+FUlR8oLEasrzO6y1XGtBIj6QwM0CndQjo+4U9vcWAcnTiDRJlqP2bq9i4dZN6Xple+W3CMfUD6Pko4Ws7U/zuAlJy8Re8KhaR5sQJzUveLSx+Ftk6KZB7QRnrBmSQh4IdwLKiHoweS8k3lcx2yp0WWChYlLn7/f59tuHg+6C9sIkzbVxmOuhP7ib/7ZNr2+5JZO/y66NlXh9mampACYMP9V0gKMgk4eIEDYf0NOK0XDPWLpDs1ZhZAep1DKMeeSgNti48vRjpU52IJwQsU10/HjgI0oSIWE2WNKTbnJpmciw/+wONjmiZOnjjlbvx/ybC5LNX9btZio21Ghrvn15rn+vE06ITswSwlkKfXXm9rtGm7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39830400003)(136003)(366004)(16526019)(26005)(5660300002)(6506007)(8676002)(2906002)(6512007)(6486002)(38100700002)(38350700002)(44832011)(316002)(186003)(66476007)(54906003)(110136005)(478600001)(66946007)(86362001)(66556008)(2616005)(6666004)(4326008)(36756003)(1076003)(8936002)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4RKS2OeSbbS3Px+4l1gLwhw7nylltweimQLlazQIodvp1aewnG+5trQ4SJ29?=
 =?us-ascii?Q?4fLQmLXRRHUEDAfgXuiztw13UY5XMC6jRkXJIK0ZM95J8C1ws8+iGwPJTZD/?=
 =?us-ascii?Q?xsuDL1AW5NLM8A2dnM9CqLp2NyF1+A770g2qxWzHqly2D/JfFwX5cgp3W3Fu?=
 =?us-ascii?Q?ElwPUMDY6HhN0A767hDR5XHseS0OO5sOWaPocrbp1sqsJwm/UM2A/g+Ft7we?=
 =?us-ascii?Q?aKl+pSIM6WQxjXDJThKbv2jf/46giEeWRG1Be+gPqjNb2PQmXyVOERzqWNfQ?=
 =?us-ascii?Q?6rURST76GC71FYIJanS/mFeKCDQOyarNS1nQMLyRROXgYz02/UeMMBTUQTJv?=
 =?us-ascii?Q?jIE9dFbuThx8aj7vRp/4k1AnYTxNOkfPyeuKcWaqlB7LVtaSsJuK7KssfZfM?=
 =?us-ascii?Q?ek+WsqfexpkIEumC+EPGb7gVX8KZAsicbl+SZ4/HROl2VfUN7NPgJSEz8NTk?=
 =?us-ascii?Q?iYjRRKm6vyBYtgLrnlc/2ezi9EJIOjNHVDbNx2/ivX3dicys76dpQuL+i9tH?=
 =?us-ascii?Q?8pxFiSH9qDVExQ6vla49O2SLIbqio4KA4mbn5sBSWggNs9MGkp/5g6ktRPYX?=
 =?us-ascii?Q?SAPKFHybNslVqt92HtzRxhBUSfCVEaLi2jITs1l7CePesNYqipymM47fi4pp?=
 =?us-ascii?Q?J5wytcBUvFlZXKgp5zpnv3uCPt1jNBXeMVovojie0uesJ75FzN9GS9I637+D?=
 =?us-ascii?Q?0PO5zYIvtvJ8yfsn3i6emFG4AKyqoucszt/uz3/yLyTelMSedXL3oM7r1Lso?=
 =?us-ascii?Q?UfbcvawWfv/TZF6ZkhkpJO+7B4IFhcAuN5ASzoAcM9FvGCRYc7NJA7pDMBv4?=
 =?us-ascii?Q?nEGi85Bpwr3YCcOkcpZZG/S0YHb6Iqam+LRSw/tAPSyv2YzcmGOXwI9ooP+C?=
 =?us-ascii?Q?NzZ/GqaR5LKhfylCOX/v7t6qAabBwysln1HgUYB5WB74Pac1c25t6Q+SbBhK?=
 =?us-ascii?Q?uDkTKyXlGQorxTrg2LUR6N6ObNSqkZe2R8Afe9PSqkwVqREEM/H8jaNOzw8K?=
 =?us-ascii?Q?g/ui2HCHEVRgQWx1uwxFihuJfarDwCwg36jNi1Hti7h6JKTxNHhpWqFddIcm?=
 =?us-ascii?Q?7ly2Dvr+P9GFe6GJMr7Ve0mDl9VMvfzh9VnY0SFsyvCLsHpeFKMnSWXNKMbc?=
 =?us-ascii?Q?m11qWtbeJZ/QPbmV2/rBaUH5y8OHu0kvOtKjYozEPA4P5TtwUYyxAQmzQJPR?=
 =?us-ascii?Q?8qE0gCruaufqROx8wsweSWws/I8fjWv8WjglIPGdR9sil3dJbTPq5+cC5OSU?=
 =?us-ascii?Q?BmOC7F8iO6EK65A3QUT+lvcehLNQDJIrz+uh08hc5VJ0eq75dnRCuNUauRDC?=
 =?us-ascii?Q?ijhlAlKmhhvnHZSMb+pW332l?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f730ab-07ba-49e7-1d72-08d924410c7d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 14:33:25.2684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLiXfCy60gbRX4twWPZjbtku70zeR4CZF0QqI+/85DRXZ6XkaHmxQAtk1YckXPpCOuQBvSCUfNxu7pI6yw1m1TUVPts0yyl+gs5QrYGeS/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There are change in firmware which requires that receiver will
disable event interrupts before handling them and enable them
after finish with handling. Events still may come into the queue
but without receiver interruption.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 298110119272..dba6cacd7d9c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
 /* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
 
+#include <linux/bitfield.h>
 #include <linux/circ_buf.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
@@ -144,6 +145,11 @@ struct prestera_fw_regs {
 /* PRESTERA_CMD_RCV_CTL_REG flags */
 #define PRESTERA_CMD_F_REPL_SENT	BIT(0)
 
+#define PRESTERA_FW_EVT_CTL_STATUS_MASK	GENMASK(1, 0)
+
+#define PRESTERA_FW_EVT_CTL_STATUS_ON	0
+#define PRESTERA_FW_EVT_CTL_STATUS_OFF	1
+
 #define PRESTERA_EVTQ_REG_OFFSET(q, f)			\
 	(PRESTERA_FW_REG_OFFSET(evtq_list) +		\
 	 (q) * sizeof(struct prestera_fw_evtq_regs) +	\
@@ -260,6 +266,15 @@ static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
 	return PRESTERA_EVT_QNUM_MAX;
 }
 
+static void prestera_fw_evt_ctl_status_set(struct prestera_fw *fw, u32 val)
+{
+	u32 status = prestera_fw_read(fw, PRESTERA_FW_STATUS_REG);
+
+	u32p_replace_bits(&status, val, PRESTERA_FW_EVT_CTL_STATUS_MASK);
+
+	prestera_fw_write(fw, PRESTERA_FW_STATUS_REG, status);
+}
+
 static void prestera_fw_evt_work_fn(struct work_struct *work)
 {
 	struct prestera_fw *fw;
@@ -269,6 +284,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 	fw = container_of(work, struct prestera_fw, evt_work);
 	msg = fw->evt_msg;
 
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_OFF);
+
 	while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
 		u32 idx;
 		u32 len;
@@ -288,6 +305,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 		if (fw->dev.recv_msg)
 			fw->dev.recv_msg(&fw->dev, msg, len);
 	}
+
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_ON);
 }
 
 static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
-- 
2.17.1

