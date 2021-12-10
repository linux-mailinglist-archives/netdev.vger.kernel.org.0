Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EE646FC07
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhLJHsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhLJHsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303C2C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:40 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b11so5710349pld.12
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXlcfrrJcOZBqldY5yvVfuYUB56sD5WnFhPJ5m+yXKE=;
        b=FEmes7JSJ6x/u+ORwr1szNDsuGIBJUbaqR2SxjRkGmM4ugH6Jo8Yfkvkw6yHG0UrgH
         LUL3kpYzw1jSh0G65WeFJhSG7wpa195HvsAjbrj6exvXdeGv/L0Qe1sK+ohXZ/hgYH3a
         PbuRsq/FFAwjb4NwsQdvkAWgVvFxqFN6Y6mUh93GGDe29fAmcYjtfR5EqbNTSY0TjH8R
         bISgJHRYfcAXYAmYglmv9N5fqkOa/f5T4/qLh/xFN+HQK95U/GruJAulEl6j/xqXB88L
         ShSpR+McLXuL5oVDclS0sxvvxXKMSZwatMLkWuokNVtWIMCv6t0RBNms1tcHscUb0m3Y
         PG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXlcfrrJcOZBqldY5yvVfuYUB56sD5WnFhPJ5m+yXKE=;
        b=PcpTJHrAaeTjTg4TVkyNEPQ/K+T+N3y3/h34QftZ6a0tpTrcAH6AnfV8u8dK/Efpin
         C8wAJI8ku/u8NC6RzkE/VjTi0Agrpt/Vh5yK82BU454ep8bzF12eKP/FVBeVkr8hxzfC
         Sr0rCqIrFjrsgXJIW1FUllDntSgDEF7tGdkuDZP5foK1ch7VrW15GeIwiGyiRMH6VxAc
         7JpABye2EcWK7Szq7t8D01DC1BuBi+dkLAIjfpmwvi/muvjfrX1GTDD+VYHFAZQXL/O1
         r6Ff5i2ZzhjRMNl1Jhh8i+eRHgurLQtKHKjII1fEiya90y8ebfvFlv7dZQsTxFtHj0eq
         E53A==
X-Gm-Message-State: AOAM531cZeGNMfVQDjviqoNF/+kudz1cmmptPPRwr48JG+1ffgD7QNae
        g0l3fQKHuvPlgsJVguKip+l4+E0Y02hADQ==
X-Google-Smtp-Source: ABdhPJzd/wQpXP7qt5j7e+jT1PSDwDSWCn9c5Swu8ITKanm+z6BsKmnGymSW/K1Vs6JHVrD42deUfA==
X-Received: by 2002:a17:90b:3887:: with SMTP id mu7mr22045347pjb.41.1639122279704;
        Thu, 09 Dec 2021 23:44:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:39 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 3/6] net: add netns refcount tracker to struct seq_net_private
Date:   Thu,  9 Dec 2021 23:44:23 -0800
Message-Id: <20211210074426.279563-4-eric.dumazet@gmail.com>
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
2.34.1.173.g76aa8bc2d0-goog

