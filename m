Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6403BF3D81
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfKHBm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:42:28 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32928 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbfKHBm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:42:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 4F77E4AAFB;
        Fri,  8 Nov 2019 12:42:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1573177343; bh=WsAHGtvnt886PVnpqF4ThKKTW7gJtIaWyQTSJX5MOGk=; b=S
        ugZYM7dt8Clz6R3i6wGBpPqr86x2OR0roch29fWQVbrST3qtKJwaqUthrW7iPmaK
        nm7GiBGA8aUMHk/EQj6fOsgf69nHhv6f5ZXpPI9C9r2z55ScsdOKwClyGeSEVbE8
        MlnzDulVjAHELZmhxgIK97F/k0T+SoS5wGAJXOwePE=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yO1Y6oMCNFM8; Fri,  8 Nov 2019 12:42:23 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 347784AAFC;
        Fri,  8 Nov 2019 12:42:23 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 1D9194AAFB;
        Fri,  8 Nov 2019 12:42:21 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 1/5] tipc: add reference counter to bearer
Date:   Fri,  8 Nov 2019 08:42:09 +0700
Message-Id: <20191108014213.32219-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191108014213.32219-1-tuong.t.lien@dektech.com.au>
References: <20191108014213.32219-1-tuong.t.lien@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a need to support the crypto asynchronous operations in the later
commits, apart from the current RCU mechanism for bearer pointer, we
add a 'refcnt' to the bearer object as well.

So, a bearer can be hold via 'tipc_bearer_hold()' without being freed
even though the bearer or interface can be disabled in the meanwhile.
If that happens, the bearer will be released then when the crypto
operation is completed and 'tipc_bearer_put()' is called.

Acked-by: Ying Xue <ying.xue@windreiver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/bearer.c | 14 +++++++++++++-
 net/tipc/bearer.h |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 0214aa1c4427..6e15b9b1f1ef 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -315,6 +315,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	b->net_plane = bearer_id + 'A';
 	b->priority = prio;
 	test_and_set_bit_lock(0, &b->up);
+	refcount_set(&b->refcnt, 1);
 
 	res = tipc_disc_create(net, b, &b->bcast_addr, &skb);
 	if (res) {
@@ -351,6 +352,17 @@ static int tipc_reset_bearer(struct net *net, struct tipc_bearer *b)
 	return 0;
 }
 
+bool tipc_bearer_hold(struct tipc_bearer *b)
+{
+	return (b && refcount_inc_not_zero(&b->refcnt));
+}
+
+void tipc_bearer_put(struct tipc_bearer *b)
+{
+	if (b && refcount_dec_and_test(&b->refcnt))
+		kfree_rcu(b, rcu);
+}
+
 /**
  * bearer_disable
  *
@@ -369,7 +381,7 @@ static void bearer_disable(struct net *net, struct tipc_bearer *b)
 	if (b->disc)
 		tipc_disc_delete(b->disc);
 	RCU_INIT_POINTER(tn->bearer_list[bearer_id], NULL);
-	kfree_rcu(b, rcu);
+	tipc_bearer_put(b);
 	tipc_mon_delete(net, bearer_id);
 }
 
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index ea0f3c49cbed..faca696d422f 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -165,6 +165,7 @@ struct tipc_bearer {
 	struct tipc_discoverer *disc;
 	char net_plane;
 	unsigned long up;
+	refcount_t refcnt;
 };
 
 struct tipc_bearer_names {
@@ -210,6 +211,8 @@ int tipc_media_set_window(const char *name, u32 new_value);
 int tipc_media_addr_printf(char *buf, int len, struct tipc_media_addr *a);
 int tipc_enable_l2_media(struct net *net, struct tipc_bearer *b,
 			 struct nlattr *attrs[]);
+bool tipc_bearer_hold(struct tipc_bearer *b);
+void tipc_bearer_put(struct tipc_bearer *b);
 void tipc_disable_l2_media(struct tipc_bearer *b);
 int tipc_l2_send_msg(struct net *net, struct sk_buff *buf,
 		     struct tipc_bearer *b, struct tipc_media_addr *dest);
-- 
2.13.7

