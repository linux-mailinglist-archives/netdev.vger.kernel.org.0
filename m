Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A150B45C923
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhKXPvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:51:38 -0500
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:41123
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231546AbhKXPvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 10:51:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=breH7OdrD4GjpEWPdLQMg5R19QhN/6LhITd4ekFx8Xl04gVfsbfPyteQXdAmYOxSt/pcRi/NL9Yw7x8CwhN5gBGEvQuJKp2R/TLF8O5NHv2GCzqeHawpPkSkTqwrbClOv5p7UHKwD0mxTtljFyjYiW/sYPm8vnCKLgJdX95ioRTUo+GadfEwFkXnQvwPf1YwcOC/v3NWbu/oCHPZpsi3Ze4ZCtM49rzu3geMJ802ygxh576J5R/RCM7YX4k5UpNaTlk3Huf43N2UFfkoyheMSxe0HkiqGvPg+CMEEArUqDGoT7DtHHo05v22nydwINTGIjPs6hBAYE2VI9PL/EOc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbJJrLlw+zYD9eiFLUphfAAFtalKW1j9ec3O0xsPKHc=;
 b=U6+3fUztZNhnzsI1fCogrsWoJj/MQ8cyHBhenVa/3RAAgmsWHL8+RQZ0YVV042q8xosmj/3Nv6r5Ju0cfJLvyi1vmOsEzemlr9W6vjttNlj8eXRXIhjouFriCUP94Y2bwstwKCxc4FpAyIfyXNXsCslqePrxsVHOo39FTlLOIRp9FG0p5aevrYJTuzgBgKcOh9qZlyxH3uJHGFFmhKRjLwGoX1mCcixWJSSDQQF2umkClsWyThMxFtd7Z3yg+rItV27YTsn/jyQwsYwKO2QHNz8gm0m+UCOCKoY0nMmcBbiSvA6wcgm7ijKwpDPt+IOUMjlwSJm6iBgKK9IuUQ5tng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbJJrLlw+zYD9eiFLUphfAAFtalKW1j9ec3O0xsPKHc=;
 b=Ej+eC7/bsAr+q65njsCaxRadoiBdH+cRBHW7Xq5uoeI3qQxkVnwGfguVeAzbFedAwM6EQwgd+Yg20TD3KUFSGMZlDHKECUjlEPgztTkcYdBGEGqG0VDvxyTgrgEvG8Mu4GwiGiLm5zWPKyht1Lo3kfgtw0kAfEfP9aEpKsEZGZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB9017.eurprd04.prod.outlook.com (2603:10a6:10:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 15:48:25 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%5]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 15:48:25 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net v2] net: stmmac: Disable Tx queues when reconfiguring the interface
