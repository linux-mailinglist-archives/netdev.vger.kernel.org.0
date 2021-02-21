Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76B5320B85
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 16:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhBUPqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 10:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBUPqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 10:46:44 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81266C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 07:46:03 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z68so8535551pgz.0
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 07:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZsQNmqrANpZKWK8wSftN8J/waqUg/B4mFTBOFpZ0+pw=;
        b=fY3qahwkQ4Ge2AY/lyLW5tvRWDGtu87+u86kDOxUjOBbL4caP7dg8P1QFWZV0yjMmv
         mNtPnxbdgIAB5EHJVOEUszpL7mCRGivZCbQEl5s0BZa88tDrl601W2JVEXP5rhMGDDQt
         ZCDpci6YYfLnQ76nidSEQfXeqn9AcyVnai76bLgV3w7daKktfynZNaAz0eXgK5kdpLf+
         mKmbgtAaB2celVPTN/LG5ndjDuV4i1/JmRJ+QHnIBmbEiZ/+1XhrL10IZ7lXy+jmrFZO
         9KUscxhzAORpxMrIbI2mhDRLrWSTwZKEYGML8NDd1PqS1RjTwwBysk/YIgnOkkc+9YbG
         3Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZsQNmqrANpZKWK8wSftN8J/waqUg/B4mFTBOFpZ0+pw=;
        b=WW8YohamaQUFUjHiuyyjhzBkj5sbE84Wztyg5xO9W9Q2k2fXnK5Ib7dZcbfgDhdmgX
         llf4PeGyNejEOHuP3jZ7NuX4XTDvNwOzDC4XPtZ+LI85upU+MtjM/p7hAnQNPhoOM2mg
         DiOyB3EZJLS0RqqI1WUk6gGSZ1v1yNV9fYdpFIyerod6X6O2bqClqCV61L5fI9F6Uiam
         mY8+LwNtAO1J/r8uJH9LNOFISGma/UpC3Ft+AyXO8VB4a9R/YUXG6/hv3fFevj/beMTA
         3iVC521+QUy51nvlpfUP88El8nVjehG5aJGNYmOD0JoOH87VBKqyEBbgJonOtL90MKWh
         mgSg==
X-Gm-Message-State: AOAM5318wZSBetkmhjF+13nywGpxFgZiCx9wKIUSb/8oZ93eeiJ5+9Gg
        Z2wMTi1e4d3H7FdEVKLb3rs=
X-Google-Smtp-Source: ABdhPJx9De80UtmsRtqKfmG0aUXzGw9aP1LahnFM8eqIiuD/fpqVbcq+dv3i/LLTq5MTKfpN9LF/kA==
X-Received: by 2002:aa7:9a09:0:b029:1ed:9919:b989 with SMTP id w9-20020aa79a090000b02901ed9919b989mr2491467pfj.20.1613922362743;
        Sun, 21 Feb 2021 07:46:02 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id z12sm14681234pjz.16.2021.02.21.07.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 07:46:02 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, vvs@virtuozzo.com, fw@strlen.de
Subject: [PATCH net] vxlan: move debug check after netdev unregister
Date:   Sun, 21 Feb 2021 15:45:52 +0000
Message-Id: <20210221154552.11749-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debug check must be done after unregister_netdevice_many() call --
the hlist_del_rcu() for this is done inside .ndo_stop.

