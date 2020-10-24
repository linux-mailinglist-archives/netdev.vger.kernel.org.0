Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AFC298179
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 12:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415438AbgJYLdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 07:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415431AbgJYLdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 07:33:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF0BC0613CE;
        Sun, 25 Oct 2020 04:33:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o1so1619864pjt.2;
        Sun, 25 Oct 2020 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NLwOajz7aLbYTCZJfZv4NGxOgDz/dYsUjO8aQaKp6ps=;
        b=j+7+X28549W+BrYcs7KatPfnkg3umYsdcjB+PsIuZdtA5kqWyqlnD230ae3p6VXXSs
         DAdjbrvEPPncflGS63+zsp8q7v2j9GE5l0RIKlUGZb4U8g4dSaUnhUQqK7mOYDrqj8t6
         eKYhyCZXwV1D6HqcendEtsrku+KR4IYroD7xcIchaNdOY6bnrHCQrHbUPHCUDs51oSbf
         76PpSC6/bPxFkY71ie+EhIWZm25BzKlrd/jVET2Eu4m6UQAi8f0XhLRz1CN0hMnIQGpb
         bUZ/5Io0D5U5C1BOwWXCui3acqh7toFHI+ldHY/y4dGtfrk3JWxyPEaVHLPXc/iY4IgI
         oWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NLwOajz7aLbYTCZJfZv4NGxOgDz/dYsUjO8aQaKp6ps=;
        b=geYpW/Z3pwkgPQ9dMrSTW/PBhRRnehofjzC6aBhz6hcN3164LQP/mES4ATL90J9i3s
         rON+Och2QBk1CU/QpuNli+a0RdP/JpBNqp0IxIQfu0wKXMGREMBNdtYhGNFg9AE+nTWu
         vo+E86K/G5SEAo7Ctc+z3pCtM7C96KcdS5MemGhFwRc1YFRi7ps5M0AfAGqaEl/V41Sg
         BqiMRAuNHrptilRseLiszdLI3P3JtRq3apk5DsDz6dxFPd1KrIcTVEjbIKRwLIasmhzk
         5DwzVR6SI06oiNmZM0nKPT+cU4WeXKttxtmP2vF1O4leAFPLGNLaNpJo1djM+/WnX2VH
         eEww==
X-Gm-Message-State: AOAM532LalJLPWWgH+4Wt8EAJPYoq4RNp36XW4NGAaxzmBS3QxAJbIh7
        LKOrfVE+RVmE0I5yhmFkbWg=
X-Google-Smtp-Source: ABdhPJyETl+EMoUUbZE2de5fwBvYir5gEzAt9d8BzO/XXFUJWvOdwy4xs6N7rTzEH4QIMbduoyYj1w==
X-Received: by 2002:a17:902:a50f:b029:d6:da2:aaa7 with SMTP id s15-20020a170902a50fb02900d60da2aaa7mr9034793plq.42.1603625599643;
        Sun, 25 Oct 2020 04:33:19 -0700 (PDT)
Received: from lte-devbox.localdomain (KD106154087147.au-net.ne.jp. [106.154.87.147])
        by smtp.googlemail.com with ESMTPSA id cs21sm21557515pjb.0.2020.10.25.04.33.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Oct 2020 04:33:18 -0700 (PDT)
From:   Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>
Cc:     fujiwara.masahiro@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Schultz <aschultz@tpip.net>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] gtp: fix an use-before-init in gtp_newlink()
Date:   Sat, 24 Oct 2020 15:42:33 +0000
Message-Id: <20201024154233.4024-1-fujiwara.masahiro@gmail.com>
X-Mailer: git-send-email 2.24.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*_pdp_find() from gtp_encap_recv() would trigger a crash when a peer
sends GTP packets while creating new GTP device.

RIP: 0010:gtp1_pdp_find.isra.0+0x68/0x90 [gtp]
<SNIP>
Call Trace:
 <IRQ>
 gtp_encap_recv+0xc2/0x2e0 [gtp]
 ? gtp1_pdp_find.isra.0+0x90/0x90 [gtp]
 udp_queue_rcv_one_skb+0x1fe/0x530
 udp_queue_rcv_skb+0x40/0x1b0
 udp_unicast_rcv_skb.isra.0+0x78/0x90
 __udp4_lib_rcv+0x5af/0xc70
 udp_rcv+0x1a/0x20
 ip_protocol_deliver_rcu+0xc5/0x1b0
 ip_local_deliver_finish+0x48/0x50
 ip_local_deliver+0xe5/0xf0
 ? ip_protocol_deliver_rcu+0x1b0/0x1b0

gtp_encap_enable() should be called after gtp_hastable_new() otherwise
*_pdp_find() will access the uninitialized hash table.

Fixes: 1e3a3abd8 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
---
 drivers/net/gtp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 8e47d0112e5d..6c56337b02a3 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -663,10 +663,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 
 	gtp = netdev_priv(dev);
 
-	err = gtp_encap_enable(gtp, data);
-	if (err < 0)
-		return err;
-
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
 	} else {
@@ -676,13 +672,18 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	err = gtp_hashtable_new(gtp, hashsize);
+	if (err < 0) {
+		return err;
+	}
+
+	err = gtp_encap_enable(gtp, data);
 	if (err < 0)
 		goto out_encap;
 
 	err = register_netdevice(dev);
 	if (err < 0) {
 		netdev_dbg(dev, "failed to register new netdev %d\n", err);
-		goto out_hashtable;
+		goto out_encap;
 	}
 
 	gn = net_generic(dev_net(dev), gtp_net_id);
@@ -693,11 +694,10 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 
 	return 0;
 
-out_hashtable:
-	kfree(gtp->addr_hash);
-	kfree(gtp->tid_hash);
 out_encap:
 	gtp_encap_disable(gtp);
+	kfree(gtp->addr_hash);
+	kfree(gtp->tid_hash);
 	return err;
 }
 
-- 
2.24.3

