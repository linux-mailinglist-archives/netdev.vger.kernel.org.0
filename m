Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCED5485B6F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiAEWMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:12:39 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:15430
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244883AbiAEWMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 17:12:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcJ/ooCOyp5NORFvewrmFp02IJVGhqmcgJKTgt4oX9inpVLLwwmYPtJs6mNBT5HPq+Eopt/iiwQugS2fnli4YYUmTPFbH2FoqrBCC3Ct2LLU2AJfC/ncMlgRdrnlRz5P9Wcj1aW7VbnuY8hJ0XnOY4u7qOLrfSD7tgQdCBN+X4ndi1Nudqpcq9rIagvTQQYcXWsiLFTrahm9f0MsFi2wx6NpZDabZc83N0OlMC4G4YeMrZlpVLdP1BZJXDlFrKENFQ0YKoKjF6SxjC6bVLaLvl3VZmWXoGki8E0aKdpLRA7eo6gnZd8BbBTeWhvfNdXPTorzoYB+ujTvVW1dg9xKWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXUUBat7LPM+Holjd4ByEDtqelCvVXuG21bVWhkzfNU=;
 b=IqBTY0ynM9YnMDA0Xh5vFZdX0F8LCOD0vDDbfI+SYO1SUkiBwk+0Y1DgC90HdjlcKcJ4m39x8nSPo2Xj/M4fI2KLdrdDozAznAt6N2TkuWJGG6w3pHPli9rv+341oFegbZpZCOpIH/idvBiMud+H1QJl3tNAGrYf5NW6YvyPMTV1mPKmDHZwhprsLE3xs4EeaYc+jt+QUvdIFPt7Xf+G6x4a2N9oXaT7orO2Xgw4JCAe6tNFrHT0u47wIs22f7VI0Dj4/+z7EgIM8FJ07PI+2m9GfjNKe0WkyrLjF61H16xSYsg1iS+OnNE+DWE2yvA0k9zzwBTk40blA3dozX38qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXUUBat7LPM+Holjd4ByEDtqelCvVXuG21bVWhkzfNU=;
 b=VpHMASWW3kEPZoiWZVLomLy0hC8MJoZDuhCpSYvNCcMa+O0QHZerIEP3dx85Y8v4R7n36TZyDj6YfG+CADbEkOwQKzs+KcS+pCBI/yfh68rPThmusuPTdIZP2Fd3+W2ZvpNLjWU8gZtAWOrh96491rwyQ/NphSLiroQt9KOoV7A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 22:12:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 22:12:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: warn about dsa_port and dsa_switch bit fields being non atomic
