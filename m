Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148534CEE07
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiCFV67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiCFV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5281C118
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9cdLUSBzKzIxbqvnVCPgL2/NiTojReRgkN+vme6rGk=;
        b=2q4dwW+ByIaFnJEu1CqO0348oukbvEYpTeM9vevhZvlTiXTYM+bpszdHx7VSTGxZtSLYd9
        Z3+YZL9XzDBjXb3hVTpp3m8Q7ZZfCKW0TJyVVtkWYlVgMANYUnbT0Io7efJnrZsALTw/l0
        sljouQH90t3OuqnwFZVqxFc8NLm4ILY6gUwgGvp9oF3GBRQ7f1Z/59lmGnT1mU9w44Ml8P
        xxz16z8svQTfVLKz922EEwqOq8DR6NMuU0ACvAxE4knD8osM5r7QGaNUlvWRysR6J0zUY/
        MkSxI1ti2eTD1xmRkekdlc3VhdwLr4NxLh2gI8Xxtl4EFAP9LHX5bk2XQW0MTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9cdLUSBzKzIxbqvnVCPgL2/NiTojReRgkN+vme6rGk=;
        b=jHytMEK4aEWdCGBVLFns/d6p0Dvd4Tr4rOLJg/VlqjeKYmQTFfIzjyqU6bondxKq+ave9Z
        QublXVTjWscGLrCQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net-next 04/10] tipc: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:47 +0100
Message-Id: <20220306215753.3156276-5-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/tipc/bearer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 473a790f58943..9dfe2bdf14828 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -768,7 +768,7 @@ void tipc_clone_to_loopback(struct net *net, struct sk_=
buff_head *pkts)
 		skb->pkt_type =3D PACKET_HOST;
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 		skb->protocol =3D eth_type_trans(skb, dev);
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 }
=20
--=20
2.35.1

