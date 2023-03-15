Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1196BB417
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCONN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCONNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA052D49
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2nhIDAawhnAZXEgwx1TJ+uduADFAph+sy6Tm1rCsEGeHPZzUbTHU1RyaWYX8iMswdkahX7r5wxjQ9GgR0dlc9Yit/74GCd8I1RIoD6XA/3n4WeiTCGZag82fbTs3cErGEHQvzPG2197yn4lTNOenykuiZBMztQexLEdySSrtltxOZ3yCxTuOoebvX5z4YZGgHd2GqlPIO1v5iPbO1aBmfmNI7yWbUP/xnh7ANiObuxcDdHQfzdEPdxcoqIadBroWXStrmmksjuXQIlhcwicRPL8MIrTthtd63YlyAU9OfHt/oYEncaX4nGdkwRNAd35i7ajFnTBhSVR97I+Jlq9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtWonyVm7KAQqIBq170ijBJOQbD/kik2/xqeAs86lAs=;
 b=SnH9h1N2jKtVZHCsxvpZhWTvgS4O+l1c4HyDJFyUKqUXdZy8O0tHE2OqU2sGKSme1D1KICojOKDBgGeAIDu4mNllsqJX1v8/XQ+UXLotI5aRRfwX+NZpFT5mYJfc3zUvZItsZuUqMtkcXt/hshRljhUnibdNAMfFejcSdp6S2egJt9jEWUXVSJclfTpwvLhi6QM4e7sUBULlD/syaCpjC5yBp2QmsuWpjO9OqciNm3ohll2/aIHvX/PiAL/quJYd8pl/XEXsqEgju01kQ0Z7u0uDdM75gSJmQ+Fpb2RIHknbjss1tYzYH5+o88K+qTz1JWL2ffuNJTsmrcvmxMHnSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtWonyVm7KAQqIBq170ijBJOQbD/kik2/xqeAs86lAs=;
 b=pHMMCSt3Mg6gZwmxRoJmNXu3bdk4zfYarYJalVwdih+XEUwB7/6aTq9sR/uUWeH3cUszUpqc1eLejMx2Jk2H43ZP08wVwWCeHoS6FwKhs2IzYSnGzoK/1/x17mpqWW0O3CWiNQuwyLXP1AIPtxYjm2iRbXTcbHDotLbZi1swt8piJsKi2tcmc48DLZHELiPzGRR3YCUgxiosr7MtnRawu8Iy+pxbQCeYVDIh0wuGwjRX5Ewh288s4xQFBGYsKAuPEc4RZn+gezms1zdhziFqulBG/9lwy9bwl8GCDYOvo1yVatEkbNX0m2GhTFpPTVjmC6Iwj+B1HGfylZLtxyGvhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:13:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/11] rtnetlink: bridge: mcast: Move MDB handlers out of bridge driver
