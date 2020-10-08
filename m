Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA442873C9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgJHMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:03:33 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:28736
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgJHMDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 08:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpmICQq/QrccHgeeTd+DMybKvTIjHiQJEvOCXw9OvJdPmD8kacaafWwdx+NJi8TwWmXCribaXqnwK7Dl7nHJgC1IMBDKR/sy+MhoVS0XZCvjvu3GDbkabtbIp3NI5ffmFKwEzPGc33wxwTgs/meo8cTat9+j456umQgTqTGpbW1MTV1tuPCP74IMyQgarBwtsDhnrFM6zb9EnZlPqeZomD3L9RHJwv2xOeFn1ON5XcPl7dZonQrKBhpmvy4U8oeRL/QR0cgb95qG1PiQKnJ/2aEC29OV1AwCjOHrfWJvxVG0030BPXATesQtkNU2Anqr7o87fG1B07/AOrnaxporuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JG7B3+TBPj/OD62iQpYPRdWvurdpF+DpapRFtZ5s1h8=;
 b=Fi/BcyaAmjAZIraOCaeE6xjK9ecsNHnTG2Pko6O00tbxeme4p1zd9npTNXg0QTjsoI8jQ0nN5v8+TtbIVPgkUEpXd+cBVQ4N3yH/Ot6Titfy9CGu1WF3wY+XYQ+Ha68FHXTsmWlfpaG3STmtPwCztbLE2XQ4/lGUj0YDBWAXTQojvIkspx00aHKNhYi9B94TXkAmPGSpu1mtEq0miRiboh/aHrnfs/xH/WDFh2DUJS0csZ4mumYobUJdIWTEsJj9laoboJvXlh+ujB3moB5vBrvmAvBrBniUk8QmnV2i754NI4k7Avu5umF98D2FK7kagxv7GglxDP8YRjF+QM2nHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JG7B3+TBPj/OD62iQpYPRdWvurdpF+DpapRFtZ5s1h8=;
 b=R1itJlP8OIruxmq28ZxwyAue7vPiKX79LBrLQKSCMt3ztu9KNS+XzP3f91UVSLeRZXfAwO916r20TP6lR2uZG0tY/vYKFeJHAXJsaXhykKiRd769u0x3z1i4BkeW4fhBJGJHySZVM0PCgYZmcETkK7xUlorEy7PfQ8LhlPFOwU4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Thu, 8 Oct
 2020 12:03:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 12:03:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        camelia.groza@nxp.com, Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Date:   Thu,  8 Oct 2020 15:03:12 +0300
Message-Id: <20201008120312.258644-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 12:03:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d8ae4d3-8ef8-4592-cf9f-08d86b822b70
X-MS-TrafficTypeDiagnostic: VI1PR04MB3965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3965F9028FC35911C2A00B7DE00B0@VI1PR04MB3965.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcsqjEijxWVmUJQuQ0tbjxx1R+35cAQpENeHesh3kSaF5b6GY3eRueEbPo/Bofj5crvJmZswTgB6biz0csQvNaqmHIRHDJ3XObfbcGQJlkWfVYjPNGATvzD7ZFtlQAmBotYcRH88jhXK44EQcF0nmno0JX6yNzCN/blF2U23H4xslqEEZRwqQTIMNbABU/bFMUVRNXxJTB55VTvYiFvfcqudVFN7SdQAcJUAPgpEN93zRSvzm7YqyZDA1k3HqMiGS5dnWq3GT8IYQ9v4ps3gM/T2yXFuRXjqrHp8a30Zxc0MKbdjEmqeDSc95WbXoFcBqkVpyl1kRJS8Sz585Dd7oT1Z2wA6qO1dqEmpuCySFqoR6U2C2RiUQew7dZGUb3D3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(316002)(86362001)(69590400008)(83380400001)(4326008)(2906002)(6916009)(44832011)(52116002)(6666004)(36756003)(66946007)(1076003)(66476007)(956004)(2616005)(6506007)(16526019)(186003)(8936002)(6486002)(478600001)(5660300002)(66556008)(26005)(8676002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1nVtTQOU1B/QWV/ZvyfxGPGQ3UVjk9U9m2pLKBveizvjzuOy6+oNMqzKakri+eB2mGCPhakfjP9ya5K4YH+YzCAP2/qPyRW/MsSQLMgSw+s2rAYsYfVCSKuiRVAu7PbNs08Ywf4I5M4vi/ZDKSm8GlmCl345uGsl4BYyso741jCEv0W3lTV4xi9fn59Id8TnIfWOiGu5Kn98PjM6vW+iXu2VS2YQoghrLZUYsO5caJj1c9LheZX2DkK0TF3BeUeNc6ZfVcfYdQ/U3Wq+/o8WHg+Ia3QCigzhZqWJJWpoNRSyBQT/d3AqODaLjVCo67USSz+DLJpsahTuZnM6R5hnaIQwiEvs78cx6cClDqLhumB+vDzqe8NCGWUihSpl5UdHp9DysAgDUosOL1/gqasldbeg/hDUT4FJFN1fZ2/JzrXKmF+392A81YRqvN6wF47SE45osSrCbOTTnUScIoL+yDfvsEWdNFsTjPCW3qz4JeZ1tfi6deCnp7YKDwDt0bMmWgpxjvqYkwQmDaRgX8yruBzHt6sAxHyYNv57po2w3CUosNpYYxK/PMqkH2yNBDagKm56nnWMkMVMbxVDYUcNVDqQcQZYLJRQ+o1yaMJoQPXnqRQ06ys39/SCFnScgpN12GL8LaiPQIgytQ5Nwrp4bw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8ae4d3-8ef8-4592-cf9f-08d86b822b70
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 12:03:29.3767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgLmnlpyj0b7rs1/vKTKQzeAcLRB2hIt3fVxgKgsm+Ny+SRAFEH1TSMb7AEnDrPdKaV8Ntv2t3waK+V2FidUkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

When packets are received on the error queue, this function under
net_ratelimit():

netif_err(priv, hw, net_dev, "Err FD status = 0x%08x\n");

does not get printed. Instead we only see:

[ 3658.845592] net_ratelimit: 244 callbacks suppressed
[ 3663.969535] net_ratelimit: 230 callbacks suppressed
[ 3669.085478] net_ratelimit: 228 callbacks suppressed

Enabling NETIF_MSG_HW fixes this issue, and we can see some information
about the frame descriptors of packets.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index fdff3b4723ba..06cc863f4dd6 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -87,7 +87,7 @@ MODULE_PARM_DESC(tx_timeout, "The Tx timeout in ms");
 
 #define DPAA_MSG_DEFAULT (NETIF_MSG_DRV | NETIF_MSG_PROBE | \
 			  NETIF_MSG_LINK | NETIF_MSG_IFUP | \
-			  NETIF_MSG_IFDOWN)
+			  NETIF_MSG_IFDOWN | NETIF_MSG_HW)
 
 #define DPAA_INGRESS_CS_THRESHOLD 0x10000000
 /* Ingress congestion threshold on FMan ports
-- 
2.25.1

