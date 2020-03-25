Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B38B192425
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgCYJdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:33:09 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:38902 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgCYJdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:33:09 -0400
Received: from ramsan ([84.195.182.253])
        by albert.telenet-ops.be with bizsmtp
        id JZZ12200b5USYZQ06ZZ1Dw; Wed, 25 Mar 2020 10:33:07 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jH2PF-0002XW-Kp; Wed, 25 Mar 2020 10:33:01 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jH2PF-0001Qt-IP; Wed, 25 Mar 2020 10:33:01 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] netfilter: nft_fwd_netdev: Fix CONFIG_NET_CLS_ACT=n build
Date:   Wed, 25 Mar 2020 10:33:00 +0100
Message-Id: <20200325093300.5455-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_CLS_ACT=n:

    net/netfilter/nft_fwd_netdev.c: In function ‘nft_fwd_netdev_eval’:
    net/netfilter/nft_fwd_netdev.c:32:10: error: ‘struct sk_buff’ has no member named ‘tc_redirected’
      pkt->skb->tc_redirected = 1;
	      ^~
    net/netfilter/nft_fwd_netdev.c:33:10: error: ‘struct sk_buff’ has no member named ‘tc_from_ingress’
      pkt->skb->tc_from_ingress = 1;
	      ^~

Fix this by protecting this code hunk with the appropriate #ifdef.

Reported-by: noreply@ellerman.id.au
Fixes: bcfabee1afd99484 ("netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/netfilter/nft_fwd_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 74f050ba6badc9dc..ebcaf5c325712f30 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -28,9 +28,11 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
+#ifdef CONFIG_NET_CLS_ACT
 	/* These are used by ifb only. */
 	pkt->skb->tc_redirected = 1;
 	pkt->skb->tc_from_ingress = 1;
+#endif
 
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
-- 
2.17.1

