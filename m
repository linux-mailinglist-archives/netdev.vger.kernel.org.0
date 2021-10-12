Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5E42A4B7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbhJLMlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:41:14 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:51483
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236669AbhJLMju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:39:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKw8kDlSE4WTDuhAR7qrJf1cus44Dk37a7OZSS9DZYtMvv6MYnpXJzHSiQfLVwlePXgnQ3MeDluaP8X5LT8MZF1PMkuhfVJbDWSP86T65KGuR6XqjcjRbWu40RNcK5InPndiNs1QG40qIyWQxIg4/uuJqTHYgRToXDYhXK7ivYliXI53Y6C40oB62mSblYwFprQtWmlYSfn/SAM9OPdFCm+eUqA/iq27tXqyJbqZTecu+LDfCqBKSRB5NFneZDDiZKLVseZYW07nH8qweMrKs64cEf9cA7m+po93ytKhleYnxQVRBWd7AQ8zLCIepauSuauHUAsK2PCKw7Utjw9cpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35mj1WRLG3SYhACcI+A9hLr5U+39PBjPOo8bSnQYKrQ=;
 b=kAdHhbImbCDC7Mp/7YDWMvnzns9XYYYy36dHw2LeiWbsKgBWEq+2p5r2f3lgJCUVYqfSzIrRTx3U0OgtgrLD3sV0tDxdAYc9EPlfZdXiucB9BuzGYtuf/AGI/8HPEgrIpAzYHMiXvehsISHKFKVdDTnSJiFBA7HYD1KRctGWT9ibKwj8vHrKf9uY6rO9iBzFKHPkLXXI3lPw0C/0M0EpMtAU0LMMc+J8/UbqXHfOW2eoqVnZBOd9DPocetGMDpM9d4Z5BGIqZGntjY14fk42huoJu+tED8bT5bU+IlMvqW95XGUS51fqeaeVMJJqDTu+ZHnCGsz3v8JFE7Eh6mCQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35mj1WRLG3SYhACcI+A9hLr5U+39PBjPOo8bSnQYKrQ=;
 b=pKTp1phAJPctIPA2Ax7ZWDFR0iWQOZ0guhn7TV8se2jn2eBDjCTeThoI9PhxaWqk02UQWqWtI0mgSY5U+XFfw8OJEFcCnDVoPMqe9shPI7DcR1CC3/QWi/NmU3n6PXJ6/c1Zpn8cK4N3Jp+oyLAkwQvIvplAj/bSXoT3an06hrg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4909.eurprd04.prod.outlook.com (2603:10a6:803:52::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 12:37:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 12:37:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: unregister cross-chip notifier after ds->ops->teardown
Date:   Tue, 12 Oct 2021 15:37:35 +0300
Message-Id: <20211012123735.2545742-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 12:37:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9334d424-501b-4ada-8cae-08d98d7d1804
X-MS-TrafficTypeDiagnostic: VI1PR04MB4909:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49098AC4B52DCDEBE5F81B4CE0B69@VI1PR04MB4909.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dv6ZV3IuZ/sKFBB+oyatDJA2H1N4q/hGkIeuVCtiq1KtrFidE8tvb4KT+0cxkYRytas5J67bwzPTvuYPZGQFmWYWCdQ5s4UOuF9kMsl+oX76WNFqi+6Y710w15XYyYrCJr/5Q1P4gg0KDa/yThj8w+wgHIMK9Q9IC+WdTEB1JG/uPwauBTOEWTtQ2e8Uk8B0TMdA1e+U2lqFyK4fyN/OYjjyOsI64wxwIFOa69OOGi+HGOVt7W8sf6LV4MuAnAmz4VuCo36/9uOW+/JjJ791Kim1AKYgTcmW+AIOa//d/ddE91YVDCr1jAEYey1WUlyPIyhogqZs9i9l4gIRcRuMJn/IDzHTJDEiuxLpQ9wydhqCgjL41ABXUHENlBQkJSMdK8p4WGKVwxyqzb2yUETOA1bRc9hMTdYUUlkMW5f9mWe7Ki1zspBFMzxvfQVdYpvxI5GLXVQ9lz3z1SbgAqNK6L7sVGguL8bBJVsBLn9RsnO6fvZlMyrgRDkuTa22MzTw0PjSx1uHNAlH26fGIL9NK066Q5FMnhA/zvLKOiee7ge/7n4QgVnxcIQkEzuOGeHFCeKbP2Ld6wZGvti6ZgP2Ebnol7vEVFN5Z9Cd9hwnt4b9+5FpQLNENDITKFv8zuVd+zCJOKAzCLSnwlZqHuvdHgoz8QL9qbTXnk4OZlnaGlkUS3Ppxc0EtboteGroqPssd9wCP+L7SG1k6ndaaqtMww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(6512007)(44832011)(66476007)(316002)(508600001)(66946007)(8676002)(1076003)(8936002)(2906002)(6666004)(26005)(66556008)(86362001)(5660300002)(54906003)(186003)(956004)(83380400001)(52116002)(6486002)(4326008)(110136005)(2616005)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T3T4Bv7ZPzolOC+5LuIjyzXgomVSeaTcz38F6gzVD0ONC+KjmnRyH3Fy7pdY?=
 =?us-ascii?Q?XILx08x2p8Q4DHSuKKoHC+0yeliemwecbJupYyfagSHKE5xexwo07xknz7vL?=
 =?us-ascii?Q?BmokgZpd0frzgdw03j55iIJ2UfPzXvkWTTcwvoSiAzXXvrgyareE7PJxDxKZ?=
 =?us-ascii?Q?hy+qRm/FaAlmAjXTGiCMGhCD8bBCbGfnTwEyL5jAY/q8SGqVA3CfnHIH9R+b?=
 =?us-ascii?Q?xKlLP1On/9MXuoDnTCkF0P/+gXqu+QHHzFEdB1IMnv6ZU7qGzGaL8w904/LF?=
 =?us-ascii?Q?9unGgVu0Xd5z0sIDisxi0U24J+6DGQK6vvUC7m/LFIYtC1hVIj4k8pg75wyU?=
 =?us-ascii?Q?sTOZ7kyggcNTAXuyr0tMKPfJuhUwYthLGl99AOFUlNr2Zb5GERfXouzK3rWl?=
 =?us-ascii?Q?9d7m6v+wodD26Kxpm9MET9vveXq0qr22mBknbdnWBye+a4K7FcYfN8t1cE/p?=
 =?us-ascii?Q?gqJe0VOdRHYhzbLLbMGG1dKqn8CtAIvAd/QXejpByl0h1bdzJ4bQ3T6pAARp?=
 =?us-ascii?Q?ZUllrEuYdLCjGuGwfasW1zzSPyMysxYkfT+roBkdsZt93lAk3P86Ntv5jvp8?=
 =?us-ascii?Q?LFenOss5C1FejOEg/4tjOPNfNLYLeoaqC0hrboLeIuGSaPIU2GcdtCYMnMIP?=
 =?us-ascii?Q?Mb9Mc1fLhPya+qb/jfRrgotBfSSqMbVE+xswYPuR6GXyEsGvtN+7C4YCDXKS?=
 =?us-ascii?Q?xCHk8eacVeDaoSojwRC/eRAplOMFoXWjo3uBU1XEhKaDgJ4Xi07Hq+nc/wsa?=
 =?us-ascii?Q?yf36JkjVZrsjDL18NFSXb+GgDnsCwEXbXtC1J2Juybdwn2l9F5a68uo6ASMk?=
 =?us-ascii?Q?SacvSWS9H6CQj8vvv79r88mYg6W5Z5iUsKJpGtvAhzUbfWGPpVm2IMeTb67e?=
 =?us-ascii?Q?Ux04RLCzqkgmCOUUmSBdTEZf/uJILmSzph2oD9Jwujyyr20xjP20YJjNtVUK?=
 =?us-ascii?Q?66phfseHMiF5lf7MrZoNDKRZh/2dWTKRZEiPZSbsrzGI0hKAPCFFU04U2VQr?=
 =?us-ascii?Q?foTnl3d2pOoCSdwu6utl6iaEnpW13hNOZjkeOVhR/yQfQLCRgqLVfDv4BD2H?=
 =?us-ascii?Q?SgM/5Ee/4vd7iVYW2BBH0FD0mbvZu9Hcjlt5P0Z3y/h50jMHSioyNdwcui6k?=
 =?us-ascii?Q?tu7nP8H3lS2GwjqaqV2DcNmfEKQ4spuJMHDfjU6StNoaMc+ECraoMp81r9Kj?=
 =?us-ascii?Q?+9NvFeseaRXd94hU7XhGoYeKoVeMd//Uodp01hLsAzVii0vuyknhxi0JXY/F?=
 =?us-ascii?Q?l93uTm+hOqE7Q30MDRNpJIurLaxsDa8kPyFQQn/7XQVJ2XDqmyisqQ6t7gyk?=
 =?us-ascii?Q?IRagBkuqY+olFS9PuVaTVd1s?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9334d424-501b-4ada-8cae-08d98d7d1804
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:37:46.4784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JADG9SNL1oBwggdkcKe85KL/3pIQYha6pEY8Xlh/bhiiYusNl3jjd5gVOWuzJlXD8N3SN+RLafhb+Uma7+Ss8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4909
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be symmetric with the error unwind path of dsa_switch_setup(), call
dsa_switch_unregister_notifier() after ds->ops->teardown.

The implication is that ds->ops->teardown cannot emit cross-chip
notifiers. For example, currently the dsa_tag_8021q_unregister() call
from sja1105_teardown() does not propagate to the entire tree due to
this reason. However I cannot find an actual issue caused by this,
observed using code inspection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 58f7dce0652c..4f92b1042dd3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -948,11 +948,11 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->slave_mii_bus = NULL;
 	}
 
-	dsa_switch_unregister_notifier(ds);
-
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
 
+	dsa_switch_unregister_notifier(ds);
+
 	if (ds->devlink) {
 		list_for_each_entry(dp, &ds->dst->ports, list)
 			if (dp->ds == ds)
-- 
2.25.1