Date:   Wed, 15 Mar 2023 15:11:47 +0200
Message-Id: <20230315131155.4071175-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: f48c4ed9-6d3f-4352-1992-08db2557083c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTcvcoBayYcJTLSSWRvWKRkDUqyjxeStI9lJPr6kl2foqSbp7ySShdO0UfUob/Q+4dHip2XVxwNrGP0MFlloJNPkYGWeslExdB2JeYpok2mYhVhnZzIWfm/bR2d3cy1dW5b9NcVPMgIR/WkmDUxf6YgTOxOXZnr9Z5v6+HcJmxsVbOovNaggUpokhGTaiM9F1oe8XKln2OrqHFukf6wHbXpILeqOu3dztG1hS/jj+RppUwh1B1J0LOSy90TPrpeoTodR6NaqVD5e8cHZqySIVI3ksqUV6vVjKA2fs+jFS9HkFuGqwjx3EOsIa4XvcnncArbToGEe3zSlLO37dnqD5DZ52Jcm2zYLGh/3cAJuQ5HYrHnSNjs4VWLcp7emCKpzQ6w/fXrrflfNBrn1GBhAS+z05iW6QuS08sNstU4J/W7DKNBXDMARnjUlcsAhJZDJ5qMaN0E8bRNDo4ZMc+rBz0cr7IlqbqlDRIJ516+spGL35QbeomdzRFam3vVGoCZoxPlCmRyaGaBLlr2FOHw5YgHdXBl1cMGFtwb+NGT53VV9apySi7rGRW8bB/Ssvl2ej/ynr6KOK1sn6Ldy/IN6RQ1f0zxjfubR8W5nnufP20BOof+umd3RozDHUpeCtL1lLxBFP2imQRU/9o6DILxUmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199018)(8936002)(30864003)(5660300002)(41300700001)(2906002)(38100700002)(86362001)(36756003)(478600001)(8676002)(66476007)(66946007)(66556008)(6486002)(107886003)(6666004)(4326008)(316002)(6512007)(26005)(6506007)(186003)(2616005)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9R9Sr2cxTc1xaeajwgqSZ9OixfX9EO6SH856pJwrS5BbRdf54Co7mgwH47oa?=
 =?us-ascii?Q?5aFFJnqxbd+DDUqeX75hzfIfURfkpTY2CgV9bFHsUnosi9RbBzF+pr84h9ed?=
 =?us-ascii?Q?klPDjb7H2Q8NNJj1EFfZy/GYNrJHLn06VvPmLafZvD6mw0LgsZZWHY9jHQGU?=
 =?us-ascii?Q?T7pqwFsRX3FdfVcxIneetxMoXSQctl7EZfa45dSvokLlcAldcTijvGsEeXY4?=
 =?us-ascii?Q?WHv+u3tzw6CMa9CZcFeMkuJ5wQeYtdDBS5K6J4kHsGfgzaTy6twUf0PRi3tm?=
 =?us-ascii?Q?bgnxVn1mffHBKMSyU5DMOFDoVcXEgWeP2nOQWOeSF2KuDR/Cv3e5p5yaAcDx?=
 =?us-ascii?Q?47VnsMnRd82SdsS4MKzZpBOL7j0hcUyetjTjItUFE4bnlo/k9xmhB4LNjU3e?=
 =?us-ascii?Q?3aFi2GKmVy4xXjpdrfLr9F5SWSEqrz0EX4DapgVXRsJmR9LYIiLvt4QtPxlL?=
 =?us-ascii?Q?noP6ZHQXq52mCdAsqy0wJaPOuI+wuyruSrYKvuqGZb7RSj89btR3b6J4nX8P?=
 =?us-ascii?Q?bC95NiUUt/0OayTpOO6pL5Zzsm83BAXcW5jBeKk68AVpHXtbiMGYFGSnUzl2?=
 =?us-ascii?Q?DxqhoxnCdrzZBnwYP1bggiyvZoXNojfeCV3ANutE03wgr48l0t25FmpUWXwt?=
 =?us-ascii?Q?kpLVPdk5MO36YD79QiPKd35CIdkPyXdSDG0snoPlUgpe5s+wdhCwoQjQkw4O?=
 =?us-ascii?Q?8fXMRyqtuOpfRWkkcY/YEey1P3dO+r+6Dxp8CQKVANeHpercS6orL77Q3dxl?=
 =?us-ascii?Q?Krc9Is0BWJb6/eziNY8djxfHV9k6pvfrkb28qBSmIsOwJSRRxPSAqHniIiko?=
 =?us-ascii?Q?9R/fjj/rNdqNCq7VIOmCMyBgK4Cj9lTD0lsDbn4JfJFBH+6ot7ql1K3u8bSF?=
 =?us-ascii?Q?XXz3Gsb/CHbZKVI8OorL8WIe7KHWSkcfS1/DSlaHf5p9V9u3TXTPgBY7SQS+?=
 =?us-ascii?Q?50vuoVaPejBvXbTGv1pjismD7TNvxuH+zr/PVSlkycmODzvUpoPAE9bmLyM2?=
 =?us-ascii?Q?j8rSE864aeahLya0GmzxGgCG2b037E6yybyNXLEGGY0EUlxfpj/88D1GEkWv?=
 =?us-ascii?Q?W5M75J6Bu1Hnv/0dxO9M/YSr7ux9mQplp04/EidCnjWZ1tjtZv+dd4NCMzB8?=
 =?us-ascii?Q?l9iAcMzrlfFb0ap/9B7vVEDlvK9v7P8xmxtn+QHGvCscSdRKLzB9hc9A36Ng?=
 =?us-ascii?Q?vFMtWHsepexmMoWYnn7PwYefAnOKeM7JZUkJzxsJB9MH5iDBmSOijHw4BzN7?=
 =?us-ascii?Q?szLjr7N308G5LXpmVIxCFy20JVKpC+7rIqkqvjhMP7kz3ZT7iNdCjaL+cccV?=
 =?us-ascii?Q?ro12ODOw4cBsP6ZoyL8Tufr6wCnLYw7r2whi5nodMGnyBKJFBGazFbqR0TeK?=
 =?us-ascii?Q?+52L0ZQGvGS5NjacLYrkUji+4YYguevbu65RP6BVgWaXJYVO0UlP3wCl6Sw2?=
 =?us-ascii?Q?BsuvLnuvmmkcwJjF+6pvP8XiZPStlzq0WM/j7DoNeHdD9TSh63AE7PU+5qp7?=
 =?us-ascii?Q?M2UMlpRsHexR2hf+X/Dgw8vG3smN6idsllhBbTzPZ+1vSZCnExgNckMFlogQ?=
 =?us-ascii?Q?93vXber2ObHo8pYNVOEDripARaPlklkFh7OFBYQO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48c4ed9-6d3f-4352-1992-08db2557083c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:13.6407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4n3jtARA8Q2bhanPf0pIyTRopx6beFGLOykMg/zZ/ykSpN7lt5Dquu6hvNcE7HSeb8Jnrf36lsFs7ZdUYHsCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the bridge driver registers handlers for MDB netlink
