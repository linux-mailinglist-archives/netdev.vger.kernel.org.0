Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81473AADCB
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhFQHk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:40:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47024 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhFQHk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:40:27 -0400
Date:   Thu, 17 Jun 2021 09:38:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623915499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=a+PnN4eBiMqzyIufqDX1LM9MjoeGcSNNcRg02kVtV+c=;
        b=JKuEckdjbbE4HbyCuncTi30WIqr2TCEDTT/G8DVs03ZvhqWahTrE9FGkRww246/chOthwM
        rTh4jKv8CxUv7VV+OTPyhprXiPhZd7Ne3ncKAO+3imaAKxAPcNkBfOarwAfDgYPVPZgpmU
        51vr5iX9fwdcdc/zoIknoYAYfeP9u5jPadU35Ja8OvsEZ6BVnOnrRIrz8R+3S/BG7WxG0l
        5Md73ht2SJV7FMnUDfFk3nVSyh2vfJj+NFoaKRItcyyWrmS10aKdHYQGQWOrxKRynDzX8Q
        SzwdOxP6Kk9MAy++GOmhV7mV8u3EkSzz12AmRuzr3HOdFMPEDxZIezwZxbE5cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623915499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=a+PnN4eBiMqzyIufqDX1LM9MjoeGcSNNcRg02kVtV+c=;
        b=pdd8KDN5NL6nC2B+kIfW45MtYUqIASqbHUC/5El8zKkZidGYE4MBZn9evK5Kuf05bpNiQR
        c/rYyhmwRuTznjCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH net-next] net/netif_receive_skb_core: Use migrate_disable()
Message-ID: <20210617073817.vioupupx2gohyrxr@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The preempt disable around do_xdp_generic() has been introduced in
commit
   bbbe211c295ff ("net: rcu lock and preempt disable missing around generic xdp")

For BPF it is enough to use migrate_disable() and the code was updated
as it can be seen in commit
   3c58482a382ba ("bpf: Provide bpf_prog_run_pin_on_cpu() helper")

This is a leftover which was not converted.

Use migrate_disable() before invoking do_xdp_generic().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 50531a2d0b20d..e597371281638 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5277,9 +5277,9 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	if (static_branch_unlikely(&generic_xdp_needed_key)) {
 		int ret2;
 
-		preempt_disable();
+		migrate_disable();
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		preempt_enable();
+		migrate_enable();
 
 		if (ret2 != XDP_PASS) {
 			ret = NET_RX_DROP;
-- 
2.32.0

