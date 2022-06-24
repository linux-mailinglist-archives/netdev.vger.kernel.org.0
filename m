Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E644559E87
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiFXQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiFXQYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:24:37 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8855A165B2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:24:35 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id f14so2351648qkm.0
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V+Xo5Z+4GigNUMqqi7J1sIaRxnSMMyJNzyBU9jsG/jk=;
        b=lLkF5lDQyf5QWfmlR9hn0mgcfC76zUlI+2cOjQTvpZlfDtehRVpGpkfCP5WstjOusa
         rvJoi0HoifdAIeQ4XQSOw8FALLo/zd0KD8YGGOCOpUTzcIcUX+7WqlZn61gJ6KoyS18I
         2imCEF45eZo9CNSM9/BExm1T8xDA1uRx9maLmjHgUjc8Fw2LoVLstas0+Gg4tdWeaKJ1
         PFzhFUIxC7ej6mhoMRpNmc05srLpTEApcud9SJqDv3fnAj27h21cSJo41rQ0mYLXBTbY
         j1JUh/q1RFV2LxJ6MDoLf4sH3JMSuRa3a7kuWXvxR16hL7Z59Trh71Vx3HZJCtqVTwyv
         r/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V+Xo5Z+4GigNUMqqi7J1sIaRxnSMMyJNzyBU9jsG/jk=;
        b=hE2R0Uj/v7Acn45+3nkoDE9HZu3VzR377VnylMgxrJHsZnXc7+7l2UQ0IL6RqLgbFM
         TAu2moWk6ma0HQxtCpLdEOcHvXWmY6qUUJLN01qzP3j6o2dxkVzhHcptLeQi0Ktxe7RP
         cxB+m50NY7F+CDFXpToJbiplJj5QI73HHgEQTL53WaKPd1V+NZUBB2jjNOTTB9lyfemA
         abCqFAQG6APL8XSMEwxyR9P07Y6h8c+5IbwK2z/5JSz+Fy/pcgvI9BmbvFDs/sADaY9B
         LDW7v/cQO+pDNP7RfjwWhRbyhrQxU1exUM//bc5p9eDbsV8dpnSf5mquRYW8frPbLTbZ
         PqHw==
X-Gm-Message-State: AJIora/NK2/xdobgbFjIO6U1XTlzDyOciKE4thdTAbSWMI41u2hqLI20
        2Zs7NEmMIkxzcHqxp8l8QZW4z+8g49zIXk6T
X-Google-Smtp-Source: AGRyM1uIFWrCnDTMOYgBMczFj2/o9o1rKsbbrZF0sMSyct5hvhiI/QUbthvYEiTQMdf8GUctN9xdkg==
X-Received: by 2002:ae9:f40b:0:b0:6ae:fdd7:1939 with SMTP id y11-20020ae9f40b000000b006aefdd71939mr5537062qkl.657.1656087874176;
        Fri, 24 Jun 2022 09:24:34 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k20-20020a05620a07f400b006a6ab259261sm1928647qkk.29.2022.06.24.09.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:24:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>
Subject: [PATCH net] tipc: move bc link creation back to tipc_node_create
Date:   Fri, 24 Jun 2022 12:24:31 -0400
Message-Id: <fe367ef0159c2f41e475bd1d00e0dc8d8a85b224.1656087871.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuang Li reported a NULL pointer dereference crash:

  [] BUG: kernel NULL pointer dereference, address: 0000000000000068
  [] RIP: 0010:tipc_link_is_up+0x5/0x10 [tipc]
  [] Call Trace:
  []  <IRQ>
  []  tipc_bcast_rcv+0xa2/0x190 [tipc]
  []  tipc_node_bc_rcv+0x8b/0x200 [tipc]
  []  tipc_rcv+0x3af/0x5b0 [tipc]
  []  tipc_udp_recv+0xc7/0x1e0 [tipc]

It was caused by the 'l' passed into tipc_bcast_rcv() is NULL. When it
creates a node in tipc_node_check_dest(), after inserting the new node
into hashtable in tipc_node_create(), it creates the bc link. However,
there is a gap between this insert and bc link creation, a bc packet
may come in and get the node from the hashtable then try to dereference
its bc link, which is NULL.

This patch is to fix it by moving the bc link creation before inserting
into the hashtable.

Note that for a preliminary node becoming "real", the bc link creation
should also be called before it's rehashed, as we don't create it for
preliminary nodes.

Fixes: 4cbf8ac2fe5a ("tipc: enable creating a "preliminary" node")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/node.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 6ef95ce565bd..b48d97cbbe29 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -472,8 +472,8 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 				   bool preliminary)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_link *l, *snd_l = tipc_bc_sndlink(net);
 	struct tipc_node *n, *temp_node;
-	struct tipc_link *l;
 	unsigned long intv;
 	int bearer_id;
 	int i;
@@ -488,6 +488,16 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 			goto exit;
 		/* A preliminary node becomes "real" now, refresh its data */
 		tipc_node_write_lock(n);
+		if (!tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+					 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+					 n->capabilities, &n->bc_entry.inputq1,
+					 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+			pr_warn("Broadcast rcv link refresh failed, no memory\n");
+			tipc_node_write_unlock_fast(n);
+			tipc_node_put(n);
+			n = NULL;
+			goto exit;
+		}
 		n->preliminary = false;
 		n->addr = addr;
 		hlist_del_rcu(&n->hash);
@@ -567,7 +577,16 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 	n->signature = INVALID_NODE_SIG;
 	n->active_links[0] = INVALID_BEARER_ID;
 	n->active_links[1] = INVALID_BEARER_ID;
-	n->bc_entry.link = NULL;
+	if (!preliminary &&
+	    !tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+				 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+				 n->capabilities, &n->bc_entry.inputq1,
+				 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+		pr_warn("Broadcast rcv link creation failed, no memory\n");
+		kfree(n);
+		n = NULL;
+		goto exit;
+	}
 	tipc_node_get(n);
 	timer_setup(&n->timer, tipc_node_timeout, 0);
 	/* Start a slow timer anyway, crypto needs it */
@@ -1155,7 +1174,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 			  bool *respond, bool *dupl_addr)
 {
 	struct tipc_node *n;
-	struct tipc_link *l, *snd_l;
+	struct tipc_link *l;
 	struct tipc_link_entry *le;
 	bool addr_match = false;
 	bool sign_match = false;
@@ -1175,22 +1194,6 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		return;
 
 	tipc_node_write_lock(n);
-	if (unlikely(!n->bc_entry.link)) {
-		snd_l = tipc_bc_sndlink(net);
-		if (!tipc_link_bc_create(net, tipc_own_addr(net),
-					 addr, peer_id, U16_MAX,
-					 tipc_link_min_win(snd_l),
-					 tipc_link_max_win(snd_l),
-					 n->capabilities,
-					 &n->bc_entry.inputq1,
-					 &n->bc_entry.namedq, snd_l,
-					 &n->bc_entry.link)) {
-			pr_warn("Broadcast rcv link creation failed, no mem\n");
-			tipc_node_write_unlock_fast(n);
-			tipc_node_put(n);
-			return;
-		}
-	}
 
 	le = &n->links[b->identity];
 
-- 
2.31.1

