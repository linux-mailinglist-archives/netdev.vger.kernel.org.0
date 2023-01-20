Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388536756D2
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjATOSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjATOSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:18:35 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2078.outbound.protection.outlook.com [40.107.6.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AC1222C2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:18:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzAt/+GOxb9EzZgiMyG9MWLeKCXxxF+zdCYgz9xUUS7K+sJyTYGkhiv9g+1KTUqYs0KA3ovqIHaIk9/14kQsiLSV/JjYT3GntWzgzvAXyEQL3t+dTAZNwRle1azCed89Q8kftL+G8jPzBtuWVVPsU0/7yFgCk/XYx3I+EF46gk0UauAF6As2O6Bi28eBQcPgpScQUtSvzLs+tkT5xcxJETVBD6hXSU+Lva+ekIRsNQ61QKm6e/QD2PxcwLzXQnLQ2b6rS5IJhDG+7UJOEm5OEqfEFpkwJuYTId5xo7nGR4WmIah1GTEZqaqxBJtgkvsTpBPxJkhLYH521qhufZV1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQonjcHEHa4PW/GOOREEtp7tE/9NyOT1EKZlK75ZoLI=;
 b=cMfXbOp+eqxR5YnW3Ignl+6ouBn86VVMMNdFiN8PzJgyLTlQ8Q0K3oFteDhsVmVP6ewTKH6JCRJqjeV4eECq6NWIqNVpkxGHws4n80+Qnd4Io4jox7HsDeNA/oQtEhVlJATTX7b939+Y3PsUVpBK8rGRwjXYphRsOvkTFOxmtTyl0Dqun9ZVfQpQCgHsKTHNkEpWla/o1QqjXXn+DK2586hez68hB43IDKHftPazbyTawxIsIT/8ma+tmFvGNXtC1SZUfdwm6JbXL6qmfoc9kMyzC4vUC2xflZUiAQJ8P79KM9L9hK9iabJvMMe2smzbN7wY+NrWMuP7H0QdhIQskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQonjcHEHa4PW/GOOREEtp7tE/9NyOT1EKZlK75ZoLI=;
 b=PadTrQQRlOmPLcG02eDdthd3HsVuH/mtu45fIUsz+CAJiPALzix/ad7QJAlhMmusYTUpHBWpYqqIslX52HtYqMXNwzMfngbkhdozb85ZHwSUWaPc1R9K+eSklJZQpK+Nb6SPyJ4bfaL25CUqJrzs3lCpbTnJ3ZTnZqT2dyAynW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8837.eurprd04.prod.outlook.com (2603:10a6:10:2e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 14:16:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:16:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 10/11] net/sched: taprio: validate that gate mask does not exceed number of TCs
Date:   Fri, 20 Jan 2023 16:15:36 +0200
Message-Id: <20230120141537.1350744-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8837:EE_
X-MS-Office365-Filtering-Correlation-Id: d61c2243-83ab-4b6b-a115-08dafaf0dc2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylEiOyhdOeGKzuxLBVNh6CjeBfGErATHaUfF1ql+SC6ahYyn2zmf0a3hec/BAkdP4d2J5O4hWp07qM3jnX2DwAxmqgVWgp6uWK8H8R5fbkbCbZbyAb/p8eQR7PK7cS7cd9yzgL7WetoAm0bLgREA0adRUPHewndVGDmRVh5xux1VnPvr92Gwiz99o4lk9OgUzfIFFV0Q92cqfIvWNkfMlSd3Zzp5z5+J83W8VWuvcMIsofQEFGebxpktVRoPbBAh/kbbyHkHcuniBE1y0zD5Rfe7N8xwJ3FW4ts4/q05gdz9QSswqnoAJAv8havAOGQYf2fXGEe1SSmH1I0eiGRlCxjlCMx2N/eb3LfMn1g6FQdKkaO6WRoL6IGkAe7VYABy1zUEud2Az1xgQwz4iptnM40QKj/NF/jSG0gEKmhQleHpNJDm1baC1aAP6/hvO6zosYw2VSYsTcnzBgxb791ri+o6naGjI6cmmTTjjbW6gglqdLrhyPU63kQ1xo0OjI1wDWOIX2S1AKhIbQmZu+RpUj1kpQCNYnjJn9o0vGIp14sJRsncGyQEPkIUTKZ0iUwsqZRsHJCdK3SqhYiS6WgS7C05RJ3M/SVOPpZp0e56OqnruzCJ0u/0cytFwn4XxUM2uJqNlJ5qP0utrzJ1bYWDeOeIgqdr8VKDgRzULBayIIaJIZL01d/VlhAQ+0v5XDfXcteRb96QmYW6sEbKp2UbSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(86362001)(44832011)(8936002)(7416002)(5660300002)(41300700001)(38100700002)(54906003)(38350700002)(36756003)(478600001)(52116002)(6512007)(83380400001)(6666004)(186003)(6506007)(26005)(4326008)(66556008)(316002)(66946007)(66476007)(8676002)(1076003)(6916009)(2616005)(2906002)(15650500001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jmBHfvt8ggEqmud8Zz+JFWK3ivLrwgt3LIR/UA0+9faSR+IzR3TkqZ5WA5YO?=
 =?us-ascii?Q?CjojNS0KuMyz//YFsZTJrEgf7camnYD3/h4+MlSAzunefrb21tH5ZF2F1M0w?=
 =?us-ascii?Q?VfHAEiOde5ay6BX5lrzkem3Abbu3WIA3FKrsAPA3Yjgr/24abGAu04GhM+Ln?=
 =?us-ascii?Q?Vg1hNDc41o70DY8ldoS/lhDjliB/5BLOnDA0S3g7MDpIOYarqeFqtsPuXB+F?=
 =?us-ascii?Q?p9EC1KsoOBS/PoFNzU9dqxRIENiMd/FaLzWZk8ZTI4W4VYqjdVki4ewQPHvW?=
 =?us-ascii?Q?GHzU6FvqlNM64cgUVS6+GLk8oR73RNMRhm4J+i3YLKdKb890mF2NplZnTijB?=
 =?us-ascii?Q?68h4N9MByKXvKFMdyXdM6ltpFL21K0joEbNOXzty/nXSYX9iRnoIvfaxQlXL?=
 =?us-ascii?Q?r/p8Bo50pDn/ZzgQV6h8dbKNoXQEibMaNk3uuv6rpRUOA/axyHQXD71pTgd5?=
 =?us-ascii?Q?VkWPhfzmFU0GgzzZQuOXwHQS9SFFvsVdMmDOoj5F8GemmrKpOQRQ/X7sMezM?=
 =?us-ascii?Q?qXKYi/jwxcEK/9qN8muorD68K3BNKQP2Bihzq/EUHcs0UiUZ1K2Xu8MjF1Nd?=
 =?us-ascii?Q?67oVR/F+e0QVAslHFjz5mnEYhVq7FGuRpJWLy2hwYV1oDYvtLxwOAlN+sqIg?=
 =?us-ascii?Q?zs1phjIkCmxAUFwe1LaytFm71zILigsVqZ+E+bn8+KvcKp4lacI1LoZKm4X6?=
 =?us-ascii?Q?YmkvXlxKjT7KRFbmZP0pMg+v7HHlzbmUgM6PRK+XyVrsMfo6lpvtW9QAeI9k?=
 =?us-ascii?Q?ur1oEKU8i2OnG4OSNe7GcPrYL022W048tYpr5ufrAX/vnGhabGzDUBEFzmHg?=
 =?us-ascii?Q?AqWkLEuc+/Opu/xJV4qhRz7G6x3aRiEWmvuvuyzfStKZZS3G+2PRnVGMrJ2o?=
 =?us-ascii?Q?NQeuSUBZXZGrSiPg1Cu/xT5DzDoaMotLm/2WYHwkzwGJgsslKS1OzCpX6uJn?=
 =?us-ascii?Q?YzVrfXA6nr1wUkKonyuFv6TJiOneQlpHNXpPQdne2cXrCRKvnpEL1iUqRI0K?=
 =?us-ascii?Q?z/80ukKWpNVdMCXMgJtD0wazijLtmrnHBd4WbkcMbcRGn8gPzAViMxRNwL7N?=
 =?us-ascii?Q?aIoeDFrJ0icgTBdx1TIl4Gzj7h4pSMI570jtVkcKnEmul+tDguWzXo2Tea2j?=
 =?us-ascii?Q?ms++IctKXUhionLWiMjx6CHqAoRyK52GQtadVDzCf735xj/D4LV1/Fd1DgNC?=
 =?us-ascii?Q?iyaxBfkocu+j9SYS2Rwod9dmriEllO2bqmqOYWwrczxjRsuV7/sIA4DluBIi?=
 =?us-ascii?Q?YxgY5aXpnbq1WaPZwgBtGQGWU+ghU8kFp9lfTJVcPPWGqQXMA98eACUft8+h?=
 =?us-ascii?Q?7erLN8x3xXpC/ujdM4P8LwoR1Lv+NTV6pnUSmgFlrhcKvsKeuoUx/dgtS8rO?=
 =?us-ascii?Q?Gzhcog/P09Xrq2yra10qoKf7qdJRolsP1icj1X/AyzhPfWPHODn5cMbUS5UE?=
 =?us-ascii?Q?48kAXGfPIvwAAuGwTZdN6BrcXmTrIGOu/ngK3ZMJUnv/tWxVFH0D2JBYpSr7?=
 =?us-ascii?Q?mgSA0/VZ7kCv1t5hmxw0L5ybuOjb2VfgIpveH9EzOxiXqTGaZKdU9XZrQnRs?=
 =?us-ascii?Q?pvSqjCldHkbdDfJBBbjaN0TKUWMGrmW4igUTn+HzKMfvrMCuSfaoJIhWYU7Y?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61c2243-83ab-4b6b-a115-08dafaf0dc2c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:16:02.1384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7/q8/OqUf06BikWIRf7fE80EIGSJ+ShIh7aoj+gB76Ge6a6Y+cMyv/iTOdU7W/QCGZmaQ9r3jnoQJ+LqiwIjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8837
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"man tc-taprio" says:

| each gate state allows outgoing traffic for a subset (potentially
| empty) of traffic classes.

So it makes sense to not allow gate actions to have bits set for traffic
classes that exceed the number of TCs of the device (according to the
mqprio configuration). Validate precisely that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8f832fa82745..a3fa5debe513 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -789,15 +789,24 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct netlink_ext_ack *extack)
 {
 	int min_duration = length_to_duration(q, ETH_ZLEN);
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
 
-	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK])
+	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]) {
 		entry->gate_mask = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]);
+		if (!num_tc || (entry->gate_mask & ~GENMASK(num_tc - 1, 0))) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Gate mask 0x%x contains bits for non-existent traffic classes (device has %d)",
+					   entry->gate_mask, num_tc);
+			return -EINVAL;
+		}
+	}
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL])
 		interval = nla_get_u32(
@@ -1588,6 +1597,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	if (mqprio) {
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
+		for (i = 0; i < mqprio->num_tc; i++)
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1604,21 +1628,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
-	if (mqprio) {
-		err = netdev_set_num_tc(dev, mqprio->num_tc);
-		if (err)
-			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, mqprio, extack);
 	else
-- 
2.34.1

