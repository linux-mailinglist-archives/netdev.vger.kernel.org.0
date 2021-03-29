Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3512D34D23D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhC2OPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:15:31 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:4675
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhC2OO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 10:14:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGmRan4sJ+B/TtjUY8515lBuhpdSZHpPdPxVF9TjqqDMAiy7vATCJ6mWTeRgGfd/bNeJ1969D4OxC07JqpXyIatWNatCevOVRB5DVkK+Z5g4p5g0YwcrS+6kwUUVmIEErs6SWsXXYxDWLWEBVlsRZfMV6knudOVmyGWwGWnOm2jQyuwfjm2ayoyhhFvrOEkKOFo1wUPnpRDJx2tyGYbCUPfdDWsobiTMeTlLv+7v/zj1mw5yFAqwskO+zQf/lnLe8+IlGbqZ9H0z/IeYXnh2/y2CxuHwbs+SfPH6zdbdd91MiZhF1NIidusPTQs99XsCAMMgHaGgnbkw5EdqghpVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ONkY6QtLb90VYMvdLYODmirklQNfPJUt8WmnvwJsKs=;
 b=Lw/DgUScmZ13+q8A7MlicLQh054MpzHr221PG/cKPi4vsjEy9OA+skW5HfYosfibG6zGFfPBxnpCG0TynFPYjNb0dxMqpOP7d9a5GsNSsUwIjmuGusbASlFudK9Iu7sbV+mhUYmPgJ2Duij7b+uS1bapwcYmkvp4IRcaIfoozZ/sZuJZw2xDEYAW020LH1WUyV5KBHcvRa7noXRHG21WZ8W0HdIVRZzLX7cl3YgDbrQjUUmOkJjjmaAZA3ME47Tp6ek7JX+4W8MVpWs7em0+6mY8/iO2JIWA6O0bxaZHQ6h9Tp4/YdN9D5U3H637wyahMk4X/u+gN60kn3JNJq9wZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ONkY6QtLb90VYMvdLYODmirklQNfPJUt8WmnvwJsKs=;
 b=PMxmLiKR50piO9xhONUw3lKYd3aav/iKaNt7RRFOgComIvnOxTupgv5P1r2FjWLAppUsuHb4n1vBJnbYGIzW44PdM6OmI3Dwy2c4uP5pTFfwjvlDBcSRVK4zARkUv7WMVFc/eXj2upYwMFjaQ6gZtqhl1WomhpBuIze6k7T2N1Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM9PR04MB7585.eurprd04.prod.outlook.com (2603:10a6:20b:280::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Mon, 29 Mar
 2021 14:14:56 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 14:14:56 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net v2] enetc: Avoid implicit sign extension