Date:   Wed, 24 Nov 2021 16:47:31 +0100
Message-Id: <20211124154731.1676949-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0025.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::30) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM9P250CA0025.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Wed, 24 Nov 2021 15:48:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccd9c7a4-d9e1-4c4a-84a5-08d9af61d9e0
X-MS-TrafficTypeDiagnostic: DU2PR04MB9017:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DU2PR04MB901794D080451EADD4E24DE3D2619@DU2PR04MB9017.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZ4znj3YllMb3GnFAz3EH69ppddr1ttzbqxpuGrhZs9PFUpHEAKcrr2IDtUd6fnTrENf9PSXpo3xgq8wmzWi4GqHnoZX0EYoP/LIQifBDUchSkig3e84CF9EEUqzFzvl4KRPBDhQ81yEHzJD/87FK3iKOQ98xhmYKF74ok/Em3e3UhN23XRFSg22BXj/RWYmYLsOqzjHWtoggZ0kS/+Jn9+t5CB8QQfuS1ImJqe3fbFjTvoP+DAZXHaPl8SAauuj/aMOe8OtaJxR/mMbJO8Hnx0lqHYTFwNOjBfwmPBVj5QRZ//ruMaueMe/hCidGM2662aElM2SFpfhP7yr5D3N15e9/nsprlv0iX2vKiROeB2uCVeyLWHPwp45qrTi6zoa2Mv/UZM+8bG2HobJq1v4zCeZX81DketvacFU2h9+7lsLk9QlWQ2ZiekvaHmFi83M9YzqZwcDoreSd1RQTGvSDANQM7wXfNunlSMM5F5X4CWCwNV3pc2cdb2jLcGOklrakclApk5+juCWuPJOphsRUpXgNI6qb5KTW4UTjHBY/rLcOwcpuepR9Nv7yAGfr4Cq6i86b0/KDHluJvwKxRmd/qflJeuTlL6EhIvoXhoa0UE1qpJ0sTfVoOE8ErV9mioGCJxYoe3lVzm9fV+E0leVh59HKNY3sknblWx7jjv0I9jblyNPH4V288F8oKhcB6lWmnJjKGh0LW3IoCS8IMM87M3n4bfrIe2xBu0sy6ihBSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(508600001)(6666004)(83380400001)(6486002)(38100700002)(66946007)(1076003)(316002)(66476007)(2616005)(52116002)(26005)(44832011)(86362001)(186003)(6636002)(38350700002)(8936002)(4326008)(2906002)(921005)(8676002)(6512007)(5660300002)(956004)(110136005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TjlAexMhzMwonVCZ2/Z5inkr+iYb3gVn/Pox+JIijwhPfXZ1mrqKhwscq6s6?=
 =?us-ascii?Q?Vwje+rsI1zvxV0soZ4IAGQyBvucAlv8ooMTdR4PzJl8Xik7WNezdLy8IpE5q?=
 =?us-ascii?Q?BndY6o886dCcUIHYLIc0XmuMgh+2NVKQYTJQE0kGQpT4hD/QcE3YlRok1A5H?=
 =?us-ascii?Q?94TjpI5ZbF933iTvtvY9B3GiU5CqidHCNJkexrCB1ftil0lzYjDHeR+e6Ga0?=
 =?us-ascii?Q?LZN+b8WDwEbG3Md/zFc0m6JvzNWP0LSSo+b3gMruHQH9ZLoZKjyth1xWAW4z?=
 =?us-ascii?Q?ncV5XwpagLlqWoSGxbXzGjnjb+dOOdcNXKHGWLqlpczrXvNoM8DXbzY4TKXO?=
 =?us-ascii?Q?1RBBA6SWzfqJM3dofeBtas5xpcCCtQIMsg7Kt9uS+2ZDVFm4rpS9aKjpgu2m?=
 =?us-ascii?Q?rv84SJ7O0I0aaauw+OdUHtN94HY7KOQuGayreuRVDXowyzqz2uZ6+iTzw0Mk?=
 =?us-ascii?Q?EzwPJMMnUfLmT/4eCRgibPSwceZxlySMXF2RtDmLavp8WZ/cUAYaCRtSFZyQ?=
 =?us-ascii?Q?7Qw16ISGNme1pGkBFM1nWquSGanXoBDhlzgFb40owjoyKlgyvd+0qrgnHXn3?=
 =?us-ascii?Q?r5oQrM1ztMup6oMddIDWVJ/L6xErMa4971eAIUnXifjOBQhYlVYNEq1Iewfo?=
 =?us-ascii?Q?mGBMQUjGQ6cuFBjv3X4uqdCvj8cz4y4bYtgXhA01Q58S/yV6cohS/MEpoXzd?=
 =?us-ascii?Q?gva2rSKoMzlAM+XFqRUX61Ofkw0arBOPkAZXLb4ijZI0k+J8EA+vJWOjU2W7?=
 =?us-ascii?Q?yqukWPYvzRdNHEphz9rXnJ1TgY/a4EJz/DOqpXxc2kRNBWzSWzR8VELOS+kd?=
 =?us-ascii?Q?Erq2CIbkRI7C6YMKn4awQxNdV8eV4PfDiI8x3nf+8uTA5I8DbhsPnILfIUmd?=
 =?us-ascii?Q?bsAX89J4MmSj7mdITV0eNBdqEKP30Q0xz84ozPMUa5YO0znMPGqBThfeZwt5?=
 =?us-ascii?Q?ByLox6DaTm+zqXHWixrWXv/RHMnx5dyaJNL4H4uZkDnrPYl+tLy1vjAQtNq5?=
 =?us-ascii?Q?iDxWM410Uu/gh8lzu4OZMvFw//xxkRvEEbU191St0mAdr7GRh5nWUgvIncHl?=
 =?us-ascii?Q?WfMKHNE0auTgnTWxJdPPNtVobFTMFL/tZWB3E8I7OPknF9YX+05WSWHJuzmW?=
 =?us-ascii?Q?O8FlN9j78s1u+4TX15shgSVY1h3NSbxPP7rBy9iLZzfOiY/40qZ8tjiEG6PR?=
 =?us-ascii?Q?DKF0wH8ZqiPAoqtouiMQNsP9jJ/vMUCSJYusfp8t6nIEOzVCE2Q69wcqNESe?=
 =?us-ascii?Q?kcl1mR1qPOv45ytqTZnN7XrSMHbD32QW3rWZWABMYg66jwsg8+TEmnhzCbd8?=
 =?us-ascii?Q?hzj2ra1DbncrOjvXfXjPwUTgN56bqsMDDuzK36bLiPohxuAzWbwp4oHjLtHF?=
 =?us-ascii?Q?cRfP2Iigelk1i9p5skfETtN8Qt2mPl5tKeu/kcsyWu+TjcVffPfU+dcyb9ku?=
 =?us-ascii?Q?xxPH4K3pVY9BKkhUrg7lbBTYsI98nqasi0KNx7n3hED/ZHnK/tb9DT0lUP/u?=
 =?us-ascii?Q?ApRmUv999Hhzq7N2DWmvoMBY2Ma94Y3tCv8fndUmhzu/KFk+mB68cMN7vY/6?=
 =?us-ascii?Q?J6+b7PPGb9g5Wc1A5WTdnltDBCXhngFeO4b14J/PttIi9VpNSlXuDNmF0CtS?=
 =?us-ascii?Q?Wsi/W+oZ2jJAqGXMWs/Hwd8=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd9c7a4-d9e1-4c4a-84a5-08d9af61d9e0
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 15:48:25.3974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lxy3iZsXUBrSecb4x9wLVGF5VKZYKPRWZVYbsEqQtRNdOgqwOoY9oVUIjYGOFfMqwBYB1IHjj2ewUyZKlD2f9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

