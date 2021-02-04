Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C8230F81E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbhBDQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:36:27 -0500
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:53984
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237728AbhBDQew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:34:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMJf62XaKhtwv8cSZTGMb11O5CIvMssQDxOugR5c0uYUCUB5/EHff/pUkYMy3NaEh3d72/eSldZoIkv9XTm5gCrrSzZNH8Vla9EzP3FkKJemLWXenkbnFB7K1HpQFWgGCrbJmJOjwyMAQJ7fOwJexydA1g04r5J/DvwppvEpgH1N7kH4mr7hRMy+nsxYByNT4sV36Xr54YkqXfGef+31afe0BxfxgP9JTD6KQDPJxtTfT9rvStCRacc4iSVPC7ohntRLsJy1LyTYYhvqclc3oqRE2XaWqtIaI0Lxejedy03XxOh2yR5mBwLR1PCQnK6Gwa7G4TVF6SQ2CfxUp6rcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qQWLVp+qZ14+V/U6sVNm2LkbO3s0Npch+EuJ1j4les=;
 b=g1CZUt/2zeoWJ2IPQp4Y/3f95NTh3jNr7qdVBU18f+4rc9aFuhckq0ai1K+F7hao6NROQKfYe/Y2kVfPw/4yXz+BamniWx8F/oRCg48+T2wGto6B+BGIEx7+8wigvqjxc4LoAsRa5YSYuizH02vA0U9Ddx39luIDUTW8wtIfvIl4KhKhS9h+9Zmzco4dP+5Jupwzi4I0/JaQ7mynMPOWTSzX3KRL/RLBE+FP5WoqQFrg+4vpySMgNw5W8LbyfhBoxtkv9WC5iAEfmbQHvrOXL43z/QIeaoMn/lag+A+gFRjwOKpulIo5LGFCSkAvzqgazz36bLLgxoTLgLeU5jnlbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qQWLVp+qZ14+V/U6sVNm2LkbO3s0Npch+EuJ1j4les=;
 b=c6teBVC2h7jtWy8EjY06qsAk/PoBUrkA2eww3Ir3JTSSPvlYdA01GvcuobRnCPqZxxdwY4CI49fcB1bYuc94RJwrX4cYsTZMrl0dSlsO3wr8rvKe5wZurbqrOlCRbkzzKCkRPa69T5YYfFLZoCnV7hvb/VDxFKqOyFEugecsor4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Thu, 4 Feb
 2021 16:34:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 16:34:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] net: dsa: call teardown method on probe failure
