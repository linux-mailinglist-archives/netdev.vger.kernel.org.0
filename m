Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EC4B8B7D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiBPOd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiBPOdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:25 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5121375AA
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N86Y+ltP5+1rp2+2LrXF/W7WBmgdAGN/DzsKq7KoeENEwSd4I/PtaGdeuR4JJsWSyvB1h726DmSLdFt55FTF3o0OkWbFNsLhv9ElTxOUAcYr6LQ7IDC9cuqDkonVFZ/D2EKpNKqgraGHD8Zs2RjYBsBd00h/U1NQ43yJZCWlBBXLEzVJhvx/k2S3nH0Zxy0WH/t2Q4Lqw80rkIvtqFInv0Z7phX5XfScApiQsOT91SR1fK1hc9nttH50WoAUmiM0RHCyZZhjFgGnV+cNuikNbFO+gEraUV+k3NbE9E5f+ZjmKMOvh0wb9mHmm29eziie8FSvyH5fyLeYf4bb/BHAMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TyLtHrPksUcqKugix3IvywS31xQ7wMViEvg24m8wO8=;
 b=DPhhaL22jj+gSk9DniTtssTtWYWrO0KiXAFhPAH0hmf4CM6hFvnss6Ku6dAgDGiA5GDwYEjENgT2bnhErIgODvI9tfEmoKdK6yN20k2tomGTgxK+Nq3dtrS6qEYItDnPbvLRW4qjzUDKH3FvYIxqnk5tG/hYsFxLYQfl74I0CqhAbOw+DO78A9D/8FoQ2RNlIPo+Cc1gpB43wU+zVJ0/YFX7oDoS4YHwwK34mBIbHMKjlfOX83GnbgMoE/KP7dw4Jq9L/3V2IfJhQaYezlBrRoKbz8kYxDwAlR+3YaxXO5RMW6SlO6EsIAngMT4mfFzFUU1F9qZGGH8nkEVMB4ayhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TyLtHrPksUcqKugix3IvywS31xQ7wMViEvg24m8wO8=;
 b=UNB4XP200oNCSrG08cQ5nYslFcO+raM8e/OdTOgWoEapqwDKDiidNrP/ZTkpX7Pq2aDdtnJvBO1w/SshZGLUyKwbdSTYPYa9QlUPXlLcMzguRB5askyPEIVRkwjE119PuA+rnDbp/kBxBi+acAvu0W3PMR2jexIPyHEhnJII2i4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 10/11] net: dsa: felix: update destinations of existing traps with ocelot-8021q