messages, making it impossible for other drivers to implement MDB
support.

As a preparation for VXLAN MDB support, move the MDB handlers out of the
bridge driver to the core rtnetlink code. The rtnetlink code will call
into individual drivers by invoking their previously added MDB net
device operations.

Note that while the diffstat is large, the change is mechanical. It
moves code out of the bridge driver to rtnetlink code. Also note that a
similar change was made in 2012 with commit 77162022ab26 ("net: add
generic PF_BRIDGE:RTM_ FDB hooks") that moved FDB handlers out of the
bridge driver to the core rtnetlink code.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v1:
    * Use NL_ASSERT_DUMP_CTX_FITS().
    * memset the entire context when moving to the next device.
    * Reset sequence counters when moving to the next device.
    * Use NL_SET_ERR_MSG_ATTR() in rtnl_validate_mdb_entry().

 net/bridge/br_device.c  |   6 +-
 net/bridge/br_mdb.c     | 301 ++--------------------------------------
 net/bridge/br_netlink.c |   3 -
 net/bridge/br_private.h |  35 ++---
 net/core/rtnetlink.c    | 217 +++++++++++++++++++++++++++++
 5 files changed, 244 insertions(+), 318 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 85fa4d73bb53..df47c876230e 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -468,9 +468,9 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
-	.ndo_mdb_add		 = br_mdb_add_new,
-	.ndo_mdb_del		 = br_mdb_del_new,
-	.ndo_mdb_dump		 = br_mdb_dump_new,
+	.ndo_mdb_add		 = br_mdb_add,
+	.ndo_mdb_del		 = br_mdb_del,
+	.ndo_mdb_dump		 = br_mdb_dump,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index cb8270a5480b..76636c61db21 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -380,86 +380,8 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	return err;
 }
 
