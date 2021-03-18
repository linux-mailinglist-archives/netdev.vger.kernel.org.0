Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFC6340D3E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhCRSi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232494AbhCRSiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1272F64F1B;
        Thu, 18 Mar 2021 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092681;
        bh=ubbs60wF992gv32lYDpS+ZivIuc922WtvI2HNICjHNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXFSZdVCdzUXCZ7T7r4yKtjVTUsskP3p13cYwz1j3fgClegtrZv1nUvf6Hme1BDuR
         FxIgIq06E+n3QWk3yfhywojXX5wJrHNHmbVJVvQysQpG8La6+13Xc65v0BFYbvwA9q
         DSvHb+89vEjDMobHEgXSigRXi77rB5ZnbzCE2NcZ1vKuHrSBzRcC7noIakmOVjDI4L
         UbWLYmgINsILPwj1nYGL+fS50caRKKIB+W7BkrzQDlHLFpl1tD4oBhXnNkHPED+QYI
         vX+FdykPHER/Y3Y2wVSkWN/0Prm45wG9vJwMyzt2s/AhLi1ggBywZvMAPPT5UUJK6o
         U3anrspXxrkOA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 02/13] net-sysfs: store the return of get_netdev_queue_index in an unsigned int
Date:   Thu, 18 Mar 2021 19:37:41 +0100
Message-Id: <20210318183752.2612563-3-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
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
index 3a083c0c9dd3..5dc4223f6b68 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1367,7 +1367,8 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1437,7 +1438,7 @@ static ssize_t xps_cpus_store(struct netdev_queue *queue,
 			      const char *buf, size_t len)
 {
 	struct net_device *dev = queue->dev;
-	unsigned long index;
+	unsigned int index;
 	cpumask_var_t mask;
 	int err;
 
@@ -1479,7 +1480,8 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 
 	index = get_netdev_queue_index(queue);
 
@@ -1541,7 +1543,8 @@ static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
 {
 	struct net_device *dev = queue->dev;
 	struct net *net = dev_net(dev);
-	unsigned long *mask, index;
+	unsigned long *mask;
+	unsigned int index;
 	int err;
 
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-- 
2.30.2

