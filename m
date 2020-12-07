Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB9E2D0BC2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgLGIbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:31:48 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:45302 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgLGIbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 03:31:43 -0500
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id A3C3F3B6CD8;
        Mon,  7 Dec 2020 08:15:51 +0000 (UTC)
X-Originating-IP: 84.44.14.226
Received: from nexussix.ar.arcelik (unknown [84.44.14.226])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id AEF254001C;
        Mon,  7 Dec 2020 08:14:41 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>
Subject: [PATCH] net: tipc: prevent possible null deref of link
Date:   Mon,  7 Dec 2020 11:14:24 +0300
Message-Id: <20201207081423.67313-1-cengiz@kernel.wtf>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`tipc_node_apply_property` does a null check on a `tipc_link_entry`
pointer but also accesses the same pointer out of the null check block.

This triggers a warning on Coverity Static Analyzer because we're
implying that `e->link` can BE null.

Move "Update MTU for node link entry" line into if block to make sure
that we're not in a state that `e->link` is null.

Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
---
 net/tipc/node.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index c95d037fde51..83978d5dae59 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2181,9 +2181,11 @@ void tipc_node_apply_property(struct net *net, struct tipc_bearer *b,
 							&xmitq);
 			else if (prop == TIPC_NLA_PROP_MTU)
 				tipc_link_set_mtu(e->link, b->mtu);
+
+			/* Update MTU for node link entry */
+			e->mtu = tipc_link_mss(e->link);
 		}
-		/* Update MTU for node link entry */
-		e->mtu = tipc_link_mss(e->link);
+
 		tipc_node_write_unlock(n);
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &e->maddr, NULL);
 	}
-- 
2.29.2

