Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBBA190D73
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCXMb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:31:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35533 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgCXMbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:31:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so8969528pgr.2;
        Tue, 24 Mar 2020 05:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=djbKCaqS+TKD77Tlh4JwH9yLK2oEV/Wol+ObqXwwa7Q=;
        b=RcKXWgpPYI5AvCqNOJ2eW7ZIErLVGwFJ75FIJJwWSUkte44zPo98jaQQwgWZNqCWas
         as2Hd8yLXwG5pdgt1xzqgDq9vxNOZ3KTAb5cR4M+Bu9nYKt+GGAAsJpzVxGgw47dDSwn
         nDv4P8dMI4wSV87Vgm6v1tPAIWIBrhXK6Ts/fJWnfAG/g1dZEJNkyiVzJVbsfQNJkGId
         jHjAv6cinJN+9PYOPYwqeOPW15blPYEIz+m/goYrGWgfqUOtjv52T8kfSamk7jxLmXPt
         1pc1/TNKjuHsYO+3sFxaP1DeXcNkD6KzkMTSGFGLiLNPR6B74USDulQalkwpcXIqZORp
         IP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=djbKCaqS+TKD77Tlh4JwH9yLK2oEV/Wol+ObqXwwa7Q=;
        b=gJ8+SeUdRgzXnV8E0kTyVmmiEnIICykj1gE8yVjkDkIxpEo/Rl3DqnJSIK2alScyd5
         +ugCC61ziWc0HBcmeSiuKPsXndvop/mneU1B06k497FqCWmSD/0yoLBpJwK7SkUpEHrh
         +oInW+WuH2m55J7vSSQoie/MnEHT/mdUtTqSl6Uv0h5NbyC9O9nABBvA5V5UdMN3W7j0
         N4yYL7YR7I+hY/Pb3SKlhM3kxfeFKgPZqosruJGkB2cdDX4N3GKRn5lD0VuQ7FBUJxyS
         crOB3h1KIrsOCr2OtFRYJzUkExQMKS3zZp+5N8Eho0b6ptoWvdVB2OXBNE86RsiFz+IX
         S7Yw==
X-Gm-Message-State: ANhLgQ3OJsb6MQKnGBYLIY3/m2M43mvTxxV5MpGEVzlhz8twKyizZdHy
        f/T0RIRIlttUITGC3kLjs8Q=
X-Google-Smtp-Source: ADFU+vtNUAXvFR94kwsUBwBDdbO17XfeFEF38u4wAqo4l+XZa01wNMK7+YpH+2F3AsNeCLa84JV9fQ==
X-Received: by 2002:a62:7911:: with SMTP id u17mr28535280pfc.305.1585053084203;
        Tue, 24 Mar 2020 05:31:24 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s27sm226122pgn.90.2020.03.24.05.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 05:31:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net 3/3] net: core: avoid warning in dev_change_net_namespace()
Date:   Tue, 24 Mar 2020 12:31:15 +0000
Message-Id: <20200324123115.19076-1-ap420073@gmail.com>
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
[   32.793965][  T986] WARNING: CPU: 3 PID: 986 at net/core/dev.c:10098 dev_change_net_namespace+0x9be/0xc10
[   32.795213][  T986] Modules linked in: bonding dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 x
[   32.797369][  T986] CPU: 3 PID: 986 Comm: ip Not tainted 5.6.0-rc5+ #474
[   32.798137][  T986] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   32.799111][  T986] RIP: 0010:dev_change_net_namespace+0x9be/0xc10
[   32.799838][  T986] Code: 45 34 b2 c6 05 85 a4 87 01 01 e8 0d aa c7 fe 0f 0b e9 dd f6 ff ff b8 ea ff ff ff e9 82 fb ff
[   32.805599][  T986] RSP: 0018:ffff88804aeeee60 EFLAGS: 00010282
[   32.806247][  T986] RAX: 00000000ffffffef RBX: ffff888057151000 RCX: 0000000000000006
[   32.807110][  T986] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88804ac2c014
[   32.807997][  T986] RBP: ffff8880571510b8 R08: fffffbfff67b65cc R09: fffffbfff67b65cc
[   32.808873][  T986] R10: 0000000000000001 R11: fffffbfff67b65cb R12: ffff8880571510a0
[   32.809720][  T986] R13: ffff88804b9f0040 R14: ffff888057151090 R15: ffff888057151c08
[   32.810575][  T986] FS:  00007f0c9d5960c0(0000) GS:ffff88806cc00000(0000) knlGS:0000000000000000
[   32.811540][  T986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.812314][  T986] CR2: 00007fcaf6747590 CR3: 0000000049c58005 CR4: 00000000000606e0
[   32.813191][  T986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.814052][  T986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   32.822906][  T986] Call Trace:
[   32.823294][  T986]  ? do_dup2+0x450/0x450
[   32.823828][  T986]  ? dev_get_valid_name+0xc0/0xc0
[   32.824421][  T986]  ? ns_capable_common+0x5c/0xd0
[   32.825007][  T986]  ? __netlink_ns_capable+0xc3/0xf0
[   32.825650][  T986]  do_setlink+0x163/0x2ef0
[   32.826088][  T986]  ? is_bpf_image_address+0xff/0x1d0
[   32.826663][  T986]  ? rtnl_getlink+0x8a0/0x8a0
[   32.827275][  T986]  ? __kernel_text_address+0xe/0x30
[   32.827999][  T986]  ? unwind_get_return_address+0x5f/0xa0
[   32.828793][  T986]  ? create_prof_cpu_mask+0x20/0x20
[   32.829391][  T986]  ? arch_stack_walk+0x83/0xb0
[   32.829949][  T986]  ? memset+0x1f/0x40
[   32.830410][  T986]  ? __nla_validate_parse+0x98/0x1ab0
[   32.831046][  T986]  ? nla_memcpy+0x90/0x90
[   32.831544][  T986]  ? __lock_acquire+0xdfe/0x3de0
[   32.832136][  T986]  __rtnl_newlink+0x9c5/0x1270
[ ... ]

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
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
index 3d56b026bb9e..725e26c4962c 100644
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
index 402a986659cf..8a4d9a23fb63 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10037,6 +10037,10 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
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

