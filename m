Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D4E279B67
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgIZRbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:44 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:61761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbgIZRbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDW0lIbZCMQ1umu1bocCyIAi73ICBnmWrUCWGwzk7+MNU463vv3Exv6MwHwMdM6dhNWESAoVNXNmuLGzSg2Xa38np9/Dp3F1htN3JTBdfTjaAEmr0eXMOS4bEAs1Llr4QFNJlw+t2Zg4le2dqW84Gjgzd0rbhuaWH72rNeJu1Ulze+i35W0hBUH8k5h2kYVb6Lm7RjNwSbOq1rn2jODuzkwhlVXDKL3l8Y0QnJXwWJ7f69oMK4gpwFUPOJFuKQGP0ow/fkMKYF8Sco0jwm4Ku7c9OXspXuUBrFmsa9djwPRi6achoQYBZ7+4oZHJSmdu+JDU0MtldJEclvPmJUZ7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3izMIuuhlLzzmedjtHJi/8g0h4QuIyABRfyzuk+EPvs=;
 b=VzjV01HqDSN5T7pVvBaU/IO4BcvnSZeaHz4fPGzDpUnUZiWhGPTzyLh4e43jemdrMW9Tg6VOivrCL8x9meBEU/+64dGeT3l0vNaiEwDXfmlRRkgiD+UR5xRn/FzaldNTebCsQMC2+szeJDXQoBuFcoBp5DvIPZwyPbdKd02Qx27Cim4ajBO23uhrHs/xVG0Sp0e+QwixNqdcLAwifZzXLfkO0HNN9N8qaivdJVyr+KWW8ymZ91Ef24FmgUjWNr5wJNF4SgF/XXXOSm7A4KHHNcdHM501ZamKKcVWDnFz7aJpxjYgp9tZIVHQQiESG8Ua5+Aw6DdY5wJiOgDtrWlebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3izMIuuhlLzzmedjtHJi/8g0h4QuIyABRfyzuk+EPvs=;
 b=EbGLm/At7FchnV8c+3kw3XF/eEzlzpj8XiDjQ2VegdXifHc3bkRCsxBRCmI4KUGpz7iHQO+YPCbIv0wV/VGXnexRnyhZXFYu5jzjSLnxrJbM1uqXjANBPvo22rsL/r2Ud6MxqhFFtsacIqkmx65qbYWtwFOxcYC6AuVA/lQHFwI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 11/16] net: dsa: tag_lan9303: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:03 +0300
Message-Id: <20200926173108.1230014-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0900327-1b51-4eb5-6da8-08d8624201c9
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48130316659F6029E44A8E13E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcOcpgotYwKxNkxm0x1pV+yIVvMAZViUBzZKgJbKEWG6Cx6I6HWGDo6zESLbWcCh3+zIDmfD9gdXBo6VNy4XV9iL9vnzPZStYiVXXQ29jT47AHpvuMCn5QWIyD60e3uP0quV75gNROW9JG3lcDU/AHA+1VdOkRQDyVYxyD2sHKG/Xs0iXaVoH4/wasbDXbT5kL9wM25xpK56e3FU0XziMWkbC9nksWWmeQZyoSY1A29l8jo47t/FcjDscMDLDN9+om/C9mrMHZPbpMFPVYJq8Lt7/0lQAXlc263cCSbufHeKoePu0bjYL50HXfS6NrheyEtc8ImISnZvOMSkuVml88hvc6BOUWfDvwqJcVh9jflCDHy1iQiNdZEH37Q8Pnwc3Fr992CgGbunpjJB/c6MZgyf+vRAlpoP7+UQ0A5+R7U5gLE/xf542w5EY1mpp8JsTrawA1uSaZ9Kvbx+YZscBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(4744005)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aQNko1Ky7grImflvJ7raXuhR00cItbDMEagv3ytls9gAzjhjP9cFjkjpDkpB2/V+CFOnHRtGEA3a4olmWml+xscAL9XvlPbdT9hUYWI3Kl2Q52c9k6XTQYNjypfeZvlA0N5zsUmJNgiFzmTxnY38O7GXaSVi9WQ3DYw3M2hueLm7paM9HLLX/rtuujJw+1KSdFzvMHKZI5NJZETP4W3a+sk5Z9qTpogSafhItfAfkRnqImxI2V2cR0N07VvML3DwfzU0ZNzuU8pPPu1DDGOssjzZmDq7urgl9xno683/O95+QM0aymFtMvJItkWHmjSIirzRkpSj1PM1abBOy9JKdSDVw9jTzRXWJfQ6fDlz474TVRJ5f9Bi8KEbTNBj9ZU+IYjAwiGhS+pXh0XhiaJC6NBi2K51aCSGykxV0vGsepiarBtw0dimzlwtu8g65rvQsq0gX4I+uuXdJGbsV2uOMxx81h36DdFjOWAExanpJoWw989Yzr0Whsyl7jILNjvlFcj5OPVomD749BuF5FH8meeGlN+HJwPJ5at3QUP28KjQBfak3w0ug+gNz97rzep6kPYI9vz7d0XRC1CCbTjEshyI5LHBPheHRynCLeWknkZZQ6xhaU3ztRZEJdRePIKM0vKdcjH/kXFWXgU5yrVKwg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0900327-1b51-4eb5-6da8-08d8624201c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:31.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXGkogw8Ro0FgKTDu1cwXqiPxJ1KATDSBnJW38u9VKHrSWTggRVlr0z8DU84fhPQclrsAJvwmovtbgiKG2skHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN9303 switches use a DSA tag placed before the EtherType, so they
displace all headers that follow afterwards. Call the generic flow
dissector procedure so that this is accounted for.

Cc: Juergen Beisert <jbe@pengutronix.de>
Cc: Egil Hjelmeland <privat@egil-hjelmeland.no>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_lan9303.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index ccfb6f641bbf..94e3808500d9 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -135,6 +135,7 @@ static const struct dsa_device_ops lan9303_netdev_ops = {
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
 	.overhead = LAN9303_TAG_LEN,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.25.1

