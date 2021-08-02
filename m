Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9963DDA55
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhHBON3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:29 -0400
Received: from mail-am6eur05on2133.outbound.protection.outlook.com ([40.107.22.133]:56059
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237755AbhHBOKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtHe2xsIjgMbGS4W98BqsKfa8dsvXm8ogXU4j1nPDJ+y8fUq2zhIHHDlTgzeDxKnWh4REzI+OLEXdEoP0mSMn4WMyjMQCQPpD5bME7PqIJ1FxBKMHEucRXT1fKcyOrXbAH2zdTNu1IDYYKTyvMcFAS7tbY88ekKtvMi4/ypCQz8FosL2FvaYKC4fGanTzKquUHDUQM/UR2B1oEFObciwcD38GeVQymCdeSQ1MQtLV5yEod0DjPSbrQXaWcfD865MAlmEqi8Qt5q4f/ncBS9KbM/8J/mUYCB542IhMjLNvpPO/e3Whd89er9P08gSJnT39j0IloPufnM+RWHOP95Vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=fDzVFjkOxC3bzUxSEdZG2k8M2HPmVqswSbFiqPyALs2Anq5KZW+NngxQSIvHKboyuqEjvooULBwxco/ddwHpAWd4zDxpULId80iIOB0g6RFNbKRqI0HfTLr5aFhJo2+BO70YjBBww0TRQ8TZyVXC48A6Ktx5QL4HxeV7dhigxh/s1Rqw+vr1zUpUfTXT0qyWbV0qFrAusqTjo8YjDk5FETFzd9pkMnnCK2hvTIUfPpzpr2NesQQZgrKc3Zd6nfa1l+BRjq5TpeRDZvuZkdx5zItgYiCdRo5sXMNj3p3DJcYhKwjYbunBSXWW8n8Qqss+79IHiYzbOSPehyD4B2F8Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=eRdHMNj2YeY76X7kOwnYCyMFdx2ORZpUoN1UauBwJy+6DVNePw7MDodz0Fk54iIjrbokubouo7P2jPq0bysBVK4G0EZR29U+A7PhSEFN2KtuYpmDiQxMka0GEc04BsiOh9hhA02kSwVhQt4sXzTdCTJx9Panr5ZPMAKoIhQmBBc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0306.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:09:23 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:09:23 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 1/4] net: marvell: prestera: do not fail if FW reply is bigger
Date:   Mon,  2 Aug 2021 17:08:46 +0300
Message-Id: <20210802140849.2050-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802140849.2050-1-vadym.kochan@plvision.eu>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0066.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 14:09:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c28be3c0-9593-4519-0a47-08d955bf2138
X-MS-TrafficTypeDiagnostic: AM5P190MB0306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB03063F05F62C8726802CEACF95EF9@AM5P190MB0306.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4kiN8dCHMMN5i/AMszGuq+qTHiMGALXoGgj6Opm233S47r87wWBrCEdf1J6R4nVXgQx1r6UXJ2ye8JELxZ6gPORI9Zk7NV3VwSVWk4YbqQnrgJ+S8zsUxGGtRAMzl3x+D10QwrxPtARwulznRFW2mJh45f4V9vPOaIowWBo8QxlN3irqhnhi7V98dfV3eNljtPqHIwf02hVnRPJzdrTpB22pKZIzEpFwgFzvI9Kg3m8hRTEbz00phn4wO64wWb1c/XyVaMsiE/qKHdXe6UkYq/K+EKgG6F5u3zC6ESdtSq+y/NM2IWXorZElp+aXyY/FN3fD2P++xJ8NYHsSwwGu3n3M3IfGB5ujkP0kRLXZPYhDksbDYbMBEiCjXZgNHi9epfRXIltfaa1OMiytkvCzn4esEgRVshP2gMJwKCjXxxU5vdIJ9vG7Ue4Bnz1tBF2GXdqaFb4gf7QtKEwjTVM6Hbv7qqEeFP+QPtyk72Nn8cXkDX9FKLj97zSUTBowqAfwQYQr6RAEDlHtPyt8dIO4xOBZ3w39M9qfzehuJ75rPUiuXk81WTQAoJu6DW/gameQiYTQTi7LJ0lIP0FbYHPuurVWbsyA/7OMST7mRJAFedMy9bG1/vpsSFyQ36AHNb6TZXyEXroTBCgP/6TXecxPE2DGHTMWq+J22WsP2dbx9BAhuJv3iJlHClND4of2eQadrXMFGHQBZOFcUPQEsCW3+RVAxHtG6S6hWa8rqdxaTg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39830400003)(136003)(4326008)(44832011)(2616005)(478600001)(8936002)(956004)(186003)(6486002)(5660300002)(86362001)(66476007)(8676002)(6636002)(66556008)(52116002)(66946007)(1076003)(2906002)(36756003)(6512007)(6506007)(7416002)(83380400001)(26005)(110136005)(54906003)(38350700002)(316002)(38100700002)(6666004)(135533001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7jbaTM93DjDXrFPfigqMOo0INOd1uQ0wAkcCh6DexnkrOCxFnjzvsBALfE+?=
 =?us-ascii?Q?4CmuCEfVZilUjlmBdp86+YeKqLllWLBbatc4PVD+vi5doIb9xyf3H2kTFQKx?=
 =?us-ascii?Q?YFyTiwgZynuYsF7tWixSWXTluyiNodPMVWqUm3EsjRBK+CWbFFumkuXQQy+V?=
 =?us-ascii?Q?7UFxZH3r5+8nJZ4nIjXuzdlSXUozhPnv1uZE95BnkJpZzKeDwqmYYGbfFEFL?=
 =?us-ascii?Q?qriwLjlt4CFKCXWWapZTd+GgI/HylxOWUgGOsG39T0sGscHVagMAlVbd4Xmc?=
 =?us-ascii?Q?ges9xvlZXlMUUvyQvo9GQrq7MKAkru0xEAKTIeL8upoJvaGTCZ38hAjAhFDG?=
 =?us-ascii?Q?UXXlpLcoe4BeKxrCjPURaphm/6JBYbxlnmrI2PWBUA8wkauScUlBtxcEJ6/p?=
 =?us-ascii?Q?X2oJNTsTD88oYdVjK0j6ONrWLhWtyl4NctsShQ2NKn1Qyd9pzNTKOfAAHePU?=
 =?us-ascii?Q?pvLL4fxsJywSbNWP4EEHgjmE5tC79XQcX3rxWz/1tYgKXIhjyhRuhC8Tr6XO?=
 =?us-ascii?Q?7XhtEWecRPEPPmT4VFPNoG9Z2yWHBMraV9Ot+eUxGsrhqZrLM01HvehYlr1L?=
 =?us-ascii?Q?n9TD+00/8Fq8OWTHvO8O10q1rEIo1KwRTJsSdRyxCGXCl6rVbtUjOTq7uWyN?=
 =?us-ascii?Q?JkdGIEGFRUb5FVPfD0Iii0r6Vqiy+f7w/WeYITODTSiCzJgLNRPynsgms1x2?=
 =?us-ascii?Q?LNdLRXVpuG+KVffmp7Jk4YiqnFRuTUJ3gdI6RGxE3qRovXcP+qAi9H4WkulT?=
 =?us-ascii?Q?N00dW7cj0d0yuGKiToht1tAN2yUU2cGyAVbnzGXkZKtFMX3NG/dXAxdWj0BV?=
 =?us-ascii?Q?4QVD4MyyVeauy7v3Z1B+M34B3Pl+MdjjiJqLa1q16NHI5IilC38e4w2QJFEP?=
 =?us-ascii?Q?fVPb2jjZ591r9tNxXPh/aM7wvoegzuu0XUXct8sZeWywCHjHQ4wXGu+/vmck?=
 =?us-ascii?Q?6JJcUdB2R4gfoYJkiNzhwTPLLaoq1QHNAhtSbtf08Wum+2sg3USJn7Gzr2Kp?=
 =?us-ascii?Q?1XhTxP26Aaly9GjVhn1uSH+J+hXQVAyJdameHp7fmsVeUe0vvxLvPFEIIkJD?=
 =?us-ascii?Q?FXT9Q9k6jbr71UnIg8/6PrvtmoimKDmIwP4ASePQX6hf48K84zvhp+emv2Bo?=
 =?us-ascii?Q?6YpBGSKrcC6EiB1/74AA1RL4EUUkH4Nj7Ly5tWzle4v//vu3eGTZ0kYhX8rx?=
 =?us-ascii?Q?tvD7ggPTS9cgyhhy3fP00AG1PFgPZk6+KC0Q3FuqNRgWqZN6Zu5SirUaFUxz?=
 =?us-ascii?Q?cUdLFJNLdfqiWD5/l7HMbXlRr+431yxyQPSA3tLW+TsopPM97Mrt1Tz6OnjX?=
 =?us-ascii?Q?s4sVZuFswPkmJbkqYilglPIV?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c28be3c0-9593-4519-0a47-08d955bf2138
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 14:09:23.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8DzNGhi5T3szAsI0MfLWAZoCiP77lIKbajpXWKmgjKKOit47QxaiBC7g4DPP95ukq+/8iaJ++/UlDaW/qwbuxTX1h6wzXeET1Z8l+Yr8Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There might be a case when driver talks to the newer FW version
which has extended message packets with extra fields, in that case
lets just copy minimum what we need/can.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..58642b540322 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -359,12 +359,7 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 	}
 
 	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
-	if (ret_size > out_size) {
-		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
-			ret_size, out_size);
-		err = -EMSGSIZE;
-		goto cmd_exit;
-	}
+	ret_size = min_t(u32, ret_size, out_size);
 
 	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
 
-- 
2.17.1

