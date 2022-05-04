Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4951B3DF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbiEEADj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350608AbiEDX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:36 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85A151E7F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:55:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHk/NKyjJOzFM73S5osGO/GoUQwH/smsTFRUpsnGs4MP82WpHOLxB4aDa5Guy35Ndr70GTLT0mS/SJRw1sXAao5SomY+TS/BBy+kQnhVoMvGZwlTtuXm+wnnuzzwQAtUV7FXPulhlHwkpgcW0di2/Dc1zfJMzzDdOk7WlEmT2NFnRhhjCX5ghfgbB2hQtPQwY6a0OSNvvciUXK3QmER5mc1lBJ4Oq7hxgdKME+ifGP4EEP7RvLKvgaU+Kg7A1Y+u6PKYGaHQ26HBTXXluM4eHWKFTP8c3wkHFHKY801/vhAPNUG4sorfVTp8Alcq2mrBLmrDid57npNpxMFliS90Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjqxtEFjOgN7uBYD7Gqxix/SIu/dRcxeriyWZYdTtJU=;
 b=g8mJpiBaAs7UhNsF+5YtIzzZE9oWx4ZcpBFHBFfJ7KVfgPsZ8miVw5Y4M4c75H9vsjLWEYXRz96grRwAmRf1ArJ4MSa7srxLxu3YF4I8OpoqWWwnxn/U4reV3h3hqpXPvQJYfTmNmymVTMapDIhuzw750uBLh9sVZ8NPP6afPEsbzE2vb09OeOyGHl7OXacgduwHH8ehMNZ978qpN0ohEhObZ5vMfn2pubjNUC2CZ8KTQRTa5gB1mpQXNFwJ4T8sJZ48Q52BzaoXLfyEvHmtfViksoSBE1qLkpMz4Vd4Mx79A3WYCp5gwAgM4yTyHk5ocDMaGU9JBxgNkxn05iNz6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjqxtEFjOgN7uBYD7Gqxix/SIu/dRcxeriyWZYdTtJU=;
 b=jK87jV1lMaIbngvRlXU8oF7KFq/ezP08vJKYhwhu6SMpWUuza6rrqUOHjGawcaNpsgGNEknuj7wx4FMaRdaVrG94o1/2t3ngoe5Z7m7mFVspJkiTIbn5diKVAu/IYpjUPBfCneWguzAQLexzD5cLxN/VT4mfJ+QKVJQLVIrRxy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH v2 net 1/5] net: mscc: ocelot: mark traps with a bool instead of keeping them in a list
