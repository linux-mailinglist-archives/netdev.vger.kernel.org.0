Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F324B7D2B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343514AbiBPCAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:00:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245756AbiBPCAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:00:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B92A4FABEF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644976828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YFBtBqy7GxzxoGYDw6JmYt8CAfh5GaKQFTvqKPCLmo8=;
        b=Y8yYTO8TCdSXWydZw7tpEy5jtZ7wBdQLY+5rQ6qhpmB1a15Ov2vUtDyzzjXa+Lsq0yM3XR
        BFXLDe0RTCr1ZCDcmlB8fdyXW6yvn6gvE/SxQMp6eRoYpj+MdrubPSejLkSaYwNg5lwmRF
        mk57e5MlOlEMv6YvPLM/KZtIu7JNYRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-rRvwecICMWez96ENeLkQfQ-1; Tue, 15 Feb 2022 21:00:25 -0500
X-MC-Unique: rRvwecICMWez96ENeLkQfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9B338030D2;
        Wed, 16 Feb 2022 02:00:23 +0000 (UTC)
Received: from fenrir.redhat.com (unknown [10.22.12.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 261BD6AB8B;
        Wed, 16 Feb 2022 02:00:09 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [v2,net] tipc: fix wrong notification node addresses
Date:   Tue, 15 Feb 2022 21:00:09 -0500
Message-Id: <20220216020009.3404578-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

The previous bug fix had an unfortunate side effect that broke
distribution of binding table entries between nodes. The updated
tipc_sock_addr struct is also used further down in the same
function, and there the old value is still the correct one.

We fix this now.

Fixes: 032062f363b4 ("tipc: fix wrong publisher node address in link publications")

Signed-off-by: Jon Maloy <jmaloy@redhat.com>

---
v2: Copied n->addr to stack variable before leaving lock context, and
    using this in the notifications.
---
 net/tipc/node.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index fd95df338da7..6ef95ce565bd 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -403,7 +403,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	u32 flags = n->action_flags;
 	struct list_head *publ_list;
 	struct tipc_uaddr ua;
-	u32 bearer_id;
+	u32 bearer_id, node;
 
 	if (likely(!flags)) {
 		write_unlock_bh(&n->lock);
@@ -414,6 +414,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 		   TIPC_LINK_STATE, n->addr, n->addr);
 	sk.ref = n->link_id;
 	sk.node = tipc_own_addr(net);
+	node = n->addr;
 	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 
@@ -423,17 +424,17 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
+		tipc_publ_notify(net, publ_list, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, sk.node, n->capabilities);
+		tipc_named_node_up(net, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, sk.node, bearer_id);
+		tipc_mon_peer_up(net, node, bearer_id);
 		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, sk.node, bearer_id);
+		tipc_mon_peer_down(net, node, bearer_id);
 		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
 	}
 }
-- 
2.31.1

