Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E246FC06
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhLJHsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhLJHsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:18 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCEFC061353
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:43 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v23so6230232pjr.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9rKHP8/jJj8YQ7QgsUwFshemJ3qNZx+J94JLF+EC2gs=;
        b=c1+dvGTD1jItQHoT65RkUcVkIIghnMNK5/MY3lFyyMmk0Zv4QdmWTn6U9evscHhmhu
         VKyuBJeyNKNEslpBvKxpnTqfYDzEE3HW0YMh1x/6fsOF3BguLpkxthnv7OoptZg4/kED
         45w+A2tNE8HBKUBEVfaqJCaKBA0xSzIzpDAOL9hYI55lcuwM5zGoSR4Uumq/EqzaTNXI
         +mHkchrPg++SWXuijVkH8Jud3Sk/3dV+VGYApa+KYFCSTW83V9Mskwu6u3yY0ckfRZt+
         jtVzeZWf8Cl6o4fDNSzVefn0e2k/OTll4UWiYUIsvTx4wwvOkqo/nh/AZVAURw3o8pxS
         M1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9rKHP8/jJj8YQ7QgsUwFshemJ3qNZx+J94JLF+EC2gs=;
        b=ImvxdHIxkrNcrD7akKcVtc0LlAZ9qbnCY7+VL9slJqXnn9SHlNJyNWfdhBZi1OOy1u
         4gCQ+KUzU0bEFOJmrdhW9/cuHg48mk6g6RV25oRuNKmlaWFXu67a4Mji36mtF8D2qLVX
         ROYbS0CdmfQl859ezNebSQ8OYzCILDaYHVupsoqDr2KkSp07OTUg8qitzAhVWcfVq47S
         jEidIbSA/BgcRgMfSIo/8L7GhNPhuYgS6HMfrUwkxUfE+87zrbB1AuaBlwVt10tEYZtx
         jkaeR+gorh/1dXns93zwvqZ8CL1/7dphUp+1ZyrPbykMyDGTmbkt6pMT2dl1+sVXoPbo
         98sg==
X-Gm-Message-State: AOAM530SeOwJ5BsdhAy3MefzMAUmezlO1Hm4tjvCje0xWpEEfIMQbtCy
        chj6XSOeGLs3R67GKX/DScA=
X-Google-Smtp-Source: ABdhPJwGGKiETyAAR/zgBOfBulrqpmZcIB29Tm6C4WLeDIaJHcCBvwIoLdr6s6NGmEBnySgpkANDHQ==
X-Received: by 2002:a17:902:7fc5:b0:143:6d84:88eb with SMTP id t5-20020a1709027fc500b001436d8488ebmr73333651plb.61.1639122283534;
        Thu, 09 Dec 2021 23:44:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:43 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 5/6] l2tp: add netns refcount tracker to l2tp_dfs_seq_data
Date:   Thu,  9 Dec 2021 23:44:25 -0800
Message-Id: <20211210074426.279563-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
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
2.34.1.173.g76aa8bc2d0-goog