The Tx queues were not disabled in situations where the driver needed to
stop the interface to apply a new configuration. This could result in a
kernel panic when doing any of the 3 following actions:
* reconfiguring the number of queues (ethtool -L)
* reconfiguring the size of the ring buffers (ethtool -G)
* installing/removing an XDP program (ip l set dev ethX xdp)

Prevent the panic by making sure netif_tx_disable is called when stopping
an interface.

Without this patch, the following kernel panic can be observed when doing
any of the actions above:

Unable to handle kernel paging request at virtual address ffff80001238d040
[....]
 Call trace:
  dwmac4_set_addr+0x8/0x10
  dev_hard_start_xmit+0xe4/0x1ac
  sch_direct_xmit+0xe8/0x39c
  __dev_queue_xmit+0x3ec/0xaf0
  dev_queue_xmit+0x14/0x20
[...]
[ end trace 0000000000000002 ]---

Fixes: 5fabb01207a2d ("net: stmmac: Add initial XDP support")
Fixes: aa042f60e4961 ("net: stmmac: Add support to Ethtool get/set ring parameters")
Fixes: 0366f7e06a6be ("net: stmmac: add ethtool support for get/set channels")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f12097c8a485..748195697e5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3802,6 +3802,8 @@ int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	netif_tx_disable(dev);
+
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
-- 
2.25.1

