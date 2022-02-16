Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB04B7C4D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbiBPBKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:10:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244888AbiBPBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:10:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE7B9104A6B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 17:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644973725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YoeZNvrACm0PXcsH81qZ8wGmrhLOetEwJUJLrUb34xw=;
        b=OZLuB+M9T05NT8rjN5OwaT8YpTYTR+X8xyWrXu9OLtrdJYVkfqPp0GO0Te3GiwiLK+YYQp
        5ag5mYOqsDhVcphBUXcm/RXPP0CVdEF+9t8Oq4IAFUc4HJbXXOT8zxxyc2KadH1MnGSTYq
        l8oSL1RUwhoYEZmKoZn7yazyG5wh9jU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-v9z_XEzpMby-eaH2cDrm2A-1; Tue, 15 Feb 2022 20:08:43 -0500
X-MC-Unique: v9z_XEzpMby-eaH2cDrm2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DACB1091DA0;
        Wed, 16 Feb 2022 01:08:42 +0000 (UTC)
Received: from fenrir.redhat.com (unknown [10.22.12.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D2E55D6B1;
        Wed, 16 Feb 2022 01:08:36 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net] tipc: fix wrong notification node addresses
Date:   Tue, 15 Feb 2022 20:08:35 -0500
Message-Id: <20220216010835.3381431-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 net/tipc/node.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index fd95df338da7..f18303ab25e8 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -423,17 +423,17 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
+		tipc_publ_notify(net, publ_list, n->addr, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, sk.node, n->capabilities);
+		tipc_named_node_up(net, n->addr, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, sk.node, bearer_id);
+		tipc_mon_peer_up(net, n->addr, bearer_id);
 		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, sk.node, bearer_id);
+		tipc_mon_peer_down(net, n->addr, bearer_id);
 		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
 	}
 }
-- 
2.31.1

