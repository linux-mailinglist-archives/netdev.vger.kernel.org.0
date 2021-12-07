Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BF446AF73
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378796AbhLGAzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378800AbhLGAzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE6C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b13so8252303plg.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rzeVbBk6mNMUa39F92ZO1gz2trjRQLibN7tHPyYXxoU=;
        b=RP5TGjPeHPEOPPsQqbGrpFwtl9SVQLEbXg/RPceO3Ww9Pk8tlFQodO3pwpFYePXVzv
         oYqGEJ+8qYdY6MtH5qeDZd/mFkxOxDEdRceXXnQLGR35kpx2Tl7+hrO1Kns8zlrlqZl3
         05CzeXSH7s47nzXD3r7HZa3fgpWkqOoyAz+a5VZJglPv1s9+G6aoNOukmPAUwMKkRWfe
         I6ZkdqVnCqROD1YdsPSvDncAxNsAUQlxYiAXEhHTCMqROj8pxuGAMQF38/Xh6zi5SDkq
         aFCpOTrMo5faelVlDSaDuZ4v4CxcC3WhjIsSqxI1kPqPYCDuaQgq7/WDeqvjbfOdKbut
         m3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rzeVbBk6mNMUa39F92ZO1gz2trjRQLibN7tHPyYXxoU=;
        b=rgXKxLN87gzZTeCgYA81F4HYdKh/to/6NfFEhExRxcZHkEIlA8+h/tRz3G1q7+xkd6
         EPDJwrrA60O+uPROc9BZg4UPK+7JFvme8WkFKQT9CaH4lVTfx4LnQXPmXDdH9reAiz2T
         TOT6I7ObNeZx631j3ZWJJgtvA0TtQLS39/MzEhAIPwYfdbMm0/6z6LjiXW0CBetptqK0
         zK/w1zn+DNKN5oeiCvI7kQ58uKE3pmzXRKlobEbK6NTFpXxqMS3wEYzb80i0+uy5Nxbi
         +iySqXVNmKiTbJ5Ylqhs7HcgDMpu4q/TMEuTaMWy56gksYMbvmLNoq8+EaEAGQkdCOah
         yIAA==
X-Gm-Message-State: AOAM53247qDDP93xdVkCJ2TKGbF0W/BoB6e54gjrHgKJ9FzqYsWUBe5z
        AJMMdvuL5ShS1bmPKJbwu2g=
X-Google-Smtp-Source: ABdhPJzoX17cv059lJWzcwW6yj9J63MLca0X3nnbswOdOq8zm0Wei76dEoAJMUpIrYaYrhR1HwagIg==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr2529374pjb.224.1638838331413;
        Mon, 06 Dec 2021 16:52:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 13/17] net: add netns refcount tracker to struct nsproxy
Date:   Mon,  6 Dec 2021 16:51:38 -0800
Message-Id: <20211207005142.1688204-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/nsproxy.h  | 2 ++
 kernel/nsproxy.c         | 5 +++--
 net/core/net_namespace.c | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cdb171efc7cb052dd4844ae182206939627c68e8..eed7768daf428cfede70f438ecd366af23da85f2 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -4,6 +4,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <net/net_trackers.h>
 
 struct mnt_namespace;
 struct uts_namespace;
@@ -35,6 +36,7 @@ struct nsproxy {
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
+	netns_tracker	     ns_tracker;
 	struct time_namespace *time_ns;
 	struct time_namespace *time_ns_for_children;
 	struct cgroup_namespace *cgroup_ns;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index eec72ca962e249c94266192b77a3c1f92ec8e889..8b50e8153bc8957b47e2fce860aacce4e9f56616 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -112,6 +112,7 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		err = PTR_ERR(new_nsp->net_ns);
 		goto out_net;
 	}
+	netns_tracker_alloc(new_nsp->net_ns, &new_nsp->ns_tracker, GFP_KERNEL);
 
 	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
 					tsk->nsproxy->time_ns_for_children);
@@ -124,7 +125,7 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	return new_nsp;
 
 out_time:
-	put_net(new_nsp->net_ns);
+	put_net_track(new_nsp->net_ns, &new_nsp->ns_tracker);
 out_net:
 	put_cgroup_ns(new_nsp->cgroup_ns);
 out_cgroup:
@@ -200,7 +201,7 @@ void free_nsproxy(struct nsproxy *ns)
 	if (ns->time_ns_for_children)
 		put_time_ns(ns->time_ns_for_children);
 	put_cgroup_ns(ns->cgroup_ns);
-	put_net(ns->net_ns);
+	put_net_track(ns->net_ns, &ns->ns_tracker);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3ea5321430ee21af687510917da9b9aea5154e12..962062ad8cc4697ff6791aea7c48aea0b5db94a5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1355,8 +1355,8 @@ static int netns_install(struct nsset *nsset, struct ns_common *ns)
 	    !ns_capable(nsset->cred->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	put_net(nsproxy->net_ns);
-	nsproxy->net_ns = get_net(net);
+	put_net_track(nsproxy->net_ns, &nsproxy->ns_tracker);
+	nsproxy->net_ns = get_net_track(net, &nsproxy->ns_tracker, GFP_KERNEL);
 	return 0;
 }
 
-- 
2.34.1.400.ga245620fadb-goog

