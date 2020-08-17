Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77408246768
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgHQNeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:34:17 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:61358
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbgHQNeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 09:34:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nrd7zHXumf2J5e/YaoG3QWi+uql5TOUOGlak0eJOWBAuhFoEpyWMrx7WcYjzB0NeJJNp/EjiWrR85wDvHw/G12y62/giexvb4iKPblPtPSxRFfo6OG1/G6ATLv2uRLWJ5VbeP58GQpAxXy5V/OSHSh51JOiaGcrDN22wnliomOUbjzdCurS9uFg6GHLHN0btQ34nrISOYnfBX0uxf5hkfmrzrbU/TRTmLogUgQYBguBdT/0rIuXM3vO2U3P2clKQpL9UO7fa0LLmKI43wMaM/6a7oCPewHcBjZMQRfZzOAKCNGXjLPyQ45sU5r6ikDhIZf78CmIHivAbON+lYDqIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQ6fpcUWv1j9sSqLuRBFbTNkwtOoS4StR3EpAGvx/uc=;
 b=nLFI4Jvfgzw4q7VmgGu0Y9dxL1Ozl2MyJzvkZKthrrwJvo63pwODVpfD1CoPTm4bjUHzlPpTrE9DYNssow6slMqRcbIDi8g2GjvlyV8x+T8pA/1y8H/oMQbriQsZ6k7wC/wtZSNEO8puUAiFPA5oHB36v8ovSp5u7SH47VkfKqIDRziES67cJGR0g9jCID4PXxHOAfdYJKWjR/f9NveZiH9vNHE7afEWjPyFRwlKswT3rUs/pd6B0rZokq0n0FGepO0Ekl5WTv19o/8WSnB4AUsBT2BS82IsvffYqesJ39G7buWZRlIYbfOCKwtI67T3+UXKcVHZHVYdZtIEr2MRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQ6fpcUWv1j9sSqLuRBFbTNkwtOoS4StR3EpAGvx/uc=;
 b=SkqL4yFkPeq93FpkU+vBMO1DZEY+L4dbp+hf2ZBXkEVyn6gUSQZ9x6fdpckHPmhcUnxhUYstczBjHb+XFUhQ4LZO3SZrPb9LvaPG/6UoxIT0ls/Ql7z4+k6diJv30HSzzg88H2WqwH4zrE2TO6a8G171x0PBQtH+gqK9JnGiFIU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5640.eurprd05.prod.outlook.com (2603:10a6:20b:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 13:33:59 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.028; Mon, 17 Aug 2020
 13:33:59 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2 1/3] ethtool: Fix preserving of wanted feature bits in netlink interface
