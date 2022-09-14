Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12B5B8C80
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiINQJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiINQJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:09:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A931E606B5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6kSOHx1j6bRfzRyCjENnTVk34J3Wx3zCXgCsYlwYtWovrM4iLsLlKxf+4M/tbyP0sPceNYjYewIXkHrDXlaMDWh9wwgdAiK0PJtfLALE73vcMZyHSin8gFyAF5LaD8TEfnFQxjhbrb/hbssvt24xwqU0OFdHadW2zMiZFHOkFRqi6Z8TC1A/GUIsiViGIrwNArpQ0ezivNhDLm7R8DefgLvFmMruV4VvFk49sBi8lq4f8jVMBtRB5Z/ZBEpA5/Bbd0hq/B1UAOZeRQqGyvtoq6vrSmKpcrQo31lQ/DkwCD2A0aS9SUEntAI1EKFJUfpr7S+HfyO3knQIHgMHfXSSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egimI0HY1WfJbytE1qaR71LpswfYK+jUjvhjEfcMeUo=;
 b=VTyRyM/A4V6vg7fXXvJ6ty63UpLG2RYfBZyu/kgCwlfUk1k4i/oEdovVjATLN+9bfw3uIuczumPMAW5xaivxySClgD91Rqg3DQSLWdJqDNIu8GZbvP3gV/fPQtNWj9wAaStQGSPdomLt+w2ycCS5jiWnmnBT356kpJkQoppTNL9PfXoJMbRi3ackSDWwta4d/R24wyrSB21hNUTotga0M55PsNh47aYLiZplIp8bGm4NucHLopDTDwnQ/X8Bi1+KVcDOiMmYNUKJd4i3czvpjnkvWCzEZV8I5zicQr9Mqzrk4jCkULdskqe7SjGqbIZXjDmayZwodnaQT6kO9D9ayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egimI0HY1WfJbytE1qaR71LpswfYK+jUjvhjEfcMeUo=;
 b=UU6s+DLzXhCD1OXiVlqpCQT0jG6wfhi2gJ6SRiY9k82g9k7Cmua7OPao5sOv1qgygyYiKtPNa+aeQ7r8MUbWT4vi4p90JjjbyiZqbPM6Wf0EPVTQ+IdxFjZfkwzSPonsxc3ItSYLUhCdjlwINvAbfYWeSRaHOcJLPRNkCY76J4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4070.namprd13.prod.outlook.com (2603:10b6:208:263::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Wed, 14 Sep
 2022 16:09:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5632.012; Wed, 14 Sep 2022
 16:09:06 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Hui Zhou <hui.zhou@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: [PATCH net-next 3/3] nfp: flower: support vlan action in pre_ct
Date:   Wed, 14 Sep 2022 17:06:04 +0100
Message-Id: <20220914160604.1740282-4-simon.horman@corigine.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: 84cada54-daf2-40a8-2599-08da966b72bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VuQN4BxelE0C/siNNJYremJ9sqNzI6hANYtvgEIf3ftemov1Ql7zZURH2LAjY6/aY6Qwc9vmqDkPiIKzC5hzX4I2YEfD18QCyhexJ/yPbK8b7JVwWfATncvcRk11G3zctAKFwwgILAf8cq9gSLzDGe5Th3Hvjc3rDP0ZMHkUF4KC/+/VmjoNQ5cZBvc2jNtDs6BIiYTSXIn402cG7tpRKBg2TgO/xBam49ZaE71Mkt2E4qj2L9K29ivF4yeOJAbIXg/rxJA5FL9o5shOFpcK9b4+OtoA9mdnFO0NBkgcxSH+PVU0L1aNrCIIKe5JO+KiuNYKr9svhgEZOQleJdNIUoBJvdzfQipcbWva+b5PROdpcjjFCqX0YyAFdHOtZrQPIpGKvSOsRc+6I9xZxbnoav0g++DeWvWyg1xnkmbs5HwUUuUkLDkg/70MKKgvR8Yn4cTjLrdaiWjMorXwUweH2D8D87zaLhiD+kJut/jvboxhsox2kIjub0gxawak9qIg5h3YTcJyub8oZPo+pLzdz+4y91iBImZm36ToNlNVx8YzwMLlUK6mBxuTp22DyDg9svA1OoEQoNMx8DC2jrw1MBLIOdHe1lH/eZWva2XlubyLjtnzaqFM9IcmResOgLLfd8oaRFJpo/1XfYn8KfFD3pflw32xQrskvPcIeNL77TP5WOF7YZyI7UqVj8tjM98TfvvlVSCheWE3v1zhUQt4HKe0VgufvO0PFLENL5ajngRh+KnIBHGNsaSBMH+csrXz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(396003)(366004)(136003)(346002)(376002)(451199015)(83380400001)(52116002)(8936002)(1076003)(107886003)(8676002)(86362001)(2906002)(4326008)(6506007)(66556008)(186003)(41300700001)(38100700002)(26005)(44832011)(6512007)(6486002)(110136005)(478600001)(66946007)(2616005)(38350700002)(5660300002)(316002)(66476007)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CjUw5idSFFfDP76rxrKtdwSVNgZFBXWwC1pjP8O3JOtgZ6laIuoOeqJDyGpv?=
 =?us-ascii?Q?yV7hngLu9dOcn+0OfM98KJ06tL1IgaOdCorO2sGRBM4kbzlVioJqzcoUp6oY?=
 =?us-ascii?Q?ZqpqeWPr6CPKw0J+ujJvKzzOSC7zb1II+F3QfO0KsxxijC922AEk1u9VaIZ5?=
 =?us-ascii?Q?H0/MCijGUzG1CvFM87wFmbdsd7rP8URPbWsXboCb7SwU2pqSoUCZ7j6K71t5?=
 =?us-ascii?Q?qT+2muttArto0jRjxUe5AKztfPXHdMNzzI3jaPBeRxzsUHJXmch7xgR43+s6?=
 =?us-ascii?Q?v9qdlgO9t4rPseprHXUFlcw64MBoM/KN9vRLcIhC1A8U1Bdn+Fi0sxm+9aiC?=
 =?us-ascii?Q?aZBiUdNZO4DB0knAxLO5cjT836BANLgog7fROoucXrAIOq9GSxxuL95BFsoX?=
 =?us-ascii?Q?pffmb9I2XwAUJcQrTGdlK7MmzkPX5eWI+WcBKoagv9aEtBSaSt0AhWqTL31y?=
 =?us-ascii?Q?5z1GFaU/nSmI+hHCmYlAG6x4JH/Zcz2B52euWcTITgERG23SdYRkCgJ1cNu2?=
 =?us-ascii?Q?Ul4Ewi8RdMhOIIdCK4Sx5+PXw+zqZ8XHLBo3HxhI285Fg/EwUbUvLkpprT4n?=
 =?us-ascii?Q?vxIL2SAT+1WRt+RmrvpEi2w1uoY1xwI0g7qG8rm+vb/+YVOkQ66A9R019xl3?=
 =?us-ascii?Q?ai0p2GEUWcxK8kmqeFJ+0LUkOL5UyZVApsvt++xOEkxtigr/Ga8vaLZLrhOG?=
 =?us-ascii?Q?Mq3QhX4RV8e9bUL6sFasASwrKJeG3cqOLXV2N0G0+93lBu9sX5w7W2rpHRXM?=
 =?us-ascii?Q?O0olGc7jhfek6j3KgmSaj8ENSb0wF8y+Zrlv/cOvSnjWm7gNTw9jvSRe2+01?=
 =?us-ascii?Q?VAo7AMVMUw+SKkFNTGaW8olXhTglKLDBVkmapT8DedIBEgSsQHN0oddLM1aN?=
 =?us-ascii?Q?nHnzSejbyt/3o0OL2H0hufvs5x9AJodM4XbUw0zgwnHQgBOZiwnxxeecGZe8?=
 =?us-ascii?Q?G3jM/toZ3c5x9L11hqwrupWvLjbdXQajLhW+t3nKYVSrdDzqFvgrZ2X1PFM0?=
 =?us-ascii?Q?co2ASP7y/MTEqj+LwMVgGRY26dN+wSn6iX9azMOjD07WeHcRblW2G5rrpr3b?=
 =?us-ascii?Q?6HGmJhKR1XvKru3VABZUc/FgZdFqfFCtb1Rzo8TNaHehT0Q4PILbmbkYDJd6?=
 =?us-ascii?Q?FcMFlIOuMpBw0BxYi1U3NqP8CZBHpvbJEopYLdoRUFHcdkl14A/minwy5JJG?=
 =?us-ascii?Q?dXJkhoEs7YgvzFYdbu8fEJYz9QvYHb+2ASVXiyyisdSPz5w4ZBcdPKK1tpKm?=
 =?us-ascii?Q?p14I0DNADHChOR/djFRJvGjiVizbBFYTuVdJ2650dZuU/W9VUN8vkbcd0+Nm?=
 =?us-ascii?Q?hm0ARs0Aa68HDNXuLx9dnUHlH/qV7Qlk035zAiqeMDQuGBwwLdxOWWrXbHe4?=
 =?us-ascii?Q?EWDdtd+D25RgZKeIqN9trkyrpVtwYlkCW9OSzX8tQKJzlyNi8uiK716zxOVU?=
 =?us-ascii?Q?h8ejDJnJ4PYwxElUPNT3x7LWfFz4MBFHRaVVcva85368qEfBWCzdwFPdPxUN?=
 =?us-ascii?Q?w7k3ZIbPBWx+4k/hCKkkGRa4iR9Y46RriXymzVfOVi4Qi6nR9leuk1092ElJ?=
 =?us-ascii?Q?u3nxRXAkEHFMY226evkIucPx206WFuX0P2PMfWy1EUP7dizhFIUNQ1EoIw/2?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4070
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hui Zhou <hui.zhou@corigine.com>

Support hardware offload of rule which has both vlan push/pop/mangle
and ct action.

Signed-off-by: Hui Zhou <hui.zhou@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 49 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 235f02327f42..f693119541d5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -468,12 +468,55 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	return -EINVAL;
 }
 
