Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF91485C26
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbiAEXLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:37 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245318AbiAEXLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G56f0DYoQyH9MQO3Gk9INbKQy2mq+PEZjoEwQv5mo2F5ZorAtmlo3jBpBF/6Ye/NsMAgE8TkLE6+0dMfb0TLd9TkA5pUq2r6RnlnvW20hI4h7jr45WRYawv2ijm5nVLsQ11wfhxT5mZNSj8EnLNqtA5QxZz5Ba755WqRpZpgRc7GHIWlmmtK9nZev2ez8918VRDIS1rvHnYuRrMEolvYMry63+vr/TOrIrfo/ZZIGpJlHu669FQBI7ylhhL35eodiSS6lY8NXdTIJXs70QjHKqpg23EtZncRBX8UFCr1U211cG0JjbnkUpP993mlp1RJ0NBKprZcXUDX7qb1lN0aJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URzNKK/JSdU7+cX/+G7LH8i/dpCeT6qWvk8k52pJB+A=;
 b=LSZEg7MQu4SxyF4/09CC2LikBD9XY/Kr2dKQd3wJGMCWT9gARZgSSppSxknSgLnbXgEcWW4DKALYWzbEjOmz6qwBbsFaG2S4OWEBLlPCktqo2KCVo5f9hFNQQhwA48Og17QZ8/DgYhjf8vzcaMy+8di/3egYu7GIADHEz7mdnavE2SuFILcELebScuLPC8rEZeLZTfs1GZ6tjBzNUi6PWNV+fruUiR3sEgmvW9N6uZz5aYnXsvsv3srkF+/PaSgUjAhgXCVU0MZ45SWxUYM01H/jNqSBvtyRDc9iuUoj7VZ3C/Fkd3qipGt5uSfWOCapkFzTSlkJxsaRDzjtDuLPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URzNKK/JSdU7+cX/+G7LH8i/dpCeT6qWvk8k52pJB+A=;
 b=gFDLMjmTygNct9wPSWCtKSA2+16RNtoWljcnESamYQMJLIGRyjq8DgqsAIYL4+RgMzyg/lJTh5dguyk8be8sUopYzj2w3Ya0R2FzqiyZK3VtBB4Lskm7B2eAOdNqDwDpKovdKRxk3u/qf0cO00xd3Zp+KlDFyMbcgCMlJZH/sJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 2/6] net: dsa: merge rtnl_lock sections in dsa_slave_create
