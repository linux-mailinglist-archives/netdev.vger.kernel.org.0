Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8ED4C2D39
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiBXNfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiBXNfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:19 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2028178688
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaLvxgBqThUeYdB16UnvITrdD0yJpeCkz2FEEOodTIYIKJpkZZwKMvEkDj5M8UgsWkhllSR3NCki9Ve4QuXZy08nudebhMJc636EUqgGnYEzbpEl2dx/a3vbxfpJBkQugg8tkQNZgGm8ibF+LFHwv45SnUOEnWoKH8SU9LKriNGPlggiKwmfaDEPJi4L38y/HW6siJbCMuahf25dNOufqjOGG+bzu2OeyUFKhZQNMi8pHtG4xtMhmdMeK5bWtlfWgQ/HGHOTiqKN4LCO9o7ja9v8qZQmcmrYVRJVa9cG4wMgzfP8GCn0FqBbTutwWrHNP4DGRyLDZipn18sqyvgZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cHomSklHzgxGHSRsDMTob4Bt9ldVipCfUVKjkmAS0s=;
 b=bMHDRLb9eJmGcGGoOi/BNrDYo3KNY8GpHak5jWfIxv6fhCjuitKFMfU6hoQC85l8lk4Y2Vg0WSC8TBpkUDdSRepXpI/btHc1fUTcdOQtM3PTUbTT3iARlK9gFNqAhAtk+ADKEEyVGRz5lHpM5vpHZLj4thYDJ4D/xlnBfZYp6ZDVadBJuJ1yynVbgxOn8ESDFo624jsENBitDi2WV9grQaXGfzj5Sxlealp5ca6lMdrIAg4rr/ql8wJ3Oj5J+Vtz3TeQ4zn4MoBVLZQNq8mMfTcWTKwsVtrynfQKIxSwPiOoRW98WCIXZW5g0/+BkwcIt68vgD7DS0j9MMhO0sZv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cHomSklHzgxGHSRsDMTob4Bt9ldVipCfUVKjkmAS0s=;
 b=hWHQpLb6M3ILenVn3nLFDPTLPgAEcgB8BV9va+5/JFO/I6ZB0f9mN+6A0uGAzBi4fZgL06NbhXn8/Zdhna2Ax5ExG9R45VvOjOGGBl+t2OIb1mK26XK3+SxDsf0xKieWyZu4X7THK14t0GblZZaByt6X3a+MppBBxE5Wvsd2LT1RkLWzdxpLWlcsTCXtKgrUyefcgppQ9XiREgdhsHJ9cxAboacszwDIuYnk44ci/pA15G7UuYSW/2KAxc6OV1VSwnI19IMPaS8fFLHOXrzVZvaJ1CTeAfbxVfpoM+nmP9dPoQ19L/J0aUGHvvEhq3TzWipyN2tl/tFh4vRceQDHTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:34:48 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/14] net: rtnetlink: Add RTM_SETSTATS
