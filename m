Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7722141AF75
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhI1M5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240833AbhI1M5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CB98611CA;
        Tue, 28 Sep 2021 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833721;
        bh=Bs156pJycha/DaevpmnOzmirXa2QBzO5NvHuZENnSDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icH0aIFynQNIB0b4pC7X/A/hG6WHQfevSUvodBgQTTOIyzoYDWYE4Y8hACe6iATJ1
         yxlRgsVUmLgZxbOEEZJNMR3IBYZQo5zdICaTWt19YdOsLf7zjjtaJqHvIhbhqpw28H
         eSIam78Mi0PMJpsCShULcVfJQ059kj9vHqdgsPkjKmil5fAl68rVIhqWxthyXhETmi
         4u0meEuEN/jYgv4cKPQ+ukqz5WbCk6rE0oB2r1AG3JTvHRjFSLbSy0FfVJced5K139
         vjUZXirP35KmVaY1UW9kE2WB09Dj2LMttpE6RpCZFruEvGKJuPv0R1CdEQPJkBfdTU
         hPYwvGzxxMXtw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 3/9] net: export netdev_name_node_lookup
Date:   Tue, 28 Sep 2021 14:54:54 +0200
Message-Id: <20210928125500.167943-4-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export netdev_name_node_lookup for use outside of net/core/dev.c. Prior
to this __dev_get_by_name was used for both name collision detection and
to retrieve a net device reference. We now want to allow a difference in
behaviour between the two, hence exporting netdev_name_node_lookup. (It
will be used in the next commits).

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h | 2 ++
 net/core/dev.c            | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..f8dae47b9aa8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2955,6 +2955,8 @@ struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
+struct netdev_name_node *netdev_name_node_lookup(struct net *net,
+						 const char *name);
 int dev_alloc_name(struct net_device *dev, const char *name);
 int dev_open(struct net_device *dev, struct netlink_ext_ack *extack);
 void dev_close(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 2f28b70e5244..bfe17a264d6c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -279,8 +279,8 @@ static void netdev_name_node_del(struct netdev_name_node *name_node)
 	hlist_del_rcu(&name_node->hlist);
 }
 
-static struct netdev_name_node *netdev_name_node_lookup(struct net *net,
-							const char *name)
+struct netdev_name_node *netdev_name_node_lookup(struct net *net,
+						 const char *name)
 {
 	struct hlist_head *head = dev_name_hash(net, name);
 	struct netdev_name_node *name_node;
@@ -290,6 +290,7 @@ static struct netdev_name_node *netdev_name_node_lookup(struct net *net,
 			return name_node;
 	return NULL;
 }
+EXPORT_SYMBOL(netdev_name_node_lookup);
 
 static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
 							    const char *name)
-- 
2.31.1

