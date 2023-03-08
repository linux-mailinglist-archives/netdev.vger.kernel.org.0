Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA016B1204
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCHTbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCHTbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:31:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B23ECEFBB;
        Wed,  8 Mar 2023 11:31:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzV3-0003qk-TZ; Wed, 08 Mar 2023 20:30:57 +0100
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
Subject: [PATCH net-next 5/9] netfilter: move br_nf_check_hbh_len to utils
Date:   Wed,  8 Mar 2023 20:30:29 +0100
Message-Id: <20230308193033.13965-6-fw@strlen.de>
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

Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
to netfilter utils, so that it can be used by other modules, like
ovs and tc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ipv6.h |  2 ++
 net/bridge/br_netfilter_ipv6.c | 55 +---------------------------------
 net/netfilter/utils.c          | 52 ++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 48314ade1506..7834c0be2831 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -197,6 +197,8 @@ static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
+int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen);
+
 int ipv6_netfilter_init(void);
 void ipv6_netfilter_fini(void);
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index a0d6dfb3e255..550039dfc31a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -40,59 +40,6 @@
 #include <linux/sysctl.h>
 #endif
 
-/* We only check the length. A bridge shouldn't do any hop-by-hop stuff
- * anyway
- */
-static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
-{
-	int len, off = sizeof(struct ipv6hdr);
-	unsigned char *nh;
-
-	if (!pskb_may_pull(skb, off + 8))
-		return -1;
-	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
-	len = (nh[1] + 1) << 3;
-
-	if (!pskb_may_pull(skb, off + len))
-		return -1;
-	nh = skb_network_header(skb);
-
-	off += 2;
-	len -= 2;
-	while (len > 0) {
-		int optlen;
-
-		if (nh[off] == IPV6_TLV_PAD1) {
-			off++;
-			len--;
-			continue;
-		}
-		if (len < 2)
-			return -1;
-		optlen = nh[off + 1] + 2;
-		if (optlen > len)
-			return -1;
-
-		if (nh[off] == IPV6_TLV_JUMBO) {
-			u32 pkt_len;
-
-			if (nh[off + 1] != 4 || (off & 3) != 2)
-				return -1;
-			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
-			if (pkt_len <= IPV6_MAXPLEN ||
-			    ipv6_hdr(skb)->payload_len)
-				return -1;
-			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				return -1;
-			*plen = pkt_len;
-		}
-		off += optlen;
-		len -= optlen;
-	}
-
-	return len ? -1 : 0;
-}
-
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
@@ -112,7 +59,7 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+	if (hdr->nexthdr == NEXTHDR_HOP && nf_ip6_check_hbh_len(skb, &pkt_len))
 		goto drop;
 
 	if (pkt_len + ip6h_len > skb->len) {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 2182d361e273..acef4155f0da 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -215,3 +215,55 @@ int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	}
 	return ret;
 }
+
+/* Only get and check the lengths, not do any hop-by-hop stuff. */
+int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen)
+{
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
+
+	if (!pskb_may_pull(skb, off + 8))
+		return -ENOMEM;
+	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
+	len = (nh[1] + 1) << 3;
+
+	if (!pskb_may_pull(skb, off + len))
+		return -ENOMEM;
+	nh = skb_network_header(skb);
+
+	off += 2;
+	len -= 2;
+	while (len > 0) {
+		int optlen;
+
+		if (nh[off] == IPV6_TLV_PAD1) {
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			return -EBADMSG;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			return -EBADMSG;
+
+		if (nh[off] == IPV6_TLV_JUMBO) {
+			u32 pkt_len;
+
+			if (nh[off + 1] != 4 || (off & 3) != 2)
+				return -EBADMSG;
+			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
+			if (pkt_len <= IPV6_MAXPLEN ||
+			    ipv6_hdr(skb)->payload_len)
+				return -EBADMSG;
+			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+				return -EBADMSG;
+			*plen = pkt_len;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+
+	return len ? -EBADMSG : 0;
+}
+EXPORT_SYMBOL_GPL(nf_ip6_check_hbh_len);
-- 
2.39.2

