Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC567F196
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjA0W7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjA0W7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:59:30 -0500
Received: from smtp.chopps.org (smtp.chopps.org [54.88.81.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEEB57BBF2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:59:29 -0800 (PST)
Received: from labnh.big (172-222-091-149.res.spectrum.com [172.222.91.149])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by smtp.chopps.org (Postfix) with ESMTPSA id 4B8F77D11E;
        Fri, 27 Jan 2023 22:59:28 +0000 (UTC)
From:   Christian Hopps <chopps@chopps.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org
Cc:     Christian Hopps <chopps@chopps.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@labn.net
Subject: [PATCH ipsec-next v3] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Date:   Fri, 27 Jan 2023 17:58:20 -0500
Message-Id: <20230127225821.1909363-1-chopps@chopps.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126102933.1245451-1-chopps@labn.net>
References: <20230126102933.1245451-1-chopps@labn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When copying the DSCP bits for decap-dscp into IPv6 don't assume the
outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
the DSCP bits from the correctly saved "tos" value in the control block.

Signed-off-by: Christian Hopps <chopps@labn.net>
---
 net/xfrm/xfrm_input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index c06e54a10540..436d29640ac2 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -279,8 +279,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
-- 
2.34.1

