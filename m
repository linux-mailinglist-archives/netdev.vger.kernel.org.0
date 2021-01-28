Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624DC30788A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhA1Oq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhA1Ooz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D329D64DE0;
        Thu, 28 Jan 2021 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845054;
        bh=51ZhoMUTg79iyFfvNiHV8sojQPSnhzYx6O57vmjqBNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex7p/J2qUYhRn+D9PTgxpX4tZx7LSNd8kk+XNeYm/tPI4bJHqjAc6+f51yw/PhVuP
         W9CKBe4EYuGN3qbY8uiNLDS+qQ23V9wKWnlhE2FAiStapgjr0jsX270wUFMXWvPHxo
         j9mPSBtSQbhaXLSywOmspXt9FdvRAHcSASIR8qyhprwSKd44W9zeSJyi7Z4y4nJGGO
         zBVKGjiJvkoISKWNpA7mlu3xgYvWs7+yg3EeVJVmMkMVu/cPSBb33arS8NwDsv++/L
         06/pblEdPLh3ystGAJ+L8CAEL16bNrXSdh0OV8ZWaG8NGPwRCcidclipb2ZhCrTcej
         VO+KqJQS/xsWQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/11] net-sysfs: store the return of get_netdev_queue_index in an unsigned int
Date:   Thu, 28 Jan 2021 15:43:56 +0100
Message-Id: <20210128144405.4157244-3-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In net-sysfs, get_netdev_queue_index returns an unsigned int. Some of
its callers use an unsigned long to store the returned value. Update the
code to be consistent, this should only be cosmetic.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e052fc5f7e94..5a39e9b38e5f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1320,7 +1320,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1390,7 +1391,7 @@ static ssize_t xps_cpus_store(struct netdev_queue *queue,
 			      const char *buf, size_t len)
 {
 	struct net_device *dev = queue->dev;
-	unsigned long index;
+	unsigned int index;
 	cpumask_var_t mask;
 	int err;
 
@@ -1432,7 +1433,8 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 
 	index = get_netdev_queue_index(queue);
 
@@ -1494,7 +1496,8 @@ static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
 {
 	struct net_device *dev = queue->dev;
 	struct net *net = dev_net(dev);
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 	int err;
 
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-- 
2.29.2

