Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665D9104A77
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 06:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKUF4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 00:56:38 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51660 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfKUF4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 00:56:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iXfSF-000228-UL; Thu, 21 Nov 2019 06:56:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Byron Stanoszek <gandalf@winds.org>
Subject: [PATCH net] udp: drop skb extensions before marking skb stateless
Date:   Thu, 21 Nov 2019 06:56:23 +0100
Message-Id: <20191121055623.20952-1-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121053031.GI20235@breakpoint.cc>
References: <20191121053031.GI20235@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once udp stack has set the UDP_SKB_IS_STATELESS flag, later skb free
assumes all skb head state has been dropped already.

This will leak the extension memory in case the skb has extensions other
than the ipsec secpath, e.g. bridge nf data.

To fix this, set the UDP_SKB_IS_STATELESS flag only if we don't have
extensions or if the extension space can be free'd.

Fixes: 895b5c9f206eb7d25dc1360a ("netfilter: drop bridge nf reset from nf_reset")
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: Byron Stanoszek <gandalf@winds.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h |  6 ++++++
 net/ipv4/udp.c         | 27 ++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 64a395c7f689..8688f7adfda7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4169,12 +4169,18 @@ static inline void skb_ext_reset(struct sk_buff *skb)
 		skb->active_extensions = 0;
 	}
 }
+
+static inline bool skb_has_extensions(struct sk_buff *skb)
+{
+	return unlikely(skb->active_extensions);
+}
 #else
 static inline void skb_ext_put(struct sk_buff *skb) {}
 static inline void skb_ext_reset(struct sk_buff *skb) {}
 static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
 static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
+static inline bool skb_has_extensions(struct sk_buff *skb) { return false; }
 #endif /* CONFIG_SKB_EXTENSIONS */
 
 static inline void nf_reset_ct(struct sk_buff *skb)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1d58ce829dca..447defbfccdd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1297,6 +1297,27 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 
 #define UDP_SKB_IS_STATELESS 0x80000000
 
+/* all head states (dst, sk, nf conntrack) except skb extensions are
+ * cleared by udp_rcv().
+ *
+ * We need to preserve secpath, if present, to eventually process
+ * IP_CMSG_PASSSEC at recvmsg() time.
+ *
+ * Other extensions can be cleared.
+ */
+static bool udp_try_make_stateless(struct sk_buff *skb)
+{
+	if (!skb_has_extensions(skb))
+		return true;
+
+	if (!secpath_exists(skb)) {
+		skb_ext_reset(skb);
+		return true;
+	}
+
+	return false;
+}
+
 static void udp_set_dev_scratch(struct sk_buff *skb)
 {
 	struct udp_dev_scratch *scratch = udp_skb_scratch(skb);
@@ -1308,11 +1329,7 @@ static void udp_set_dev_scratch(struct sk_buff *skb)
 	scratch->csum_unnecessary = !!skb_csum_unnecessary(skb);
 	scratch->is_linear = !skb_is_nonlinear(skb);
 #endif
-	/* all head states execept sp (dst, sk, nf) are always cleared by
-	 * udp_rcv() and we need to preserve secpath, if present, to eventually
-	 * process IP_CMSG_PASSSEC at recvmsg() time
-	 */
-	if (likely(!skb_sec_path(skb)))
+	if (udp_try_make_stateless(skb))
 		scratch->_tsize_state |= UDP_SKB_IS_STATELESS;
 }
 
-- 
2.23.0

