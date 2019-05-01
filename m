Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0791058C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfEAGnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:43:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32987 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAGnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:43:12 -0400
Received: by mail-pl1-f193.google.com with SMTP id y3so7001901plp.0;
        Tue, 30 Apr 2019 23:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j9MH4iiJ+X2ecNXQBhUm1t4pzmUrHFzr5eMR80D9r3g=;
        b=BVINc4Pj1E93GIlFhXNO6bnORlYT1bhzJWEjTw0CztPg6w051bMroJ0qGm4MEg17o7
         Dn4I9jPgxki7xhislO3Vma77vVMmbihJKSOKmE63H5dmnjP57FqXnNM/17uLYJGDNdNB
         WExXpgU3Cx1/l+LYmO+Lo/tqGufK9Sm1CTF9FXFqegllgXVYWEA8v1G7ApR2WTZjIKFB
         JwtxQdwDw8UwJ4Mc7pO9g8+As7ip3HUA4B08CJzcIR0kts/27UULtmb1ceD9EwYXywaB
         npOYtzFKS6vc1w65GYqRMfv3kH25NE4Wg6Tep3b2u6oBp3x845r7QFxBfjy5LpeSUikf
         9erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j9MH4iiJ+X2ecNXQBhUm1t4pzmUrHFzr5eMR80D9r3g=;
        b=gTj9pjdLTbfl3E8GaHLw8ZPmxpW4MNpfMGpAsyQndEv6AC7SEiKs1OgpqG3+MMFzsZ
         aWN8VGbG6GhCfQF/QvgscPICku49S50yRpxy5HWAMyFrmFeq46X3sYUcEOOE1MuHa102
         ZXKXquevaok1UStg4nY3qMMMEX7yRu+MGwMeTKElCDY0RC1VP/2GgNY4D0lu4GBF53bU
         +3+qwGR9qQgT+mADJKcv9lrBcKyqNH1NX+aqly4logU4OE35szm2NHhYWUidV2vXNHr2
         SjBu8c7YkcnlYSZtOEilg+fIJZa0xFbCoHox3/sNhpN+f+Gn+P4FhT5x21t9fvxTBHHd
         Qf8g==
X-Gm-Message-State: APjAAAW+NDDrCSeoIJ/zY3+2GiTrzsUHVWZWyX7D/VCq+Vl4cCprBdBT
        BEUHmt1auvlKzzo0KLqlud4=
X-Google-Smtp-Source: APXvYqzSBCCuDLKPMty7pzwucHkxq4V9xhk5NVotbehkelZrHHoxtaKo+E4/j0wNuBPRE+jyc2A6gQ==
X-Received: by 2002:a17:902:b481:: with SMTP id y1mr76303909plr.161.1556692991321;
        Tue, 30 Apr 2019 23:43:11 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id 25sm56800323pfo.145.2019.04.30.23.43.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 23:43:10 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     viro@zeniv.linux.org.uk, davem@davemloft.net, bfields@fieldses.org,
        jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 1/3] nsfs: add evict callback into struct proc_ns_operations
Date:   Wed,  1 May 2019 14:42:23 +0800
Message-Id: <1556692945-3996-2-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
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
index 60702d6..5939b12 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -49,6 +49,8 @@ static void nsfs_evict(struct inode *inode)
 	struct ns_common *ns = inode->i_private;
 	clear_inode(inode);
 	ns->ops->put(ns);
+	if (ns->ops->evict)
+		ns->ops->evict(ns);
 }
 
 static void *__ns_get_path(struct path *path, struct ns_common *ns)
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

