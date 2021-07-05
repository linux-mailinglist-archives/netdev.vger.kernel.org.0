Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EAF3BC113
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhGEPl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhGEPlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA4FC06175F
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:38:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f20so9064447pfa.1
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lMSSdoWiTyyXbHxY8RuHT5ZkkeUWhPJEXNlMOqEppmY=;
        b=JjH+MLdJgwevILRyRtDlrWI/UyJQKA69mnaa43RRVamwhiB7ngebuZHkPh3Yqlr1x7
         A6PM561okVOKamdcq2mGn21UUz8uWhg3005qns54kQGpUWwRAO2K3CaKfkVBF9/rhEzX
         NqAPjZ6b9eNHNdhxlnvmzAZUpKcRSc6H8mO2uNSXIhRrpffue6SIHLINweXNr08lXqHt
         zzn34udUYb/J0f4Dg8SEV0LZeMantEOi0v5sCnL8EpNMWoG1QFenVXjiG17J5sVOysGy
         apoRP2QMACzezgo3D4JL+TwCz75f/N0Pb8flCdfIYttI4SC2u2xkHB+roBoDUGZajlha
         rxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lMSSdoWiTyyXbHxY8RuHT5ZkkeUWhPJEXNlMOqEppmY=;
        b=bSx3YGKP3DD3nQVNjSThCHx/EW+SIzvvRrIYvpoKvSjUeQwuE9ICCcLliOTqn+kGNQ
         6Gtc58GnOo+ALYVHEI3KLGrx3966NEzGi2Gxz+YuwQUq0JeQhSSeZoIfazibAC+1tKQY
         0sjkf3S4GeQ6FISgPvxxXRnub/kIg95aILO0iFiyz33nE0aN1WUNIP16AGn3kOq7HUwU
         yn4iGfohEHkyXCPZzE2DZnUurZ/v3dys4rOR5wXurkznTCzkQiSZLAYrFeUkkj9lJkIZ
         peps/1IP0Hb79I23jrGVlWezuNFsOWvoBKTww2LpEF7vNcMMmoVTLuMjN13H4eMHjx+T
         JIeQ==
X-Gm-Message-State: AOAM531TkR9WIemRMXxW/bEpfvhzWZcQ8bj1rEKCcoQQufp6gGcrx9nE
        CX8S/FgBPWgqDqmuGpX4V+Q=
X-Google-Smtp-Source: ABdhPJygmUHiM0ZWSgSUTOVaBrR29PMSQNxWjAf/APb0Xr+u82oIRuZhde1kOmrX4w8pRwULVBPjbA==
X-Received: by 2002:aa7:86c4:0:b029:316:98ff:30c with SMTP id h4-20020aa786c40000b029031698ff030cmr15617765pfo.66.1625499526135;
        Mon, 05 Jul 2021 08:38:46 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:38:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/9] net: netdevsim: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
Date:   Mon,  5 Jul 2021 15:38:08 +0000
Message-Id: <20210705153814.11453-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two pointers in struct xfrm_state_offload, *dev, *real_dev.
These are used in callback functions of struct xfrmdev_ops.
The *dev points whether bonding interface or real interface.
If bonding ipsec offload is used, it points bonding interface If not,
it points real interface.
And real_dev always points real interface.
So, netdevsim should always use real_dev instead of dev.
Of course, real_dev always not be null.

Test commands:
    ip netns add A
    ip netns exec A bash
    modprobe netdevsim
    echo "1 1" > /sys/bus/netdevsim/new_device
    ip link add bond0 type bond mode active-backup
    ip link set eth0 master bond0
    ip link set eth0 up
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 mode \
transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in

Splat looks like:
BUG: spinlock bad magic on CPU#5, kworker/5:1/53
 lock: 0xffff8881068c2cc8, .magic: 11121314, .owner: <none>/-1,
.owner_cpu: -235736076
CPU: 5 PID: 53 Comm: kworker/5:1 Not tainted 5.13.0-rc3+ #1168
Workqueue: events linkwatch_event
Call Trace:
 dump_stack+0xa4/0xe5
 do_raw_spin_lock+0x20b/0x270
 ? rwlock_bug.part.1+0x90/0x90
 _raw_spin_lock_nested+0x5f/0x70
 bond_get_stats+0xe4/0x4c0 [bonding]
 ? rcu_read_lock_sched_held+0xc0/0xc0
 ? bond_neigh_init+0x2c0/0x2c0 [bonding]
 ? dev_get_alias+0xe2/0x190
 ? dev_get_port_parent_id+0x14a/0x360
 ? rtnl_unregister+0x190/0x190
 ? dev_get_phys_port_name+0xa0/0xa0
 ? memset+0x1f/0x40
 ? memcpy+0x38/0x60
 ? rtnl_phys_switch_id_fill+0x91/0x100
 dev_get_stats+0x8c/0x270
 rtnl_fill_stats+0x44/0xbe0
 ? nla_put+0xbe/0x140
 rtnl_fill_ifinfo+0x1054/0x3ad0
[ ... ]

Fixes: 272c2330adc9 ("xfrm: bail early on slave pass over skb")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - no change

 drivers/net/netdevsim/ipsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 3811f1bde84e..b80ed2ffd45e 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -85,7 +85,7 @@ static int nsim_ipsec_parse_proto_keys(struct xfrm_state *xs,
 				       u32 *mykey, u32 *mysalt)
 {
 	const char aes_gcm_name[] = "rfc4106(gcm(aes))";
-	struct net_device *dev = xs->xso.dev;
+	struct net_device *dev = xs->xso.real_dev;
 	unsigned char *key_data;
 	char *alg_name = NULL;
 	int key_len;
@@ -134,7 +134,7 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
 	u16 sa_idx;
 	int ret;
 
-	dev = xs->xso.dev;
+	dev = xs->xso.real_dev;
 	ns = netdev_priv(dev);
 	ipsec = &ns->ipsec;
 
@@ -194,7 +194,7 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
 
 static void nsim_ipsec_del_sa(struct xfrm_state *xs)
 {
-	struct netdevsim *ns = netdev_priv(xs->xso.dev);
+	struct netdevsim *ns = netdev_priv(xs->xso.real_dev);
 	struct nsim_ipsec *ipsec = &ns->ipsec;
 	u16 sa_idx;
 
@@ -211,7 +211,7 @@ static void nsim_ipsec_del_sa(struct xfrm_state *xs)
 
 static bool nsim_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 {
-	struct netdevsim *ns = netdev_priv(xs->xso.dev);
+	struct netdevsim *ns = netdev_priv(xs->xso.real_dev);
 	struct nsim_ipsec *ipsec = &ns->ipsec;
 
 	ipsec->ok++;
-- 
2.17.1