Date:   Thu, 24 Feb 2022 15:33:29 +0200
Message-Id: <20220224133335.599529-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0228.eurprd07.prod.outlook.com
 (2603:10a6:802:58::31) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cda6cc51-ec5b-4bc8-714e-08d9f79a6d8c
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6008C237B8D4745D3A7124A6B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NydymS2oWEh6jdo65bfUZ96K9lvPYpcnCkML+fI+XmHVdiYINvOQX4b9A1Pf5SQMxR4PNjRcnUjzpxmo7BPsQxbZK5Vwrc75s2HtROt4DGgKIyMKuQZTbbNyZm7qa0zvdZ8sGFFFhK8I6KFucxrKLCccL5plNu5OwnGhCOww+2RSP5i+s3XXMNEmAbz9sEUkfi/jDyZwt8b3d4vw6Hub7TV2izmo3WSacqYzdqwuCSasOYTr/Hfpsj+ZcLo7wea1HHnou1xgBp1sEpwN+FghBrvLNzrLQFDVzHZOZ6m3gIT528ZuWtVtt6aBdFukHVXUmTqAqxqfDlRDnLxSAyCFfZQu6lwUrI0EdbLWwB1X6SLIms9VRMpbj5jfVK6wiMMIGyqxb+2H3J6aIRxrLyJgr16aUsALWARW9Tn4O7A95nzgfDtDKozO7EJYyYOIVIdzsHrhkO7bYjM+hE8cEQ1nUd7bmqZTO77wPTt5fTs6vwhBMU6Tbm90i1iIW2dWuJLtMvvtH96oxD5waiU6y/QR/FTVaW8O1sO+n4mYhxniIjdqrMA1AUnQzHKUtPuuo+pazYHflSblgYPCrR7oy7XgdBqndExMKAT34zGbZhdmwxDW+rboMTK5/Gv57/eEBPADEWJf5XOxlsoy3bctKuk1AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BxuLTizMp4toLaiDI9FTy+RRftpw0jPWora7gSpxZ9EA/tE1S6Cv/GeWwG1v?=
 =?us-ascii?Q?ccBntrBuna5n2W9OIzUO903Qw9gZIZZ0V/ERC3lUSErkJVVPMs7mVvzb9zMp?=
 =?us-ascii?Q?nP38DTYHGmJMDqKKgT0whhVLcckK8bTx0M/6RQK87ReVQdoZrkivpAdx2kV1?=
 =?us-ascii?Q?9RZ5zwSNlrWLIfVFCs3KuArsd5nMvz+sEp1YPwuzhSjHPYA93V8fF3kDWnN2?=
 =?us-ascii?Q?Q5zF1mWmp445WAJjVAqaJrf0D0nRcxPBEAEMBjCUgrCKHvAa5tttf/dJSX9k?=
 =?us-ascii?Q?kO0tABJDdizbErmlQmeKybRY0ZazabtJxhTxC7odQ5C0idUJhqx5KzW34sGP?=
 =?us-ascii?Q?G5Ebf02EdJjM9oNOFoz1lMfXesCmFFG9HIjOo+vL5hAfD9D0PndhxaMHxxkO?=
 =?us-ascii?Q?qP5g32OIl5DxZNeH5ZwRkBbjVQNltXy0c9QCGHjYQ0ixZXebvbuaxtYTRlyN?=
 =?us-ascii?Q?zRqyHZBg4I8FMzsxJrK6pDinjPrBsYDd6yB9zVRQOatw5YIsMAS/YL1/1rdT?=
 =?us-ascii?Q?AYhpUfAW0c7KdgD18MVtckzXNUNQy/YjKKBKjTjuC4AKGhhrCN+7mb94GoQ5?=
 =?us-ascii?Q?/Pl7s2ezy43SpdWeH8EtJVs977DnKzKkCzYvpTOmp9am3lR6+ub26OA7scPw?=
 =?us-ascii?Q?iKWLSs3Arr1dG5Q1DdaBf7MBfXgqFepc0Kwg8bDhjnun1lu7J9WAbCOiJw+j?=
 =?us-ascii?Q?EJkz4Cc97G63KEuLW37wggQc2MMrLkU42dsx2fTzANqN74Ugpja+W5SsojyD?=
 =?us-ascii?Q?KWRHsz8FuWhWkI2nIQCpRvGKKvhltOxqDKpqBs8sXUiPmiVSXOjQAkv1RBOW?=
 =?us-ascii?Q?HdrN4kArjwBo5lP2IxJ1Et8gQcgyU5ZBX0pJLs23fKVQJBl/+Sz6AKZxaNrd?=
 =?us-ascii?Q?dIiZrZMr9ttov9Ta6ZrFuJ3sliMv8hkpRDov/WboB7vGrzoZwmk7wdossEYV?=
 =?us-ascii?Q?TMvnqW0QIIjXpd/9tD+5wP9VAPoe7MpdNg5ukyPlmTs9MLtIPZsD+SU2xM6C?=
 =?us-ascii?Q?6qLxJU1Le58yyKZmTfSiigZ9k+0dOVsRqkLZ9lLIN9PtIx+hsVhNauh44nAR?=
 =?us-ascii?Q?NFc4qiGJ5AkWBuPSz0fKFllN0FL4rR3tcYKcCnG7rklPQXGinO0vhK9HW5yo?=
 =?us-ascii?Q?O/Lp5UQF69lCJ5PL/GfxmzZaNEkyJwy+f8G9csR2YmOZLbWA0Ft4qg+taFbz?=
 =?us-ascii?Q?nl+C2+64x+xcVW8ejFWKpEknVXJRJvsa5rcCinBXEaM8S02YsDKFAzLAEoiZ?=
 =?us-ascii?Q?uBE8FWPrisGZpXDJTifaskyqkGwIHiFJ4zFzFp4gDTFXvBUM/mgcykwU4icV?=
 =?us-ascii?Q?GVNyR+A3FMNJc9RkmCL10yHpZxRNZKTYB3xFo776EB4EwNcRnxlC2y3vA7uF?=
 =?us-ascii?Q?Mofds+Rz1DKiJVzMtPa2pxsM6h0eF8+K0XZC3blK2OLadGygw96Q18QAJqGb?=
 =?us-ascii?Q?EiGfZZoFZz0F6krX0UEA8PTcRerDwugELO5masl4+DLNIZSI5Xl0j5SUrF0T?=
 =?us-ascii?Q?1fyt7xPD0ZcizzzVbwsuKD6Cm7ey3pQI5Rf1aVEcFqB9WIbsCygTmhs71Uus?=
 =?us-ascii?Q?uDxckk1ZAsnTNc4grpiko+Oz6IvlH0TsJCPn7qtTM+vl2aKwaC1IJnsSqdq9?=
 =?us-ascii?Q?c+5+Kv+OPvuzcGDMOqxTf88=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda6cc51-ec5b-4bc8-714e-08d9f79a6d8c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:48.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZyBAUVMIz/U8AHj+jTGsWUqa/RrLrz7Fk3utswQLqR69sW5Dwpyk4ph14e4w2XPPzabaP/u+lnvetUrOhThRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The offloaded HW stats are designed to allow per-netdevice enablement and