-static int br_mdb_valid_dump_req(const struct nlmsghdr *nlh,
-				 struct netlink_ext_ack *extack)
-{
-	struct br_port_msg *bpm;
-
-	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bpm))) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid header for mdb dump request");
-		return -EINVAL;
-	}
-
-	bpm = nlmsg_data(nlh);
-	if (bpm->ifindex) {
-		NL_SET_ERR_MSG_MOD(extack, "Filtering by device index is not supported for mdb dump request");
-		return -EINVAL;
-	}
-	if (nlmsg_attrlen(nlh, sizeof(*bpm))) {
-		NL_SET_ERR_MSG(extack, "Invalid data after header in mdb dump request");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct net_device *dev;
-	struct net *net = sock_net(skb->sk);
-	struct nlmsghdr *nlh = NULL;
-	int idx = 0, s_idx;
-
-	if (cb->strict_check) {
-		int err = br_mdb_valid_dump_req(cb->nlh, cb->extack);
-
-		if (err < 0)
-			return err;
-	}
-
-	s_idx = cb->args[0];
-
-	rcu_read_lock();
-
-	for_each_netdev_rcu(net, dev) {
-		if (netif_is_bridge_master(dev)) {
-			struct net_bridge *br = netdev_priv(dev);
-			struct br_port_msg *bpm;
-
-			if (idx < s_idx)
-				goto skip;
-
-			nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-					cb->nlh->nlmsg_seq, RTM_GETMDB,
-					sizeof(*bpm), NLM_F_MULTI);
-			if (nlh == NULL)
-				break;
-
-			bpm = nlmsg_data(nlh);
-			memset(bpm, 0, sizeof(*bpm));
-			bpm->ifindex = dev->ifindex;
-			if (br_mdb_fill_info(skb, cb, dev) < 0)
-				goto out;
-			if (br_rports_fill_info(skb, &br->multicast_ctx) < 0)
-				goto out;
-
-			cb->args[1] = 0;
-			nlmsg_end(skb, nlh);
-		skip:
-			idx++;
-		}
-	}
-
-out:
-	if (nlh)
-		nlmsg_end(skb, nlh);
-	rcu_read_unlock();
-	cb->args[0] = idx;
-	return skb->len;
-}
-
-int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-		    struct netlink_callback *cb)
+int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		struct netlink_callback *cb)
 {
 	struct net_bridge *br = netdev_priv(dev);
 	struct br_port_msg *bpm;
@@ -716,60 +638,6 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
-static int validate_mdb_entry(const struct nlattr *attr,
-			      struct netlink_ext_ack *extack)
-{
-	struct br_mdb_entry *entry = nla_data(attr);
-
-	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
-		return -EINVAL;
-	}
-
-	if (entry->ifindex == 0) {
-		NL_SET_ERR_MSG_MOD(extack, "Zero entry ifindex is not allowed");
-		return -EINVAL;
-	}
-
-	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is not multicast");
-			return -EINVAL;
-		}
-		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is local multicast");
-			return -EINVAL;
-		}
-#if IS_ENABLED(CONFIG_IPV6)
-	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
-		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv6 entry group address is link-local all nodes");
-			return -EINVAL;
-		}
-#endif
-	} else if (entry->addr.proto == 0) {
-		/* L2 mdb */
-		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
-			NL_SET_ERR_MSG_MOD(extack, "L2 entry group is not multicast");
-			return -EINVAL;
-		}
-	} else {
-		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
-		return -EINVAL;
-	}
-
-	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
-		NL_SET_ERR_MSG_MOD(extack, "Unknown entry state");
-		return -EINVAL;
-	}
-	if (entry->vid >= VLAN_VID_MASK) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid entry VLAN id");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
 				struct netlink_ext_ack *extack)
 {
@@ -1332,49 +1200,16 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 	return 0;
 }
 
-static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
-	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
-	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
-						  validate_mdb_entry,
-						  sizeof(struct br_mdb_entry)),
-	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
-};
-
-static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
-			      struct br_mdb_config *cfg,
+static int br_mdb_config_init(struct br_mdb_config *cfg, struct net_device *dev,
+			      struct nlattr *tb[], u16 nlmsg_flags,
 			      struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
-	struct br_port_msg *bpm;
-	struct net_device *dev;
-	int err;
-
-	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
-				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
-	if (err)
-		return err;
+	struct net *net = dev_net(dev);
 
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
 	cfg->rt_protocol = RTPROT_STATIC;
-	cfg->nlflags = nlh->nlmsg_flags;
-
-	bpm = nlmsg_data(nlh);
-	if (!bpm->ifindex) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid bridge ifindex");
-		return -EINVAL;
-	}
-
-	dev = __dev_get_by_index(net, bpm->ifindex);
-	if (!dev) {
-		NL_SET_ERR_MSG_MOD(extack, "Bridge device doesn't exist");
-		return -ENODEV;
-	}
-
-	if (!netif_is_bridge_master(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
-		return -EOPNOTSUPP;
-	}
+	cfg->nlflags = nlmsg_flags;
 
 	cfg->br = netdev_priv(dev);
 
@@ -1388,11 +1223,6 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
-		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
-		return -EINVAL;
-	}
-
 	cfg->entry = nla_data(tb[MDBA_SET_ENTRY]);
 
 	if (cfg->entry->ifindex != cfg->br->dev->ifindex) {
@@ -1430,16 +1260,15 @@ static void br_mdb_config_fini(struct br_mdb_config *cfg)
 	br_mdb_config_src_list_fini(cfg);
 }
 