Date:   Thu,  5 May 2022 02:54:59 +0300
Message-Id: <20220504235503.4161890-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
References: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0227.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98b74e6a-9ab1-4a64-8c55-08da2e299e5b
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4683AA848FA08343D849B491E0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1C5vZJRm3td5rKGv0657PKV8JzWSBVYpqFeR8HpW90jdC5MPuIvg8zlX/JVuAT+6VSlqYcEubOoS6ePg8X/Cvl8ALH2Sgwtjk/7px4Aa87lsuMMP8FnMyw5EPTe3Fwt44w6ESrGzB43LNlHo8/jjgADcxmqQNlPpqZCdgBdHqEJfvKJSKtcWNUC+zoe0PcbbJ9NwIxHGV5QaPvDdqr3pU7ODpEFJIwyDGBotcS8ROkubaAl4Sjty6o++bj/aVwlQ4ls8BFbLswZknoasG6opSYP3BhE3TMLMeCn1f4JQvovU/lJ9P5LxCPCvE+Jzu70X1a1wuFUGAVKB+kvlCS36IOM6MAfF2tTFt5gHavKlixMNRBq+EyjlnQgmkCIkltmcyS0PUC273O3Q9hp/Z1rpyPJoX7vWZDa++YfZVt+u/WJLOisSdWkMUTnxCQtm25Za1f4ADVFjRp8suWiFaiC02az5R6Q5yT6pV/I+Uj2srpfnoX05XW3ssBV8WaZaNmlSJcc0VfHyT8u0H6V9N0QKAqbZJ0FdH8gYQAsZKzede6e42P9qzf0/3Prph/fi3KEZm3Nv3SkXMn7PIKfRPoYRvweQtv0xS5tGyF6z/k7Ki7FH/uwfsdroc6AbnAI692fyPUApQoH/eBKpNVl/DGOzv1QqFQtkcrMDi7LgpiflorvJBQ5a6ciuX23ktAUBXEO4PcVuLLHZnwjxn3B9zoqkTWNMfv3I+siCOrsaSh5A4En9N959lnq/wGTdVMHGrzqun+gCBFwpjyUOwSHU3SSITud22FVBEy1JefHiW9rmoJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(2906002)(7416002)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1P04TVhgoFKwSVywCGW1Hn9gG0htkT170XQvGmpeadtPA7pmzROp7/GfKqww?=
 =?us-ascii?Q?pRcH2uNwlGvf40VOC0Qjv3q7jRUBkz5+Jc709scps/wJMk+t2vR/X7GtDZAB?=
 =?us-ascii?Q?aYCqZQ2aWPJAhVzk3Qmu1Erf9ZwxG4zY14Ukbi9tmXJ86gr5FRh4OdASoSPd?=
 =?us-ascii?Q?T6GsGge0us37m5UTL8ZlVHtW6mcM1Jy+Jb4lK/EQOIljiGKjBMJOSHXufv98?=
 =?us-ascii?Q?MiXVq7GgkMxWnvoaUuPuMpMO+CxGK5UVBcQHsfDgeQf2fJDKgleXHl50do9e?=
 =?us-ascii?Q?nV/v5yioI4safUnfJyMm6yzM0qL4jW7XWf9vamNTZyrB6LMYheg0ywTaMCly?=
 =?us-ascii?Q?tNLpQvpMYafcwQdFtJjw/fIaNpn2pRKW8opEnl6j4jr8LKyQj2zc9YWwfZfj?=
 =?us-ascii?Q?45Ky36ltD1NZTTwyz2Un9nM5NPDYsoq4wThlqp0LvKfN+M/FroJ8eGnyEK4B?=
 =?us-ascii?Q?FM0WLz9riCBz8mz4u8k8Kz6+YdXLhZJWiq8Z5ugy8yE6HqBbWAzgypF5a03o?=
 =?us-ascii?Q?SWNGvZxVMMKiFqCrO60kZome5ShTjxrJ86s80UGnQgmT8daCxcmCCa9v/xOx?=
 =?us-ascii?Q?kEmwsJIWWS2/I9YISZQ+Lk1QUDmOtYbwe0ocaOx4sMPkdJih8NAGdB512ypn?=
 =?us-ascii?Q?YLzIWSgdxf8E8jALOOOrT8GXjv2Y73D+AD2NdbcBHVrhlbK5yriO7xyK81Y/?=
 =?us-ascii?Q?YzS0ni+VzzZnHZT+ADCJe0l5pNCn6vCr5mbmcP9clloudhogFOQYLJT/nl9h?=
 =?us-ascii?Q?A2m9OBthPqGx3deJ70HsEZ+ZX15sPWUKKoqcMZo8ADL4vPEtm7DKaXVUNriM?=
 =?us-ascii?Q?k68ZykkRbNmwOFI4CpsjVRmHIUOI2SBChqygfS/nNtuTVyYK9ygnQZEHqsUb?=
 =?us-ascii?Q?XMxPduiaxTR76IEMLxDkvY1m09WUDECs9DaQxyvI2qx7VC7LAHHnv7lYTeI7?=
 =?us-ascii?Q?U08vyJ2TbAqRXJC/dL9vFmVNB2VQtjAl78CW9ddfmhq7eqFSOG9wYhDPY4zU?=
 =?us-ascii?Q?g5JINHKOvs3Mu1KSXilE/Tgnyv6tylXN5ItFAAWF6R1B8Q/hMvgWFz8AtvO5?=
 =?us-ascii?Q?4YpzCAn6ttJ9rP4kB4hI/xvA+4is0ob4uu6ZCwhN7yD1HxZOTM4TztmKdUJ9?=
 =?us-ascii?Q?KB5zblUrSkm9PowtzqSN3sblCpukOeRInB2XTIGfoXehIKFl8iqJteq6DDZl?=
 =?us-ascii?Q?fc+zwzaafsyi1FmGlZYGdX1R2QdZtIqRAGzlqI+Duyn+DulR+zZR3vWlrcmK?=
 =?us-ascii?Q?mrBw+lOZTOudV9ysHt9gh/rJCxT3CfFyu/XME6Gxc9tfQPTUJA+YbnfWqARs?=
 =?us-ascii?Q?4PwFm0JTo6ypSl+Ygiv1We98uiuD2bwRH5Jbdtwo93bcJpVV7qx4CoF57hsN?=
 =?us-ascii?Q?2vMqKB1wBzBHxQO/hqHR1N7sfHxZym6mWD841PxP39V7GczozTEtglrfhBbv?=
 =?us-ascii?Q?5qAbecwkq1fGQRGLfWK4rNtjuonZMq6zgJ7CPmXJUewfR4R+VUWWvi288qN7?=
 =?us-ascii?Q?oG7T+Ae/95yfUdfpTN0Ft6hOGLEPrC5AEIhpe8zTvDZ8NqACMP9cKwxgr9EQ?=
 =?us-ascii?Q?mz3rZP5ZRMuv27a/zWm0xS1CLwYvKO+JXAuFy0DQu1uabvtSx6jEhthswf7V?=
 =?us-ascii?Q?nLVd+Ez8nPZQyPyrHVdD7CrnRN8zvfWRrAVjhiUARMv/iyPvFSaSPBkao4zz?=
 =?us-ascii?Q?FIIOa6AzWetBMO+Uf7msc2REWdZ/zGr0ZORhrgPTwh0F/4iaRZ126MSs2RB8?=
 =?us-ascii?Q?8tr9yNGtAb/Ekmo/ytqgm9zjMqOp1/w=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b74e6a-9ab1-4a64-8c55-08da2e299e5b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:51.3870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ry6eP0vbkaVwYn/k6xDIcUMDPFysZdOTQ2iXFA8hR0ST9+9y6odhU76z/nliUr6dbzL+oLPMClpNyQtl/m8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit, VCAP filters can appear on more than one list.