Date:   Wed, 16 Feb 2022 16:30:13 +0200
Message-Id: <20220216143014.2603461-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 784672c5-2182-49ef-bf60-08d9f1593454
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815E6ABF22222696EFE5027E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnl6ipFL2/X4uJ9U+OUzmByUn0f8bURRSMvHZhAdXq3ABdkEwR7e/76eHMuGliU0TegI4wJgBEpk2fgVyHWnjpcMOR1EG/UKsWHghxrxV4kwntGa1BatHFQt68UYDnjKTyd85asPNzvKqJp88eQuhnxaIg8vwV0o1i6ivTZsi+jpQwFoPJrc8zVlj0xGSXWrOL9pMXTGF8HaLVIEsWkM+P0HV7eJ24mAgE8UKdvEmmbSi1b2K9vPvpV95eYnztkBFoQQLtAtEcDRdzfo9OwCg99eI5LAvHVMUcNKP+L2A3Bio3gjVANj6UMMeL/t5L4TE8wA6lhxbIADBK30Y4BTxNwyeHlvMcE4vv9r6uelIMCnGyT+WzvZkErcEFK/DBIEafjdFc0+cdBJW9FxD6xGLalo70zk5/Aknu231otV38QQC6WTPF7mjUxAsafrFie5eVNApLooZamXA5nXLyXJ7PndG1hkJ7A+B69gIe1R9us/PlZN3ZcXEm89i4MWOZAdAABYJDniLBzx3a3k2n2oQmLRfdpeVsTL6CM12JHzbQM4C4hmEGV1CeVOJbwOK7ywD81tb06WS47Ns8FyaMcrSnAx3lJBwn6uIqgNLb2dg9WHitc7c+EMAuAiDEuM+/lARJ/XAGKEAJC4xzgThjmG/fRaE9/SH8J2kzAOmBwrd4NfMu80utYeEnqfld6bnFaspFu9IyzucVDabcs6W3jo4O8ZMJfRkB8nTYJ5HOl9H5c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(15650500001)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(30864003)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZ8yj/GOEfcAvphRRwX2qyyofwaQ8wbNJNX2HxeUb9FUt5Dx4Yw90lWczlZ3?=
 =?us-ascii?Q?ox/Hs29WEU9PBCYbbtLcHPM1uLPE8LN0E89rYqJOR0QukAYBpgV7B8vsJ9Vf?=
 =?us-ascii?Q?sCXum6dgQfwcY0oP7V/kI7AYZAu+nfQ33CXC00n9JWm1EEWM+D1o1jce3V3v?=
 =?us-ascii?Q?qDmSrz8f7n/kYlF6TwuOgEzIQDKY2BqJhs7EEhuUd5ajzVZf9V2SnoYa0fOV?=
 =?us-ascii?Q?54qeLbK8lr1t3cXTMCMl+SdfLrSnU8wr4ku8F2WnuecassTgPv9fw+pYdU/r?=
 =?us-ascii?Q?opsqZkpRDcO2bk13TK/uGQwaH+kubE9djLtiUBwRVmA+FZ7PRRKeFdkBjCyw?=
 =?us-ascii?Q?pdyS5iIfIg3Op0iiUMuyj5ow0VbB53Xi3TiX/A6Adpw512LBsivwk9CvSskZ?=
 =?us-ascii?Q?9EokVNbEQQ0onxihzx+H4RwoAOF3YJWFNKy2TACrEgJmbN74/a/MlM0ahrRQ?=
 =?us-ascii?Q?UAeD3DAjli178ighzSBHpwruoj6FGIXoGYwEkTSazmkMS48kDTz+CA1KIhy3?=
 =?us-ascii?Q?4EgcnzIDWCMo2JRyTc6Wicg4yFhied3ao5s+m61c0NaRR/E+9zbu5OBBKkxk?=
 =?us-ascii?Q?mDHTZtsxkKy7vK+sQl1YCIo8keaMjP9aAFUgO4nymDo9VDH597XO5xLPk8Fx?=
 =?us-ascii?Q?fmTHaTfpAWBo0plQLrZ+zQAWK3K+E0fP6c/Z9swWb6/5VLknzmN0QTD1rdV/?=
 =?us-ascii?Q?CHUOHQiqKIiJu4yC3suwLuB11Wq/qqfNQ4C1XIjr8BWan/QDp/qHgCjNWpHp?=
 =?us-ascii?Q?UaZNgVGjrxIjlcnHltZYTi5A0V/SQMyNRo72sRvck8ACMyB7cgXdo+m9JxwA?=
 =?us-ascii?Q?b5uWseiDnf40lNuY+KuMnXs73WvxRQBHXbi8pwn32ONMYAruy4dcR6LxMcen?=
 =?us-ascii?Q?BUKEe6FqvfD+P1OgYVinY8tHpEI1umxnJp0wo7ModaJHF2/RPeqSjONNzyT1?=
 =?us-ascii?Q?Lj+CH14d3vazxWWidwR6Vf7R3I2riXGQR056LXZiPMlK7tQ64DUx7mU20vRa?=
 =?us-ascii?Q?oxNjMGi9c7G9Z1vsY1iml6bG7tSnBWTo2QllQocjBvyh1pDtV/OzYQO1dOKa?=
 =?us-ascii?Q?ACL4KlN8XEHUgh04cOeLXQvf5dJKiBErSUAgEhIiVrdCNEl4bWYyuArHFUQ1?=
 =?us-ascii?Q?VXywp5BmVahyRdHQP2H0erKdAFDogplCe9TKOExwKYBFGtZNDDTTbxBWLoIX?=
 =?us-ascii?Q?46ih5Ix6jLN+f3unRwH/85p2QSHQ2ujHPew+xtp8cyRj7e0fOu91c8St67EB?=
 =?us-ascii?Q?IELq5A6XQCz+MH4SARWNgWZEtuPoLMRUasBBuWxB7pvAnLd4IqlVLs2vC5v/?=
 =?us-ascii?Q?qakyIHbbGDOezS22J3YekW9GsbPZG/FiOfyxcQoV7flS/UGdIL1MiHT8pj5p?=
 =?us-ascii?Q?GZLBskIwO8KYfb9/cNYll+4Ha6SS6eL5pR/8E5y+pSC2ZpjlTCrWe55BpJB2?=
 =?us-ascii?Q?qECzEAXnphSXvtwHCciDX5BLNKONaqg2+N30kRLwOJwwSRlxJJ/6ILjGn1kP?=
 =?us-ascii?Q?IPaY3vkncfk0J5L8yWBhup5bbmtVAooX8s0ooHw9rw588nZIHm8CKGpCgxOU?=
 =?us-ascii?Q?WRMFcR7bH7NyBxR8EmedeBofDfUmLCaLRy8d+GTtkIKCIDcQwzouO/T9nAY0?=
 =?us-ascii?Q?G/TRfN26HB+8/tY+Mpe6T+Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784672c5-2182-49ef-bf60-08d9f1593454
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:48.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HB9yD3GEXQTgeMecSmnHSl0WxNpfLYovjJzr0NXBCVDlQbvG5PTIGpVM9A7n/RK2mV4O9six0CkAMvv1v2W+Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, the felix DSA driver has installed special traps such that
PTP over L2 works with the ocelot-8021q tagging protocol; commit
0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP
timestamping") has the details.

