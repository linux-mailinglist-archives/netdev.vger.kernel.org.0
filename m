Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2066B11FF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCHTaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCHTau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:30:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49301B2DD;
        Wed,  8 Mar 2023 11:30:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzUr-0003pP-IX; Wed, 08 Mar 2023 20:30:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 2/9] netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
Date:   Wed,  8 Mar 2023 20:30:26 +0100
Message-Id: <20230308193033.13965-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193033.13965-1-fw@strlen.de>
References: <20230308193033.13965-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

When checking Hop-by-hop option header, if the option data is in
nonlinear area, it should do pskb_may_pull instead of discarding
the skb as a bad IPv6 packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 6b07f30675bb..afd1c718b683 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -45,14 +45,18 @@
  */
 static int br_nf_check_hbh_len(struct sk_buff *skb)
 {
-	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
 	u32 pkt_len;
-	const unsigned char *nh = skb_network_header(skb);
-	int off = raw - nh;
-	int len = (raw[1] + 1) << 3;
 
-	if ((raw + len) - skb->data > skb_headlen(skb))
+	if (!pskb_may_pull(skb, off + 8))
 		goto bad;
+	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
+	len = (nh[1] + 1) << 3;
+
+	if (!pskb_may_pull(skb, off + len))
+		goto bad;
+	nh = skb_network_header(skb);
 
 	off += 2;
 	len -= 2;
-- 
2.39.2

