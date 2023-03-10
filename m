Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871546B3E45
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCJLpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCJLpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:45:45 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7AF11053E
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDRc0vlaZOClhNJ7WkYVOIYluIShH+DN6aB3hEoM1tJHDzrmiisHByeP+aVSagWDqlW6MwM50hFSnYUDJYCxumJv/MptjFlryvtloOX10SPuhNqnnMRF0I5Z3I3e+q2lZCro1KcnvoqVjSu5OTRzrf4txAxLqpVhywAMSHtvC48roEEouFiTU8coAklki/siScHliN+IvFgRez2ybIi7A14kw5sk5vMoSWd+5SN2SKmpyrNJpH5BgE7m4Cb/NKxtJCE5wxnNb+vHhs+fglWLdF7gGGj4IClV6IIGVubUfykWNQZE5bqfNnxvV0LIG7p3B3V8ZSuw82D8QKxNIGCviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74J3BC/GhqTiSv4mcOFjAxeO+5ekkOVycWVlpm+/fEM=;
 b=jl/KW5BeIvv9FcjUA9EeT+52O8oGi7tyNrlXJR6oSpOXWKs5OT8hfjhVTvQB8NuUPJl/C89u5H7yDAQIRUmfUBs2xpccxPKlX+dqPTFFu/bS9MdZSp3ij0hI/UpX8d6c9gB+3PX4Sgl8ApTPaqb/0Z8GUvGhdZ/poTJYeBANiK/yioy01UpUPCzut7KofzdAkZPvseSG4wLXKxenzCFV4pDWViHDIcmBFddQM2F0EXHh8k44xAjEVKbptpo1QpBTxgP0Bmy5kLSTE+QKrKCaphTC2h3//AOm+12fKAIgxzssUXRIDTZ18yoHDcbtQNTSToli0GOTh6JlQMvFnRabrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74J3BC/GhqTiSv4mcOFjAxeO+5ekkOVycWVlpm+/fEM=;
 b=WXaU2Q/9r7KynFTJpY8YZsXHm8awUP4NjuiGdKjlSTivxNnuPTJX3aAz1lthtCQT5s9G/+I+aXWpPbRmD4E8I3sZ9LumsCGyAtgC1gEXAcw+Mp4bSunCrges2DorPKmDm7rqSVs2cUDOfPNIlny4n+cA4e98b00hOad2RrJZNxuip8U2byefrNIOVF92D+mKuuyX202u1IVYKyU18ihMVPedFXKUphY9cUwkq8kUXnL6o7vk2Ucg9C9fBqz+4E7yfFsg5JIoTS6ReAMz6eL/nY+HACcG+AVnqH3Ff44RjmF3KC2yo151YcJyk0uXtmDbAYyA889QeljnlN3PVaycHw==
Received: from DM6PR13CA0059.namprd13.prod.outlook.com (2603:10b6:5:134::36)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 11:45:40 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::e4) by DM6PR13CA0059.outlook.office365.com
 (2603:10b6:5:134::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19 via Frontend Transport; Fri, 10 Mar 2023 11:45:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:32 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:28 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/5] net: ipv6: addrconf: Support IPv6 address labels
