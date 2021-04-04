Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0363537BB
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 12:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhDDKIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 06:08:19 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:28443
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229578AbhDDKIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 06:08:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6PLYyaWZDnC2ofF2cIvPAigsPutd4y68C8xHJR4LNU7TI7o9SPzuxHaxd5V4nsyJsO9482BOY96HlhpZULX995eR9/9o8KVQShy1jKLJGAvFB0l6gtTBsmZrvcGAPuiE82fuTzxEGg9zfdtOmO0z8A7Pf+UQFx8xkDvZGJ5VsPtF7thvpt510op0U8iAUqW2zyLYKNBUcC6kZhXytCcu34dyGDj+YBhWJLKYWGi3Dz+GxlMI2i8s7Ncu1jMPpA0oDk3hs4uz+WqMJl4heFdl+DqpvG1SnKwOmWErcW+Ba37F90nrKVZRTuqM9QraVRojKN4XDZOlUHRMHgzQpYxmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5SZ10Yfb0ZCpMVeE7d61gRxiopmactadSurdMCXwm0=;
 b=Nqi/qCc3EIsbXceWvvKUebfUGoMU4prAu6pUEVN0DdSJK2+ULAfjSXZSJNMZTN143IaQHRsyty9csc/aagcoBY93dVV6ikU/zPbzxIfnbYZAvTt/ArVxcJagEQDd5FvtSe3nFzr2SdQwo/Y+uWAw3iBPAzQFk/N/5UCiQaQ1irdDoR/VN3JPjFZ20dGrp12TnyPXI0YNJqe4r0pOnEuvJcHljmkfgq+KjjLeB6or50EQQ4ciIJuOuRXrlLWeZYAi2TYYCYJQRZK8ARorejNZIUp0hDNM0cc3J3unj2uvZURri1n731lDyhTcg50qV5GhTREu0mwttvdVHUH9R3ruOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5SZ10Yfb0ZCpMVeE7d61gRxiopmactadSurdMCXwm0=;
 b=jS/9uTeFHGdENQdr9NhDRpcS+57nj1qtg22eQ1aWUoUQQVw4cNK/KCoEPmejlnzL+GGSIY2v7lWX1t9X7V1CwFPBcOOPcm5WX7E01rXAdsBDGtadE7TjdCuvpFn9T8SXSKJUtaPlN0Jw5zvExJT6/NPpk+pL2of9VuJ0JoXeHVk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4956.eurprd04.prod.outlook.com (2603:10a6:10:1a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sun, 4 Apr
 2021 10:08:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.032; Sun, 4 Apr 2021
 10:08:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, christian.melki@t2data.com
Subject: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume back
Date:   Sun,  4 Apr 2021 18:07:01 +0800
Message-Id: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HKAPR03CA0003.apcprd03.prod.outlook.com
 (2603:1096:203:c8::8) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HKAPR03CA0003.apcprd03.prod.outlook.com (2603:1096:203:c8::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Sun, 4 Apr 2021 10:08:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4b536d7-bba5-45a7-1641-08d8f7518dc4
X-MS-TrafficTypeDiagnostic: DB7PR04MB4956:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4956F05A447BF46766A94C04E6789@DB7PR04MB4956.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVdwzFDJYT+EynF0FgQLtCjZ3VinPxvWdFze63iv9rQhbmmhMNXxs4s60tQBVcCwdhE2hCh2sFyKirijpNdF7MenghNgyVv77Rz9j16+7nCe1VCy3vh8AaoZ2uhlr/x6HQk2jNjHkvt6eV8EC2S/10RNN1RFUnlMwEpNiMOZjkCUV6pidNMQ54f/Bhl8Z5riCqL81eafmPt0jJh+6QGWeUb5MQFdvux4r+om+Cz0LN9Qe1oTSYgjr94Ej+dcI2W9yOtDE0I2XTLE0EpR9mxuWdCZYhJCkAwMGOAn/sxrjZf8V6dqF17zEj8MEeohv5+IKvrk33myh2hQ3rd+CU1OCpY1QB0SLdo8nI+j1TJkgR6LfkZfd1xe41EWg0eHcTVWmYMfdTbNv99vy9xE29vc+wsNouHOLGyz8FwaQCd4NQqwbs1zP77d86omL+BD0+AZi5r6EO2yLzd8xhErnkl4GX1y2StzacEVTsXlASnB89YxIroU/yZgz6+viDYOO7xX4BY6W40SQkyBRS33Y0Cqudcow9YgUBSBgUlWGvdAQepPh1lRcxwym04NJOCwhPldY7PWKpNiC1I4mlcZ94ti5LqpInNPo1YkI4/tK1hVpuRi8LJGVURIhflmhuxHFmj488lMgOM6DeY5gnQD6GG1tQAAHtjnNiFKw9j2A+7po3lCR8DXBaVOJTKB8dkF5WLH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(4326008)(2906002)(83380400001)(38100700001)(6506007)(478600001)(6486002)(8676002)(8936002)(69590400012)(36756003)(956004)(2616005)(66556008)(5660300002)(1076003)(52116002)(186003)(16526019)(26005)(316002)(6666004)(66476007)(66946007)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UuaQ04vZFr4LI69uy+PVvOhcybGd2864WDjTxirKZ1Z6ErxgIO6XnxkfbldS?=
 =?us-ascii?Q?xilzYu4DL2+QReo2fYb0A+jubAnH9x1V2zwrXreSzbjlkabud9qLqe8JU4nR?=
 =?us-ascii?Q?5Zz3WnC/FZZvmIcxcsi1ie7KMdpzlQo0HgizYNqk3YZkgQfl/fRSgj9AjLuw?=
 =?us-ascii?Q?NzFlHpttDo6X4dkQvoJ/eOA0Nc0AhQK0wnmhzKSO+F0RfAVeV9MD9uaKy6mA?=
 =?us-ascii?Q?5FhmzHveOf8baSO6+ltCNFsJHY698ZPUEmo7dLxPUN5IvhGvXavZenFoaWOh?=
 =?us-ascii?Q?2md3ZXE5Cob+tXoeL8Q0OQGYPx4rDgAJMmXQzcq4Ck8hMmuFU0BpOcVD5Yfl?=
 =?us-ascii?Q?w0VISaqDyRl4aQfQ52rVfX2uUm3m+mIY9zjVKmM7qHbjrrs+192bOmVCn7AH?=
 =?us-ascii?Q?qrW9TmesFoodpl7+ybwvvnN4+F5BUR9qvlLrh/xH/ZJTy2LcMpX0vs1gbgI5?=
 =?us-ascii?Q?/2MZIiz29p2/XDwulzIO61e0H1TOXH5jFKSRSD33kQSPHXmngGiYkF92NIf6?=
 =?us-ascii?Q?mp7i2zAxgWVejjMdEoPvf6Vv2VAAIy2SfrjxVq1NyIJCnLHO/iYJscaTXBSK?=
 =?us-ascii?Q?AZgfJoZcjwVdNHqmPqR43Fgv5IPN67WCHbnEYHFg7f61OCC99Ykce8BI7TAO?=
 =?us-ascii?Q?hP2sIh8nHKzpf1wjJl7oFymoTzWzWl1jdUZeXJ14+YWE73KpaZSPWeyjhXDH?=
 =?us-ascii?Q?C7bA5SRv9rQEKDaeTHWxoTpRskR2YmHepcmwlC8IjQqovaj/VZt3SqZZPp00?=
 =?us-ascii?Q?NjQBuP6yZMhPeSl+2UVCIgEeVwTec7yqwTu0Qj7BDB5P2+EkM90NJMNMSoed?=
 =?us-ascii?Q?1aEXVOySl9tg2R4vkFkuRYFkuF9/EPRVH4NqmlkyKSL3Kq7CCldVVyRK2bO3?=
 =?us-ascii?Q?UvRvmfjSMEYKtw1wj2pf4QGXzj1q6sXbw1l4xabnIc98EN70NKIAGb6wdvmG?=
 =?us-ascii?Q?R2UKnKT05dOJaa8WHkcP1Vfh1Xy7NosMNLGLQj/HMcVVSJgG5KHaORFwbbCN?=
 =?us-ascii?Q?hokE+N8EcpDMqxGB/m/rMrU5IN8AetmpA+AcCmhK+f5iupidlVh/lT6xFIIR?=
 =?us-ascii?Q?Bc5ADhNOZf8HPVKYkSpCWPGMPLsX3DWOsLs2F9F+BFJi0QFpxjAJ+Z9dJ6a7?=
 =?us-ascii?Q?CT3EfrC8c/0cDB5V4e6McJc6hC865Ehpmh+UZxR9qRtTeEty9TrBUARyHjrC?=
 =?us-ascii?Q?8QimOw72KYJBfy3TzPU4XiV039Mmmc8DlsFHuDhftgMIHQuFQC3zFUQuM4Y+?=
 =?us-ascii?Q?v9tgyfwwkyTRUzHMU5Rb8iW2mpQ3zeph6MO6eBdxKoUqgole4oRN3DAWyGSK?=
 =?us-ascii?Q?2ICUSC8qzVultgc/wd4VL6ul?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b536d7-bba5-45a7-1641-08d8f7518dc4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 10:08:11.7497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Y2OUKWla5tzVUyiIYBmI8t7kCICYaXKLY/04ukafFGN/qVkX3lYkPS6hk7dWD5cxBPGSHqsuSmdeTpYVsoahQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
soft reset PHY if PHY driver implements soft_reset callback.
commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
work any more when system resume back, MAC driver is fec_main.c.

It's obvious that initializing PHY hardware when MDIO bus resume back
would introduce some regression when PHY implements soft_reset. When I
am debugging, I found PHY works fine if MAC doesn't support suspend/resume
or phy_stop()/phy_start() doesn't been called during suspend/resume. This
let me realize, PHY state machine phy_state_machine() could do something
breaks the PHY.

As we known, MAC resume first and then MDIO bus resume when system
resume back from suspend. When MAC resume, usually it will invoke
phy_start() where to change PHY state to PHY_UP, then trigger the state
machine to run now. In phy_state_machine(), it will start/config
auto-nego, then change PHY state to PHY_NOLINK, what to next is
periodically check PHY link status. When MDIO bus resume, it will
initialize PHY hardware, including soft_reset, what would soft_reset
affect seems various from different PHYs. For KSZ8081RNB, when it in
PHY_NOLINK state and then perform a soft reset, it will never complete
auto-nego.

This patch changes PHY state to PHY_UP when MDIO bus resume back, it
should be reasonable after PHY hardware re-initialized. Also give state
machine a chance to start/config auto-nego again.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/phy_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..312a6f662481 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
+
+	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
+	 * rounte with phy_start(), here change to PHY_UP after re-initializing
+	 * PHY hardware, let PHY state machine to start/config auto-nego again.
+	 */
+	phydev->state = PHY_UP;
+
 no_resume:
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
-- 
2.17.1

