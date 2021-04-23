Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887E436968E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbhDWQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:00:40 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:55911
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243191AbhDWQAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:00:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBVgaroNesc0z/Pib/IOZS/TtdckGUuq6XTScjdIEm/iUBqd1Sb5C5AhAVp7XenPlCAiyaLMDJZ7s7mM7BNYpJFBC+42ux3QVgUPi8KjJUNh7B+fsE0y80Zj4RqyGZdHZHUtUvpv1ekTmyt5IUHHKQCEBe/RiiByqrRPM6k9+UTJv2HwzcU6XTj7BIGRxwGZ3qLMU77VxHeTV5Sj75yzoxaxcC9w6OsezfRpaTrH7Msd+SZm4yXvVbfsq4pCSUIM41K0XqLACjC41CGz4jHdC80CZlFcenEOnx8/Px9cZCXCvO4kjkfHshXohoZ8pszep101yaYTqV5RrbemHGbFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f93B8to9WRvGZ85Dvo2jUmUOm6m26h9Kxbwk+2gVPCo=;
 b=NQq/Bgnp7EhiyYnjgfcbHUJkqfSDdzbvd+UcnVlloA8SXLvOkC5vefx6y8zCKgIj584JiVVwXf8+0wpOYlnZY84Vr+YtuWzjTL0YR6PhtEDVz0metIm51SOeXDtGVkt5a3AxuP+R9h5zQlOWKHIrBSG0HFQhfAz+iJ4BW3lV/SQPjlU91uw6AHrnFAQGo8xBAOGNc4nNL08M1kPJTDQogxuoGsUIBBUe6yTkfN+qBME+/qRK7gY5SRgv46L3Iiqq4YwE2OefDg1tt6uIwx++ClT0QvUqcIgErf8uEG9WfqNQrDu2lFcW0mi8jSjIYKr8hGASVznf8qJMcSGAOhdyAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f93B8to9WRvGZ85Dvo2jUmUOm6m26h9Kxbwk+2gVPCo=;
 b=lT9NhiMBCbx2kS2QxMwO24UBI5GD9aknC39ofzsIEVTe/VU5Hdc66l7QxTqex++lfw9ty8CFrMK4N8to0SWY3QHHHJz8ADkpaeuGgerPL/AQG1DkhVUf1DLCg/eZFcRpo08gVLwGiiOUdGRpQlpGaj18l9pdCsBL3j6PYvDOG8Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0187.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 15:59:56 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 15:59:56 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 2/3] net: marvell: prestera: disable events interrupt while handling
