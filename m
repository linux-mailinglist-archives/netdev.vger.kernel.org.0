Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F04F3E46
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfKHDCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:02:54 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33338 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726219AbfKHDCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:02:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 304B54A9AE;
        Fri,  8 Nov 2019 14:02:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received:received:received;
         s=mail_dkim; t=1573182169; bh=Ljy6J+7VJgFq3gtlOr17+gQvJEXANk+H/
        hS2OJAAudY=; b=DmtuRy1xs2CgNNquWXjdIp2Pk/brifkR9zSjLdkbqUq6AYfuX
        O0UPyy3F1tAnMi7wIC4OKo9+Xkkr2O9RX6FSG6dtvT/WUGuY9B3HpHZqGbCvT4u1
        eRmZrm+pEEZulYyZNJ/7+oy5WAMuOjVBYG06LISYjYdei+XIYIzQFx80Lg=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8uyePDZKCrd4; Fri,  8 Nov 2019 14:02:49 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 15D784AAFB;
        Fri,  8 Nov 2019 14:02:48 +1100 (AEDT)
Received: from dhost.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 270584A9AE;
        Fri,  8 Nov 2019 14:02:48 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [net-next] tipc: eliminate checking netns if node established
Date:   Fri,  8 Nov 2019 10:02:37 +0700
Message-Id: <20191108030237.6619-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we scan over all network namespaces at each received
discovery message in order to check if the sending peer might be
present in a host local namespaces.

This is unnecessary since we can assume that a peer will not change its
location during an established session.

We now improve the condition for this testing so that we don't perform
any redundant scans.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/node.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 1f1584518221..b66d2f67b1dd 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -472,10 +472,6 @@ static struct tipc_node *tipc_node_create(struct net=
 *net, u32 addr,
 				 tipc_bc_sndlink(net),
 				 &n->bc_entry.link)) {
 		pr_warn("Broadcast rcv link creation failed, no memory\n");
-		if (n->peer_net) {
-			n->peer_net =3D NULL;
-			n->peer_hash_mix =3D 0;
-		}
 		kfree(n);
 		n =3D NULL;
 		goto exit;
@@ -1073,6 +1069,9 @@ void tipc_node_check_dest(struct net *net, u32 addr=
,
 	if (sign_match && addr_match && link_up) {
 		/* All is fine. Do nothing. */
 		reset =3D false;
+		/* Peer node is not a container/local namespace */
+		if (!n->peer_hash_mix)
+			n->peer_hash_mix =3D hash_mixes;
 	} else if (sign_match && addr_match && !link_up) {
 		/* Respond. The link will come up in due time */
 		*respond =3D true;
@@ -1398,11 +1397,8 @@ static void node_lost_contact(struct tipc_node *n,
=20
 	/* Notify publications from this node */
 	n->action_flags |=3D TIPC_NOTIFY_NODE_DOWN;
-
-	if (n->peer_net) {
-		n->peer_net =3D NULL;
-		n->peer_hash_mix =3D 0;
-	}
+	n->peer_net =3D NULL;
+	n->peer_hash_mix =3D 0;
 	/* Notify sockets connected to node */
 	list_for_each_entry_safe(conn, safe, conns, list) {
 		skb =3D tipc_msg_create(TIPC_CRITICAL_IMPORTANCE, TIPC_CONN_MSG,
--=20
2.20.1

