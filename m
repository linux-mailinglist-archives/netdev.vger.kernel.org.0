Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3538B352
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhETPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:37:12 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:8577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234023AbhETPhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:37:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbIQHbI07gB11Ee4vg6o1ChxiBbtzCXpsdSNGqH/6UVY+qtc1rQFSSs6BkFGjfeKzmeTN/0R5m4Fu7+ZR+t8XdNDRnOi5dqpkIPZZVW2v6Hk6ZQ/G3DSEa3xDj+aFyYnUvwCN7SkjR6Blj8f5euZQzK/gZp3XQlIcIYbUCd2Pn8/ht+bBT934hQ9us8dB4zgpq1XpNiNPU4imz+xOQ4TnaIoEgIQUH8F7Q1dGL1B7d3lGwPQBjKgFsgVy4ygnC7vfz1UBdMXSASzP//mesiRyQ6TkrarAmpTXLqQergUC273rp26YMfNaFksWBHLV43xFLeccED/0LtYQ3197/6YPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8bp5vVsYCRNZgSkqz9f+7TdXrBaQ2RlSE6aJGIpDuw=;
 b=Pz4AQ5DVUW4EQ/DsBBwxkl/gQHIyf22mijitGMUlnb2ey+850oA/c3YAgwYwyDW4jiISBJ2MzzpVhsMOsN2bgW1wCjyp6KFIb4dFbWFjjGWl0F/p0zQj5RN4oCIbg42TF92MTiIrcLd92u3Uog35/aGwz+WRavlJl3yaiTvwS/PIYaqissaEe96/CZQje2OI1H0i5uPuI0K+qpptO08feYml5p8dm0sKHCKi6XWqNZqXwjUFwxjtuRWA6FTK/r1ePy2H090+YPbFqZ8uklQ3p8CZnbDOPxB68gFxinK04Mb+cYCAY0Lj0D6wkSCCPMBxDtukED1oDKWo1wIGHGGcIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8bp5vVsYCRNZgSkqz9f+7TdXrBaQ2RlSE6aJGIpDuw=;
 b=eGC6tV9PBn+RRlVqWY7s2eeTu3qN4/qUJ6UCXLJLHBCZO/1M2g6lLNydZgR5o3k5T2YVbYDo3tMFfsQk0wDx672O5yU7WirMChuObyXmZo4qSaeAHA2Y9cWJjSSaK1ZDnlyiEQwRc0ghn63yEgioELY3RWKEC8c6LemKDRb/K2A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 15:35:44 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:35:43 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next v2 1/4] net: marvell: prestera: disable events interrupt while handling
