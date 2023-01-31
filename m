Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21CF682DEF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjAaNcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjAaNcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:32:04 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F8504860E;
        Tue, 31 Jan 2023 05:32:03 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/2] netfilter: br_netfilter: disable sabotage_in hook after first suppression
Date:   Tue, 31 Jan 2023 14:31:57 +0100
Message-Id: <20230131133158.4052-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230131133158.4052-1-pablo@netfilter.org>
References: <20230131133158.4052-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When using a xfrm interface in a bridged setup (the outgoing device is
bridged), the incoming packets in the xfrm interface are only tracked
in the outgoing direction.

$ brctl show
bridge name     interfaces
br_eth1         eth1

$ conntrack -L
tcp 115 SYN_SENT src=192... dst=192... [UNREPLIED] ...

If br_netfilter is enabled, the first (encrypted) packet is received onR
eth1, conntrack hooks are called from br_netfilter emulation which
allocates nf_bridge info for this skb.

If the packet is for local machine, skb gets passed up the ip stack.
The skb passes through ip prerouting a second time. br_netfilter
ip_sabotage_in supresses the re-invocation of the hooks.

After this, skb gets decrypted in xfrm layer and appears in
network stack a second time (after decryption).

Then, ip_sabotage_in is called again and suppresses netfilter
hook invocation, even though the bridge layer never called them
for the plaintext incarnation of the packet.

Free the bridge info after the first suppression to avoid this.

I was unable to figure out where the regression comes from, as far as i
can see br_netfilter always had this problem; i did not expect that skb
is looped again with different headers.

Fixes: c4b0e771f906 ("netfilter: avoid using skb->nf_bridge directly")
Reported-and-tested-by: Wolfgang Nothdurft <wolfgang@linogate.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..9554abcfd5b4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -871,6 +871,7 @@ static unsigned int ip_sabotage_in(void *priv,
 	if (nf_bridge && !nf_bridge->in_prerouting &&
 	    !netif_is_l3_master(skb->dev) &&
 	    !netif_is_l3_slave(skb->dev)) {
+		nf_bridge_info_free(skb);
 		state->okfn(state->net, state->sk, skb);
 		return NF_STOLEN;
 	}
-- 
2.30.2

