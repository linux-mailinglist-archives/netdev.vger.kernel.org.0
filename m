Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F7C42EA8B
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhJOHwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:52:17 -0400
Received: from mail-eopbgr1310122.outbound.protection.outlook.com ([40.107.131.122]:58784
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236198AbhJOHwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 03:52:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXFF5hCZVAXwkj7OGND85vsexG/12/2sM8nt0pSjYBqmAilyYUhzwRwVL/TSbB7LrMwGn2tOVqg13B9NE6BLgXWVoVY/Pxmujyi5MsCuwCDOf12QZfHq61ngnWwQmOfjVa10BYnhxorlmImvbIbkfuPPXAZaT/ZiGLyoWk2ihzJMjP8WQbo27xcZZrU7PUVygzCFHGHKyJX6k/q0OnYLFvby9N2bxsa4hJ2dRhyR8LjisKew57niMjIUndfZPKfXD7G4DarIhdPl1yp2JDejp8zPEXYh3XqaIlR/bnUywzgTBtaQkeUi4LmnUX5FsVPUHXkXOqqy5KvfLTWPpW0kTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJLIN6hNGI3dlKQXf8s98PkQ7taZWBOXok0RGBS0VlA=;
 b=DpQRdjQcZkeVEBla44esfJ6fLTKXt4yHmTJlpzUk8SjGxE5k3g7RsnNvh4ldbfcBuUBCK0uSJFzbLPs3+I13xRNoQV+8I/IN/E90S24+laidFBdBuGup7b02C0JV/FUC9+24fHwXD21IRzcT9eFVSxJWyeHPTu5QKJlGHxXlPjf396qeAtXnvwqoZsfJE60YijspLUJDGoV9uzLGumKSEPd/gFp1afYLh+mRdJFw2BTaPxTc5V5V8OUfv+AoYr4ZG5br+cMJByfC9NgJSCl6lyVb3C5ORIeA1/4zj9PV8NjAb1vzs79dx2i3ZHMnYL7PjInBw2NP83e8kqM279Ue2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJLIN6hNGI3dlKQXf8s98PkQ7taZWBOXok0RGBS0VlA=;
 b=GdSifSMjeHbT+BIWeyQCxQyeaf/etDpO7duhG3FhFCsBthckxFWwyA3QO3iDR2LCdes92AKmijpfoi9Qo2pfs9K604PueTW344qUZ0sv3teG8yRQOdq+7i7qMdjBoM4Tbpq5OJymrIomXxF0kmetASCPiACHNvRVbxIikoROXMA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3822.apcprd06.prod.outlook.com (2603:1096:4:dd::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Fri, 15 Oct 2021 07:50:05 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 07:50:05 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: phy: Add of_node_put() before return
Date:   Fri, 15 Oct 2021 03:49:49 -0400
Message-Id: <20211015074949.14589-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:203:c9::6) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Fri, 15 Oct 2021 07:50:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d6fc678-c0ea-46f0-ee30-08d98fb0666b
X-MS-TrafficTypeDiagnostic: SG2PR06MB3822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB38220FEAB9D9BC4D6DAE5F3AABB99@SG2PR06MB3822.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdDkvcZTeNljInc1WZOwwS19G+6+xaUmXdA1Hwmb3D0MIaxb6Expnyp82hgPmIgaIcLaC2/Eg9BsIt6CmN/lVG4uoaSVe6qZtU3a3giMm88nj50NIWlu5gQxKRN++5YDJz50VfEv7p4YRvnm7PAG6PMpEmtNL2rPrirxXLztfmkR6C8f6oSae4Bi6VMNN0Lexdr+TvWal786UjpCMQ5W8bZZe6Erjh39biFwP+rarvx/wJ1s7IGR1nHrA1HMKqmWVkRpF3heNGUqVErTHpAzXVSpVgZ5moOnO3ERUleLaUbNbNvQ3uC1Xfv21+IuunL/0MwoK2vohleemYPIie1lYp2W0Imyxgc1bOBCBYe2UFRXshNy+AQ5O/qasN9pWWU3If+yKbxsULNjHKhbSjYAsqdFMuImaWzE3OQBMiYXifAC8hRofzbnnmsEsFzm3FG3i6e5+xQ5WVUUU28T5GAa6uPqnosjWqd97h4YNtTCKQqjl6OkN2jyts3fclqy0ZMXP4PBUHYq247g1Dau+Rw/avKjr3PpNNAGpx6v8bMVEjxblN6WsOYGulRksKV7/sIa+1f+NrbLktC1dZOKa/u6jxOb9EC8PKE24vX3/2RSVZEskUeLfxcvGcJrI/ZzZTkfscha+il1SkajtAgNTEX5EfdM3rlfZ8x9m7j7wSR+QMGCfq6CwmvJ7GjqPE0Mu+Hxz17pm4odl6pP16SBqNRGZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(38350700002)(6512007)(186003)(52116002)(4744005)(26005)(5660300002)(8936002)(2616005)(8676002)(956004)(508600001)(6506007)(4326008)(36756003)(66476007)(6486002)(86362001)(316002)(83380400001)(107886003)(110136005)(66556008)(1076003)(2906002)(66946007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0XYmD8DGKwJKoLF9xKX41FqP/7I9dF6wrna0Ir5ChZJj2BkiM1n7mtFQny3?=
 =?us-ascii?Q?lB/e6ZkuDwA8GsQQhrwAP53xylRaS0YmjeBByCkefO2o+oGNJ1sSwaDA/l2O?=
 =?us-ascii?Q?EgU4H5vQk9wEAZlIgmTmBPVxLkOKTGSQ6XJx8rUvqo7yzBgKm+0X04H+JHU3?=
 =?us-ascii?Q?EOEZfNuaU+WJCiYtNWN5Ip5bgOfJ0BLSSQ4HMq+Xi6yroEupUB4yLdsOQAkp?=
 =?us-ascii?Q?De1i2DY/qI6j6g9o5Eqzm4NPu443nOabVh8ZEug1bXISerrMz6jKMBDsEVZl?=
 =?us-ascii?Q?7+05l/6U3zTch/fsQ7Axk8OwazItXILOT0Vf07ZGwOjkIR8zFUw/FktP8nn6?=
 =?us-ascii?Q?xCzJFNwIVtJldb82bajCZf4AZ+9EUeLfKRDYnJxSO3g0z+Ihx0GmY3kGUdmY?=
 =?us-ascii?Q?mzKGkXMSPauePD4wtGWcZT1ph/V87JZdF9+5s2BTTjXyaaTVtC3O8yL3digq?=
 =?us-ascii?Q?5eV2j4q6o2LoduptaUziHptlbTggAJ+5AbztRBY/shlnVOAaDeecpizvbiRQ?=
 =?us-ascii?Q?Z31QkPisS9k1xJ7qVQ2VMW4xHpDKRS2oFFkZjYkgY44fEFrC6vw+4RkPmgRn?=
 =?us-ascii?Q?3FOUzm6MGZg8YM0OACh1b1YMIMFkYD6xZY6OdEQDz20oxDBQgrKc9NATYgti?=
 =?us-ascii?Q?xrIscybJk6bbZylIUfHuQBqI8mezq8bfoPVJ9YOmCvzaCfOFlFqvUGfINSco?=
 =?us-ascii?Q?Qzfiw1aEKOdjnRmK4+HBU+fNVJmXrnRBFJNE9KY2ogEiypDV5Wj3Ci5k/eZf?=
 =?us-ascii?Q?Gol8D58crwdw4NOFKiO9pgC0OO6z2gxXxREZN1cW6kb1dHapEuAF0ZW7p3D0?=
 =?us-ascii?Q?s22y2MXe0IF5eZVxYpfnM+Bgh6KhqBbX0KAknb1yvcz7R2aqYfN7Dpek2P1g?=
 =?us-ascii?Q?+5QyOec1wmShSnzSUS9gb4hnDeCuQ5U64lmwJEGbHECgRyiholkceXJ8KnhA?=
 =?us-ascii?Q?7SVc+orwo/R4X/oYMs8Qn3bEV9D7bIHvtRTHHiFV6mYouxG4j4Lflkkmff8i?=
 =?us-ascii?Q?qzKQtyMUXnv5iuM3mH4VWmmhiWrpsdyS87I5KezE3dUXiBjiBSiwhP8adGJZ?=
 =?us-ascii?Q?9g7Larl6C5B3Cstt0MlFq7fI5CNV4Tnha/j/Pa9cIaKJRaLaZZNx2QHzNxff?=
 =?us-ascii?Q?YCoznfycRSUsfy+OtgZ4pW+qm34i508KL2em72BymJGUTgt0sRvNg2cfZv3G?=
 =?us-ascii?Q?sgSL+bMXKR+xkWqOPKGEGTjX8vFVJFPoyyCoXR8FtJk7o2FiTYYWd2ZKAWvy?=
 =?us-ascii?Q?LY7dtA/+v3RQ8aQLX5F3WEPK20TnIRll3QaPFfrE0Wq6nlAUi9ETM/z3Srxv?=
 =?us-ascii?Q?aiuy5UsnyzaPNzYKJNyklhpf?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6fc678-c0ea-46f0-ee30-08d98fb0666b
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 07:50:04.8139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZKptHd4EZuYp8wris8v8pD6w7OBxqalp7bx4+sLVunfh7c3IeneZZ12BI5GprGITkZwnzbjjyXjD6i9o6FlOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3822
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/phy/mdio_bus.c:454:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before return

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/phy/mdio_bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c204067f1890..d19ee8a69e6c 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -460,6 +460,7 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 
 		if (addr == mdiodev->addr) {
 			device_set_node(dev, of_fwnode_handle(child));
+			of_node_put(child);
 			return;
 		}
 	}
-- 
2.20.1

