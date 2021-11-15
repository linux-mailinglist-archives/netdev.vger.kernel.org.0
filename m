Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8714527A4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbhKPC3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhKORQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:16:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8815EC06120C
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:58 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso13737945pji.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9sQDD/4/Q8DJlCorQNfKu6150bTPmEtz37IdYnRvKY=;
        b=Lrx8pdO4QmetG9vTbYCwYD7pU1xvquwvb3qoSX4Ozl/1LMBD5rOAQ+Fl1Rf9Qvwzbu
         BnnVIg7wMdr9gQNs1EhT/lIeE4AsTMkLmgQsSTh/fRHsy4BUt2+JeL0LrrNE7G3vskDj
         4Vry7k1lrvp83ZdOqEtQAcEmogmp/fbIQULggxwqCUk8vSIiLGgjwNWBQH9ujfz2CMof
         D04uRGBW9V2Z7tjLkhPscaCmYUbqUyChSzpxw75WfMl4K3roSf5YAGwiNeN184af42Fd
         twuS1/uSquFvW70q6qvkjdFX2RnPB2PqJaifwkWyTY23PM2Hebzmq9BYJLlImIgDggO7
         Kp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9sQDD/4/Q8DJlCorQNfKu6150bTPmEtz37IdYnRvKY=;
        b=jND1f1vmKYCasmxYPAmZp/9Jn5OXhEASfchS2exfd2xewKY/UtGYHAy3rd3JNrNtUu
         L7GZThaCrc4iZGaBWSdL+rMKKXD3mgVUqtRLBsYlVo4AvZy1pAbDswwxoVeiEKU52yBH
         XXM5u6OwmBWrQsWoYIC438wYnie8Q9sw+BLeq/FV8EyCGOflQlUTeJ8dYN0Qsn7dFZdP
         5YXpJuhqMHiubQpmYF5GDGWqMSZftInI7p/0LZZc9AZXMrJiV/RqrE47QWL5MeiuEnRf
         vBPPdYgfMjDfIzx7foaoUdHtpRszrIbPGBXptekLaQRrSJddJQMdVStMhiomecinM2wS
         HAOw==
X-Gm-Message-State: AOAM531IAped5Uog08S5s0MB49PwoQrR+yw2Z3diTz3NkUrIMz39Pash
        A1BQUMd/Mi9DONVxMNNXKYo=
X-Google-Smtp-Source: ABdhPJyC1bHhBSwGPU/ekoPpiXeAylG69a6kidwEX5JcKhMxw4JZzrOwS42KHgv3dcNzC10y31RScQ==
X-Received: by 2002:a17:90b:314c:: with SMTP id ip12mr133285pjb.162.1636996318130;
        Mon, 15 Nov 2021 09:11:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id j127sm16466632pfg.14.2021.11.15.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:11:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: make sock_inuse_add() available
Date:   Mon, 15 Nov 2021 09:11:48 -0800
Message-Id: <20211115171150.3646016-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115171150.3646016-1-eric.dumazet@gmail.com>
References: <20211115171150.3646016-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

MPTCP hard codes it, let us instead provide this helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h  | 10 ++++++++++
 net/core/sock.c     | 10 ----------
 net/mptcp/subflow.c |  4 +---
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3f08e9d55f0ceed4ec4593012e6c856b400fc33f..cdc7ebc049b41b00aa7c851a6f1df6e58bae8430 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1429,6 +1429,12 @@ static inline void sock_prot_inuse_add(const struct net *net,
 {
 	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
 }
+
+static inline void sock_inuse_add(const struct net *net, int val)
+{
+	this_cpu_add(*net->core.sock_inuse, val);
+}
+
 int sock_prot_inuse_get(struct net *net, struct proto *proto);
 int sock_inuse_get(struct net *net);
 #else
@@ -1436,6 +1442,10 @@ static inline void sock_prot_inuse_add(const struct net *net,
 				       const struct proto *prot, int val)
 {
 }
+
+static inline void sock_inuse_add(const struct net *net, int val)
+{
+}
 #endif
 
 
diff --git a/net/core/sock.c b/net/core/sock.c
index fac46efd31fd44b4105c6004b4491aa11e1ed67c..214c2e816c63dba9146557a622516e73c1da142e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -144,8 +144,6 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
-static void sock_inuse_add(struct net *net, int val);
-
 /**
  * sk_ns_capable - General socket capability test
  * @sk: Socket to use a capability on or through
@@ -3546,11 +3544,6 @@ int sock_prot_inuse_get(struct net *net, struct proto *prot)
 }
 EXPORT_SYMBOL_GPL(sock_prot_inuse_get);
 
-static void sock_inuse_add(struct net *net, int val)
-{
-	this_cpu_add(*net->core.sock_inuse, val);
-}
-
 int sock_inuse_get(struct net *net)
 {
 	int cpu, res = 0;
@@ -3629,9 +3622,6 @@ static inline void release_proto_idx(struct proto *prot)
 {
 }
 
-static void sock_inuse_add(struct net *net, int val)
-{
-}
 #endif
 
 static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6172f380dfb763b43c6d996b4896215cad9c7d7b..49787a1d7b3467acdfe284fd1494ac4c4a6eaf5c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1534,9 +1534,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	 */
 	sf->sk->sk_net_refcnt = 1;
 	get_net(net);
-#ifdef CONFIG_PROC_FS
-	this_cpu_add(*net->core.sock_inuse, 1);
-#endif
+	sock_inuse_add(net, 1);
 	err = tcp_set_ulp(sf->sk, "mptcp");
 	release_sock(sf->sk);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

