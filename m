Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8753C2DE1A3
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389315AbgLRK6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:58:01 -0500
Received: from mail-vi1eur05on2110.outbound.protection.outlook.com ([40.107.21.110]:62177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389290AbgLRK6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 05:58:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBn1N7wFfZqEMkR0xU4gEFP/1LO3xtB/9sKLddq9xzvHcaSSK/IoIzRYnEL9+vXV7+R2MHZjjxB9QU9pZOCNc7BLnjdQ9MqpdfRF6tsaXrgxgeRokQeQxfXfsPIyYsO9kdXI8JPn4UqDaTJRS8fbcBggPokDkEupAtgIsFsDXMujSWPnS47CN5QPzWamI8N86mvTyPVrGo63HEtTNgVqYJRdSUjrhveG0ausoJ0rqx+6I0k26wclGNJT88goe6MybwEFy1v8e4JNR2n85wHQa3dsqLi8jbatBnXIzWTzOi/w1qyB4g+hK/jDfOHn9aPYM5Hrmpo458UWgRDWHCza7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvWQa9GJbeHHpYLFRbIUYYJ7VqMhR/u01W5562zRcTA=;
 b=aDaVcMMUfk8P9a7Go1gIXOFdTnJHJJieDqLbtmzfNHoLRx8FWjhwvt/gkJjT2fHcO7a9As1bkcX/bYdt+CvMGwRhYmmNye/8FPFayQ6UYHMlmO2/T7XWvBQsnzKh5zVUNqwDIbWKbmjB+qTEx9O54/7vGfomd1qkXKHm3w2LZM3Earok9aEDVShXh0e5qO1YwtmUz+owc9GHpm0V+793ysp+up2pi5BjvHfXTMb1TYA9KrUgUBu+F9R9gVPpKyifGqvmyL67OuwCzrAeUdZECiQ4QpgnyeDKky18tKr/ieibZB+8H7tVtXw4tocrKkg7+HgmYejVMpEgxgc4MZHCcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvWQa9GJbeHHpYLFRbIUYYJ7VqMhR/u01W5562zRcTA=;
 b=ZexDRCm8L96O2wIroK7peEwqj5JX+DDyYUky4nQ4eC/ztE1KsPhJikOTehYPDCBLMv6kslFSo4aR4Qne4aLN4iLO7xsKgLCBLI4JHy1OKrZDHkcgt1MjeK2rWEeVIJuLTWgaJPL/KDvJMZWYZY6SKDmXCVSyT4PDxiMe+ucupCA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4163.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 18 Dec
 2020 10:56:39 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 10:56:39 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Zhao Qiang <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net v2 1/3] ethernet: ucc_geth: set dev->max_mtu to 1518
