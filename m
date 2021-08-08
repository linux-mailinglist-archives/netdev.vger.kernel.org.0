Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B93E3D16
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 00:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhHHW51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 18:57:27 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:33075
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230024AbhHHW5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 18:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6kIz/NKU4Ay9nbTgOvf96Ilqf4f8VJHJaySBsmojCrezUgrjxVNrMHX+0rfil7yTMqKt4Xc/pulky4izfTRcVBvAiD8hKF5DZb2IebLqGbFu17nyDdVYJXC2gWwQ82AhWjkjiXVIufWbvuVGJGAE3kgPKKifuQhdYxsxotsZmU8F0XNU0W1PK5o3yKgCW6XkHOC4A3stP8X+UuL+dV+r1gzRUw5gb3nEv2yCLZZUAQ3/+ZejOSFY66hwokLfvD/0LxZAyO3/MKCbV5qIDzOTi9gE8iG24Tp3f9OSqd/iI1B5Yej/HsigPtQp6aCFd7HoHv3yKVZ5yLz5rUz+Dz5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjFF8URgMbcgIbNv5nTgoRwlerysRg3ccyQN1jBQLYg=;
 b=cDl8kyYcgYaYBEA3wzryjSTLd5N7k8OOG1xTY/7r3AkspgEFawerYaJ8PACJ4YSlmFCAdrOY0KiLS0RRKnNVuOxi5GGmbUVtlOkdSwJ1COMs7rYf83C/sEP+1MQubKuXxJTQpDnJdWqyW6wb0OEWQ71Jhf4L3FE3c0+pLgX9QixoTMa0GrRB0ep9foO9XTC+EWdyfImn/vKcIXheO1gwokPKbRjtHf363BluEYO0AiUTh4U1+4fn37nvyUR2R/2ifNTJvstFRCopZPDIiaI7va3cmXXbVH/WiUvD0lficR2AZVEXZtZ+4l3Zne2yEVBK5ySbsoecX+mArkDdbYhkdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjFF8URgMbcgIbNv5nTgoRwlerysRg3ccyQN1jBQLYg=;
 b=ONBp/OMdJtugHCYZ1j5hjSTBSG9YD8Rg/6S6niKH0+yTzrWMdxzdG+aWlItrFhcGJnmzjisOeSeOCIiI22buO//f8oE7rh/Cjhw2s5oEyGg/Zp5OAA+hC47pOUdssyADwWgxzZXbx+26rlFZ04rwpE0qF3cL8TARcvrQpnU6+7I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Sun, 8 Aug
 2021 22:57:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 22:57:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: avoid fast ageing twice when port leaves a bridge