Then the ocelot switch library also gained more comprehensive support
for PTP traps through commit 96ca08c05838 ("net: mscc: ocelot: set up
traps for PTP packets").

Right now, PTP over L2 works using ocelot-8021q via the traps it has set
for itself, but nothing else does. Consolidating the two code blocks
would make ocelot-8021q gain support for PTP over L4 and tc-flower
traps, and at the same time avoid some code and TCAM duplication.

The traps are similar in intent, but different in execution, so some
explanation is required. The traps set up by felix_setup_mmio_filtering()
are VCAP IS1 filters, which have a PAG that chains them to a VCAP IS2
filter, and the IS2 is where the 'trap' action resides. The traps set up
by ocelot_trap_add(), on the other hand, have a single filter, in VCAP
IS2. The reason for chaining VCAP IS1 and IS2 in Felix was to ensure
that the hardcoded traps take precedence and cannot be overridden by the
Ocelot switch library.

So in principle, the PTP traps needed for ocelot-8021q in the Felix
driver can rely on ocelot_trap_add(), but the filters need to be patched
to account for a quirk that LS1028A has: the quirk_no_xtr_irq described
in commit 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP
timestamping"). Live-patching is done by iterating through the trap list
every time we know it has been updated, and transforming a trap into a
redirect + CPU copy if ocelot-8021q is in use.

Making the DSA ocelot-8021q tagger work with the Ocelot traps means we
can eliminate the dedicated OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO and
OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO cookies. To minimize the patch delta,
OCELOT_VCAP_IS2_MRP_TRAP takes the place of OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO
(the alternative would have been to left-shift all cookie numbers by 1).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 187 ++++++++++++++-------------------
 include/soc/mscc/ocelot_vcap.h |   4 +-
 2 files changed, 77 insertions(+), 114 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f0ac26ac1585..7d420e35654f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -267,30 +267,26 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
-/* Set up a VCAP IS2 rule for delivering PTP frames to the CPU port module.
- * If the quirk_no_xtr_irq is in place, then also copy those PTP frames to the
- * tag_8021q CPU port.
+/* On switches with no extraction IRQ wired, trapped packets need to be
+ * replicated over Ethernet as well, otherwise we'd get no notification of
+ * their arrival when using the ocelot-8021q tagging protocol.
  */
-static int felix_setup_mmio_filtering(struct felix *felix)
+static int felix_update_trapping_destinations(struct dsa_switch *ds,
+					      bool using_tag_8021q)
 {
-	unsigned long user_ports = dsa_user_ports(felix->ds);
-	struct ocelot_vcap_filter *redirect_rule;
-	struct ocelot_vcap_filter *tagging_rule;
-	struct ocelot *ocelot = &felix->ocelot;
-	struct dsa_switch *ds = felix->ds;
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct ocelot_vcap_filter *trap;
+	enum ocelot_mask_mode mask_mode;
+	unsigned long port_mask;
 	struct dsa_port *dp;
-	int cpu = -1, ret;
-
-	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
-	if (!tagging_rule)
-		return -ENOMEM;
+	bool cpu_copy_ena;
+	int cpu = -1, err;
 
-	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
-	if (!redirect_rule) {
-		kfree(tagging_rule);
-		return -ENOMEM;
-	}
+	if (!felix->info->quirk_no_xtr_irq)
+		return 0;
 
+	/* Figure out the current CPU port */
 	dsa_switch_for_each_cpu_port(dp, ds) {
 		cpu = dp->index;
 		break;
@@ -300,103 +296,46 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	 * dsa_tree_setup_default_cpu() would have failed earlier.
 	 */
 
-	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
-	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
-	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
-	tagging_rule->ingress_port_mask = user_ports;
-	tagging_rule->prio = 1;
-	tagging_rule->id.cookie = OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO(ocelot);
-	tagging_rule->id.tc_offload = false;
-	tagging_rule->block_id = VCAP_IS1;
-	tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
-	tagging_rule->lookup = 0;
-	tagging_rule->action.pag_override_mask = 0xff;
-	tagging_rule->action.pag_val = ocelot->num_phys_ports;
-
-	ret = ocelot_vcap_filter_add(ocelot, tagging_rule, NULL);
-	if (ret) {
-		kfree(tagging_rule);
-		kfree(redirect_rule);
-		return ret;
-	}
+	/* Make sure all traps are set up for that destination */
+	list_for_each_entry(trap, &ocelot->traps, trap_list) {
+		/* Figure out the current trapping destination */
+		if (using_tag_8021q) {
+			/* Redirect to the tag_8021q CPU port. If timestamps
+			 * are necessary, also copy trapped packets to the CPU
+			 * port module.
+			 */
+			mask_mode = OCELOT_MASK_MODE_REDIRECT;
+			port_mask = BIT(cpu);
+			cpu_copy_ena = !!trap->take_ts;
+		} else {
+			/* Trap packets only to the CPU port module, which is
+			 * redirected to the NPI port (the DSA CPU port)
+			 */
+			mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+			port_mask = 0;
+			cpu_copy_ena = true;
+		}
 
-	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
-	redirect_rule->ingress_port_mask = user_ports;
-	redirect_rule->pag = ocelot->num_phys_ports;
-	redirect_rule->prio = 1;
-	redirect_rule->id.cookie = OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot);
-	redirect_rule->id.tc_offload = false;
-	redirect_rule->block_id = VCAP_IS2;
-	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
-	redirect_rule->lookup = 0;
-	redirect_rule->action.cpu_copy_ena = true;
-	if (felix->info->quirk_no_xtr_irq) {
-		/* Redirect to the tag_8021q CPU but also copy PTP packets to
-		 * the CPU port module
-		 */
-		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
-		redirect_rule->action.port_mask = BIT(cpu);
-	} else {
-		/* Trap PTP packets only to the CPU port module (which is
-		 * redirected to the NPI port)
-		 */
-		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
-		redirect_rule->action.port_mask = 0;
-	}
+		if (trap->action.mask_mode == mask_mode &&
+		    trap->action.port_mask == port_mask &&
+		    trap->action.cpu_copy_ena == cpu_copy_ena)
+			continue;
 
-	ret = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
-	if (ret) {
-		ocelot_vcap_filter_del(ocelot, tagging_rule);
-		kfree(redirect_rule);
-		return ret;
-	}
+		trap->action.mask_mode = mask_mode;
+		trap->action.port_mask = port_mask;
+		trap->action.cpu_copy_ena = cpu_copy_ena;
 
-	/* The ownership of the CPU port module's queues might have just been
-	 * transferred to the tag_8021q tagger from the NPI-based tagger.
-	 * So there might still be all sorts of crap in the queues. On the
-	 * other hand, the MMIO-based matching of PTP frames is very brittle,
-	 * so we need to be careful that there are no extra frames to be
-	 * dequeued over MMIO, since we would never know to discard them.
-	 */
-	ocelot_drain_cpu_queue(ocelot, 0);
+		err = ocelot_vcap_filter_replace(ocelot, trap);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
 
-static int felix_teardown_mmio_filtering(struct felix *felix)
-{
-	struct ocelot_vcap_filter *tagging_rule, *redirect_rule;
-	struct ocelot_vcap_block *block_vcap_is1;
-	struct ocelot_vcap_block *block_vcap_is2;
-	struct ocelot *ocelot = &felix->ocelot;
-	int err;
-
-	block_vcap_is1 = &ocelot->block[VCAP_IS1];
-	block_vcap_is2 = &ocelot->block[VCAP_IS2];
-
-	tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
-							   ocelot->num_phys_ports,
-							   false);
-	if (!tagging_rule)
-		return -ENOENT;
-
-	err = ocelot_vcap_filter_del(ocelot, tagging_rule);
-	if (err)
-		return err;
-
-	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
-							    ocelot->num_phys_ports,
-							    false);
-	if (!redirect_rule)
-		return -ENOENT;
-
-	return ocelot_vcap_filter_del(ocelot, redirect_rule);
-}
-
 static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
 	unsigned long cpu_flood;
 	struct dsa_port *dp;
 	int err;
@@ -432,10 +371,19 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		return err;
 
-	err = felix_setup_mmio_filtering(felix);
+	err = felix_update_trapping_destinations(ds, true);
 	if (err)
 		goto out_tag_8021q_unregister;
 
+	/* The ownership of the CPU port module's queues might have just been
+	 * transferred to the tag_8021q tagger from the NPI-based tagger.
+	 * So there might still be all sorts of crap in the queues. On the
+	 * other hand, the MMIO-based matching of PTP frames is very brittle,
+	 * so we need to be careful that there are no extra frames to be
+	 * dequeued over MMIO, since we would never know to discard them.
+	 */
+	ocelot_drain_cpu_queue(ocelot, 0);
+
 	return 0;
 
 out_tag_8021q_unregister:
@@ -446,11 +394,10 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp;
 	int err;
 
-	err = felix_teardown_mmio_filtering(felix);
+	err = felix_update_trapping_destinations(ds, false);
 	if (err)
 		dev_err(ds->dev, "felix_teardown_mmio_filtering returned %d",
 			err);
@@ -1287,8 +1234,17 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 			      struct ifreq *ifr)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	bool using_tag_8021q;
+	int err;
 
