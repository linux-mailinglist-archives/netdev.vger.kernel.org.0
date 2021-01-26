Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0D304037
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405723AbhAZO0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:26:15 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36513 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391829AbhAZN01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6F359999;
        Tue, 26 Jan 2021 08:24:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CJdsMTONk8Mu5RZ+mdxJVoL++jK7kJLo8gjQRU7cfb8=; b=Xrq1CxO2
        ePo+SqDq2EPxcLS3n9WCbESEvd/WRewQKcqLm/pbSPye83AB8gmPryMPZYg7f3We
        nU9CdfS5f7r3lcL1C256zTNqJxmFtw1TRBqiUcMPWHuz8LVqgGvfNvb2lZZGMg4b
        X6S+mpiM1R7lNk9nKMszK1CazLieyw8a6+bx6NIsXc22ZqBk80fzQbDtkiqAqrUv
        1cTLKiVXYrTVkWgTFMWhUgrUvu70ThtJQSkm4QBO1GY2HlxydY2nn92ea4leUBaB
        tw5XOXlDVy3oJyi6q57RMxYzNa6GJrTgjkKdSqVcaGOcY7Qj0hwX44R6ufdveo24
        LyNAFo/28eshRw==
X-ME-Sender: <xms:CBgQYB2Uhugu9eC0-s_hy7P73H_byWsAiek70K1BExfInU-xo4L-_A>
    <xme:CBgQYIE6EeMih_t_3lxdkZerPxEwqgomLkBKESnpEMGkDc5r2G3A25tyQNQxfT7r8
    9FpZ6LQ99zoyAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CBgQYB4nMu3bo_SugTXU8d2ioEkOG38Kv2t-psW_gjMWD2QVx-rvFA>
    <xmx:CBgQYO0HC2ar72Gf0zFE476kR4CYyPd7gxB8ci2siPAmkF67_FLkwA>
    <xmx:CBgQYEESkWw8Ue2whcAW8JagR8gbMUrFrRbWsTqvAGsf5YU4t15ruA>
    <xmx:CRgQYJ465b8paETXjRkjynCh6cKi3RcfCHjY3RI7xb0wMD5P5yQ-pQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB500108005F;
        Tue, 26 Jan 2021 08:24:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] net: ipv4: Emit notification when fib hardware flags are changed
Date:   Tue, 26 Jan 2021 15:23:06 +0200
Message-Id: <20210126132311.3061388-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After installing a route to the kernel, user space receives an
acknowledgment, which means the route was installed in the kernel,
but not necessarily in hardware.

The asynchronous nature of route installation in hardware can lead to a
routing daemon advertising a route before it was actually installed in
hardware. This can result in packet loss or mis-routed packets until the
route is installed in hardware.

It is also possible for a route already installed in hardware to change
its action and therefore its flags. For example, a host route that is
trapping packets can be "promoted" to perform decapsulation following
the installation of an IPinIP/VXLAN tunnel.

Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
are changed. The aim is to provide an indication to user-space
(e.g., routing daemons) about the state of the route in hardware.

Introduce a sysctl that controls this behavior.

Keep the default value at 0 (i.e., do not emit notifications) for several
reasons:
- Multiple RTM_NEWROUTE notification per-route might confuse existing
  routing daemons.
- Convergence reasons in routing daemons.
- The extra notifications will negatively impact the insertion rate.
- Not all users are interested in these notifications.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 20 +++++++++++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/af_inet.c                     |  2 ++
 net/ipv4/fib_trie.c                    | 27 ++++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 5 files changed, 60 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..01927b36bbee 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -178,6 +178,26 @@ min_adv_mss - INTEGER
 	The advertised MSS depends on the first hop route MTU, but will
 	never be lower than this setting.
 
+fib_notify_on_flag_change - INTEGER
+        Whether to emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/
+        RTM_F_TRAP flags are changed.
+
+        After installing a route to the kernel, user space receives an
+        acknowledgment, which means the route was installed in the kernel,
+        but not necessarily in hardware.
+        It is also possible for a route already installed in hardware to change
+        its action and therefore its flags. For example, a host route that is
+        trapping packets can be "promoted" to perform decapsulation following
+        the installation of an IPinIP/VXLAN tunnel.
+        The notifications will indicate to user-space the state of the route.
+
+        Default: 0 (Do not emit notifications.)
+
+        Possible values:
+
+        - 0 - Do not emit notifications.
+        - 1 - Emit notifications.
+
 IP Fragmentation:
 
 ipfrag_high_thresh - LONG INTEGER
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 8e4fcac4df72..70a2a085dd1a 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -188,6 +188,8 @@ struct netns_ipv4 {
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
 
+	int sysctl_fib_notify_on_flag_change;
+
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_udp_l3mdev_accept;
 #endif
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b94fa8eb831b..ab42f6404fc6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1871,6 +1871,8 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.sysctl_igmp_llm_reports = 1;
 	net->ipv4.sysctl_igmp_qrv = 2;
 
+	net->ipv4.sysctl_fib_notify_on_flag_change = 0;
+
 	return 0;
 }
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 28117c05dc35..60559b708158 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1038,6 +1038,8 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
 	struct fib_alias *fa_match;
+	struct sk_buff *skb;
+	int err;
 
 	rcu_read_lock();
 
@@ -1045,9 +1047,34 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	if (!fa_match)
 		goto out;
 
+	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap)
+		goto out;
+
 	fa_match->offload = fri->offload;
 	fa_match->trap = fri->trap;
 
+	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+		goto out;
+
+	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto errout;
+	}
+
+	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_ROUTE, NULL, GFP_ATOMIC);
+	goto out;
+
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_IPV4_ROUTE, err);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3e5f4f2e705e..e5798b3b59d2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1354,6 +1354,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ONE
 	},
+	{
+		.procname	= "fib_notify_on_flag_change",
+		.data		= &init_net.ipv4.sysctl_fib_notify_on_flag_change,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
-- 
2.29.2

