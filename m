Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CCB12AD88
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLZQkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:40:15 -0500
Received: from correo.us.es ([193.147.175.20]:54798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfLZQkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 11:40:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F2F4E34EA
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FD74DA711
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 856C2DA70F; Thu, 26 Dec 2019 17:40:11 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DBA7DA712;
        Thu, 26 Dec 2019 17:40:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Dec 2019 17:40:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3390F4251481;
        Thu, 26 Dec 2019 17:40:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/4] netfilter: nft_tproxy: Fix port selector on Big Endian
Date:   Thu, 26 Dec 2019 17:39:56 +0100
Message-Id: <20191226163956.672174-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191226163956.672174-1-pablo@netfilter.org>
References: <20191226163956.672174-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

On Big Endian architectures, u16 port value was extracted from the wrong
parts of u32 sreg_port, just like commit 10596608c4d62 ("netfilter:
nf_tables: fix mismatch in big-endian system") describes.

Fixes: 4ed8eb6570a49 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Florian Westphal <fw@strlen.de>
Acked-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tproxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f92a82c73880..95980154ef02 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -50,7 +50,7 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -117,7 +117,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.11.0