If their action is "trap", they are chained on ocelot->traps via
filter->trap_list. This is in addition to their normal placement on the
VCAP block->rules list head.

Therefore, when we free a VCAP filter, we must remove it from all lists
it is a member of, including ocelot->traps.

There are at least 2 bugs which are direct consequences of this design
decision.

First is the incorrect usage of list_empty(), meant to denote whether
"filter" is chained into ocelot->traps via filter->trap_list.
This does not do the correct thing, because list_empty() checks whether
"head->next == head", but in our case, head->next == head->prev == NULL.
So we dereference NULL pointers and die when we call list_del().

Second is the fact that not all places that should remove the filter
from ocelot->traps do so. One example is ocelot_vcap_block_remove_filter(),
which is where we have the main kfree(filter). By keeping freed filters
in ocelot->traps we end up in a use-after-free in
felix_update_trapping_destinations().

Attempting to fix all the buggy patterns is a whack-a-mole game which
makes the driver unmaintainable. Actually this is what the previous
patch version attempted to do:
https://patchwork.kernel.org/project/netdevbpf/patch/20220503115728.834457-3-vladimir.oltean@nxp.com/

but it introduced another set of bugs, because there are other places in
which create VCAP filters, not just ocelot_vcap_filter_create():

- ocelot_trap_add()
- felix_tag_8021q_vlan_add_rx()
- felix_tag_8021q_vlan_add_tx()

Relying on the convention that all those code paths must call
INIT_LIST_HEAD(&filter->trap_list) is not going to scale.

So let's do what should have been done in the first place and keep a
bool in struct ocelot_vcap_filter which denotes whether we are looking
at a trapping rule or not. Iterating now happens over the main VCAP IS2
block->rules. The advantage is that we no longer risk having stale
references to a freed filter, since it is only present in that list.

