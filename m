Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B47E51B78B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiEEFrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243666AbiEEFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2114.outbound.protection.outlook.com [40.107.101.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C353B34B9D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8xnt5mPtIOf39s/eY8cHMksJzSwHL8TyOF6d55K1lV9EWdcRSB1Bznu1lZEb2XbOaL47TT9F+ajImGK4mc3EFw+/fFPMRzYeeW74LB4Lv8Z9sq6yy4OKbf4N214os6fe++h0soWPmeAGrK6V054VbWgJsQNdT7Z+hbBlZzWt+1Z8OxNFSi+rAesONuJ9MEpp0R87G2h0lIDsEdpKE7N83QwN6DMyK+RzIDSBCvuhgWiQa1B+xXgkQGm8yMDqy3g3W8zjZlqvTheW1zz0H2f7vYCQ6HWj6g+pjsM80pVsPskYZv8bByi4ZRdUicUudZE8p9fcHEjn4pfvOXQrSWilQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFzBykFnBnIqO4caDsWIwKq7BQ6TOUi+Q6ifVvBrTGk=;
 b=QzzmgH8GBKhAZWPjyG5slCTAlyCBEzf1VW+6Auq2El8+Cu3Lss/5U4WX2KITCbycRrdGUxNZRz4+spRH50qdk6jivq5ff4ePw+omTN4WNkzehLv4zcpQJARe8AjeKToPWDqBNMGjYO8CFo1QGTmtWfmF7Kc0Mzmg6kxz/4pxnaHAyFGCm9CbTvEKtXswkRxouiL9BARjaL6x6TivoVyU5J4Dyy9udjP2bL83+ckbkjIWDuN6w61znXVwmkfd+OQtvGQ5QfwvIskBsbqE5K3HzsnByLCacpC8j391CWoaX2Etx6+8PX4cWdckZMrZc/1j86/drM4tYqm4jRIIMtrU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFzBykFnBnIqO4caDsWIwKq7BQ6TOUi+Q6ifVvBrTGk=;
 b=lWpHhgPqqngsP6vwDAFz27TbN/Sb/H7gojCn1eeknRrN1vkzXxhKYkPXiLZkXDrWZxrsjctPdKW0LWFz2mr11PmQNZD437v7kJB8HxOvKRtC8p33tamYVG8FQOku3jmMXiPKun4HGOC8N+xPeMRU3pC00ucOuOTccvDvolqDQX4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2609.namprd13.prod.outlook.com (2603:10b6:408:82::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Thu, 5 May
 2022 05:44:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 3/9] nfp: flower: enforce more strict pre_tun checks
Date:   Thu,  5 May 2022 14:43:42 +0900
Message-Id: <20220505054348.269511-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8f23c6c-7453-4a37-b47b-08da2e5a45a1
X-MS-TrafficTypeDiagnostic: BN8PR13MB2609:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB26095FDCC37695CC38740EA8E8C29@BN8PR13MB2609.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgVUH8Q3+V9IbSyrxXkVXoJFueSNFdfnGqFtZMGYshiJmxKzJi5UoY62a0n7yub8DyBrKtnz5wX/pPjqD/BEQvHKZXc2PapYbrc2MGfKH+t3KGSKflUasWptC+NSlSoYTJb7aiCDyrQBx5w5cJxVAEl3Ae8WkW1r2/pXqSZAAPduZUFM0y9o2RL8uswciuxDfmpPuPQVR05TgMMjrrz75zH07yB1Nw0hFZdid6UoZzetBYn6rI4hx1CEOWxOc+xp/mBUal2Ai1ik+Z7y9uTRpo32iSK43qpBXPFIdET+ykpyBHQJlqhRpBmC+p0t0XXC7jdzKru9ICuNrHNVOsR6GPhPfnBBS42k0nj0H2+wv3La4tPWWn0wGmOxoBglHTxdip8abGdvN1RItLadPfyU2joHnXBcKZyXh85vGCzIWX5ABGRs90WkAllziz3Vuga+96AiTaWpUsZK2T54PPR4+gH64zYqYb1UMN881IA2pGXEzmfarrtLVYPC22qRtpzL4xolME5gqY+WWyfmBGdF98fMOZwFi1XiQcLZfLkDOIbj6xLfWoOiZs9A7qUG+dnGW1wdirWasHo1iD32dMVnu/NlXHe1APezDZ2ZTC5Z/ok5RD6Q6KEQzdDEkT4Ol5C5h0BwhGUnOajeYx94OukrSLcJzo3YFNQb5gy6uWnd9LHUMiNrU/JAvDUW2ZF20HBAd/v1IyxJML3sbGX2zsI8Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(346002)(136003)(39830400003)(6666004)(6486002)(38100700002)(38350700002)(44832011)(5660300002)(316002)(508600001)(2906002)(36756003)(86362001)(186003)(52116002)(2616005)(6506007)(6512007)(26005)(83380400001)(8936002)(66476007)(66556008)(66946007)(8676002)(4326008)(1076003)(107886003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mA/vtcaLxVQJUVdewBilwcbAMRThkTBNnFB6it/rMIQn1eBKvcs4FCAG8BUV?=
 =?us-ascii?Q?9cCU0eiZnlMFdQx54B0FIlwofSWT4CggotOvrCUiPzOroN8rmNE6uWuv3BAP?=
 =?us-ascii?Q?pmL90i1zL2xXfIa3N5RPl8ed+A4nebaaoDNXxrh0AJrQFuvFY0zumah20pNX?=
 =?us-ascii?Q?EHE/ROnHEblnCnLxJm6Fd0/og8Gn6pS7fjyMJQXY7Vkx2bRnnFdyhbDmNnkn?=
 =?us-ascii?Q?2tuPTvgS9FLYyq2iwUcy0egOBfSpPFnxlwYR7cqxMrFxE4l/4/7oC4PE2+Tn?=
 =?us-ascii?Q?XhgGTDruoYmHPQq6cpQz+1MWKDEOZJFCcQxkJT0OwmlDkVNzpvdWGszeBufT?=
 =?us-ascii?Q?4RiBZ2ZPEOKBfnctMeh+U2nXIbECcSS/2NcSJ3yhrNj9MuXYuucdaKIztfy3?=
 =?us-ascii?Q?Xdnv8xLbAWs2yggDPr6WSK+fUmdCZadfNrTgDo80IuImPTAoG8dzTKZpfcCA?=
 =?us-ascii?Q?HH3vQvVnVjRNHXHYa0VudIf7BATZUjQnfCjtXv8j+zLh7n+W1GU1eYCMwDG0?=
 =?us-ascii?Q?lhMNWimTT0X2TDn/QciCILh3GWXanZ90VsFn/Ce1N5jfBN3M4tAGHI/2oEd+?=
 =?us-ascii?Q?1a0gS80QpVZX/Jgx1uJFwHuuFA4Uoqgvs3yrj+NcPYr+b37Tg+EILP4aFRSc?=
 =?us-ascii?Q?sQueyjuZgolJbJwr4k9mk8l5DGIA/ATZK6xz3v2jd9RxFMW2v2jlGgdPXNN9?=
 =?us-ascii?Q?DFBw+lJYyYidpwdBJNTD5lM5w3H8mXX4mKeLNejrptfHVN7qs+lE1obzq1ty?=
 =?us-ascii?Q?4I6iyX1juEMwuLCnXYhxyImWylkQcnKeFghwNHZ6mXiiy49uzjdG7NR+iNgg?=
 =?us-ascii?Q?VSK9058InEItsGiGeAdYBr9GIZtVnZpREcMr15jogSevrMTn0KPq+0KGe7kZ?=
 =?us-ascii?Q?StM/9/HPVxK1H1lon3INWUdgMThCfx1R8ARhtTWYrU621CgGXqAdICBqgoKy?=
 =?us-ascii?Q?6+xsKIZ/9YG4vTC27Ij1HTgWYtgRMIvjmpM35oxtybP1HNjBFFWrCeCubzka?=
 =?us-ascii?Q?IIdJEIx6in73Hq93PO7pcpO8PDwKk1kQHUHbyVwPI1vvkagIp5VBlS5tqB9Z?=
 =?us-ascii?Q?p1IDwuGdEev3fD/A31cFGIR/ahTPsmQ0rAn3or6RDsr5KKB/3ilPY57lACkr?=
 =?us-ascii?Q?CFkf+ZOAsVpl5k1c1yXkybjpW5sHtPOYxg2GQJfa0ZoqRL70FWBR9AQemHts?=
 =?us-ascii?Q?DTtRCyIm8i89B/AMv/d5hxviaYETRvhfZf0fQGYOjt+8rrbFDyVT0azDyMOM?=
 =?us-ascii?Q?ZtSygUMSw4K107/JKFYr91RRtcBopxNRKsIiMx0xlY7pUeKlAojzAO5ZBeIz?=
 =?us-ascii?Q?kNhK83svodvCvrB96qbPL9AOKzlbSFMZkUzbNrNThEISNvSBA6i7jvus+4AH?=
 =?us-ascii?Q?6lk/RPLPbfk4aV7Pi3Y/BNvH4NOKNAijH1eJQzMZtn/46rEPYUTwjM8llOYS?=
 =?us-ascii?Q?dUIgE9esilmbXi+5nUYinEqJtQu7kDJE1zVkT7dYoH1Bv3Gb38oX9M8/ZsWz?=
 =?us-ascii?Q?yXAvH7vPiSXQxoW3amAR3CkomkcS/vfkTCEpLf3xc4AquQm2jqQJhAnU0YDc?=
 =?us-ascii?Q?6gOb4eECXb/XiTyYQ7Pzj83ANfk55z0iI9QtJL15BTxjWYjq+WKW3vG4e0KS?=
 =?us-ascii?Q?IkglsHpnXye+EfIvs2mF/US3kTpLEJYY9SBhYtsBrlDHl29RuwtrQPStoIDs?=
 =?us-ascii?Q?OB+OKdGye+XlBXrDvYPGD090oWuo7hHB34JGllfH0QJqCMI6ZO6h4Fej+u3x?=
 =?us-ascii?Q?BSdAF6N1wUDacnWr2cSS5o3eWUxxZRg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f23c6c-7453-4a37-b47b-08da2e5a45a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:07.7599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qQlLThJHuX9HPBldFCDHjUm41Ow+PJK/MhBEK02W8EXLAuKx1JqfQCUQ37hJU/S3Mb37xEP0mqd3wDMkiKP83mu4z3Tlb376iwjx0a0/P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Make sure that the rule also matches on source MAC address. On top
of that also now save the src and dst MAC addresses similar to how
vlan_tci is saved - this will be used in later comparisons with
neighbour entries. Indicate if the flow matched on ipv4 or ipv6.
Populate the vlan_tpid field that got added to the pre_run_rule
struct as well.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 41 +++++++++++++++----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 0fe018bef410..5fea3e3415fe 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1170,6 +1170,11 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	if (key_layer & NFP_FLOWER_LAYER_IPV6)
+		flow->pre_tun_rule.is_ipv6 = true;
+	else
+		flow->pre_tun_rule.is_ipv6 = false;
+
 	/* Skip fields known to exist. */
 	mask += sizeof(struct nfp_flower_meta_tci);
 	ext += sizeof(struct nfp_flower_meta_tci);
@@ -1180,13 +1185,6 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	mask += sizeof(struct nfp_flower_in_port);
 	ext += sizeof(struct nfp_flower_in_port);
 
-	/* Ensure destination MAC address matches pre_tun_dev. */
-	mac = (struct nfp_flower_mac_mpls *)ext;
-	if (memcmp(&mac->mac_dst[0], flow->pre_tun_rule.dev->dev_addr, 6)) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: dest MAC must match output dev MAC");
-		return -EOPNOTSUPP;
-	}
-
 	/* Ensure destination MAC address is fully matched. */
 	mac = (struct nfp_flower_mac_mpls *)mask;
 	if (!is_broadcast_ether_addr(&mac->mac_dst[0])) {
@@ -1194,11 +1192,36 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	/* Ensure source MAC address is fully matched. This is only needed
+	 * for firmware with the DECAP_V2 feature enabled. Don't do this
+	 * for firmware without this feature to keep old behaviour.
+	 */
+	if (priv->flower_ext_feats & NFP_FL_FEATS_DECAP_V2) {
+		mac = (struct nfp_flower_mac_mpls *)mask;
+		if (!is_broadcast_ether_addr(&mac->mac_src[0])) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported pre-tunnel rule: source MAC field must not be masked");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	if (mac->mpls_lse) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: MPLS not supported");
 		return -EOPNOTSUPP;
 	}
 
+	/* Ensure destination MAC address matches pre_tun_dev. */
+	mac = (struct nfp_flower_mac_mpls *)ext;
+	if (memcmp(&mac->mac_dst[0], flow->pre_tun_rule.dev->dev_addr, 6)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported pre-tunnel rule: dest MAC must match output dev MAC");
+		return -EOPNOTSUPP;
+	}
+
+	/* Save mac addresses in pre_tun_rule entry for later use */
+	memcpy(&flow->pre_tun_rule.loc_mac, &mac->mac_dst[0], ETH_ALEN);
+	memcpy(&flow->pre_tun_rule.rem_mac, &mac->mac_src[0], ETH_ALEN);
+
 	mask += sizeof(struct nfp_flower_mac_mpls);
 	ext += sizeof(struct nfp_flower_mac_mpls);
 	if (key_layer & NFP_FLOWER_LAYER_IPV4 ||
@@ -1227,17 +1250,21 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	if ((priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ)) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
 			struct nfp_flower_vlan *vlan_tags;
+			u16 vlan_tpid;
 			u16 vlan_tci;
 
 			vlan_tags = (struct nfp_flower_vlan *)ext;
 
 			vlan_tci = be16_to_cpu(vlan_tags->outer_tci);
+			vlan_tpid = be16_to_cpu(vlan_tags->outer_tpid);
 
 			vlan_tci &= ~NFP_FLOWER_MASK_VLAN_PRESENT;
 			flow->pre_tun_rule.vlan_tci = cpu_to_be16(vlan_tci);
+			flow->pre_tun_rule.vlan_tpid = cpu_to_be16(vlan_tpid);
 			vlan = true;
 		} else {
 			flow->pre_tun_rule.vlan_tci = cpu_to_be16(0xffff);
+			flow->pre_tun_rule.vlan_tpid = cpu_to_be16(0xffff);
 		}
 	}
 
-- 
2.30.2

