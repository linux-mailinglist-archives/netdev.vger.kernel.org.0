Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9926C5B8C7F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiINQJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiINQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:09:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2103.outbound.protection.outlook.com [40.107.94.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554C2606B5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSCDHsfpzb6rEMva+oQJ0F9zMmkH9+mRo0yh0NgQ5GnSnezk9fyss3LLBoES5cjpZrIAd02MJDV/gRNajuWpQJUH7R/BdS1q7KIbtjFHrriKBku3YoryhEWcmi+hDFzTR8/HickC5woqRbhdfSL9AkopnddCIfxpzUwA1pCyOZE6i3g9f5LICQu5jVMLTCs78eJ05lqBzYZhY/PzJGgcOEl0zN6ctH6a25dkmKKNST1BrBFEOepLo1cMvQ9+cQUUq4l4Cmklb6idbLVKAK4f2ca9PITEs0nfkCG6HPx6cEa98ae7hodrR3omhtXY8Dfo6D5e3Ku0rwM+kVLqkCcYQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeEtkosdSH5Lk021RNG34qZbv2k4mDua3V0B893iEjo=;
 b=VF5LjrCM17tIhfY4YgcFM/jHwjZS//FqQjy/mnE1y0P06/EjzkdiP6cATenIU1NalBBNGSWfVlvTGKqBtLmh+6I2klA6a4UZKjR9Fy4uPA7BAEqsFAZwADFXNhB8zP1HvQ4ygMeaID2Hk0ggaoCgC63TsQHF+zpkaDD/zTaaoJYXTHcXHw96LQ5/8WykWxN1Ma4eojdXnzZNYhDZa7bo0jThu191q8IMzuKa+AcXJnxEwORys9+3kvH1TdWFDZ//pMuVeHP14zzBdXHEfclhU7Gf5OyxWwNlS8hJorGrYyPP2kOsW4Q245ceXTdKIkJ08mi2DHQWQ6nRA5cFKkmK4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeEtkosdSH5Lk021RNG34qZbv2k4mDua3V0B893iEjo=;
 b=g11wRziRoNG8d/TZzO+ALZSkstlyao/ckTPTfbxZ+gdBeDxJsCU2ZjvTjsl43/5sxD0FDFkW6yBefSlLDj2gV/rU0k5gsAXKcywWqjDnCsoIZfQCEa0uhk9SYrBRlNnXXjcZsQ0dgeVdcPpGMH5AttliXOjfBhylfklmpz0OO/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4796.namprd13.prod.outlook.com (2603:10b6:510:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Wed, 14 Sep
 2022 16:09:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5632.012; Wed, 14 Sep 2022
 16:09:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Hui Zhou <hui.zhou@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: [PATCH net-next 2/3] nfp: flower: support hw offload for ct nat action
Date:   Wed, 14 Sep 2022 17:06:03 +0100
Message-Id: <20220914160604.1740282-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220914160604.1740282-1-simon.horman@corigine.com>
References: <20220914160604.1740282-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 3653d310-8bf3-45dd-523a-08da966b7194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vzYU0069fCdiy3acjKOpwYqcxfO8KRV1je3XFcjzzN9LiIoMRBMJDJgGY+PzrBVEjrZT+QH9NVN64QRLPYh0s2vDWgxW0NsBIQYwluLq2+i3Lo5zZqh/kxWlt9mMp1VaYGgAOrK5lAho9U48+9+oYyAgp+Y3gnNe8869WDZLOFCKlIfy94RE5f7zPfTRifACem5GjMzwlvq7ueZCPOaWtfOlj/h9d8jtcODLkDWEr4kZqjS+UCmhBm5rBOOFScNS0ub94suZwk6F0bru9q+ecmzR6WG7hyT/8yZXYXobb3zz+SWlGT8iJuWgIQm6DQiaWeYGsCLs6uLm8XcQbSAvKhaoVT5dx81eb9IjOTmhUMe7vV4fH8rujhNLeFg1aPOftzSBqrbuKSvF8tpPrS9c7fZAPFIaB1AM9kuhHAXMXvdm/D2mBI7Xg97KQNkunSnu1o9mcuzLC7Pv/bFw864ZBI09o0egNo6tB9pH0hxcNfiANSnyz1NGSlAKVxvX5K7Ywn4iAPPzhDKfA1H1ayTcX7HN6N+4LQc/d0rWF1V0oXy7SSdLSw3JcCkr//oSRrYwQ9R2WyasZNzOz1CxSgwojbYE5GOLdU6Stx6n4Ucj2xlFqJ0RUa1RqDdxDH3xh8bkApF74/dyoJMrv+vAUYzRlyO0NjD/9Wb5CLrH/RzO+MKPYKYK80vDV5XPiuRWa3K0wCSbJHbF1D8NZXUJAYf4Kn05kOnNSUgQrkujrF9LG15I6t1lwVlH7LYnbrpchMwrN4RyaykTsYHm1+ICU3xOlEyEk6FftdHuD8QjDeBJic9uKfWPVH2wYBjFrNi4f4Vw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(366004)(39830400003)(451199015)(30864003)(83380400001)(36756003)(66476007)(316002)(86362001)(8676002)(66946007)(8936002)(4326008)(38100700002)(5660300002)(52116002)(44832011)(38350700002)(478600001)(26005)(107886003)(6512007)(66556008)(6506007)(2616005)(186003)(54906003)(1076003)(110136005)(41300700001)(6486002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CVzn1KmKVH8MvGqrsIzV0QEvOBTwskkw1BHLgJuSSL8d8gcVkJZ/kDsGjD3G?=
 =?us-ascii?Q?C4qeO4GhxJJmqPGQ9px5eBCbXDtzk7tb3OoO8+JagT9Pyirhe7uvLYbYWong?=
 =?us-ascii?Q?ZzKi/EeELb5nrcpPpa1zUd+wp1lCqW9lop8qdEMLmNWKiB5Sa62sZthDMeom?=
 =?us-ascii?Q?WDGdrnG0KEkD4VBZdO4HLRrKhutpRExYFoKl+cqqrFsI2Nr4vTQHGYjgPVej?=
 =?us-ascii?Q?YpXcj6WCzn4nN7Rgvzsehsvj46dR4H4NYSoeuaQnF1ljeVFAlcj5i3Yb7NqS?=
 =?us-ascii?Q?7DGDK3+ZF3xlz4XkKGhTrguYQQtJMCzO4n85nb7cGTiXKa0/DERhRPzDTwWQ?=
 =?us-ascii?Q?/5F3cjS+hy093oL0N5uyZaJHsDhR7FXNFPdAi3wPdXy5rZADKrESfmWQDKwQ?=
 =?us-ascii?Q?HhH7z+1Cx6HYW5B0eO7v4OZuVRv4OD3081hs6/M2fee/ciugSWhp/2kcamhe?=
 =?us-ascii?Q?Gfxhfb6ZiJvMI7vF5rIy/hOQFrFmTc9C0+R9he4iJ0PT3PPab4V1oJE1wTBF?=
 =?us-ascii?Q?GNLWd6mdc81v4GY0gFDuYQJhPjqVKxq/4UgUafRNby6PxT3kgeqjG+NcgI8a?=
 =?us-ascii?Q?KKHoxfaFgCNAWrZNnOboh6+/32TUgE170V5iYh8IQ8gBpWUYUWBMn7AOZCfL?=
 =?us-ascii?Q?VEZ5FbEaYmOzWvp3ifBIZXA8CKMvoedwVZA4JGR6M93RckHS0DFVG2X/JZ8a?=
 =?us-ascii?Q?fAVux8ZM4piSAXk89C195mJ5J8I5RI1HxRfpYeM+760YsfN533ZLX8or23pj?=
 =?us-ascii?Q?xwFQsd3v4JlCcW0LiEiS01MUSXjOAPXIyiAr/M4BH3BbzlksAWc0u8wCqlM2?=
 =?us-ascii?Q?8pTZ3/S3EPoZ/RhJmwGo4WolM8ihbFJFeSvNVOZQ1Pa3oHgIlMYtZUnRaxi4?=
 =?us-ascii?Q?DvApwk7NddC7vUPsw4oeYJgnug7ylV6rRRqhzdWNXfauIhwzx5Pk0Xc1LuyD?=
 =?us-ascii?Q?hIzv2hBpUgRvTY+EIiDuTw8yl2nawCnwidyPbrTwk1lsky4u78jHXT3Op6mE?=
 =?us-ascii?Q?/YY5KcgWz72OPxQ1mKl9Qpfr3wTMELxX/Gh5dn06SL3EnnvIE4ujOZ1MeS44?=
 =?us-ascii?Q?Q0IqL+sU0kbNcTstePnvF8BG8SB7b2OP1xCe+Feejy6JXxZe1ycyyzzT0RjL?=
 =?us-ascii?Q?VWgnuxYXzkQqXF8nsFVzDX5X9o31Pm6JV2UrCLUzsqBlgM/LsrSTFYqRylAw?=
 =?us-ascii?Q?lxkqWi846aQdgDtH+8ZaWkj8ckUXxsWQQ+BeFBWZ896W4Cpu+1vQmbduKkq5?=
 =?us-ascii?Q?AvJ8kFfb292q+DEF8Lw+IyOxYq0yZGVCX4Pidkap999hWcMq+DjnJAUlTIyP?=
 =?us-ascii?Q?E83QMHgxXlmvsKbrWBhoi5NORf9xzrSvU6fbWHQwDA1AiIPzFbu56x9Hi5CP?=
 =?us-ascii?Q?c0/bhBLai82TjOor2R5RMikAuzJx4j0AWQxVR8UwRHsMGDbtvb5mnaVryHLE?=
 =?us-ascii?Q?zGdXTa7ZLR70oPZZkzyGQ+XCrvQHnEGucFsNhSHWwBN1vUNd5IfxnlcX8ooD?=
 =?us-ascii?Q?ToSaZhqnGY+lAdkvrntoHzkNZ5ziRqCoa0ldt/wweERF0EUH3gjGvLvBWo6n?=
 =?us-ascii?Q?hWRW/TK12o+qBgs2cHCIcMzp+V90skVBUTvqLpv1gv71MN+VDZ08dIq7giwE?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4796
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hui Zhou <hui.zhou@corigine.com>

support ct nat action when pre_ct merge with post_ct
and nft. at the same time, add the extra checksum action
and hardware stats for nft to meet the action check when
do nat.

Signed-off-by: Hui Zhou <hui.zhou@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 193 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |   6 +
 2 files changed, 192 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index b3b2a23b8d89..235f02327f42 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2021 Corigine, Inc. */
 
+#include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_ct.h>
+
 #include "conntrack.h"
 #include "../nfp_port.h"
 
@@ -56,9 +59,17 @@ bool is_pre_ct_flow(struct flow_cls_offload *flow)
 	int i;
 
 	flow_action_for_each(i, act, &flow->rule->action) {
-		if (act->id == FLOW_ACTION_CT && !act->ct.action)
-			return true;
+		if (act->id == FLOW_ACTION_CT) {
+			/* The pre_ct rule only have the ct or ct nat action, cannot
+			 * contains other ct action e.g ct commit and so on.
+			 */
+			if ((!act->ct.action || act->ct.action == TCA_CT_ACT_NAT))
+				return true;
+			else
+				return false;
+		}
 	}
+
 	return false;
 }
 
@@ -66,13 +77,37 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_action_entry *act;
+	bool exist_ct_clear = false;
 	struct flow_match_ct ct;
+	int i;
+
+	/* post ct entry cannot contains any ct action except ct_clear. */
+	flow_action_for_each(i, act, &flow->rule->action) {
+		if (act->id == FLOW_ACTION_CT) {
+			/* ignore ct clear action. */
+			if (act->ct.action == TCA_CT_ACT_CLEAR) {
+				exist_ct_clear = true;
+				continue;
+			}
+
+			return false;
+		}
+	}
 
 	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT)) {
 		flow_rule_match_ct(rule, &ct);
 		if (ct.key->ct_state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED)
 			return true;
+	} else {
+		/* when do nat with ct, the post ct entry ignore the ct status,
+		 * will match the nat field(sip/dip) instead. In this situation,
+		 * the flow chain index is not zero and contains ct clear action.
+		 */
+		if (flow->common.chain_index && exist_ct_clear)
+			return true;
 	}
