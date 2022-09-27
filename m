Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F75F5EC36E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiI0NAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiI0NAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:00:01 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F5F6FA06;
        Tue, 27 Sep 2022 05:59:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C21B20491;
        Tue, 27 Sep 2022 14:59:52 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0Y8nUdu-HE-c; Tue, 27 Sep 2022 14:59:51 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 954C0200AC;
        Tue, 27 Sep 2022 14:59:51 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8646880004A;
        Tue, 27 Sep 2022 14:59:51 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 14:59:51 +0200
Received: from [10.182.6.203] (10.182.6.203) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 14:59:51 +0200
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Christian Langrock <christian.langrock@secunet.com>
Subject: [PATCH net-ipsec v2] xfrm: replay: Fix ESN wrap around for GSO
Autocrypt: addr=christian.langrock@secunet.com; keydata=
 mQENBFee7jkBCACkeMIuzZu/KBA1q3kKGr7d9iiZGF5IpJnIE9dMiK3uaz7uM26VSTJVp6jd
 GuSGGGmb81OSLEcIEIsYKXvjblAKUX1A74t3WMRcky3MwJbmN6AkN8QlP45mDddtPRf1ElB2
 S32i9OrEkvw8xcvHYPwbaHenXic4/8fHWEh+vtd/5/5TDTIU/ag9tQfPea13ixXN0PuccMub
 FeUMpwFCg324+Z19iGvfDWWZmQQGlBjc3Q6z0hXOb/deWL/+lPS4t+tTgpmmZO4XkIs+18Kq
 xCVukCbnqV0y+04sj3G1GQ/DlGvZHxwywBceAL7BvmdeXQKAS0KRL5zrghIBCgnUyutDABEB
 AAG0M0NocmlzdGlhbiBMYW5ncm9jayA8Y2hyaXN0aWFuLmxhbmdyb2NrQHNlY3VuZXQuY29t
 PokBNwQTAQgAIQUCV57uOQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRCjeMdfgutr
 Xu3kCACIBx6UHReBtBciNUPkP3fRaGeSOADIrql72VKD9faLAHTt6w8kvyzb8Ctpa77jswJt
 21c349mF3maPlpNtpswqH27bTlXYhNcXxcmHPCbNtN3yGUy0UuIJfBMZc8PLqiqYoY5GKD3u
 imeVbDYjgNhebO2f1cUvwY2wTwX6b0tgKVK0xYYTDpXI1/2MVGsjXqak7PQoqVq0sDu0gIAA
 i1QO0Fbb6jIaHj6CEM2hpBTBk8qbkPs/MqYGdLl4oXvkWTLduQjm6dMtjxvIt6WJWZQbLjTe
 QIfc21luNQKDmfT623pVTPPMMAciWfpdw63FblfGcfBnAKCJ8JBj0z9T6/PmuQENBFee7jkB
 CADS7amJPbY2dWpeGtE+I9yLL53lSriP4L6rI9UoEwNM1OkjnB7wFnH8dm8N68K2OJogkHwo
 X2OnzGhxJ28NHRuAh++3hIYY+gU4HMLaX3onDK1oqAdYczhJ7f6UCPbYaghkzJ6Vg/FEWpA8
 u5vG/BX4y+F3/Y98l6mzAX5wLmTapRwdfuRCXRA6jlIHIOwP3NPKK4Pz2E7witsimV1ucN4u
 XFiZ36CUPAiXXlER9iPZnQUSyCobqJOJKm4C7wUNQ1negCXDBd3KjSyzTIafw/oYG4RrWGul
 iI2ig/qTUC8cZdAJTMBjUJR6ugJazMB1Rg17p2GRD0AzUOV2qdqYFqQFABEBAAGJAR8EGAEI
 AAkFAlee7jkCGwwACgkQo3jHX4Lra17vtQgAg2g0JEXVTGT36BDJgVjIUY1evnm1fWwTPpco
 kP/8/aO2ubmlxtWQ2hV5OPfL5nDday2S4Nq5j3kqQq+rvUrORVmvT4WxYZM1fr2nibuzaUbs
 JtxphNpjahrsEcLLTzBW4CbHTaL4YTT+ZD/GDeHoxAh9JfMkdMBXHyWTuw+QSP0pp7WvNsDo
 sukKFyQ0rve9PH2dry6A0oLP7UxtAzEERV2Se0BueZPQuVnU6Cvj3ZStK28JDhMjxIPkZPE5
 kCV8QNF8OsiwymA3aoPKe5Bw0lOcjuuJkxRa5bazyuubX9pIIgTeGsecgpSgpfA9jsEHKFqo
 LuxUA+77VQ5hSydVaQ==
Message-ID: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
Date:   Tue, 27 Sep 2022 14:59:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using GSO it can happen that the wrong seq_hi is used for the last
packets before the wrap around. This can lead to double usage of a
sequence number. To avoid this, we should serialize this last GSO
packet.

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for...")
Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_output.c |  2 +-
 net/xfrm/xfrm_replay.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e8fa98f786f..49d6d974f493 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1749,6 +1749,7 @@ void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
 int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
+int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
 static inline int xfrm_aevent_is_on(struct net *net)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9a5e79a38c67..c470a68d9c88 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -738,7 +738,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-			if (skb->inner_protocol)
+			if (skb->inner_protocol || xfrm_replay_overflow_check(x, skb))
 				return xfrm_output_gso(net, sk, skb);
 
 			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9277d81b344c..991cfc7a091d 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -750,6 +750,34 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 
 	return xfrm_replay_overflow_offload(x, skb);
 }
+
+static bool xfrm_replay_overflow_check_offload_esn(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
+	__u32 oseq = replay_esn->oseq;
+	bool ret = false;
+
+	/* We assume that this function is called with
+	 * skb_is_gso(skb) == true
+	 */
+
+	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
+		oseq = oseq + 1 + skb_shinfo(skb)->gso_segs;
+		if (unlikely(oseq < replay_esn->oseq))
+			ret = true;
+	}
+
+	return ret;
+}
+
+bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
+{
+	if (x->repl_mode == XFRM_REPLAY_MODE_ESN)
+		return xfrm_replay_overflow_check_offload_esn(x, skb);
+
+	return false;
+}
+
 #else
 int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 {
@@ -764,6 +792,11 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 
 	return __xfrm_replay_overflow(x, skb);
 }
+
+int xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buff *skb)
+{
+	return 0;
+}
 #endif
 
 int xfrm_init_replay(struct xfrm_state *x)
-- 
2.37.1.223.g6a475b71f8