Date:   Mon, 17 Aug 2020 16:34:05 +0300
Message-Id: <20200817133407.22687-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200817133407.22687-1-maximmi@mellanox.com>
References: <20200817133407.22687-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0069.eurprd04.prod.outlook.com (2603:10a6:208:1::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 13:33:57 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a712769b-e8c9-4394-a0b8-08d842b2322c
X-MS-TrafficTypeDiagnostic: AM6PR05MB5640:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5640D90F3F5D521C681A58EFD15F0@AM6PR05MB5640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0fp4HQp9UID4UslB9lUmvHHl3s72x5T62HSK3lEw9c9qcqsM9DrrCxEVGBkCb3j0m4ys5b5eBuatT21NzJoOA0S5i4xTEO+is7F+vBe9+KKG6xwEl66l1DTFfOIUGuBVEi9ZozunQUF3/d9BNis7Hsln+CugayIMA9ukQ5thRjgNwdC6CmooaprjBjk4SVFcOn+zmmmExBH910BzfB/9RQAYrrDMHYUR5wL7Bu/JDQFW5pgIw5OTZjpiYiot4Pcvd7/1D1Yh11x54R070jrB/V0hENRA+yEkTGh/5ztdENNySr6Obxl8ohZHKDaqoOv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(107886003)(66476007)(66556008)(66946007)(6666004)(8676002)(8936002)(52116002)(478600001)(956004)(2616005)(26005)(110136005)(6506007)(86362001)(316002)(6486002)(186003)(36756003)(83380400001)(6512007)(2906002)(4326008)(1076003)(16526019)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lScd4M297wxhlpg8nRk4k4M+zYxVolAklubFyv3WlfOEp2wbweqcwuyHW0Ka8WZXiDxUlyHm+9N98AMKpLdNci+8Epyb+1vMGvSI+E1ONMRN6cxYcNsEwoPKW7ytx5r4wnwRvXRFCy/0Zpp+Y++g5eGxQoo9S3I+so3cKyISmkjWp9KB7PHleYbctu4iCX/1uw39/3f7rEu+WdLE48cpHaIo+FWQW1RFPo/RbptTfjt2r/TsBCOCbzCi3ST8IdJcV+pjkkdHV8Fi9FJnQaQj/3jHuN6nkueJyLoNYDYVeVqgROdk83DNCRgsm4G3h7B9T02QK9UfK5MLGjb59tpmy7KyA75xXKkzvaRFcsqXd1giLpwxa78a7je0tlPkHZNSfXkW86eBGYDG5WFTkpiT+YomCz+wjX/4uQb+VW6UiytzDp+rehqymzq5hvRT/0XzyUM1p6ABsHVSfo9DQ+iKCAPPpWPIVtyLrnAgCK31GIKBEPUD/HCjmrlaB9C+PXMrdOFW0LLkiJy9hbwtqoIr2Cit7BhX76nq0fu8+9xZt4zvqh0p7hk+qtV1BfhBsjsmzjxmfMlp1PSGmpyCyy7a27Lc4JnLlJ6d2NqWiaQKvhwwGJ7NytYJTpK66j+ltJkPPAruOfgG4c4PI0RSo+i+7g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a712769b-e8c9-4394-a0b8-08d842b2322c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 13:33:58.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3khHmDOI3xxFexNFGEX2hgiO+YGqBFXVzh0QHEJTqsIJtMYN3LHlzyUJ87JcycRSaJmIpypwpCBHt8adYSdzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ethtool-netlink calculates new wanted bits as:
(req_wanted & req_mask) | (old_active & ~req_mask)

It completely discards the old wanted bits, so they are forgotten with
the next ethtool command. Sample steps to reproduce:

1. ethtool -k eth0
   tx-tcp-segmentation: on # TSO is on from the beginning
2. ethtool -K eth0 tx off
   tx-tcp-segmentation: off [not requested]
3. ethtool -k eth0
   tx-tcp-segmentation: off [requested on]
4. ethtool -K eth0 rx off # Some change unrelated to TSO
5. ethtool -k eth0
   tx-tcp-segmentation: off # "Wanted on" is forgotten

This commit fixes it by changing the formula to:
(req_wanted & req_mask) | (old_wanted & ~req_mask),
where old_active was replaced by old_wanted to account for the wanted
bits.

The shortcut condition for the case where nothing was changed now
compares wanted bitmasks, instead of wanted to active.

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/ethtool/features.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 4e632dc987d8..ec196f0fddc9 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -224,7 +224,9 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
+	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
 	struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1];
@@ -250,6 +252,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 	ethnl_features_to_bitmap(old_active, dev->features);
+	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
@@ -261,11 +264,11 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 		goto out_rtnl;
 	}
 
-	/* set req_wanted bits not in req_mask from old_active */
+	/* set req_wanted bits not in req_mask from old_wanted */
 	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_andnot(new_active, old_active, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_or(req_wanted, new_active, req_wanted, NETDEV_FEATURE_COUNT);
-	if (bitmap_equal(req_wanted, old_active, NETDEV_FEATURE_COUNT)) {
+	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
+	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
+	if (bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		ret = 0;
 		goto out_rtnl;
 	}
-- 
2.25.1

