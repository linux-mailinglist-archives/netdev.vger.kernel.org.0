Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF68A1AF4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfH2NIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18183 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfH2NIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:08:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD4403CA25;
        Thu, 29 Aug 2019 13:08:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6F5C5D772;
        Thu, 29 Aug 2019 13:08:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/7] rxrpc: Add a private skb flag to indicate
 transmission-phase skbs
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 29 Aug 2019 14:08:08 +0100
Message-ID: <156708408801.26102.11592449726244941243.stgit@warthog.procyon.org.uk>
In-Reply-To: <156708405310.26102.7954021163316252673.stgit@warthog.procyon.org.uk>
References: <156708405310.26102.7954021163316252673.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 29 Aug 2019 13:08:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a flag in the private data on an skbuff to indicate that this is a
transmission-phase buffer rather than a receive-phase buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/sendmsg.c     |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 20d7907a5bc6..63d3a91ce5e9 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -188,6 +188,7 @@ struct rxrpc_skb_priv {
 	u8		nr_subpackets;		/* Number of subpackets */
 	u8		rx_flags;		/* Received packet flags */
 #define RXRPC_SKB_INCL_LAST	0x01		/* - Includes last packet */
+#define RXRPC_SKB_TX_BUFFER	0x02		/* - Is transmit buffer */
 	union {
 		int		remain;		/* amount of space remaining for next write */
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index bae14438f869..472dc3b7d91f 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -336,6 +336,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			if (!skb)
 				goto maybe_error;
 
+			sp = rxrpc_skb(skb);
+			sp->rx_flags |= RXRPC_SKB_TX_BUFFER;
 			rxrpc_new_skb(skb, rxrpc_skb_tx_new);
 
 			_debug("ALLOC SEND %p", skb);
@@ -346,7 +348,6 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			skb_reserve(skb, call->conn->security_size);
 			skb->len += call->conn->security_size;
 
-			sp = rxrpc_skb(skb);
 			sp->remain = chunk;
 			if (sp->remain > skb_tailroom(skb))
 				sp->remain = skb_tailroom(skb);

