Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EA4598815
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiHRPuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344265AbiHRPuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:50:16 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2081642D8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGenDveMDASm81Pdm78mjF5mAuLfPM6LVkFXl0SbzXrsLfc8iWoCjj9FKljW3Mm1jEV/Xnn3SuXAffYfaXYpCeugjVtOqrzDuwT5PRxLGPONOmwwDFh7xgdXqDAf7hTHIQQJO2hFdbMeT9fu9wwi2bdd7zSkF0kR/kDdgzKDvDV3nxU4yZ15hCA6ZIbsJ0p2bK6p6aA076bCeaKX6W9n47BcnlgxL/Om85mKgFvOSJbBozFh7v1Mdp5hJebewgeMlavdHuTK/oQarqacSjpHUf45Rz7h3eNOk7//ULzNPH2aIdAXZGpTHFaxDzx05wr0OG7fSNEILb3Ntd42uTTrUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEMP8tUJMkaKH9VDbzUFN4Z/aLJe0v8AnZHzYi7eB7Y=;
 b=hGWZ53O3kSNrYp5AM5c/GE/2BNi8q5D44+gWxQAvuf0HkA7Saeeprc5M2A22whgpaEsOWqBuv0gLCombb9D6AJWz3dzCVb4/9oVOGuGS5txAA57Sxsb2+Rl7Oy7GG7QuC2TW0FZKs1mW9gDlySuc0UihfAY19W7cRGbf5IhiWKTg2MDxX6SsLcBzcAAjfyL74NYkMmOEvxnSQqJyqY7Uxsmr/VCmcjg+JY8pMQSfEQlWvZRuHaRcia+esXS8q8kYqzCvQWpFLQBJpxVXHk3GJkBibMvHmmnjSjEhO5alk4MuEB1ySFoZEI2Nz03T8hr/1D7pITS/zqlNhL6WVX+KVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEMP8tUJMkaKH9VDbzUFN4Z/aLJe0v8AnZHzYi7eB7Y=;
 b=Dgu/7pmYIbEbrOLERdAUfnr/4WLrPR+Aw0xOq5vdxKSTiDsaftjS6uaKTJBIjnSTqSOA2DwC/6gfF6yyv38Kv+e/35Tv7g2NaRcr+e6p9Ett024NUPsIJCPQ3AVsdK0KxfgrCKM5oRwzcWXkGaFHnP+iZQYNjRY/wy5hzmIUDnU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 09/10] net: dsa: make dsa_tree_notify() and derivatives return void
