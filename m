Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA55911821C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLJIVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:21:22 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33049 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727039AbfLJIVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:21:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 7845E4BD3D;
        Tue, 10 Dec 2019 19:21:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1575966078; bh=9mFcoo7SmIjQayaHRDfSrpplq5OFpR/XpgBif3JGWrM=; b=h
        DdhasgU63OOuOFhExYtRBoIPtcT4OCczs9h+11YBa5wIZKW3DYAufA1Xa9PhsVIT
        O1d4YqpRkAf4X550Gwp5AdBkQlMnPAVzIqYtjPp5FvY38NqjtajVu2uej6qB311t
        HQ5mDVNqkqqdxpGI770bAtaU3vXQuHFyDs6RmxL0Qw=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Bwtby4biTTtB; Tue, 10 Dec 2019 19:21:18 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 550F64BD38;
        Tue, 10 Dec 2019 19:21:18 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 46F604BD3B;
        Tue, 10 Dec 2019 19:21:17 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 4/4] tipc: fix use-after-free in tipc_disc_rcv()
Date:   Tue, 10 Dec 2019 15:21:05 +0700
Message-Id: <20191210082105.23905-5-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
References: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function 'tipc_disc_rcv()', the 'msg_peer_net_hash()' is called
to read the header data field but after the message skb has been freed,
that might result in a garbage value...

This commit fixes it by defining a new local variable to store the data
first, just like the other header fields' handling.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/discover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index b043e8c6397a..bfe43da127c0 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -194,6 +194,7 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_msg *hdr = buf_msg(skb);
+	u32 pnet_hash = msg_peer_net_hash(hdr);
 	u16 caps = msg_node_capabilities(hdr);
 	bool legacy = tn->legacy_addr_format;
 	u32 sugg = msg_sugg_node_addr(hdr);
@@ -242,9 +243,8 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 		return;
 	if (!tipc_in_scope(legacy, b->domain, src))
 		return;
-	tipc_node_check_dest(net, src, peer_id, b, caps, signature,
-			     msg_peer_net_hash(hdr), &maddr, &respond,
-			     &dupl_addr);
+	tipc_node_check_dest(net, src, peer_id, b, caps, signature, pnet_hash,
+			     &maddr, &respond, &dupl_addr);
 	if (dupl_addr)
 		disc_dupl_alert(b, src, &maddr);
 	if (!respond)
-- 
2.13.7

