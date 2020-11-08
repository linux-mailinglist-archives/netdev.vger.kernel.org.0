Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD84B2AAB54
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 15:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgKHOIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 09:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHOIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 09:08:31 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A559EC0613D3
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 06:08:29 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id y197so5626515qkb.7
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 06:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=T76EEMrTc1Zt+31d8tkhqAihJgCMcxSE/ejB9cvBUXw=;
        b=VKaH7xzDjSc7GZ0s7tXmnx+ltY9p2cVY6P1nkKRFqT/SuRPNj4AtMbxy1auP0gM+04
         KDqWoODlICRd9K1EsvTKKVlXPtQT8qPHx5RNc2M1PmUBpcS75FDWRLNkmBU29L4VrXvH
         IvHI1du28HlA38ilcs3ji/kbHLbxdFdhtAmwd9aMIhGGTWPPOyjPuW+uaIoAUaz07MF1
         i3hMQe3Qm0OuRqj741qHYNhNwfHZvUKTqBhXqF2hKCGbrE8Kl1VtZC1xELhqWhNVxkd5
         bBilP1fb9Yc/r7UYatse8BZ9+js3IMKDxMZuL6E3ZqkEw60vWhZnRi0wl6VvwhGM9sDM
         qzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=T76EEMrTc1Zt+31d8tkhqAihJgCMcxSE/ejB9cvBUXw=;
        b=SLZqJKKVI8mRnFrmiPzzS282fwATGRQHyBvhKpUKdKIeYGtLkNcCf5+J504BTUGGqD
         MEBKi6lJG63Q3JewhDxpIegDNiNwCuQy3xsZMhMM0VzFevjyWXz0sM8HL6nyNAyBCa4y
         +5hQN2TnVr2C6Z8mOLwMt1ZTiv8Kf4zfIpOd0w+j7DTRp2VBHTS4dlqZPZQxY+BELE+T
         tEp7tL1gUPdDyHkVUXtXJHwHS7Vzg56jE5oVGoxqi5aPMB1p5kGrngiUTxoVB6GRO9Es
         qgk4OSoWP4GB4bVjTc5JO0lrq0KphUD1AfgEKk+q1yUS44GtjKaXBOZN/OXTbhajOBm7
         /b2Q==
X-Gm-Message-State: AOAM532Be8pliGns4V8Ztwx5TxqWrh6WUaoE1QAE/IdM/sCsdz0twCyb
        96WF8JqPjCjLbBUXhaUUBdvetyLDB6b+
X-Google-Smtp-Source: ABdhPJyxT98NXbivzBbT4ApsyYS7f/ND/QxchTLg+KhMFhCTa6HXQ/nJxgAKgCKfm9tJL4h41HdHNw==
X-Received: by 2002:a37:7181:: with SMTP id m123mr9317287qkc.295.1604844508368;
        Sun, 08 Nov 2020 06:08:28 -0800 (PST)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id h11sm1963838qtr.13.2020.11.08.06.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 06:08:27 -0800 (PST)
Subject: [PATCH] netlabel: fix our progress tracking in
 netlbl_unlabel_staticlist()
From:   Paul Moore <paul@paul-moore.com>
To:     netdev@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Joe Nall <joe@nall.com>,
        Waseem Chaudary <waseem.a.chaudary@accenturefederaldefense.com>
Date:   Sun, 08 Nov 2020 09:08:26 -0500
Message-ID: <160484450633.3752.16512718263560813473.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current NetLabel code doesn't correctly keep track of the netlink
dump state in some cases, in particular when multiple interfaces with
large configurations are loaded.  The problem manifests itself by not
reporting the full configuration to userspace, even though it is
loaded and active in the kernel.  This patch fixes this by ensuring
that the dump state is properly reset when necessary inside the
netlbl_unlabel_staticlist() function.

Fixes: 8cc44579d1bd ("NetLabel: Introduce static network labels for unlabeled connections")
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 net/netlabel/netlabel_unlabeled.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 2e8e3f7b2111..fc55c9116da0 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1166,12 +1166,13 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
-	u32 iter_bkt;
-	u32 iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
+	u32 skip_addr4 = cb->args[2];
+	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
 	struct list_head *iter_list;
 	struct netlbl_af4list *addr4;
 #if IS_ENABLED(CONFIG_IPV6)
+	u32 skip_addr6 = cb->args[3];
 	struct netlbl_af6list *addr6;
 #endif
 
@@ -1182,7 +1183,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 	rcu_read_lock();
 	for (iter_bkt = skip_bkt;
 	     iter_bkt < rcu_dereference(netlbl_unlhsh)->size;
-	     iter_bkt++, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0) {
+	     iter_bkt++) {
 		iter_list = &rcu_dereference(netlbl_unlhsh)->tbl[iter_bkt];
 		list_for_each_entry_rcu(iface, iter_list, list) {
 			if (!iface->valid ||
@@ -1190,7 +1191,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < cb->args[2])
+				if (iter_addr4++ < skip_addr4)
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1203,10 +1204,12 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 					goto unlabel_staticlist_return;
 				}
 			}
+			iter_addr4 = 0;
+			skip_addr4 = 0;
 #if IS_ENABLED(CONFIG_IPV6)
 			netlbl_af6list_foreach_rcu(addr6,
 						   &iface->addr6_list) {
-				if (iter_addr6++ < cb->args[3])
+				if (iter_addr6++ < skip_addr6)
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1219,8 +1222,12 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 					goto unlabel_staticlist_return;
 				}
 			}
+			iter_addr6 = 0;
+			skip_addr6 = 0;
 #endif /* IPv6 */
 		}
+		iter_chain = 0;
+		skip_chain = 0;
 	}
 
 unlabel_staticlist_return:

