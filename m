Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A527E3D0062
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhGTQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:58:28 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:38117
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232076AbhGTQ55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsuF7qrJ642iMGFi8uKk5ylbaWg6moZ3NX4teHgrEf+audgTepa+uOWCHcWYizAQIfmyZ5w2neDEBc4S12Ct4qvRMGfXNP3QnBwtvdbCjCm5vuCs31IccbXGYuwNkvkQM36PIvyKQWD+cQRdUAVjzrFRHLIu4VdQIYgf106NVb3N36gbBXQohMUomQI3AFrQpVPgv8Dn6D5qrPqH8RTsLcrWmPx0ptguJdkiYgXzXOqRzU+f5dK23bNtR1f9uuZ5mfkO3DJDjXBDWZtOXTadFKR4/HXyjVarNKRckouxgZogMIIoRRsbZk8p/6A51Bn2yHH4onNladzDY87tyNOsDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7Mjbjr8WQl6TdgQ81t7bCtUpb8w7tsPguhkUAHv0Jw=;
 b=F2eHQAXcQM2GWyNLFFEy4U9yiYqZ792KKiB7Eelr+dhT25ItPEK8CfNf9Nx9YgNYAuvWZS/puXKctIRja1du8WR+K0DDqPRNtyueN6K3s+nXz2kZkOuMmgck15M3rXD+d6k00JgIhWulk+ybQob8XHgLDD+IfGxbWy/W2XDBgtb2KOsH/+Ena580VCjh2fx9z+j1jpVhFwcsLsolg4x6BU1RlTDJxzE0WPc94jKmHMOo4kQYSNOROD8YEM5IcukMN0rWpS/md6U3ViTzILGV3YBA5RU3KBJZaK2lFnw00SYeg2UxBJugBC7q5iul/mKrbbKmsn3/3wYXF1M3kZSh3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7Mjbjr8WQl6TdgQ81t7bCtUpb8w7tsPguhkUAHv0Jw=;
 b=RuggENXnjv7vzTzd05IJ/+qwOquZF2uiucMWI5ef5QD3wo+2acucJw1o5WCowCmEy4NcawZr1hHzW2gKR5wqg0QKvuPk7ARckndHReyfmeS7zHxQ/HvLLWsU/HoBIBgZt+HXs2CientxBrsQJwt833NzoXEMxrRVj/GGf9XV1J8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 17:38:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 17:38:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] net: switchdev: recurse into __switchdev_handle_fdb_del_to_device
