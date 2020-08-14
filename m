Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4866244A3A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHNNQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:16:47 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:30530
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbgHNNQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:16:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vq9jDwW/OV7IR4Pg2ZTqHBc0hTEcksGsdhWx7JKTJB96+wHrvLhXOP9lhXYHbGFNR3tKYVDOXvuXbB3WH8C5Y50GLDRS5ypMkT5sA3IYGrwEghlrJ7NL5DUKjJ1JZ3sKk1JMF1SHmd+XJqouTOoVXhRNI8cfMpj0BIEaaBGlnSRuGiMccpFrhD0KQMkDO6wd/uT0Qg8qNs1V2N6pV0bTjVyFkX+Ld6uh0wLDZhyN/COnUjTV3m6j9qC1Q9jXj3+GGNGrZnA2yR0lm0C8iZOqLbi0wGostocRaTYXNMtzthIW1UCFXmPEfwIXlQfc0lY+fl8/8SIpajz3Quf4Z2rUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xunhK4vIKc4e3Vw4a7mftzJWr9FGCtpyHS9dMl5ZzAs=;
 b=LJfVsukhGfVwFhUJnsG0px5GXAF3euLmojA+h4tTL7I2QDYXjoLFKavWbgg4UQEyDlRL8u5eYJQ5VVlt7rzZ6hPvKBq/dKJpIHuFmtHSKSL7zyp+SyRpI58VFKmm+O5dQMJKRw2iGUjfEWnFm6GcHg/vxuFxOqyehTO9PF1nj3hrhG3Y5f+iDDnbg3pzQ7iq/8WylCDgJho5BuC9Q/7yoAWZK3mjF+JpgRmp2mCKnS3pInSFOSC9zG7iwhwFCMTI7aAsPsjI+il8WJTHcH5ZndbnasVATwomUM3iZmZ/bZVLhsGoCRKyUVyTa3axyQM3zMZxoSSnUdluWy2hvbM66w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xunhK4vIKc4e3Vw4a7mftzJWr9FGCtpyHS9dMl5ZzAs=;
 b=ddJUu/dLOARbNADbAqmvjYfQwCih2qQX4ihCN84LsU+0TEqMnPybkSOds/w7hF+nLFwgKXwD30Ujx8obe1DXB6+PSwNwzNG1YNq9O/uxKBbyG76ULNHWxqJepY687lJl8Jk5kIL7pHnTQ8qG2plnJIgvvXANcvO9CV7r8caPBOs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:16:39 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:16:39 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net 1/3] ethtool: Fix preserving of wanted feature bits in netlink interface
Date:   Fri, 14 Aug 2020 16:16:25 +0300
Message-Id: <20200814131627.32021-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200814131627.32021-1-maximmi@mellanox.com>
References: <20200814131627.32021-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:16:38 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5803568-5e0b-4c5a-dbd1-08d840544797
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB36058483587986551C07D094D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: toeAVU5w4jPL93TABHijYwyYS4XM9ROLmJidEUQAdDqAsLYrDM6DnYVUjcEa+/wMGaaKp5yVTLRD3BiYeqAKulUlFkeilnaXG1tg7zLTUqLggkcSisfdRNANQX8/TaMdMLX/AZxohW0FEXuV+ZzOkg+QqOAMX89UngSROwINuLMWWqmSvScedNT7G/F9LM8e/3GHBe1erdAc4yr+slQ4dffGYpq4Xm8khzOQMRHt7KzetoP2Hp33FkWlXpAXfKr4/yF4OeWqXKCPZHsUmsRmFfmyYKn1Xu7gPE5OO0dfZifdq9goBluSpnU/ZrMeNExO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zgjeX0Lh+g4PZknry/TFK0Z5m5DT2isAowPeSbBb+VJjlEJX9JXgA+bqvZt6/QHwD6V/CAYJjXk7jOYEObTqSEob2R/VZD+SBP34PPcV3xy0X2/cKXRiUBKVn/UFyX7+94Xbhy4LFzdlgcKnGS3wT9Z0Rph/CFnQDEVsjlCtkbch6ZZVFh96zRV6+4xyxEDyq8cBHi/FZu6P5fGILNVtuyRWrmiY8I7YoQxDK72ikON1m7reHKwDLta06kVpaGooXxj299x23dC28+cDgmpZEIQ5bM7+7IxtCSqFF9/AsrZDGBT+WEW33+7pMKiUNxMEho6Muu5rbhXuYJ2tHElsKYu6V/SFvCM9EqAR+X3KSFkyEs12yw6bCQB5FZlabSk+6mwdh/Ln+bc5pVlmh/19h3RC5BBOVVnCx+KxWt8tPk2RKt3ySRppg/xgGm51HwZi38W/4RpdBVGJPK4zJzNsvUX0wY0t6jDSLJGezugt5BJvMPRX0ZH6LfRTQsEep9ekcqS4+xpucMP2H+1hICAQucNCsyAtZU4sJHcBmBHZdV5Y+sOynUGlWbhPcT/jTiLFsB1cqlKvAiFPMuPz+3MlUKaNHQ5jKzzBUgfLgc+8QrLRfOk88UbfPmWXHLR6LO3U1JMb6IDquGXq8tzQvkomnw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5803568-5e0b-4c5a-dbd1-08d840544797
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:16:39.8098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RItMmcwqxZr312dp3KiFagODBJdhy3/O9kEH4fgZMBEitEg840dEhkzAswzDHyDQGDr6i6KK3INEP4vEOthVrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
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
2.21.0

