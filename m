Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8F2FC10F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbhASU1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391761AbhASU0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57E1823138;
        Tue, 19 Jan 2021 20:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087924;
        bh=T9Ergzt8UttH+ZgH2jkWyJf/CzIXN9QAzLK5kPx9jPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSZCHNi5+o5MUUlr6e7T2zkZY80Eq168WJ/qTjU1ubMVQhZAkY5sGdVeveexzf6Kz
         HBbMi4x1Aux1J3bsFtnkw7hP5m2BciUllRKtCzJiDM3phKP4IPWujPW9ejNlQgc224
         e8spmWwvopOz5pUACW4/ZBM/nKzvnESWkQsFl4XlBVJr3ckilU8n5xeQhmvsqOkUFl
         ru4os2PMlh/JqVl2PhORxicSx4BSAXWRAcJLmY/BlgZGcHzOnQsWoMcw7pyWeYzXVd
         Nyfu8B1TfVO+KJHpwlQDnJMye6wrYc4c/nebQSkuWqYFAh/U/5rhksmrr0hJZbkNY7
         sBOOj03NqczoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/4] net: move net_set_todo inside rollback_registered()
Date:   Tue, 19 Jan 2021 12:25:18 -0800
Message-Id: <20210119202521.3108236-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119202521.3108236-1-kuba@kernel.org>
References: <20210119202521.3108236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev
failure.") moved net_set_todo() outside of rollback_registered()
so that rollback_registered() can be used in the failure path of
register_netdevice() but without risking a double free.

Since commit cf124db566e6 ("net: Fix inconsistent teardown and
release of private netdev state."), however, we have a better
way of handling that condition, since destructors don't call
free_netdev() directly.

After the change in commit c269a24ce057 ("net: make free_netdev()
more lenient with unregistering devices") we can now move
net_set_todo() back.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6b90520a01b1..5f928b51c6b0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9546,8 +9546,10 @@ static void rollback_registered_many(struct list_head *head)
 
 	synchronize_net();
 
-	list_for_each_entry(dev, head, unreg_list)
+	list_for_each_entry(dev, head, unreg_list) {
 		dev_put(dev);
+		net_set_todo(dev);
+	}
 }
 
 static void rollback_registered(struct net_device *dev)
@@ -10104,7 +10106,6 @@ int register_netdevice(struct net_device *dev)
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
 		rollback_registered(dev);
-		net_set_todo(dev);
 		goto out;
 	}
 	/*
@@ -10727,8 +10728,6 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 		list_move_tail(&dev->unreg_list, head);
 	} else {
 		rollback_registered(dev);
-		/* Finish processing unregister after unlock */
-		net_set_todo(dev);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10742,12 +10741,8 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
  */
 void unregister_netdevice_many(struct list_head *head)
 {
-	struct net_device *dev;
-
 	if (!list_empty(head)) {
 		rollback_registered_many(head);
-		list_for_each_entry(dev, head, unreg_list)
-			net_set_todo(dev);
 		list_del(head);
 	}
 }
-- 
2.26.2

