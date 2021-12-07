Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB646AF6C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378753AbhLGAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbhLGAz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:29 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057D4C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so1250753pjq.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QHc+3KMzO/IXeML/pk2azuwtgD5APwxFUb3/0O1vz9Y=;
        b=QiJeyyxP9Ne/LFm7t+mDBvArEbmGWkiB2JvdAASpAjUMpsqFKjA/nDmJcMNlaWu0MT
         pP7tRJ2n51LuqpOuWDq6E/JLwcJb7fHlX4WpLoOUaxMuPIfEe4uCQUZraaTT8Bwpsz4r
         hxgZSHTaWXmiqY9s0NBIk8vUarcOx96z0yUpxe+Wd313z4oLRbbTwi8JBPvHbXQxR2fT
         86QMRrthfcreTdI5UdPnhuBt+K8AgnQ6zYCR7zUL4A6klz21S2HhzPx1+7CWU7jSfytm
         KCEwodxPAjZCoyApJzgsgXl3gv1KYWbj1S5BemwKGaCxLfHL6h+rDQtf9H68r7Doj1aV
         yKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QHc+3KMzO/IXeML/pk2azuwtgD5APwxFUb3/0O1vz9Y=;
        b=zfyIaf7N/lYvLH9OEVH928rZ8sajrfnDAYgK0P03UCPnC4NiloATPAjD24l8Qilzz7
         sym0ASShoyeDkpeaT/mrnbCcs0pr/GyuaJbYMqBK90blfMWsNIfiDI7fcN2O6QdReDDB
         b6JdM7ti6tdKf/7/gVx6me3fV9Po9cSZmIxrS5wvFsVUfIj2UD3+t3VKarIAzCjpsTnN
         tuWkKu9+Tu5mvNY1PcNi1LmY2RidraBhncXxOA8rCG/pTuKIvdoeWYAfd+zJ8dHylmJu
         m9yMsMm1tUyvoRPPGaCyMfAxt84U3k6Fg+E5AOXX89YaRLZly/dg7bpuej2FAGdcK9fK
         GUgw==
X-Gm-Message-State: AOAM5319TyUAner2v+qQx6dhqJHrJ9inpBh4u8o+AURS9Ohv33pdat5Z
        759jZPCaWIpQxXMyEs5Yspc=
X-Google-Smtp-Source: ABdhPJxUuVm09oHzBm7SR4GJdk6E7iUX8wvO9atBDF8r+eBBVGs48eexFy6jHkSZHt2ffKGZO8qf2A==
X-Received: by 2002:a17:902:dacc:b0:142:12bd:c5b9 with SMTP id q12-20020a170902dacc00b0014212bdc5b9mr48169818plx.74.1638838319623;
        Mon, 06 Dec 2021 16:51:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/17] l2tp: add netns refcount tracker to l2tp_dfs_seq_data
Date:   Mon,  6 Dec 2021 16:51:31 -0800
Message-Id: <20211207005142.1688204-7-eric.dumazet@gmail.com>
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
 net/l2tp/l2tp_debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index acf6e1343b88e070004f422e00d8fc697b4e4130..9d1aafe75f92dd7643c6908b83f4eb60ea79b025 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -32,7 +32,8 @@
 static struct dentry *rootdir;
 
 struct l2tp_dfs_seq_data {
-	struct net *net;
+	struct net	*net;
+	netns_tracker	ns_tracker;
 	int tunnel_idx;			/* current tunnel */
 	int session_idx;		/* index of session within current tunnel */
 	struct l2tp_tunnel *tunnel;
@@ -281,7 +282,7 @@ static int l2tp_dfs_seq_open(struct inode *inode, struct file *file)
 		rc = PTR_ERR(pd->net);
 		goto err_free_pd;
 	}
-
+	netns_tracker_alloc(pd->net, &pd->ns_tracker, GFP_KERNEL);
 	rc = seq_open(file, &l2tp_dfs_seq_ops);
 	if (rc)
 		goto err_free_net;
@@ -293,7 +294,7 @@ static int l2tp_dfs_seq_open(struct inode *inode, struct file *file)
 	return rc;
 
 err_free_net:
-	put_net(pd->net);
+	put_net_track(pd->net, &pd->ns_tracker);
 err_free_pd:
 	kfree(pd);
 	goto out;
@@ -307,7 +308,7 @@ static int l2tp_dfs_seq_release(struct inode *inode, struct file *file)
 	seq = file->private_data;
 	pd = seq->private;
 	if (pd->net)
-		put_net(pd->net);
+		put_net_track(pd->net, &pd->ns_tracker);
 	kfree(pd);
 	seq_release(inode, file);
 
-- 
2.34.1.400.ga245620fadb-goog

