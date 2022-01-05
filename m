Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B704D48537B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbiAENWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:22:11 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235186AbiAENWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:22:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdbII56TdKHnwhDjmkjoMfetDgz1xzhYAY679GPVHrCVnK8xyFx1bJYb4BHD/Z9Y19JcHgPur8Jy7ghbhThf1gkpZMNBzmvJSsSUg/IGYP7u9yO15WCdp6pYQWu34+398rIo5f7lx7DmcMp1HvWKNKQx+rGK9nnK7KiuLM+c+bKZaN1So0+Ce9FjQwoz8X7aeA6G9p1gU62UVNpvwnWjjO+x3NKEqyOwNfrlZGkIKwqpC5H/ZY1YPBc+9wz0wws2vglKTwbdoGknwge7fI4BEbwy6uvifv3ElrZBHuphiDIf+lRHqoRaIP0toKmLOn4YVg/g4uoN1+pOLjRc0RJYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVes2I22LqyvIMkv7l6UANxjhDHISZ2RgZXPj5KUsgw=;
 b=QIA9ROWmqSy4KSQ/ZQeIwuDpBB9F7tXS0AgeXEmZyXKG9YOfb3u8R4aCLDjCa59mGipKHKdLrL381HN4YTa7APyNwqtcI1//E4+qLncTgUNi95b3Hru6hJDmE23VSZdG1iE/Vd2VX4HBg++Bf0cB7f3beiw6zZCzfADtOkXvvRuReFIviUO0s9u5F/RbcqlBTW8l4YGNUAgvuHPSO1DAVyag8Zn8Kc3I+m5uWlyZAE6bX5BX4nqCzERrS2jZKgXhPnGIZG9wVMHhD+EBfduc9+Sqkr/Ndg7w6Em+35UHFR10Qf6GHTzdQBLv/262EcCmqMmr8I/uZ954ScVjceMKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVes2I22LqyvIMkv7l6UANxjhDHISZ2RgZXPj5KUsgw=;
 b=J9urtfIhz2icI4M2dRnhIqwGO+LlFvW72fBH3alBS7TtiN7lU2ocXyhwnzQANDSbayowixJ4TllkTDFOffYBwzocdRXGYDSbHANhX3tG3CjTAY7Te+urK7okk9s1OqkhLZ1FkhaYCGYVGczuDgJae9Ds7ui0U3aCU9qcSrs2vSw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 6/7] net: dsa: move dsa_switch_tree :: ports and lags to first cache line
