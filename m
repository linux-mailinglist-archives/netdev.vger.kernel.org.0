Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201C741AF78
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbhI1M5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240858AbhI1M5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D2561206;
        Tue, 28 Sep 2021 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833730;
        bh=Ag2p0eQmaQKoD0RHMA3spX+uYqTTNv/FMT+QUF+zdoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oP4Yn7ao/g3qLtDa5Y4cXNU5oGaAqfbRb17buGT+jT3vmI8sY6FXrIyEz8GKTOZG3
         wLlWQU7TMOH47JxzP6ZNN8O31djVpmbLqVU8RoIG5W5mymOlcyfDOiDldiPqZLkUNn
         H1+uGYuZIeJ9R6KD0fpVQY6tiM9/NANkD5KlobwwayxNxo2gDmEf8TsHZECruNVnVf
         FZD6hYXHkrbWNgaS9D5r4yYImJu34uwGb0ck4GaRNmfdLxnTs7/OZbXj7MiP9tNGnA
         ddgLtf50csf7WYrKzISq8zYr+jWRCkGMDpZHt1gFr1MntN4Eni77qDUVqIe2dcF+84
         6dN5D5bBwbvnw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 6/9] net: use the correct function to check for netdev name collision
Date:   Tue, 28 Sep 2021 14:54:57 +0200
Message-Id: <20210928125500.167943-7-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_name_node_lookup and __dev_get_by_name have two distinct aims,
one helps in name collision detection, while the other is used to
retrieve a reference to a net device from its name. Fix the callers
checking for a name collision.

(The behaviour of the two functions was similar but will change in the
next commits).

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bfe17a264d6c..02f9d505dbe2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1142,7 +1142,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 	}
 
 	snprintf(buf, IFNAMSIZ, name, i);
-	if (!__dev_get_by_name(net, buf))
+	if (!netdev_name_node_lookup(net, buf))
 		return i;
 
 	/* It is possible to run out of possible slots
@@ -1196,7 +1196,7 @@ static int dev_get_valid_name(struct net *net, struct net_device *dev,
 
 	if (strchr(name, '%'))
 		return dev_alloc_name_ns(net, dev, name);
-	else if (__dev_get_by_name(net, name))
+	else if (netdev_name_node_lookup(net, name))
 		return -EEXIST;
 	else if (dev->name != name)
 		strlcpy(dev->name, name, IFNAMSIZ);
@@ -11164,7 +11164,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	 * we can use it in the destination network namespace.
 	 */
 	err = -EEXIST;
-	if (__dev_get_by_name(net, dev->name)) {
+	if (netdev_name_node_lookup(net, dev->name)) {
 		/* We get here if we can't use the current device name */
 		if (!pat)
 			goto out;
@@ -11518,7 +11518,7 @@ static void __net_exit default_device_exit(struct net *net)
 
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
-		if (__dev_get_by_name(&init_net, fb_name))
+		if (netdev_name_node_lookup(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
-- 
2.31.1