Date:   Thu, 18 Aug 2022 18:49:10 +0300
Message-Id: <20220818154911.2973417-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60daa27e-c307-4306-dac0-08da81314249
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9zgUA56uUES8Sv3Ow8S4N5xrLhdpmqdj5US7n34ZwJ2c1QvK5YojtJ8MWa19rAUwzFCqWyqYWB2YFvnD5lyhREN1DzapxSJXuzETZI4CdXxy9NvLVRYvogoQEezfTPrFfOeFzuSZLTXeMuII5MblhDI4/H1vuJppyXB8Y0ea39Rz+QwsdRMCgqEG7m8poJxgBoT8HnWIO+EdwGGIyqxqTzZoY3UkyYerRNb7Ya4UmC9VXn0fYWxbk4eKx87nCA4H0g2pLCxSiclrNRmGRQfhK7g+NHKJWuBEwxJ+pfa2DRbSi1/6TTcbBVBmFITSBJZ1SWFliOwnyVyi6Z/lEFoWYRtCYgvGhmT1MBbicsBow1ndMQbx79UNtmJgTmgqLWLphfx/pMMbTmI5JkdMusHcFlQ6wXeteX7mcnk1mIhFE+WR17vNCfWUDTQpxxuzivbrao67Gp9fKzJZgX8k5AHl2sX/P3PZKRqYyV3z5KI48G8+FihfbEqsVMdi031BidlfEl6L37PoJQoBqivDr42yAbuhARnPeaP9BPrToSw+v4A0UFa1VLZiP6dTwHD7CtSGtVeAxGExOI7kYIjMMnIcdxOAfGHdIN1jthH3j4sARhk8l+rdGUZtKBFC+89JJ5YWoRZqcYm57H9eyJq/Pp3jcj2e4TfuWGvPs/hFcwrg0G9JnF8xzfyeomcT+SzFOO08e0F+su4uHbBFlsOGW7AXn+u16Hm+zPfc8+nSt/hdgwRXUqsCIWREf0Ihh/70VQfl3z869ERSbY/gNDUPE6EdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(30864003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VC7dXHE+x6u12NIgUCq3pGUBVaW6au2dNOa96uqeKW6mXvthFn1neb0a2ekd?=
 =?us-ascii?Q?RujqWhJ1J1SVq09Q+T8uWvhJ+kc5C14e1a56uwzFU8cxyAo0+oMJHEsQBKYC?=
 =?us-ascii?Q?HyAyqVwPBg4QQGP8wky2UkMiz79cv8FIJQSu5zI6xwjHbwx/yL4EU9aiuc9u?=
 =?us-ascii?Q?DS0U5HOvpCZT5DbMBrxyK5CRM9UgnoPmv3A/VSoUQgqEk1U98aq39ehZjTyM?=
 =?us-ascii?Q?O+eE23YrzqhXbbB869v1kDlWCAx5F+AYlasv5lDNoEZ9x3ZGfZWtQhfqT4Sr?=
 =?us-ascii?Q?RO6UZlbxISG0z2SSTqvbyeTufszkAqQA1B+LOKgnXOeQoWtEEaTwf1aJ6nGP?=
 =?us-ascii?Q?ziBiyLOfxX9o+VngCbADKq1kIo+NEb2yee0o/DH7e38nHYe86NYWBK75mYbk?=
 =?us-ascii?Q?0frIl6PEC6YTzWX/9LNO6uWylIjdZBVHC+eE6V5sS26yyOw8tSJih4NDrpKK?=
 =?us-ascii?Q?vpK42yg5Wt3HKv3ap/aCbEtQri2sWGbV31u3F/KacIvTjBHj1nfQSqvW+WCu?=
 =?us-ascii?Q?3xoRxSigXmO7au1Wo+4gjVdykIZ+fYH7XINLipU8scSN/MKjBUOuC+Z3W9GS?=
 =?us-ascii?Q?zeyjn8uQymDErsJifV4ECA8BOKzGVodxhZwaqj4a89VHPLWqC5dzmf4JOcIb?=
 =?us-ascii?Q?nbxILfGuQR+osctN0SkQLyhG/Nig0OpkAXDxG9deUzvEipAOl/WoERBzWBJA?=
 =?us-ascii?Q?nolbhMCAvEnBWeUhDd+kkaetM4PFMZYtqzr63OoA5cdp9d/m4EE3mwV1KIbm?=
 =?us-ascii?Q?Pv5RAKM0Ki6zDl87vreDkePVssc1jhKy0DoM4ATOHhcYZyu3CaUro9iXx6+Q?=
 =?us-ascii?Q?M1/70nqnD5XGBedoISZITYup1onkqtygpOQZXdzM/pU1FS2eKbHMuMPlW5Xi?=
 =?us-ascii?Q?P1eNTFVtXP2QFDLPif2kMuZJb3BPvTVT89PG4qIwThyIPNT3n266VPqkYSsr?=
 =?us-ascii?Q?OQOvTMr/DhIZti8mHbI3tOK7jlxHnKyerBnZ1mp6tftRwfLBXrzUXNCGUci5?=
 =?us-ascii?Q?VZi+3ao+GmoE0sdZ4DWTG37D2wTUd72qnqgMbO9Se5kQ5xpVVHXL7UpYq+sQ?=
 =?us-ascii?Q?sklWSawdpbCMV87XQ2pwThSEafc3eJnOMGq/75O0L2NTPm++fQ2ZmexWfI/v?=
 =?us-ascii?Q?ER3hyMvmOS1oA8M09b6ujThK+NFb3mG0xYjC0tgAzi8ZkoMyw/fO1afGjwx6?=
 =?us-ascii?Q?+ddOOvXLWB2w/hofsdVHUd9JcN590MDUCr4gPYBnfq6DqbnD2zw8uPxA/V0R?=
 =?us-ascii?Q?2xpE0L9ZUGi4zGPCxzScNnG/ioRIsQMrbWoJ8CGp5XDciHuyO7coiV4DbzbI?=
 =?us-ascii?Q?YudVrQeBQUgk+/JfSB+jqOignErkZFRHKXlKtqwKJSaI78vZ1vYCq6TmHxjB?=
 =?us-ascii?Q?ECHoAKqsDgNnDbvHILbNFY7xggA/JisWI342rVUgosz42rOK2XaDuIAre7mz?=
 =?us-ascii?Q?vY5DjZcZHxd3L+7jmQWwb55eeCTd9TkTraxYEby/WETfVTWiqWqozGDhJ/FJ?=
 =?us-ascii?Q?w+zVRG5WNl5CvpOnFyYRaMPOyAjWNqTrA+oRdy+J7r5luHXd5/+/mQA9tRFV?=
 =?us-ascii?Q?5MzYgRy+flSgxu6+Fyd3VLmbvYkAieLdFf3fnAzc8GGnrNehUkqKAGlnzA0Z?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60daa27e-c307-4306-dac0-08da81314249
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:39.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTB3Krz3ry7O51szICVQx08gW3mYwqNYYni8UUmkYfbT9ImTSt/iTEBIi6oguhgPS6KxLnr3jdWrHaWeas2UrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all cross-chip notifiers where we do care for the error code
were converted to use the robust variant, suppress errors coming from
the rest, giving a clear indication as to what we expect to fail and
what we don't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     | 83 +++++++++++++++++++++++++++++++++++++++-------
 net/dsa/dsa_priv.h |  5 +--
 net/dsa/port.c     | 62 ++++++++++++++++------------------
 3 files changed, 103 insertions(+), 47 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 40134ed97980..6596e7c2831d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -26,6 +26,68 @@ LIST_HEAD(dsa_tree_list);
 /* Track the bridges with forwarding offload enabled */
 static unsigned long dsa_fwd_offloading_bridges;
 
+static const char *dsa_event_name(unsigned long e)
+{
+	switch (e) {
+	case DSA_NOTIFIER_AGEING_TIME:
+		return "DSA_NOTIFIER_AGEING_TIME";
+	case DSA_NOTIFIER_BRIDGE_JOIN:
+		return "DSA_NOTIFIER_BRIDGE_JOIN";
+	case DSA_NOTIFIER_BRIDGE_LEAVE:
+		return "DSA_NOTIFIER_BRIDGE_LEAVE";
+	case DSA_NOTIFIER_FDB_ADD:
+		return "DSA_NOTIFIER_FDB_ADD";
+	case DSA_NOTIFIER_FDB_DEL:
+		return "DSA_NOTIFIER_FDB_DEL";
+	case DSA_NOTIFIER_HOST_FDB_ADD:
+		return "DSA_NOTIFIER_HOST_FDB_ADD";
+	case DSA_NOTIFIER_HOST_FDB_DEL:
+		return "DSA_NOTIFIER_HOST_FDB_DEL";
+	case DSA_NOTIFIER_LAG_FDB_ADD:
+		return "DSA_NOTIFIER_LAG_FDB_ADD";
+	case DSA_NOTIFIER_LAG_FDB_DEL:
+		return "DSA_NOTIFIER_LAG_FDB_DEL";
+	case DSA_NOTIFIER_LAG_CHANGE:
+		return "DSA_NOTIFIER_LAG_CHANGE";
+	case DSA_NOTIFIER_LAG_JOIN:
+		return "DSA_NOTIFIER_LAG_JOIN";
+	case DSA_NOTIFIER_LAG_LEAVE:
+		return "DSA_NOTIFIER_LAG_LEAVE";
+	case DSA_NOTIFIER_MDB_ADD:
+		return "DSA_NOTIFIER_MDB_ADD";
+	case DSA_NOTIFIER_MDB_DEL:
+		return "DSA_NOTIFIER_MDB_DEL";
+	case DSA_NOTIFIER_HOST_MDB_ADD:
+		return "DSA_NOTIFIER_HOST_MDB_ADD";
+	case DSA_NOTIFIER_HOST_MDB_DEL:
+		return "DSA_NOTIFIER_HOST_MDB_DEL";
+	case DSA_NOTIFIER_VLAN_ADD:
+		return "DSA_NOTIFIER_VLAN_ADD";
+	case DSA_NOTIFIER_VLAN_DEL:
+		return "DSA_NOTIFIER_VLAN_DEL";
+	case DSA_NOTIFIER_HOST_VLAN_ADD:
+		return "DSA_NOTIFIER_HOST_VLAN_ADD";
+	case DSA_NOTIFIER_HOST_VLAN_DEL:
+		return "DSA_NOTIFIER_HOST_VLAN_DEL";
+	case DSA_NOTIFIER_MTU:
+		return "DSA_NOTIFIER_MTU";
+	case DSA_NOTIFIER_TAG_PROTO:
+		return "DSA_NOTIFIER_TAG_PROTO";
+	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
+		return "DSA_NOTIFIER_TAG_PROTO_CONNECT";
+	case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
+		return "DSA_NOTIFIER_TAG_PROTO_DISCONNECT";
+	case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
+		return "DSA_NOTIFIER_TAG_8021Q_VLAN_ADD";
+	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
+		return "DSA_NOTIFIER_TAG_8021Q_VLAN_DEL";
+	case DSA_NOTIFIER_MASTER_STATE_CHANGE:
+		return "DSA_NOTIFIER_MASTER_STATE_CHANGE";
+	default:
+		return "unknown";
+	}
+}
+
 /**
  * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
  * @dst: collection of struct dsa_switch devices to notify.
@@ -36,14 +98,17 @@ static unsigned long dsa_fwd_offloading_bridges;
  * each member DSA switch. The other alternative of traversing the tree is only
  * through its ports list, which does not uniquely list the switches.
  */
-int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
+void dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
 {
 	struct raw_notifier_head *nh = &dst->nh;
 	int err;
 
 	err = raw_notifier_call_chain(nh, e, v);
 
-	return notifier_to_errno(err);
+	err = notifier_to_errno(err);
+	if (err)
+		pr_err("DSA tree %d failed to notify event %s: %pe\n",
+		       dst->index, dsa_event_name(e), ERR_PTR(err));
 }
 
 /**
@@ -80,18 +145,12 @@ int dsa_tree_notify_robust(struct dsa_switch_tree *dst, unsigned long e,
  * WARNING: this function is not reliable during probe time, because probing
  * between trees is asynchronous and not all DSA trees might have probed.
  */
-int dsa_broadcast(unsigned long e, void *v)
+void dsa_broadcast(unsigned long e, void *v)
 {
 	struct dsa_switch_tree *dst;
-	int err = 0;
 
-	list_for_each_entry(dst, &dsa_tree_list, list) {
-		err = dsa_tree_notify(dst, e, v);
-		if (err)
-			break;
-	}
-
-	return err;
+	list_for_each_entry(dst, &dsa_tree_list, list)
+		dsa_tree_notify(dst, e, v);
 }
 
 /**
@@ -108,7 +167,7 @@ int dsa_broadcast_robust(unsigned long e, void *v, unsigned long e_rollback,
 			 void *v_rollback)
 {
 	struct dsa_switch_tree *dst;
-	int err = 0;
+	int err;
 
 	list_for_each_entry(dst, &dsa_tree_list, list) {
 		err = dsa_tree_notify_robust(dst, e, v, e_rollback, v_rollback);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6c935f151864..263a07152b07 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -17,6 +17,7 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
+/* Please update dsa_event_name() when adding new elements to this array */
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
@@ -543,10 +544,10 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 				  const struct net_device *lag_dev);
-int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
+void dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_tree_notify_robust(struct dsa_switch_tree *dst, unsigned long e,
 			   void *v, unsigned long e_rollback, void *v_rollback);
