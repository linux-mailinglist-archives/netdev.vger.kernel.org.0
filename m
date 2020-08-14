Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCFB244A3D
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgHNNRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:17:06 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:30530
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbgHNNQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:16:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lccLdSFtw1CTGt0iLLaTT5UcoL5G7PVUBKVTjsSnrI3BEXXdpsHKci9B3OO1MdABvXeXTxSnQ1MlrePsxV6DfNgTv9CAvIE4xRR7HeeDngVL48PVRfwr9Wb2cr2FM/0Wibt1Ai9moj2xU1erXYEyVBaMTKM6cqVT95Hi1XI7RD2clfcxU0v1UAEEVeKRegjCAgdOPcOzCIwU68nKZD1jA/epN+NR9RQoRiOOu5oynk5tAj0k0pS2GbSEFY0BgtKOFbhhZsB0VZYG95VrR5mT78MZhQDQU3Foz15OV7rNrLNstspStBOS4OFI6FiBonxfP6nLdFQClf5uf4HicUe/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V31HHsGQ9mWGB4yXyaybpc3yldoBHNuvYXlentgiIAg=;
 b=jv8ym3jkXRh9u6jwvTSICNpqfg+23v6sQy7JDg7HiielM/461M7KbvBpFy891OiZNPcwt2ODvxKFLyKU3SnudHWYVBfZwegw4FMlrDuSJ35lR7Ldxm477aTcuF1zQXoh+o9l60jhy4rm1hGZRvJzRIH67hvhULfPwsW88a5mYw9mMQ/i9qYzc0uZmN0+iCkoVYHNgXSF8OLa/HeV8B0h2X1jg/N3cQgfE2eISdQGYx4zA+3TvFVPXFvsu1xDhFNeWgMuH6bqrLDtjOyyj9UFNY0rvGUTa98ySiqY5QKTBWzKquG+h8eqJIbdB55dDOWSeFzkCUUGxK0bmoELuQyHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V31HHsGQ9mWGB4yXyaybpc3yldoBHNuvYXlentgiIAg=;
 b=kEkxXoCzVNDMkbiFLnbaXFOhes4O8MI03u1bIgpxrYYnxqioOKbH0gXeV8FSfotv00P4kvz25puCbJ9rhJopINHXLb9psD0Z+iHHPR9qmKoTyB+kX4m7nnKjOp+GFMXT1QGkC2gNL4UATvckWSxwR9y/5SfPO5NBA/4PhfxSIqg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:16:41 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:16:41 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net 3/3] ethtool: Don't omit the netlink reply if no features were changed
Date:   Fri, 14 Aug 2020 16:16:27 +0300
Message-Id: <20200814131627.32021-4-maximmi@mellanox.com>
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
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:16:41 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22b0c6b8-3025-48cf-e994-08d8405448cb
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB360575B72966D9B591EFA6B4D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kUc+7b96uw105I+ePgk7zqCBAluiABZe1avrtbbar34mT5frvjtPusAum3JiGxai7VDjyouyX9ter0uL8pC+qaMkPNxq5e3NpIxnYt0Yap3hJlMjB0Rj0qaod1JkWXOoC/XlZ3kiA7emz7ZSYL8bpXjtVWBAfKIjAu6EBIyobJOMU1eY6pt2H3Hb+YFvbWmdqsb8Mta0HL37roIPje4aTeW97bHI+T7LNV475WHF1vpd8+frpmYVZs8mqgY7/RRA8a+QR2Xs4L5dY0yF6NrTL9FsxNrXwS/rGQCL1RUfWPFX0d1tLCXfFpDbKt0EWY4C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YRMj4G0npgJq0IwFWBvIXkPcgOsNgeCUAQHMxs8/Wkjs/Bomn9pZGGKDMNZwwWCkKSjfqlgE2Wzo3qO0Gbt+BqZUIFgohzCCfXHAsc4YzjKVoQlb5tIsQCfmvvq2ntch5BNDarAgqKDK/DmQlpHxjb2d8/cs/xihoiUFwY51xwXAU+dhuIA3It/7rCayrTgma1IXPiWJB2X/JTDXjltVkOEZA56eUbIgHr73sPgV1Yw+xBvu1ornDGxtS/EEqI1gE5ebNZ7U/7eLYEfv40ABWQqsUIiC30KnBWXVdUUosAKQqr7IwpWeU4i9s+ub3kJ0wjcphWEbgEvsI0fNavUEkv4Eh23gX4fGObTTCmY3Y9YoxziR4f/kffeV/EdJEnOTN6TjYisDJZR2EwTF4QcLOtxCqSPV1OlrT1UNJUAmEBIG9CrRYziBGXeSiF0MFWzhpNNSPWG6jyxurfb0KTymzmg8iJR0UG84QFwtrShBYgR2+vK5SG6RcOPy0XDvuSq4Lp+kO64mOMVmBTWuMy71aXvOwP8sM4/QgEyA72DYeFqQviNur64DV8ev/ah5zxpnYmpSReJRYxey6INZK9Bv4vnmzjxU0f/nkBeigR6eU7k/c7NkKBTMBXfBdw58c593bohZUcjcmQjHzNntaLWT4A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b0c6b8-3025-48cf-e994-08d8405448cb
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:16:41.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LPDPVzz+1CK51eOmUoh4AFjSrvvzLsEIyqp0YqtanJ2kUwxv/2LgBebJtK1mmDcneDjOqNCG1Zgh67C0h6mqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy ethtool userspace tool shows an error when no features could
be changed. It's useful to have a netlink reply to be able to show this
error when __netdev_update_features wasn't called, for example:

1. ethtool -k eth0
   large-receive-offload: off
2. ethtool -K eth0 rx-fcs on
3. ethtool -K eth0 lro on
   Could not change any device features
   rx-lro: off [requested on]
4. ethtool -K eth0 lro on
   # The output should be the same, but without this patch the kernel
   # doesn't send the reply, and ethtool is unable to detect the error.

This commit makes ethtool-netlink always return a reply when requested,
and it still avoids unnecessary calls to __netdev_update_features if the
wanted features haven't changed.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/ethtool/features.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 6b288bfd7678..495635f152ba 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -268,14 +268,11 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		ret = 0;
-		goto out_rtnl;
+	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
+		dev->wanted_features &= ~dev->hw_features;
+		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		__netdev_update_features(dev);
 	}
-
-	dev->wanted_features &= ~dev->hw_features;
-	dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-	__netdev_update_features(dev);
 	ethnl_features_to_bitmap(new_active, dev->features);
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
 
-- 
2.21.0