Date:   Fri, 18 Dec 2020 11:55:36 +0100
Message-Id: <20201218105538.30563-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
References: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::41) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 10:56:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05124c28-6f95-4beb-c3d2-08d8a3439889
X-MS-TrafficTypeDiagnostic: AM8PR10MB4163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB4163F4627D2F34EBFA8BCEA393C30@AM8PR10MB4163.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAb94YHceBYBy/IrB1ReJUwzHA8QEb+NCAXS9w5dBAdpTyvDLNsW2fwuJyWVnIuQi8Hhhsbmc/qtweLBt0zUNbbVTSN51k+k6EHcqE8YZBeQQFCMEVsPeRAWVNRVcR7mhq+Adi+AfKwVdmL2QFXlKmOMgH92/496dej8oYhSOunAuof+eX5BLBUtPiiv/PHMz7a2NOWt0sydmF8bw/koX1hpt8qQKCKcH6fw3qMCUivkYSrCaDfa7+yqqaYeRzmY7hdB6rMPZ7V6jCA8Szja7F4B4w8FfEnSmMkGyOKosKNfv3zX+V7Viq6WTu9dah+XOx2f+lR+6caosGI4snT73Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39840400004)(396003)(366004)(136003)(346002)(44832011)(66946007)(36756003)(26005)(66556008)(2616005)(52116002)(478600001)(316002)(86362001)(54906003)(8976002)(956004)(1076003)(186003)(2906002)(16526019)(8676002)(6486002)(6506007)(4326008)(83380400001)(5660300002)(110136005)(66476007)(6512007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5+kJ8rsjnx2gjvQL4GOgERrtAP0+W0i1S2VcVXk1hMIbJmdBdA/SPzBKx7aW?=
 =?us-ascii?Q?6E3WF4j3Z3TtdHkArKE462ZiLzhO5O/2aCC1GbZA552RbsMQT6Orqv9XSfv1?=
 =?us-ascii?Q?8dOzclUCojyDOtqhex92/V7zrxgsnOhBuYiN6WWvcpojYrtUjx3z4m/sSiCT?=
 =?us-ascii?Q?EkakbvYwnmKN56d/mTSy/Qj9rScETgjycsDnnmfBQoQ5Vr7hgoFCg1sM7HoF?=
 =?us-ascii?Q?v7IPOhCs0eq191AWspXMAYPQluNw9c4qgNPno+rZ1jgmMC1pg52il84yPdA+?=
 =?us-ascii?Q?aXYBDyv2sM0qo4jFmzz1xGXbIRigN8nuSG8BJ//PZHtobCc1Wj18LDba9yp2?=
 =?us-ascii?Q?Fb9MauPtgrCtBi51tv+jiYDyrN73i0GKR4vWrdq1OAmrZTxzsrksq0AKZ3Kv?=
 =?us-ascii?Q?n1B86voEdJVofufy1R0xWOCGxUdLnUQaE3b7n9nHDqwdo/G5g9cj0k1vsEpt?=
 =?us-ascii?Q?QM+N6hqviPSFCzru7sNy7PDHIoKMzgTwAhQxiHuAqI5BD3SfKxjdd54NuOv0?=
 =?us-ascii?Q?gEZSz/xJHVycK6cocJLYT52lRYY0l+OmvtmozMnEXbGkAnIuLLeURkQXN49G?=
 =?us-ascii?Q?5gL9+v/o8A5vuV5uAbENd6rZsbV83Dn14hTk45ZUvpTCgv70FXfmA0YdWaL8?=
 =?us-ascii?Q?mtP+X6kxbdc2IhdBKUAK+fqA4pLxuMOmFjgph7WmHcokR5VfOig21U68/Clz?=
 =?us-ascii?Q?YrUsh5je21IkUo+pTx1ax3lWPqw/MPAhSQqjydO1diiR2aG8IBrHFfPXyiCZ?=
 =?us-ascii?Q?qRlBo5k6cgWE6g/58lxVNpor2118NxhTCMgmuKQ+Y7MsUCHvSsIZ675DJUsw?=
 =?us-ascii?Q?1/W8Xa96PFLT2eieZ92SoxeovWBMbwWiYRy6dGgy42eWEHvxmWUhd3LenoeX?=
 =?us-ascii?Q?1WroXI35WCO0Cox0o05f7pn9vcEWPpsJOGYJpcuyTwv/8z98dGhlI0tphgul?=
 =?us-ascii?Q?6EZsTgp8Y4PXc9+iy9CIiAzLA1gXhE3QTl6ZkWqf0FdtonKfoyU7VS62Ak12?=
 =?us-ascii?Q?JS2Y?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 10:56:38.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 05124c28-6f95-4beb-c3d2-08d8a3439889
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xb4+NGZvzLbPkAYDAywlc6Tz7r0tMHUlkI3aYFxmHZkDzRgJ4LA+T+g+Cq4RS3AM08XTVMkSxiCFO9Ql6W/OKU4iJMVeywyaZAJuuXPgJpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the buffers and registers are already set up appropriately for an
MTU slightly above 1500, so we just need to expose this to the
networking stack. AFAICT, there's no need to implement .ndo_change_mtu
when the receive buffers are always set up to support the max_mtu.

This fixes several warnings during boot on our mpc8309-board with an
embedded mv88e6250 switch:

mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
...
mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead

The last line explains what the DSA stack tries to do: achieving an MTU
of 1500 on-the-wire requires that the master netdevice connected to
the CPU port supports an MTU of 1500+the tagging overhead.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 714b501be7d0..380c1f09adaf 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3889,6 +3889,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	INIT_WORK(&ugeth->timeout_work, ucc_geth_timeout_work);
 	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, 64);
 	dev->mtu = 1500;
+	dev->max_mtu = 1518;
 
 	ugeth->msg_enable = netif_msg_init(debug.msg_enable, UGETH_MSG_DEFAULT);
 	ugeth->phy_interface = phy_interface;
-- 
2.23.0