+
 	return false;
 }
 
@@ -168,6 +203,20 @@ static void *get_mangled_tos_ttl(struct flow_rule *rule, void *buf,
 	return buf;
 }
 
+/* Note entry1 and entry2 are not swappable. only skip ip and
+ * tport merge check for pre_ct and post_ct when pre_ct do nat.
+ */
+static bool nfp_ct_merge_check_cannot_skip(struct nfp_fl_ct_flow_entry *entry1,
+					   struct nfp_fl_ct_flow_entry *entry2)
+{
+	/* only pre_ct have NFP_FL_ACTION_DO_NAT flag. */
+	if ((entry1->flags & NFP_FL_ACTION_DO_NAT) &&
+	    entry2->type == CT_TYPE_POST_CT)
+		return false;
+
+	return true;
+}
+
 /* Note entry1 and entry2 are not swappable, entry1 should be
  * the former flow whose mangle action need be taken into account
  * if existed, and entry2 should be the latter flow whose action
@@ -225,7 +274,12 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 			goto check_failed;
 	}
 
-	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+	/* if pre ct entry do nat, the nat ip exists in nft entry,
+	 * will be do merge check when do nft and post ct merge,
+	 * so skip this ip merge check here.
+	 */
+	if ((ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS)) &&
+	    nfp_ct_merge_check_cannot_skip(entry1, entry2)) {
 		struct flow_match_ipv4_addrs match1, match2;
 
 		flow_rule_match_ipv4_addrs(entry1->rule, &match1);
@@ -242,7 +296,12 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 			goto check_failed;
 	}
 
