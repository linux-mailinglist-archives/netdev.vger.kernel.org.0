Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3E440A85
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJ3RVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhJ3RVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 13:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27DC561051;
        Sat, 30 Oct 2021 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635614334;
        bh=QhluK+06FrJHkanlZMVBtEgZbu3hLUjKpRQYz7lJRRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btpcjxA3OQjwUWeVVISP7T1/uVK0//jT4OAllJxkmIJyp/Z54KVTnRTTR5Wb1bDc3
         TVlipsXSeZCZ4KIHwJtH2HzjYn7lbxn6Bkeylzjp7eVl9wU5WZafiGW9dcBTlg1jm/
         /8kpIxGWrfsnNBWGqSQzP14nprJDnGu4W+El8+CFW0rSgew9snjWZ9qp7grW5jtII3
         TrN3i66qcEQOSOAaz720j3K9O1u1nupQwqRxTyxZ3qm1IpD2iBxy5LQPeglC8ZtpN4
         A/YSeCuBXQjsciSvlh/BeeWTQOTN2PFkxE5FltvAYUkWZiBE+KDgmvbex/funN3olG
         GalEYPBhCnesQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/4] devlink: expose get/put functions
Date:   Sat, 30 Oct 2021 10:18:50 -0700
Message-Id: <20211030171851.1822583-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030171851.1822583-1-kuba@kernel.org>
References: <20211030171851.1822583-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow those who hold implicit reference on a devlink instance
to try to take a full ref on it. This will be used from netdev
code which has an implicit ref because of driver call ordering.

Note that after recent changes devlink_unregister() may happen
before netdev unregister, but devlink_free() should still happen
after, so we are safe to try, but we can't just refcount_inc()
and assume it's not zero.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h | 12 ++++++++++++
 net/core/devlink.c    |  8 +++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1b1317d378de..991ce48f77ca 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1726,6 +1726,9 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
+struct devlink *__must_check devlink_try_get(struct devlink *devlink);
+void devlink_put(struct devlink *devlink);
+
 void devlink_compat_running_version(struct net_device *dev,
 				    char *buf, size_t len);
 int devlink_compat_flash_update(struct net_device *dev, const char *file_name);
@@ -1736,6 +1739,15 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 
 #else
 
+static inline struct devlink *devlink_try_get(struct devlink *devlink)
+{
+	return NULL;
+}
+
+static inline void devlink_put(struct devlink *devlink)
+{
+}
+
 static inline void
 devlink_compat_running_version(struct net_device *dev, char *buf, size_t len)
 {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2d8abe88c673..100d87fd3f65 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -182,15 +182,17 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
-static void devlink_put(struct devlink *devlink)
+void devlink_put(struct devlink *devlink)
 {
 	if (refcount_dec_and_test(&devlink->refcount))
 		complete(&devlink->comp);
 }
 
-static bool __must_check devlink_try_get(struct devlink *devlink)
+struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 {
-	return refcount_inc_not_zero(&devlink->refcount);
+	if (refcount_inc_not_zero(&devlink->refcount))
+		return devlink;
+	return NULL;
 }
 
 static struct devlink *devlink_get_from_attrs(struct net *net,
-- 
2.31.1

