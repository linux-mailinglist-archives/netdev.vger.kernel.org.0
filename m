Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422916DAEAC
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbjDGOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbjDGOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:15:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB338A5B
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFLowSieKpSHcacEiwFuqW4cpJ349wLXr4XqczSWq6vnUV04hrvI98lqGB28HCREPiIDLSwkTkLyBQmqXwNi1qMpE3RM88506vZgSfeKLfV7ZYSYNOEwBjXikdNMdo9T38SDa4C0rqVCiD++JT+2dVzkG33nPrVrHEvAwTS3J7ME/+FnDQEjuzLVNpF/nHyBRYAEQhrswCsp8r8n4rsANCztcYW7VHU8HYTjJjj1Ic4pmd4ACvHmbzYw40P99ohPjovH/T4s+ZDzIuvDrPPIa7Tt/0czEbJjhvCUGMWmCuIJhEwIRi2as+LOD0k/AsbmIOWXK7LLFPtCxwl259Utzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex+Mstf5UwOoMrJNKmPD73HfwcHqWlLEjEgrKOGKJ8A=;
 b=ZbHCZKhUwah87CD6UN4yA7fQZGgMS0+isgeFOgfCA3nzzp0Web/5kYhgZGAEnmKfusL6U9wok433Wc7y+2czqV1kV0l+ndcga4UUW35E7QI2I9jbxuME5E1IK/yoHABFxWb2VjDRqzBSkezz39HE5vJsAz4OjA+PtEHuG4hUBOHa1wx0hlSW9nKN8vdrGobk607yQjiB4K2TOYUYCPtaPd4Bvjm1EL1Os4g3I563UCiAbjz0L6ZLPu/DgMZ1xDfnhm1Tbzr6MpG8EWyfqG0ycwoWrb1Q6C2FTGDKkIlGP1CNaZToRJAoVImLy9ZOngiJJhlM19xtTYqrCIdkwy69AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex+Mstf5UwOoMrJNKmPD73HfwcHqWlLEjEgrKOGKJ8A=;
 b=mbl7Ut9DJDQTAWrYXrqeW0e7OKVSatSx9mjSWzQCF4ONJ1JYRmfb2h6ITlFU4lKW4L4oW+xDFvf2TRb8OWingwIo0UDlk1dW3IgbKPu2AbdZcjKUaCavKVWYXlySlvRU/sPX7j5HfyxM0jrOsqZFCnNWK4tNO+VuL2dBKsODmj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7405.eurprd04.prod.outlook.com (2603:10a6:800:1a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 14:15:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 14:15:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: add trace points for VLAN operations
Date:   Fri,  7 Apr 2023 17:14:51 +0300
Message-Id: <20230407141451.133048-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407141451.133048-1-vladimir.oltean@nxp.com>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0134.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::39) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: d590d8d7-b427-4ae8-32c4-08db37727b40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0a4k+WS95/JY61Jw7HSlSTD60sewRTHc8vjtK6ypiRiln4m1MpJPM0wEbDE91orrZ4r4tnzCYcXCMZswriNlllQmIgIMluwsQmCtu/erWqFzO6r7ZQPmYCPEpihSJ9lxGdKeii+0JDhAcnNO1d3WdYMMOX8J4kTE4Q8zx3LbOmAlLs2aj1EOGRoVhm4pkWf6kJJER0DKKOD07ALgZeOzWYTIEdpamEkFZ/I8Q0CNGsQquCVqPQw6GuX2IxH9EsywZKt0vx6Qsz7VjZRaV4ddPk6eO8iUHSi8eUjSy2keDl6tlHQjkw+gFRLz/5RvV7h9zHIp4Wh8EFfY8UfZ7SNMMygLth9gXxZyyFOWGJQttbREjAPzmFrXrR8Ae+qSqzS7suLdQosEn6j26xI0h4TBLqJjWlzz0cReDUzKfcNkLUVNqDkfD1oJfN4kQXsTLrelLAkaZxeNPI7bi+nnrh+raKAMMDGDo00Tb38SY+qtuv6dEZiubfTzoNM9IyQqwirauYmuyG14ebVGTlkWF43TfH2FFp2YrfIibnbD/9jb7WIjF0r9fO/cNSBf4jCfQCXs5XHEabHae+HWbYt5+KAWC6lASSlw/aqq5A+slvPgCXqsfJqjg+fg/1xJ5hPP2AW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36756003)(86362001)(41300700001)(52116002)(316002)(8676002)(6916009)(4326008)(54906003)(66556008)(6486002)(66476007)(66946007)(478600001)(44832011)(2906002)(8936002)(5660300002)(186003)(38350700002)(38100700002)(6666004)(6512007)(6506007)(1076003)(26005)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?83L3zUberDNR/NsR+yo1/e0XTGZNPsL9ergGKgAzl8LeHviUk+MREmA7syzA?=
 =?us-ascii?Q?3UepxlTQyvLNakgyGjOJyzAxy9MCmxPmVMzQ3mTuMlVsjbl2FzPPtLl6FUiQ?=
 =?us-ascii?Q?g5aZ5h1Yh+HNHhAlI1iz4ZklTzYj7qcgvBJc+ac+4AABkYTfcZGtrmLgt2Ln?=
 =?us-ascii?Q?YJe/DFKFr/rHgGp0mI8wzMgyPgFbHKgwDEVUd/wjH3tYPFZmKuELw+hKaSQW?=
 =?us-ascii?Q?nkDnsZE4GVb15uq4fI5Md/JZjWDObwh1syuJv4om869+P18oY6mJdq66UDb0?=
 =?us-ascii?Q?kuDBFutZ2onVpwaSgAqk8zOg0d9Aw0MGijXZe7jIEUmW4kANtPMSJtm4ecX7?=
 =?us-ascii?Q?qnQZO/9fJMfLhuJvx2qKbaXb92eQpHBdovsbltFoFNqPFkiIIxcslAwhcb4F?=
 =?us-ascii?Q?wf++OtPrxtqQLAB9WLiaVFigiPt5auLrnClVoB7k0G+TpgcebLgjwFGhzD6U?=
 =?us-ascii?Q?uJZeA3j+mS55s3Z4lOrWZUdS1onmnwV3LunnmjthNWmzjjXEth5HgfYFCxRv?=
 =?us-ascii?Q?pGp43L6uKsvNaZTc0Cxi0JJ59Zu5gMReV9I9dn56DTJQaude3wuNf9ydINde?=
 =?us-ascii?Q?XAgW5mYPyYYcVpEKwzp+wfyo4KSfjI3ellczw3M5MfX/7WeihsWFyMyMSh5c?=
 =?us-ascii?Q?J6QPImgJwIwUk9L91QOl35JtZLvNJEbTaS03zgcqrRGoCDkvcWYutWttqck2?=
 =?us-ascii?Q?3XKd2rl52E5FI9HcgjhFov2MrRfN5msosHIzyHVeX06pqzoY3l73uzVT8FzY?=
 =?us-ascii?Q?O8kDndYRzqGddA7ADLcQA6C4AnhiFC1H2ZQludn/UHWhcW6AowTmBky+dSzP?=
 =?us-ascii?Q?ZDOlyAhlmoJmJn5CXOfWtVt7SbAiMBfPpVsAkGhOm+Ib2VKYjxa59zzP9iRA?=
 =?us-ascii?Q?xD+DmAOkRpmk95VBj11fecMgR5gPqqvN7XIMVOIS/OuMFaulE+DHGSjwVoYJ?=
 =?us-ascii?Q?ZflfWNwCLLLyv13NsqI0KPX6RXWtokQ34jiInSKm6M40sj3IjUeb37PNDYm7?=
 =?us-ascii?Q?SDin2zhPMlZfUf1n7xYJauaH3RoEKgAM+kIeluxuOPDqpUSL1TOmGNuhq76s?=
 =?us-ascii?Q?Yq0Zc32l5AE2W42lI7NpL5tOivFLOgMA+gt2vg0NJncRaSfhZpeHv7GqHyjc?=
 =?us-ascii?Q?dmYF0g2caMGSqwP4xBhsaiRa08C3k1A5saAxkaYBnv2Phc2Zx6mvhSnLu//a?=
 =?us-ascii?Q?BQPOSwXHBVgxo537TJP6AxZoKVBHYq1d6J0BE1MFvN8T9GH24lJiSc8cHLCp?=
 =?us-ascii?Q?I95Zj6fX1vnpzwOz07RsaUsDmQRivWXinnzLxjrMs/2zyKbs6faiSSGhxWwY?=
 =?us-ascii?Q?rulGoTKkFJn0A/kYRkEfB/0f7IFHcZJWlC46nJE8v4fQ5TouedFzAZi6aH50?=
 =?us-ascii?Q?HNbhOMSgbYAQKfN5V8MVR5WsXgJ4nevHfv6FFX9BCzaSP7oRTl+S8gY2ui94?=
 =?us-ascii?Q?M2afK79aKADVf9Vv/8RGxcc+dOKm2/9P3xyRBjbv/iTt1VTgh11pPvKvN5qX?=
 =?us-ascii?Q?vsAqQOJLc5rvYHNTPiG5Ba8jxAqK7SkOpbB6TaYqdBU9jbKIliFpSQLmGqBT?=
 =?us-ascii?Q?2f4s7zdhLZ57ZoStpGzQOpt/ofz1uwas/qMnhcb/4+mFf8bms9xYw0b774SD?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d590d8d7-b427-4ae8-32c4-08db37727b40
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 14:15:03.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lCyP1OVa/FJqShZckM3O/MTPFUaX7Or2CgVpEywW45C1sYlJk7jRQUmPHeyKBchIf3dKlR3b0vBsDYM4mE//A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7405
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are not as critical as the FDB/MDB trace points (I'm not aware of
outstanding VLAN related bugs), but maybe they are useful to somebody,
either debugging something or simply trying to learn more.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c |  24 ++++++++--
 net/dsa/trace.h  | 118 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index ff1b5d980e37..8c9a9f94b756 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -695,8 +695,12 @@ static int dsa_port_do_vlan_add(struct dsa_port *dp,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports. */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_vlan_add(ds, port, vlan, extack);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_vlan_add(ds, port, vlan, extack);
+		trace_dsa_vlan_add_hw(dp, vlan, err);
+
+		return err;
+	}
 
 	/* No need to propagate on shared ports the existing VLANs that were
 	 * re-notified after just the flags have changed. This would cause a
@@ -711,6 +715,7 @@ static int dsa_port_do_vlan_add(struct dsa_port *dp,
 	v = dsa_vlan_find(&dp->vlans, vlan);
 	if (v) {
 		refcount_inc(&v->refcount);
+		trace_dsa_vlan_add_bump(dp, vlan, &v->refcount);
 		goto out;
 	}
 
@@ -721,6 +726,7 @@ static int dsa_port_do_vlan_add(struct dsa_port *dp,
 	}
 
 	err = ds->ops->port_vlan_add(ds, port, vlan, extack);
+	trace_dsa_vlan_add_hw(dp, vlan, err);
 	if (err) {
 		kfree(v);
 		goto out;
@@ -745,21 +751,29 @@ static int dsa_port_do_vlan_del(struct dsa_port *dp,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_vlan_del(ds, port, vlan);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_vlan_del(ds, port, vlan);
+		trace_dsa_vlan_del_hw(dp, vlan, err);
+
+		return err;
+	}
 
 	mutex_lock(&dp->vlans_lock);
 
 	v = dsa_vlan_find(&dp->vlans, vlan);
 	if (!v) {
+		trace_dsa_vlan_del_not_found(dp, vlan);
 		err = -ENOENT;
 		goto out;
 	}
 
-	if (!refcount_dec_and_test(&v->refcount))
+	if (!refcount_dec_and_test(&v->refcount)) {
+		trace_dsa_vlan_del_drop(dp, vlan, &v->refcount);
 		goto out;
+	}
 
 	err = ds->ops->port_vlan_del(ds, port, vlan);
+	trace_dsa_vlan_del_hw(dp, vlan, err);
 	if (err) {
 		refcount_set(&v->refcount, 1);
 		goto out;
diff --git a/net/dsa/trace.h b/net/dsa/trace.h
index 42c8bbc7d472..567f29a39707 100644
--- a/net/dsa/trace.h
+++ b/net/dsa/trace.h
@@ -9,7 +9,9 @@
 #define _NET_DSA_TRACE_H
 
 #include <net/dsa.h>
+#include <net/switchdev.h>
 #include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
 #include <linux/refcount.h>
 #include <linux/tracepoint.h>
 
@@ -318,6 +320,122 @@ TRACE_EVENT(dsa_lag_fdb_del_not_found,
 		  __get_str(dev), __entry->addr, __entry->vid, __entry->db_buf)
 );
 
+DECLARE_EVENT_CLASS(dsa_vlan_op_hw,
+
+	TP_PROTO(const struct dsa_port *dp,
+		 const struct switchdev_obj_port_vlan *vlan, int err),
+
+	TP_ARGS(dp, vlan, err),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__field(u16, vid)
+		__field(u16, flags)
+		__field(bool, changed)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		__entry->vid = vlan->vid;
+		__entry->flags = vlan->flags;
+		__entry->changed = vlan->changed;
+		__entry->err = err;
+	),
+
+	TP_printk("%s %s port %d vid %u%s%s%s",
+		  __get_str(dev), __get_str(kind), __entry->port, __entry->vid,
+		  __entry->flags & BRIDGE_VLAN_INFO_PVID ? " pvid" : "",
+		  __entry->flags & BRIDGE_VLAN_INFO_UNTAGGED ? " untagged" : "",
+		  __entry->changed ? " (changed)" : "")
+);
+
+DEFINE_EVENT(dsa_vlan_op_hw, dsa_vlan_add_hw,
+	     TP_PROTO(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan, int err),
+	     TP_ARGS(dp, vlan, err));
+
+DEFINE_EVENT(dsa_vlan_op_hw, dsa_vlan_del_hw,
+	     TP_PROTO(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan, int err),
+	     TP_ARGS(dp, vlan, err));
+
+DECLARE_EVENT_CLASS(dsa_vlan_op_refcount,
+
+	TP_PROTO(const struct dsa_port *dp,
+		 const struct switchdev_obj_port_vlan *vlan,
+		 const refcount_t *refcount),
+
+	TP_ARGS(dp, vlan, refcount),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__field(u16, vid)
+		__field(u16, flags)
+		__field(bool, changed)
+		__field(unsigned int, refcount)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		__entry->vid = vlan->vid;
+		__entry->flags = vlan->flags;
+		__entry->changed = vlan->changed;
+		__entry->refcount = refcount_read(refcount);
+	),
+
+	TP_printk("%s %s port %d vid %u%s%s%s refcount %u",
+		  __get_str(dev), __get_str(kind), __entry->port, __entry->vid,
+		  __entry->flags & BRIDGE_VLAN_INFO_PVID ? " pvid" : "",
+		  __entry->flags & BRIDGE_VLAN_INFO_UNTAGGED ? " untagged" : "",
+		  __entry->changed ? " (changed)" : "", __entry->refcount)
+);
+
+DEFINE_EVENT(dsa_vlan_op_refcount, dsa_vlan_add_bump,
+	     TP_PROTO(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, vlan, refcount));
+
+DEFINE_EVENT(dsa_vlan_op_refcount, dsa_vlan_del_drop,
+	     TP_PROTO(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, vlan, refcount));
+
+TRACE_EVENT(dsa_vlan_del_not_found,
+
+	TP_PROTO(const struct dsa_port *dp,
+		 const struct switchdev_obj_port_vlan *vlan),
+
+	TP_ARGS(dp, vlan),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__field(u16, vid)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		__entry->vid = vlan->vid;
+	),
+
+	TP_printk("%s %s port %d vid %u",
+		  __get_str(dev), __get_str(kind), __entry->port, __entry->vid)
+);
+
 #endif /* _NET_DSA_TRACE_H */
 
 /* We don't want to use include/trace/events */
-- 
2.34.1