-	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+	/* if pre ct entry do nat, the nat ip exists in nft entry,
+	 * will be do merge check when do nft and post ct merge,
+	 * so skip this ip merge check here.
+	 */
+	if ((ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS)) &&
+	    nfp_ct_merge_check_cannot_skip(entry1, entry2)) {
 		struct flow_match_ipv6_addrs match1, match2;
 
 		flow_rule_match_ipv6_addrs(entry1->rule, &match1);
@@ -259,7 +318,12 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 			goto check_failed;
 	}
 
-	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_PORTS)) {
+	/* if pre ct entry do nat, the nat tport exists in nft entry,
+	 * will be do merge check when do nft and post ct merge,
+	 * so skip this tport merge check here.
+	 */
+	if ((ovlp_keys & BIT(FLOW_DISSECTOR_KEY_PORTS)) &&
+	    nfp_ct_merge_check_cannot_skip(entry1, entry2)) {
 		enum flow_action_mangle_base htype = FLOW_ACT_MANGLE_UNSPEC;
 		struct flow_match_ports match1, match2;
 
@@ -468,6 +532,12 @@ static int nfp_ct_check_meta(struct nfp_fl_ct_flow_entry *post_ct_entry,
 			return -EINVAL;
 
 		return 0;
+	} else {
+		/* post_ct with ct clear action will not match the
+		 * ct status when nft is nat entry.
+		 */
+		if (nft_entry->flags & NFP_FL_ACTION_DO_MANGLE)
+			return 0;
 	}
 
 	return -EINVAL;
@@ -537,11 +607,37 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 	return key_size;
 }
 
+/* get the csum flag according the ip proto and mangle action. */
+static void nfp_fl_get_csum_flag(struct flow_action_entry *a_in, u8 ip_proto, u32 *csum)
+{
+	if (a_in->id != FLOW_ACTION_MANGLE)
+		return;
+
+	switch (a_in->mangle.htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		*csum |= TCA_CSUM_UPDATE_FLAG_IPV4HDR;
+		if (ip_proto == IPPROTO_TCP)
+			*csum |= TCA_CSUM_UPDATE_FLAG_TCP;
+		else if (ip_proto == IPPROTO_UDP)
+			*csum |= TCA_CSUM_UPDATE_FLAG_UDP;
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+		*csum |= TCA_CSUM_UPDATE_FLAG_TCP;
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		*csum |= TCA_CSUM_UPDATE_FLAG_UDP;
+		break;
+	default:
+		break;
+	}
+}
+
 static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 					struct nfp_flower_priv *priv,
 					struct net_device *netdev,
 					struct nfp_fl_payload *flow_pay)
 {
+	enum flow_action_hw_stats tmp_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
 	struct flow_action_entry *a_in;
 	int i, j, num_actions, id;
 	struct flow_rule *a_rule;
@@ -551,15 +647,25 @@ static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 		      rules[CT_TYPE_NFT]->action.num_entries +
 		      rules[CT_TYPE_POST_CT]->action.num_entries;
 
-	a_rule = flow_rule_alloc(num_actions);
+	/* Add one action to make sure there is enough room to add an checksum action
+	 * when do nat.
+	 */
+	a_rule = flow_rule_alloc(num_actions + 1);
 	if (!a_rule)
 		return -ENOMEM;
 
 	/* Actions need a BASIC dissector. */
 	a_rule->match = rules[CT_TYPE_PRE_CT]->match;
+	/* post_ct entry have one action at least. */
+	if (rules[CT_TYPE_POST_CT]->action.num_entries != 0) {
+		tmp_stats = rules[CT_TYPE_POST_CT]->action.entries[0].hw_stats;
+	}
 
 	/* Copy actions */
 	for (j = 0; j < _CT_TYPE_MAX; j++) {
+		u32 csum_updated = 0;
+		u8 ip_proto = 0;
+
 		if (flow_rule_match_key(rules[j], FLOW_DISSECTOR_KEY_BASIC)) {
 			struct flow_match_basic match;
 
@@ -571,8 +677,10 @@ static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 			 * through the subflows and assign the proper subflow to a_rule
 			 */
 			flow_rule_match_basic(rules[j], &match);
-			if (match.mask->ip_proto)
+			if (match.mask->ip_proto) {
 				a_rule->match = rules[j]->match;
+				ip_proto = match.key->ip_proto;
+			}
 		}
 
 		for (i = 0; i < rules[j]->action.num_entries; i++) {
@@ -589,11 +697,32 @@ static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 			case FLOW_ACTION_CT_METADATA:
 				continue;
 			default:
+				/* nft entry is generated by tc ct, which mangle action do not care
+				 * the stats, inherit the post entry stats to meet the
+				 * flow_action_hw_stats_check.
+				 */
+				if (j == CT_TYPE_NFT) {
+					if (a_in->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
+						a_in->hw_stats = tmp_stats;
+					nfp_fl_get_csum_flag(a_in, ip_proto, &csum_updated);
+				}
 				memcpy(&a_rule->action.entries[offset++],
 				       a_in, sizeof(struct flow_action_entry));
 				break;
 			}
 		}
+		/* nft entry have mangle action, but do not have checksum action when do NAT,
+		 * hardware will automatically fix IPv4 and TCP/UDP checksum. so add an csum action
+		 * to meet csum action check.
+		 */
+		if (csum_updated) {
+			struct flow_action_entry *csum_action;
+
+			csum_action = &a_rule->action.entries[offset++];
+			csum_action->id = FLOW_ACTION_CSUM;
+			csum_action->csum_flags = csum_updated;
+			csum_action->hw_stats = tmp_stats;
+		}
 	}
 
 	/* Some actions would have been ignored, so update the num_entries field */
@@ -1191,6 +1320,49 @@ static struct net_device *get_netdev_from_rule(struct flow_rule *rule)
 	return NULL;
 }
 
