Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A58DA5416
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfIBKeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729806AbfIBKeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:34:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3FFCC049E23;
        Mon,  2 Sep 2019 10:34:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D7D160C05;
        Mon,  2 Sep 2019 10:34:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix misplaced traceline
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 02 Sep 2019 11:34:08 +0100
Message-ID: <156742044878.3320.3639294965607016931.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 02 Sep 2019 10:34:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a misplaced traceline in rxrpc_input_packet() which is looking at a
packet that just got released rather than the replacement packet.

Fix this by moving the traceline after the assignment that moves the new
packet pointer to the actual packet pointer.

Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Reported-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index d122c53c8697..157be1ff8697 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1262,8 +1262,8 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 
 			if (nskb != skb) {
 				rxrpc_eaten_skb(skb, rxrpc_skb_received);
-				rxrpc_new_skb(skb, rxrpc_skb_unshared);
 				skb = nskb;
+				rxrpc_new_skb(skb, rxrpc_skb_unshared);
 				sp = rxrpc_skb(skb);
 			}
 		}

