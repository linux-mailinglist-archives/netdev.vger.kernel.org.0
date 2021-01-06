Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7895F2EC2F3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAFSFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbhAFSFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7072E2312C;
        Wed,  6 Jan 2021 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609956278;
        bh=51ZhoMUTg79iyFfvNiHV8sojQPSnhzYx6O57vmjqBNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HG4w1aFwGuXfMWwX0LkM3yNk8UwcRaSsk8QNACz+fDS3tzysXDqG5JZbitEWNF5Tf
         KeD7beOhK8tWzs1cExI4ivkUtVa4OlIs05qJpURs3jFoUNtzwwagkbw1EIZnMN+gW9
         Knbx/PKBhxBqZQF6CPHyvTk2/85EAdbBrllt+cu4A+TS053RxPD7aw/D6vF29lJyoy
         YtilkwuI8Xz/JGrsOkFlLbEX1ywVbugd7yLZYFqdyi1msxxR5hMyXbWQySoTp05Dnp
         PL/FN4mQ/Ij3j2egDeCjvD0PRrycHDMHdaDBA3IJdm7VGJd3d4jv2N1M1RcQJHDQhe
         aFdrjG+SbkSxA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 2/3] net-sysfs: store the return of get_netdev_queue_index in an unsigned int
Date:   Wed,  6 Jan 2021 19:04:27 +0100
Message-Id: <20210106180428.722521-3-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106180428.722521-1-atenart@kernel.org>
References: <20210106180428.722521-1-atenart@kernel.org>
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

