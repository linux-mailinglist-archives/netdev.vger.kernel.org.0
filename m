Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280673BA22B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhGBOaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhGBOaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:30:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8D0C0613DB
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:27:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b5so5674733plg.2
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MjLUbGH0MGrlBm4hWaTXQtXhGGiwb0l8vU/Dm19x2C0=;
        b=qvUB4Hp1ERDHSFHgMOLgazpHt96sJfyf8ZvAgp5Oo4qQSxmfjqCrCLiMHcJ2rF3nSL
         ErUHEsL2O/SKK3E6BQQByPYgbTODERF02oCKw90ysLd6N3nob8B0D1KYsWO7Oud+WpvS
         vcMGnwcvzhpngkjnTmaDqYiedEBg+3HoDsDJ5nBucdCRbsM7wbNzvm4fqbfEImZTHSC5
         spJ9TGTH7jOt41HMyZWwkmLogq06oMyOYAEvr66NWZl7u5+1Gr239/s8Z8uwqGmi9S+r
         ISa7LSJ6uchuCfV+cv0l4l3wDNwFZSihBtfPRxhG8cGon0qTYecLfcrIq+9Qgw37ZCT5
         w9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MjLUbGH0MGrlBm4hWaTXQtXhGGiwb0l8vU/Dm19x2C0=;
        b=rFM+1JIzo3hGiOYCSyF1Qn1HyYd7EaJ23gmE2FZX0RZOJYk4UQQs8ybIVitrs+miiz
         1egAEI7PN1ZM4GoqBLg8EztkxRHV7p4eIsKbSbc0/3e/VplJ/846rX5inBtCKQ+S0sPO
         KI3C+Qrwqv9CI30oKMEGFJsm0wI4E1ZQMTh5ZEbNSf/W9KKo5hrHIWHqxUZaljEoGGip
         UzjRcm4aQQWJtFFSewXWtk9ppy2yUEk1DsLCdCMa+qzzVLnhMMpl3ukLlDNqvwVYxoe7
         dqTuWa8okLbPCPpN6WxT3QOPYmRaqV34GMmP4HXhE1rdWiXbSNzt8EuDsIYAFbm0MAfs
         ZwxQ==
X-Gm-Message-State: AOAM532nnZ16RMQ89esaJ3BNiA8jtIfquKr0yoEDvajo3S9AHjn33uYU
        /ZLlWhpJWlTjRmQ4aC+BfQI=
X-Google-Smtp-Source: ABdhPJzuGqTXJAuqGlKdJAxPv/xVGKVmguNmlZOMHLMPfj9525bAE8E3BL5e8iGNoVfh+Br0u98U4w==
X-Received: by 2002:a17:902:c611:b029:122:847c:66e9 with SMTP id r17-20020a170902c611b0290122847c66e9mr88936plr.82.1625236064509;
        Fri, 02 Jul 2021 07:27:44 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nr12sm12683747pjb.1.2021.07.02.07.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:27:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 8/8] bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
Date:   Fri,  2 Jul 2021 14:26:48 +0000
Message-Id: <20210702142648.7677-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702142648.7677-1-ap420073@gmail.com>
References: <20210702142648.7677-1-ap420073@gmail.com>
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
 drivers/net/bonding/bond_main.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d2d37efb61b6..44c4509528f8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -568,24 +568,34 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
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

