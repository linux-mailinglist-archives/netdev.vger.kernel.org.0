Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521074B3EEA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiBNBjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:39:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:39:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 817F950B30
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 17:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644802756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Le9GiJLPWtcbLoJEMeK27Xo5ZDBBLnzPvmbdj9ferQ4=;
        b=VOuRKnMRDPOXwRYzrbCpQHVd9BnoYsEiotQ36Dp9uGXHuCpPH32ZIJzOelAaM/mltfxQKk
        4TtJWa1ydRp0YeQRvupQiE7rUGSb6yDlHGdRihhqP9/RWh37mVq87o8r6EoTlzkHBfNT/W
        sR+xOCDAznHvL3qZUwFbKMAPXeIUzIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-vaBjDP-tMo-ZGgeKYdEX7Q-1; Sun, 13 Feb 2022 20:39:11 -0500
X-MC-Unique: vaBjDP-tMo-ZGgeKYdEX7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DC6D814243;
        Mon, 14 Feb 2022 01:39:09 +0000 (UTC)
Received: from fenrir.redhat.com (unknown [10.22.12.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62F385F4F5;
        Mon, 14 Feb 2022 01:38:53 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net] tipc: fix wrong publisher node address in link publications
Date:   Sun, 13 Feb 2022 20:38:52 -0500
Message-Id: <20220214013852.2803940-1-jmaloy@redhat.com>
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

When a link comes up we add its presence to the name table to make it
possible for users to subscribe for link up/down events. However, after
a previous call signature change the binding is wrongly published with
the peer node as publishing node, instead of the own node as it should
be. This has the effect that the command 'tipc name table show' will
list the link binding (service type 2) with node scope and a peer node
as originator, something that obviously is impossible.

We correct this bug here.

Fixes: 50a3499ab853 ("tipc: simplify signature of tipc_namtbl_publish()")

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 9947b7dfe1d2..fd95df338da7 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -413,7 +413,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
 		   TIPC_LINK_STATE, n->addr, n->addr);
 	sk.ref = n->link_id;
-	sk.node = n->addr;
+	sk.node = tipc_own_addr(net);
 	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 
-- 
2.31.1