Date:   Mon,  9 Aug 2021 01:56:49 +0300
Message-Id: <20210808225649.62195-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808225649.62195-1-vladimir.oltean@nxp.com>
References: <20210808225649.62195-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 22:56:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8de1b297-96f8-4f5f-6888-08d95abfd487
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328850A3FF60D94AC303356E0F59@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1ssgTzGcLq1LYXCwR90pD6PCmN2IKkzECuTu1tGSztlMBNFzIQpuyevzWiqyFgWFhkMwnDDFQjNqwIi2Jhj1Q14k7e5FK/8W3Ph4l0t3TMC/5jKdQBDoIZZdIOlBbK0pF3YWtdORaUPJj+rr8nagRJfuIeholUxMv2Zd8dhsLJRIbCgMZMclnZjg7NTISD0CjgO+m6Q91nAknmIHdeJ9+UkMjwX13RJxNdNGsBIyuwCdHM51z+fkZbtbKkVaq/IhNJKrD0HTLNBuhLNVr1kHMHm4ByLdfdFBO89NXDu8z4w6a3Gbo0lEVxKEShJlsm7ut/c3xBpte9eUalfOImmcFBVSN5/pU6RJdXrLxuITEQqLsr/vUoSpwIrzklHLHxuZ0LAWEyPlAPRQWn5Rvm1bimSZYUB+eohuev/tv1sBbaowvr1VXqyJeR5IwkjvSAudTjZUgnz8O/J2q4SgzDTfkMQqpAJ+jF7zB/NJe3OuPn0NbNL/TtFEpRMTg4Vi4NJI7CpEI7i24MYS6xf/BsYudCLvLdzaOOY5Je8ZvbUJhEhsz9G24ungrgAoUh1UzGPSYYVkP7TFkasgJCfixHwtjQ/8LXfO9SZn5Zt6QmS3dNsZdt4r3rz7jDbZY6juMxUAMjo107x7uu64qf91OzWhdyLIZtsvtpT2TeoSgCM7e8dvau43G6dDQLlrmOysxi85bgTPZvofQenhpF5VvvnVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(36756003)(186003)(5660300002)(110136005)(26005)(54906003)(316002)(38350700002)(38100700002)(4326008)(6666004)(52116002)(86362001)(478600001)(66476007)(1076003)(6486002)(6512007)(83380400001)(2906002)(66556008)(6506007)(8936002)(956004)(66946007)(44832011)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r3X71bxpXKvY1P9eq9glw9rkVbBKPJc6ZzWIJTXhOa2JG4mZPhKd69D1BUpb?=
 =?us-ascii?Q?jN3yjSMH3XW8SpV9TqmlY9o4/PHHRt4/OhhpQkITMX128mlP8R4hoTnMITGl?=
 =?us-ascii?Q?c6TLkgTxIRmvqW3YkyNPDLqOSMlbo4mHveBR2NByic6EXQC+Vul/XPiIQdLZ?=
 =?us-ascii?Q?xBQHJlxbzH7PtsCW14vOup+9srolAD4Sw8peWi6TzhoSLI8M/uUsnmajGTy/?=
 =?us-ascii?Q?/Fb979VzBHLqOqiAT8sysGg/eJYizZMoqvIT0YrEHOVOcc5HaWjNnj4DGn74?=
 =?us-ascii?Q?TMOhfGvDVCl96v81ptSZDJxvIFqS5FXpSRFgN2+LqQXGWcQyRouUpjwMGWNF?=
 =?us-ascii?Q?OvegCW1N5afpMwJHihxWNVfnrQfVRgqvIiBmwd9PqQLQXd4b+RmEilOM5XBs?=
 =?us-ascii?Q?lA7rLE7OmStEWS5GlNPMlygqRVF6xUVTuw6Hx9/Ur3tnvEVJ3Ei3WeXg7+gI?=
 =?us-ascii?Q?feb/Phd7I+OVFcmi6qwO79ACWUMa+Qx5ukbeYi+Jb6sZ5R3kQ6rADxaO7zY0?=
 =?us-ascii?Q?9gfSdiLCzxweUO/AXA/APdCDFGzbiy8IGLR2X5MhtEsDGrDD/89nPC5vnXEE?=
 =?us-ascii?Q?RUijFE3KDBXj1+FETaVNFTLYUl/FafYk9ZYswpUNHzFPOhNEwUcb36FITqKX?=
 =?us-ascii?Q?MPgjL+qkH63JvKZUFDsCpmBHQwfUsGFxthvoVTuFSPi9M2HbpcP2zTW68zGU?=
 =?us-ascii?Q?UMS1CPQtnCWtf/HSQMl/R8nDnHl968FoKA2KDfec3ZjhsoUp/OBrMCY20gIy?=
 =?us-ascii?Q?hheqLevGgbFLqQ3rufWSH0LpX/mYu9mOrGMzucnB0SdhuFAQvU0cJKIaexXI?=
 =?us-ascii?Q?eMQDK++CtQ3M55YVhEF9OL2g3VFMH70HzfoVds4LQxuJefHtsC+GIFrVAABw?=
 =?us-ascii?Q?02Sx2FXCvR+uTUVJdPn2kUYfomyWX2zImaQLb/KEtu6QUC7Wt5tk0FZ87J9Y?=
 =?us-ascii?Q?mix36Q8qdfDouq97++j3vw45H7oj7j8umpZEZdSCs916mau96tOjTG3sWOHu?=
 =?us-ascii?Q?d7xnmw0y7tktHqDupAq5jy/zpjdxYIwNSMvxK/mZsNedMmmDwPOD/SxrfMNa?=
 =?us-ascii?Q?7UaoJGwHPxJV1wu763HQh1KHEzriMkMZnF0KHlR7gK22bRrqvJkX1X0g7SRM?=
 =?us-ascii?Q?wIAmBgVxFzql6CEuTCi3H3qUyrykoTkwlVMeYahWvWlY7m37AkBgcd9OexOP?=
 =?us-ascii?Q?gPiSnIYApywshvrKSjspiAmTGx8TbRj5bS+buOOH0NkC6g5tJlfLhFQ0iGVA?=
 =?us-ascii?Q?NRYO2qOClib7HTrP+jINVq2UUSxi2keD3A01R60MjopTzNFv2+vkyGJNwFNO?=
 =?us-ascii?Q?i4XkUYF6tHEUHK1gaTjkb9dI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de1b297-96f8-4f5f-6888-08d95abfd487
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 22:57:00.1832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbTg5uePVDb00i7A8rzcvqsLd3s+WPP6iDKBIS9vRGJIZIKRSwYgkbN5Q3roqJ+xE+FmoqrYHWGwg9duZfm9xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers that support both the toggling of address learning and dynamic
FDB flushing (mv88e6xxx, b53, sja1105) currently need to fast-age a port
twice when it leaves a bridge:

- once, when del_nbp() calls br_stp_disable_port() which puts the port
  in the BLOCKING state
- twice, when dsa_port_switchdev_unsync_attrs() calls
  dsa_port_clear_brport_flags() which disables address learning

The knee-jerk reaction might be to say "dsa_port_clear_brport_flags does
not need to fast-age the port at all", but the thing is, we still need
both code paths to flush the dynamic FDB entries in different situations.
When a DSA switch port leaves a bonding/team interface that is (still) a
bridge port, no del_nbp() will be called, so we rely on
dsa_port_clear_brport_flags() function to restore proper standalone port
functionality with address learning disabled.

So the solution is just to avoid double the work when both code paths
are called in series. Luckily, DSA already caches the STP port state, so
we can skip flushing the dynamic FDB when we disable address learning
and the STP state is one where no address learning takes place at all.
Under that condition, not flushing the FDB is safe because there is
supposed to not be any dynamic FDB entry at all (they were flushed
during the transition towards that state, and none were learned in the
meanwhile).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index aac87ac989ed..831d50d28d59 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -699,7 +699,9 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 		if (learning == dp->learning)
 			return 0;
 
-		if (dp->learning && !learning)
+		if ((dp->learning && !learning) &&
+		    (dp->stp_state == BR_STATE_LEARNING ||
+		     dp->stp_state == BR_STATE_FORWARDING))
 			dsa_port_fast_age(dp);
 
 		dp->learning = learning;
-- 
2.25.1

