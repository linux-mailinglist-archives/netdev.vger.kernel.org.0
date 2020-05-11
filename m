Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B497F1CD40C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgEKIeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgEKIeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 04:34:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F788C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 01:34:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jY3tg-0003wT-GR; Mon, 11 May 2020 10:34:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH ipsec-next] xfrm: fix unused variable warning if CONFIG_NETFILTER=n
Date:   Mon, 11 May 2020 10:33:42 +0200
Message-Id: <20200511083346.24627-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511130325.44e65463@canb.auug.org.au>
References: <20200511130325.44e65463@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After recent change 'x' is only used when CONFIG_NETFILTER is set:

net/ipv4/xfrm4_output.c: In function '__xfrm4_output':
net/ipv4/xfrm4_output.c:19:21: warning: unused variable 'x' [-Wunused-variable]
   19 |  struct xfrm_state *x = skb_dst(skb)->xfrm;

Expand the CONFIG_NETFILTER scope to avoid this.

Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/xfrm4_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 502eb189d852..3cff51ba72bb 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -16,9 +16,9 @@
 
 static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+#ifdef CONFIG_NETFILTER
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 
-#ifdef CONFIG_NETFILTER
 	if (!x) {
 		IPCB(skb)->flags |= IPSKB_REROUTED;
 		return dst_output(net, sk, skb);
-- 
2.26.2

