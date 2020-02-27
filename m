Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEE170F19
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgB0DkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:40:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40189 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgB0Dj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:39:59 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j7A1k-00030x-Ir; Thu, 27 Feb 2020 03:39:56 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v7 9/9] net: fix sysfs permssions when device changes network namespace
Date:   Thu, 27 Feb 2020 04:37:19 +0100
Message-Id: <20200227033719.1652190-10-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
References: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we moved all the helpers in place and make use netdev_change_owner()
to fixup the permissions when moving network devices between network
namespaces.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
unchanged

/* v3 */
unchanged

/* v4 */
unchanged

/* v5 */
unchanged

/* v6 */
unchanged

/* v7 */
unchanged
---
 net/core/dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a69e8bd7ed74..0f9c4684fcbd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10016,6 +10016,7 @@ EXPORT_SYMBOL(unregister_netdev);
 
 int dev_change_net_namespace(struct net_device *dev, struct net *net, const char *pat)
 {
+	struct net *net_old = dev_net(dev);
 	int err, new_nsid, new_ifindex;
 
 	ASSERT_RTNL();
@@ -10031,7 +10032,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
 	/* Get out if there is nothing todo */
 	err = 0;
-	if (net_eq(dev_net(dev), net))
+	if (net_eq(net_old, net))
 		goto out;
 
 	/* Pick the destination device name, and ensure
@@ -10107,6 +10108,12 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
 
+	/* Adapt owner in case owning user namespace of target network
+	 * namespace is different from the original one.
+	 */
+	err = netdev_change_owner(dev, net_old, net);
+	WARN_ON(err);
+
 	/* Add the device back in the hashes */
 	list_netdevice(dev);
 
-- 
2.25.1

