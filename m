Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83D4699933
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjBPPrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBPPrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:47:24 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDDA3ABE
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:47:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso2300333ybp.20
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D9pxfcVR3UvQqSHxgnSfWR23mgJgfzcoCmw3w072SDo=;
        b=h4asEAaszl35gY4ro9n95L1sfk1sff/ZCM/6GdY814C4aSWxEHwWGyy+vtwTF/CV4A
         QzDL/TXVoTI7P1OPnjrlJxUHyWYuInvEUBj0abzOyG/Bn5Uw4w6hMz5n6v5fvcyrxUfW
         UssLf37qIwKoquXOsIEnwY+jr79tiBzHOrNNSo6zrluSBB74HvJCPwM97DdsfQ9lqgoM
         HUhWdZ9dr0f5m7STyhL4x2k9PF2B3Dz8KHMk3NR8vBcu5+UBg5NExJHs7HM9/84lwIa+
         9HVyedx8NMvnn13vY1LGLJi7/yhUExc4ReTQa/rJZJ6NRVtRRxUlojnXJscrLQLPpIFu
         bDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D9pxfcVR3UvQqSHxgnSfWR23mgJgfzcoCmw3w072SDo=;
        b=offn1FqDH3bzKUkGvwFWyxUzAchS//SthwsoxYa0lCaIqlP1iKmm3SXvU8UBmF1yoT
         eOnO7CzaHqlqgbVmZCCANVD2+W/4dyqyvwv1UXTcrC+xkUuITceRtbqye27mqxca1+Mf
         0B/7nwyL9X5IBqRlxygzBu0HiQO/kgtgTLVHHvZMT0HmE6Nchx5poZWt6WlBYWPcwWvg
         BQtWEe12rj25/5nWx5BjEACc/seWIY6NvdYr9pvzku+90VWKHKIEQuGmDWzDE6o7isqU
         qfuHPBCf7uIOZsxvnpOnJ/625u9+uWmPUEbWTjalTaINj62NfDVBgX0XxH54jU+KzYgQ
         opwA==
X-Gm-Message-State: AO0yUKUoJZEx2RdPG0DvROsKFEbAoh+ND9GMjUIyP9Iq3SVkK92hmVVr
        2sT6P+AMzemd0khTiWHSBy5L/B9xP72Z8A==
X-Google-Smtp-Source: AK7set/ZAhqwT4sHfTaqKB6h5UaYkPRwjq85cp1x3TWhBF7cwwJZ1P3s97x4Ivlekj0KnRifF2CPYq6p2H+brg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:c15:b0:52e:c5f1:a0d4 with SMTP
 id cl21-20020a05690c0c1500b0052ec5f1a0d4mr9ywb.4.1676562441149; Thu, 16 Feb
 2023 07:47:21 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:47:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230216154718.1548837-1-edumazet@google.com>
Subject: [PATCH net-next] net: add location to trace_consume_skb()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kfree_skb() includes the location, it makes sense
to add it to consume_skb() as well.

After patch:

 taskd_EventMana  8602 [004]   420.406239: skb:consume_skb: skbaddr=0xffff893a4a6d0500 location=unix_stream_read_generic
         swapper     0 [011]   422.732607: skb:consume_skb: skbaddr=0xffff89597f68cee0 location=mlx4_en_free_tx_desc
      discipline  9141 [043]   423.065653: skb:consume_skb: skbaddr=0xffff893a487e9c00 location=skb_consume_udp
         swapper     0 [010]   423.073166: skb:consume_skb: skbaddr=0xffff8949ce9cdb00 location=icmpv6_rcv
         borglet  8672 [014]   425.628256: skb:consume_skb: skbaddr=0xffff8949c42e9400 location=netlink_dump
         swapper     0 [028]   426.263317: skb:consume_skb: skbaddr=0xffff893b1589dce0 location=net_rx_action
            wget 14339 [009]   426.686380: skb:consume_skb: skbaddr=0xffff893a51b552e0 location=tcp_rcv_state_process

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/trace/events/skb.h | 10 ++++++----
 net/core/dev.c             |  2 +-
 net/core/skbuff.c          |  8 ++++----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 25ab1ff9423d0d53453c334820dfbf7dedd626f3..07e0715628ecc6ce02e2f76828817da790e5e966 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -53,19 +53,21 @@ TRACE_EVENT(kfree_skb,
 
 TRACE_EVENT(consume_skb,
 
-	TP_PROTO(struct sk_buff *skb),
+	TP_PROTO(struct sk_buff *skb, void *location),
 
-	TP_ARGS(skb),
+	TP_ARGS(skb, location),
 
 	TP_STRUCT__entry(
-		__field(	void *,	skbaddr	)
+		__field(	void *,	skbaddr)
+		__field(	void *,	location)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
+		__entry->location = location;
 	),
 
-	TP_printk("skbaddr=%p", __entry->skbaddr)
+	TP_printk("skbaddr=%p location=%pS", __entry->skbaddr, __entry->location)
 );
 
 TRACE_EVENT(skb_copy_datagram_iovec,
diff --git a/net/core/dev.c b/net/core/dev.c
index 357081b0113cb5260c6285008821f1bf8be1d084..ea3318cea74e1a83a909543b23477eafd9ad9a5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5027,7 +5027,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 
 			WARN_ON(refcount_read(&skb->users));
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
-				trace_consume_skb(skb);
+				trace_consume_skb(skb, net_tx_action);
 			else
 				trace_kfree_skb(skb, net_tx_action,
 						SKB_DROP_REASON_NOT_SPECIFIED);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 98ebce9f6a515d85b749b9c880a172f37ad2a6a1..eb7d33b41e7107b07e4d8af7abf474b22255a9cd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -991,7 +991,7 @@ bool __kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
 
 	if (reason == SKB_CONSUMED)
-		trace_consume_skb(skb);
+		trace_consume_skb(skb, __builtin_return_address(0));
 	else
 		trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	return true;
@@ -1189,7 +1189,7 @@ void consume_skb(struct sk_buff *skb)
 	if (!skb_unref(skb))
 		return;
 
-	trace_consume_skb(skb);
+	trace_consume_skb(skb, __builtin_return_address(0));
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(consume_skb);
@@ -1204,7 +1204,7 @@ EXPORT_SYMBOL(consume_skb);
  */
 void __consume_stateless_skb(struct sk_buff *skb)
 {
-	trace_consume_skb(skb);
+	trace_consume_skb(skb, __builtin_return_address(0));
 	skb_release_data(skb, SKB_CONSUMED);
 	kfree_skbmem(skb);
 }
@@ -1260,7 +1260,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 
 	/* if reaching here SKB is ready to free */
-	trace_consume_skb(skb);
+	trace_consume_skb(skb, __builtin_return_address(0));
 
 	/* if SKB is a clone, don't handle this case */
 	if (skb->fclone != SKB_FCLONE_UNAVAILABLE) {
-- 
2.39.1.581.gbfd45094c4-goog