Date:   Thu,  6 Jan 2022 00:11:50 +0200
Message-Id: <20220105221150.3208247-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105221150.3208247-1-vladimir.oltean@nxp.com>
References: <20220105221150.3208247-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0060.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8257bbfc-9019-4a46-b10f-08d9d0986986
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6015B56168F0A871E8314C24E04B9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YPYFVp9wPqUiUbc/DDsUMp81eOIuPTSfHC7KjOcQGfFz6mus+m7ef+ogp0sZQUnEIww8fZ0wos0ab1bWv27RyoQJgiDlVM3sv/8ccdM5a0fcPY5wtKnvfqO+91yeQKoxzg3ApcTrHwBRfykRBUUV2p2Ivlr27oKikSKyDo/swjOixvrMDaEX3a1gK5erPOSguevwzV8PYgO2L+CNbLb0X3JVsxwNUCa1nWAJb7yfJ9kPulg808BJvwQDlMT18hL7MxZyKtyqz/mCugV/4zavTZx1G1l2wsfrcCwLnyNsfZrbI0UfeCM/LrD1Qp2b188Qgk75PebhhWPMM+3aPdUUdDKbW8863hJ5OvDp2wZ+XNU0oRVahwEV4x4vmGq58E9pPy04W7Wlz3ih7AlQK3f3NMPFfU5yC4d6iwXmBMe4oLYFfAJN+YVOowEHSkAPbpNKCSvPc4Pg2ZVw09Cf8d8uXI4du+QRS1Aq+QdMSJl23MdB53vDaratoSQoVXgpdN3NQ9Qq9MmDNM553u7lJ4fzuyAu8UTg9UtHRG3SS6zlTycvmSa23Y/OsCZM1c6d0lxh1OUiseBDbMVGU2TdXtRzuQuKfK8UynoIm9Q802Pz9T7yqotbCL36Kanot+C5nfTdK4qcswPM+kUZpszF7T6KrjteR3BRXYJmn5DIOAnT1gm5uYh+jyrKGq3mT6PYvF9NtRBr/vt4I7xeY7Fd85NXJSyHq+hOyjvj91MkbqQVWDYHikirJvVEL3kj9Y1S33JcIJHX6zR4HTBtxySis9nzBPSVctJ9etYg4tsspbK/GKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8936002)(8676002)(966005)(6512007)(83380400001)(4326008)(66946007)(6916009)(86362001)(2906002)(5660300002)(508600001)(52116002)(6486002)(1076003)(66476007)(26005)(6506007)(186003)(38100700002)(54906003)(38350700002)(44832011)(66556008)(2616005)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wxh/slF0bp8rT5EsRNmnBkG+SrbNhjiTEwprTQc5z3PF91bwbzQjiCtDgEUV?=
 =?us-ascii?Q?xjSLP1o/iq6Y1adZiTr5smRXvaVNfb+/UDH44Ke/Gpfly/LB6GwS/mvm04bH?=
 =?us-ascii?Q?Zcg9HgM4hu1WNySZsLEFRfgn1ZyM8npGZ0eC4bToYe7g4eKL5KGxpcs0YzY7?=
 =?us-ascii?Q?mKGgZ/lSMesVRr1UwTWi1CdDrKP7DEgTeR/T+naNbcQwU7x1mSKBkfuTlXRL?=
 =?us-ascii?Q?WY3tvm/CwzBnJGlxp03WNlD6jnTqurGJaSxPmJpGZ48d7fkpzivGcEV/XwVx?=
 =?us-ascii?Q?Z2YcRSaQHLYMzLUZIh9GC5qsHkqLeJVpF5TWZO/679hqOdrI8hi/gHcpxK2q?=
 =?us-ascii?Q?KmCiEDAsxSZjmTtTSW6OIRAYxzxdTgjSPHDT135TfvNpDqx2W1CRRa4OqnTh?=
 =?us-ascii?Q?IJ1IhPVGCInavNpqlChAsgfggQc5HWLgvse+DwpgpnnKZiYWNN6bZpAvnMcK?=
 =?us-ascii?Q?CvhTSB6cS9JfGGEofHRfgC04e/5h3bNb5bP/BesJTgtar0lspJjvYPEdZJaK?=
 =?us-ascii?Q?gZCXb3RYJUYKVqGszvEp3G0WiVwYitGVdBejep5FVWxsaHpQzhDPPi7llSzS?=
 =?us-ascii?Q?0rn3QQiY0nypVSqzFthXaJzk/5tHYoPRedWwRbWbUxN8S56gX858TZKE7r3g?=
 =?us-ascii?Q?PoFADtc1tWeIXJkMKdPgXAAbBnCdlIrbsU6dvdStISw7mT8IyZlK9ZzQtKda?=
 =?us-ascii?Q?BVq9ThLAEOaHlhuHEPb8QXZ17sR/chDTnhkmuYIDvQvmvMF1z5TCE4F9qW5/?=
 =?us-ascii?Q?9MVGJ6w+T+61mi3kZIZP9xqqR3ekwETx5y05q4ngAFQX5v1+pdFa0LxcMW5k?=
 =?us-ascii?Q?7Eb1OMW+GmV91n7K9cZndnMUiqO5Fof7p7pV7Zvv8sN1e5Xi4jgZi4JA0B5M?=
 =?us-ascii?Q?FeBChTFLy12/Cq99veOd5qBiD88lrM9TrC4nOrjKL6aBFMKb+7op8U3GZddW?=
 =?us-ascii?Q?wr10BUnAxAp9+h7GA2u9ASQ/oofLubzSB6f3w5VVRahCEeldT43CpJLZkW+J?=
 =?us-ascii?Q?kQCHEOBEB5HLaRzmTNFZFgwAZwprVUVl10U6tJWLMfqjYEbwIUj2xMqE0n6h?=
 =?us-ascii?Q?lCSZYNfvZN2/pP/LZD52a/ZUcedWdg58JocwWwW6K4V4lqpFDIgh64ljZ4rx?=
 =?us-ascii?Q?iXiSnmCjgFzx4RTXjXUqJdarQJ2RGqODCODJ8zHv3g5LCm7BG8NeVqXR/pn/?=
 =?us-ascii?Q?9DcfEF4zGiyphaZSeUOx4BxgXk2XdremOrPlKHWK+I/hqw9d558xN0zwwDY2?=
 =?us-ascii?Q?rrb+piGqhsjQeRyE5mq7lrcZLVioIvgHQIpS44aiY2wYXzsF/Na/ub6SLXCv?=
 =?us-ascii?Q?NNFvRULmukFbI6PwGQS2of2HPFJZb7DuvaBiJZLixBQzTmkpc2zxO35oMXW4?=
 =?us-ascii?Q?JbYecfBX2N1oUbUlqGN/X7oArNPYDGkFTIiXGVlKzgLEhWLYcKoG6Yc8MzVe?=
 =?us-ascii?Q?wfkS5KNDTzPykHuImuzy8USfOgNtR969eACrW9cnj0y8fjZmRpzMmwoaP/OC?=
 =?us-ascii?Q?tDMksxcgSWdnmeALVJnQIPCLqCeRA1PihACzpf6vpfImLJBf/EaooAVXuPRH?=
 =?us-ascii?Q?EsEEK9xD0ci8+OBRTqQTOKvgpGsrQPhVWX10fCf8MsqHMyoETjcu4egN8XSE?=
 =?us-ascii?Q?kokhSJhQCzzJMvWJeCBwO3Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8257bbfc-9019-4a46-b10f-08d9d0986986
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 22:12:07.5239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMQNl9UtdCvtbb6CzvaGa8boHpb0Gp5HaSd6OgUAxdoTzJYk+TN7eBxR/KURxT8I3UMZW2JIeIK9rAhwHIW42A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed during review here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220105132141.2648876-3-vladimir.oltean@nxp.com/

we should inform developers about pitfalls of concurrent access to the
boolean properties of dsa_switch and dsa_port, now that they've been
converted to bit fields. No other measure than a comment needs to be
taken, since the code paths that update these bit fields are not
concurrent with each other.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 63c7f553f938..57b3e4e7413b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -265,6 +265,10 @@ struct dsa_port {
 
 	u8			stp_state;
 
+	/* Warning: the following bit fields are not atomic, and updating them
+	 * can only be done from code paths where concurrency is not possible
+	 * (probe time or under rtnl_lock).
+	 */
 	u8			vlan_filtering:1;
 
 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
@@ -333,6 +337,10 @@ struct dsa_switch {
 	struct dsa_switch_tree	*dst;
 	unsigned int		index;
 
+	/* Warning: the following bit fields are not atomic, and updating them
+	 * can only be done from code paths where concurrency is not possible
+	 * (probe time or under rtnl_lock).
+	 */
 	u32			setup:1;
 
 	/* Disallow bridge core from requesting different VLAN awareness
-- 
2.25.1

