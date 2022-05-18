Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4E52C561
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbiERVGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbiERVGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:06:16 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D91C14D13
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 14:06:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q76so3209125pgq.10
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 14:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0MYc5tA+6Kk+mImSFFJDL7iE/dnIAiygpXE+Nyj8a7Y=;
        b=PgQlhIbYRhNtuHDufzTYVX6pyMkGW+9WugLaBTbqxueJOxfo9GnBV5ygNgv57oLb9w
         EZYYfzSJTlDdoR4SOmxQ0WmofKN3jObox199zzTfZlZ/nvrpaL0lmxD2yQ7rJClAJFnd
         OU0Ya9KHrqerFGxMFViJnS6mBaRJloG4zjKvr2WptY1BBKXABXHFl4DmJ/7zrX6gxV03
         EhLl19BBwIqUM4hB5/+MIcsOJyVM+lf561/fPLCGgYDceZqWurcPJ8jyrl3h0JR0SsQT
         lyNs8pGAujLM2AduX2XX7nm/IHmpI77dKFLDYehbyk+6OvN0OdGyh5EMnF6BTSWyy9re
         v0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0MYc5tA+6Kk+mImSFFJDL7iE/dnIAiygpXE+Nyj8a7Y=;
        b=NfLYeTYQPIoQBoL+ztr4hsa77k5/SdaQzgjPBgiK0B1HZheNKqK2Nj1up2zsknYo/7
         1kWhtAzzlv4v0UgS16lKMqpoXNNzF1bgUMqy1Iya6JtEoR76mdvmi2Dj9ZH+N27skBMW
         +rvTl9H2gqMOO1KVGJfvVRCJGbml+x8ok6ghz1U1D0zghJEzbyWkjgzMhWgFk9XQCZmg
         jT4FkQ3vqC4NqzzhYXZeUDxHk+YLFD8aRQTPKS+fKWZSzpB18sfo+UAjKY3wCoalNW0f
         sjruw0H+i1rYKUqpssaRYMJtmqTNRoZBxls3fu+vz3QgV+8I9l7fBc9UEPOe4lRKGdsa
         1zow==
X-Gm-Message-State: AOAM531Qw7Vt6wUnRXWsm+irjBFpgSnxHsOz5gj0+0T9kIb8JgV9JwgM
        iEiXRQ4i+i6VmTI+wyxwe88=
X-Google-Smtp-Source: ABdhPJxo9H6cJzSrewRdNexhJiiPvy9ZffoaCdxcaoxXmgCyMvwffYySCOhKG//+KvstdKyaEE4nRg==
X-Received: by 2002:a63:d743:0:b0:3f5:f77a:a516 with SMTP id w3-20020a63d743000000b003f5f77aa516mr1119879pgi.210.1652907967283;
        Wed, 18 May 2022 14:06:07 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:c7a5:3f7a:9ca9:aa8c])
        by smtp.gmail.com with ESMTPSA id q4-20020a170903204400b0015e8d4eb1e5sm2111625pla.47.2022.05.18.14.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 14:06:06 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lina Wang <lina.wang@mediatek.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes.
Date:   Wed, 18 May 2022 14:05:48 -0700
Message-Id: <20220518210548.2296546-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

One may want to have DF set on large packets to support discovering
path mtu and limiting the size of generated packets (hence not
setting the XFRM_STATE_NOPMTUDISC tunnel flag), while still
supporting networks that are incapable of carrying even minimal
sized IPv6 frames (post encapsulation).

Having IPv4 Don't Frag bit set on encapsulated IPv6 frames that
are not larger than the minimum IPv6 mtu of 1280 isn't useful,
because the resulting ICMP Fragmentation Required error isn't
actionable (even assuming you receive it) because IPv6 will not
drop it's path mtu below 1280 anyway.  While the IPv4 stack
could prefrag the packets post encap, this requires the ICMP
error to be successfully delivered and causes a loss of the
original IPv6 frame (thus requiring a retransmit and latency
hit).  Luckily with IPv4 if we simply don't set the DF flag,
we'll just make further fragmenting the packets some other
router's problems.

We'll still learn the correct IPv4 path mtu through encapsulation
of larger IPv6 frames.

I'm still not convinced this patch is entirely sufficient to make
everything happy... but I don't see how it could possibly
make things worse.

See also recent:
  4ff2980b6bd2 'xfrm: fix tunnel model fragmentation behavior'
and friends

Bug: 203183943
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Lina Wang <lina.wang@mediatek.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 net/xfrm/xfrm_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index d4935b3b9983..555ab35cd119 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -273,6 +273,7 @@ static int xfrm4_beet_encap_add(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm4_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
 {
+	bool small_ipv6 = (skb->protocol == htons(ETH_P_IPV6)) && (skb->len <= IPV6_MIN_MTU);
 	struct dst_entry *dst = skb_dst(skb);
 	struct iphdr *top_iph;
 	int flags;
@@ -303,7 +304,7 @@ static int xfrm4_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
 	if (flags & XFRM_STATE_NOECN)
 		IP_ECN_clear(top_iph);
 
-	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
+	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) || small_ipv6 ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
 
 	top_iph->ttl = ip4_dst_hoplimit(xfrm_dst_child(dst));
-- 
2.36.1.124.g0e6072fb45-goog

