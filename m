Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A235F25FDB6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgIGP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbgIGPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:55:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1638C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 08:55:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so8211397pgl.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LWOmlmQoF3TaWOo2GtIcX+gnjgbnREfLyUi3/TqeQnQ=;
        b=nWvngLRwzdK/W37q5zAERRErUIwq/rIv5zhyUTx96bTNHzy088GZoIa/Xvrev0ZLTP
         2rRy94gO/yhOvaYvmhNNxNaWVFZoQKmY4PJfmQObDbyf77XWxwcWW1f23ju1iuQMFpbL
         7ZgLEaFtQLQQwyA04NwGvZaF6uoQ2mgNAbIGUaOwg2noW8NjwPZZrOzy7LVDMpnTvAHr
         87QhPrFnAd4WRHeRcCMe34863iAQsFh8IgApBaT6kH4Puq1Zl4gowVXjiJJhvIJxU6mA
         cviRtPEo/w/oQMW4kcy4+ukBy1zZ1FOzzA2i7kCthYXCBkKZhLY/S7OqDxpfkcMzBDXl
         Pt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LWOmlmQoF3TaWOo2GtIcX+gnjgbnREfLyUi3/TqeQnQ=;
        b=rScnMRbHRqWKcjwmGVURjpcLTJ+FumquAALMx6pxoIm3xICnhKMfNGOX3p1ezOkU08
         5W24h2cqL+8jk82GOe0bChg5ICqK/trEFDdQh7w8Uu7zTkvu/FhG7GmI6Exs5LqrBiE/
         GGV8kGf3fUl/YHe6QB74H87z9FOqmDE1Vu2XFA82bNFuFSIY78fjd9tF4Gj7xzj0Ulf+
         x6hKSClfdEOkDnutxQ9mV79ukghxzCX3SLko76MBVDPQO7XYfIFTDLUpjdMEJm3GTOKY
         bwV1vtS/dO8JM5JN6NuiWGr2cPOjBs1yqCuCNiQxpy36fC+C9/wiqJr7wMYqd7/MaL5Z
         EMXg==
X-Gm-Message-State: AOAM5316kQB2sz4bEAXi2G1ihPd1C/ocqfvbpFRB04lh8Wa1CBrTZpcS
        MQgkVQKnBD/UbHtDuRPdt0g=
X-Google-Smtp-Source: ABdhPJwHc1qvmRqGQGl/VEM+M8AzJqPv+hvuGZM/aTNrKAmUnR9z3sUAEVNBWs0farkAq62i/Y0ayw==
X-Received: by 2002:aa7:930a:: with SMTP id 10mr6400885pfj.91.1599494142153;
        Mon, 07 Sep 2020 08:55:42 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id c3sm15489048pfo.120.2020.09.07.08.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:55:41 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, gnault@redhat.com
Subject: [PATCH net v2] Revert "netns: don't disable BHs when locking "nsid_lock""
Date:   Mon,  7 Sep 2020 15:54:41 +0000
Message-Id: <20200907155441.5938-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 8d7e5dee972f1cde2ba96c621f1541fa36e7d4f4.

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

Acked-by: Guillaume Nault <gnault@redhat.com>
Fixes: 8d7e5dee972f ("netns: don't disable BHs when locking "nsid_lock"")
Reported-by: syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Use git revert template

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