Date:   Thu,  4 Feb 2021 18:33:51 +0200
Message-Id: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: FR2P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by FR2P281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 16:34:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02457e96-bef3-4e14-d334-08d8c92aae83
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407FBFF2401CD2247C7B51CE0B39@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pyW1ROgGEfcHNKQo/GblyuE/CTOAw8ot67XM+c8/KDJXwvfqW86DIR7qAxCg54ZFIJ8F13BKxvaVPSLcIs/tSzZmpAwXXpiPhCcBSR1FqAiIsdnbjh+wHzP7a5x2SWBzXMpX9aU05TUpTTwCQsxK3Dqwvdb6RPYQtKs+uscEqhcxI26W9Kn3+CCy6CuMOdXLgmywhpVEn6+OGFg5yBKMd73jgTKho5WM1og/qkAsyHVcm+uBrF2BgjWZ0AY1Vg6DkVB7kS/mkLuMmtTfwrXRZsRABAqon/12iWNbLRlwDeqwwI9LWM76JyfqRL8rNxdZfKH0dolI/iNKga1//kVrjsJGbEgtO5M89uyv86G+DwjTb8wE92Vj9TQPLqtax5LgaRicrD2FQajtt1iy6I0jpbawG4bedG7vr+iieuEC036SBs8yHIpYausPSlr1yUZGIeqyfANht2MMmEOd5i8iOEraSwp6BPe9cD3V86MS4YJSfZ2XnKR001RxkVj36W+1+71aoIZeOpxR8q+qiptFy/AksA4Mkm4SqxOgMvGGAIx9rDdrPvuohnorGAZviFKxGd+CgiSm2ZpWC64/wMUpUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(69590400011)(1076003)(8936002)(86362001)(4326008)(83380400001)(6512007)(16526019)(54906003)(6486002)(26005)(110136005)(66556008)(6666004)(52116002)(5660300002)(316002)(44832011)(6506007)(66476007)(66946007)(956004)(478600001)(186003)(36756003)(2906002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pVskCnD78aXTc/amwC2+CKyR8k/hX3LqCqeNPDt1Z/8M0qZ7gOTrBOEKPEB+?=
 =?us-ascii?Q?N8+vwmisekBRf6DwkzYkjSx1w0ZBYx16Kz6z4brtCGw0ZAvweJloH2CvhNjD?=
 =?us-ascii?Q?25sb/cPfT4IsgIIpzIRq7dm020JI1z11oLY3Qygyv2PdBJ/e3HIr87VGsq8A?=
 =?us-ascii?Q?pzLfl/w1oW15LpDqKS+qARTPifiDcq+SwGqJCwPNAbupc3qvy0BTnNP24l2C?=
 =?us-ascii?Q?BoAQQmbFgnp4sc0cqW9FBYGTLMfuLQiMrxEzv7boQA5rWNGnhMXB0/JH2qsY?=
 =?us-ascii?Q?Zcq0F1W4TUdoztfoEZoMv5U5iOIJrP/ItFOyn7EAPVnfbtlD3xHxufEqxWw6?=
 =?us-ascii?Q?dDY0hqyBPsi93vCGs2qRBMBAPzDImXuOpTvMF7qUGXjeRlItBHlClGpsLvYU?=
 =?us-ascii?Q?Yqatps0Bd2o3+T6vyktXKIicg4gQ7iEFHU5IYrfoWjy31avu1zd5M+U1eJZ+?=
 =?us-ascii?Q?R9jl0hJmmjxj9+IkL+TLFtn6cc/qQGflewDR0gbHGlEdIexYaANqTYwUIUc1?=
 =?us-ascii?Q?qK4cGgUVBN3axZh3vnz7LB87DmBqEeHQxpmR48nY0eGb4o2zcJK+QAZQn+Z/?=
 =?us-ascii?Q?HK3qHpvgUWHa7vxXNQpvhC8GJUeTIt1zMlxgbqJT9yhzIle1I2FG3IWJLk/+?=
 =?us-ascii?Q?bi2zK0j/KQB6GPSRSVTkmUX5+yK76jYHIDVjdoUWcRCPOZwgZ7Daue3cbBy/?=
 =?us-ascii?Q?oqcRC+HwfRHu+mEO6pAqhxdaTypFj3xWQe2woM+Qz4g3F5tdk2kZIs7sUxTD?=
 =?us-ascii?Q?9xuNqDWlHJ+ia9mAz0D3xVroX6obnzEKP9hac7rClNw+iwVMKoQ5JgX01PQe?=
 =?us-ascii?Q?Wp1ssdvaMO5ci+tZkKM3P8bXiZz7UoVhBfm6DjT2FaNy5ogYU+UOb/Dl6ice?=
 =?us-ascii?Q?6BxlUPRowRulJMzWn6Uy8sQ19gD1FYR7lqGWA531cFOPmqwOwnsRtKEFfzKm?=
 =?us-ascii?Q?pu1+k0Q5G+QO3NJFyCsq5H+/MbvqGPs3agtX1hJjRjZy3q51lfN6sPb0kUBS?=
 =?us-ascii?Q?3SEavY3qObVJZlCLJDLLRBnY0w0136/MTxDnRkDMuETnwa1+5XI6dTTEN/ca?=
 =?us-ascii?Q?M41lHHRf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02457e96-bef3-4e14-d334-08d8c92aae83
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:34:03.0047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAEaJETnrnFEDTxmKSERhUIG7r0oQnf94SEn7cVFTU17NtaJdtZ3wHHk4rzd01P+2moBVFfozxUp8pTcV1sw+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since teardown is supposed to undo the effects of the setup method, it
should be called in the error path for dsa_switch_setup, not just in
dsa_switch_teardown.

Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 96249c4ad5f2..4d4956ed303b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -724,20 +724,23 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
-			goto unregister_notifier;
+			goto teardown;
 		}
 
 		dsa_slave_mii_bus_init(ds);
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			goto unregister_notifier;
+			goto teardown;
 	}
 
 	ds->setup = true;
 
 	return 0;
 
+teardown:
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
-- 
2.25.1

