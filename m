Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D646D370F40
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhEBVNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBVM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 17:12:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E312C06174A;
        Sun,  2 May 2021 14:12:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q9so2319180pgl.13;
        Sun, 02 May 2021 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6Tew3fIKE8mp1DfEhtGtLfIGo/Xh6uMnhvGW+TPG/Jk=;
        b=f25eNO1lxxCmddvV0ThPJHHIvRS/nGjlcMg3EpcGD6ItJTLX8wtHkPFF9nBxX9fxhL
         QBoJAu9rUaxQx/rBG5Wiu3tWpbYKkuYhLr3zNejha97EVrwXLGDtNCOzZ6BsxXqtc09X
         jYffODzpMyf5xy0fyaH+PlyrJqu80kuSk75x7MDmjRnVDANDXyprSX4oRJaxCbvnnMkU
         pr47B8KDCWnxuCc77qyKXD1k+QaxNt6XgAVPN7UBhF1qtathH8e9iaZvj6OxDoFTQKe6
         6WviJRz2xfyBqDs7hJIwDSmrQgJs8NIITZZ4VSV8gvZqNj2wCgVzi5a8zew1m6WwBVxp
         1eiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6Tew3fIKE8mp1DfEhtGtLfIGo/Xh6uMnhvGW+TPG/Jk=;
        b=sZRVd80yM91XzIkPEg9mOI6Mfx9OP/lVYnT09s/FI+n833PVuKAuw7l2U38nbpHM3p
         RPVDNVArOaizIYmMsNhdc7AI41BBUIJRzsbVGckT7p/g4DsdM6FPLqHssi/WDix7LH21
         Ux3F7XR7a4RIMjbQcveymhvYlMUwg8G3fSa7Qx46A4169lfxAxNolEdJZjBrSog6IhGs
         g4oXuxYSgjOEmyjXmjCOYfsnMIXsYCrkuAv2Npu9Hz/wilcQP8i9QNYGsBxJKPgd+YU2
         snxZoBCP3Zm5mIhz9QKzZIAHsS7231oSNJcLzgrEXG8/j1zNu4VjdZzmFBJlYSQz34be
         O1QA==
X-Gm-Message-State: AOAM531xZ+pt1wEj5S/zvWgcK86dV2rmvxrWDTyOj2TKosgryC2f+0Mf
        nTAF8/WVyJYWKoA4Usdau3yUrah5qqsJaOok
X-Google-Smtp-Source: ABdhPJxkY9gnYau2UwZDhuNmcIj1pJZmcMVqmamWZfCMDBEV0kIcQ+iWzxoFLpkokXnsOXjIQg5ZXg==
X-Received: by 2002:a63:7986:: with SMTP id u128mr15324163pgc.223.1619989927368;
        Sun, 02 May 2021 14:12:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ng6sm15706467pjb.14.2021.05.02.14.12.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 14:12:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH net 2/2] sctp: delay auto_asconf init until binding the first addr
Date:   Mon,  3 May 2021 05:11:42 +0800
Message-Id: <8f397eb9b1e75b4de26fcd76071aa3718ab70a2c.1619989856.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4dc7d7dd4bcf7122604ccb52a5c747c3fb9101c5.1619989856.git.lucien.xin@gmail.com>
References: <cover.1619989856.git.lucien.xin@gmail.com>
 <4dc7d7dd4bcf7122604ccb52a5c747c3fb9101c5.1619989856.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619989856.git.lucien.xin@gmail.com>
References: <cover.1619989856.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Or Cohen described:

  If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
  held and sp->do_auto_asconf is true, then an element is removed
  from the auto_asconf_splist without any proper locking.

  This can happen in the following functions:
  1. In sctp_accept, if sctp_sock_migrate fails.
  2. In inet_create or inet6_create, if there is a bpf program
     attached to BPF_CGROUP_INET_SOCK_CREATE which denies
     creation of the sctp socket.

This patch is to fix it by moving the auto_asconf init out of
sctp_init_sock(), by which inet_create()/inet6_create() won't
need to operate it in sctp_destroy_sock() when calling
sk_common_release().

It also makes more sense to do auto_asconf init while binding the
first addr, as auto_asconf actually requires an ANY addr bind,
see it in sctp_addr_wq_timeout_handler().

This addresses CVE-2021-23133.

Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 76a388b5..40f9f6c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -357,6 +357,18 @@ static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
 	return af;
 }
 
+static void sctp_auto_asconf_init(struct sctp_sock *sp)
+{
+	struct net *net = sock_net(&sp->inet.sk);
+
+	if (net->sctp.default_auto_asconf) {
+		spin_lock(&net->sctp.addr_wq_lock);
+		list_add_tail(&sp->auto_asconf_list, &net->sctp.auto_asconf_splist);
+		spin_unlock(&net->sctp.addr_wq_lock);
+		sp->do_auto_asconf = 1;
+	}
+}
+
 /* Bind a local address either to an endpoint or to an association.  */
 static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 {
@@ -418,8 +430,10 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 		return -EADDRINUSE;
 
 	/* Refresh ephemeral port.  */
-	if (!bp->port)
+	if (!bp->port) {
 		bp->port = inet_sk(sk)->inet_num;
+		sctp_auto_asconf_init(sp);
+	}
 
 	/* Add the address to the bind address list.
 	 * Use GFP_ATOMIC since BHs will be disabled.
@@ -4993,19 +5007,6 @@ static int sctp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	/* Nothing can fail after this block, otherwise
-	 * sctp_destroy_sock() will be called without addr_wq_lock held
-	 */
-	if (net->sctp.default_auto_asconf) {
-		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
-		list_add_tail(&sp->auto_asconf_list,
-		    &net->sctp.auto_asconf_splist);
-		sp->do_auto_asconf = 1;
-		spin_unlock(&sock_net(sk)->sctp.addr_wq_lock);
-	} else {
-		sp->do_auto_asconf = 0;
-	}
-
 	local_bh_enable();
 
 	return 0;
@@ -9401,6 +9402,8 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 			return err;
 	}
 
+	sctp_auto_asconf_init(newsp);
+
 	/* Move any messages in the old socket's receive queue that are for the
 	 * peeled off association to the new socket's receive queue.
 	 */
-- 
2.1.0

