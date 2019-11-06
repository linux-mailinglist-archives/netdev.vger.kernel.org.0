Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC15F0EE1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 07:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbfKFG0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 01:26:30 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32979 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725995AbfKFG03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 01:26:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 6103C4AAC6;
        Wed,  6 Nov 2019 17:26:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received:received:received;
         s=mail_dkim; t=1573021584; bh=jI0AGYhJquj9/cmKZ5Y8DmCDwYuP1OnHc
        itq87VvODs=; b=oJefkvlsE2sD17FgNfZUfBTvirzoP8jwKvYY7TZCl5pLIqcV1
        Qlg3M6oG+T8HfQm8LwY/7gX779ffCTcJwSCdCWu/Gq8TZbMLbq+QMb+NciFRhKMc
        3eRGxLpZxbQW7r6a60rouztyPBYzXMYbzq4BECuxYav4h1T+GJjgkMdoPE=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Q-LKzfX5ulxZ; Wed,  6 Nov 2019 17:26:24 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 3A0D64AAC5;
        Wed,  6 Nov 2019 17:26:24 +1100 (AEDT)
Received: from dhost.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 473114AAC4;
        Wed,  6 Nov 2019 17:26:23 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [net-next 1/2] tipc: update cluster capabilities if node deleted
Date:   Wed,  6 Nov 2019 13:26:09 +0700
Message-Id: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two improvements when re-calculate cluster capabilities:

- When deleting a specific down node, need to re-calculate.
- In tipc_node_cleanup(), do not need to re-calculate if node
is still existing in cluster.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/node.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 742c04756d72..a20fabd09e7e 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -665,6 +665,11 @@ static bool tipc_node_cleanup(struct tipc_node *peer=
)
 	}
 	tipc_node_write_unlock(peer);
=20
+	if (!deleted) {
+		spin_unlock_bh(&tn->node_list_lock);
+		return deleted;
+	}
+
 	/* Calculate cluster capabilities */
 	tn->capabilities =3D TIPC_NODE_CAPABILITIES;
 	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
@@ -2041,7 +2046,7 @@ int tipc_nl_peer_rm(struct sk_buff *skb, struct gen=
l_info *info)
 	struct net *net =3D sock_net(skb->sk);
 	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
 	struct nlattr *attrs[TIPC_NLA_NET_MAX + 1];
-	struct tipc_node *peer;
+	struct tipc_node *peer, *temp_node;
 	u32 addr;
 	int err;
=20
@@ -2082,6 +2087,11 @@ int tipc_nl_peer_rm(struct sk_buff *skb, struct ge=
nl_info *info)
 	tipc_node_write_unlock(peer);
 	tipc_node_delete(peer);
=20
+	/* Calculate cluster capabilities */
+	tn->capabilities =3D TIPC_NODE_CAPABILITIES;
+	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
+		tn->capabilities &=3D temp_node->capabilities;
+	}
 	err =3D 0;
 err_out:
 	tipc_node_put(peer);
--=20
2.20.1

