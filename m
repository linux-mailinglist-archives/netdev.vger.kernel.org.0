Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F50A290AC0
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390540AbgJPR3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:29:35 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58245 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389852AbgJPR3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:29:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C40B7B57;
        Fri, 16 Oct 2020 13:29:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Oct 2020 13:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RItVByjQCrLrEhk/I
        Pd3UGeblYO7Go1U0n5N49J1wf4=; b=O38KQZBc9IqeSWcl230VySCVHfsS8uEvc
        ETjxANVpwo4VtbYdqPDZfcp2wvPrd3LIHkbAERrXycrXEAMJlNB8//7CO9l9/WNF
        /r3yCwrhkuq64YxJZDtiJ0kvIJgXJeRaDuPf1xzPq5u+hRSuWzDTitX7wWZ66ao3
        9YalC3YPfDSseKDzOKjR+cqe0X+w9SetN/dmZa4QwwjJT2hNejr6OolF352bl5k2
        WjfARE2tPRyH9XujHjfyLNNQB9PguZTxqDZ9Fkm95LNA3g3GQGWD9loNbo/6ZZRG
        i30ML7rLg7hlT4meVByKB/q7DDkqxGkYKVrV7sHx4C6hadL5HJAWA==
X-ME-Sender: <xms:fdiJX3eJtuX92KGtkqh2-UOAWrLWhZmbr8OHbuDjoq1t447dB0PYBw>
    <xme:fdiJX9ON4wFbPP5N8aQ54XXLUwmrjZiF4_HvpbAuJvnqef48g3ZhurYjdntyhpdkK
    X61Pw7E0lByzN8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieehgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeejrddugeeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fdiJXwhNM--dFdQLlF7KdClHRsxUNJ-rVLddITYbhoBlfByBDrqRMw>
    <xmx:fdiJX49oUCilRIcj5F98R5Lfxx-N65Nq7__zy3wzm2u7BiyU1HsswA>
    <xmx:fdiJXzvDRArhc6olqHU-cfAZLhrn3WUqUutVCoyNUiIpf-HUIbcSjA>
    <xmx:fdiJXzIhVmSk-hK1ubmVzhXUsqQOxEFQme-nIC713g1pldsfpPbYCg>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7F6F306467E;
        Fri, 16 Oct 2020 13:29:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] nexthop: Fix performance regression in nexthop deletion
Date:   Fri, 16 Oct 2020 20:29:14 +0300
Message-Id: <20201016172914.643282-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

While insertion of 16k nexthops all using the same netdev ('dummy10')
takes less than a second, deletion takes about 130 seconds:

# time -p ip -b nexthop.batch
real 0.29
user 0.01
sys 0.15

# time -p ip link set dev dummy10 down
real 131.03
user 0.06
sys 0.52

This is because of repeated calls to synchronize_rcu() whenever a
nexthop is removed from a nexthop group:

# /usr/share/bcc/tools/offcputime -p `pgrep -nx ip` -K
...
    b'finish_task_switch'
    b'schedule'
    b'schedule_timeout'
    b'wait_for_completion'
    b'__wait_rcu_gp'
    b'synchronize_rcu.part.0'
    b'synchronize_rcu'
    b'__remove_nexthop'
    b'remove_nexthop'
    b'nexthop_flush_dev'
    b'nh_netdev_event'
    b'raw_notifier_call_chain'
    b'call_netdevice_notifiers_info'
    b'__dev_notify_flags'
    b'dev_change_flags'
    b'do_setlink'
    b'__rtnl_newlink'
    b'rtnl_newlink'
    b'rtnetlink_rcv_msg'
    b'netlink_rcv_skb'
    b'rtnetlink_rcv'
    b'netlink_unicast'
    b'netlink_sendmsg'
    b'____sys_sendmsg'
    b'___sys_sendmsg'
    b'__sys_sendmsg'
    b'__x64_sys_sendmsg'
    b'do_syscall_64'
    b'entry_SYSCALL_64_after_hwframe'
    -                ip (277)
        126554955

Since nexthops are always deleted under RTNL, synchronize_net() can be
used instead. It will call synchronize_rcu_expedited() which only blocks
for several microseconds as opposed to multiple milliseconds like
synchronize_rcu().

With this patch deletion of 16k nexthops takes less than a second:

# time -p ip link set dev dummy10 down
real 0.12
user 0.00
sys 0.04

Tested with fib_nexthops.sh which includes torture tests that prompted
the initial change:

# ./fib_nexthops.sh
...
Tests passed: 134
Tests failed:   0

Fixes: 90f33bffa382 ("nexthops: don't modify published nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8c0f17c6863c..0dc43ad28eb9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -845,7 +845,7 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 		remove_nh_grp_entry(net, nhge, nlinfo);
 
 	/* make sure all see the newly published array before releasing rtnl */
-	synchronize_rcu();
+	synchronize_net();
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
-- 
2.26.2