Date:   Thu, 20 May 2021 18:34:57 +0300
Message-Id: <20210520153500.22930-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520153500.22930-1-vadym.kochan@plvision.eu>
References: <20210520153500.22930-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM4PR0101CA0065.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 15:35:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69640ae9-e925-4825-dfe3-08d91ba4ee5a
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0268E0F8FDF84BA340C8B7D5952A9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nm1KnyCflYzypfgPiV0Xe7Lx2eZst3gxttML4Eg+ipAmIu5NJNP6ikRm7pSR2fDk+EkLN+i40PjqTIOE1rqu9yZyNxEq+kNBxhIBBZKJJV4LE2Ru6e+mwriUplUw6XXKaYpK96qSQibzkmxGXZ3T3suL4vcAJbeU4d35SERIrRVDOQK02E0jT/egSJfuynSRg4n6qccYTpg2Tn/qRr1PKklXTfWxIpA1Mkj5kawCajUqtmK8C5het/P2g3VSdwEMwG2n6GyEhQJANqS6tCWiDjXu4OFHp02TpF3aiBN0tP1rHzf/InUWFhJvatAoSN4WEm1Di6Us+rpi656Bx/cdAlnH00lLcYnAQnK3dzOxsTIxXd3B46t8R82k3j6DROlqn9w5Hi4L89RQZRntSMtqTWLENy+wRr3U9IdzKNzKyzCOijC0LpEfaFZMLMEYmI5ipJAUhkz2X/iVO6Z0rA0UUSI1yD+nWatisai+MqGGrtmUgO0r9hF7OYYAvef2JwA6oF2bo93VJxNs820UIteieUV+jVo4VPr7moAcKUJIT0XwSoxouDHEhdbRBGXx5P7Kmt5QgeXRn7EQVcmW1awUm0/AdQJxFPmS0F9n4s/WuTO7S/bM0zuC5tvC2TGTA+AY5rHUREPXQqEkqJ59LgVpMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39830400003)(346002)(366004)(6666004)(26005)(5660300002)(4326008)(6512007)(66476007)(8676002)(66946007)(316002)(66556008)(110136005)(956004)(54906003)(36756003)(186003)(16526019)(52116002)(1076003)(2906002)(8936002)(38100700002)(38350700002)(86362001)(2616005)(44832011)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UP+ghVJOEQwWwEr4FFjKHJDI9ej+JDRqjIJ+tjyMRbfnBsC6zrgWToZoAAw4?=
 =?us-ascii?Q?tENZVAxs9ptdC/WJ3/7lUO7HyQzYx56+eh5yPBxt/xKJ4K7QKwXJ2mgYRFM+?=
 =?us-ascii?Q?7L+ErLW5EJh6Rgm4DB5bX07+NAUEOQLbS853vVifsnJ1ywjzM5kFXCgrbhEJ?=
 =?us-ascii?Q?7ATUHzH+PIGwqsS0rRE0J7uGiXBlQjsdjbBQgN2F+SNPaWKDCWYslUQhpay+?=
 =?us-ascii?Q?pe+dlO0cOklLs0M6ZcVqZUNWBtJQdDGztysiSP0Qxz1ADToMcOD7nO2dQF00?=
 =?us-ascii?Q?nkvBnI0Q3shnjHNdRfmtx5h6KyWLkn01JpdAFzQAULIK3hQujzbf3qBdfTrn?=
 =?us-ascii?Q?8JsKR1fTIA7Um5Kc+xW8eZRHTIyTk41p4tVARJ65Xd6LRpD+AyHDHzPX7tKM?=
 =?us-ascii?Q?cs/FfwchqCz5rU+PHkhh7YZ6phGPcB8ShYTygK4R1Zjnyl+O4aZU7f5nqdSk?=
 =?us-ascii?Q?/OUZO/vzKPGgyWrUykFSbgszIYW2DSaV1l3fON2W/zVIOtlClFqvvta97Y0n?=
 =?us-ascii?Q?g80vvKWyX1EXPmBtSu4AGwbjUEBO6xjsNnh6q7u/AipEg5QcGdEfT20YQMez?=
 =?us-ascii?Q?f+C+H+GpGVFcZhmAKpd0EOcFiuNmZITQV3D6RN1hzE5KiK6ezywwHEXUODdW?=
 =?us-ascii?Q?1Hso5FJVSO2QUM50Ns5p79uSpOf0Uhx4zD6ZE/msrL8TK13CZtncZrRK0+uC?=
 =?us-ascii?Q?hCcs1fTbyuPvhMCtApJPHI0oU3j1vGIYia+0Dg9USbE2V4tFD9JI9oX5Jm0q?=
 =?us-ascii?Q?zySbP4tDVTA+/MUWQmVaHI3TLlU7DgN3xU247l+/OSyT3U/5+C/anlVrdHjD?=
 =?us-ascii?Q?2Cj+KSCTBLkW3m6PeUZVu5xcTbBJawY6IDxwF1x1gjiCg8U9qYTPbmbEHi8j?=
 =?us-ascii?Q?LM2l2ikCazdu80PherD9UJrsz+WIcq5GujsJ0siFfio5Gy6K3Nrno/uHHKbZ?=
 =?us-ascii?Q?EouPh+4kJTXYjNDlWIvIQ6r6Vrqo+zNNR6Z9ffDeSdjSwuricu2fWBZ21D9X?=
 =?us-ascii?Q?6xNXEuebnfVXWcIu501awC3ZeI7zeA2LNHOgShRCywQ6gekp/nzYHKmCuN3x?=
 =?us-ascii?Q?w6yhp7d5m19dCzYQHVfe3UCQPIn5nu12B7SGZ3Mdcr4rxk6Oqm/3WjlIpW5+?=
 =?us-ascii?Q?GkFw1TtNmAmSq6pPmsVjtqbYuZ7tRxZ2OocLsaBj4lSDIxfWLY0ev3GLhLYx?=
 =?us-ascii?Q?Gix9Pmz45fEf7xXMeTeHJWEqRUkJt1N2QBBqcEztl8OyZRF4ypCRxk1PCQQ2?=
 =?us-ascii?Q?dITyBnr5FXzqrrdwYv5bK6O9uMIl5sxoJGb/LHiBjBADUwETdtLYPUGa8cuV?=
 =?us-ascii?Q?smjGYoCFESEPJ2Sm3VD8RJJR?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 69640ae9-e925-4825-dfe3-08d91ba4ee5a
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:35:43.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lozxAP8HOtannqZE9pDajfmKFV2CVVf20UEwVvjpL7BRSdQQGIualIGt0c3TCj8X+IEoX96qA6aM6G3jQ5CtIP83YfeOHAAEfOZBAWsufto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
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

