Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00E4389113
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbhESOgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:36:14 -0400
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:4932
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347905AbhESOgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyOwio0FSdTLTgl2XTKhwe1ON0/03A8InmPh7+lTx0XsHxa75Hu49ThFTVz9Ur55paQJf/9x0p/Qe/NeRSVFqMEset3OE18FglU5d5hIRZXg7mTskBCosmuT7OVrjnGIZoUnu1eBSFtS9mILhrmBL1yGbQ6Yt30lUXebBdx7qWDQLiIP69lLj2uX9daZvWbQCMVjhgBH9hIJYZUt0wckzEfgbseQ8bPs3ISG/zp21wvJAhLHxr5rNbusA8yhjdp9CSoI57Brai24oTt1wz6NHfSFJd/0XKCobxB7MdKSPfmLWpyzmVc5oIv92eMu90ThvnnBbwkYFpeeyO5TZzw3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4YhyQ+luXaCasg21ELxIVG0PGOo2ZGaFRKq4gyC204=;
 b=m3BzEPVOsXr5zaFrLS7+VvOKelxZaA7UGW2oaEpsP8SkDlBfaZ7c5v88MnjJV5GlsbK+Z0lkUBrjvi1D7GAFGR41rfLyQ/9+s64iBHmhz2lvH3Doc+77Vwu48TkfWSQ6Jnh3nh4dm2vGvxFajpY3MQVm7IZLPv6zILF1rSuk4voYaaEv5MA3iEUALUx+tmbsCu5/wwh1CjRjYmCu57IqpBZgOCp3A6MQnEsUaxIRGApqEHAgRHuqmlqNeiH1fczFyqPVU4l+DDbgaxNN6gIdbLQ7ZwAUl163dFMWdtHGRRRvDfCChEEq0W4pZ7zppbElXEN9N+mMSLzyLIwWXgUZrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4YhyQ+luXaCasg21ELxIVG0PGOo2ZGaFRKq4gyC204=;
 b=RMMg6ikHQfT4c4jx2dx0WOKsWqWM0yapQSpkDTWX1AR3oPVNXYxLSbytmmNJSeHxgahbGVb0y87S45NeAA6O6LZJWVgUdS2HkJN2a0+NvI2wN8rrdPhUqZx9sjHSHq31y+83PRq6VT1tJ30p1CUZ5fSwxVI+zhJQ0qY+vdw8I1U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0058.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Wed, 19 May 2021 14:34:43 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 14:34:43 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 2/4] net: marvell: prestera: disable events interrupt while handling
