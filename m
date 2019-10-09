Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6DBD166D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbfJIRaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbfJIRYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:10 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD11821D6C;
        Wed,  9 Oct 2019 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641849;
        bh=WxL+isxSLqVyP/vPvSWCFfVBslLsA4hnCVMimY/E5uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuPvJtzWPaNkQYPMmFawFJJIsZe5ktwdYsAiNueWKyipNKr5iwq+6aETsBjxPOjfB
         6yIe0wJbHQvhYIWCE8mYtaLWmuTsXEGvBRBfNHkMButOFXh8PeAcdabDuQLQjJ3+Z3
         lAb0wxRHIqetiZoNORdsL6g+/JIZrMAi7h6N23wc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/26] netfilter: nft_connlimit: disable bh on garbage collection
Date:   Wed,  9 Oct 2019 13:05:50 -0400
Message-Id: <20191009170558.32517-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 34a4c95abd25ab41fb390b985a08a651b1fa0b0f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_connlimit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index af1497ab94642..69d6173f91e2b 100644
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
2.20.1

