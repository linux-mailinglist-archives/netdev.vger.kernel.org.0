Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE94942D90B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhJNMNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhJNMNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6C0C061570;
        Thu, 14 Oct 2021 05:11:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazaC-0002nA-WE; Thu, 14 Oct 2021 14:11:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 8/9] netfilter: ingress: switch to invocation via bpf
Date:   Thu, 14 Oct 2021 14:10:45 +0200
Message-Id: <20211014121046.29329-10-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ingress.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index c95f84a5badc..20e0b1c2c706 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -19,6 +19,9 @@ static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
 static inline int nf_hook_ingress(struct sk_buff *skb)
 {
 	struct nf_hook_entries *e = rcu_dereference(skb->dev->nf_hooks_ingress);
+#if IS_ENABLED(CONFIG_NF_HOOK_BPF)
+	const struct bpf_prog *prog;
+#endif
 	struct nf_hook_state state;
 	int ret;
 
@@ -31,7 +34,19 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
 			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
 			   dev_net(skb->dev), NULL);
+
+#if IS_ENABLED(CONFIG_NF_HOOK_BPF)
+	prog = READ_ONCE(e->hook_prog);
+
+	state.priv = (void *)e;
+	state.skb = skb;
+
+	migrate_disable();
+	ret = bpf_prog_run_nf(prog, &state);
+	migrate_enable();
+#else
 	ret = nf_hook_slow(skb, &state, e);
+#endif
 	if (ret == 0)
 		return -1;
 
-- 
2.32.0