+static int nfp_ct_check_vlan_merge(struct flow_action_entry *a_in,
+				   struct flow_rule *rule)
+{
+	struct flow_match_vlan match;
+
+	if (unlikely(flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)))
+		return -EOPNOTSUPP;
+
+	/* post_ct does not match VLAN KEY, can be merged. */
+	if (likely(!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)))
+		return 0;
+
+	switch (a_in->id) {
+	/* pre_ct has pop vlan, post_ct cannot match VLAN KEY, cannot be merged. */
+	case FLOW_ACTION_VLAN_POP:
+		return -EOPNOTSUPP;
+
+	case FLOW_ACTION_VLAN_PUSH:
+	case FLOW_ACTION_VLAN_MANGLE:
+		flow_rule_match_vlan(rule, &match);
+		/* different vlan id, cannot be merged. */
+		if ((match.key->vlan_id & match.mask->vlan_id) ^
+		    (a_in->vlan.vid & match.mask->vlan_id))
+			return -EOPNOTSUPP;
+
+		/* different tpid, cannot be merged. */
+		if ((match.key->vlan_tpid & match.mask->vlan_tpid) ^
+		    (a_in->vlan.proto & match.mask->vlan_tpid))
+			return -EOPNOTSUPP;
+
+		/* different priority, cannot be merged. */
+		if ((match.key->vlan_priority & match.mask->vlan_priority) ^
+		    (a_in->vlan.prio & match.mask->vlan_priority))
+			return -EOPNOTSUPP;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 				  struct nfp_fl_ct_flow_entry *post_ct_entry,
 				  struct nfp_fl_ct_flow_entry *nft_entry)
 {
 	struct flow_action_entry *act;
-	int i;
+	int i, err;
 
 	/* Check for pre_ct->action conflicts */
 	flow_action_for_each(i, act, &pre_ct_entry->rule->action) {
@@ -481,6 +524,10 @@ static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
+			err = nfp_ct_check_vlan_merge(act, post_ct_entry->rule);
+			if (err)
+				return err;
+			break;
 		case FLOW_ACTION_MPLS_PUSH:
 		case FLOW_ACTION_MPLS_POP:
 		case FLOW_ACTION_MPLS_MANGLE:
-- 
2.30.2

