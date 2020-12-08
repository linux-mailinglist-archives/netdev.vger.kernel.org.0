Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815F72D26C4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgLHJCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:02:13 -0500
Received: from mail-vi1eur05on2126.outbound.protection.outlook.com ([40.107.21.126]:49180
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725927AbgLHJCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 04:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7bdfN/wPu5kF8HKPnrIK1y057z6pEGVz8qKhGpV2qCEe2pXzoWx2du5O2j5Jzm1e/KsnY3a7G12zTQTyf5EwGUfE4Sd8G5WujY5JZYT0j/BOncvv3kNKHJceczqUJV3zNncF97PdSc7FIRTtJDrT3iCYGTJZxLLzkGfa6tZlHBrv2Q+fkcbBz+c9bRTI3nFtc2PNTy6Son43C2Hjtf4awAf3jNg7V80ZFkgQ/xQNsK4hBhk6Q2A29l2iOpguaHkYY83OkZZ22HsryPwlDj+Ms+K4wy20vHzqWL7+PsEZ0ZlRVrrnYLrnBcrY+HMvU172xnoshecnnZf69dN1gq9/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vagzSGmT7jxDI9ItAPtKBlJl5ehicw29QPe18x/Cssg=;
 b=iP5PFM+Gl65P/xRtkCKLkKAVFffFJMl1vIA8Uwkq+3UKkbN+ku2ZXRNTYy3iXTkvVuvmQHvTn8QWEEkUXAVgE9aZKOzWrTT8bzGMnCQ9r2rtNxfOnno7eMyWdoArTpQwYwYumZpk2TG2cqmwV06xusIf8ulMZHE1DFHzItqJQwtZYLKwMHPNvuiuLV/iIp1ggioh43nO5l2Ai/ECjpioJoqEoAfHzN4RVHXrb3r0gxeHBTc2GcE5po+FGuz4Jw+N2sU39+jC/YqsUnumNz0pILNIkF1bsCUrdfeZOayTgqqKvrq07GN058b9aKcBesFwGDwJH3g8mr3h6J4yGJacpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vagzSGmT7jxDI9ItAPtKBlJl5ehicw29QPe18x/Cssg=;
 b=LaXuOP6is3EHgytjFchRfFMh3/uC8ZAwihPZpjDjqBUCCS7fUsi09RUWU0Jy5WrWeH2EeRvUp50UHj5i86P4YU7/7bcyS2s+uPiFHMAedejqfqla5cL/DWrUxPON3LdJXy6l1EQ9iUk124lEhtD4o7hqyAkPQDojHaY8JBNqVuM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2323.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:db::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 09:01:19 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 09:01:19 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: don't set non-existing learn2all bit for 6220/6250
Date:   Tue,  8 Dec 2020 10:01:09 +0100
Message-Id: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::43) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P195CA0066.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 09:01:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 765ef881-4eb7-4d61-3064-08d89b57d3c5
X-MS-TrafficTypeDiagnostic: AM0PR10MB2323:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB232337CA02E9C867150520A493CD0@AM0PR10MB2323.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1hGDUvoX/PfhCqTNTgNKccWGcrOKfff3B5EiQTp6LUmch/9O593Xor56wzmVKjywkGQvSGe/guLtAmgmgPSdxFSYv/OaXWnXkx0/Ii1UhU/CgVVOn4immL9u3J++EXWkZZ9zs9QhrmWN4ak8Of2M+qT/gFsM5bmz7uHFOmy7IBqHOzyvp4KqYF75/FvRdcYRFVHVo0JO/a2faHMsPNZQHm867qXBbAIRA4C7ywVKBh+67KZUFgrtO0d/bviRFmMPKQtY9brEYTzcTPD0LdKRhnLLiqSr46M3eL/uM75WvhzFa1q11JLj0T0s7aZZKcK29aHPFjwtjcYIVQtnGN55w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(54906003)(86362001)(83380400001)(66476007)(956004)(6486002)(107886003)(1076003)(5660300002)(66946007)(66556008)(2616005)(6512007)(36756003)(186003)(8676002)(4326008)(26005)(6666004)(6916009)(8976002)(8936002)(52116002)(6506007)(508600001)(44832011)(16526019)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0hlCMR0FbtVKxlJw8EFc2Zc/aHOql8HhPvoRl8w7+ZHsuPN8+I1STbwuCbLx?=
 =?us-ascii?Q?ZGnydaRAECPJ/m7GFAVdPdb3N9DrMi1IN527IANJw9bSptraq57AaiDWD4if?=
 =?us-ascii?Q?ypVarMtKnIVYqy6UtDDoLxEvadUVMgqLB4Xnc0UQMPEQkQNOh8BJrYU5nkZM?=
 =?us-ascii?Q?Xpou5Xzzhb3M4GFr38Dt0N60N0+3geGOFs0uLCHurZJ0+SvOvjO/vJRoXRRz?=
 =?us-ascii?Q?VM8MJy6Llw3/HdsqmettYLUrc66W50/KW/c6NsUKM9er4kax6WMUBVYAod4e?=
 =?us-ascii?Q?Zyh1n0J4t4XiQr7wK7a/n91LxmWOl/4J+v28ebsH+Pn8bEs8rfg5giC3Q4mo?=
 =?us-ascii?Q?r8VS+LDt0DgVkIA+efOC56lRsG2K0tPFijfRuzzdSFM1TjpGLcjFCfwSnH89?=
 =?us-ascii?Q?nR1KbilCyntvhl8KABeW9H7aBoeQTX3kGzUM1LBmr3J7oMY6pj90MeuFtEY3?=
 =?us-ascii?Q?svc68H+aKxiND6jXZdNLbSEmsXLkgmPB8iGYLqcJg5cpk7EUf4LQK5Qt4JrH?=
 =?us-ascii?Q?N7nxMtxw8Pq7JTCKQovS8bRAzVC6AnFHVlTRgKDUEUmqIW4pM8wHqrueRsRx?=
 =?us-ascii?Q?IeeqP6q2YM893TG841ZswsFm3/4Qx6v5TXqiSTvNfa75+tkQOyBFFidVL9Hy?=
 =?us-ascii?Q?2N5cILCt0CbB57NErOhxnwNxhUJO9IcB7wPFecuHG8+WjALtqG3n8642jnSY?=
 =?us-ascii?Q?6J6gZt5Jq74EBtBP4nUtc1qRll8TjL81y4hcuQyow/cyL+nwujEJPevIP7iJ?=
 =?us-ascii?Q?zme2nM1Ovm58LOCkTa/xW+DUkFOmw20zP5ZwdhZnpZjulfydeoKXxgerJRcw?=
 =?us-ascii?Q?QlmmQuVEh2Z+CLQI1J15fNF7xL3G+Tw9ILo0yZYJwpUBMusRffDm/v4yYjFp?=
 =?us-ascii?Q?xuSBkGNCuRSdcSk9lrAsLyY29qcpR+VGf35V8rbyXIR/tRq8T0P5or93nZ10?=
 =?us-ascii?Q?CRNaItPbkrb86Oll+bEYd1CUTdy3UZa/3qexABwRm+Xq8mc/kqjknw99l1PA?=
 =?us-ascii?Q?YxX7?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 765ef881-4eb7-4d61-3064-08d89b57d3c5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 09:01:19.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agq6xEORvnIo3SO2XQ4SUfRmTFkkGDeO+JfO71C610qdHOmWYPgXIYzLKQnvxhvptfhV7Ulf6z7r3goXWqtUm4CQvlXwzHOvCfwNZ73Ao5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2323
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 6220 and 6250 switches do not have a learn2all bit in global1, ATU
control register; bit 3 is reserved.

On the switches that do have that bit, it is used to control whether
learning frames are sent out the ports that have the message_port bit
set. So rather than adding yet another chip method, use the existence
of the ->port_setup_message_port method as a proxy for determining
whether the learn2all bit exists (and should be set).

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---

This doesn't fix anything from what I can tell, in particular not the
VLAN problems I'm having, so just tagging for net-next. But I do think
it's worth it on the general principle of not poking around in
undocumented/reserved bits.

 drivers/net/dsa/mv88e6xxx/chip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 25449f634889..0245f3dfc1cd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1347,9 +1347,11 @@ static int mv88e6xxx_atu_setup(struct mv88e6xxx_chip *chip)
 	if (err)
 		return err;
 
-	err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
-	if (err)
-		return err;
+	if (chip->info->ops->port_setup_message_port) {
+		err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
+		if (err)
+			return err;
+	}
 
 	return mv88e6xxx_g1_atu_set_age_time(chip, 300000);
 }
-- 
2.23.0