Date:   Tue, 20 Jul 2021 20:35:57 +0300
Message-Id: <20210720173557.999534-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720173557.999534-1-vladimir.oltean@nxp.com>
References: <20210720173557.999534-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 17:38:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d2bfcb-92bd-4f22-0b2f-08d94ba523c9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB36161AF0A7ED2B59AB4BA32FE0E29@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8IzQfNolMQ4SolvZO6PG2adgPVaKT7dDp2n4tI9lb6/WVzlFu32eHI9Ylo/x1G5z7KwqjHmxdfAcz0z4fgm+dETD/PNAzJhsV8/8mIyaT2oZvlNiRSj8I+TBheVEia00wSYYufIKi4ShfXWhFrLKmbZmwSFY8rClANvBH5Qk3bXGoIza+cBuotVwURPT2lG5g8QWXEYXkIptIMZvEVovzPerx+tJtdu7fj0ugE5VdwutOfKYR/yyZnXANL0XAq240sHcak7ptiC9B70Ea7WFla7S7dYI3HjOau8+5GGlY8H1b3a4YwH8W+dncTCpAMLv5/Des+w7u4mpoLhYILW8vihdzvVTKujt0kqbuuN97aQo/b8rsVWKobmPZneHX0KUqyOJo9RL+m0ksnIWF7EabcqF3kva/hu9UhMg9lGFplilFB313sYbjT5MmGNOWRvCf6IW4bHUqKn2UYIKxWOhKr38ScfYRWX+SwsvS3KXdPLs8jBmzKG9S5HBUibjSs90+uoYZmikxm4cC8DKWiKR3yHg6730P1h7OjEIJqHYE7NhO5sQfax6wDIkldvzfSO/WgXClpzyxCc2wzOzTj7wvp7PZICtZiSFkpc1ki+Ps1URKiMkzhNtdm0FaOf3jBRBp4YfkvpxnQqUQN6XXFkeAuu+P0lXQJvMSXxOWwQSDsejYaw/FfPfDAVSYrDntEa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(6506007)(26005)(66946007)(6666004)(478600001)(6512007)(186003)(1076003)(86362001)(52116002)(110136005)(66476007)(6486002)(36756003)(83380400001)(316002)(66556008)(8676002)(956004)(38100700002)(38350700002)(44832011)(8936002)(2906002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K887+KCO+eRiKyla4q9EbHyKre1uvsCYu+vcV76nR+dEPYb8IJABc62oQv2x?=
 =?us-ascii?Q?U3wxfgFrqtN9XmMFnkpBGOa4V5cG1vNoLx/RZ2gH1AOk2vvRdd5sMCRHbQCH?=
 =?us-ascii?Q?QMWY7iILF7wpp6dw2Cld2PbjuZ6QIAUCCPnzaxS7sDV0uO+IYP5ZSvF8kqT1?=
 =?us-ascii?Q?QtdmYBwc+qo/dIQ5haZBlIoyI2jMW6i9nzof2Z2/wVnQ7PhMQpijQLPSV3i8?=
 =?us-ascii?Q?inlMX34gSisaZBpyaMhfxqBvfGz+wVbvnwlSyb+k9Amv9qZCZozvmXRb6YjR?=
 =?us-ascii?Q?wvvcj2vQ3WUgsDZ/u4GbAeXjBK6pPzc4PtOUHPKFbdLGooKglPsiZ0QDy++F?=
 =?us-ascii?Q?RP+Qq1ocQT/yTZN4UIC02nQ2K3Dj1lAstegGYqUNmHaamCqhYK3LePPJ+Xur?=
 =?us-ascii?Q?rM0nFIENC+FyvIUbTC+qxOhfe7dXNbaUVITA4BR/u0jlNxsjRye7AqNDyeYU?=
 =?us-ascii?Q?BWYG0FVXiBus6Y1JP3TiZUjJ4W7CfuVR0nhZTs2YspN6mf7F7RVjh39Xjr+J?=
 =?us-ascii?Q?tkLsUUxvCEgaBm6cWr/tHsi9H8AEhF3zQr+LXighOWRoJsL4cSuq7zzzvqMB?=
 =?us-ascii?Q?OsfvbFVGCOsu8A+ptHywjnsIJmzNvQvEZA1+eUFM2Tokhdj3MD6jIX3DvL0k?=
 =?us-ascii?Q?k5Jrq2UTg8xh+mIn3FuQORv9Yk8+q66CX/lYRhFCYZP7Ptiug1/QfjEqMC0t?=
 =?us-ascii?Q?Tto1d0mFBA31sTJzOVIr45Unrti0073NLKmvZW6uQUU9qb2lrlPHKraBBdca?=
 =?us-ascii?Q?8Y+yufFxPNIlnPyRejnt1XjEOdGKlzCVxvVeDqFr66jsr78+8iEREVXF8evf?=
 =?us-ascii?Q?Wv5p8KxPac6vV2hy6mEO2T2+frYU2F5PFxWQ3x1jYy2RcOJI5G494JhHEFIK?=
 =?us-ascii?Q?1KzQsJPcBvbh7Y+4/J17JGA7ev2Z7qNJvFUyw5uD+9Xn16ufRkHbwPR703ew?=
 =?us-ascii?Q?5We4Qvi1QZvFgR+QSrOTLsKKwmh8dy9qQS6grVapVvl/+A5f1rJOrOCm22Op?=
 =?us-ascii?Q?eHDDZX3n2paMBkC3HIhdKQVmKz4+6w5w8uhDX45cVhnWFe1CTwAJSEvI+n5y?=
 =?us-ascii?Q?00PV9QO5EWzY7YKQvNWREArBapetuXSNtG4bo2IFFZGFKxF+NPkeF7A+p1ZS?=
 =?us-ascii?Q?iL+4LSMaZZBTdTd6Jim+fhzoEtb0prP7V5bhqOG7YO6ncyNNsRN8FrWGjdLC?=
 =?us-ascii?Q?1l6kl0UY0jHqMG61cFIn+t5f8KF/+j5jS7GVvKCDE82SS0eooxjPohjYejuf?=
 =?us-ascii?Q?rlyXffBmPTF3MYzxBoAQCB4lfccRijUebsAL2slWcG6610tW09+n0lju09gy?=
 =?us-ascii?Q?ybTOod/6u5UxYZO339/yBtJG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d2bfcb-92bd-4f22-0b2f-08d94ba523c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 17:38:09.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zI2Kl8JqgSNA/akvOr+QjwGfNpoBjhn14O68yrTqS7Rc0S0JYcj+FEbaDEaIWSPsjr+s2eHYrnmpXs3gCHAImA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The difference between __switchdev_handle_fdb_del_to_device and
switchdev_handle_del_to_device is that the former takes an extra
orig_dev argument, while the latter starts with dev == orig_dev.

We should recurse into the variant that does not lose the orig_dev along
the way. This is relevant when deleting FDB entries pointing towards a
bridge (dev changes to the lower interfaces, but orig_dev shouldn't).

The addition helper already recurses properly, just the deletion one
doesn't.

Fixes: 8ca07176ab00 ("net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/switchdev/switchdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 82dd4e4e86f5..42e88d3d66a7 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -532,10 +532,10 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 		if (netif_is_bridge_master(lower_dev))
 			continue;
 
-		err = switchdev_handle_fdb_del_to_device(lower_dev, fdb_info,
-							 check_cb,
-							 foreign_dev_check_cb,
-							 del_cb, lag_del_cb);
+		err = __switchdev_handle_fdb_del_to_device(lower_dev, orig_dev,
+							   fdb_info, check_cb,
+							   foreign_dev_check_cb,
+							   del_cb, lag_del_cb);
 		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
-- 
2.25.1

