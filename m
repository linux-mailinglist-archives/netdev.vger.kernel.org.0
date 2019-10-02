Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDF8C912D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfJBSx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:53:57 -0400
Received: from correo.us.es ([193.147.175.20]:52780 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbfJBSx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:53:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE12C15AEA3
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 20:53:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF0EEDA4D0
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 20:53:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4957DA840; Wed,  2 Oct 2019 20:53:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D98F4DA72F;
        Wed,  2 Oct 2019 20:53:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Oct 2019 20:53:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B081F42EE38E;
        Wed,  2 Oct 2019 20:53:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nft_connlimit: disable bh on garbage collection
Date:   Wed,  2 Oct 2019 20:53:45 +0200
Message-Id: <20191002185345.3137-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191002185345.3137-1-pablo@netfilter.org>
References: <20191002185345.3137-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BH must be disabled when invoking nf_conncount_gc_list() to perform
garbage collection, otherwise deadlock might happen.

  nf_conncount_add+0x1f/0x50 [nf_conncount]
  nft_connlimit_eval+0x4c/0xe0 [nft_connlimit]
  nft_dynset_eval+0xb5/0x100 [nf_tables]
  nft_do_chain+0xea/0x420 [nf_tables]
  ? sch_direct_xmit+0x111/0x360
  ? noqueue_init+0x10/0x10
  ? __qdisc_run+0x84/0x510
  ? tcp_packet+0x655/0x1610 [nf_conntrack]
  ? ip_finish_output2+0x1a7/0x430
  ? tcp_error+0x130/0x150 [nf_conntrack]
  ? nf_conntrack_in+0x1fc/0x4c0 [nf_conntrack]
  nft_do_chain_ipv4+0x66/0x80 [nf_tables]
  nf_hook_slow+0x44/0xc0
  ip_rcv+0xb5/0xd0
  ? ip_rcv_finish_core.isra.19+0x360/0x360
  __netif_receive_skb_one_core+0x52/0x70
  netif_receive_skb_internal+0x34/0xe0
  napi_gro_receive+0xba/0xe0
  e1000_clean_rx_irq+0x1e9/0x420 [e1000e]
  e1000e_poll+0xbe/0x290 [e1000e]
  net_rx_action+0x149/0x3b0
  __do_softirq+0xde/0x2d8
  irq_exit+0xba/0xc0
  do_IRQ+0x85/0xd0
  common_interrupt+0xf/0xf
  </IRQ>
  RIP: 0010:nf_conncount_gc_list+0x3b/0x130 [nf_conncount]

Fixes: 2f971a8f4255 ("netfilter: nf_conncount: move all list iterations under spinlock")
Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_connlimit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index af1497ab9464..69d6173f91e2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -218,8 +218,13 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
+	bool ret;
 
-	return nf_conncount_gc_list(net, &priv->list);
+	local_bh_disable();
+	ret = nf_conncount_gc_list(net, &priv->list);
+	local_bh_enable();
+
+	return ret;
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.11.0