disablement. These stats are only accessible through RTM_GETSTATS, and
therefore should be toggled by a RTM_SETSTATS message. Add it, and the
necessary skeleton handler.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/rtnetlink.h |  2 +
 net/core/rtnetlink.c           | 67 ++++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |  1 +
 3 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 93d934cc4613..d6615b78f5d9 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -146,6 +146,8 @@ enum {
 #define RTM_NEWSTATS RTM_NEWSTATS
 	RTM_GETSTATS = 94,
 #define RTM_GETSTATS RTM_GETSTATS
+	RTM_SETSTATS,
+#define RTM_SETSTATS RTM_SETSTATS
 
 	RTM_NEWCACHEREPORT = 96,
 #define RTM_NEWCACHEREPORT RTM_NEWCACHEREPORT
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0db745cc3f11..daab2d246e90 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5565,6 +5565,11 @@ rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
 			NLA_POLICY_BITFIELD32(RTNL_STATS_OFFLOAD_XSTATS_VALID),
 };
 
+static const struct nla_policy
+ifla_stats_set_policy[IFLA_STATS_GETSET_MAX + 1] = {
+	[IFLA_STATS_GETSET_UNSPEC] = { .strict_start_type = 1 },
+};
+
 static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
 					struct rtnl_stats_dump_filters *filters,
 					struct netlink_ext_ack *extack)
@@ -5770,6 +5775,67 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct rtnl_stats_dump_filters response_filters = {};
+	struct nlattr *tb[IFLA_STATS_GETSET_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev = NULL;
+	int idxattr = 0, prividx = 0;
+	struct if_stats_msg *ifsm;
+	struct sk_buff *nskb;
+	int err;
+
+	err = rtnl_valid_stats_req(nlh, netlink_strict_get_check(skb),
+				   false, extack);
+	if (err)
+		return err;
+
+	ifsm = nlmsg_data(nlh);
+	if (ifsm->family != AF_UNSPEC) {
+		NL_SET_ERR_MSG(extack, "Address family should be AF_UNSPEC");
+		return -EINVAL;
+	}
+
+	if (ifsm->ifindex > 0)
+		dev = __dev_get_by_index(net, ifsm->ifindex);
+	else
+		return -EINVAL;
+
+	if (!dev)
+		return -ENODEV;
+
+	if (ifsm->filter_mask) {
+		NL_SET_ERR_MSG(extack, "Filter mask must be 0 for stats set");
+		return -EINVAL;
+	}
+
+	err = nlmsg_parse(nlh, sizeof(*ifsm), tb, IFLA_STATS_GETSET_MAX,
+			  ifla_stats_set_policy, extack);
+	if (err < 0)
+		return err;
+
+	nskb = nlmsg_new(if_nlmsg_stats_size(dev, &response_filters),
+			 GFP_KERNEL);
+	if (!nskb)
+		return -ENOBUFS;
+
+	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
+				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+				  0, &response_filters, &idxattr, &prividx,
+				  extack);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(nskb);
+	} else {
+		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+	}
+
+	return err;
+}
+
 /* Process one rtnetlink message. */
 
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -5995,4 +6061,5 @@ void __init rtnetlink_init(void)
 
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
+	rtnl_register(PF_UNSPEC, RTM_SETSTATS, rtnl_stats_set, NULL, 0);
 }
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 94ea2a8b2bb7..2a7e6e188094 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -76,6 +76,7 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_GETNSID,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_NEWSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_READ },
 	{ RTM_GETSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_NEWCACHEREPORT,	NETLINK_ROUTE_SOCKET__NLMSG_READ },
 	{ RTM_NEWCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
-- 
2.33.1

