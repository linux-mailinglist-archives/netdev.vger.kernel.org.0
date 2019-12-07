Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1496A115E79
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 21:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLGUXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 15:23:25 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38294 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfLGUXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 15:23:25 -0500
Received: by mail-pf1-f201.google.com with SMTP id c23so6310096pfn.5
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 12:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=C14g8sWvL0VjxW4aCQqtsnywUgA2BKuDFqttfwfNqVs=;
        b=qUGg2/P2tHO3NK2rWZTLjY6ZcQeHknTe9Vlz7LUO6CBj1hdY0PwGu8+RUmZ7vxHo0g
         S0TMKagw97PatRyxEZ7hyxsK4W0epHSpP4diMP3ITy/hg1nkobPLIfHTSKMaKx0kMlgF
         9PHNLJSk2gTKYrA+4O8biBKpX0L46z0PEhNKwQO6wcD+mtFtapzd7JgfLpLtCDp55okH
         p3JbY3B94H5kF7aUEUGfqSwds1mBkxsPoNhaVP4zI9b7kqBnffCU/GCMGupnmdLdqY2W
         OXoLHny9A55/SqCkbIlV4i9gYQhFgSuc0DPClSpX98MuKehRv/F1V8A4m8W1z+qxK9Ag
         uXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=C14g8sWvL0VjxW4aCQqtsnywUgA2BKuDFqttfwfNqVs=;
        b=G/D9rGReWUaEjF9Ikz6F1/jL6Q/48ckqymCBmI70SfgVVLTfvfND436bMfhkeC0EAn
         P6Y3oLqReP3I2X1UhuLbtKTYO3gQuurjsyx4tyEPMHFAgwFfx6BzR2wRMTLaLKmjtZxt
         HisVL4cCd20atCVhHWaF6ED0rdj8GxAvkXk5trW0rKq/qd1Y0XGNBi1RXSrAj7WL/ZSh
         8AFUm/nhP9Id4MI9+HT7W4eKicTBs4A79ACS0VuHYrq6RZ1zrnCkVqyWn4nGJV5AGtAm
         w+ASvnIbCSH/mWql9I04U0HYo/p4gqkTqUX8RuoXEBT2pNtUkr1Z4fogZqG+z9AFFkTr
         UlAA==
X-Gm-Message-State: APjAAAWWcpxSHAGRWhQRqLlYhRrLwVR6d1HN+L9SaREB2rq5O0zyBKLu
        ngYKXNaiBM52LF63NrSe9wNoApbqVChWLg==
X-Google-Smtp-Source: APXvYqzOkiq4jqxEmA8robx/HiGyOVdCHa8Mi0hOaHdxFuYPA+m7Wi3untBiVm2IKMUt2VuEdaYfVRX0eNM40w==
X-Received: by 2002:a63:4b50:: with SMTP id k16mr10826190pgl.386.1575750204639;
 Sat, 07 Dec 2019 12:23:24 -0800 (PST)
Date:   Sat,  7 Dec 2019 12:23:21 -0800
Message-Id: <20191207202321.148251-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] neighbour: remove neigh_cleanup() method
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

neigh_cleanup() has not been used for seven years, and was a wrong design.

Messing with shared pointer in bond_neigh_init() without proper
memory barriers would at least trigger syzbot complains eventually.

It is time to remove this stuff.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/bonding/bond_main.c | 8 --------
 include/net/neighbour.h         | 1 -
 net/core/neighbour.c            | 3 ---
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fcb7c2f7f001b310075a8774ae67d8ea9e879575..6c72623e48e54d1d099a216c1181738667d32aec 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3712,18 +3712,10 @@ static int bond_neigh_init(struct neighbour *n)
 		return 0;
 
 	parms.neigh_setup = NULL;
-	parms.neigh_cleanup = NULL;
 	ret = slave_ops->ndo_neigh_setup(slave->dev, &parms);
 	if (ret)
 		return ret;
 
-	/* Assign slave's neigh_cleanup to neighbour in case cleanup is called
-	 * after the last slave has been detached.  Assumes that all slaves
-	 * utilize the same neigh_cleanup (true at this writing as only user
-	 * is ipoib).
-	 */
-	n->parms->neigh_cleanup = parms.neigh_cleanup;
-
 	if (!parms.neigh_setup)
 		return 0;
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 6ad9ad47a9c54bfbd1772f404f4ae81bf9cc6dd3..8ec77bfdc1a413d0a45edc978075aedab817e62e 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -72,7 +72,6 @@ struct neigh_parms {
 	struct net_device *dev;
 	struct list_head list;
 	int	(*neigh_setup)(struct neighbour *);
-	void	(*neigh_cleanup)(struct neighbour *);
 	struct neigh_table *tbl;
 
 	void	*sysctl_table;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 652da63690376b52d084a901310db39f4258aca3..920784a9b7ffaf0140c8e4427e327ec8867c2a2a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -98,9 +98,6 @@ static int neigh_blackhole(struct neighbour *neigh, struct sk_buff *skb)
 
 static void neigh_cleanup_and_release(struct neighbour *neigh)
 {
-	if (neigh->parms->neigh_cleanup)
-		neigh->parms->neigh_cleanup(neigh);
-
 	trace_neigh_cleanup_and_release(neigh, 0);
 	__neigh_notify(neigh, RTM_DELNEIGH, 0, 0);
 	call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, neigh);
-- 
2.24.0.393.g34dc348eaf-goog

