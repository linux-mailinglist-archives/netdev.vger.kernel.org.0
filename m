Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A03253861
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgHZTkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgHZTkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 15:40:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFCC22083B;
        Wed, 26 Aug 2020 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598470811;
        bh=L/dXU6IU6GhVL0swV+A1k02DT/++5wWqX1+JR++mjcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQDhBBsXJBV77GHsv9R+Tw8H2cMCP1Dcxa5SRZH//lIpCZ2TBJKCdnbZmcRKGSqsA
         8kwN9lqkQTNUL4CIhRabMv0gAgNsEfttlvO2uj1vSnYYCnRJv5Z8NRwQ2YGYOL6a4J
         QdB7FI/0ZHHGRp5RP4hftw2jXePEoAmnHlqYqHx4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     eric.dumazet@gmail.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>, Rob Sherwood <rsher@fb.com>
Subject: [PATCH net 1/2] net: disable netpoll on fresh napis
Date:   Wed, 26 Aug 2020 12:40:06 -0700
Message-Id: <20200826194007.1962762-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826194007.1962762-1-kuba@kernel.org>
References: <20200826194007.1962762-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_disable() makes sure to set the NAPI_STATE_NPSVC bit to prevent
netpoll from accessing rings before init is complete. However, the
same is not done for fresh napi instances in netif_napi_add(),
even though we expect NAPI instances to be added as disabled.

This causes crashes during driver reconfiguration (enabling XDP,
changing the channel count) - if there is any printk() after
netif_napi_add() but before napi_enable().

To ensure memory ordering is correct we need to use RCU accessors.

Reported-by: Rob Sherwood <rsher@fb.com>
Fixes: 2d8bff12699a ("netpoll: Close race condition between poll_one_napi and napi_disable")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c     | 3 ++-
 net/core/netpoll.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d42c9ea0c3c0..95ac7568f693 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6612,12 +6612,13 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
 				weight);
 	napi->weight = weight;
-	list_add(&napi->dev_list, &dev->napi_list);
 	napi->dev = dev;
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
 	set_bit(NAPI_STATE_SCHED, &napi->state);
+	set_bit(NAPI_STATE_NPSVC, &napi->state);
+	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
 }
 EXPORT_SYMBOL(netif_napi_add);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 093e90e52bc2..2338753e936b 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -162,7 +162,7 @@ static void poll_napi(struct net_device *dev)
 	struct napi_struct *napi;
 	int cpu = smp_processor_id();
 
-	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
 		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
 			poll_one_napi(napi);
 			smp_store_release(&napi->poll_owner, -1);
-- 
2.26.2