Date:   Wed, 19 May 2021 17:33:19 +0300
Message-Id: <20210519143321.849-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210519143321.849-1-vadym.kochan@plvision.eu>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 14:34:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8099301-5ef1-487d-6683-08d91ad33de5
X-MS-TrafficTypeDiagnostic: HE1P190MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB005838CF944FFB89BCC4E2CA952B9@HE1P190MB0058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hS/MsLZ2JLqzHCB7oQkWFT9pCe1A/m+f5My1zogQxdFtQMEEiZXCe5Ok32tteDDb90ttL5gliDLyCF3BQlck1HQ/Dfr47CVO7YAWNNgMSXHcEz9GwXE9GaiW7aqn2mmGqMvVqgeLT6W6MzwSqDoyu06PesKjRPCWaf0dTbL3DecpBLNWOT97Pkjrm697mbvK0IFoLn82nuII6gsUkzXZgq8O7US8JnEtV6nh2oh34CRS8I9Rd+dasMiOkuXFtrVKUunxTGfcBDA2xjoD/Kww3ru4dZ+6Jn1sF6WtwIQh11gLwbdKvGJYD0pK/IaqMiBX4xLeucamEBQCvHaHOVsmd3eS/FvGp/2+OljLpQYHevcRUWjSjSkkORGcQGtFD5IltRttDJrEgSS7oXQjwEC9ALm3k6PjzwCRI/3I7diGOVawpnaXQBLJdn6OfEG8Zm591/LWwrdST6d/LjrVZiXbE8dwYFsgGBVLDpBFBCYhvQ3WomCW3k13J/MCXvv61ESLyemQRzcTFnGkmM2YT/yKaUtE+J0ajvpZbbiACcp668aDWpronwkLEeD8F3xde/PaL3sRTg9j7hC+xhvR79ziwAAo7kk3ZJ4O5MrT8tqDut3uz7UGMk7J0Sxe2AkUyAJzHfRnlZEpEr2k9SYLanJQCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39830400003)(136003)(346002)(66946007)(478600001)(4326008)(316002)(38350700002)(38100700002)(52116002)(5660300002)(16526019)(66476007)(110136005)(66556008)(186003)(6486002)(54906003)(2906002)(36756003)(8676002)(2616005)(956004)(26005)(86362001)(1076003)(6506007)(44832011)(8936002)(6512007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LJ27sp0GaJ10yKijQsYQG8qqvKVDvZ4EXiIQNe76xLgrSD63ZhwIZO7ruByQ?=
 =?us-ascii?Q?3K/kdLU6dCKMLmTnfccHboXBK7xzMUTSxsg5BWMb3FGR7A5lEK3iKOjFz5dY?=
 =?us-ascii?Q?vV1U0mm+45tLeqgxq4uyRwjLt3knGOxlx8cstNSQ/KAKpTAUH/9SvOrDsUCA?=
 =?us-ascii?Q?VcpCYuteOPhhRwAjz7Zxvu+4K/aBFZrILUp9548KAJ65W/VDd8wOMVCCxs4O?=
 =?us-ascii?Q?D8lcu8Jst3otGrlfke8FaYnKgaOLz33rMPHrl8Hs+QKl0exzj7dXPBJuFbhj?=
 =?us-ascii?Q?RwEID2gQQ5BF29U4jSikRO3gHOWl/0CfdZmmFxVwaehEXSmnWbF3wzUHQfR7?=
 =?us-ascii?Q?8VClSEnlqIvi+h0lFN8Q2/NNKkL34Rfk7lr2SSoSa/HksPhZ6su8PIym4ysu?=
 =?us-ascii?Q?ligD0nReENNhyWZOw5rSKj+pGIPNWT/fyi0zLK18Dmm6FTCcEFSYq8ZdpCAT?=
 =?us-ascii?Q?EOHJAHZeyxLJOx0VD0XSh0K9JyIqCsMToNE3aCkGxVAoP8hAoQ+lfyg9+G/b?=
 =?us-ascii?Q?Zh+RO02OdkuA6NHnvGvtD6ao3+1MyiloxiG5mNP+DMb12+aJpF9PEEHgxZqz?=
 =?us-ascii?Q?ecP+5o7ikKpOwtl4ZcC+j1BIqhh6kMcD3qrYtHUeqFldg+h5VAQB5MpoPeCt?=
 =?us-ascii?Q?DEOTZ3XDQDhEI4pc0HewLKPkLmPLgfqqb28WyUOmCe0bciadTDPZoGn59rjW?=
 =?us-ascii?Q?8y+kG8QgJKF8ZdzmYHnk7WT8ibBc0qj/kL3jOAWgyyn0SeeNb3EFoi7H3ECO?=
 =?us-ascii?Q?H7XIIU8p0EA7ehY68UKxDJojMLvjSAnAxmFwEu8T1SoykkeEEYsujFBUT0OW?=
 =?us-ascii?Q?kij3hYugodkG05HAvIsWqByBV87BohBgV4bQzhvXV2yf4o1hvpsNI5QRb7dF?=
 =?us-ascii?Q?Rg5VzUgT6uFi8iKt+Kpf2lphK5Xte/WNCMKvsCPwzwZcrztdqxUp3BZW+RyI?=
 =?us-ascii?Q?JkCLMSJwrmJPhCOeBVIUf84OxU0EYf2utfHJQsqRwZfM92CdlLn0q+ZwJlWX?=
 =?us-ascii?Q?6u4CVlJ+Hrm4LLJjZuyB7ohWWj/R4JDWyDhofOVBBj6rQ1L6pOPVocsag3Wq?=
 =?us-ascii?Q?MiQtsmyYUqF1qLq5853t1z5XZtrSfH4Jey4dsJi99UIHdALma1tNx/PtyzRz?=
 =?us-ascii?Q?KHAp8TaJ28qoLuqTS7ILfkGRJO/Ct6ib2E4WZKUzT9j0EmQalL6A0nt2/0As?=
 =?us-ascii?Q?pXCCfr4EV6gTrm05fl6hL2eIa4rtsKK4uxfjH/l/vooeiAnvgs6BGtS7wfz4?=
 =?us-ascii?Q?kw9NpURqoRU5NK3zWh0l5eAY7povODWmApRUdcmWW4BqPkBDq5PUPAkPx6Jt?=
 =?us-ascii?Q?FboOr6zMLMeRnAzFgpxUw0x1?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e8099301-5ef1-487d-6683-08d91ad33de5
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 14:34:43.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wglerWqAqbswrIG9AmauUjXiIQT4mARUdKcWXudYII8JHAVW5AWWs9CXwYKk5jLgoaBtgR9866YMaLpZ0wJpYtXlPelVafe504VWLacPU7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0058
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
index d384dcacd579..7ac045e82fab 100644
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
@@ -262,6 +268,15 @@ static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
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
@@ -271,6 +286,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 	fw = container_of(work, struct prestera_fw, evt_work);
 	msg = fw->evt_msg;
 
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_OFF);
+
 	while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
 		u32 idx;
 		u32 len;
@@ -290,6 +307,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 		if (fw->dev.recv_msg)
 			fw->dev.recv_msg(&fw->dev, msg, len);
 	}
+
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_ON);
 }
 
 static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
-- 
2.17.1

