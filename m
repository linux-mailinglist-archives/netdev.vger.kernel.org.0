Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A63562FF85
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKRVpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiKRVpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:45:08 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF6088FB4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:07 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id df6so2020788qvb.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xL2dxZZ+2wUAwiTvYsxOOu5mixYpfrSKbofQ4f5aFek=;
        b=VFRYXKMckUn5DbITT/pfr/somDp6/Lg59LAQstNGr0E1YG9OiUiqGVrmlFu8B3UaxX
         qEdmd8jcI1kDa9cq9AeNCft7QHT6XHliVhVxT43W59bpRvP6tfczDz/leLvdN/Jjxaer
         IgjnCrdpHx5if2XPc1gCsLsKZtApxI9YnQwQGceaVKWdFScapba28RqpMw2HDpTsATwA
         i0BNeP5YxfujC+ZuhFTgLpeIEHID9L2ZZteJCLyWbZSHCGBM9mbyeDaXgvF9gjNt1WqW
         YLG07bZyNuytbHhjfC1FyQcNDz3ITN8F4hgcLn1xtmsL1V3yKR/9PaLWkOpVqX9i1hOz
         rXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xL2dxZZ+2wUAwiTvYsxOOu5mixYpfrSKbofQ4f5aFek=;
        b=yfwhtMxbbxWU8edbh+V/Zo2/O6cmc+s2iRRnfSAWWtdgJWEImLbazgCPAwYmEFch6u
         vOx9HUVDgD169yh0KRjIP5GhZBcsHVPUsNS0Q7CQvbbM4Qr0jYK5t9SYFDQbzQeBYcSL
         d5vetaoM5tAhFeXH3Nr5vao9muN5VHh1o3G5oOU7a7ruZDas+xwWhV46YRx9vEX45Ins
         cRweuI2rCddWSCQd5FyiYVKkZ+Tx3/vq79PROQ+lmoySwvjfIX3+MbnhZ1JM0+sGp3Ri
         UUsM7yqKVnVzrr6JYnSadh201IYuy+2V/7nPu9WvETuw+5k49uXxwNY5Az/eVVW7hP5c
         cR5g==
X-Gm-Message-State: ANoB5pnYc72MLQ0Ra2qglbqmi4ndKStWuYcnRZFQjNXPwrHydobRKOLS
        UunZemenPk3ntf3Qb42F5IW1+A3NNugAwA==
X-Google-Smtp-Source: AA0mqf4E6fLHxiBedVlxXqpYuDu7JsBXwWFu5rRRGBilMqwZCjs+4j/uxL0I0givKzXnZdsBp54TKw==
X-Received: by 2002:ad4:4482:0:b0:4bb:8ef1:b544 with SMTP id m2-20020ad44482000000b004bb8ef1b544mr8610094qvt.99.1668807906604;
        Fri, 18 Nov 2022 13:45:06 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi41-20020a05620a31a900b006f956766f76sm3232917qkb.1.2022.11.18.13.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:45:06 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH net 1/2] tipc: set con sock in tipc_conn_alloc
Date:   Fri, 18 Nov 2022 16:45:00 -0500
Message-Id: <bc7bd3183f1c275c820690fc65b708238fe9e38e.1668807842.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668807842.git.lucien.xin@gmail.com>
References: <cover.1668807842.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A crash was reported by Wei Chen:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  RIP: 0010:tipc_conn_close+0x12/0x100
  Call Trace:
   tipc_topsrv_exit_net+0x139/0x320
   ops_exit_list.isra.9+0x49/0x80
   cleanup_net+0x31a/0x540
   process_one_work+0x3fa/0x9f0
   worker_thread+0x42/0x5c0

It was caused by !con->sock in tipc_conn_close(). In tipc_topsrv_accept(),
con is allocated in conn_idr then its sock is set:

  con = tipc_conn_alloc();
  ...                    <----[1]
  con->sock = newsock;

If tipc_conn_close() is called in anytime of [1], the null-pointer-def
is triggered by con->sock->sk due to con->sock is not yet set.

This patch fixes it by moving the con->sock setting to tipc_conn_alloc()
under s->idr_lock. So that con->sock can never be NULL when getting the
con from s->conn_idr. It will be also safer to move con->server and flag
CF_CONNECTED setting under s->idr_lock, as they should all be set before
tipc_conn_alloc() is called.

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/topsrv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index d92ec92f0b71..b0f9aa521670 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -176,7 +176,7 @@ static void tipc_conn_close(struct tipc_conn *con)
 	conn_put(con);
 }
 
-static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
+static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *sock)
 {
 	struct tipc_conn *con;
 	int ret;
@@ -202,10 +202,11 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s)
 	}
 	con->conid = ret;
 	s->idr_in_use++;
-	spin_unlock_bh(&s->idr_lock);
 
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
+	con->sock = sock;
+	spin_unlock_bh(&s->idr_lock);
 
 	return con;
 }
@@ -467,7 +468,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
 			return;
-		con = tipc_conn_alloc(srv);
+		con = tipc_conn_alloc(srv, newsock);
 		if (IS_ERR(con)) {
 			ret = PTR_ERR(con);
 			sock_release(newsock);
@@ -479,7 +480,6 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		newsk->sk_data_ready = tipc_conn_data_ready;
 		newsk->sk_write_space = tipc_conn_write_space;
 		newsk->sk_user_data = con;
-		con->sock = newsock;
 		write_unlock_bh(&newsk->sk_callback_lock);
 
 		/* Wake up receive process in case of 'SYN+' message */
@@ -577,12 +577,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.filter = filter;
 	*(u64 *)&sub.usr_handle = (u64)port;
 
-	con = tipc_conn_alloc(tipc_topsrv(net));
+	con = tipc_conn_alloc(tipc_topsrv(net), NULL);
 	if (IS_ERR(con))
 		return false;
 
 	*conid = con->conid;
-	con->sock = NULL;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
 	if (rc >= 0)
 		return true;
-- 
2.31.1

