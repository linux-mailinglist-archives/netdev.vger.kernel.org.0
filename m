Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B635987E8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343957AbiHRPti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343989AbiHRPtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106195F59
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIvuO86T8z2tf2dRmbVFitISyKi7HxaV7erPtPrNzsZHeJCCFl/GHr66NA5yJ4f32+lwQjXVBHok1KevDpMNBf7g6tzfYlTY+o9gI2YyTQrUsNBuJ0bU9iJItmteqauEuPRDWFTqnYHrXV+9uvG5DHr25HXk8bsD5QUubuAJ1uOoullSEeVf1TZXNOsgfhv9XYpfifwvska8OagcmTA2NgYEWdHGU1C+I0y4NICIb/NxCMSBUoaZUeXmE8wvIOtLl6EuQe1613FVEw3DfGAlYfwZbVdK4c4ZUGpIbdyefEl8TowfTnidnI9Pr5pO+s+C2w+mX5HzqQrplwmi/hy+Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CY8ZlRJNQG/Sf5X7qNqSbRAEZ2RElcut/fdKB3VhaM=;
 b=YzSNiVNNUxJpXLljl5agFuxE1Wh+KvIObim0MdGvg+b/3bMRo009NgOSDH6CIPBAw3oLqrZHAKINWwWVb8DuFUzALVNIBg443ORYCobcEnt0JX8s7n3r89JJbjiuGbNCBq4/RnvJ0/pbJiTi9+Xqxd2Bij5yKdCb+2byOZIpazqU0VUIR/Y/+Imr0FTwx2BlrKZ7tw79coYSNeHLXT93Q4kNOGFa7N4HVBVQO2LHl6zyTlqd6am+8kwGq9MUpJddn9WUikTTK8BY7LXVrBYPYL1KyIBzM3+tfIREFMypWPt9aWT4nmP/xDTkSU2dWbVNqh5EcizJEwSK480Zd/9IIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CY8ZlRJNQG/Sf5X7qNqSbRAEZ2RElcut/fdKB3VhaM=;
 b=a4Ah2lL5D4eFxFRkUA6tOQgDuPJL1/YsZM5z6c8JlRmZAmmnX0QyBPuJiuoM6F9jFPX0oLvAldS02qX3jjAfdOjFTF7W5+txXfe9dVoNPfSaysrqEgE/we/ttLAJp2qt93QqgucZZmGz1BvtgeNV723K0gZ7DCuZJclyLUBAtWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5648.eurprd04.prod.outlook.com (2603:10a6:803:e5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:49:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:29 +0000
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
Subject: [RFC PATCH net-next 02/10] net: dsa: introduce and use robust form of dsa_tree_notify()
Date:   Thu, 18 Aug 2022 18:49:03 +0300
Message-Id: <20220818154911.2973417-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: cc9e9010-6648-4bfc-2fcb-08da81313beb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5648:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yatEnFf/jAKeEYia8dRNUOHBlU34/paQ5tc2HU/4NFCX2L1gH8Wnoz4BG0MnNVPe0Cx+0HHkQg0PumpP3f3qdtpbEtPCpAWSTKRtJQ3QBW6pPfUVBQ9aEin1yBxWu6Xgt6RjZf3/W/M5PY/nL+wLEzAz6D7sLXje9BSuNZ7Rjr+aNi9S7CpW44rYsFHp/5BQsELFRluOfLNXPRKiWm18rB7AMxv613WGcSaWg6UAW5uS+Sph9eTQS0zZpctgz0oeQXmzclVDaQRxtN1m6inUFWTsVspmk14febwR6MIduSEabMGh12NcdGentab2y/KW/C6g2T4/slm41BCIDqaK3e0dOH5fjCo+mHJKYxyFItmIjrLjiP4HO6RFIieqMUV1wFukTmJ2/V5dK9QOaXPkueRdmslQis9hKkW8MzncqzoH2kLzBrCCIaF1K6dqdvaYqEI9fTOJhVOU8JjsNCvPVFLjpi5NKln2wPLgTPXHL/0JgJgBU9dQuDv5ARdK90vXKiDgXMMvZdfDirFuz/COZaFmFhvF731DWbpW+A0o3tC1Wl+eCjWzPffr7H8LZDpWTOW20CkVccDttRM2hjbvqPN9njchvCKb9mdJvECfX3dwswzM35WffHNAp0LFEFWQP3ZyH+fse+x+C7+t1Ff4LB3/ufwphoCUITVVAQnJxTS77JqkX9kYgce1f9NKgtuV7jwck1io6Qj1Lk9T7daSSCRp4iHwCgCObeH/k7Lc9ZkJzzqhJQAlxKqq7xuT4GOz8PHVFCts9xu+YIKF7UAzaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6486002)(478600001)(38100700002)(38350700002)(83380400001)(6666004)(186003)(2616005)(1076003)(7416002)(5660300002)(44832011)(36756003)(6506007)(52116002)(2906002)(86362001)(41300700001)(6916009)(66476007)(4326008)(66556008)(66946007)(8676002)(316002)(8936002)(54906003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q51+/WRvGvaxRowswpnAieszeC+60DUpG64T2leiEMHUhPXbTuRvLSgF8bj1?=
 =?us-ascii?Q?+YED0LvYp79oA6rQn1O+0K9XKUIOJ6G6DV/ViCV15eYYk/+MfQpeiQawMlUX?=
 =?us-ascii?Q?zRsOJ8Wy2gwa/KDxG5r2Y/4nYM+nM3YktniIr0ou4QwYg13/X85DAsBI7WKS?=
 =?us-ascii?Q?LNL4NUVYasWGudU4fUjS2CBhOh4O5Csj8BjFPgHG9u3HrbAO7yo5+BkdH625?=
 =?us-ascii?Q?QOn7MU9P4xyFMzzBK2/PbjDwZS+sUmNi2ESf4Hpq4PVrMwT6XwqvYZymKlWT?=
 =?us-ascii?Q?QQCR8GcS8bdhxdg0gbTfOnDxa4jISKGpQAvEiPokT+C/jfre9gtM92fAuCAT?=
 =?us-ascii?Q?aXiT7I1nSGUl+AUyezPThPukYk0sn3oGeiZWYjztVP9HjSuBxx34B5x313EK?=
 =?us-ascii?Q?V7ajeGrXG2CN7U/dF//2w31b8gj+4RBvjooNDTb0snK7SN3g+okohNvG/MuE?=
 =?us-ascii?Q?qUV1SrtatfTmSY5oLppJ1NgDbJfBnEaboA5g9Fq2+IHbooF9Hn53LJ6bEg9U?=
 =?us-ascii?Q?dtUrVQlR53nFfBZLYU5r7H6M0zAe9AWNJ5ENH3EbzOX/LP1uF1BY/QdYufEU?=
 =?us-ascii?Q?z+71t+tn6aCKJbto2C8s/j0E8wK+AwkUYAgpT0ji9hJY9J4vDWGDiBhCIin2?=
 =?us-ascii?Q?IvqeEzsc4MEJSLaUpWkPyKG2FecZXz/OO0L9B0i0d7gQV2TmI/FavqUEtfP5?=
 =?us-ascii?Q?ShBiSYXuE76PsJhud9S84A34rPU0KnTEMtSQpAL86QrAYysRu0zeJLDKr8t7?=
 =?us-ascii?Q?R+KMiJY3CvMBL5qVFqNyrrSmiqasXJLZEDZ19ov6n4rCY0VpXqO+dwjnryBj?=
 =?us-ascii?Q?oh4EWAT5MrXVU0gw9keMhUkNyUUTp/Xj0Mga7SgizKKg7us8P/gw8s5gtqOh?=
 =?us-ascii?Q?JcVDcUePOO2adCCD50EaI+mncEPCBWli/mLNVLkISVjeCpXbWkXW+yLICsEX?=
 =?us-ascii?Q?Wt3N78LE57JyAYvnc3u4YToSiZaRRl4Y2Vgf1u0oh6th7gx81CndfB/MAB50?=
 =?us-ascii?Q?+E1pxyd9lXucO7IELz4kjLnKnwPnjLb0bPXVD7tdcaWtu7GDG8GW3EQ3usT0?=
 =?us-ascii?Q?828uklTv/GqtcBkHKkxrR32nLVDke3GoTXKAmCyW2Q9hrmTVtHV3oKAFsrUE?=
 =?us-ascii?Q?b+VhRSzPLP4UsDE4NfopyEJ1TjF4bPdi/pISlM931Xz3FOEjMa0k1dkZkCoE?=
 =?us-ascii?Q?s+jWKT1e4Bc3/RiN6YhQsfcWop7rrmOtuf28lz9Ux7DAJROv1QeAhz4zaBxZ?=
 =?us-ascii?Q?ijkAs6dfP//QqppcTzwe8kdnCCp0o33SlVlC20cuSJJsD3rS0Ql6IFEFmzh5?=
 =?us-ascii?Q?gqFUWfBLmTE6AeZtOMjtZmrper3StpYipPSnYmGE1hjLaTNovq2f4Cbuiw6y?=
 =?us-ascii?Q?XlCqZTgBOy5fe9kU2Eq+wDv2ADnvhfkVbNw8FTl+SOit3BT6dusfjpEaB36A?=
 =?us-ascii?Q?V5zNfmGpdL5k9XAwCFekubv60PRMEEZdhZfFVQ74Xt4Nc/LU28vd7m7fIpGx?=
 =?us-ascii?Q?Ap1YOdLMSNeNzD4rSSI5VUDo8SejBd8C0Lrk0ruwyc4upOj7+5CWllniWqtA?=
 =?us-ascii?Q?sphaqPj8YQAIOnkbpWqJ0whtbK7Fa9V6ck+GxeIE3V4fai0DbUR5w8WlYqCc?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9e9010-6648-4bfc-2fcb-08da81313beb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:28.6402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWU0DotmA+i+yLWSVyoNxHzobKH+yVJLHLkxizEgG2C6zSPFRvsVoH2QTrGTLazZNpsWoiqffeFICxpW8efyMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cross-chip notifier chains being broken mid-way by a switch returning an
error is a recurring problem, and some callers of dsa_tree_notify() and
derivatives (dsa_port_notify, dsa_broadcast) deal with this more
gracefully than others.

Not dealing gracefully means not doing anything (and letting the tree
have an inconsistent state), while dealing "gracefully" means emitting
one more notifier which contains the old state. However, even this has
its own potential problems, since in some cases, switch drivers do not
expect to receive a call that requests a state change to their existing
state - see commit 0c4e31c0722a ("net: dsa: felix: suppress non-changes
to the tagging protocol").

The right thing would be to roll back the switches that succeeded,
and leave the one that failed, and the ones where the notifier did not
execute, alone. This is achieved using dsa_tree_notify_robust().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     | 56 +++++++++++++++++++++++++++++-----------------
 net/dsa/dsa_priv.h |  2 ++
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..50b87419342f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -46,6 +46,28 @@ int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
 	return notifier_to_errno(err);
 }
 
+/**
+ * dsa_tree_notify_robust - Run code for all switches in a tree, with rollback.
+ * @dst: collection of struct dsa_switch devices to notify.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ * @e_rollback: event, must be of type DSA_NOTIFIER_*
+ * @v_rollback: event-specific value.
+ *
+ * Like dsa_tree_notify(), except makes sure that switches are restored to the
+ * previous state in case the notifier call chain fails mid way.
+ */
+int dsa_tree_notify_robust(struct dsa_switch_tree *dst, unsigned long e,
+			   void *v, unsigned long e_rollback, void *v_rollback)
+{
+	struct raw_notifier_head *nh = &dst->nh;
+	int err;
+
+	err = raw_notifier_call_chain_robust(nh, e, e_rollback, v, v_rollback);
+
+	return notifier_to_errno(err);
+}
+
 /**
  * dsa_broadcast - Notify all DSA trees in the system.
  * @e: event, must be of type DSA_NOTIFIER_*
@@ -1215,22 +1237,18 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
 	 * to the new tagger
 	 */
 	info.tag_ops = tag_ops;
-	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info);
-	if (err && err != -EOPNOTSUPP)
-		goto out_disconnect;
+	err = dsa_tree_notify_robust(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info,
+				     DSA_NOTIFIER_TAG_PROTO_DISCONNECT, &info);
+	if (err && err != -EOPNOTSUPP) {
+		dst->tag_ops = old_tag_ops;
+		return err;
+	}
 
 	/* Notify the old tagger about the disconnection from this tree */
 	info.tag_ops = old_tag_ops;
 	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DISCONNECT, &info);
 
 	return 0;