-int dsa_broadcast(unsigned long e, void *v);
+void dsa_broadcast(unsigned long e, void *v);
 int dsa_broadcast_robust(unsigned long e, void *v, unsigned long e_rollback,
 			 void *v_rollback);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4095592c4790..1452f818263a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -25,9 +25,9 @@
  * reconfigure ports without net_devices (CPU ports, DSA links) whenever
  * a user port's state changes.
  */
-static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
+static void dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 {
-	return dsa_tree_notify(dp->ds->dst, e, v);
+	dsa_tree_notify(dp->ds->dst, e, v);
 }
 
 /**
@@ -551,7 +551,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	struct dsa_notifier_bridge_info info = {
 		.dp = dp,
 	};
-	int err;
 
 	/* If the port could not be offloaded to begin with, then
 	 * there is nothing to do.
@@ -566,11 +565,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
-	if (err)
-		dev_err(dp->ds->dev,
-			"port %d failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: %pe\n",
-			dp->index, ERR_PTR(err));
+	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 
 	dsa_port_switchdev_unsync_attrs(dp, info.bridge);
 }
@@ -598,7 +593,9 @@ int dsa_port_lag_change(struct dsa_port *dp,
 
 	dp->lag_tx_enabled = tx_enabled;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
+
+	return 0;
 }
 
 static int dsa_port_lag_create(struct dsa_port *dp,
@@ -696,7 +693,6 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 	struct dsa_notifier_lag_info info = {
 		.dp = dp,
 	};
-	int err;
 
 	if (!dp->lag)
 		return;
@@ -711,11 +707,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 
 	dsa_port_lag_destroy(dp);
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
-	if (err)
-		dev_err(dp->ds->dev,
-			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
-			dp->index, ERR_PTR(err));
+	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 }
 
 /* Must be called under rcu_read_lock() */
