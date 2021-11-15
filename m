Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BAB450B14
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhKORRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbhKORQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:16:08 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F71C079781
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:57 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x5so4946852pfr.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qayLb2xV/LFUDq1f3MKbLUkAQUL6V+68jcfEVuc4xqs=;
        b=RRa8MvwpTkr5qVypRG5DMnyh+aFzJf/39/a7rKNErMECzM1zoslAxL0PKwMNZ0rYFi
         EZl5G0Si07JfBCtXnkS5etmXZKCyF6YoIhU5oETcx3+3y8j+4r9AXSf262mcCNQM2a8P
         J03pr7GS7aFoItLz+Esl+0no8S0L93flLNnvZ7Ek+EM/d8zTUs0WAcM0g2Jaqup2twxG
         /nPEIPy04e06xEhhjmqKv3C3F/LEJVlTkbn7pyfAwy5SLwQyM0gzAbTnzHKFqSibmQyO
         wCe/hBc8FiFe3c/K21kWL/3TBoFvHcGFomy89tFsE7ah9etyEgQZlcZNFMa5I+T5SGez
         PkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qayLb2xV/LFUDq1f3MKbLUkAQUL6V+68jcfEVuc4xqs=;
        b=NQOZCSCOs99ym/v5CbPPZKfD+Kz3HTCAerEaxQdmaDs1ydeTjDEiDz3V/ApbT+vpq6
         RUsFmX1sDoa3fnr8f+uxNI0uJSZbFufAZUXPdor75DrdmaBN4lk0DqVNf8FxYEcUlWP0
         v8UTW+nDJJIA1w/VsGQZidlFJyO8nc58o7TSpJ9k5z8dupGAtyTyjctqBxkY1HNsnlPa
         jroH9mIr5imiuFwMTuwKsTMS++QcAdcNdJAb6UM5SziLBehShcSmkb7JLasdcFMaCYEh
         6t8hC811p2z3Zu1gwy6U6KcWCzx+JpnyKhIAf10Lb886xplo4JxzqP2KuprIk2CVGG08
         QAPw==
X-Gm-Message-State: AOAM532J2li68olMTc1GCad3ue+h5uu6/MbieLdt+4gebgkWFEbT+5T/
        EGZMJ/fs1/oNOiw5XsmYPkc=
X-Google-Smtp-Source: ABdhPJzYwsRCqYRoYG5YZSRxW1JDRVCsrSupd7zbAT0JdP9dr0DXzWD85+ozggcA4QwKtZvGbHEGbA==
X-Received: by 2002:aa7:84d7:0:b0:49f:aa6d:8745 with SMTP id x23-20020aa784d7000000b0049faa6d8745mr34340047pfn.50.1636996315587;
        Mon, 15 Nov 2021 09:11:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id j127sm16466632pfg.14.2021.11.15.09.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:11:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] net: inline sock_prot_inuse_add()
Date:   Mon, 15 Nov 2021 09:11:47 -0800
Message-Id: <20211115171150.3646016-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115171150.3646016-1-eric.dumazet@gmail.com>
References: <20211115171150.3646016-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sock_prot_inuse_add() is very small, we can inline it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 14 +++++++++++---
 net/core/sock.c    | 11 -----------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b32906e1ab55527b5418f203d3de05853863f166..3f08e9d55f0ceed4ec4593012e6c856b400fc33f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1419,13 +1419,21 @@ proto_memory_pressure(struct proto *prot)
 
 
 #ifdef CONFIG_PROC_FS
+#define PROTO_INUSE_NR	64	/* should be enough for the first time */
+struct prot_inuse {
+	int val[PROTO_INUSE_NR];
+};
 /* Called with local bh disabled */
-void sock_prot_inuse_add(struct net *net, struct proto *prot, int inc);
+static inline void sock_prot_inuse_add(const struct net *net,
+				       const struct proto *prot, int val)
+{
+	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
+}
 int sock_prot_inuse_get(struct net *net, struct proto *proto);
 int sock_inuse_get(struct net *net);
 #else
-static inline void sock_prot_inuse_add(struct net *net, struct proto *prot,
-		int inc)
+static inline void sock_prot_inuse_add(const struct net *net,
+				       const struct proto *prot, int val)
 {
 }
 #endif
diff --git a/net/core/sock.c b/net/core/sock.c
index 8f2b2f2c0e7b1decdb4a5c8d86327ed7caa62c99..fac46efd31fd44b4105c6004b4491aa11e1ed67c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3532,19 +3532,8 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 }
 
 #ifdef CONFIG_PROC_FS
-#define PROTO_INUSE_NR	64	/* should be enough for the first time */
-struct prot_inuse {
-	int val[PROTO_INUSE_NR];
-};
-
 static DECLARE_BITMAP(proto_inuse_idx, PROTO_INUSE_NR);
 
-void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
-{
-	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
-}
-EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
-
 int sock_prot_inuse_get(struct net *net, struct proto *prot)
 {
 	int cpu, idx = prot->inuse_idx;
-- 
2.34.0.rc1.387.gb447b232ab-goog

