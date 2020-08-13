Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4DB243B7E
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHMOY4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 10:24:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48040 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbgHMOY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:24:56 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-V6j9o2HyMk2_QFsBh3-K-Q-1; Thu, 13 Aug 2020 10:24:49 -0400
X-MC-Unique: V6j9o2HyMk2_QFsBh3-K-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 344F0CF987;
        Thu, 13 Aug 2020 14:24:48 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB2A019C78;
        Thu, 13 Aug 2020 14:24:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Xiumei Mu <xmu@redhat.com>
Subject: [PATCH ipsec] espintcp: restore IP CB before handing the packet to xfrm
Date:   Thu, 13 Aug 2020 16:24:04 +0200
Message-Id: <b3c2d120af02d34c0ab6e67b897be502c5106dca.1597328612.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiumei reported a bug with espintcp over IPv6 in transport mode,
because xfrm6_transport_finish expects to find IP6CB data (struct
inet6_skb_cb). Currently, espintcp zeroes the CB, but the relevant
part is actually preserved by previous layers (first set up by tcp,
then strparser only zeroes a small part of tcp_skb_tb), so we can just
relocate it to the start of skb->cb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/espintcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 827ccdf2db57..1f08ebf7d80c 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -29,8 +29,12 @@ static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 
 static void handle_esp(struct sk_buff *skb, struct sock *sk)
 {
+	struct tcp_skb_cb *tcp_cb = (struct tcp_skb_cb *)skb->cb;
+
 	skb_reset_transport_header(skb);
-	memset(skb->cb, 0, sizeof(skb->cb));
+
+	/* restore IP CB, we need at least IP6CB->nhoff */
+	memmove(skb->cb, &tcp_cb->header, sizeof(tcp_cb->header));
 
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
-- 
2.27.0