Date:   Fri, 10 Mar 2023 12:44:55 +0100
Message-ID: <274d34670c9cc79cb387b4fae2bd1ca70561a9c1.1678448186.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT040:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8db451-6a9f-4db9-7b07-08db215cf88f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6j41x9lVj2Q05nqUYq5lU3Dr93TFrQ4g/Wz3G+jSJ41O/pjWbUJkCc84zn40sMYr4i+TEumxsvNbzOTgqKqot0hbQ5xhUCpSpcHOawLLiNgIVRA19ucTCxa2iKw7azQQEtpb8E8haGffbJqmKSK/HpRllwtqkgQyM9bT67yVeDQ2uDpkhlKMwmsrKyoljwrGqpvNcIJ6QB3foL6pNkr2PAMDZsAVCqohpblpABq27Xu97uDVKItVTb3pWvBQ4IQac0QWxxDeb0AJFe0AUdjJzEGoElJ97CctiLUi4gz/oXQOseTNIvr8q1mR01rnF74VcVQosMZCjNSRwIBa4hGp7DkkHsHCDOcFa2sPKfQ9PaTJhVIGs8so1/AEqbs1Xv9T4mnBmsevaVrlpBEIE0inbF/Hh9+oRz5e1UDMQecVVyw3QH1Y+Xrp+tVKhSJmlUiRvkKdgtwLvsJDe3mciJLyq4qp9wIweeNppBHCKzjsv1KEGCNrvYf+C77wECN6LYMAPveF9bGkkZcjQEye+AlmWN/bdIPzlnU+4RYZVsVNG/1xEqHZ+taTBa5/5+d3rcgKWplFlVcl5GggM7ymmANqxZTNEOLJW0acGL9OJ06NvAEUkeyLZx4+1JRQpXwv2YnVZW/N1cHCK0bWP1SUfSCw2/IeMov3PXBJ+w90bwZS9gFBW8fMTELIE7iu+yL2iZg1/TIXfBthE7zdpvgQNhlnjV18Cyyo4FQYsm48vPU4RudbwBo01Ce7qOvSm+LG7Es
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(46966006)(36840700001)(7636003)(2906002)(82740400003)(83380400001)(40460700003)(36756003)(5660300002)(40480700001)(8676002)(70586007)(70206006)(41300700001)(8936002)(110136005)(356005)(478600001)(4326008)(36860700001)(47076005)(86362001)(316002)(54906003)(82310400005)(7696005)(426003)(2616005)(107886003)(336012)(26005)(16526019)(186003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:39.2355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8db451-6a9f-4db9-7b07-08db215cf88f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
which are used for prioritization of IPv6 addresses, these "ip address
labels" are simply tags that the userspace can assign to IP addresses
arbitrarily.

In this patch, add to IPv6 support for address labels. This adds the
necessary fields, but does not expose them through UAPI yet -- that will
happen in the next patch.

When not given, the default address label is the same as the netdevice
name. In IPv4, this behavior is due to Linux 2.0 compatibility. While this
is probably not a concern anymore, having the same behavior in IPv6 as we
have in IPv4 will make the feature easier to understand.

Also similarly to IPv4, when address label is part of a request to remove
an address, the label given has to match the label at the address, or else
the address is not removed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/addrconf.h |  2 ++
 include/net/if_inet6.h |  1 +
 net/ipv6/addrconf.c    | 14 ++++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index c04f359655b8..52214a46cc7e 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -73,6 +73,8 @@ struct ifa6_config {
 	u32			preferred_lft;
 	u32			valid_lft;
 	u16			scope;
+	char			ifa_label[IFNAMSIZ];
+	bool			has_ifa_label;
 };
 
 int addrconf_init(void);
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index c8490729b4ae..2cfb2ac1d1f7 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -83,6 +83,7 @@ struct inet6_ifaddr {
 
 	struct rcu_head		rcu;
 	struct in6_addr		peer_addr;
+	char			ifa_label[IFNAMSIZ];
 };
 
 struct ip6_sf_socklist {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index faa47f9ea73a..5f4f16bb6ef0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1134,6 +1134,11 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ifa->rt = f6i;
 
 	ifa->idev = idev;
+	if (cfg->has_ifa_label)
+		memcpy(ifa->ifa_label, cfg->ifa_label, sizeof(cfg->ifa_label));
+	else
+		memcpy(ifa->ifa_label, idev->dev->name, IFNAMSIZ);
+
 	in6_dev_hold(idev);
 
 	/* For caller */
@@ -3000,6 +3005,7 @@ static int inet6_addr_add(struct net *net, int ifindex,
 }
 
 static int inet6_addr_del(struct net *net, int ifindex, u32 ifa_flags,
+			  const char *ifa_label,
 			  const struct in6_addr *pfx, unsigned int plen)
 {
 	struct inet6_ifaddr *ifp;
@@ -3019,6 +3025,8 @@ static int inet6_addr_del(struct net *net, int ifindex, u32 ifa_flags,
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifp, &idev->addr_list, if_list) {
+		if (ifa_label && strcmp(ifp->ifa_label, ifa_label))
+			continue;
 		if (ifp->prefix_len == plen &&
 		    ipv6_addr_equal(pfx, &ifp->addr)) {
 			in6_ifa_hold(ifp);
@@ -3079,7 +3087,7 @@ int addrconf_del_ifaddr(struct net *net, void __user *arg)
 		return -EFAULT;
 
 	rtnl_lock();
-	err = inet6_addr_del(net, ireq.ifr6_ifindex, 0, &ireq.ifr6_addr,
+	err = inet6_addr_del(net, ireq.ifr6_ifindex, 0, NULL, &ireq.ifr6_addr,
 			     ireq.ifr6_prefixlen);
 	rtnl_unlock();
 	return err;
@@ -4691,7 +4699,7 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	/* We ignore other flags so far. */
 	ifa_flags &= IFA_F_MANAGETEMPADDR;
 
-	return inet6_addr_del(net, ifm->ifa_index, ifa_flags, pfx,
+	return inet6_addr_del(net, ifm->ifa_index, ifa_flags, NULL, pfx,
 			      ifm->ifa_prefixlen);
 }
 
@@ -4792,6 +4800,8 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
 
 	if (cfg->rt_priority && cfg->rt_priority != ifp->rt_priority)
 		ifp->rt_priority = cfg->rt_priority;
+	if (cfg->has_ifa_label)
+		memcpy(ifp->ifa_label, cfg->ifa_label, IFNAMSIZ);
 
 	if (new_peer)
 		ifp->peer_addr = *cfg->peer_pfx;
-- 
2.39.0

