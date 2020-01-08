Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0299F134745
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgAHQKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:10:31 -0500
Received: from mail-am6eur05on2099.outbound.protection.outlook.com ([40.107.22.99]:13928
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727127AbgAHQKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 11:10:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZsDtYVnodN7FymDNX88l22aETsfHoy7OaHd1LOUKwxwRPQi2S7Vi21Eg9p695W0aRsZwhgqGEBJtyHX+yOK/eOAmOBKjwHr7veg6cpNHRjzqvXYLu4ecT0Lr9hQk7DTtp7LVKuPkLONabD4XQgPBsOvPgcqtXrMGhQzdPy4/9xFWcfNzPNmE1V9uTQtzsRC+9K1qGAckumzok7BumJ4B69FE8eszwxLuCLIq3zqmWzV4shj4MWHd8G8UiCXkgVsIsjwvSWlMplIbQ3Fl+t4w0sQt3oPnGxJANlyUPVeWFUL2UFWP6alYGGRBocdHSS1oI97lEOynMvgybuc7gHckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3yKSQIsj8F3huyV+KmT9VyryTVpJf+903b8XMB3VvA=;
 b=Ci8pob9cPVd/o7YZr0B/5z46Cc3ARkzp6UYcUyuoQSfyhEGg4cK+puwwUObpMhQHVqvdTqfcsum8TC3sjn9V17+nfW9d9otjcSvU2ouBw4D6uoP2xZkJ5l+6NDKLtDfSXYIDwCk/NnDyXdM7pxK0hTNquUzCjaOiYLW93ZoBwJmjb4NcUpvP8hFAMt5pGFj6Gsr965cfJr+M+2g80anW1HGItQOL3ZjaDf/FN0fl9AesNpJ2BVDH5JavzdtiPCTwV7neaSf4C87qL0yY8o9cJBP2gm7qVqtk+JXH4JCi2qEb+fo9MLnhGIXYw+JJXtFDm7MhaMUl542scnmQ1Tqvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3yKSQIsj8F3huyV+KmT9VyryTVpJf+903b8XMB3VvA=;
 b=fWs914g+oCWrHMQa3CIF6ceruJi1Zpis8qav68VGJamXqVQlW9Z+1SlA/7DSOdulj/aqU6WHKJXGnrN5jd5sWmlMnd9R15d+g6OEe+fub5nlTyk7Xk1bpLdKafCU/SWotChw8aMD1y/pFf57xj4xgY2BVeFJKfa/cpd8G+0ibto=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB3870.eurprd07.prod.outlook.com (52.134.26.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.5; Wed, 8 Jan 2020 16:10:27 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2644.006; Wed, 8 Jan 2020
 16:10:27 +0000
From:   Alexander X Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] staging: octeon: repair "fixed-link" support
Date:   Wed,  8 Jan 2020 17:09:56 +0100
Message-Id: <20200108160957.253567-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.24.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::30)
 To VI1PR07MB5040.eurprd07.prod.outlook.com (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from ulegcpsvdell.emea.nsn-net.net (131.228.32.181) by HE1P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Wed, 8 Jan 2020 16:10:26 +0000
X-Mailer: git-send-email 2.24.0
X-Originating-IP: [131.228.32.181]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: caebf886-b604-431f-bab5-08d79455467a
X-MS-TrafficTypeDiagnostic: VI1PR07MB3870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB3870F618A76B4136E6D3829E883E0@VI1PR07MB3870.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(39860400002)(346002)(366004)(189003)(199004)(956004)(54906003)(66946007)(36756003)(2616005)(5660300002)(6512007)(316002)(52116002)(16526019)(186003)(26005)(6506007)(86362001)(6486002)(6916009)(2906002)(81166006)(6666004)(8936002)(1076003)(478600001)(8676002)(4326008)(66476007)(81156014)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3870;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LEZuzKu6ksDbb+CquHPzC5cTdyrk49IaC6/4o0wY76biHOrwK8N/yZ1omdL00+0I4DPIw/rftkLXObmxtxQwClYNQGS1TT7HaDLm7Cp/9+R24sNNza+6r2NrgLcodySxtcXXg2PktKw1wi+vjplN6YvLvh4rfbHn7bZNau9swJhiHb7mxPN8uwPitM6po98mtjLZgP4+u8tGW/FhOtYJW83rjaXKQEN8ffIb0JeLFpIAdDY3ODwjvkTADuwmPefE07I9Tv190tvE35MsyqWUTmmeIaUzqR1mrwqu5aS5Z2qwIN0tbSh65dQV0dQ73xCWKfnj0aqiSBlOcDeB8S3cYcfZgBhal1AUsSHr2814ud09DZ1dVcKWvyBBFZZS+Rmd+GB3ul5roT22Z+qDxJUUtTRNj+Vqk1NzFmOMYBf805i35GKGlmltDLrGy9kH9afz
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caebf886-b604-431f-bab5-08d79455467a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 16:10:27.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7nur7Yj+iz4jyQjlYXHv/T+AEHWyHeBRlZDrY6a9JuZxoyBLc06yJLOZDOMakrHBdc0l48u3HZODRjYi/VqNu3e3i/Bm4wWMow4beQhyZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3870
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

The PHYs must be registered once in device probe function, not in device
open callback because it's only possible to register them once.

Fixes: a25e278020 ("staging: octeon: support fixed-link phys")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/staging/octeon/ethernet-mdio.c |  6 ------
 drivers/staging/octeon/ethernet.c      | 11 +++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index c798672..d81bddf 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -147,12 +147,6 @@ int cvm_oct_phy_setup_device(struct net_device *dev)
 
 	phy_node = of_parse_phandle(priv->of_node, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(priv->of_node)) {
-		int rc;
-
-		rc = of_phy_register_fixed_link(priv->of_node);
-		if (rc)
-			return rc;
-
 		phy_node = of_node_get(priv->of_node);
 	}
 	if (!phy_node)
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f42c381..241a1db 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -13,6 +13,7 @@
 #include <linux/phy.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
@@ -894,6 +895,16 @@ static int cvm_oct_probe(struct platform_device *pdev)
 				break;
 			}
 
+			if (priv->of_node &&
+			    of_phy_is_fixed_link(priv->of_node)) {
+				r = of_phy_register_fixed_link(priv->of_node);
+				if (r) {
+					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
+						   interface, priv->ipd_port);
+					dev->netdev_ops = NULL;
+				}
+			}
+
 			if (!dev->netdev_ops) {
 				free_netdev(dev);
 			} else if (register_netdev(dev) < 0) {
-- 
2.4.6

