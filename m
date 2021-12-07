Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6056D46AF69
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378741AbhLGAzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378738AbhLGAzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF91C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:54 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id np3so9030840pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iqCYdj052fYTydLFbj8bY0QPq64SEhrx3lyjdG2q7JM=;
        b=CQsWCMLv1nJuNYFmaHGM9vErumgWi9/UnEbgEncd3TcWHoExCGiaVfrWKB7S3X836T
         2G7u0SGrNzm/HHdtx3uEK1Hv+Z/rvBo5ByYMOwdueDrY7zptJJnOmgOgCvu4pSLBnv1A
         Y/8ATuQb7cey5jBgFWgGnNjUir/xVc43Htanl6QkX4MjrpNU3jruuAD7LoWqhXsOXXcF
         OgnjYtObTufHG86eGRfNG2z7rQcsAhJZWj5B2dO8q7CjzWTa9xTTX3gXUkbKoNjbj1TJ
         835FRggIh89Xla8P+fVpyPYD7EnteAkWZgeVWddQKeE8aCwiNLZQ0zHtNVqAaFWPoc3w
         tNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqCYdj052fYTydLFbj8bY0QPq64SEhrx3lyjdG2q7JM=;
        b=VTDR2h6ezAANCdjqoiFsYj4iOOXARPm7u0t4FUFWI9GdKGWRIEKIuNMtHkeHvD8O5d
         IkRxTBJL4iEVJ/d+o5shdbSy7Al3s/81BW1lQqxP1TNjOHvU91DvrzOvG1w0Nq154qFT
         WyzL1WlzlUm5Wgb6GzoW6kjIn9PPLBbicuK8e4NaaZqJMAPbIy60YXKfKPEX25ChYZHB
         JznJXIX4S7Nq5LBbRdGfKH7vRrxt4+tv0EX7Xmc9bxyKyHX3DPTWTQY6L/kRf3ZMSWgp
         CAs0YXPFn/1ANd3H7ov44JrRPxr0RI5f8MGIIGg4Xb/Kf8339RY4jzWL+znh/KJ/oqUt
         3bjQ==
X-Gm-Message-State: AOAM532pru+hH7zxvAcMlA/Pl+2vLMzcHt8Pl35YFE25fXdYNOqtTY1s
        U2I612QvcaGYO/Gnkldh7Es=
X-Google-Smtp-Source: ABdhPJwCQQFp4YkMCIxqZCnDMWaq1TTji7zU68UqFowzTJ/WcT5zcj4mwp3i+ekd4K/dJCxfggkebg==
X-Received: by 2002:a17:90b:4a0e:: with SMTP id kk14mr2591697pjb.42.1638838313682;
        Mon, 06 Dec 2021 16:51:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/17] net: add netns refcount tracker to struct seq_net_private
Date:   Mon,  6 Dec 2021 16:51:28 -0800
Message-Id: <20211207005142.1688204-4-eric.dumazet@gmail.com>
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
 fs/proc/proc_net.c           | 19 ++++++++++++++++---
 include/linux/seq_file_net.h |  3 ++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 15c2e55d2ed2c4b8b00209ecf9b18caa1a47f1b7..39b823ab2564edf62fd08983ec44560b1120ee24 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -61,15 +61,27 @@ static int seq_open_net(struct inode *inode, struct file *file)
 	}
 #ifdef CONFIG_NET_NS
 	p->net = net;
+	netns_tracker_alloc(net, &p->ns_tracker, GFP_KERNEL);
 #endif
 	return 0;
 }
 
+static void seq_file_net_put_net(struct seq_file *seq)
+{
+#ifdef CONFIG_NET_NS
+	struct seq_net_private *priv = seq->private;
+
+	put_net_track(priv->net, &priv->ns_tracker);
+#else
+	put_net(&init_net);
+#endif
+}
+
 static int seq_release_net(struct inode *ino, struct file *f)
 {
 	struct seq_file *seq = f->private_data;
 
-	put_net(seq_file_net(seq));
+	seq_file_net_put_net(seq);
 	seq_release_private(ino, f);
 	return 0;
 }
@@ -87,7 +99,8 @@ int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_info *aux)
 #ifdef CONFIG_NET_NS
 	struct seq_net_private *p = priv_data;
 
-	p->net = get_net(current->nsproxy->net_ns);
+	p->net = get_net_track(current->nsproxy->net_ns, &p->ns_tracker,
+			       GFP_KERNEL);
 #endif
 	return 0;
 }
@@ -97,7 +110,7 @@ void bpf_iter_fini_seq_net(void *priv_data)
 #ifdef CONFIG_NET_NS
 	struct seq_net_private *p = priv_data;
 
-	put_net(p->net);
+	put_net_track(p->net, &p->ns_tracker);
 #endif
 }
 
diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index 0fdbe1ddd8d1bd53269c4ca49297544860f3d3e5..b97912fdbae78304be7c3c45c862dce880e08dd4 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -9,7 +9,8 @@ extern struct net init_net;
 
 struct seq_net_private {
 #ifdef CONFIG_NET_NS
-	struct net *net;
+	struct net	*net;
+	netns_tracker	ns_tracker;
 #endif
 };
 
-- 
2.34.1.400.ga245620fadb-goog