+static void nfp_nft_ct_translate_mangle_action(struct flow_action_entry *mangle_action)
+{
+	if (mangle_action->id != FLOW_ACTION_MANGLE)
+		return;
+
+	switch (mangle_action->mangle.htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+		mangle_action->mangle.val = (__force u32)cpu_to_be32(mangle_action->mangle.val);
+		mangle_action->mangle.mask = (__force u32)cpu_to_be32(mangle_action->mangle.mask);
+		return;
+
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		mangle_action->mangle.val = (__force u16)cpu_to_be16(mangle_action->mangle.val);
+		mangle_action->mangle.mask = (__force u16)cpu_to_be16(mangle_action->mangle.mask);
+		return;
+
+	default:
+		return;
+	}
+}
+
+static int nfp_nft_ct_set_flow_flag(struct flow_action_entry *act,
+				    struct nfp_fl_ct_flow_entry *entry)
+{
+	switch (act->id) {
+	case FLOW_ACTION_CT:
+		if (act->ct.action == TCA_CT_ACT_NAT)
+			entry->flags |= NFP_FL_ACTION_DO_NAT;
+		break;
+
+	case FLOW_ACTION_MANGLE:
+		entry->flags |= NFP_FL_ACTION_DO_MANGLE;
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
@@ -1257,6 +1429,13 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 
 		new_act = &entry->rule->action.entries[i];
 		memcpy(new_act, act, sizeof(struct flow_action_entry));
+		/* nft entry mangle field is host byte order, need translate to
+		 * network byte order.
+		 */
+		if (is_nft)
+			nfp_nft_ct_translate_mangle_action(new_act);
+
+		nfp_nft_ct_set_flow_flag(new_act, entry);
 		/* Entunnel is a special case, need to allocate and copy
 		 * tunnel info.
 		 */
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index beb6cceff9d8..762c0b36e269 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -103,6 +103,10 @@ enum nfp_nfp_layer_name {
 	_FLOW_PAY_LAYERS_MAX
 };
 
+/* NFP flow entry flags. */
+#define NFP_FL_ACTION_DO_NAT		BIT(0)
+#define NFP_FL_ACTION_DO_MANGLE		BIT(1)
+
 /**
  * struct nfp_fl_ct_flow_entry - Flow entry containing conntrack flow information
  * @cookie:	Flow cookie, same as original TC flow, used as key
@@ -115,6 +119,7 @@ enum nfp_nfp_layer_name {
  * @rule:	Reference to the original TC flow rule
  * @stats:	Used to cache stats for updating
  * @tun_offset: Used to indicate tunnel action offset in action list
+ * @flags:	Used to indicate flow flag like NAT which used by merge.
  */
 struct nfp_fl_ct_flow_entry {
 	unsigned long cookie;
@@ -127,6 +132,7 @@ struct nfp_fl_ct_flow_entry {
 	struct flow_rule *rule;
 	struct flow_stats stats;
 	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
+	u8 flags;
 };
 
 /**
-- 
2.30.2