Date:   Mon, 29 Mar 2021 17:14:43 +0300
Message-Id: <20210329141443.23245-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::18) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 14:14:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 68c5d1fa-fa5a-4d82-1c25-08d8f2bd0770
X-MS-TrafficTypeDiagnostic: AM9PR04MB7585:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB75858FFBBC7F6C8D387DEE23967E9@AM9PR04MB7585.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5Zpan6iO22vkaH8qqYIma1/fCDbDxBz0FwRVsS+27bUK9jHf3agpHPUSYeTO39Re6gEg118TfExMRF+dvNUJJ7FDtESHh5pmnsnyYiKNJhh0WhLq8qpSZfyNkcx+2I9Rbw87VNTqXCeR5MknWYmvYZZmI0IzBJw5QZlIwvGitUxlvSjZmmRhrDvZQ2g81U0XK0IF2wwnbSkC3QI2Z6eB0f0CLuTIMNOTYKm2ypNiKFy26/X6IiwcwE4rL36z+QKBQ/LJ9ND6C5AEnmpFe4n47l5Us7IIBZyjiMDe7QTmz84JHkH4zBCQG4FW0++ySW5LZZLPkLdI/akpPJA4q6qJLwV8TA04PLnvKwTccqAbXLaUp8mpeGFy+Rqb/ZjDcvG43PhCiDmaZwL5r5rD5P8v+O0jq+pXSYCznl+LxHojVF+KUetEILV3ty6tdSoNUY79YIrw/zPBeWlEfbpdwDtDdxI2Cp1/oPdaY7X7k3nChMzDMCdXinW0EEW60UaVoxnO86jTwd0CoEzJ3lm91az5UxFdFPbatrjYqIvlyyAGvNZazkcw7s6mDzBHC0KVeoIY34t8q/MLI+7DyO3Sx34EWzaPDOUZjdLnEtE0mwyoSLkADl2WpRJqXBWcHneWIiXnnxLcwP9wSeK9/dVcCTj8xeAdSfBi36tb+oulBqxxsU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39850400004)(136003)(366004)(376002)(1076003)(66556008)(4326008)(66946007)(5660300002)(52116002)(186003)(36756003)(478600001)(6486002)(44832011)(83380400001)(16526019)(6916009)(2616005)(54906003)(956004)(6666004)(26005)(8676002)(86362001)(38100700001)(8936002)(7696005)(2906002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qKNVpnpnE4euh+XTpbmlJ+1Ca2+6/Bqh87qk0icuBUEBRLxopmq3Q0AOUJYb?=
 =?us-ascii?Q?8GSW2VZ8mnxwEB0jKiSa3EiiH44ax4ZHkHWIFWHE4yjY6wR9HVOiXUeivJw4?=
 =?us-ascii?Q?BLD2ikgBs+pS9HeRxsF1rMfljXjwprf6h78MJEwSRau8EYyfQtfO6XwP5+u9?=
 =?us-ascii?Q?BSguQRp40TCGy6pfEZPI010VwOxL7Lyqi4KmE1dEX77tXdNE9sh28ZxeI1rL?=
 =?us-ascii?Q?5Y0aCJVqmzE9n6tcHXOQwWifxV32wXn8/IBTbSGOBkPCs2R7fjmJXyACSLEF?=
 =?us-ascii?Q?I57UWNMeM7xjZcxgm5B4PF09OUD56iRUjE9B1nHGXQ46n2YpKRWTS7+yK23E?=
 =?us-ascii?Q?/MNSOFTD+0D+tY3dLr82mypdkHHZGq+n+Hc3DHzM90h2Po1pvDS6aMTyCv0h?=
 =?us-ascii?Q?6CkDRa9kASwu3e5nol8GD+iJ7Hf+avJgZflOtYBXa+MrQaplLsNo+GUk4nvs?=
 =?us-ascii?Q?ugqEoDykxiQLzLcNZ0umXFak5eHrEGE1pGR7eCvTaoOiYAsM/sp5i685VWqV?=
 =?us-ascii?Q?xkerYj1Qu0gqYw+j0zgbQsfO/AmX+uSSJqWmOBhrHcWZC1Q86qUmgbpaN3o6?=
 =?us-ascii?Q?tFfTmvAAQATprlw7gbefPF66cuxi31ETbdAOND+eDqPSnscoa4hVggjdl55I?=
 =?us-ascii?Q?jMjcjrzZ/91p4tqQ2Ij9KP78UhlcPz43FVI3XtkqBGUW/omaloBxxzYM06vT?=
 =?us-ascii?Q?84i5tC1V+LVZvdoOleVXP6sA3aW8t74Rzr1/QbBu/yz6bMDT3NhaEMjc02zt?=
 =?us-ascii?Q?zvpl/ePruB2bQvAuBkKhT9J//O4JsZnxCYvZ5ErKIOmkjYguXUkPrEGT8ZT3?=
 =?us-ascii?Q?Z+Dqa07THN14gRtbVXjYWBaUfmt9d7g4gzHgtmd1al4g47vHnso7Lmlq3Q+f?=
 =?us-ascii?Q?KZ+hpyAK1RuHsGaeuvB4K814TEiDp/C/WTTUz1vdK67eqMW8bEAzP3DjRXtI?=
 =?us-ascii?Q?HpLDLKvA2JIMVEwHIbR3YJbDsGtW3bX+GV50H7NRt2ibLSaMyrlr6seDKSjs?=
 =?us-ascii?Q?8C+iY0ZZyeoZ2lDn+6jZXLH/gln2OO4IJrX069vZW/UC+Bvthh0fkx9gCE32?=
 =?us-ascii?Q?36ClB5OqiVwaHYbfR6vrOoXkJZTedBsQfoalmUUsGU/bkDrbPsheCYagfANM?=
 =?us-ascii?Q?wzt3dOqN/LDqMUaNigli/XG7ER2X2MR3t054K1XTQu3Zz6ajiMw+h/gW9hGJ?=
 =?us-ascii?Q?+W3WyHjUl7zBtlekL+m8ircVK1setgDMd0uQ6egZidRQ7JxtC9qQfNWuBYMW?=
 =?us-ascii?Q?2sDl8fkrXfxpY4WKyP1Zjs1oCN1BGpcW9RZlFT82yEkT6i/MyQoKVWfoBBE5?=
 =?us-ascii?Q?CBz0v0hTMI56Xm3sDb4hm+Q2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c5d1fa-fa5a-4d82-1c25-08d8f2bd0770
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 14:14:56.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iB/O/uwPNBuM5f+te0v8LvMvVJB2e9MSYjlf1XD5K0GNUkC5K/simNRBxMK2BExVw1mNh3p6j/OyX4VblO6zjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static analysis tool reports:
"Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
then sign-extended to type unsigned long long (64 bits, unsigned).
If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result
will all be 1."

Use lower_32_bits() to avoid this scenario.

Fixes: 82728b91f124 ("enetc: Remove Tx checksumming offload code")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2 - added 'fixes' tag

 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 00938f7960a4..07e03df8af94 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -535,8 +535,8 @@ static inline __le32 enetc_txbd_set_tx_start(u64 tx_start, u8 flags)
 {
 	u32 temp;
 
-	temp = (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
-	       (flags << ENETC_TXBD_FLAGS_OFFSET);
+	temp = lower_32_bits(tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
+	       (u32)(flags << ENETC_TXBD_FLAGS_OFFSET);
 
 	return cpu_to_le32(temp);
 }
-- 
2.25.1

