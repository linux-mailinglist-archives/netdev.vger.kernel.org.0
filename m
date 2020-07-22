Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9B2297A1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgGVLpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgGVLpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:45:11 -0400
X-Greylist: delayed 408 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Jul 2020 04:45:11 PDT
Received: from vinduvvm.duvert.net (vinduvvm.duvert.net [IPv6:2a03:7220:8081:4600::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50C69C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:45:11 -0700 (PDT)
Received: from home.duvert.net (152.60.68.91.rev.sfr.net [91.68.60.152])
        by vinduvvm.duvert.net (Postfix) with ESMTPSA id EC50E76CDE
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:38:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=duvert.net;
        s=vinduvmail; t=1595417900;
        bh=YjLjrjqXm+3LF4qfaMTlT2v/xMZrLH+jzUJ4c13ZkYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJxUxS9m1iTt/BDOotKgMZVhBr2wjvD6Y11ubLuN6/ZDIA9ea2kHirtJQMayskdWL
         tKjWfeFrgJmkPsvSckSS6sFRnmeInaHNp9BJhwxoEEOuSZuDFwtFVaEfF3sqnhlsYV
         uPK32gk46i03Ib8A8RHX+cmFGT3DEwfSzDQ96yEY=
Received: from vincent (uid 1000)
        (envelope-from vincent@home.duvert.net)
        id 91e23
        by home.duvert.net (DragonFly Mail Agent v0.11);
        Wed, 22 Jul 2020 13:38:19 +0200
From:   Vincent Duvert <vincent.ldev@duvert.net>
To:     netdev@vger.kernel.org
Cc:     Vincent Duvert <vincent.ldev@duvert.net>
Subject: [PATCH 2/2] appletalk: Improve handling of broadcast packets
Date:   Wed, 22 Jul 2020 13:37:52 +0200
Message-Id: <20200722113752.1218-2-vincent.ldev@duvert.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200722113752.1218-1-vincent.ldev@duvert.net>
References: <20200722113752.1218-1-vincent.ldev@duvert.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a broadcast AppleTalk packet is received, prefer queuing it on the
socket whose address matches the address of the interface that received
the packet (and is listening on the correct port). Userspace
applications that handle such packets will usually send a response on
the same socket that received the packet; this fix allows the response
to be sent on the correct interface.

If a socket matching the interface's address is not found, an arbitrary
socket listening on the correct port will be used, if any. This matches
the implementation's previous behavior.

Fixes atalkd's responses to network information requests when multiple
network interfaces are configured to use AppleTalk.

Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>
---
 net/appletalk/ddp.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 15787e8c0629..9d19cd03076f 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -89,6 +89,7 @@ static struct sock *atalk_search_socket(struct sockaddr_at *to,
 					struct atalk_iface *atif)
 {
 	struct sock *s;
+	struct sock *def_socket = NULL;
 
 	read_lock_bh(&atalk_sockets_lock);
 	sk_for_each(s, &atalk_sockets) {
@@ -98,8 +99,20 @@ static struct sock *atalk_search_socket(struct sockaddr_at *to,
 			continue;
 
 		if (to->sat_addr.s_net == ATADDR_ANYNET &&
-		    to->sat_addr.s_node == ATADDR_BCAST)
-			goto found;
+		    to->sat_addr.s_node == ATADDR_BCAST) {
+			if (atif->address.s_node == at->src_node &&
+			    atif->address.s_net == at->src_net) {
+				/* This socket's address matches the address of the interface
+				 * that received the packet -- use it
+				 */
+				goto found;
+			}
+
+			/* Continue searching for a socket matching the interface address,
+			 * but use this socket by default if no other one is found
+			 */
+			def_socket = s;
+		}
 
 		if (to->sat_addr.s_net == at->src_net &&
 		    (to->sat_addr.s_node == at->src_node ||
@@ -116,7 +129,7 @@ static struct sock *atalk_search_socket(struct sockaddr_at *to,
 			goto found;
 		}
 	}
-	s = NULL;
+	s = def_socket;
 found:
 	read_unlock_bh(&atalk_sockets_lock);
 	return s;
-- 
2.20.1