Fixes: e42bd4ed09aa ("net: mscc: ocelot: keep traps in a list")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new, replaces previous patches 1/6 and 2/6

 drivers/net/dsa/ocelot/felix.c            |  7 ++++++-
 drivers/net/ethernet/mscc/ocelot.c        | 11 +++--------
 drivers/net/ethernet/mscc/ocelot_flower.c |  4 +---
 include/soc/mscc/ocelot_vcap.h            |  2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 33cb124ca912..a1b6c2df96c2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -403,6 +403,7 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
+	struct ocelot_vcap_block *block_vcap_is2;
 	struct ocelot_vcap_filter *trap;
 	enum ocelot_mask_mode mask_mode;
 	unsigned long port_mask;
@@ -422,9 +423,13 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	/* We are sure that "cpu" was found, otherwise
 	 * dsa_tree_setup_default_cpu() would have failed earlier.
 	 */
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
 
 	/* Make sure all traps are set up for that destination */
-	list_for_each_entry(trap, &ocelot->traps, trap_list) {
+	list_for_each_entry(trap, &block_vcap_is2->rules, list) {
+		if (!trap->is_trap)
+			continue;
+
 		/* Figure out the current trapping destination */
 		if (using_tag_8021q) {
 			/* Redirect to the tag_8021q CPU port. If timestamps
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0825a92599a5..880dee767d96 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1622,7 +1622,7 @@ int ocelot_trap_add(struct ocelot *ocelot, int port,
 		trap->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 		trap->action.port_mask = 0;
 		trap->take_ts = take_ts;
-		list_add_tail(&trap->trap_list, &ocelot->traps);
+		trap->is_trap = true;
 		new = true;
 	}
 
@@ -1634,10 +1634,8 @@ int ocelot_trap_add(struct ocelot *ocelot, int port,
 		err = ocelot_vcap_filter_replace(ocelot, trap);
 	if (err) {
 		trap->ingress_port_mask &= ~BIT(port);
-		if (!trap->ingress_port_mask) {
-			list_del(&trap->trap_list);
+		if (!trap->ingress_port_mask)
 			kfree(trap);
-		}
 		return err;
 	}
 
@@ -1657,11 +1655,8 @@ int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie)
 		return 0;
 
 	trap->ingress_port_mask &= ~BIT(port);
-	if (!trap->ingress_port_mask) {
-		list_del(&trap->trap_list);
-
+	if (!trap->ingress_port_mask)
 		return ocelot_vcap_filter_del(ocelot, trap);
-	}
 
 	return ocelot_vcap_filter_replace(ocelot, trap);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 03b5e59d033e..a9b26b3002be 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -295,7 +295,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.cpu_copy_ena = true;
 			filter->action.cpu_qu_num = 0;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
-			list_add_tail(&filter->trap_list, &ocelot->traps);
+			filter->is_trap = true;
 			break;
 		case FLOW_ACTION_POLICE:
 			if (filter->block_id == PSFP_BLOCK_ID) {
@@ -878,8 +878,6 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 
 	ret = ocelot_flower_parse(ocelot, port, ingress, f, filter);
 	if (ret) {
-		if (!list_empty(&filter->trap_list))
-			list_del(&filter->trap_list);
 		kfree(filter);
 		return ret;
 	}
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 7b2bf9b1fe69..de26c992f821 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -681,7 +681,6 @@ struct ocelot_vcap_id {
 
 struct ocelot_vcap_filter {
 	struct list_head list;
-	struct list_head trap_list;
 
 	enum ocelot_vcap_filter_type type;
 	int block_id;
@@ -695,6 +694,7 @@ struct ocelot_vcap_filter {
 	struct ocelot_vcap_stats stats;
 	/* For VCAP IS1 and IS2 */
 	bool take_ts;
+	bool is_trap;
 	unsigned long ingress_port_mask;
 	/* For VCAP ES0 */
 	struct ocelot_vcap_port ingress_port;
-- 
2.25.1