-static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
-		      struct netlink_ext_ack *extack)
+int br_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+	       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	int err;
 
-	err = br_mdb_config_init(net, nlh, &cfg, extack);
+	err = br_mdb_config_init(&cfg, dev, tb, nlmsg_flags, extack);
 	if (err)
 		return err;
 
@@ -1492,65 +1321,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
-		   struct netlink_ext_ack *extack)
-{
-	struct net_bridge_vlan_group *vg;
-	struct br_mdb_config cfg = {};
-	struct net_bridge_vlan *v;
-	int err;
-
-	/* Configuration structure will be initialized here. */
-
-	err = -EINVAL;
-	/* host join errors which can happen before creating the group */
-	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
-		/* don't allow any flags for host-joined IP groups */
-		if (cfg.entry->state) {
-			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
-			goto out;
-		}
-		if (!br_multicast_is_star_g(&cfg.group)) {
-			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
-			goto out;
-		}
-	}
-
-	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
-		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
-		goto out;
-	}
-
-	if (cfg.p) {
-		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
-			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
-			goto out;
-		}
-		vg = nbp_vlan_group(cfg.p);
-	} else {
-		vg = br_vlan_group(cfg.br);
-	}
-
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * install mdb entry on all vlans configured on the port.
-	 */
-	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
-		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			cfg.entry->vid = v->vid;
-			cfg.group.vid = v->vid;
-			err = __br_mdb_add(&cfg, extack);
-			if (err)
-				break;
-		}
-	} else {
-		err = __br_mdb_add(&cfg, extack);
-	}
-
-out:
-	br_mdb_config_fini(&cfg);
-	return err;
-}
-
 static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
@@ -1592,16 +1362,15 @@ static int __br_mdb_del(const struct br_mdb_config *cfg)
 	return err;
 }
 
-static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
-		      struct netlink_ext_ack *extack)
+int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+	       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	int err;
 
-	err = br_mdb_config_init(net, nlh, &cfg, extack);
+	err = br_mdb_config_init(&cfg, dev, tb, 0, extack);
 	if (err)
 		return err;
 
@@ -1626,49 +1395,3 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	br_mdb_config_fini(&cfg);
 	return err;
 }
