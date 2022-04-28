Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF55131F8
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345251AbiD1LDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345089AbiD1LC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:02:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2123.outbound.protection.outlook.com [40.107.220.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FDA98580
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 03:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pq546xxCGZ4Y/Iu9PzIE8lo7tXQavSP6VrpeAmqlMULf6aUSfffpE85cEQHgoRgk1+wCMMqU50NUrD7a0mIn9SG25J98HDEP+uQloy7LZIYFoXnbrx7BA2eqB1C5LHsHs1ChFhhuOC4rWadsjOv8V2Dd2w3jgAoiF/7Lcc7bwsUfhJcCkNiun3wEfZ0f7I/tFu4jB7Pbm31BosZQxo3phVOqnDsGd1QejTN0j+jB5nK/eYP137mPm7KPFQxEldTOtEgSZ7J8sadeF20nJR/VRm4T7tyyYAWqs1hWosZuzxMFBNdFt9VKMS5+KNeTw1EclCyDIynH46HfuSJvVoBxuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XkPEkr4l+7ueHNzkrExN9JJ2IeO2BMBPVm59WRwVY4=;
 b=CiBCudUVa4SzBHbG9zX2qDBCvuSHIVxQv/5nd9BdE9oGl2IM/c8VGk/i9n6B5ntKKwvgcY041l9EOXwW5uGsjWcCYRCtiv05gIcqsFlKpkdQS0ErfPcNUx52JwAOLoy5A64ioIBt/WQXougdqIXQwol6bWmFuX6GWEZxNXrYhYf/BkFkxhD7c12ZxRnNIbr2axSdXuhUuzyTpp7qCYg+yiuvHVuoLzDgrDXSJtCg+NBHWEkCOB2sk6KC7xp6roKuJSVEtoVQH/HBT8rIfmSja0CmMn7jHcwbAU6cmG9I5RswHKe8wcVDxZgAQL6Fg9IhC/1Vf4thEi5eEZOXnOjp5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XkPEkr4l+7ueHNzkrExN9JJ2IeO2BMBPVm59WRwVY4=;
 b=oZnJvFDj2m7JUYzcEoY/0dUpPgeknlhlepHay6nyq38X4gaVMvt8Ow35/MysWLXaoPgBRnFEOhqk98ijV+THZ/iTpp2u9EpoJ1g/ii4cs2feTexC6AqK9H2TkNyo/A/iwvqFfLdF0yR2V8IsZrKC4vdrX+pPdAb53TdpMpPHKDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB0996.namprd13.prod.outlook.com (2603:10b6:404:20::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 10:59:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 28 Apr 2022
 10:59:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: utilize the tuple iifidx in offloading ct flows
Date:   Thu, 28 Apr 2022 12:58:56 +0200
Message-Id: <20220428105856.96944-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24cfcdd0-11c3-429b-f7e7-08da2906230b
X-MS-TrafficTypeDiagnostic: BN6PR13MB0996:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB0996A0CE94759A82888F85B0E8FD9@BN6PR13MB0996.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yo0k3m+VqqYitBETCTxhTRRVCMdoj58BcXW+nMyoSvOueeZs2jlndm86xlrtEPN9C+ZorVWcmu4XMxWywLval2TmPBhur2ymIHYhIz1jdn4ue6VkAkMcVnCOXT3vEhgbC54r57yNFtkszKAjEsziwWx/pbirgB+ARA3PaErDqeCNSZE18QPoM3agpPp2h6AA70iXne/zYcsIzZswylcDwVvN2axupl2trn2NLErMrosfflQ0skniGj2c1Biw20BYwVk0RDxfLmmdPpZp9Jgqc4PU2DPNXSfpjJ3QTjFOFDrg3fIBwoxnTwz7KTHElFDOQdrusNZXiXAJFdvl2uO6nXmyyJD+W+tIgjvRg2oXY9Zy81GAsC7rhbQvAPCRxH/2wNXyG3d01lILEbfq02iwR4qSYOsxlNHC61bl4VtMoJpM07xWzzZ4LUg3qvSXAuvyfZYsYOsbvFusWSF+vfC/52DKcpjXNHX6/6CTEqL0m/pAi9Gvyj0JksaytsiwKzleTruM0zkzqHiteJH42Ajsbmmd34GkYS/BVrjkbpbZy+jDc7vScI/TWiqN+GiKZbldmEtZaYk5vXccU6cZaFxcN02Unbk2O9Rv335UgSBDog0+qByY0ClUpB3kNJqALkmPz1phtYTORL8yckAEteJuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39830400003)(376002)(366004)(396003)(5660300002)(8936002)(1076003)(6486002)(6666004)(83380400001)(2906002)(44832011)(36756003)(508600001)(38100700002)(52116002)(8676002)(66476007)(66946007)(66556008)(316002)(186003)(4326008)(6506007)(54906003)(2616005)(107886003)(110136005)(6512007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o6w/CMUZP4w9Q5aGrK1VHGO22xYJKQ3oJOj6O5rEmxIpD/ihEDEVzR/SQNSg?=
 =?us-ascii?Q?RJWpCYIs5V9tZN421422wk36yqRGOgAqqbrJT0A8a/qdyKHtDeoWNC2Wpvio?=
 =?us-ascii?Q?w5A3CzfWnGSIJaffCqtyQoJhdlUWIkmHKwnqacEW5jAM8d9q1sUF/YauOFV+?=
 =?us-ascii?Q?cKL4I0EQd6TC2U5Sb15O/sx+ZZTofdt1ruGhvXFoyHXJOboA7yU0/kPuRBkU?=
 =?us-ascii?Q?ELaWaZ7pFRGfO4iUNK8lCxA+75YlCBMDF23KMsBXDXSP827eFq3wkRo2T4mP?=
 =?us-ascii?Q?1Gi6px39ipXB5yygM3//WITJnzc/+PY3HAd5fir86sTRl2sZdKteMfJr0Ng1?=
 =?us-ascii?Q?pjSBgi0abd5q4FgCqz9XJwJB0PKeqGe/Tar8z66wiVgj2fGtBCWlqdmMCn96?=
 =?us-ascii?Q?PcxS2lWwysAfMBYm4SGQpziH8GBchrsezR7P/Lyhw4hhdr/yAfTRoRpS1egg?=
 =?us-ascii?Q?YNhnfiq1mATer5Zb1RklASZQDNBCHMdM7/WZmwCmsxro5E/fXw6pt+tIoCta?=
 =?us-ascii?Q?DcGvSBmWCPuPuyjDdTrHW9Efz6F+tzmjUUyvUC05zNLD/aa4gkreNL8+T4PU?=
 =?us-ascii?Q?FIOabpAhXGIl6Di6Z2SnXkfHJc9zjR4iMgVu7haYwroo4CvRv0E4XuAjivcU?=
 =?us-ascii?Q?rFTMSMjaRf2DAhbggmUSpKu6saML1nYdXdoVYBaA4ccXgyGc0+wvxhjfdwmd?=
 =?us-ascii?Q?pBCg9oLiYPUTVnsLhlR0j8qj2qOCnD/Pr0Ptn9M4jjlD8z1dV5tGib4iObcE?=
 =?us-ascii?Q?CuQD5XV685oHFFM32Wr8D9Gux+shMLJYQhtZaeapr/mT0XJpwxkH7qKNpIrJ?=
 =?us-ascii?Q?TSa8etCvs6e9DLhmFEjOWxBCZD0V2cWR98ssR7m49sWLyVIKD+WJDhGe2u5K?=
 =?us-ascii?Q?dx6NK1zSxjsglt9x2GVXB1LsQY16y4IkQlCx8NfqBUqPjm4NfFoR40nAeww4?=
 =?us-ascii?Q?p3sDpBga/4ydPIfKPpjDnhI3ptsE5GsEi+s/JLlkanGFtpolWOA+iEF4hjUQ?=
 =?us-ascii?Q?l8kKm81aIg1mjj8thIPTil8qD6itcP/ibGRF3tAfHcrus7mmogjr6Hrn4L6J?=
 =?us-ascii?Q?KoR4vlLssWiN90hKGPHB30MoQy3WHGbKJB3YkpvCjm22g+lWE4eoGbSvKnQ4?=
 =?us-ascii?Q?PrU5Icghyb85EFGj9ihNgKLYKrTF4PvFMf/VBowK+UEbM652BXUL1dU4qBZv?=
 =?us-ascii?Q?PkkXVspClC8s6Bov86AHPbG9ozRczVgw6msfG3r1XJSwrn3mkNtLR2w4mRoc?=
 =?us-ascii?Q?+uRWnqLUy6inzY6C+474LUeGsJSycngrU8s/Q0EfywSLkITh0XXkbRn+n5Kc?=
 =?us-ascii?Q?lEtNXB8h09gQNkR7uhdnn9F+TS1XHUzVKOEvglQcq1pA5QIg4O5FOprjyVl2?=
 =?us-ascii?Q?pZiAmTLZ8DUguVLcOnbNKMZTlNBx7tb9cwKlJNptimtz9hyplx67XpEjZ3O2?=
 =?us-ascii?Q?hhVyJZo9tlfBp7/afH/SmJUM9nOmMwXKXG9VXtsuOkw/yrBnmQa9QiqFsuIO?=
 =?us-ascii?Q?tNcF2VDjDl+gs+5IGJYgC/uIdkxKwHAAif3IH2tGtZWpm0IMD/nEsRRYfeiN?=
 =?us-ascii?Q?EEwM2ebo49jheTAWmEFBtDKVMaAdoXwuh4FgWek3Ao8RkgTTXFHFrhNsOpun?=
 =?us-ascii?Q?Q24jpuoroBUeeFxvhkepNcPPJh77ppmdDjRZh1KEKoLzSJHVfo+khpXk0Vp2?=
 =?us-ascii?Q?9l2EPHxSZUCoTaa7iiOuCMZd6vFsW2XvTWP31VouPdVHIo3Ksgmm02jQbYjz?=
 =?us-ascii?Q?z63SUfpYo1+W02dewe+Rx/Vx9sXPMuN9+r8QBA0o8URZzk095WP1heO5bYBk?=
X-MS-Exchange-AntiSpam-MessageData-1: c+G/rL6xGniJQj9876jOqNcxsHL2AE1HmYA=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cfcdd0-11c3-429b-f7e7-08da2906230b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 10:59:16.2438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qelK5wyWlImdV8wskVpIpXEQM6KVxo05PswbmvevcrAjSKWDGCBxaYw2STPMVaJm7et1AVWTD64s2a6Sd8/OmC9bRh7LBBsPDuIPWZwfXMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB0996
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The device info from which conntrack originates is stored in metadata
field of the ct flow to offload now, driver can utilize it to reduce
the number of offloaded flows.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index bfd7d1c35076..9225a459d8d4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -83,6 +83,10 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 				 entry2->rule->match.dissector->used_keys;
 	bool out;
 
+	if (entry1->netdev && entry2->netdev &&
+	    entry1->netdev != entry2->netdev)
+		return -EINVAL;
+
 	/* check the overlapped fields one by one, the unmasked part
 	 * should not conflict with each other.
 	 */
@@ -914,7 +918,7 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	/* Check that the two tc flows are also compatible with
 	 * the nft entry. No need to check the pre_ct and post_ct
 	 * entries as that was already done during pre_merge.
-	 * The nft entry does not have a netdev or chain populated, so
+	 * The nft entry does not have a chain populated, so
 	 * skip this check.
 	 */
 	err = nfp_ct_merge_check(pre_ct_entry, nft_entry);
@@ -999,8 +1003,6 @@ static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 		pre_ct_entry = ct_entry2;
 	}
 
-	if (post_ct_entry->netdev != pre_ct_entry->netdev)
-		return -EINVAL;
 	/* Checks that the chain_index of the filter matches the
 	 * chain_index of the GOTO action.
 	 */
@@ -1114,6 +1116,20 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	return ERR_PTR(err);
 }
 
+static inline struct net_device *get_netdev_from_rule(struct flow_rule *rule)
+{
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
+		struct flow_match_meta match;
+
+		flow_rule_match_meta(rule, &match);
+		if (match.key->ingress_ifindex & match.mask->ingress_ifindex)
+			return __dev_get_by_index(&init_net,
+						  match.key->ingress_ifindex);
+	}
+
+	return NULL;
+}
+
 static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
@@ -1154,6 +1170,9 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 		entry->rule->match.dissector = &nft_match->dissector;
 		entry->rule->match.mask = &nft_match->mask;
 		entry->rule->match.key = &nft_match->key;
+
+		if (!netdev)
+			netdev = get_netdev_from_rule(entry->rule);
 	} else {
 		entry->rule->match.dissector = flow->rule->match.dissector;
 		entry->rule->match.mask = flow->rule->match.mask;
-- 
2.30.2

