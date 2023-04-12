Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03B16DEFED
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDLI5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjDLI5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:57:36 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6359D7283
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:57:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 1957C220006;
        Wed, 12 Apr 2023 10:56:23 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Eo_yVfNIg0ne; Wed, 12 Apr 2023 10:56:21 +0200 (CEST)
Received: from think.home (147.249.6.85.dynamic.wline.res.cust.swisscom.ch [85.6.249.147])
        by mail.codelabs.ch (Postfix) with ESMTPSA id B742D220005;
        Wed, 12 Apr 2023 10:56:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1681289781;
        bh=nVFrFB1zsPC2EDhsLaEVwORFouJe7j2sM7VUsoAV79o=;
        h=From:To:Cc:Subject:Date:From;
        b=vFa0Ha9R6nbuaaQIz+tYcu/ewM0WUvbWIFG74ckQYLVERtNlQLwD7znieDwX+Lbct
         G3ghmLfO+uCeIbASUIPzdjJdLrLu9CnUidaEYxrA7mta+EOciduKfNHxGV/sHvqXsp
         9oDsw6er8lQ2ZVkEeNwnl5Q0YcU3ZGe7cgMJLcwKsmtIw2Uj1eqS+X9DkjJ3018BPa
         e3QCtG5LQgalpXL3w0wPJ2Mkd02JDDNpgxEcz1Z5fhYLn8kEzluUynDSGVIPJ6V6b0
         8ao2rnnSxv4t8xDfxIWNeJAcck2FPGVitsM/TOtkdHond18Mvqadrs5r5Z8dEY4t+x
         n7EFWYUzdMU+A==
From:   Martin Willi <martin@strongswan.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>,
        Eyal Birger <eyal.birger@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for packets forwarded
Date:   Wed, 12 Apr 2023 10:56:15 +0200
Message-Id: <20230412085615.124791-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

So instead, limit the secpath reset to packets that are not using a
XFRM forward policy. This should allow nested tunnels, but keeps the
secpath intact on packets that are passed to Netfilter chains with
potential IPsec policy matches.

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Suggested-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Martin Willi <martin@strongswan.org>
---
v1 -> v2: Use policy dir instead of flowi outif to check for forwarding

 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5c61ec04b839..669c3c0880a6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
-		if (if_id)
+		if (if_id && dir != XFRM_POLICY_FWD)
 			secpath_reset(skb);
 
 		xfrm_pols_put(pols, npols);
-- 
2.34.1

