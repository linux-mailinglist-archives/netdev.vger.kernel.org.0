Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA6544548
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbiFIICf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240457AbiFIIC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:02:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A59D63C8
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:02:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+98m7hV820zOyrTLwkv1vr9ek00VjN3jjRpUBI2PnxWDZwIiSgj36lRo9T45yVCtmAxHEB5J7F2v6joWnS5DeFrBkTdfP4VndDJ6qHThVZOuaZ7lFb+3o0mlVlIxZ2cpSZuKbLLgVkbCqgfZ/C23T6YLk/ShgkhLCizphiBNVfMIGll8X+sTA12PN7fGOSf7spp/n/mkrVoGTP9yQdiiXMZYfR1Cv3gg/EOpcw7v503VPoeKC0TEe7oeXSjeE1Wm99jslo7r8iU0dd8tf8jxf834+uNVVUx185uwdXBwe6popNB/GdH9Kr+lrM5ovMPVYWOH2G7zHJ2cqxyQNdu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwDaRjXbCndo/vf01CkC4ZyDfoUW7FWks47FvHKmA7c=;
 b=Qh4XG77XWSbrphzJksusLo4QJ6CfYVtE2HdgyTcfIkqARvDfOnAEEoqSD9+FqoRwnbfLa8NTeJ2/xVVBlzFSd9/nswBVrTT45j1WydZqKlgFiC8fnULCO9NBEwhLmJgZONTz36UZlCNUD37RlLt6SoviYPnNQca9M9eOapTPCIxtWliTuyHHflqUpYmRqnn/6tdDfQsbbxay8LeUUrW1Pc0wZhs5guXwX10XlChaQWBkCZ2H+2Lp1gL6KoWfLx5FzI7NDqKd1aoY+y/H/Keb6K0t4yBYj15Ffb2JJd0IVgPFBBRr4stSyo82pfBPrrvCnfGwYHIHLjeEasYea90cgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwDaRjXbCndo/vf01CkC4ZyDfoUW7FWks47FvHKmA7c=;
 b=dIFzvViIcJaGQW61f50J0RlkFQFrLeyXW9qssNn8TFcAY8zXK2ZPXvQ/4krck+t642KtaWTSfdG7DAGd9cyDGWpW4KfRBb84y6xQUwaiERIsc6j5TIgpnipSoSOWjp7cQtJniTjZdTYiBsJbbNv0Vz5rnZ/3tOEJnKj2fmUYqc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB1915.namprd13.prod.outlook.com (2603:10b6:4:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.11; Thu, 9 Jun
 2022 08:02:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Thu, 9 Jun 2022
 08:02:03 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: flower: support to offload pedit of IPv6 flowinto fields
Date:   Thu,  9 Jun 2022 10:01:36 +0200
Message-Id: <20220609080136.151830-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1e36335-127a-41bd-d4c5-08da49ee5708
X-MS-TrafficTypeDiagnostic: DM5PR1301MB1915:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB1915C2B7B903E43301462D56E8A79@DM5PR1301MB1915.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDYcxEVO+iM2ilkh1Ucqd1TBxPPoE83rUKTK+r+u4ybDGmG4l1eQyHsAWnuUddVqEjt2McbdTh3NEnIvRla2RLaDW14OnAlgg7zoH5IeWtxbgBL3wM8/BiTTEV4diFsCbtuoa5GtstQflI+iXGcON9cHjOJNoHxTcyoOyQZtINv9qLm0GFJFwSpDl3SONifM8z5hmacACKehAuGEO6Nl5FVNZSnoaxWt0kJRqQGu/JFoypMYpeXBKaOpNMpHjYaBichZ+namAhExT0SVf/Nk6nXOamkrGid9KHf1Mw4q1vHtQvRm4AwOpV0VtWBJ/QBubM50zjRKnNEC+kQFidOQ/EuYGZBkyWV/4Zve7AJVOX+nIIpoR9pF1upy6KpVMwwM7Qw7uHK9yl/s6Nrcii24tfyuiGYuwupOpZfXmrQwF8/vW9QLjpC14FvggxoMTt3xAIg9cMpnwZWYkefLplaOdck6j7cKP+5hGtNETJDdQn2f+Fx5hij8mck8f/K6ZEB8tQfWXtXC1hKK2Cx0GphGqIrMaAM54mPJLZr/VXDXgnv74UuPpr2mo6UeOWx3ra1Z2fjzZxby6Bws6FvwwYC2spLtNe1Dp32yZeS1V+0si6crp37WFFeKyZp3q3UBBY6i3QY0p2YiSw0ZKh/UQqk2z2fTg5lKc+fNQAt06+CCEFXsNpVfHL790fWwflvWBrMb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(39840400004)(346002)(396003)(366004)(110136005)(8676002)(41300700001)(107886003)(186003)(1076003)(2906002)(6512007)(38100700002)(44832011)(5660300002)(6666004)(4326008)(508600001)(8936002)(36756003)(6486002)(52116002)(2616005)(6506007)(316002)(66946007)(66556008)(83380400001)(66476007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZagDlXxfj8j66pYCoEvgAmhxHdCjFW8T3HvsNO8uGwYxV2/EUM9AFZQOqkSJ?=
 =?us-ascii?Q?MprgElKnYhNIlN4mg6gQtFnvF3nVapSJhtQJwH5p2gfX9k6Z+JDZy5Di7HTM?=
 =?us-ascii?Q?WHCJOyGd8EVasV9n6kt9PKnn0LvU8UsW96dzX9PpaOoyBGN2Oe+4LszYrAOA?=
 =?us-ascii?Q?s9eFvC9hd2askGFqJZGeQ6SZ00K4X3fyNJU0PWikJtk9iQC1i9+mb5sNT7KH?=
 =?us-ascii?Q?UJY7dv30s66THXVjU+UVOQ7o0P4/p+8G/z4YU4vzyGy8Qfk+ClNJQpVe92O9?=
 =?us-ascii?Q?/tS9rYZCELQicMXOI+n0zc9u5S5PxtDJQ32/GswJb+Sh17V1+ECfDw8F8t/e?=
 =?us-ascii?Q?HX9eAlYjFebgYBjESM2nLDWK8ANipNGf0D9Fscp5ymEeNrhxF/WUzFC5ReBa?=
 =?us-ascii?Q?m0gidwP0r4Put5hy8MPbPTTRS+Wa7U+9V4KZ7u4bELESLkb+8m02zlaWE4I2?=
 =?us-ascii?Q?NnO+wWfFCg4nv1+wXBGG1H77XMTa/Azkq280vRjO8tx0+9U4T/hMri3Dqjgq?=
 =?us-ascii?Q?bhGn05xnu6HRhZZYl6vnZsDPD07GovWxuV2y6rStNwjaxMPHScXnNFmMpwXY?=
 =?us-ascii?Q?ZNfomDlsLXumZNcSeDWHZZWcKSOQElO+rNOUIE0RqkezW0U4RaBbCP29q/9p?=
 =?us-ascii?Q?C9+I8B1XIURNQgtKE/5hDgh+TEk/zDcOmktBEUgH1CkrTSH/4c9ZH1/XPxYP?=
 =?us-ascii?Q?uEznPrym2EuBdK0c+/oZBqjptC7lWT8ezhfJNnaQUoVRZ98rWAP3VInbySPj?=
 =?us-ascii?Q?RBgl7xlxTLPB/xF0preX13skBZ4OvI0JD2ubet0OdMTWGZLX2gaTQvmnDI8K?=
 =?us-ascii?Q?+ZaOzBLIpeKYNoPwhH+bzVMyYalLrVjpzugz1sGpeqsX54L21pXEyOCQws20?=
 =?us-ascii?Q?VplZsUTnbMRx5Z+TFflYSeqfy6OJdwQujrGM81+OaMbDZGcqaTv+YlDe04Lp?=
 =?us-ascii?Q?EtQMVEvEkD4yNIE2pAfNZ3oBZNvX7+t3pmzEKEYisXWwUmApYX9rRwTqab/1?=
 =?us-ascii?Q?i6YF1ZLZ9DSFruv3y/gAx55uPqo1CZtwGkIvWQDsRwzsk/ZG3a0vMeNGwrCo?=
 =?us-ascii?Q?c3T6DKBdDniTYhX7LHg10ai5aRc56QS53llRjwZhwzC7xbQNTD7ay61Zh6y2?=
 =?us-ascii?Q?61TeMMQbhyAJkHFTYguckvel0Mu/VtnEi1ECZo9ut7jlgriA7kzaOjoNvYNh?=
 =?us-ascii?Q?RCcwpUny9vpUOVb4bdrvlm6Xf4+9sMzK8XrrUOiDDCoMVD1G3QEMTyQVRxEn?=
 =?us-ascii?Q?4Imd5yFeT/uEF7PYxL6qiM+G6Ct/mTK6W1GLkG2OGv8VeD6Qd+2W0Ij+/B5p?=
 =?us-ascii?Q?4dCz13+FasSAIVXqmuVjnUtaJyXttb47rFTyV71bmbtDpn3cldDlSNKZyafA?=
 =?us-ascii?Q?LJV8b3CEN6cURkHBVmyOu2RHQdFOVvvbD3xCHbrFtPLbl26ci8BGBtA/FKyu?=
 =?us-ascii?Q?bVAsRZABfVrdRozYE/Q3muGWWOtbVMQz8PQx4EMzul7Ob9Qattsv674hQilx?=
 =?us-ascii?Q?9qiIMaMIS3CWdTxmfleZP/pT0/t3F3h7vCFzrxE3U73jlbag4xJYk1uGhINK?=
 =?us-ascii?Q?+q5CPxYtCztiw4G8XmNbif/sPL5qpypctK8MOSq1XC3ONjthXcPmGX9UtSwJ?=
 =?us-ascii?Q?hVHQh1nFtYCNhNypO4WsPMlqdbCHmKyzUWIAjOyCOR+cEVKdLKEqtciC9pm7?=
 =?us-ascii?Q?MZbuukANav6e3UzqG/rLBIUjeZCYuzfzeRjr3lrWHn2M6rbcw/9MQ2tSCz2y?=
 =?us-ascii?Q?n3x/3NiPckc1S/pp/9KgT7+ogv9k5om/Vx+Y5dl/Wf42nbACBLd/EYb8Uw2X?=
X-MS-Exchange-AntiSpam-MessageData-1: ssJ4K2D+eoJt96vjpT20tD6iAwoW0iHFA/8=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e36335-127a-41bd-d4c5-08da49ee5708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 08:02:03.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/9bTcRZPVRBO6v/Cqhkycnugv3hNC5bKOQpVIwbkjntn+RueWdZhtdpsLL4u8khbxMlns7YN6Qt6yhTMQJ2FaL6VYxRV5axaXt9WKT7grs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB1915
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Previously the traffic class field is ignored while firmware has
already supported to pedit flowinfo fields, including traffic
class and flow label, now add it back.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 6 +++---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   | 2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 0147de405365..b456e81a73a4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -674,9 +674,9 @@ nfp_fl_set_ip6_hop_limit_flow_label(u32 off, __be32 exact, __be32 mask,
 					    fl_hl_mask->hop_limit;
 		break;
 	case round_down(offsetof(struct ipv6hdr, flow_lbl), 4):
-		if (mask & ~IPV6_FLOW_LABEL_MASK ||
-		    exact & ~IPV6_FLOW_LABEL_MASK) {
-			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 flow label action");
+		if (mask & ~IPV6_FLOWINFO_MASK ||
+		    exact & ~IPV6_FLOWINFO_MASK) {
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: invalid pedit IPv6 flow info action");
 			return -EOPNOTSUPP;
 		}
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 68e8a2fb1a29..2df2af1da716 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -96,8 +96,6 @@
 #define NFP_FL_PUSH_VLAN_PRIO		GENMASK(15, 13)
 #define NFP_FL_PUSH_VLAN_VID		GENMASK(11, 0)
 
-#define IPV6_FLOW_LABEL_MASK		cpu_to_be32(0x000fffff)
-
 /* LAG ports */
 #define NFP_FL_LAG_OUT			0xC0DE0000
 
-- 
2.30.2

