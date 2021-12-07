Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12CA46AF74
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378801AbhLGAzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378815AbhLGAzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:42 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEBFC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:13 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so8247718plf.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hWumiZx7P2cYyxkqj8MeKD2gSwwFhLpbzMigSDdLAyw=;
        b=moo9wzjl00VOCwaEwN9wJOSA+vB3ZCq2I656FFCrBoLAS2AO24ikK8qZi1TTZneQWw
         zHuhrVe9TK0A9Bu9WJZ51TuaqeNUdlHAY24Mk4ncnFDy3jlGfyIJMHzw7MfNL2gER7Al
         TYkcTqh/oFRbWYFg34DLX8eq/4WWcaek/yHPXXP+XURNsE0Bydx/3AIwhxpuec/UZgsh
         iveqvLB/JmYATnRe65O86tkdmBi1/tKKZxkEZCdAYxtd8CL3TTi4WT95zd/8fO7zxcGh
         UwBJlRr9dvuM8ZP1nbe4N6lciMhgOjHokrzr/Fy9GvBArx1yltLB9/9lxACBcayIwONQ
         d/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hWumiZx7P2cYyxkqj8MeKD2gSwwFhLpbzMigSDdLAyw=;
        b=fR/y/rtSRS9+KkhYBtyem7tOe+7jzl+UwGAHBQcveL+hr4XBaUg6pq2VztOWo5Sj6p
         Cm3OxhdclGrP6wdWwSh1L04yMQwZsT735J9o31x7wYugzn4pAI99+9py8pEs6UQ64uW3
         aecqzjaQx32aXfYc864izHITka/MoBClqiwk93amM7HAZGN7NyyEx/v9EzkdIfBCwlxx
         KDAKxFbb8tICne7SvwEI5cHeFS6XzA4YIEhq7ByL2IxmK0/TqT0QxzMxsjVgHz/kfk4B
         uvev8C0zSdc1zcWieoe3dJ4mnC28k/74Zyi8R2+TOT3xT5f8Xil6XSOvOgZidmFtrAUO
         +MNg==
X-Gm-Message-State: AOAM532wdUGmqOr65oNb3kPpEcyaFyuJrm29ggL0ZkE7RIPV5MBnbK8m
        PtPU6zFJZ6SyFG3d+kpSXmA=
X-Google-Smtp-Source: ABdhPJwwHarcRg8pnworbQq/bPnuJyJcNNruRMSySxBrWQ9XTyCSrh8mde0khlyVFhwwoJ+DOHDPsg==
X-Received: by 2002:a17:90a:e7d0:: with SMTP id kb16mr2600241pjb.22.1638838333178;
        Mon, 06 Dec 2021 16:52:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 14/17] vfs: add netns refcount tracker to struct fs_context
Date:   Mon,  6 Dec 2021 16:51:39 -0800
Message-Id: <20211207005142.1688204-15-eric.dumazet@gmail.com>
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
 fs/afs/mntpt.c             | 5 +++--
 fs/fs_context.c            | 7 ++++---
 fs/nfs/fs_context.c        | 5 +++--
 fs/nfs/namespace.c         | 5 +++--
 include/linux/fs_context.h | 2 ++
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index bbb2c210d139d9033e83e39f0c4778de83afc694..c67474607604cc8096cfe343893994fe4153ffb4 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -78,8 +78,9 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 	int ret;
 
 	if (fc->net_ns != src_as->net_ns) {
-		put_net(fc->net_ns);
-		fc->net_ns = get_net(src_as->net_ns);
+		put_net_track(fc->net_ns, &fc->ns_tracker);
+		fc->net_ns = get_net_track(src_as->net_ns, &fc->ns_tracker,
+					   GFP_KERNEL);
 	}
 
 	if (src_as->volume && src_as->volume->type == AFSVL_RWVOL) {
diff --git a/fs/fs_context.c b/fs/fs_context.c
index b7e43a780a625bca1b0faeba53e2702463ad0496..06ece7c4b4c295cd1d918378597a23ac3a3cb13e 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -263,7 +263,8 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 	fc->sb_flags_mask = sb_flags_mask;
 	fc->fs_type	= get_filesystem(fs_type);
 	fc->cred	= get_current_cred();
-	fc->net_ns	= get_net(current->nsproxy->net_ns);
+	fc->net_ns	= get_net_track(current->nsproxy->net_ns,
+					&fc->ns_tracker, GFP_KERNEL);
 	fc->log.prefix	= fs_type->name;
 
 	mutex_init(&fc->uapi_mutex);
@@ -355,7 +356,7 @@ struct fs_context *vfs_dup_fs_context(struct fs_context *src_fc)
 	fc->source	= NULL;
 	fc->security	= NULL;
 	get_filesystem(fc->fs_type);
-	get_net(fc->net_ns);
+	get_net_track(fc->net_ns, &fc->ns_tracker, GFP_KERNEL);
 	get_user_ns(fc->user_ns);
 	get_cred(fc->cred);
 	if (fc->log.log)
@@ -469,7 +470,7 @@ void put_fs_context(struct fs_context *fc)
 		fc->ops->free(fc);
 
 	security_free_mnt_opts(&fc->security);
-	put_net(fc->net_ns);
+	put_net_track(fc->net_ns, &fc->ns_tracker);
 	put_user_ns(fc->user_ns);
 	put_cred(fc->cred);
 	put_fc_log(fc);
diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 0d444a90f513a9fa6d2cef1748a7218575a38d84..ea0bd82a29ecb498d995ef74b1a4c0fc1832116d 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -1531,8 +1531,9 @@ static int nfs_init_fs_context(struct fs_context *fc)
 			ctx->nfs_server.addrlen);
 
 		if (fc->net_ns != net) {
-			put_net(fc->net_ns);
-			fc->net_ns = get_net(net);
+			put_net_track(fc->net_ns, &fc->ns_tracker);
+			fc->net_ns = get_net_track(net, &fc->ns_tracker,
+						   GFP_KERNEL);
 		}
 
 		ctx->nfs_mod = nfss->nfs_client->cl_nfs_mod;
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 3295af4110f1b1c5890f110c3d49424a3d19406f..8c630907d1eff2f7199d32d6becee4c10259473d 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -170,8 +170,9 @@ struct vfsmount *nfs_d_automount(struct path *path)
 		goto out_fc;
 
 	if (fc->net_ns != client->cl_net) {
-		put_net(fc->net_ns);
-		fc->net_ns = get_net(client->cl_net);
+		put_net_track(fc->net_ns, &fc->ns_tracker);
+		fc->net_ns = get_net_track(client->cl_net,
+					   &fc->ns_tracker, GFP_KERNEL);
 	}
 
 	/* for submounts we want the same server; referrals will reassign */
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 6b54982fc5f378ec704f56def2fdb299e7d8b42d..9099bf7769c6db04b649d319502aec1b17d3d236 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/security.h>
 #include <linux/mutex.h>
+#include <net/net_trackers.h>
 
 struct cred;
 struct dentry;
@@ -96,6 +97,7 @@ struct fs_context {
 	struct dentry		*root;		/* The root and superblock */
 	struct user_namespace	*user_ns;	/* The user namespace for this mount */
 	struct net		*net_ns;	/* The network namespace for this mount */
+	netns_tracker		ns_tracker;	/* Tracker for @net_ns reference */
 	const struct cred	*cred;		/* The mounter's credentials */
 	struct p_log		log;		/* Logging buffer */
 	const char		*source;	/* The source name (eg. dev path) */
-- 
2.34.1.400.ga245620fadb-goog

