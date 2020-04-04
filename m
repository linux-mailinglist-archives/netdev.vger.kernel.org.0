Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A059A19E57C
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDDOTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 10:19:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34360 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDOTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 10:19:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so4008559plm.1;
        Sat, 04 Apr 2020 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FQZ87IqMgNSbWHXUc3DVaj/f2JBKgxMopHxIVMyYK98=;
        b=p3m27AyDHmdxfRJhrqvH57lz+PzJDwICr5tmnu7wifkJKXW5TigDxWVr4K9AJba6qc
         HrTISnsEFOvjlMlT24tCAk5pwX2XmtRl9d94Vbx6h1h9uoSRywAb9JS7arigyBE7SIpv
         JiG/yOrPJgLFRSML80N6B5KI4wuJeH65NcWWOl1A1JeSRWHcAutJiKk1y8jvMbt6Bj1a
         tYF3hCg1CS4nIFRWjVIHloAUZJ537Axjvx+P0vJ1rwlyVvj+BZ2WuYZ0NpEpNyW3JnKX
         Nj4JxX/LMfIYC8epl1MIQvYapfePF5+HVldnQ0TijbjWJVAVg3OirW17putz2lgVJvyG
         AesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FQZ87IqMgNSbWHXUc3DVaj/f2JBKgxMopHxIVMyYK98=;
        b=ewcb/d0Xt5xeAu6y9+OKASo74HhpUdxzwDnf0sXlVeh1JTxzkKdHVNOAPxMkkwAqpN
         NYK79+gq6ZhOQy/WqJA8j1DiZQo4io0l+Wiv1jekRcQF4niDMz5IiEJJ8mP9HzGkLetC
         XQQMS2ro9s2JAfhv7gS69kcozztWIrgcmosdIMqvQy83RZokdh0svhatzrXNwVVdXOyO
         grbmrpRNfBdeGy1A4tK9/+PrckMEg8+phW4bxCuVUiCXkJJsC7v2+4qK6cnySM/51B0x
         eU97omo4Yavf2FfFWB/z8cSIRnB5xURHIJeRdtJYyGrk1UHaSc/DYy9l3/8D35lOlaq+
         AAOw==
X-Gm-Message-State: AGi0PuYCzEB6TEkseznLFbO48ij1GbKfzPyxBLGpFuzqHrc+7+VcNyqa
        KnWlj6PfFrJZ9KNmoT+cfMQ=
X-Google-Smtp-Source: APiQypJGttGtx8hTXs2pI9Mfqxpd3HNJmLrKFx1NYY3Yuk6Zhkp8KchsYjqOdDiXleRtFjmCw4QIjQ==
X-Received: by 2002:a17:902:8c94:: with SMTP id t20mr12392555plo.170.1586009971820;
        Sat, 04 Apr 2020 07:19:31 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id t66sm7876837pjb.45.2020.04.04.07.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 07:19:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net v2 3/3] net: core: avoid warning in dev_change_net_namespace()
Date:   Sat,  4 Apr 2020 14:19:22 +0000
Message-Id: <20200404141922.26492-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When interface's namespace is being changed, dev_change_net_namespace()
is called. This removes and re-allocates many resources that include
sysfs files. The "/net/class/net/<interface name>" is one of them.
If the sysfs creation routine(device_rename()) found duplicate sysfs
file name, it warns about it and fails. But unfortunately, at that point,
dev_change_net_namespace() doesn't return fail because rollback cost
is too high.
So, the interface can't have a sysfs file.

The approach of this patch is to find the duplicate sysfs file as
fast as possible. If it found that, dev_change_net_namespace() returns
fail immediately with zero rollback cost.

This patch includes two other things.
a) Acquire rtnl_lock() in both bond_create_sysfs() and bond_destroy_sysfs()
   to avoid race condition.
b) Do not remove "/sys/class/net/bonding_masters" sysfs file by
   bond_destroy_sysfs() if the file wasn't created by bond_create_sysfs().

Test commands:
    ip netns add nst
    ip link add bonding_masters type dummy
    modprobe bonding
    ip link set bonding_masters netns nst

