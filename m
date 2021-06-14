Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89373A72A4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFNXzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 19:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhFNXzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 19:55:10 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F73C061574;
        Mon, 14 Jun 2021 16:52:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g22so4887544pgk.1;
        Mon, 14 Jun 2021 16:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzrwDLq6rSGwq7hR9b7UB2LYdIgrZENxyMug//2zCHw=;
        b=UsHZRDas5Rr006JPWAuo+xx8+wfUMc9BQBNCAj27XwQ0UCdQGPm9nSsQ6yqZ3Zpd6U
         FmXMpbqGgF58cwXlBJbt7ePG2PyHiVsY83vV+rGhbbVoy05AbZFPGGaQ+oaLX0XRzErr
         feCoBjciJ0HPePoErB4U5Oz8Ond6OVZBABjePKYgEoNdr5/mUoIoTO1hIdZPm9Upre9R
         KgnggLjCsfo/jn98JERVzn4jaQTgo8YtgndRKPvEm8lwHMmcDD2qq4pVZu0TJKmEUesk
         cntIFlL/FRHCwy8hbW/GU5zBQ72ii+xodvrMwzVRclau3SiYbpGoi8wqoebMUO3t0g9L
         SudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzrwDLq6rSGwq7hR9b7UB2LYdIgrZENxyMug//2zCHw=;
        b=iRtjXntOPo1N+RhXXEgoedO9wrDkke2LY4mQfoxfZxoIjd7+w0xJprBxYKx2eSLKds
         TCdfSWlMbKv0NsASfwZYRdLS8n5fSvE9g3gmtHWGrLUj7Cb5LDCd36fc/+87P1h64zWD
         CzJ04Fnt0ObfegtlLQTCKX+l/u5z7pIZ4CGzt8VmLyKTTw/L1+TS9a3tMFmGZKHxOunA
         M60r+ci2ZWqKH0XB9ITMYRnf7B+bmPWp/s/+dp4kvNbkU6gzySTzBd+XVnEdcFQ6dlHT
         JxDjH4ZpBdqavPqPH1YY90EH2+GbGQGPr/lqjSM50rl3zaCm2Qt1O69WFpEhwCBD2Fno
         eb3w==
X-Gm-Message-State: AOAM533UII4RNAxVyPtQZi7Kr4Ba4lgI7zdkgcSwYNw+MAwtasNFARXe
        3dxfH03Pb/vtFabJRK2IO0w=
X-Google-Smtp-Source: ABdhPJxU12POMiz425RgMv+h1L9rYomjk03xnD8/VdAQz4ie8vMd1FNXpU7ekSZTRdW7RWiHBWutSA==
X-Received: by 2002:a63:6e87:: with SMTP id j129mr19734947pgc.45.1623714771788;
        Mon, 14 Jun 2021 16:52:51 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id h21sm12966524pfv.190.2021.06.14.16.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 16:52:51 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kici nski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>
Subject: [PATCH v2] net: inline function get_net_ns_by_fd if NET_NS is disabled
Date:   Tue, 15 Jun 2021 07:52:43 +0800
Message-Id: <20210614235243.51546-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function get_net_ns_by_fd() could be inlined when NET_NS is not
enabled.

Signed-off-by: Changbin Du <changbin.du@gmail.com>

---
v2: rebase to net-tree.
---
 include/net/net_namespace.h | 7 ++++++-
 net/core/net_namespace.c    | 8 +-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 6412d7833d97..bdc0459a595e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -186,6 +186,7 @@ void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 void net_ns_barrier(void);
 
 struct ns_common *get_net_ns(struct ns_common *ns);
+struct net *get_net_ns_by_fd(int fd);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
@@ -210,13 +211,17 @@ static inline struct ns_common *get_net_ns(struct ns_common *ns)
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline struct net *get_net_ns_by_fd(int fd)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_NET_NS */
 
 
 extern struct list_head net_namespace_list;
 
 struct net *get_net_ns_by_pid(pid_t pid);
-struct net *get_net_ns_by_fd(int fd);
 
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index cc8dafb25d61..9b5a767eddd5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -672,14 +672,8 @@ struct net *get_net_ns_by_fd(int fd)
 	fput(file);
 	return net;
 }
-
-#else
-struct net *get_net_ns_by_fd(int fd)
-{
-	return ERR_PTR(-EINVAL);
-}
-#endif
 EXPORT_SYMBOL_GPL(get_net_ns_by_fd);
+#endif
 
 struct net *get_net_ns_by_pid(pid_t pid)
 {
-- 
2.30.2

