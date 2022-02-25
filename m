Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F24C40D1
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbiBYJA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiBYJAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:00:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2098.outbound.protection.outlook.com [40.107.237.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B61E22B97D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 00:59:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkVvLTUDwiVNLyt1KsHMXUeQNTzakbKcsIeHiKzx6K0BbXaTVNr9riVDEC8LWYg1XNc76cHXXR52uOn2kx9/8IsNLdnQ+6luymebFsQb+UO5ZJ+eeehh70ZfsSGoGy3iqgbWee9/FKGHL7OdHDhKznVZWeUbjGYnWU7zBob9WcCwI7+baHPTms25QJN1mDFQBf7IrMa2JC+y36lSQLZrqkdJEFmddV3cRYh9ZKl9DLdrZXJh8CS+jd6DKc3gz7IZK43nbBlCxBLUWiH8gzQ7QNX2YsSh77cxswJEWsCr013s70wv+wC3IRuPl100+qVHlwUD/DzJ+Jo+0G4B6lVK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ0kZRZ/QiB1Njmif7v+sq2FKLQOqO3kYoLvNBjdwG0=;
 b=bmoTJp0IdisRnUFwopfMQ0QIgMiEb5A1A6XsSyZbSapxER2JgqJK5gRYy93X8IuhH7DEa3PQ5at88HVDTcPgo7juIdZkslUUbv1lkYD5bqVtT7PQ65mb5kDl5OyQA4nXdBUfXQVFwMGkfQKHCGMGSCDL6H4lacFeQ2r8bXaBzwaKOvfV+XrukJxF02BwPNAqL2m+nsL56yHb4Rrd0wEhoa9MPUS7ULmB5hw2yS7OhkUYoio3FTGzEMHtl2JPls+kws3RttGL3QfIGvEDPTl/fcuh94r+Vit7OUV+umRD4SdqwYXhYcd1p8wq4K6vrmMrWb/MevCBCToT65u0TnQC1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJ0kZRZ/QiB1Njmif7v+sq2FKLQOqO3kYoLvNBjdwG0=;
 b=hl+35FulQu0ViFDfrr54uvHxPdLTviSbMlMwHf+5X5PDe5njANx986g2hrPmFzFATjTPegz3+vv4NHAH8wodIGMRFO9qYXcB9v/UsUH5dvDcf8WAZFew9DWXIL5dSejI5UTWeFRpnpKaUHr4WPCgbs4NOgcCYyAdh0S/xEFszZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5949.namprd13.prod.outlook.com (2603:10b6:510:167::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9; Fri, 25 Feb
 2022 08:59:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.009; Fri, 25 Feb 2022
 08:59:51 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: make RSS can be switched on/off by ethtool
Date:   Fri, 25 Feb 2022 09:59:29 +0100
Message-Id: <20220225085929.269568-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4325c65e-90c5-437a-f181-08d9f83d2ebd
X-MS-TrafficTypeDiagnostic: PH0PR13MB5949:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB59492992E872E405D61E1694E83E9@PH0PR13MB5949.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYbVbY7elot5zKim5MJWnhre5NWBBYJ79FpO1Ovpiqbp6JmfX1KYZ0v/2SwIu6fYvHkxOhE7FyKP4GKHzP9WzXVEEb2xEpapi6d5zBiIlFeIHMdkvYaTOpR/gqFArl25J5w1vywzJMcGiR3YtzlFD5XAVwF+EA6LN8KQteBcLlU3LP9yWo9h7JcRrVcrk+QGfN0Y0HP4vqugLQw8u9DaRLcuB80m6yUIzDIm719AkbHO+OhtRJDAlGnV0P0EVr27qWKWDGk5YgkDGEzopUiO13enSjGDtijs5BdWQSKhlpL04NH5fL0JdfHSTUYRa4J8horExwvUY0zdVryLGwyGxJ42lhA9XeqkDPuXNFyBwCB/3xt2Rc/H7tpd+X6fmL3FaB2f84x8mzEr1VaBjTokCoEuZvWyIfkVW5RldcDDPUGcS8GUC4lPjtzcz90XvVlJm0aqFtfjXBhhwiWItQmXU5wcQWW3MzRWP1RSq01QOMNYTH2iw0YbdAdjPWOlA98R/PEApHlrYh4iYJpuIFpYbAwYf9u/U4ZRO9pbJJmJbQnWhOvpDS2AivHldnTRKF5be4eKka0p6wsosivCFnoT91O3EViJqBOwED5QLv4vnFP2NvhzFgzyOcpN4PMlvVj57a70D6Ck++hnhqZ/UkYfs0bx9xpIeNFQQnd4AO179e5tbC8CFhU8rbzHjrMF9/kZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(346002)(376002)(396003)(366004)(136003)(5660300002)(36756003)(83380400001)(44832011)(52116002)(6666004)(2906002)(110136005)(6506007)(8936002)(54906003)(1076003)(107886003)(6486002)(2616005)(66476007)(4326008)(66946007)(66556008)(38100700002)(6512007)(316002)(86362001)(186003)(508600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mw46eRu7JZxBiGfsTbTnKfYR17MNGzCRygNaM3UHxM/oHDNzla1PGz4gQjnz?=
 =?us-ascii?Q?MF7N2yaff/VBlJ3t54bNlvJHuqFDQIY7wlVQJZP/3G6yeOZXL2Qry/0QzjT9?=
 =?us-ascii?Q?Wy9tnppbJk2ldgfs8FMgUwPeHSqHJA/FTlrFAVkIL8i4UZsYIUnpN3rbsisc?=
 =?us-ascii?Q?tPntC/RmJRnPIjQpWy72YR7oOoLyjuZxCLCqK4/MFk2Ni7Dh6sjz6iZkV8qE?=
 =?us-ascii?Q?jX43a2p3ptMwyA3niQXgxvHessk26nJqrXWfO6WaECaS7LonzUjLsB4vaquC?=
 =?us-ascii?Q?ooSokRyqs66RdcAYMstGZ9Zt70QO0mDhUicHe2I1YzsOQMy63ToGGK09ZEj0?=
 =?us-ascii?Q?htVcLmJ6G8wSFcy7ySq14+t5bqlGWXfjwhena0YIJt9to9WLbMHniSYfzP9j?=
 =?us-ascii?Q?ubsmOWgMzewdJN+G2OkayD/CwvYXHRrDYnI0wDwj9P/V+OSccNU/oNfXM3+s?=
 =?us-ascii?Q?5EQdzckQ/vH3KOmlUO26pQPviUNeM2JkEENcjzqPGzUEgCfO77yUNCkJyjbr?=
 =?us-ascii?Q?oAs2dnF22v9ipRtmEC9BUqx2MW2gAcbgQORBZ1Yv69XvNWINL0MJw3jEhyh2?=
 =?us-ascii?Q?asa1v/JS0nBmb5VeR7+2cPpHfiB9SkZ2FogFHbnatxYg2ZuGtSRbewp7kEWY?=
 =?us-ascii?Q?E9J0yrGEl7tqfD0LKqii86Oh1fX2b1Zav2LTusiVwBboo1E78I1bK/CvqTSn?=
 =?us-ascii?Q?H9CJqIh2HBGQmZquMuHnerZVhp5Y5bs+65l8drw++wqA9bfev+bZUAJJXi8V?=
 =?us-ascii?Q?fCdH6RGiOsOMaWTl0474MlfUWBAEZcRNI1PS4oN4tCtbKV3LooT8E7Yw258Y?=
 =?us-ascii?Q?P5Jc/zPd+SaN97JlvOdDKsQn6Qe1viL9TuOcrdVjdNK/XE65+h5Rjub8xyCp?=
 =?us-ascii?Q?Ozim7h+xzK+tYUjY4eL1l03D38hQnd+ucbSWbSn3bHE12qr3tYrOkBoh6bQW?=
 =?us-ascii?Q?J2TYAoN993YxZovJdhYco0XJm9b0No7q7OWz6qCzE3xKAzKCmnQC56e5GBpJ?=
 =?us-ascii?Q?N0WaSUdFXgQ/dfo+7NEK1f1e8haGTacE4aiHKhiWkubH7mE+/uR9quq9FHs+?=
 =?us-ascii?Q?0YFotvv7ua6OFBT7R1i8WBR0+D+HWpK7fbIOTeyAophsQznvxd2HcyvAOviG?=
 =?us-ascii?Q?1RaZIrfAzATbeQRuUSFnjl/8gdAxnVzGGmJwBFNXZlLReK+8bccDMxTs3YGW?=
 =?us-ascii?Q?/TrA0a5LQmJR/JrtEWoKs+xuYR2k1PpecMYo04z+r4Iv40wQ40YSe3u4uHnM?=
 =?us-ascii?Q?ht+LYl6KaXr1t2625HvqjneNVLmiuC55AV39CkAY06Ch5Rhsa32q7nqYjtS5?=
 =?us-ascii?Q?v5tat94v+whPWlfhX2SVcxy4ZnKPqHV7aloRYdW/ZlTj4Bo0TX4QLevswDDp?=
 =?us-ascii?Q?Qwd4HxU72UVXOoufO21Pq7Vek3oP6ppB/NxWvtGdBZxjGmg4pdcRODRyt0lS?=
 =?us-ascii?Q?oKf7vG8C6QhIIUPuGu3kfY/IkAsyTcA6pH73tA7jUsuMJOlPjmrIAGEZhqGq?=
 =?us-ascii?Q?CgPFQNExI0LJRjpCTPeRlKOwtQLBPiNjSZiC9Jtu60VgCSt1Nzj5pnnJUsDz?=
 =?us-ascii?Q?2seIjG0Uxa9hltnQeOWzq1ccD1wMrToB05CJcuGb5eBDpZXI0qWFumtGvnnX?=
 =?us-ascii?Q?xzZUWEJHpimfD2PfQejLV2G4FBCXKOWwuZlWpdjmfj9skfRV291rlQE76Xjs?=
 =?us-ascii?Q?qLQz8qYFWRlptrG32Sqycpn1rjFrjQqlevlpR/on+uAb0Ir5d95Mj2NfthfD?=
 =?us-ascii?Q?dMOkzRDtOw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4325c65e-90c5-437a-f181-08d9f83d2ebd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 08:59:51.1935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axNlteWxIeNpE557Q/n14KwbSpIZlewDiGIQd5GCF1tuQS7SRJuYRfRebvckWsg9VWWCHnUBtOWuE2oyJUU5/GKVWEB+j8Fx2rvK1U+quZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5949
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

RSS is default on in nfp net device, and cannot be switched off
by `ethtool -K <int> receive-hashing off`. Implement it now.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c    | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 79257ec41987..f80901619fa4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3515,8 +3515,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 				netdev_features_t features)
 {
 	netdev_features_t changed = netdev->features ^ features;
+	u32 new_ctrl, update = NFP_NET_CFG_UPDATE_GEN;
 	struct nfp_net *nn = netdev_priv(netdev);
-	u32 new_ctrl;
 	int err;
 
 	/* Assume this is not called with features we have not advertised */
@@ -3573,6 +3573,16 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_GATHER;
 	}
 
+	if (changed & NETIF_F_RXHASH) {
+		if (features & NETIF_F_RXHASH)
+			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RSS2 ?:
+					      NFP_NET_CFG_CTRL_RSS;
+		else
+			new_ctrl &= ~NFP_NET_CFG_CTRL_RSS_ANY;
+
+		update |= NFP_NET_CFG_UPDATE_RSS;
+	}
+
 	err = nfp_port_set_features(netdev, features);
 	if (err)
 		return err;
@@ -3585,7 +3595,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	nn_dbg(nn, "NIC ctrl: 0x%x -> 0x%x\n", nn->dp.ctrl, new_ctrl);
 	nn_writel(nn, NFP_NET_CFG_CTRL, new_ctrl);
-	err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_GEN);
+	err = nfp_net_reconfig(nn, update);
 	if (err)
 		return err;
 
-- 
2.30.2