Splat looks like:
[ 6396.214052] WARNING: CPU: 2 PID: 1167 at net/core/dev.c:10119 dev_change_net_namespace+0xa13/0xcb0
[ 6396.215087] Modules linked in: bonding dummy bareudp openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 af_packet e1000 sch_fq_codel nf_tables nfnetlink ip_tables x_tables unix
[ 6396.217064] CPU: 2 PID: 1167 Comm: ip Not tainted 5.6.0+ #492
[ 6396.217885] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 6396.219046] RIP: 0010:dev_change_net_namespace+0xa13/0xcb0
[ 6396.219845] Code: e9 bc f6 ff ff 4c 8b 64 24 28 e9 a5 fc ff ff b8 ea ff ff ff e9 65 fb ff ff e8 f9 00 27 ff e9 f5 f6 ff ff 0f 0b e9 0b fb ff ff <0f> 0b e9 ec fa ff ff b8 ef ff ff ff e9 43 fb ff ff 4c 89 ff 48 89
[ 6396.222336] RSP: 0018:ffff8880518a6dd0 EFLAGS: 00010282
[ 6396.223114] RAX: 00000000ffffffef RBX: ffff888057049000 RCX: ffff888051a8c000
[ 6396.224128] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffb8dc0074
[ 6396.225265] RBP: ffff8880570490a0 R08: fffffbfff7166089 R09: fffffbfff7166089
[ 6396.226307] R10: 0000000000000001 R11: fffffbfff7166088 R12: ffff8880570490b8
[ 6396.227333] R13: ffff888057398040 R14: ffff888057398040 R15: ffff888057049090
[ 6396.228350] FS:  00007fdb2d3710c0(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[ 6396.229514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6396.230403] CR2: 000055ec001c4910 CR3: 000000006591c001 CR4: 00000000000606e0
[ 6396.231414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6396.232420] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6396.233463] Call Trace:
[ 6396.233907]  ? do_dup2+0x450/0x450
[ 6396.234452]  ? deref_stack_reg+0x9c/0xd0
[ 6396.235078]  ? dev_get_valid_name+0xc0/0xc0
[ 6396.235718]  ? ns_capable_common+0x5c/0xd0
[ 6396.236342]  ? __netlink_ns_capable+0xc3/0xf0
[ 6396.237022]  do_setlink+0x171/0x2f70
[ 6396.237663]  ? check_flags.part.41+0x450/0x450
[ 6396.238393]  ? unwind_next_frame+0xb77/0x1c30
[ 6396.239113]  ? rtnl_getlink+0x8a0/0x8a0
[ 6396.239751]  ? is_bpf_text_address+0x81/0xe0
[ 6396.240447]  ? kernel_text_address+0x111/0x120
[ 6396.241177]  ? __kernel_text_address+0xe/0x30
[ 6396.241860]  ? unwind_get_return_address+0x5f/0xa0
[ 6396.242571]  ? create_prof_cpu_mask+0x20/0x20
[ 6396.243239]  ? arch_stack_walk+0x83/0xb0
[ 6396.243842]  ? pskb_expand_head+0x25f/0xe10
[ 6396.244479]  ? stack_trace_save+0x82/0xb0
[ 6396.245103]  ? memset+0x1f/0x40
[ 6396.245616]  ? __nla_validate_parse+0x98/0x1ab0
[ 6396.246297]  ? register_lock_class+0x19e0/0x19e0
[ 6396.246986]  ? __kasan_slab_free+0x111/0x150
[ 6396.247629]  ? kfree+0xce/0x2f0
[ 6396.248129]  ? netlink_trim+0x196/0x1f0
[ 6396.248715]  ? nla_memcpy+0x90/0x90
[ 6396.249258]  ? register_lock_class+0x19e0/0x19e0
[ 6396.249958]  ? deref_stack_reg+0x9c/0xd0
[ 6396.250556]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[ 6396.251387]  ? entry_SYSCALL_64_after_hwframe+0x49/0xb3
[ 6396.252154]  __rtnl_newlink+0x9c5/0x1270
[ ... ]

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change commit log.

 drivers/net/bonding/bond_sysfs.c | 13 ++++++++++++-
 include/net/bonding.h            |  1 +
 net/core/dev.c                   |  4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 2d615a93685e..02c0ae58b9db 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -772,9 +772,13 @@ int bond_create_sysfs(struct bond_net *bn)
 {
 	int ret;
 
+	bn->skip_destroy_class = false;
 	bn->class_attr_bonding_masters = class_attr_bonding_masters;
 	sysfs_attr_init(&bn->class_attr_bonding_masters.attr);
 
+	rtnl_lock();
+	if (netdev_class_has_file_ns("bonding_masters", bn->net))
+		goto err;
 	ret = netdev_class_create_file_ns(&bn->class_attr_bonding_masters,
 					  bn->net);
 	/* Permit multiple loads of the module by ignoring failures to
@@ -788,13 +792,16 @@ int bond_create_sysfs(struct bond_net *bn)
 	 * configure multiple bonding devices.
 	 */
 	if (ret == -EEXIST) {
+err:
 		/* Is someone being kinky and naming a device bonding_master? */
 		if (__dev_get_by_name(bn->net,
 				      class_attr_bonding_masters.attr.name))
 			pr_err("network device named %s already exists in sysfs\n",
 			       class_attr_bonding_masters.attr.name);
 		ret = 0;
+		bn->skip_destroy_class = true;
 	}
+	rtnl_unlock();
 
 	return ret;
 
@@ -803,7 +810,11 @@ int bond_create_sysfs(struct bond_net *bn)
 /* Remove /sys/class/net/bonding_masters. */
 void bond_destroy_sysfs(struct bond_net *bn)
 {
-	netdev_class_remove_file_ns(&bn->class_attr_bonding_masters, bn->net);
+	rtnl_lock();
+	if (!bn->skip_destroy_class)
+		netdev_class_remove_file_ns(&bn->class_attr_bonding_masters,
+					    bn->net);
+	rtnl_unlock();
 }
 
 /* Initialize sysfs for each bond.  This sets up and registers
diff --git a/include/net/bonding.h b/include/net/bonding.h
index dc2ce31a1f52..c04b0a0ac767 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -607,6 +607,7 @@ struct bond_net {
 	struct proc_dir_entry	*proc_dir;
 #endif
 	struct class_attribute	class_attr_bonding_masters;
+	bool skip_destroy_class;
 };
 
 int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9c9e763bfe0e..a3a151142bc8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10058,6 +10058,10 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 			goto out;
 	}
 
+	err = -EEXIST;
+	if (netdev_class_has_file_ns(dev->name, net))
+		goto out;
+
 	/*
 	 * And now a mini version of register_netdevice unregister_netdevice.
 	 */
-- 
2.17.1

