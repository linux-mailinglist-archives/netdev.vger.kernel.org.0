Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6831E42ED06
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhJOJD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:03:57 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234459AbhJOJD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:03:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7gbf1STARLOSAmDX/2/M7uAPK+2pcAs+/EyG2O7z+jyT1kUZHISLwaXMplP5dV8CZWjuBHAGnAmNTg0Y2wKeWae/7NZqTYubEZhsU6cS04LA2gJkAkY3lYPrOvLpXAYOr9lHCgwaqb+X90j5Ly9O9pSuIaxDUJ6HP1sRdy/M2Fy8F+oE4FYmIuwFqbLmrOlTbotHP9dPA6bmqOiVg+vZTWe33jaNFjD94w9X5XFLZKdJMKOUcf/s3Bzel3nD/GHMw+lfwof9cNX755C0xxPKQhp/KCEvYKHtHhtgf+uNrKstKnkAL51t2/JFCbZ2mfmvymsq5LgvljSqi0M0+uqCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqS5cvhufYMmtQCGVfRqae1D2hzE2PGergU0liNQuR0=;
 b=lX3cLBaHPRkxbdg6N5zoVVxUxjXtksEBc0InSy+xVYqKMnf6BSaFBOwXLnohBxTaM+coLC7IKcdbgzsV90cObTkd736HJubip25c8rwCoqeEhgXLwulfhQVrLOEoFPeop1Hv8GIzDsI48iDrXrks9/TU4ObdYk3bJkiG6L9h5lHCPLWyBX5UPayHFlDkCcl64s2H3Do0XjRJrHRp2RCzv6OnXsjTBWS7vdTqairKjwCXVhcvu0GDAwzIgwkHwXpvPVRRdoD20c1+u/YC4LM5MZOL29G7XxJyQA6DKSX1f2Gu6EfmCpCLfES8+U2Ny9KoTEQgh1Kp9Emr5lalhuSkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqS5cvhufYMmtQCGVfRqae1D2hzE2PGergU0liNQuR0=;
 b=LHFJTaUBuzAex8CWR3pDGstmCnLLeQOYKxAe2Wq5q0jFiOgWU/o3mwQqWOjqJvTyNrGhBPCnIxayZaI+42hnKt/IF7RrtQz5If6/epNUFMMQmpWYIeT1sbvYWEm8anFZiC1J9DR932e5kyn6gWleCPova2/3iWxXadWUNb0oN6o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:48 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:48 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 3/5] net: dpaa2: add support for manual setup of IRQ coalesing
