Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4C541AF73
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbhI1M47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240731AbhI1M46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8689A611BD;
        Tue, 28 Sep 2021 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833719;
        bh=8cLfolrANnusajxe/rQ7Xw6RsowFwoRI5G/COp4LbYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpLWhZgE34MhcFNjfzcoavbIOF/5gZsjyLM9fdeJSZUzSjCN1HApRbc18meFQNS2W
         K2PUbLVxlmuQrIe9tWbCkWhMMKgm+w+2Z/DwzPYPW9ZM7Gu8wHcKyuwhPXNHPzarmS
         Kzn5TVIsUdrGTP72X6He5bFMuW9jSu4rNXSVhd0hHOakVEO3ELaAGWUxgdwiZitXho
         oY0ylbuFgiyxaFzxhQGhFD5sIz/Lzk9Fi5Q3jOm5ayFUZ4Dgc7sbuLGhKeJ/2txvir
         ctdPD72X0JbDYHb3RskuRou1BZtNloISICD9GOxfqf1RrlCVc9scCJNBwCgCp7UqIe
         J2roJtXM4XjNg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 2/9] net: split unlisting the net device from unlisting its node name
Date:   Tue, 28 Sep 2021 14:54:53 +0200
Message-Id: <20210928125500.167943-3-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This (mostly [*]) cosmetic patch spits the unlisting of the net device
from the unlisting of its node name. The two unlisting are still done
for now at the same places in the code, keeping the logic.

[*] The two removals are now not done in a single dev_base_lock locking
    section. That is not an issue as insertion/deletion from both lists
    doesn't have to be atomic from the dev_base_lock point of view.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fa989ab63f29..2f28b70e5244 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -385,13 +385,21 @@ static void unlist_netdevice(struct net_device *dev)
 	/* Unlink dev from the device chain */
 	write_lock_bh(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
-	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
 	write_unlock_bh(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
 
+static void unlist_netdevice_name(struct net_device *dev)
+{
+	ASSERT_RTNL();
+
+	write_lock_bh(&dev_base_lock);
+	netdev_name_node_del(dev->name_node);
+	write_unlock_bh(&dev_base_lock);
+}
+
 /*
  *	Our notifier list
  */
@@ -11030,6 +11038,7 @@ void unregister_netdevice_many(struct list_head *head)
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
 		unlist_netdevice(dev);
+		unlist_netdevice_name(dev);
 
 		dev->reg_state = NETREG_UNREGISTERING;
 	}
@@ -11177,6 +11186,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* And unlink it from device chain */
 	unlist_netdevice(dev);
+	unlist_netdevice_name(dev);
 
 	synchronize_net();
 
-- 
2.31.1