Date:   Wed,  5 Jan 2022 15:21:40 +0200
Message-Id: <20220105132141.2648876-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0150.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5363893c-1c24-4a0d-6ea0-08d9d04e5913
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB74081DA1B130097370594798E04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KaRJZCtxyLcQAIf8Iv/j2E3GLCumWRFf5WkeFZrequaD8L34pahWZq+z7I1lDF08c7AM+ZA26ksej3siqXif4cYUPzg6+VVaND7ASzyX8u9h5WAGLVpTfeGazGjTjMCSxfxyc1iWX+fc52EX1vv1h5v/cvSJQvlYwv0YlgJ4aIj8tz9Rabfw/8pBDvgd94zT2os4FDZ6HyEznlU78fegWL09SJ/khGRZA05kUAykXKT1R/bnVRmyw+hv28pKc4o+X+sLQw/mpm4ADO+Jfs2iKs4idCQgRTJB8duoivFfoJeQIKHLpKY2E298V9t8Leu1W0fa9Lr11WX0MSTEeRnEG/rB8OEPmR87sSlJqyQyHonMiX7Up5GNMxYxICeW94j4vuHc0rSA3oUOl5ZmsAb87+xnWl4EeNKIEi/vB+HQQIDW8Uf6gBxlLzN+9vWUTg1lZDF9jej0uozvf7T4HhbfGGf07Aef/0OKsxnav2y2QSRA89H4aylFiYnXJ9HTDwmNfPpy/cO93FspPSBWp/f1HyOAlZ98rlMNxB2tKHPn0qhs0/FuqexKxtypQ7AuwJDfKK5GHseFLd4FJxKUGhl0lSmhML5BLPVPubFbnUy5k4xJU91Uiy9wkFvsVGikvExT/xGm6CK8lTZslj0M1p0mlmh7IB7uRuXHbz7o5SYT7w4UhIF4vNHbO4Vkq8qvuDFhqQyXIDlk18tL40SIB7HRGg2WYLPjzZ03XD/Lf75Km8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJF5IAwxAWGwgpGlFM9r+NvGXCU73R6NPy8ybf3dCXjYrpY/AtIfNbBm83zl?=
 =?us-ascii?Q?+77TfyTBQPxxwDh2Hozvq3toPKjhiZGTcLD+epgqBcu9OO0oynHw6eZ/i/Ca?=
 =?us-ascii?Q?CP9kmg5u2P7CZKjqjFHwSKJHDtU5Sh5AlDhbomnydmSys+Qp4mc+9AbgSIC2?=
 =?us-ascii?Q?BStqQb72qwGImRv8bBNknCfCLmm61ovGEdxsVk1thYTgLJS0xRZBqQgtOHXp?=
 =?us-ascii?Q?NqiSZXXqpycM/FUO1yCsWkppLDxgbDJNPU547SPRx+Lp+sJf1RaQZ+dju6lb?=
 =?us-ascii?Q?hWUFm3fOvEwSRlanqQk9sew8kY+iGwoPPcxw99Ka7zqkK1Z9DKxZko5nXq6T?=
 =?us-ascii?Q?TBJnOEc3z4TPfh9oc2nx+aRCE4MwbAba75KRXnV2ow4TX+VBlcaRufbBFI9S?=
 =?us-ascii?Q?1mysu3A49h3x2UaFE6MEtLNB2KE/yMElZxoCNRgRBkHJuM0M6tW3d7RRdyvq?=
 =?us-ascii?Q?SyGOIyYSQDdLEZTGyuOHQMAkuo/wA44cyaG1fSIgqIPj17blP5FMxo+bdsau?=
 =?us-ascii?Q?1CNLZCRfnEjxT95U7tb2Wa85Zzr3Wysn7A54vxDa55qxhYoTau5qhXAmp7sb?=
 =?us-ascii?Q?h0UAFBPuoSSZGm0xe5swvkVza1Cj2cbM1f85aHuvX59rvFEJX1v05jozrglQ?=
 =?us-ascii?Q?5yGTTVfYf0Nf/trWdgefBbckmlLIuyIon6ocUNtuHgKPLZ0zOCOC3tdpwyPE?=
 =?us-ascii?Q?BktTWHE5/dc3/7o7CsSyAzEcmaw3DZgCAYyOgQlj5CMlPshsuQAB1x0SELIV?=
 =?us-ascii?Q?oxauKlVVcxNeX1W1M0P7Tew/5VsjoQ+PDZJBVPV4xWzHGS04VGCkzI7Vjw5T?=
 =?us-ascii?Q?XsQL+Fhf1rR7sKtgPyRcyfs4M48rcNn4ozek/2HUhArF3ZTKsEptu0PifEys?=
 =?us-ascii?Q?H3UfRVB5RR1wE4a6Fg3oSiHx1haAHbJwAfaCB63cWDTPT5NPIQVUeV77brJn?=
 =?us-ascii?Q?DC86SdTpTBvCQdoNgcsERzBvGppS0q7SqGGKXb8bkLA9cFofy+gIZEt1ZIjZ?=
 =?us-ascii?Q?bVNfcIwhfUF8k9+fjI53mCtcBkFFP3UMQge1D0RxqeHN74uyyejWfK6tvsVw?=
 =?us-ascii?Q?h/sdhqdWSe4mKRedS+5OyqdKaucyiTQfqJm+4Q/1aaEBik9qAiRESI7jy0Nq?=
 =?us-ascii?Q?XqwFBdCJ0bNohfKxAtO8tmnLwnI770/+OSyeu49lyPG3NWLRFYQjLoQwE7aJ?=
 =?us-ascii?Q?ChlRRUjERoN28ziYLZMqmjJZ43iYRrZj4CWJb8O3cKMGYvgpcIh+y5WFm3Yt?=
 =?us-ascii?Q?WMzEPcWsL5vZnkt4JUJLf2AKtkeBSqMdwHKjN0DRb5X0brUaW2Mnaj/mSXQl?=
 =?us-ascii?Q?7a9fWM8YY0aKFU0hq70JhOwQwOYxd1sVOquzxn1WxdA2myR9D9v+fd+Xxbm9?=
 =?us-ascii?Q?BEomRlayXWLJkHyaVRK9II6PwYHv5AMvzkFZJAddb2yikUdEKbkQ4HNn9JwI?=
 =?us-ascii?Q?Az3+MkDgbYHxpbZ+uk9e3zbnfd+fTZdCQMsnm9lEDU2o10ZsoK7pA7lk0Gp8?=
 =?us-ascii?Q?JCRlaVt/yAhXJ90qGnBqcKVTCltG2tBqxpVPeiFpnjRB0oQHqDzWSX/KceCV?=
 =?us-ascii?Q?cKyKzUVkndVXOzOFdagu7DCxy6F89LPOifjrLG6ek++sMEa85G/QaIhL8Fpz?=
 =?us-ascii?Q?kP1InW/2+e6JFeI65OCKOHU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5363893c-1c24-4a0d-6ea0-08d9d04e5913
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:57.1357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBkebYrR9p1ON0LldCtIXEJd9Ei1LDFHcgaNRdh30XLVu1nU9UoFNZPb2LZfmMRf/z+N0XEQDQDksDe1iUvrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dst->ports is accessed most notably by dsa_master_find_slave(), which is
invoked in the RX path.

