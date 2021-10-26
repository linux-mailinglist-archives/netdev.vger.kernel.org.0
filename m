Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7669B43B404
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhJZOas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:48 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:38305
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236529AbhJZOah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IClRNL2SbyET2XzgPEEaw2hFU6M2Dc/xvGF98/Wih88rvDaDqtBp7kTYbgI83Q8Md1plf1TIvO9SrqMbKaa8GRY8p7V/rLyL9ek+PIqJNYJpMJSZNdImGstLsFmWoAVztFD2M0CbuOQxfSHf/z4ZmvySnUvgQbhU4WAyDVE2UKdcUd/S5S2JpZ7KRNq2FT8HXnV7q1pQA7KZVgnPPS5Ti5HT6sBf8fwk+g9PcyuMNwSGzcrk5VGhAcxws+EXuAPXP3DyFwJyB3F6iC3zhGnjWaWecdAFg0MBB9ncZ9+SL06bIKNmhkGrytrjCIQ2WpaGH+q/xLKM8lX0T/dCrv1Zbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63pB1gdBjXYI2zozRkrHArNpGh2Z9uUiBRFA80kZ/Mg=;
 b=Xbi3qSva11lXpwXZb/Xw3iuVHlpoXNYW+U1fxkl8fHSlwXybOtfYTHCHJv97RW9QdaKnXD6EEw2rkvHgHJa2LOy45V0L1LOJXPyDfEfiD1XxwnZYJISn67kjX5uaqSTOEb3qCw93hPMoaY9/G8GZ8f/kwuXJCQKZBgE29e1PIJdFWVrcWsjEUq5Ek4ovHO6pNrmA+GTAF6mkdtpEIf3g0EeEy9vYcPKPEzmwvpydMy1+KpNoinQ7KJSOGG9ygDJQvf7OsmG4NlRMzlmA8GFN8FKFLFcBDNZez9VW3HEqDt6lBusCsZ5J/btHjNM5/CnPK50TedzIVcxb91rrvzFZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63pB1gdBjXYI2zozRkrHArNpGh2Z9uUiBRFA80kZ/Mg=;
 b=aFRDo49BnxrLZdeh8w8WjixF99gQrTc0OKs3xuy72yVdD5lvfwf0rvKj8qNyCL/LAs78lbtAAQZU9U7VuL05k+1o2MV0wjFxo86Bq1K0KIj0ETamIsbzRocJUr75hvsZ3Loz7/aCeTMbW4LvkL1M9s/ecSDNHNx3TKIvkVB398k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 14:28:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 5/8] net: bridge: reduce indentation level in fdb_create
