Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477113C6DA0
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbhGMJkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:40:32 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:12545
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234971AbhGMJkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 05:40:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVpNQijJc/ocwOwy1P8DGCl56lDRmQqtepLJSJW+9Ztnp1XZ0BJ3JGI7boxKo2+h5QFkXVT6bxMGlDkwPUgQX27QplhMgLLUok7W8xDhGWZ3eeD1HsIJOgjh/6K+bBU7LcfyBQkUcwWEiZDsU4fPPdzEKMBLt4HOV34P8JfjmQvU3VxB3nfyZn9gdSSsKI2rdnmdkw4b4roUdG0psYSGT3gJeuc2VQkCCgqshPfY1h5j9qtOJTZ0gyrFRoOlDQVYBcULM5Le5RcCkad55yGFeWz23R/Dpi2wFYLafF2sruxoZIiDjuvijBQIicIlHtnhSKgfdPXhEPHTr8idGsy6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tzCa6Cu6dau0TIFEjSVnXYyAC9SrkPTO29ngeyETHM=;
 b=S1LHFRkpcNKhXyasvgCqszP9MggzHeGetNeJNcdi4QX4gEE4hveD8uVU1ob2bA6UmMwY63L53iWvfjEbDYSqr6RUO9Np6WvZ7WA8jrqT2XshiKx0aKTf/OT6U8DNw1fgJVUhdU9r6R9Rm+s9UHPljeEswl4Gbti8Z+S0YucXz8JCcKdtdbJuGaPLsz3TCk/nbX8z6nSs5Cxut3ZgUShIjDwIZnGpNVCCfNke2O4CQ2tnO0FB4Y5fTftMp8FuONxyqIRZOPAUC14bWgJSAXhO9AztjLp/ZLQ/GkDsspQ912ZXO6/FNynu+u6495Cb+JkRp/cUqeJZHWjmtFxfWqqypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tzCa6Cu6dau0TIFEjSVnXYyAC9SrkPTO29ngeyETHM=;
 b=jvKX37DW79IjVzzsbBxFFyzPWGAiYFhL7WJNX8Au5MuCZ83nMni34nZF+g2+4qWOi/dd8VjxN9Pv9UOwUi1ElQ6Rgwj/+Mlx00bd2B8/HtTYkaOVPxWXPF/gDlrSzjyHOlwPPBIaPPNMyoIKun6er8x+9xNSYXCcdCnVd7ZLYZY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 09:37:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 09:37:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: fix address learning getting disabled on the CPU port