This is the same with commit 0fda7600c2e1 ("geneve: move debug check after
netdev unregister")

Test commands:
    ip netns del A
    ip netns add A
    ip netns add B

    ip netns exec B ip link add vxlan0 type vxlan vni 100 local 10.0.0.1 \
	    remote 10.0.0.2 dstport 4789 srcport 4789 4789
    ip netns exec B ip link set vxlan0 netns A
    ip netns exec A ip link set vxlan0 up
    ip netns del B

Splat looks like:
[   73.176249][    T7] ------------[ cut here ]------------
[   73.178662][    T7] WARNING: CPU: 4 PID: 7 at drivers/net/vxlan.c:4743 vxlan_exit_batch_net+0x52e/0x720 [vxlan]
[   73.182597][    T7] Modules linked in: vxlan openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 mlx5_core nfp mlxfw ixgbevf tls sch_fq_codel nf_tables nfnetlink ip_tables x_tables unix
[   73.190113][    T7] CPU: 4 PID: 7 Comm: kworker/u16:0 Not tainted 5.11.0-rc7+ #838
[   73.193037][    T7] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   73.196986][    T7] Workqueue: netns cleanup_net
[   73.198946][    T7] RIP: 0010:vxlan_exit_batch_net+0x52e/0x720 [vxlan]
[   73.201509][    T7] Code: 00 01 00 00 0f 84 39 fd ff ff 48 89 ca 48 c1 ea 03 80 3c 1a 00 0f 85 a6 00 00 00 89 c2 48 83 c2 02 49 8b 14 d4 48 85 d2 74 ce <0f> 0b eb ca e8 b9 51 db dd 84 c0 0f 85 4a fe ff ff 48 c7 c2 80 bc
[   73.208813][    T7] RSP: 0018:ffff888100907c10 EFLAGS: 00010286
[   73.211027][    T7] RAX: 000000000000003c RBX: dffffc0000000000 RCX: ffff88800ec411f0
[   73.213702][    T7] RDX: ffff88800a278000 RSI: ffff88800fc78c70 RDI: ffff88800fc78070
[   73.216169][    T7] RBP: ffff88800b5cbdc0 R08: fffffbfff424de61 R09: fffffbfff424de61
[   73.218463][    T7] R10: ffffffffa126f307 R11: fffffbfff424de60 R12: ffff88800ec41000
[   73.220794][    T7] R13: ffff888100907d08 R14: ffff888100907c50 R15: ffff88800fc78c40
[   73.223337][    T7] FS:  0000000000000000(0000) GS:ffff888114800000(0000) knlGS:0000000000000000
[   73.225814][    T7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.227616][    T7] CR2: 0000562b5cb4f4d0 CR3: 0000000105fbe001 CR4: 00000000003706e0
[   73.229700][    T7] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.231820][    T7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   73.233844][    T7] Call Trace:
[   73.234698][    T7]  ? vxlan_err_lookup+0x3c0/0x3c0 [vxlan]
[   73.235962][    T7]  ? ops_exit_list.isra.11+0x93/0x140
[   73.237134][    T7]  cleanup_net+0x45e/0x8a0
[ ... ]

Fixes: 0e4ec5acad8b ("vxlan: exit_net cleanup checks added")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a8ad710629e6..0842371eca3d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4725,7 +4725,6 @@ static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan, *next;
 	struct net_device *dev, *aux;
-	unsigned int h;
 
 	for_each_netdev_safe(net, dev, aux)
 		if (dev->rtnl_link_ops == &vxlan_link_ops)
@@ -4739,14 +4738,13 @@ static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
 			unregister_netdevice_queue(vxlan->dev, head);
 	}
 
-	for (h = 0; h < PORT_HASH_SIZE; ++h)
-		WARN_ON_ONCE(!hlist_empty(&vn->sock_list[h]));
 }
 
 static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 {
 	struct net *net;
 	LIST_HEAD(list);
+	unsigned int h;
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list) {
@@ -4759,6 +4757,13 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
+
+	list_for_each_entry(net, net_list, exit_list) {
+		struct vxlan_net *vn = net_generic(net, vxlan_net_id);
+
+		for (h = 0; h < PORT_HASH_SIZE; ++h)
+			WARN_ON_ONCE(!hlist_empty(&vn->sock_list[h]));
+	}
 }
 
 static struct pernet_operations vxlan_net_ops = {
-- 
2.17.1

