Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BEA9266
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbfIDThF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:37:05 -0400
Received: from correo.us.es ([193.147.175.20]:37924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbfIDThC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 15:37:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09FB9303D08
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F02BED1DBB
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5D08D2B1D; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A52FB7FF9;
        Wed,  4 Sep 2019 21:36:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67E2E4265A5A;
        Wed,  4 Sep 2019 21:36:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nft_socket: fix erroneous socket assignment
Date:   Wed,  4 Sep 2019 21:36:43 +0200
Message-Id: <20190904193646.23830-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

The socket assignment is wrong, see skb_orphan():
When skb->destructor callback is not set, but skb->sk is set, this hits BUG().

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1651813
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d7f3776dfd71..637ce3e8c575 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -47,9 +47,6 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	/* So that subsequent socket matching not to require other lookups. */
-	skb->sk = sk;
-
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
 		nft_reg_store8(dest, inet_sk_transparent(sk));
@@ -66,6 +63,9 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
 	}
+
+	if (sk != skb->sk)
+		sock_gen_put(sk);
 }
 
 static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
-- 
2.11.0