-
-int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-		   struct netlink_ext_ack *extack)
-{
-	struct net_bridge_vlan_group *vg;
-	struct br_mdb_config cfg = {};
-	struct net_bridge_vlan *v;
-	int err = 0;
-
-	/* Configuration structure will be initialized here. */
-
-	if (cfg.p)
-		vg = nbp_vlan_group(cfg.p);
-	else
-		vg = br_vlan_group(cfg.br);
-
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * delete mdb entry on all vlans configured on the port.
-	 */
-	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
-		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			cfg.entry->vid = v->vid;
-			cfg.group.vid = v->vid;
-			err = __br_mdb_del(&cfg);
-		}
-	} else {
-		err = __br_mdb_del(&cfg);
-	}
-
-	br_mdb_config_fini(&cfg);
-	return err;
-}
-
-void br_mdb_init(void)
-{
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMDB, NULL, br_mdb_dump, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWMDB, br_mdb_add, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELMDB, br_mdb_del, NULL, 0);
-}
-
-void br_mdb_uninit(void)
-{
-	rtnl_unregister(PF_BRIDGE, RTM_GETMDB);
-	rtnl_unregister(PF_BRIDGE, RTM_NEWMDB);
-	rtnl_unregister(PF_BRIDGE, RTM_DELMDB);
-}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 9173e52b89e2..fefb1c0e248b 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1886,7 +1886,6 @@ int __init br_netlink_init(void)
 {
 	int err;
 
-	br_mdb_init();
 	br_vlan_rtnl_init();
 	rtnl_af_register(&br_af_ops);
 
@@ -1898,13 +1897,11 @@ int __init br_netlink_init(void)
 
 out_af:
 	rtnl_af_unregister(&br_af_ops);
-	br_mdb_uninit();
 	return err;
 }
 
 void br_netlink_fini(void)
 {
-	br_mdb_uninit();
 	br_vlan_rtnl_uninit();
 	rtnl_af_unregister(&br_af_ops);
 	rtnl_link_unregister(&br_link_ops);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a72847c1dc9f..7264fd40f82f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -981,14 +981,12 @@ void br_multicast_get_stats(const struct net_bridge *br,
 u32 br_multicast_ngroups_get(const struct net_bridge_mcast_port *pmctx);
 void br_multicast_ngroups_set_max(struct net_bridge_mcast_port *pmctx, u32 max);
 u32 br_multicast_ngroups_get_max(const struct net_bridge_mcast_port *pmctx);
-int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
-		   struct netlink_ext_ack *extack);
-int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-		   struct netlink_ext_ack *extack);
-int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-		    struct netlink_callback *cb);
-void br_mdb_init(void);
-void br_mdb_uninit(void);
+int br_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+	       struct netlink_ext_ack *extack);
+int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+	       struct netlink_ext_ack *extack);
+int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		struct netlink_callback *cb);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
 			    struct net_bridge_mdb_entry *mp, bool notify);
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify);
@@ -1380,33 +1378,24 @@ static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 	return false;
 }
 
-static inline int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[],
-				 u16 nlmsg_flags,
-				 struct netlink_ext_ack *extack)
+static inline int br_mdb_add(struct net_device *dev, struct nlattr *tb[],
+			     u16 nlmsg_flags, struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-				 struct netlink_ext_ack *extack)
+static inline int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+			     struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-				  struct netlink_callback *cb)
+static inline int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+			      struct netlink_callback *cb)
 {
 	return 0;
 }
 
