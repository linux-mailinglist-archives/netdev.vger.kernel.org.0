Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7769D19873
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 08:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfEJGhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 02:37:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39775 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfEJGhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 02:37:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id w22so2506531pgi.6;
        Thu, 09 May 2019 23:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zLdDfcuD8HJ6Gnz5XFclI1wW6NCmbCtA5LfOLEb3XOU=;
        b=Wed4E5pOWrD7XVDE4H4yqGlfRAyjKQcvhGqFo5bLHStJSijC3WZ0ggU8d64oDNXp6z
         Jj3muWk56f0OAHfmz5Sgp3rrpANuLj85FrfG8oEPwB9YW424ubwyVW1Tkzs14bSpG5oO
         lzRosd/80AIg2tF4WGhQ7MmvhyZM5Qv3FcgCREMUJEcnQddsRXOMyUCott4PTuhISIXW
         op4eQaLxadv9/yPYQ3pPjE2Fl7ZSr6OySE2vta4oxNs8IFzIFxPLXtoN5ly2oQy2Uikr
         5NorPvALvRzePopDsk4jTLhi6KVdnBZzZkwbq/0hMnyYXfUXBFRwSKSIZiG3mkzDZtZW
         NNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zLdDfcuD8HJ6Gnz5XFclI1wW6NCmbCtA5LfOLEb3XOU=;
        b=k6odyvy8eKyEQZ3MDGdb1ByyendRWPwFbwaYMnIJ4ttdo/pna4WlRyZu4EMHLapydJ
         4LKC8mNsGJDh/neSYmrvp9RmQCFG0z8cNmM3YEmBqvl97MQR/CdTMnqoNqZmE1l0EeIy
         icqhXnpWIK/bMSuelGUGR+SOzlYq2DcQy7TFZ8KMVXJOSySbcJSwrIHOmMQ2o2Ln9cFa
         CJaeVTp/+XiXr93SNRsjcmkojZWe1T2zYuegeEc3iz2TjufkjHLLuNIKAqL/ft0i9DWo
         CHSxMY0AV3LW9REUpTA40HrIy8qhDYkM/zjBwGSFE8iXydzFTfugX04/MR9vHpBtNzvQ
         TKiw==
X-Gm-Message-State: APjAAAWzTuXDL3AC3voi89ZnkLgLOeWPsJv0OV2x242aBZ7yDfz/AyKC
        TrvuCKehS1hqBBzTzifCK0E=
X-Google-Smtp-Source: APXvYqz9O37wiP/z0WGDMk6JfJvn0KMws35Bec0ftiK5yJUjYh+LUgDOkcNwtt9qThkYL3tcOsIsug==
X-Received: by 2002:a63:d343:: with SMTP id u3mr11525240pgi.285.1557470222385;
        Thu, 09 May 2019 23:37:02 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id v6sm4469263pgi.88.2019.05.09.23.36.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 23:37:01 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, viro@zeniv.linux.org.uk, davem@davemloft.net
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v2 1/3] nsfs: add evict callback into struct proc_ns_operations
Date:   Fri, 10 May 2019 14:36:01 +0800
Message-Id: <1557470163-30071-2-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
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