Date:   Tue, 13 Jul 2021 12:37:19 +0300
Message-Id: <20210713093719.940375-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by FR3P281CA0058.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Tue, 13 Jul 2021 09:37:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a18d1a3-8c5d-4bba-dd20-08d945e1db23
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686C9A8F6B332E76A99D0FBE0149@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +t/9cWPVbxOv32w1w77S8QaPWTq/QYDFEE0fdpLmzXIEgQqTzVNibCB0InULsQK1Uy2n+gSWO5XMsyQyzWmCtlPi1vF/7jp0g6ecd1r54TeTnnUGtNhVLMaRRJOpYfBaWboxINxvBqfZw/3eXKwEQSg+qhXfcZImGO6e0opuHAb9eLdaAvLr+3ESOakmj/iW42Kr/muTPSt2xaJ0aSMGoHrhNSYz+/MrkB5Y2+YDSsgKjG/AIMW1nh/2a4rQXP/kgGeFlUIRl3B7pc4VNnJ/OWlR1xPABz6RNpQWQSw8j9shMBjgOPjLd8lwCNLHlVodPu29Dl/vrs+dEGph/B7amXrPYdjqTTSBikeIZ1OdZYC6KxWf7Hef3RmHs0d8weww1CPJ632ER7bUw/x7k/DRKMru0ELIrja+1PrupT8qYXWDWkcZPZDAvKEt+cqX4rjLchyor/9Xqg+Z9uOTsNVs6gICUbMjwPI+OurW73EWsSSOqLREHZHqyncFl17xhTtlZ/65SJaxr7f17NAxbWB2kwr7WZn8M8Wt29rmxwGbkdacFiHvbmDrc8RJ6HtBfdDJZc3LX23ddkiJn7feCDQOIuEpMD9LVUi8WqJuQ+sGQWq81LFT/kc4z29ZGuACnwO/BWy9cb2v3se3d/joY8mms0RMho7TdOowFKF6PuEMwNNQcn4ejyugd8NZ7EISJgCi1VJvbXcWneP6PdPkj9Lpmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(44832011)(52116002)(2906002)(6512007)(478600001)(66556008)(38350700002)(186003)(66476007)(38100700002)(6666004)(66946007)(1076003)(26005)(4326008)(316002)(8676002)(36756003)(110136005)(6506007)(83380400001)(8936002)(86362001)(6486002)(956004)(5660300002)(2616005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uk88gPnTwAbg3YIER1UjbGcFb/amtlvG5rn6/fTiTGW2MgQDtlm1JLoE9ziO?=
 =?us-ascii?Q?lTFDknlkfsKg4uxqs+E2pWs7djyR3QotP+rX3BthDFdRsxN5LyoXzVsfRSIB?=
 =?us-ascii?Q?TbU6xtlZ/zT0CEUlO3W72GATftCs+hlsCBiQUaooVEJIJWzJB6m+UbGbF+TO?=
 =?us-ascii?Q?+aGWfD+VyQKTdsJvdCpLNzjF95tBuVzpeFR0v9nUKnd83lkbzc6QvAyNQu54?=
 =?us-ascii?Q?UramFjr70hE08fCvMtSsGcEuv5lIb8nXtkn/SHcTTvdHKSGMN6VvDFTNOf3Z?=
 =?us-ascii?Q?NEFVwYO+xzeuYsqOWStLebBYQrwOEl1pa1jHXgxsebpCLT4BvwgHEHCcjndn?=
 =?us-ascii?Q?jnneOL2LXB0Mj+aiDN2duBx6cn6w7KkEv7IgiN4820CQQ9sVbX95rlv4LuGk?=
 =?us-ascii?Q?BLBmokPGon+dlx1Qhtp0G8vlkb7mBb0KcAPKnMPiV4W3xJ3XR1v3iI+KGD38?=
 =?us-ascii?Q?Bq2hIvSt1WHlTkBdY2uTLXaIxJo3/86mXIVj72VxRXVWnNSQV2yLeKx70w63?=
 =?us-ascii?Q?R+muYz5zxCxA1QLfM2bwWq6StYds5Xm4Rk32K0F7dX/Sy5JKZIiSWRT3tumN?=
 =?us-ascii?Q?kQxkFi78raI46ypvVV3f7wh2f44IvANC+s11xxxOoWptuloc/3GCYyPNtDn9?=
 =?us-ascii?Q?z8RJ2pIBliCDBwHKC2OefUmwdlIilPq2qK51QMHHDOWKuNxc3PKJ1Qw2LnYm?=
 =?us-ascii?Q?bbcuoOCbodxvmHwWwo4gRxF6LtsHtrgUyJlWCdGPFIf/aNmrngGksjUGDOY9?=
 =?us-ascii?Q?n/Na0k9/EUz64ouIZPlEnXJSSNtBFIMkKd/XHm67XX3e2O2gNXUjGCyc43Gf?=
 =?us-ascii?Q?iLQTLgtInOgvLcP2iyULUkPIOCLDLJ05WIbIZtHePlspZeXtdJWk7Eym47qY?=
 =?us-ascii?Q?6ZD2HumBNkIdDBNZdd2WTULo6ITaiiQwrTyHF7v5y/qxZYbKGZL8IbIsmf6g?=
 =?us-ascii?Q?yU6/5NrhFGZ3iIHabdbxFB4wzz7NyOmONBOx2jW3iZ1GMtd8fP5SnMQ02DsV?=
 =?us-ascii?Q?kKskoHZcWx7wEcka6YC2pVtUoD0xzblkHBfx12ZoKYI26pgGHvAMyDWET1jI?=
 =?us-ascii?Q?FlZNwWsPMMLiyCGEQ0d811LquwtDMt+kQ04CSaCW3sKYe4Wadg3aNm8bFeWL?=
 =?us-ascii?Q?6ttYEsdTCi7VsBttBKgemk4yo1g8IoI0QceY+h478m5aAKkytdrQ4hBTLV6X?=
 =?us-ascii?Q?3niTIlZ1dA7x5VhvNMyHPhArcZP5VuWXvMMI/h0RpPjMrYSJv4qTUQMqBbcj?=
 =?us-ascii?Q?QJjI4eYCz7x5vDal743qE+1ComrAiJs6CAEzbqB5ldA00OPkmdHsC5cmYHdU?=
 =?us-ascii?Q?vJXpphIvkWx3Pfmm9FH6poiJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a18d1a3-8c5d-4bba-dd20-08d945e1db23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 09:37:39.7993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rx/J6dLNkwhLb3VoIjoMOh6yAB35gpYc10pJapn0A4EFGFNu80E4VoNlAS5qpN+ilFfl/veR4sFl97mMd52s9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In May 2019 when commit 640f763f98c2 ("net: dsa: sja1105: Add support
for Spanning Tree Protocol") was introduced, the comment that "STP does
not get called for the CPU port" was true. This changed after commit
0394a63acfe2 ("net: dsa: enable and disable all ports") in August 2019
and went largely unnoticed, because the sja1105_bridge_stp_state_set()
method did nothing different compared to the static setup done by
sja1105_init_mac_settings().

With the ability to turn address learning off introduced by the blamed
commit, there is a new priv->learn_ena port mask in the driver. When
sja1105_bridge_stp_state_set() gets called and we are in
BR_STATE_LEARNING or later, address learning is enabled or not depending
on priv->learn_ena & BIT(port).

So what happens is that priv->learn_ena is not being set from anywhere
for the CPU port, and the static configuration done by
sja1105_init_mac_settings() is being overwritten.

To solve this, acknowledge that the static configuration of STP state is
no longer necessary because the STP state is being set by the DSA core
now, but what is necessary is to set priv->learn_ena for the CPU port.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4f0545605f6b..ced8c9cb29c2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -122,14 +122,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	for (i = 0; i < ds->num_ports; i++) {
 		mac[i] = default_mac;
-		if (i == dsa_upstream_port(priv->ds, i)) {
-			/* STP doesn't get called for CPU port, so we need to
-			 * set the I/O parameters statically.
-			 */
-			mac[i].dyn_learn = true;
-			mac[i].ingress = true;
-			mac[i].egress = true;
-		}
+
+		/* Let sja1105_bridge_stp_state_set() keep address learning
+		 * enabled for the CPU port.
+		 */
+		if (dsa_is_cpu_port(ds, i))
+			priv->learn_ena |= BIT(i);
 	}
 
 	return 0;
-- 
2.25.1