-static inline void br_mdb_init(void)
-{
-}
-
-static inline void br_mdb_uninit(void)
-{
-}
-
 static inline int br_mdb_hash_init(struct net_bridge *br)
 {
 	return 0;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5d8eb57867a9..f347d9fa78c7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -54,6 +54,9 @@
 #include <net/rtnetlink.h>
 #include <net/net_namespace.h>
 #include <net/devlink.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/addrconf.h>
+#endif
 
 #include "dev.h"
 
@@ -6063,6 +6066,216 @@ static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+static int rtnl_mdb_valid_dump_req(const struct nlmsghdr *nlh,
+				   struct netlink_ext_ack *extack)
+{
+	struct br_port_msg *bpm;
+
+	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bpm))) {
+		NL_SET_ERR_MSG(extack, "Invalid header for mdb dump request");
+		return -EINVAL;
+	}
+
+	bpm = nlmsg_data(nlh);
+	if (bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Filtering by device index is not supported for mdb dump request");
+		return -EINVAL;
+	}
+	if (nlmsg_attrlen(nlh, sizeof(*bpm))) {
+		NL_SET_ERR_MSG(extack, "Invalid data after header in mdb dump request");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+struct rtnl_mdb_dump_ctx {
+	long idx;
+};
+
+static int rtnl_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct rtnl_mdb_dump_ctx *ctx = (void *)cb->ctx;
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev;
+	int idx, s_idx;
+	int err;
+
+	NL_ASSERT_DUMP_CTX_FITS(struct rtnl_mdb_dump_ctx);
+
+	if (cb->strict_check) {
+		err = rtnl_mdb_valid_dump_req(cb->nlh, cb->extack);
+		if (err)
+			return err;
+	}
+
+	s_idx = ctx->idx;
+	idx = 0;
+
+	for_each_netdev(net, dev) {
+		if (idx < s_idx)
+			goto skip;
+		if (!dev->netdev_ops->ndo_mdb_dump)
+			goto skip;
+
+		err = dev->netdev_ops->ndo_mdb_dump(dev, skb, cb);
+		if (err == -EMSGSIZE)
+			goto out;
+		/* Moving on to next device, reset markers and sequence
+		 * counters since they are all maintained per-device.
+		 */
+		memset(cb->ctx, 0, sizeof(cb->ctx));
+		cb->prev_seq = 0;
+		cb->seq = 0;
+skip:
+		idx++;
+	}
+
+out:
+	ctx->idx = idx;
+	return skb->len;
+}
+
+static int rtnl_validate_mdb_entry(const struct nlattr *attr,
+				   struct netlink_ext_ack *extack)
+{
+	struct br_mdb_entry *entry = nla_data(attr);
+
+	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Invalid attribute length");
+		return -EINVAL;
+	}
+
+	if (entry->ifindex == 0) {
+		NL_SET_ERR_MSG(extack, "Zero entry ifindex is not allowed");
+		return -EINVAL;
+	}
+
+	if (entry->addr.proto == htons(ETH_P_IP)) {
+		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast");
+			return -EINVAL;
+		}
+		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is local multicast");
+			return -EINVAL;
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
+		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
+			NL_SET_ERR_MSG(extack, "IPv6 entry group address is link-local all nodes");
+			return -EINVAL;
+		}
+#endif
+	} else if (entry->addr.proto == 0) {
+		/* L2 mdb */
+		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
+			NL_SET_ERR_MSG(extack, "L2 entry group is not multicast");
+			return -EINVAL;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Unknown entry protocol");
+		return -EINVAL;
+	}
+
+	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
+		NL_SET_ERR_MSG(extack, "Unknown entry state");
+		return -EINVAL;
+	}
+	if (entry->vid >= VLAN_VID_MASK) {
+		NL_SET_ERR_MSG(extack, "Invalid entry VLAN id");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
+	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
+	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						  rtnl_validate_mdb_entry,
+						  sizeof(struct br_mdb_entry)),
+	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
+};
+
+static int rtnl_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
+			struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
+	if (err)
+		return err;
+
+	bpm = nlmsg_data(nlh);
+	if (!bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "Device doesn't exist");
+		return -ENODEV;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
+		NL_SET_ERR_MSG(extack, "Missing MDBA_SET_ENTRY attribute");
+		return -EINVAL;
+	}
+
+	if (!dev->netdev_ops->ndo_mdb_add) {
+		NL_SET_ERR_MSG(extack, "Device does not support MDB operations");
+		return -EOPNOTSUPP;
+	}
+
+	return dev->netdev_ops->ndo_mdb_add(dev, tb, nlh->nlmsg_flags, extack);
+}
+
+static int rtnl_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
+			struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
+	if (err)
+		return err;
+
+	bpm = nlmsg_data(nlh);
+	if (!bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "Device doesn't exist");
+		return -ENODEV;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
+		NL_SET_ERR_MSG(extack, "Missing MDBA_SET_ENTRY attribute");
+		return -EINVAL;
+	}
+
+	if (!dev->netdev_ops->ndo_mdb_del) {
+		NL_SET_ERR_MSG(extack, "Device does not support MDB operations");
+		return -EOPNOTSUPP;
+	}
+
+	return dev->netdev_ops->ndo_mdb_del(dev, tb, extack);
+}
+
 /* Process one rtnetlink message. */
 
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -6297,4 +6510,8 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
 	rtnl_register(PF_UNSPEC, RTM_SETSTATS, rtnl_stats_set, NULL, 0);
+
+	rtnl_register(PF_BRIDGE, RTM_GETMDB, NULL, rtnl_mdb_dump, 0);
+	rtnl_register(PF_BRIDGE, RTM_NEWMDB, rtnl_mdb_add, NULL, 0);
+	rtnl_register(PF_BRIDGE, RTM_DELMDB, rtnl_mdb_del, NULL, 0);
 }
-- 
2.37.3

