Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF416EDD05
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjDYHqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjDYHqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:46:33 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A892180
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:46:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 27769220002;
        Tue, 25 Apr 2023 09:46:30 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n3zue1Gthl1l; Tue, 25 Apr 2023 09:46:28 +0200 (CEST)
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 74816220001;
        Tue, 25 Apr 2023 09:46:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1682408788;
        bh=c/2aL8Owu92oLuQUZbTLujlTBhi7v8WGbZ+3H3eHPC0=;
        h=From:To:Cc:Subject:Date:From;
        b=A05Q8wcmip5xJw2qqli7/+OhaaMolab9WzFOaFJOAPvp0L9oJJ8O7L8GAuRUFTDKK
         hrge+nIyGWHi4OiaNyGz2N41bzNfbAVjNZexhr7BzZDxW6TDcnTCBbcEnf1SDLJaeS
         +jm1Ny92quydLzXzYPBz9XVSDjfuNFqOPZKLZ5S1AU7EIWZ/06bAuRHxwUx6SXIX40
         Hse1CcBQ94YAuHFm5j2nombIT48PSF48WkFVm1+038WB+Jg+oNbjoCRHqWD6Quh+d4
         Zra+TlaW0W7mzZ9WaznLk95C8xiknxzCHhuwZk258rIwCShg7nm4mMG8U+Wpk96frJ
         tx9lYCnBnYCww==
From:   Martin Willi <martin@strongswan.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH ipsec] Revert "Fix XFRM-I support for nested ESP tunnels"
Date:   Tue, 25 Apr 2023 09:46:18 +0200
Message-Id: <20230425074618.275389-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b0355dbbf13c0052931dd14c38c789efed64d3de.

The reverted commit clears the secpath on packets received via xfrm interfaces
to support nested IPsec tunnels. This breaks Netfilter policy matching using
xt_policy in the FORWARD chain, as the secpath is missing during forwarding.
Additionally, Benedict Wong reports that it breaks Transport-in-Tunnel mode.

Fix this regression by reverting the commit until we have a better approach
for nested IPsec tunnels.

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Link: https://lore.kernel.org/netdev/20230412085615.124791-1-martin@strongswan.org/
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 net/xfrm/xfrm_interface_core.c | 54 +++-------------------------------
 net/xfrm/xfrm_policy.c         |  3 --
 2 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 35279c220bd7..1f99dc469027 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -310,52 +310,6 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->mark = 0;
 }
 
-static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
-		       int encap_type, unsigned short family)
-{
-	struct sec_path *sp;
-
-	sp = skb_sec_path(skb);
-	if (sp && (sp->len || sp->olen) &&
-	    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
-		goto discard;
-
-	XFRM_SPI_SKB_CB(skb)->family = family;
-	if (family == AF_INET) {
-		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
-	} else {
-		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
-	}
-
-	return xfrm_input(skb, nexthdr, spi, encap_type);
-discard:
-	kfree_skb(skb);
-	return 0;
-}
-
-static int xfrmi4_rcv(struct sk_buff *skb)
-{
-	return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
-}
-
-static int xfrmi6_rcv(struct sk_buff *skb)
-{
-	return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
-			   0, 0, AF_INET6);
-}
-
-static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
-{
-	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
-}
-
-static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
-{
-	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
-}
-
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
@@ -991,8 +945,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrmi6_rcv,
-	.input_handler	=	xfrmi6_input,
+	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -1042,8 +996,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrmi4_rcv,
-	.input_handler	=	xfrmi4_input,
+	.handler	=	xfrm4_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 62be042f2ebc..21a3a1cd3d6d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3739,9 +3739,6 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
-		if (if_id)
-			secpath_reset(skb);
-
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.34.1