dst->lags is accessed by dsa_lag_dev(), which is invoked in the RX path
of tag_dsa.c.

dst->tag_ops, dst->default_proto and dst->pd don't need to be in the
first cache line, so they are moved out by this change.

Before:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct raw_notifier_head   nh;                   /*    16     8 */
        unsigned int               index;                /*    24     4 */
        struct kref                refcount;             /*    28     4 */
        bool                       setup;                /*    32     1 */

        /* XXX 7 bytes hole, try to pack */

        const struct dsa_device_ops  * tag_ops;          /*    40     8 */
        enum dsa_tag_protocol      default_proto;        /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct list_head           ports;                /*    64    16 */
        struct list_head           rtable;               /*    80    16 */
        struct net_device * *      lags;                 /*    96     8 */
        unsigned int               lags_len;             /*   104     4 */
        unsigned int               last_switch;          /*   108     4 */

        /* size: 112, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 2, sum holes: 11 */
        /* last cacheline: 48 bytes */
};

After:

pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        bool                       setup;                /*    56     1 */

        /* XXX 7 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        const struct dsa_device_ops  * tag_ops;          /*    64     8 */
        enum dsa_tag_protocol      default_proto;        /*    72     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    80     8 */
        struct list_head           rtable;               /*    88    16 */
        unsigned int               lags_len;             /*   104     4 */
        unsigned int               last_switch;          /*   108     4 */

        /* size: 112, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 2, sum holes: 11 */
        /* last cacheline: 48 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fef9d8bb5190..cbbac75138d9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -119,6 +119,9 @@ struct dsa_netdevice_ops {
 struct dsa_switch_tree {
 	struct list_head	list;
 
+	/* List of switch ports */
+	struct list_head ports;
+
 	/* Notifier chain for switch-wide events */
 	struct raw_notifier_head	nh;
 
@@ -128,6 +131,11 @@ struct dsa_switch_tree {
 	/* Number of switches attached to this tree */
 	struct kref refcount;
 
+	/* Maps offloaded LAG netdevs to a zero-based linear ID for
+	 * drivers that need it.
+	 */
+	struct net_device **lags;
+
 	/* Has this tree been applied to the hardware? */
 	bool setup;
 
@@ -145,16 +153,10 @@ struct dsa_switch_tree {
 	 */
 	struct dsa_platform_data	*pd;
 
-	/* List of switch ports */
-	struct list_head ports;
-
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
 
-	/* Maps offloaded LAG netdevs to a zero-based linear ID for
-	 * drivers that need it.
-	 */
-	struct net_device **lags;
+	/* Length of "lags" array */
 	unsigned int lags_len;
 
 	/* Track the largest switch index within a tree */
-- 
2.25.1

