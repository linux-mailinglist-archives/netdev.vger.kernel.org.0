Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344925EE45
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgIFOhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgIFOeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 10:34:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F7FC061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 07:34:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w186so6772419pgb.8
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 07:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+bM41kxyml6yCth4Mwty5ISSovAMLgFnRSP5d7bmRoI=;
        b=qBcpUOloL5ia9n4PEVanDagAnsqu2HMa0xNODwvIiNZ/2qsTDtusl47aXH9ontj5zY
         iLb+jS0vTtCLZDqu8G7B7eGyVeiTSzkBbTDXrR05JWESbdpoo4Gtda1Y5Jyb26bjdC63
         HsSXH7Jidifo+g/LBYgYunodw2P+VAz3Hgl+bmj72FzyBA1WJBBelyHFjYrcCRMgLFHk
         aVTyIVbVBCY3AQBcG9WSlBAW4nmpB79XiOIs95Xz8gv0IxWmdvvWU3xGfYptdyuFU2Ag
         eeSkuPGLwoBnBlZwg0ToD6RT0Uis4ZOixtIcYboXcXDP3xlCrK6E7YtHr4Ft6e1Qxg5c
         NwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+bM41kxyml6yCth4Mwty5ISSovAMLgFnRSP5d7bmRoI=;
        b=BEVdKN9hei45p4lJp7M2fle1qtkHqGbm6rUAxv26eF27b41Xv8iQRcUEA1e85bOjav
         5XWE0mQ6x2urhtWQ+sVROUhxoKqMwcbqjkI5k3Kvwu4vIqWgF6Hjd3nEI28fiU+5L/a+
         wxVlLGBS4f8s0DZtwD/MUn7oglnCd4pQj2g+XyhFmmfaZHk64iqwy8EBW7emkEuarFDi
         1fh4MgDjOG0YqWrwsk/aLmwhVzN6F74DMGMbP3Dy4uWN8R1eX7fj+iSLwsy17gUbpaMn
         ueiTYwrAkCUC+tf904sN7+87XIacx2XqZKeozvKtRQwaE4tz3eHPi9pJlWS7NKToxRhd
         +PGA==
X-Gm-Message-State: AOAM531LeMsQLXWylr85LZfIkC9ZdWRGZv0PVyft8jonIiD0bFCEqbfy
        ZjxpksDiVeTtVrHAhMvcemc=
X-Google-Smtp-Source: ABdhPJyyIq9qmJzPGbvA9LCVSQmv3gKACxlZpl/5BiMP59oXCZ8+Uc05zRiHpxLDFaeZMXvzjtk5YQ==
X-Received: by 2002:a62:1b81:: with SMTP id b123mr16900443pfb.149.1599402852159;
        Sun, 06 Sep 2020 07:34:12 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id x9sm10450823pgi.87.2020.09.06.07.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 07:34:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, gnault@redhat.com
Subject: [PATCH net] netns: fix a deadlock in peernet2id_alloc()
Date:   Sun,  6 Sep 2020 14:34:04 +0000
Message-Id: <20200906143404.31445-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To protect netns id, the nsid_lock is used when netns id is being
allocated and removed by peernet2id_alloc() and unhash_nsid().
The nsid_lock can be used in BH context but only spin_lock() is used
in this code.
Using spin_lock() instead of spin_lock_bh() can result in a deadlock in
the following scenario reported by the lockdep.
In order to avoid a deadlock, the spin_lock_bh() should be used instead
of spin_lock() to acquire nsid_lock.

Test commands:
    ip netns del nst
    ip netns add nst
    ip link add veth1 type veth peer name veth2
    ip link set veth1 netns nst
    ip netns exec nst ip link add name br1 type bridge vlan_filtering 1
    ip netns exec nst ip link set dev br1 up
    ip netns exec nst ip link set dev veth1 master br1
    ip netns exec nst ip link set dev veth1 up
    ip netns exec nst ip link add macvlan0 link br1 up type macvlan