@@ -1027,7 +1019,9 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
+
+	return 0;
 }
 
 static int dsa_port_host_fdb_add(struct dsa_port *dp,
@@ -1096,7 +1090,9 @@ static int dsa_port_host_fdb_del(struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+
+	return 0;
 }
 
 int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
@@ -1165,7 +1161,9 @@ int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
+
+	return 0;
 }
 
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
@@ -1213,7 +1211,9 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
+
+	return 0;
 }
 
 static int dsa_port_host_mdb_add(const struct dsa_port *dp,
@@ -1274,7 +1274,9 @@ static int dsa_port_host_mdb_del(const struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+
+	return 0;
 }
 
 int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
@@ -1327,7 +1329,9 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
+
+	return 0;
 }
 
 int dsa_port_host_vlan_add(struct dsa_port *dp,
@@ -1360,15 +1364,12 @@ int dsa_port_host_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
-	int err;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
 
 	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
 
-	return err;
+	return 0;
 }
 
 int dsa_port_mrp_add(const struct dsa_port *dp,
@@ -1795,14 +1796,9 @@ void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast)
 		.dp = dp,
 		.vid = vid,
 	};
-	int err;
 
 	if (broadcast)
-		err = dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
+		dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 	else
-		err = dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
-	if (err)
-		dev_err(dp->ds->dev,
-			"port %d failed to notify tag_8021q VLAN %d deletion: %pe\n",
-			dp->index, vid, ERR_PTR(err));
+		dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 }
-- 
2.34.1

