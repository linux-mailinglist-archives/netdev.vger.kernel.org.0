Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6262F4251B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406560AbfFLMKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:10:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39938 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404605AbfFLMKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:10:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so6264740pfp.7;
        Wed, 12 Jun 2019 05:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k798wRZQDGMJDiTV9bjRB/U80AnvSeziRwT5A0j4Yps=;
        b=ZnJeIIeEsrf0RBz8cUuNco1Dsa6YYWySNwCyzxVXuMjSVfsI3euXPHGFNd5U3aT7T2
         u3o5JRKw8UVlfk6tEs7r1h2vnN2fS45lN4cyMAZqXmt0ZVzQQ7Su3hSzUlTA67Uegl3V
         HAfN2+J3Dz8ARzfRo8v1y0GFkMSGMfSFJ6PPYY+b+8ixGdKTQmEOJltFxOfW//P7WcUC
         1qPfo4w2PZlCixLPiZGpAO2PE6fyRH0ZdInm+UshlFvu61nTz5rIZ/74ijz8MJ05zzFI
         u6Q779IEv+Y1ZyyGVP0YMAkLSa5mfil4WnZ3SxN5tXjPcttYDB9+miHwR6Tw9tmj3ZxV
         My7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k798wRZQDGMJDiTV9bjRB/U80AnvSeziRwT5A0j4Yps=;
        b=kKoVDTYnJVCzef3Bzv9lo0i9Zg9I3cGotO7m27Ut1TfzyLJzxQ2wDSocR4ir3li2C6
         k3dZglrIQhlXiYH2XVrQyBlOKJA0lRWvycGUm8hR6W4Vt/YtDVCCLe1N5g6twGsSmYJw
         ZtCIk1edO41rMwJW5MyzC7Oq05a1z6CDMFnxkjWkV6mgfpFNrKMdS5hN9L73xT2n0Yg3
         tpIlMgnleNtHVMKqFPfj4o5hgpWXM46lArpxVuLAoypm2dci4EpaPYxPnvjisDbimJhb
         Uhbxjt4KySrP3EkSbH7bZTRYAmVVw/d9whNFT0eovfgM+05pka8YbaQf5lOKBdP56X28
         QhOw==
X-Gm-Message-State: APjAAAWfscwXJrQr590Q0j5FcoFta/v/Go3t7HnB8UYpt9Da5ABhFdIA
        rfXyFOUp5UGCiuyjkHNuJUE=
X-Google-Smtp-Source: APXvYqyZYyC7+qBhCl7Dz3QvcRcYd0meu/WwOuFR40I+8ggrwRQPRwHs1luVNB2VxPCUljZ1Voqy3w==
X-Received: by 2002:a62:4dc5:: with SMTP id a188mr87234896pfb.8.1560341439222;
        Wed, 12 Jun 2019 05:10:39 -0700 (PDT)
Received: from bridge.tencent.com ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id s5sm5035653pji.9.2019.06.12.05.10.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:10:38 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, davem@davemloft.net, viro@zeniv.linux.org.uk
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v3 1/3] nsfs: add evict callback into struct proc_ns_operations
Date:   Wed, 12 Jun 2019 20:09:28 +0800
Message-Id: <1560341370-24197-2-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly added evict callback shall be called by nsfs_evict(). Currently
only put() callback is called in nsfs_evict(), it is not able to release
all netns refcount, for example, a rpc client holds two netns refcounts,
these refcounts are supposed to be released when the rpc client is freed,
but the code to free rpc client is normally triggered by put() callback
only when netns refcount gets to 0, specifically:
    refcount=0 -> cleanup_net() -> ops_exit_list -> free rpc client
But netns refcount will never get to 0 before rpc client gets freed, to
break the deadlock, the code to free rpc client can be put into the newly
added evict callback.

Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nsfs.c               | 2 ++
 include/linux/proc_ns.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 60702d6..a122288 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -48,6 +48,8 @@ static void nsfs_evict(struct inode *inode)
 {
 	struct ns_common *ns = inode->i_private;
 	clear_inode(inode);
+	if (ns->ops->evict)
+		ns->ops->evict(ns);
 	ns->ops->put(ns);
 }
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index d31cb62..919f0d4 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -19,6 +19,7 @@ struct proc_ns_operations {
 	int type;
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
+	void (*evict)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
 	struct user_namespace *(*owner)(struct ns_common *ns);
 	struct ns_common *(*get_parent)(struct ns_common *ns);
-- 
1.8.3.1

