Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6203314A721
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgA0PY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:24:29 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:32823 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0PY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 10:24:29 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dc0f2af9;
        Mon, 27 Jan 2020 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=dNK/qRymv8vLPYFtEy3d0yAds+8=; b=rJ3EZxbG/LZ8X015UDN2
        ERJwWZrV0zH4u5ifScpWQCOaQ+EzMmm9QV61oPN8eF4A+IvGs8wtcZFwPl7eoaHz
        AZXHL8mVIUscKm78bkXLDKD4K077bQCn2QxDnghbDiEGgqtoGaxyhVNox4UxkwUH
        8m9v8YFopk4BisIwoYi6kP0hTllQbYddiM72JL/PCQvVTjQ/wJ4nqUAzTfQAn7X6
        L37jzddlyS35HYzeqL2Mg1axuUj6s6xWCLKOouHA7sGrLqDLRF0uWURd4zTa89oU
        c0CKhAnldzyCa9pkJaEOjsITW6oIgFXh7YYPG68jer5KSaM1Txv39uPvLnIfR5UZ
        DA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 16f44cbe (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 27 Jan 2020 14:22:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [RFC] net: add gro frag support to udp tunnel api
Date:   Mon, 27 Jan 2020 16:24:11 +0100
Message-Id: <20200127152411.15914-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen,

This is very much a "RFC", in that the code here is fodder for
discussion more than something I'm seriously proposing at the moment.
I'm writing to you specifically because I recall us having discussed
something like this a while ago and you being interested.

WireGuard would benefit from getting lists of SKBs all together in a
bunch on the receive side. At the moment, encap_rcv splits them apart
one by one before giving them to the API. This patch proposes a way to
opt-in to receiving them before they've been split. The solution
involves adding an encap_type flag that enables calling the encap_rcv
function earlier before the skbs have been split apart.

I worry that it's not this straight forward, however, because of this
function below called, "udp_unexpected_gso". It looks like there's a
fast path for the case when it doesn't need to be split apart, and that
if it is already split apart, that's expected, whereas splitting it
apart would be "unexpected." I'm not too familiar with this code. Do you
know off hand why this would be unexpected? And does that imply that a
proper implementation of this might be a bit more involved? Or is the
naming just silly and this actually is _the_ path where this happens?

The other thing I'm wondering with regards to this is how you even hit
this path. So far I've only been able to hit it with the out of tree
Qualcom driver, "rmnet_perf". I saw a mailing list discussion a few
years ago about adding some flags to be able to simulate this with veth,
but I didn't see that go anywhere. Figuring out how I can test this is
probably a good idea before proceeding further.

Finally, and most importantly, is this overlapping with something you're
working on at the moment? Where do you stand with this? Did you wind up
solving your own use cases in a different way, or are you sitting on a
more proper version of this RFC or something else?

Regards,
Jason
---
 include/uapi/linux/udp.h |  1 +
 net/ipv4/udp.c           | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 30baccb6c9c4..35b23c8a030f 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -42,5 +42,6 @@ struct udphdr {
 #define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
 #define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
 #define UDP_ENCAP_RXRPC		6
+#define UDP_ENCAP_SUPPORT_GRO_FRAGS (1UL << 31)
 
 #endif /* _UAPI_LINUX_UDP_H */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 208da0917469..ee583f20cef5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2095,9 +2095,19 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int (*encap_rcv_gro)(struct sock *sk, struct sk_buff *skb);
 	struct sk_buff *next, *segs;
 	int ret;
 
+	if (static_branch_unlikely(&udp_encap_needed_key) &&
+	    up->encap_type & UDP_ENCAP_SUPPORT_GRO_FRAGS &&
+	    (encap_rcv_gro = READ_ONCE(up->encap_rcv))) {
+		//XXX: deal with checksum?
+		ret = encap_rcv(sk, skb);
+		if (ret <= 0) //XXX: deal with incrementing udp error stats?
+			return -ret;
+	}
+
 	if (likely(!udp_unexpected_gso(sk, skb)))
 		return udp_queue_rcv_one_skb(sk, skb);
 
-- 
2.24.1

