Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13ED3C6D64
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhGMJbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:31:25 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:26546
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234819AbhGMJbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 05:31:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzQ0axh9FZSMpYLY/yqaOIjeCoGF5bOEPnzff/1QEw6ybU3mNUPQG/g1e//ReC0aAN2Qa3t3i1ykDNaBpo2M5MI+Abo6PlgST4Qw8Ulkc87xgR8BMm1JXhTppkmmhBBsX1kvrJuEerYRUUZKn3FBQK7yGtfXbdB49G/QHlOdtIHYEkJReTcnYYcwprivjvK+sXpqlRxE6pQC5n00tMcMa1jM8vMvYhMKeFw0xYJn+QM37h287IRxNtNVyBczp2LfaSfpwtmkzqk7TSiFBgZEmF2C+D6qXIHNRq9/zx8vjBfU/3YfBtA2YHceXtC9aKp0aMkVxaouRah8t0mzjKVang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBSqsCdvCyblflGOv12u6EbIfLBZ8HlWB9gGAw+CmPU=;
 b=niCyPJkeMOpmaXb2O8SndOcgW0hLLIvQaO6RzcdDkwGDpdF7/FnR5hbDhuHs7NODSRSI+a2Tbv/ABWD3YlWbDKy+DITCAOIBH6yALZEM2bQKcEKLctlhvq+8j5FDwWsP+TKgbuIWLs5Crfp4bKxcge4PsUHbKfaZ786fUBW0m4Yb2dnF6M0Y3/+fYEPLdCdIpctnZFP9kXaoTbAXfds26z15EvBLwVX1Vp464D6cQ3tE++NnZpqv872cigWGwJHKUQuE8ZMhPaOhIi9OsMTOIWVXeGeOzF2AJst1toX7LBB5NO0PEOk6vtljYOafV9UMcNoNYFER2Fvvu5+ujZoQLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBSqsCdvCyblflGOv12u6EbIfLBZ8HlWB9gGAw+CmPU=;
 b=F2S4Zq4y52qUEkMHefi5+6k5k5B2DeLb2x4J/caVpdYfogV86Tc7UNOA9+tJZXu93tiylnpuVc2OlsmBAnq5w/+9y/6NMRyM9E+OfH0dtdp5ureaaU/lVmtfkfldvNzZyT+wr+JW6mbobV+udQ5sq005+k9xiUoL27rXPHB85mQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 09:28:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 09:28:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net] net: marvell: prestera: if the LAG that we're joining is under a bridge, join it