-	return ocelot_hwstamp_set(ocelot, port, ifr);
+	err = ocelot_hwstamp_set(ocelot, port, ifr);
+	if (err)
+		return err;
+
+	using_tag_8021q = felix->tag_proto == DSA_TAG_PROTO_OCELOT_8021Q;
+
+	return felix_update_trapping_destinations(ds, using_tag_8021q);
 }
 
 static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
@@ -1415,8 +1371,17 @@ static int felix_cls_flower_add(struct dsa_switch *ds, int port,
 				struct flow_cls_offload *cls, bool ingress)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	bool using_tag_8021q;
+	int err;
+
+	err = ocelot_cls_flower_replace(ocelot, port, cls, ingress);
+	if (err)
+		return err;
+
+	using_tag_8021q = felix->tag_proto == DSA_TAG_PROTO_OCELOT_8021Q;
 
-	return ocelot_cls_flower_replace(ocelot, port, cls, ingress);
+	return felix_update_trapping_destinations(ds, using_tag_8021q);
 }
 
 static int felix_cls_flower_del(struct dsa_switch *ds, int port,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 50af64e2ca3c..deb2ad9eb0a5 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -13,16 +13,14 @@
  */
 #define OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port)		(port)
 #define OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port)		(port)
-#define OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports)
 #define OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port)		(port)
 #define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		((ocelot)->num_phys_ports + (port))
-#define OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports * 2)
+#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot)			((ocelot)->num_phys_ports * 2)
 #define OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot)			((ocelot)->num_phys_ports * 2 + 1)
 #define OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 2)
 #define OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 3)
 #define OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 4)
 #define OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 5)
-#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot)			((ocelot)->num_phys_ports * 2 + 6)
 
 /* =================================================================
  *  VCAP Common
-- 
2.25.1

