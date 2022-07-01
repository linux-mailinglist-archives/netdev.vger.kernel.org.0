Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101B8562882
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 03:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiGABlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 21:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiGABlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 21:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3EF5C9C6;
        Thu, 30 Jun 2022 18:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 048A660F68;
        Fri,  1 Jul 2022 01:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BADC34115;
        Fri,  1 Jul 2022 01:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656639670;
        bh=yJ3BCnw2LtMDCfgAawtRgZZPutlI/b7jlQ7gc6oPj3E=;
        h=From:To:Cc:Subject:Date:From;
        b=gwD7aaKkSVJS1jzRYVCKmN0XfC60+ibz6HwZ8nWg+FJnIJy4Ta2kQtnmfX+F/Mbx7
         66XWFSVZzyD3YgRkMJ/TrjjY0z4qtvgX2wd11bhy9pQO7wBn9YTjD7ozAxMxDP7xuJ
         bC1DX43WONc82mvq8jaDQDuf61RksZUDnYNiNxoxOP4dk0qlfjAyr11rlEKpXLbjRw
         Btjz+gD731Qhj5x+Pav/xA2RfOMi0/RdYyU6fY7Hz7jspGIar/4K2qrBll0ecZOuue
         p1F+lASS4JWUHzJl3xjKw4GTE5N8H4ZN7Dk2zkjr7NVYFeTECFkD17HP/eC3245425
         YS0Oos3XBRSJw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     stable@vger.kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH stable 5.15] tcp: add a missing nf_reset_ct() in 3WHS handling
Date:   Thu, 30 Jun 2022 18:41:01 -0700
Message-Id: <20220701014101.684813-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6f0012e35160cd08a53e46e3b3bbf724b92dfe68 upstream.

When the third packet of 3WHS connection establishment
contains payload, it is added into socket receive queue
without the XFRM check and the drop of connection tracking
context.

This means that if the data is left unread in the socket
receive queue, conntrack module can not be unloaded.

As most applications usually reads the incoming data
immediately after accept(), bug has been hiding for
quite a long time.

Commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") exposed this bug because
even if the application reads this data, the skb
with nfct state could stay in a per-cpu cache for
an arbitrary time, if said cpu no longer process RX softirqs.

Many thanks to Ilya Maximets for reporting this issue,
and for testing various patches:
https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/

Note that I also added a missing xfrm4_policy_check() call,
although this is probably not a big issue, as the SYN
packet should have been dropped earlier.

Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Tested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://lore.kernel.org/r/20220623050436.1290307-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a189625098ba..5d94822fd506 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2014,7 +2014,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb) ||
+			     tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2061,6 +2062,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
-- 
2.36.1

