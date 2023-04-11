Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7DA6DD454
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjDKHfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjDKHfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:35:40 -0400
X-Greylist: delayed 617 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 00:35:38 PDT
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25489198C
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:35:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 32676220002;
        Tue, 11 Apr 2023 09:25:17 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hsj5Lg_kJoMO; Tue, 11 Apr 2023 09:25:15 +0200 (CEST)
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.codelabs.ch (Postfix) with ESMTPSA id A4202220001;
        Tue, 11 Apr 2023 09:25:15 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH ipsec] xfrm: Preserve xfrm interface secpath for packets forwarded
Date:   Tue, 11 Apr 2023 09:25:02 +0200
Message-Id: <20230411072502.21315-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit referenced below clears the secpath on packets received via
xfrm interfaces to support nested IPsec tunnels. This breaks Netfilter
policy matching using xt_policy in the FORWARD chain, as the secpath
is missing during forwarding. INPUT matching is not affected, as it is
done before secpath reset.

A work-around could use XFRM input interface matching for such rules,
but this does not work if the XFRM interface is part of a VRF; the
Netfilter input interface is replaced by the VRF interface, making a
sufficient match for IPsec-protected packets difficult.

So instead, limit the secpath reset to packets that are targeting the
local host, in the default or a specific VRF. This should allow nested
tunnels, but keeps the secpath intact on packets that are passed to
Netfilter chains with potential IPsec policy matches.

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 include/net/xfrm.h     | 10 ++++++++++
 net/xfrm/xfrm_policy.c |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e1f70e8e424..f16df2f07a83 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1349,6 +1349,16 @@ void xfrm_flowi_addr_get(const struct flowi *fl,
 	}
 }
 
+static inline bool xfrm_flowi_is_forwarding(struct net *net,
+					    const struct flowi *fl)
+{
+	if (fl->flowi_oif == LOOPBACK_IFINDEX)
+		return false;
+	if (netif_index_is_l3_master(net, fl->flowi_oif))
+		return false;
+	return true;
+}
+
 static __inline__ int
 __xfrm4_state_addr_check(const struct xfrm_state *x,
 			 const xfrm_address_t *daddr, const xfrm_address_t *saddr)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5c61ec04b839..4f49698eb29f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
-		if (if_id)
+		if (if_id && !xfrm_flowi_is_forwarding(net, &fl))
 			secpath_reset(skb);
 
 		xfrm_pols_put(pols, npols);
-- 
2.34.1