Date:   Fri, 23 Apr 2021 18:59:32 +0300
Message-Id: <20210423155933.29787-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210423155933.29787-1-vadym.kochan@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0147.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:20b:127::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 15:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88bf2f84-5a0b-4db7-fce1-08d90670d72d
X-MS-TrafficTypeDiagnostic: HE1P190MB0187:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0187D3B6311D360C8052B1FC95459@HE1P190MB0187.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJAing/QHj0OBuabGdbJwxMPOdvgPwvlfgySRcUTKxyDTJyi5vgP43lPH6vk15SiBZss9OBfhV14BZ3uquVTuQm4L37TxX6yfjdk5j3VTrF5A6US8YRnd0dH2ujTqFp4FOMk1vVIgA9U6KQyf2zULScCf++0Y+eJ9oWwn6T65s91/GC/Xo/1A7l3FVNcItNT0hahbq9uzSVwKIJq1EPQVgZhLEmgtTVKBdDj2kVtajbXHga7ybOPentn1XLoDDpTUfPV28UuoZTEWOwcwalQeXvTAdxIIjAezR7/Y5POCK3BZ80b3GDHuR/ahNstouaAJYZhdmNy5vWuO4+mdz+Ej9xEU/J60EjCOB6PmYJllQSOYodfkZFQhkjzA572Ig0ThshUMXejAyTpNL2htUN+Qj8huG6EHuBLqeRAHI793RRz3KoNBBat1SNiAvVD6iop1wvKP64Dtf/Hm0g9/wDoze81EZq+n4uxRiEpFjoEdJreiOOoZ3g9egL4Ay1RwhsythIbDxpLN9uWZgY6LCoZnqc9LrleCqLDqUVVx3qSA0ZN/NNDlUGq1IL35Q+a8UtwJIPzhip8WQAlXx6ZC3ZYC5Jqk15fNk5xPEbjLkS7Uu/bHH3hNMWQQFAjCrABXGCaLZlzR8Pyj0/5JPxlI8riKGScRc1eNlc6FiXtG9ZEnZ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(376002)(346002)(366004)(86362001)(66556008)(66476007)(6666004)(5660300002)(4326008)(66946007)(186003)(2906002)(316002)(36756003)(1076003)(6512007)(478600001)(54906003)(2616005)(110136005)(6506007)(26005)(8676002)(16526019)(8936002)(956004)(6486002)(52116002)(44832011)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+OCeZweuaADCzO11sKqQhoW0HUCrU41R685ter5M79Mf0t0FbX+IrzhYRrLA?=
 =?us-ascii?Q?EzQ3duIepMlkvrcgMDr4wDeCd00ReCewFbipyS3YYTYFJee9ZBaXd+AFEG3p?=
 =?us-ascii?Q?U/7HThkjNpjxTbdPib/XCeZdcqPT1BuyFaUfjPfD9iyls3nA3iNZHbmnOVJf?=
 =?us-ascii?Q?yHHXw4SCyKO0RE6Manci3eMOFdvuZagTakhb7UXgdHQsRihd8Etsry3l/F49?=
 =?us-ascii?Q?zQrcuAwoAKEkQgky35zLIOBsqGANWyV2fu+ZS7Im0h72okqLKUwBmlpO7WPF?=
 =?us-ascii?Q?joOJFhN+CcT1nC9+4X3LwtLQNUNdcMDmA4HDOYvpkFdzSBdEe3p0HO57777h?=
 =?us-ascii?Q?rlE3ZcL1GdNeGtfRkyC8vYwH+t4ohYRDHUDQFVTFKwzED2FkLZaPHo/ZBr2F?=
 =?us-ascii?Q?UXyoVea3K9UtqT2hshkrzUCRUQhveY49cTydbSeOZPRe/dw/GPCajtt1W4Q7?=
 =?us-ascii?Q?jAiCIhWBBwDIU/yrT4hgkWKT4bYDw9BdJsoShl0IozEEqO/UHvYc8AbgfUSD?=
 =?us-ascii?Q?NiTAnbgPAJ8AT9kKX/mXsxnBNypp++W45uoBQbV31aiy5tz28hBJp0lGBgo2?=
 =?us-ascii?Q?pBPCAKTQpvc3TgZw/9ewrr3cInSLQF99EZzaEVbo2aZO8/NpD+5ZrNN4QIxf?=
 =?us-ascii?Q?mkJ5mABdhuU4iMy5K/rsUMjYhCpGLTntpMlJsHoXTNZ9+r4Q0dvcQq/2z89k?=
 =?us-ascii?Q?hbV57/Us+ZLknR+lXNQ8XTxOTIoS/qB3jC8G5ZcFfvyNzQdNaNmRdx0aXa3A?=
 =?us-ascii?Q?JAxz6zEXHga+SfzYW0G53fUa0/+54SrydLhZ4vkzWDLJ66TQhPIji+rL1rZC?=
 =?us-ascii?Q?n4zZR1yUD5VOw1KojDSXNeB6Owql0IxS1cgOGWU+N/omJk8GrqEDKmU2atoi?=
 =?us-ascii?Q?qeT2Pt9Y0i5TDQik3NKzYodV+O8W+uatUfF+GV1MZ2UgIpWtuNy5/lQFf0OH?=
 =?us-ascii?Q?LSGXftwX15e8t4c2MYJjPK8JKlsfQnk/32F921omXU72jUx+H3KU+Pf7fdDQ?=
 =?us-ascii?Q?aQptI0v8T0kz3VYsyFt6o6q47fCDGMGz+iv3QV8HJF1CBgKEv1H/jQg/5Ksh?=
 =?us-ascii?Q?MvvJ+ilebpCDNhlDXPfFYDaqWp4m/vk+U/S05OVBngGlg1eVUa6W6V2BSPFn?=
 =?us-ascii?Q?qLZ6KMzMxQ/ER3+bzD52fev6nN82lGVBoEzsONuW0nUtM4UiNXMzOyX4F1lg?=
 =?us-ascii?Q?7eJWHiz40Y0yhGOtHubR7Y/ZZL8MDtkIUwrpIGiVOKG+aIV6UVWtGpSQk9Rj?=
 =?us-ascii?Q?ZntoVbOnPC566pBQ6/tsggSH/HxW6PNziXx0x5hm9h6wOOAQbTLi8hpkbAaH?=
 =?us-ascii?Q?SVjQ4GjMmy5cfug3tgEVMGXK?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 88bf2f84-5a0b-4db7-fce1-08d90670d72d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:56.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wronJiVEo+su80G4H2u+vWbfq7gBi64XFmZC4cFUZ6afmOGd0v0PXNPlrA+gn76W1ZqvNhAn83zS+ElII/L0eHAPnV+0/tuJYJgPDnfhRSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0187
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
index 80fb5daf1da8..5edd4d2ac672 100644
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

