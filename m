Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550933BC119
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhGEPlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhGEPlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:40 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12ADC061762
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:39:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s18so3544449pgg.8
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z/GRneOwL1VpqYdTs9VsVkUYVJD8+xrWHwe0lfZhQeI=;
        b=UZAKV3CcpV0ZiK3Ivzk3HTYCveB+bhdQH0Y97ocRLi70jqdW2vPPtZ7+h+LImFqFAt
         qyOf4KZ+GwlKtXsAM6kavXJ++LRiDxkrUv0sf8gJC4+Yf/Z9vlshnzZZEo9yISQMvzO1
         cqmtoXPmTRBiJpHzIoFkAB/3qWVy25OLEyQyhBulRhgfr/UQ/Lq0IyBXgbJdFv9zRmEV
         TYg1JNuAEBoAvPUNUnmuCuExCwIjaZXGKc7HOG0IsoOlHvHIkHAeZuynG/e1eOqiphSE
         rVkMRl1CyY3iPQ7gJCCCjWbeG2UEffu8zyThE7iNXnZnTECMzgsnqUIQFjc53y6Uyn6v
         ETcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z/GRneOwL1VpqYdTs9VsVkUYVJD8+xrWHwe0lfZhQeI=;
        b=BQAXsd65E8pkinwXhI4ZX3YvwwKc+fORxbdxZ6o7gV7hotmWwYujD0AF4LLcJrwc31
         bp3oHmU8O7KMHKFRWvKLstHMBWLuT7k9d+gY4yZuYPaJke7hBqlOXCGg2a8i4WWHgZSZ
         Qdma26GV9XwgkjPuBjvcDu2RPpyuNPnBSnCJDOlYosFoZS74StjPGqBPlrEGZy2xqOYA
         DZ4PZ/ddTbhCPikNemgfnw2RUBDXkFZEHo22zD9MHtvg4kVBmbVO9uA+R6CmXN/CQCjd
         WfBYC+GPyfWfVvV1XAatRKp1yYSZ+ixp/rbP9Dazg7gEeBO9JNVQhchLdowt11/5NHm+
         fOsQ==
X-Gm-Message-State: AOAM530XVpGjwD1rNLForKrKsbBgqANl7Kd6Fq0P0ctCb0rIOBfgaDQ8
        3DUQF4kDPO+wGzLR9oj4AfU=
X-Google-Smtp-Source: ABdhPJxEsiHnOonwQLFFSka2dLVGQmWy5L0AYtJDHHFa9uYC0NWMf3vEvfgt001NDNmMY++w+qChCQ==
X-Received: by 2002:a63:5156:: with SMTP id r22mr16651716pgl.264.1625499543237;
        Mon, 05 Jul 2021 08:39:03 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:39:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 8/9] bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
Date:   Mon,  5 Jul 2021 15:38:13 +0000
Message-Id: <20210705153814.11453-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To dereference bond->curr_active_slave, it uses rcu_dereference().
But it and the caller doesn't acquire RCU so a warning occurs.
So add rcu_read_lock().

Splat looks like:
WARNING: suspicious RCU usage
5.13.0-rc6+ #1179 Not tainted
drivers/net/bonding/bond_main.c:571 suspicious
rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ping/974:
 #0: ffff888109e7db70 (sk_lock-AF_INET){+.+.}-{0:0},
at: raw_sendmsg+0x1303/0x2cb0

stack backtrace:
CPU: 2 PID: 974 Comm: ping Not tainted 5.13.0-rc6+ #1179
Call Trace:
 dump_stack+0xa4/0xe5
 bond_ipsec_offload_ok+0x1f4/0x260 [bonding]
 xfrm_output+0x179/0x890
 xfrm4_output+0xfa/0x410
 ? __xfrm4_output+0x4b0/0x4b0
 ? __ip_make_skb+0xecc/0x2030
 ? xfrm4_udp_encap_rcv+0x800/0x800
 ? ip_local_out+0x21/0x3a0
 ip_send_skb+0x37/0xa0
 raw_sendmsg+0x1bfd/0x2cb0

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 - no change

 drivers/net/bonding/bond_main.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9c44ec92eb72..a9cb06959320 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -573,24 +573,34 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	struct net_device *real_dev;
 	struct slave *curr_active;
 	struct bonding *bond;
+	int err;
 
 	bond = netdev_priv(bond_dev);
+	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
 	real_dev = curr_active->dev;
 
-	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-		return true;
+	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
+		err = true;
+		goto out;
+	}
 
-	if (!xs->xso.real_dev)
-		return false;
+	if (!xs->xso.real_dev) {
+		err = false;
+		goto out;
+	}
 
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_offload_ok ||
 	    netif_is_bond_master(real_dev)) {
-		return false;
+		err = false;
+		goto out;
 	}
 
-	return real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+	err = real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+out:
+	rcu_read_unlock();
+	return err;
 }
 
 static const struct xfrmdev_ops bond_xfrmdev_ops = {
-- 
2.17.1

