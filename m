Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940733390AC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCLPFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhCLPEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150B464F78;
        Fri, 12 Mar 2021 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561492;
        bh=h/BOmfBbTaJBFbxKqdSRFVRIBV/jimnFB8eQIyKuQ0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1N7VKyn07N6rM7grOrQvWmh61L6MKZKh4yIHeNhUtW4U651Bg012ED31xN7LXRHT
         kbNSVndXi1fwJ6b8V5PYNqtQSDedIEynSoUpYhpQj3y62EfmszPzcfeZ1SDzW8XH0s
         ErYAW17+2TvNJAwlCToleSej2iHo8QPXaU33h+/t57LLl09KGyjWxkfGAgveaZubwt
         nIaX7aHGSY447gZUkUu1QM6pI0k1ovOKZAYg5vEUBiZdj+W2CAGJZ0LwzvzTAgJB+v
         KMnjlpeYwhWUaFy2q7museBJwh6e9CuDZp1gbcavRa1saXWFpRXvEBYuSv9AkN5T7X
         7NuIE0W7+msrg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 02/16] net-sysfs: store the return of get_netdev_queue_index in an unsigned int
Date:   Fri, 12 Mar 2021 16:04:30 +0100
Message-Id: <20210312150444.355207-3-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
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
2.29.2