Date:   Fri, 15 Oct 2021 12:01:25 +0300
Message-Id: <20211015090127.241910-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e57a5a-6957-43ed-5604-08d98fba6bdb
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5988ADED0CB898488DEA30CDE0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bG4fnUh51kKyDd7966UgDaWylb3eyYm8t8iSWvMMUB3J+6uZYLMLwIl76SHfo3vK0n0yOdjCdm3gukEONLDaR/VNwj0nq+c1URLtmMn/69bGW/6oSOsjWCe37r0Xcm0GYtO0676ubsvFPJreuo9oU0S47Nk9Ar0S/ZLyza+tUrPrnrIO9431swlgCGA49lGivWQmIhmJ0ZiuUYIOQsullIy511UKgDZbqOMlN/i1IWkTtVGyiC7h8r6S8Kk7NmAjSSyCIfpBIeEXkNE07/NRmtCp6DpXjTlo378qU4nCvM7tXGCsRnmH2x1b7GtGWwKtEacrJlJMHPxy3NKI0tSpLLORLVagJtJbFH8OqrwuPKOctdaLSVlq64/kOX/jrdnClJeTmykELXo2hUkMyHRSKK7qfnpGp0m3QQOV1JSV90v1LesDUxbArQau4Cr//6+9lZfBFVuF8fOR/S/qiVSt47Rl9sSizI4V73mjyHzxaPek/gOY5iNx7pYXN0dhGKXoC+pxX8V56sW51lV2VJ3webKyfszft5UcqOc01YbXa5G8XAqARQXBpP0s+FdQFZrUmIMy90C1PPYMbo58oGmbP57U2i0L0jekg4DN+5trmYxlYP5N5SfUXHGhYWLgMyW7hKMVAk2WFL50rY/Zu7zuOb1FZMUqH3By3cOVUSX/TB5rIbMZ3Jl7bqyaefQrjZfL71oAjkhyH3aa8VMOeksPbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ccLHE4ON1JSlaWY/L+bAWL7JUcL9xKXc5SPCgLEK67TH8ty/8iBP8kzv/O9q?=
 =?us-ascii?Q?e9GSYtG6L+X2HDk8F/lO0XPhrUMROHUti6UGjXsZtY94II1RIa7XGrXwU81I?=
 =?us-ascii?Q?gLElBf9CkS8XyYp7t0L3fk9aLNDCWoDVFIRe0Hf8FhJUqjqdXjCoWjDPHIz7?=
 =?us-ascii?Q?H9F4HiRxmI0Srs+bbwxWayXVp96vOrgQ9lfqrlc7jPcC3BzETgYaGRSG7rSL?=
 =?us-ascii?Q?gt3yFyex13yzntdu3tYmyzc9d32zzi6d3/jPIBTxO+JDCAzTT+GUmcEGdqeS?=
 =?us-ascii?Q?tQqVxu3rtj1aaZL6mPF8SrQRbOn1J576BFF/iqkYZjEGXgcWfrFQoTU/dehb?=
 =?us-ascii?Q?nHX2blheUcP2alvPTcCJsz5BLk6kWmkCanqW4YJz0xwMNqVXDdACry8ZuCNM?=
 =?us-ascii?Q?HUbZXGsy0pE0wV8fh1/qlh+nVGk37noogvMkrxZuQ3j9tRTp7Ohb6z/UMphk?=
 =?us-ascii?Q?+lSK7SHUKHctprPxW1Ie8qiD62tVaXNdwvvcs3gTJISu8K3gUPGdnpfmSApL?=
 =?us-ascii?Q?0GbPWT/eL89gVJsRa93b3SXB0NVo0kvKFiKUPQkHCBHlKpFN6ZQeNr+rELpk?=
 =?us-ascii?Q?F2aPvxPDFNIxlGmQ0AiNNVhjLSlvAvVmNa81OXspwfBu9YaKsuLintRCuDcb?=
 =?us-ascii?Q?IRiEEDgaccYBhWznTeCnAJ6QgxcNYLLs3inYlSxi0SmXunzQxM3wA1mDPITX?=
 =?us-ascii?Q?3A1A1m3uYinH0M9WykjNmLmVL2YNWaI02vawRB2LhOE3Gq8rW/S0uozDp8eL?=
 =?us-ascii?Q?woTnbnrH6heXQHa6bNrW84J1bbv5A9P5B7CNMR8EGnZgUqS6lC8I9JaXsNzd?=
 =?us-ascii?Q?ZizitGSumNBA/U5ohxSF36qwRPjDRrZGL+u61+XwvzIeysczy3sf5yI+d5lZ?=
 =?us-ascii?Q?VcIb6nz8scu/oKLU9x1NVQvD+wE/6oPyruydDxWPDnj/xCUfdrcQ6iDKdLSc?=
 =?us-ascii?Q?WHvkv+23bh1+TDNArd3lCurZQ79hZ2vIvg3CY2CdYYGYb273Qmyp/mQo3Wtb?=
 =?us-ascii?Q?sEuB9nsfByiZiNNZc91MSS/SIjakMtkReQfLAqfDokSObWR+cSmPKJA6+x+a?=
 =?us-ascii?Q?7A0iIlXM38QpwOoBw7wuYVZ05AcQ74dFP6N7OzbovSSI47V1ofsQQFBV91Pl?=
 =?us-ascii?Q?9zgnunkFwRWLH9GzA8nA8VtMSjunnuCj1bxVaS6YBoQjyKWCkbf0pb9rImyo?=
 =?us-ascii?Q?H90B9w6LH7S9LpfJqE9iBrlVf8qJS0/LZ1+77tO4zhJL34G1cpjmmOXp0Tfn?=
 =?us-ascii?Q?XYGqHc+o95W1TrCZm5BsrUAcLJw/GfElZT6AMEIcK5E/0tsA3tUz22nzMV/r?=
 =?us-ascii?Q?dT8h0sy124m90rxOTmJ4BBMU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e57a5a-6957-43ed-5604-08d98fba6bdb
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:48.7740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbOL9MmX2hkurE6H6aOOHx+Udcoc984zmCQaez4R+dmRDNUCmPAe2hHfENq9Mrwk5QvSodbLY6SKqgwRu4YLzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly exported dpio driver API to manually configure the IRQ
coalescing parameters requested by the user.
The .get_coalesce() and .set_coalesce() net_device callbacks are
implemented and directly export or setup the rx-usecs on all the
channels configured.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 2da5f881f630..69a6860e11fa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -820,7 +820,56 @@ static int dpaa2_eth_set_tunable(struct net_device *net_dev,
 	return err;
 }
 
+static int dpaa2_eth_get_coalesce(struct net_device *dev,
+				  struct ethtool_coalesce *ic,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_io *dpio = priv->channel[0]->dpio;
+
+	dpaa2_io_get_irq_coalescing(dpio, &ic->rx_coalesce_usecs);
+
+	return 0;
+}
+
+static int dpaa2_eth_set_coalesce(struct net_device *dev,
+				  struct ethtool_coalesce *ic,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_io *dpio;
+	u32 prev_rx_usecs;
+	int i, j, err;
+
+	/* Keep track of the previous value, just in case we fail */
+	dpio = priv->channel[0]->dpio;
+	dpaa2_io_get_irq_coalescing(dpio, &prev_rx_usecs);
+
+	/* Setup new value for rx coalescing */
+	for (i = 0; i < priv->num_channels; i++) {
+		dpio = priv->channel[i]->dpio;
+
+		err = dpaa2_io_set_irq_coalescing(dpio, ic->rx_coalesce_usecs);
+		if (err)
+			goto restore_rx_usecs;
+	}
+
+	return 0;
+
+restore_rx_usecs:
+	for (j = 0; j < i; j++) {
+		dpio = priv->channel[j]->dpio;
+
+		dpaa2_io_set_irq_coalescing(dpio, prev_rx_usecs);
+	}
+
+	return err;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.nway_reset = dpaa2_eth_nway_reset,
 	.get_link = ethtool_op_get_link,
@@ -836,4 +885,6 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_ts_info = dpaa2_eth_get_ts_info,
 	.get_tunable = dpaa2_eth_get_tunable,
 	.set_tunable = dpaa2_eth_set_tunable,
+	.get_coalesce = dpaa2_eth_get_coalesce,
+	.set_coalesce = dpaa2_eth_set_coalesce,
 };
-- 
2.31.1