Date:   Tue, 26 Oct 2021 17:27:40 +0300
Message-Id: <20211026142743.1298877-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40df0db0-e910-4f17-73f4-08d9988cd57a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967C78DA9A137D38C622C6AE0849@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFoqMg7IEUu+kL2iQCBSg1enydqU/ssQrgZtEVYs9GjzwlVlKwat6Mm+CH9r1B2/ZEdCZB5W2ahnHViNhp4KaX5XEHD4o/0kyiaEBwsKj6jVl+UWpdgOB2fqdVKx/hh+/0RpBh70ZVG4NyzNFJ99JreZm+E6o0JsiE/6Rvl+p51bMCP7tilhSWwaTk9MOG0myK4cIbHmVwJuRsHqRBMA2r6MHmjZJFp+Z0DHg+f1CGLRX5/oBG0b8ZZaUinCBZyS/+Yj0NFczi4+vEBDNGtOFuZiB2LTRj6lDBAyQCkphYbsBDE/MfTOWxx9kPvovdTOefGeS5wf8LrQi0gr+vmYpCAa/vnDLoTyENESlPNfvLDnAc4+ulLyi9Gd4MObKNypOdePn1Sxf57DtQR+yzbpSRBmcFG2gsuQszA6C86RTdz5VCT3JB+iGnPQRqxULXJhiaVO3uodrziE5VYhdeW/3zKERX/6xsJxl55Uo4JWwKU/bKqNzYEbWayMfvL8hiQHe/GyK0Qrevc5TYc3MuNYNbJdocibNLJBPPz9OfpL+lNhQ1p9GQTXNCll+BRZZdz+bRT/TTnNY0BHKL0QtGaYemJ78Ckupz3RrMJD1yWdHkWCjNQO006lhZ2lQgtIWHhgU5sWESZMP6CZGy/q549z8AynTa5X5Tkj7RYlU+AnArybXzRUkl92RL2mzVeepwbHl8WKlsRJ62L3MM9cUvFUBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(186003)(66556008)(83380400001)(8676002)(52116002)(6512007)(6916009)(66476007)(36756003)(508600001)(66946007)(2906002)(5660300002)(316002)(6506007)(6486002)(4326008)(44832011)(8936002)(26005)(38100700002)(38350700002)(54906003)(956004)(1076003)(86362001)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZXpfZlO6TBDVzTTsXCJRM+8/qt9STBSlFs2WHmz32nKOJnxJxqWgabPUqTq?=
 =?us-ascii?Q?XBKhCVGJfCIxbdGKDo/S/AJl+v2zSFp7V2pUTsWoxldPTZz5HJy47eHCPdTC?=
 =?us-ascii?Q?omnOMpaM1DtoWp6wsapn7ChCKUAnrqd4aez+Ui1Hi+eyHCT2t1V0ACstv/KL?=
 =?us-ascii?Q?i0DcyTl4l+I62grxE0HPFxjIMrh9fCybvtpyWtrcZ+MUV2c/ajjV6+FBwKYC?=
 =?us-ascii?Q?ccgk5LAaT7AEkOea5Wz+nldF0Y3ZSinnzO5dX0Q+jzxAbFsKladNrHhoB6k6?=
 =?us-ascii?Q?BTaRjSWY/OuqYDUGIzCT5L5DKEAhFmwBRZFhvbgUst87XjZQ5Qj7LHkpXCp4?=
 =?us-ascii?Q?A1GtronsOy8wEMEPM1721qt/EVhcJW7BXz9yOtVWUoktKr0wHjbLJg/gCx5C?=
 =?us-ascii?Q?F1O1syoRc3Poy9PYqNwMuR5AsqBPUuCfmB4zWNM2QQHkC9FNgPi5y5OWKwMf?=
 =?us-ascii?Q?o+Z5DeMGuIFRBSqVN6QQQ0sNNwHi7YxDdoAInVILzwxl5wbLS4VquXd4Pu5L?=
 =?us-ascii?Q?YHHaoxOiBdk1DFOw+NXK0qKzfNJtWfGT8gBdIrUKZx8ZBfZ+1jKRZDZSdbMg?=
 =?us-ascii?Q?k7dHgAC23NFB7+wYmtxCdF2su43MKsVQOrsC3TgNDrad4HLm2Pp4jsXIoW9X?=
 =?us-ascii?Q?RNMmZgeH2t/FprEDJrfmRKs45jjJ34bgIJN58XbYPoxOJbQqgIkmccDeieGN?=
 =?us-ascii?Q?Q3wMnx5jikpEQGQn8zvzp4mVf4X4tDMdQoAiElqeJdu/Ey1qWEtu7GvIkN/R?=
 =?us-ascii?Q?OXb7/hwTOMmUEDSCZraTx0y2jm72DMr6l7/CU1jbtWJEq9SPig7i8dfc76Bu?=
 =?us-ascii?Q?70r4rpJznhqiFiqOhXkPdc05RMyZAMbm9xQzr08R+GZIEhOwYNwMQvb38xBY?=
 =?us-ascii?Q?LmE+2ykHl+R5X88SQfuDyL4N7TdRw0n863Msj8z7dxvjGqciO58kQ0vfYskE?=
 =?us-ascii?Q?Tcn69QocChO17f8aLa4f+nsfN9mERjXjGISiMLLIr3bpR+rynWdmxvWeaESR?=
 =?us-ascii?Q?0XcMArYLY+f1GtlEJV0cIQ/cjZWLmlSzpMdSsVxWfV4cIbSWvERbxq62ffQY?=
 =?us-ascii?Q?kwuB6NpygkwDgLwK48Mw6iEGItJsLaqW+LeFx2u4hqaxU2ZFv5dz93q+H7TF?=
 =?us-ascii?Q?hXGNnbVj+xafKE4KsC91cdwoTOoQCZVs6/lk/srLEv+zQ5mTvCj7VdtPmrhE?=
 =?us-ascii?Q?NJuTNlQu+TJTqXRQ3uGATydTOpxS/jeEtTk5zzZO6aEfzhjbSb7/8iXDT1IN?=
 =?us-ascii?Q?HPKR9VaQsfCFr/qr89AWJvA6CZXQLzhMMwf0C0ysaYsJxDI9o6efWSFVrATt?=
 =?us-ascii?Q?965uCFeF9AiFbMgIZ/PoTt6GxPztOvOEhdZD1cGcGb8aswiojSa6cxsa3cSU?=
 =?us-ascii?Q?AlwKH+nBIhmv9k8u5Olq2B4BmMQRsqN8vWHCO8xrWZPP92hE/q+/CYUf+N4t?=
 =?us-ascii?Q?YrBl0mLKPOQM+cEuK8VZSsKF0esCJlzZIbUUMJFvVoVJ+Mxi1nnBCi9phDXj?=
 =?us-ascii?Q?kfe9txYIlcUUCJzC11fXmGNLusTgpYxbivHZIvVzo2upsN+yyCyBo6eyRzIr?=
 =?us-ascii?Q?dU0TQCWfhaAVR5W0tnrqfyV7fGT64L8S0P30x8EDJDK8Js+vX+tEM1iPyNBB?=
 =?us-ascii?Q?Z0esBrsZzx4QLdPwAGaxP4Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40df0db0-e910-4f17-73f4-08d9988cd57a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:09.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSHjW9MRa2FggRSKV72tfMwo//5ixHwfPf76u8WZu0gVS5LQeI8de15q9B0FCDfxWqPzL6InxwRxoQEwO9ahiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can express the same logic without an "if" condition as big as the
function, just return early if the kmem_cache_alloc() call fails.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 09e7a1dd9e3c..f2b909aedabf 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -382,23 +382,26 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 					       unsigned long flags)
 {
 	struct net_bridge_fdb_entry *fdb;
+	int err;
 
 	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
-	if (fdb) {
-		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
-		WRITE_ONCE(fdb->dst, source);
-		fdb->key.vlan_id = vid;
-		fdb->flags = flags;
-		fdb->updated = fdb->used = jiffies;
-		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
-						  &fdb->rhnode,
-						  br_fdb_rht_params)) {
-			kmem_cache_free(br_fdb_cache, fdb);
-			fdb = NULL;
-		} else {
-			hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
-		}
+	if (!fdb)
+		return NULL;
+
+	memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
+	WRITE_ONCE(fdb->dst, source);
+	fdb->key.vlan_id = vid;
+	fdb->flags = flags;
+	fdb->updated = fdb->used = jiffies;
+	err = rhashtable_lookup_insert_fast(&br->fdb_hash_tbl, &fdb->rhnode,
+					    br_fdb_rht_params);
+	if (err) {
+		kmem_cache_free(br_fdb_cache, fdb);
+		return NULL;
 	}
+
+	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
+
 	return fdb;
 }
 
-- 
2.25.1