Splat looks like:
[   33.615860][  T607] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
[   33.617194][  T607] 5.9.0-rc1+ #665 Not tainted
[ ... ]
[   33.670615][  T607] Chain exists of:
[   33.670615][  T607]   &mc->mca_lock --> &bridge_netdev_addr_lock_key --> &net->nsid_lock
[   33.670615][  T607]
[   33.673118][  T607]  Possible interrupt unsafe locking scenario:
[   33.673118][  T607]
[   33.674599][  T607]        CPU0                    CPU1
[   33.675557][  T607]        ----                    ----
[   33.676516][  T607]   lock(&net->nsid_lock);
[   33.677306][  T607]                                local_irq_disable();
[   33.678517][  T607]                                lock(&mc->mca_lock);
[   33.679725][  T607]                                lock(&bridge_netdev_addr_lock_key);
[   33.681166][  T607]   <Interrupt>
[   33.681791][  T607]     lock(&mc->mca_lock);
[   33.682579][  T607]
[   33.682579][  T607]  *** DEADLOCK ***
[ ... ]
[   33.922046][  T607] stack backtrace:
[   33.922999][  T607] CPU: 3 PID: 607 Comm: ip Not tainted 5.9.0-rc1+ #665
[   33.924099][  T607] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   33.925714][  T607] Call Trace:
[   33.926238][  T607]  dump_stack+0x78/0xab
[   33.926905][  T607]  check_irq_usage+0x70b/0x720
[   33.927708][  T607]  ? iterate_chain_key+0x60/0x60
[   33.928507][  T607]  ? check_path+0x22/0x40
[   33.929201][  T607]  ? check_noncircular+0xcf/0x180
[   33.930024][  T607]  ? __lock_acquire+0x1952/0x1f20
[   33.930860][  T607]  __lock_acquire+0x1952/0x1f20
[   33.931667][  T607]  lock_acquire+0xaf/0x3a0
[   33.932366][  T607]  ? peernet2id_alloc+0x3a/0x170
[   33.933147][  T607]  ? br_port_fill_attrs+0x54c/0x6b0 [bridge]
[   33.934140][  T607]  ? br_port_fill_attrs+0x5de/0x6b0 [bridge]
[   33.935113][  T607]  ? kvm_sched_clock_read+0x14/0x30
[   33.935974][  T607]  _raw_spin_lock+0x30/0x70
[   33.936728][  T607]  ? peernet2id_alloc+0x3a/0x170
[   33.937523][  T607]  peernet2id_alloc+0x3a/0x170
[   33.938313][  T607]  rtnl_fill_ifinfo+0xb5e/0x1400
[   33.939091][  T607]  rtmsg_ifinfo_build_skb+0x8a/0xf0
[   33.939953][  T607]  rtmsg_ifinfo_event.part.39+0x17/0x50
[   33.940863][  T607]  rtmsg_ifinfo+0x1f/0x30
[   33.941571][  T607]  __dev_notify_flags+0xa5/0xf0
[   33.942376][  T607]  ? __irq_work_queue_local+0x49/0x50
[   33.943249][  T607]  ? irq_work_queue+0x1d/0x30
[   33.943993][  T607]  ? __dev_set_promiscuity+0x7b/0x1a0
[   33.944878][  T607]  __dev_set_promiscuity+0x7b/0x1a0
[   33.945758][  T607]  dev_set_promiscuity+0x1e/0x50
[   33.946582][  T607]  br_port_set_promisc+0x1f/0x40 [bridge]
[   33.947487][  T607]  br_manage_promisc+0x8b/0xe0 [bridge]
[   33.948388][  T607]  __dev_set_promiscuity+0x123/0x1a0
[   33.949244][  T607]  __dev_set_rx_mode+0x68/0x90
[   33.950021][  T607]  dev_uc_add+0x50/0x60
[   33.950720][  T607]  macvlan_open+0x18e/0x1f0 [macvlan]
[   33.951601][  T607]  __dev_open+0xd6/0x170
[   33.952269][  T607]  __dev_change_flags+0x181/0x1d0
[   33.953056][  T607]  rtnl_configure_link+0x2f/0xa0
[   33.953884][  T607]  __rtnl_newlink+0x6b9/0x8e0
[   33.954665][  T607]  ? __lock_acquire+0x95d/0x1f20
[   33.955450][  T607]  ? lock_acquire+0xaf/0x3a0
[   33.956193][  T607]  ? is_bpf_text_address+0x5/0xe0
[   33.956999][  T607]  rtnl_newlink+0x47/0x70

Fixes: 8d7e5dee972f ("netns: don't disable BHs when locking "nsid_lock"")
Reported-by: syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/core/net_namespace.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index dcd61aca343e..944ab214e5ae 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -251,10 +251,10 @@ int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 	if (refcount_read(&net->count) == 0)
 		return NETNSA_NSID_NOT_ASSIGNED;
 
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	id = __peernet2id(net, peer);
 	if (id >= 0) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		return id;
 	}
 
@@ -264,12 +264,12 @@ int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 	 * just been idr_remove()'d from there in cleanup_net().
 	 */
 	if (!maybe_get_net(peer)) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		return NETNSA_NSID_NOT_ASSIGNED;
 	}
 
 	id = alloc_netid(net, peer, -1);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 
 	put_net(peer);
 	if (id < 0)
@@ -534,20 +534,20 @@ static void unhash_nsid(struct net *net, struct net *last)
 	for_each_net(tmp) {
 		int id;
 
-		spin_lock(&tmp->nsid_lock);
+		spin_lock_bh(&tmp->nsid_lock);
 		id = __peernet2id(tmp, net);
 		if (id >= 0)
 			idr_remove(&tmp->netns_ids, id);
-		spin_unlock(&tmp->nsid_lock);
+		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
 			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL,
 					  GFP_KERNEL);
 		if (tmp == last)
 			break;
 	}
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	idr_destroy(&net->netns_ids);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 }
 
 static LLIST_HEAD(cleanup_list);
@@ -760,9 +760,9 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return PTR_ERR(peer);
 	}
 
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	if (__peernet2id(net, peer) >= 0) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		err = -EEXIST;
 		NL_SET_BAD_ATTR(extack, nla);
 		NL_SET_ERR_MSG(extack,
@@ -771,7 +771,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = alloc_netid(net, peer, nsid);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
 		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
 				  nlh, GFP_KERNEL);
-- 
2.17.1