Date:   Tue, 13 Jul 2021 12:28:04 +0300
Message-Id: <20210713092804.938365-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0030.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR2P264CA0030.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 09:28:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d507c9f3-5a7f-4516-56a1-08d945e094f8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5136845F8D2F1C00E6716E13E0149@VI1PR04MB5136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiaWC7qlx8azxD6oSERrjSWtBfmv1EQgTpTKhJUuO8A6LFJwIYN/YKOtp1HPGNQKXIn+6hGjoGMChtaro0mLLQH+tD41OrmCjIV+v+BPa3kulP2cj3upRLXidziGfBSoH08PxuL0ZdCB4zm/Z+RKYaBei4cWGsIK/MmTtLXAXuVoDQSepQYxun8De8M6AUUXS1gmVq2Uko8XKyobHTB139EeR99oFZQGUjvuNctysODwd6UWf0qcXF3hQ5Pca/7lWRt63qeqMPYVaBCDR5u5MmvGVl/SwrGfgMl6+E9TZVgYv4asZqB0cwcZ7ZZiCnf/nLSBGRh1TaLHm+nOtd59D+0jxbQ9x/YpwmqgxmYUsBcnndOkh3AuVcbpEA40fZ+EIqB4PmBpG0/q6L3snUUwYUjsnSJsYYo0c9jkoI07cWgqJT2+DEGza4QUBqe4DDB301xd/P4JyQLZctfbCkQm/1mFUWu8Y8omHET4wagK9yaO2pTk85KVjcrHFM2mSXVibRh5H/Gov1Ox/0I/gmyGMgcBR4v1j6p7Bfl2DV2qrgINmBqVggyQpYbd4HioW7Jq8L46M3Ci6PlGkNbQjhg0RXjq3hWNmSAoPjgKqpKSDzkxSVJARv7j+MEvQckvXHQ63nzmdth1GFYO6C2TBpgtCW6xU5hDOYm/IxSe6LotljefoEwWfVsUqZ4nGiHCliZFxGUPU0H7GudUIYp57G4mVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(66476007)(66946007)(186003)(52116002)(6666004)(5660300002)(1076003)(86362001)(26005)(6512007)(66556008)(6506007)(36756003)(44832011)(38100700002)(956004)(8676002)(316002)(8936002)(7416002)(4326008)(2616005)(38350700002)(6486002)(110136005)(2906002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?loYSotq8tbaHeFCUe+PwXzcpQlKfkG1TdnsLukCA0KZT0KAcRbHPqVgY7lh1?=
 =?us-ascii?Q?OtkjmxRlqZXEOz1y40x0O2AgIdDcZvHVDbzEtAo3nAUHJIHfTWOXa+W7gSMX?=
 =?us-ascii?Q?3CPKJMwFPRcHDp16amsBSLuD0JQEmWfUUCRkGKymWw6/sFHmMbf+ZW5LSKvQ?=
 =?us-ascii?Q?9glxO0gxnnIYSLB6r6MGeM0DnxpeqSwa+OpWwaEBA+E/fdkEOFWJkVMuwXsI?=
 =?us-ascii?Q?Y/kvSiT/jZb/QvXx0PmunAqQjPrZ5Hg5XVaBPw+69FPXOuukY4A+AppAS8l6?=
 =?us-ascii?Q?YZJQ0lslJWMVSM67MJDWSg93jHhQbU7bstKhvKQOogwlBgSCL4zAeougoMZS?=
 =?us-ascii?Q?BQreHLlBAMCtxGYQw3kxv1p1ZpuZffec2jSaIbWUt2RU00gNyKyODRaKfhJx?=
 =?us-ascii?Q?3rRhQUJ9IiOZdYx9l6+EHbKjC694YoqxzJO2dQMt3OR/jufAErDn7NDQvAoO?=
 =?us-ascii?Q?Q1G9bbmYf/o22WegeXvmMhkXHfZl9AWlpaRcd7xL28Vs+UUmRQ7p89oqDXAJ?=
 =?us-ascii?Q?XSmma1tTPLXl/Zh+B6UmzfXjugxw44s/2zzSiKXa8aY3O5q4DLnMjM48Wp/p?=
 =?us-ascii?Q?HuNVH7MB3THwkMxAgINzXAgg6TCmCh7+f4xH8MHG+ZO3Fl63W93hsPsiVuh6?=
 =?us-ascii?Q?WiJTZ+yfNNSw1RVOPOPGYkyQDt3Dwxm9JmihkyoVSd0sRZKJ6WdUUX1oajkB?=
 =?us-ascii?Q?Tzb3jcHygdAOcSyU+N8MHS6AMc0X/pfSdduGGuLMmzZDH1MFQ3EdVqcyEnlB?=
 =?us-ascii?Q?r2cTzSjZQuUMFnGbnHr7lky/qp0BeEp5hH9ly8AUTelOV0rgxo9hFgGeRwgd?=
 =?us-ascii?Q?ey/v97AAiFqKF4goBhxq/LTtt8vF2IKUIfWH8fkqwYFFmayliC4kC+53x4x2?=
 =?us-ascii?Q?fmqnQTOmJg5YCIdT6K/Vce1vwEAHMLK+V1eB9HnSjkSttMaeboHafoHukkH9?=
 =?us-ascii?Q?6U3yuKdTw4B06n2DwnV2D8GOTD5QI2M127C92G7Mf8qMfVXZmLb0oVgqr/vW?=
 =?us-ascii?Q?67ZXzJdegupEkDkX915zq4aTXVQ3hxnNncjQrhHPs6ClHcyrRi+enAEp4NDp?=
 =?us-ascii?Q?ihT9y+2U6lW1DGjXFwUWtBpyFpYJESF+e9GNyouCZ8sJ5Du3ZtCwXutW5Goc?=
 =?us-ascii?Q?TPkmwIX2e4JMuRJ/oiJAy1Qp92TwjXvrO+qtPRlvsv1820Wii3/5kr2kqrBW?=
 =?us-ascii?Q?J/oII5CXCjVvFMaSrYEiaCoISh7LPG3HK8GlRsoqi1db2m2a3r0zibytOXrL?=
 =?us-ascii?Q?TYDjAM+F0ZLwAeiHOurSifusqJkfxWcPV3mXpNbrH2pyJeoFMtVOxFeiRYim?=
 =?us-ascii?Q?u7BgxPX/DEaIpXBIL5zyU7hK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d507c9f3-5a7f-4516-56a1-08d945e094f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 09:28:32.5728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 610p/PLC0lLs5krXu0D5GVEiLJWiOtP9lI+xs0Y9PMdrtDmCZqAM0v1Wlt6Yg6ZY/8RJQR8NpA7ha7gB3Gzjjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switchdev drivers, like mlxsw since commit 25cc72a33835 ("mlxsw:
spectrum: Forbid linking to devices that have uppers"), refuse to join a
LAG that already is under a bridge, while others, like DSA since commit
185c9a760a61 ("net: dsa: call dsa_port_bridge_join when joining a LAG
that is already in a bridge"), prefer to handle that case and join the
bridge that is an upper of the LAG, if that exists.

The prestera driver does none of those, so let's replicate what DSA
does.

Fixes: 255213ca6887 ("net: marvell: prestera: add LAG support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 226f4ff29f6e..979214ce1952 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -567,6 +567,14 @@ static int prestera_lag_port_add(struct prestera_port *port,
 	lag->member_count++;
 	port->lag = lag;
 
+	if (netif_is_bridge_port(lag_dev)) {
+		struct net_device *br_dev;
+
+		br_dev = netdev_master_upper_dev_get(lag_dev);
+
+		return prestera_bridge_port_join(br_dev, port);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

