Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82966AA625
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCDAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCDAMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:50 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9111F4A2;
        Fri,  3 Mar 2023 16:12:49 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o3so2934967qvr.1;
        Fri, 03 Mar 2023 16:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZ0vhTutGGK9agR9K+MeMFv3WJrBT1StcvjUsNJ0JeU=;
        b=i+gGxMb9zeC7JYwZy76adVkW5RbiosfdklzCJieR7NZZoNs89nao3+LrZWaIEj9lGE
         In+V9Z5ggyfpr+zMqq04pqBdWdxY0UgmEH2o0JfcYF0GsBOC6AAbqJ85tSxLdrcIIL4F
         UeoEq4n9UHq1R1DWdjJ0ZWHhKpc+kcyoR90C0dhudyyQSFsAGjL4HxHUcPciPahN9RRg
         BYbJijwbo77ZfU79jmXgOLHwSOGC9vniALrz7AWep00d43hAiDBbktonqOBP4EnA4wqq
         aFbRV2npNN0SAh0yE7OY4XU5zBEfEmWiVp4UQqJZp58Fe4j04XKkerxMEyp5aw80XwXo
         NJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZ0vhTutGGK9agR9K+MeMFv3WJrBT1StcvjUsNJ0JeU=;
        b=2ApFSHXh9e/w9/8vp+lVwoiMSdLY+5Kq6tnLjH7kVUI4ibEUZbFJgvbAacLoZGNWZM
         XZqPMrCx36aez2OqREV7eRo4ZRUBgJCVzfFUKNf3V04IvJKerYIrMrfbTscVmWpIFORD
         btEccj1EiWgcpmVQpt7efP03ZiTmM+SNSrHU794s9oRYmlfbXfE04Ay1ah3YZXXVjRvG
         Kit4M9yBxK9eTTCOspF+d0JlQ9sjuzvkEJHC8IzJ8yJbzNFGzQmw+9GvKU7dmsn5KV36
         GESmwilj17UGF4cwn7nSB6uleyP4ViLo09krQSKsPUQn0ex/XZQZhilf4p6o1wAzgU1w
         6ptw==
X-Gm-Message-State: AO0yUKXkXjeNkFYNzFgwEtq0vrLlaSlBYA8jjd3PcHL6227iYjjvdMoF
        7Q9tpm3c1sBmI5yIuCF6kCl5g+q9uk1SGw==
X-Google-Smtp-Source: AK7set/QTB32NVLdGVNIVUw08bMIyY5m1ozy+bD8ChxPEueacrrg+TqoncfPLWpwGarzsWFzPCp4Vw==
X-Received: by 2002:a05:6214:3012:b0:56e:a88f:70d0 with SMTP id ke18-20020a056214301200b0056ea88f70d0mr4549691qvb.27.1677888768309;
        Fri, 03 Mar 2023 16:12:48 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 4/6] netfilter: move br_nf_check_hbh_len to utils
Date:   Fri,  3 Mar 2023 19:12:40 -0500
Message-Id: <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
to netfilter utils, so that it can be used by other modules, like
ovs and tc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/netfilter_ipv6.h |  2 ++
 net/bridge/br_netfilter_ipv6.c | 57 +---------------------------------
 net/netfilter/utils.c          | 54 ++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 56 deletions(-)

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
index 07289e4f3213..550039dfc31a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -40,61 +40,6 @@
 #include <linux/sysctl.h>
 #endif
 
-/* We only check the length. A bridge shouldn't do any hop-by-hop stuff
- * anyway
- */
-static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
-{
-	int len, off = sizeof(struct ipv6hdr);
-	unsigned char *nh;
-	u32 pkt_len = 0;
-
-	if (!pskb_may_pull(skb, off + 8))
-		return -1;
-	nh = (u8 *)(ipv6_hdr(skb) + 1);
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
-			if (nh[off + 1] != 4 || (off & 3) != 2)
-				return -1;
-			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
-			if (pkt_len <= IPV6_MAXPLEN ||
-			    ipv6_hdr(skb)->payload_len)
-				return -1;
-			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				return -1;
-		}
-		off += optlen;
-		len -= optlen;
-	}
-	if (len)
-		return -1;
-
-	if (pkt_len)
-		*plen = pkt_len;
-	return 0;
-}
-
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
@@ -114,7 +59,7 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+	if (hdr->nexthdr == NEXTHDR_HOP && nf_ip6_check_hbh_len(skb, &pkt_len))
 		goto drop;
 
 	if (pkt_len + ip6h_len > skb->len) {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 2182d361e273..04f4bd661774 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -215,3 +215,57 @@ int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	}
 	return ret;
 }
+
+/* Only get and check the lengths, not do any hop-by-hop stuff. */
+int nf_ip6_check_hbh_len(struct sk_buff *skb, u32 *plen)
+{
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
+	u32 pkt_len = 0;
+
+	if (!pskb_may_pull(skb, off + 8))
+		return -ENOMEM;
+	nh = (u8 *)(ipv6_hdr(skb) + 1);
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
+			if (nh[off + 1] != 4 || (off & 3) != 2)
+				return -EBADMSG;
+			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
+			if (pkt_len <= IPV6_MAXPLEN ||
+			    ipv6_hdr(skb)->payload_len)
+				return -EBADMSG;
+			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+				return -EBADMSG;
+		}
+		off += optlen;
+		len -= optlen;
+	}
+	if (len)
+		return -EBADMSG;
+
+	if (pkt_len)
+		*plen = pkt_len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ip6_check_hbh_len);
-- 
2.39.1

