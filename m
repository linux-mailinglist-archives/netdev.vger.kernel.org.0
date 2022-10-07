Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9F5F79EB
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJGOub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJGOu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:50:28 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DF5A8BB;
        Fri,  7 Oct 2022 07:50:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CEBF82057B;
        Fri,  7 Oct 2022 16:50:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fDj5BHZ5B1YY; Fri,  7 Oct 2022 16:50:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3BA0120536;
        Fri,  7 Oct 2022 16:50:17 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2CC0480004A;
        Fri,  7 Oct 2022 16:50:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 16:50:17 +0200
Received: from [172.18.157.49] (172.18.157.49) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 7 Oct
 2022 16:50:16 +0200
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Christian Langrock <christian.langrock@secunet.com>
Subject: [PATCH ipsec v6] xfrm: replay: Fix ESN wrap around for GSO
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
Message-ID: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
Date:   Fri, 7 Oct 2022 16:50:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
---
Changes in v6:
 - move overflow check to offloading path to avoid locking issues

Changes in v5:
 - Fix build

Changes in v4:
 - move changelog within comment
 - add reviewer

Changes in v3:
- fix build
- remove wrapper function

Changes in v2:
- switch to bool as return value
- remove switch case in wrapper function
---
 net/ipv4/esp4_offload.c |  3 +++
 net/ipv6/esp6_offload.c |  3 +++
 net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
 net/xfrm/xfrm_replay.c  |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 170152772d33..3969fa805679 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -314,6 +314,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
                        xo->seq.low += skb_shinfo(skb)->gso_segs;
        }
 
+       if (xo->seq.low < seq)
+               xo->seq.hi++;
+
        esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
        ip_hdr(skb)->tot_len = htons(skb->len);
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 79d43548279c..242f4295940e 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -346,6 +346,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
                        xo->seq.low += skb_shinfo(skb)->gso_segs;
        }
 
+       if (xo->seq.low < seq)
+               xo->seq.hi++;
+
        esp.seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
 
        len = skb->len - sizeof(struct ipv6hdr);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 5f5aafd418af..21269e8f2db4 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -97,6 +97,18 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
        }
 }
 
+static inline bool xmit_xfrm_check_overflow(struct sk_buff *skb)
+{
+       struct xfrm_offload *xo = xfrm_offload(skb);
+       __u32 seq = xo->seq.low;
+
+       seq += skb_shinfo(skb)->gso_segs;
+       if (unlikely(seq < xo->seq.low))
+               return true;
+
+       return false;
+}
+
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
 {
        int err;
@@ -134,7 +146,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
                return skb;
        }
 
-       if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
+       if (skb_is_gso(skb) && (unlikely(x->xso.dev != dev) ||
+                               unlikely(xmit_xfrm_check_overflow(skb)))) {
                struct sk_buff *segs;
 
                /* Packet got rerouted, fixup features and segment it. */
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9f4d42eb090f..ce56d659c55a 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -714,7 +714,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
                        oseq += skb_shinfo(skb)->gso_segs;
                }
 
-               if (unlikely(oseq < replay_esn->oseq)) {
+               if (unlikely(xo->seq.low < replay_esn->oseq)) {
                        XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
                        xo->seq.hi = oseq_hi;
                        replay_esn->oseq_hi = oseq_hi;

base-commit: 0326074ff4652329f2a1a9c8685104576bd8d131
-- 
2.37.1.223.g6a475b71f8