Date:   Thu,  6 Jan 2022 01:11:13 +0200
Message-Id: <20220105231117.3219039-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f290ea3-7f9e-4537-dd12-08d9d0a0b5de
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3069E8E28B9E4943FB8DB84CE04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAvKOkVOvEmnJv/XRKJgiLs4uE6KcnVUWeR+YsF0fCnSYnz1SbRf6CHabAazwXemui/NLeBdKDzoTvv/OfffaOa97RzUU3I3JD+pYrtHGS8ZzXD2yLOSqF6jo+CNlMzbvvLiUiYtI/BLh6Z9sM4yaS4mBzGfiKcD0Eb8E/2oRZV6HSxIPqeSrfQWnJAhUMXL1Vxn8KkNNr5sh0sXgOZPBMtLA2mI06Wbh/9gwzFgZB3rADh1BEbHoCTiXG5jJFtcNqt6mbeqocCxwUJc5emdnbBG4NQ89I/hSHP1g0gesFkfP1I/l0LknjE6CLZXLBWGVaz+j0QoakaoecLOgR0q5d8LXL4/D8KyddxCbkNzrir5CtNmf9k2UZF/X39KkE6w1EaQBfh/9ar+Ncialyao9nFFCpRlph8UgYia42gIlkYsz0NNcAK/rjnEuFZfnimPL7HW175KGAdvKxQhhOvUMJHhFudJ0ltc8q48Kmfk9wKKvkbEpFetFQ8T88QtAnx/cB366m1Qjx17HNzsfs46SHiykUVXbnieJgPzvj32i7z9cNpUZxm6p6/+dTQGCSLyzJE2ewKJqt83Njr8zl++GWprwZemaTOAEYiY+E0RCpngV5C+UvrhCexspeL7g4DwAIDBprDJR002I+Noy2wJQ27NdWE0d7ambxA6ytOIiOu4lMEwRh9oLzAY0Z4SMwS57tm2Nexu/2AtUlduI7y93w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(4744005)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Qc/8UaIZ6pCNzz1LVFrMY7wusWBynNEUxyYpgLatKl/Cy5wfrRo6pyE2stx?=
 =?us-ascii?Q?ijthcSatFh7YZZNeJZeMUale3Rt7Rp/4mMSdatbiXDv3ellxEUmeuUxMVVgg?=
 =?us-ascii?Q?s7ns8cTId7SjpHD2IW2qDzMzIrUhs4rinjBLxsJhSSsYDeuiOK1WOlrxBq3e?=
 =?us-ascii?Q?V3Tl6bSSOe6QAhbAYMltB/AqWWvt23fE5yVHqF9IDHGXROrH6wm5M0/PHTsD?=
 =?us-ascii?Q?YJlo39CJyaHdX1mQiA23dTPHwkoprNQ7STfbfE9YocVCBW9dAtFNiNVb+YBW?=
 =?us-ascii?Q?7118XJ5R2fO4xouui1lJjWKJ5q1OQKQD4WPTwA8pFVFMdWsaFLrq9Hu7dkrT?=
 =?us-ascii?Q?KJarAPH5jMMx7qWp5c34HLt/xDKFdU4rEvy2rQcyyviOshhp3Moc4Gon8CaG?=
 =?us-ascii?Q?6BZGycKPpv5Jm3g6MIeyS2ew/cMKuh6qQXVEZnyge7xgXJsIHPlXK9nyvpFC?=
 =?us-ascii?Q?MuwqAEeSl5cTrmZomVPM6QL192mHZtZ/yQ64m78fqg9B56CMjdyTybAmo2tY?=
 =?us-ascii?Q?+BhdzH2ZjK3qsDMrMYAtZ5InefYypgDEzqmY/JW/6kLiP1ZEAEXLDcriaYC7?=
 =?us-ascii?Q?dEOHApeidfFfNTZR+8YSeRjI6jfdCzU7NU5EMRRUBxnth4g2IcF7R7+uskyK?=
 =?us-ascii?Q?7fG4ZwNY6ZfPP65fyQhWg3B96CapeOEhaGu9/k5uc0zJnhxqX1NkkKXCD6XQ?=
 =?us-ascii?Q?2Wz2TsuAORU+n4OSJxZ2Zg8aoveueksy1lH1lwtMRTNyNCSxi9oaR7wk1nHM?=
 =?us-ascii?Q?tNtQYgfvx2FKSninCE15GmVJgtzksE3OWbg4zwRxZJN20JqxYDvXR5DYmk7x?=
 =?us-ascii?Q?rlLqEeSKY78VkYtl21r5R9pNYr3Jpiq5zpatZ0xSCB7eiV5oSsrNiJtad9a2?=
 =?us-ascii?Q?fdWLecr3Q+gu8Ac//l9ayzp/vCzKS79CHy2jGKkPzwiBW/6aP8utazRToYmX?=
 =?us-ascii?Q?qAtVjeSfC667Yp0uhx0xN5h/TmLF0L7s0BeUx/eMZkpJK6FF5o/IaeiygAZv?=
 =?us-ascii?Q?DBQEEiyARma3soDxFbwPQhq50+CTkCkHZDXH6DAzHwOGBLDRJrA4vF1q8h8j?=
 =?us-ascii?Q?Kh91UhfNBdeXCGGWsU5kypLvswnZfrDzn+qaqHkixsE7BAecGMdnYI2ydfJl?=
 =?us-ascii?Q?UiQ1owPSS3aiPhodtUQEEcmRjTR/bkdy4w39BAY7WdwlxKR+0s8B/cHU9WIG?=
 =?us-ascii?Q?rl7Myws/eY72rI6m6HEuffQhEro8JDpJKQAarTbNKSNblAZKRlU4NcXFqZ2d?=
 =?us-ascii?Q?OIauUCMkCRXR5s48I5VaUfMehnPVek1x3YN2mLYMZeQDTpurbKKyD8g9s6x+?=
 =?us-ascii?Q?GJz9OvNr+yrGIdxNGmXVM6yr6rtnjUV9fAQsTpfxN9Vcv81TRNhbvFstP6s6?=
 =?us-ascii?Q?J+Z01jhFCXjiUU9qzVLgFGYxTdoVg73WfMWsTu3LUgVMjnlVSmzfDAQbocoG?=
 =?us-ascii?Q?Xb/83vRH7iBkXRVF69U0HM2bVdeuy+6A4ugorRy6FYPtz9e6V5KNj2t3iXI9?=
 =?us-ascii?Q?9H0c3ernG4CLxm5GOrf3CVBcOOGrKoEFl8EhHgmoWnjKSzNNRJHx6+SNY4Np?=
 =?us-ascii?Q?ldXfW8Razz105GZzwoWDhxdw+/JMIFR0aAOgtjVIqAyINGsunra/YrC9xxSA?=
 =?us-ascii?Q?ddKzzqaJAFghP7GKp7Mp4AM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f290ea3-7f9e-4537-dd12-08d9d0a0b5de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:31.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svjnvtKAS/G7S+EKEva0BlqBYONNrC5kYzj0sSHSGAQpNPCnJngRSHjBnMcLHScCnK08u7/CuG691vPOGUBZAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dsa_slave_create() has two sequences of rtnl_lock/rtnl_unlock
in a row. Remove the rtnl_unlock() and rtnl_lock() in between, such that
the operation can execute slighly faster.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 88bcdba92fa7..22241afcac81 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2022,14 +2022,12 @@ int dsa_slave_create(struct dsa_port *port)
 	}
 
 	rtnl_lock();
+
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
-	rtnl_unlock();
 	if (ret && ret != -EOPNOTSUPP)
 		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
 			 ret, ETH_DATA_LEN, port->index);
 
-	rtnl_lock();
-
 	ret = register_netdevice(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d registering interface %s\n",
-- 
2.25.1