-
-out_disconnect:
-	info.tag_ops = tag_ops;
-	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DISCONNECT, &info);
-	dst->tag_ops = old_tag_ops;
-
-	return err;
 }
 
 /* Since the dsa/tagging sysfs device attribute is per master, the assumption
@@ -1242,7 +1260,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops)
 {
-	struct dsa_notifier_tag_proto_info info;
+	struct dsa_notifier_tag_proto_info info, old_info;
 	struct dsa_port *dp;
 	int err = -EBUSY;
 
@@ -1267,23 +1285,19 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 
 	/* Notify the tag protocol change */
 	info.tag_ops = tag_ops;
-	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
+	old_info.tag_ops = old_tag_ops;
+	err = dsa_tree_notify_robust(dst, DSA_NOTIFIER_TAG_PROTO, &info,
+				     DSA_NOTIFIER_TAG_PROTO, &old_info);
 	if (err)
-		goto out_unwind_tagger;
+		goto out_unlock;
 
 	err = dsa_tree_bind_tag_proto(dst, tag_ops);
 	if (err)
-		goto out_unwind_tagger;
-
-	rtnl_unlock();
+		dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &old_info);
 
-	return 0;
-
-out_unwind_tagger:
-	info.tag_ops = old_tag_ops;
-	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 out_unlock:
 	rtnl_unlock();
+
 	return err;
 }
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..9db660aeee93 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -543,6 +543,8 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 				  const struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
+int dsa_tree_notify_robust(struct dsa_switch_tree *dst, unsigned long e,
+			   void *v, unsigned long e_rollback, void *v_rollback);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
-- 
2.34.1

