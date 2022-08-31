Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737BF5A8793
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiHaUhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaUhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:37:34 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4E7E3425
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 13:37:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b196so4788304pga.7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 13:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=t8mR0Ke/oBjK3rDeF36MjY20WjWplunat8rEiItk5HE=;
        b=QmZA9/+NsNMqhhBzR6N9/FnnVkivXdHLNl9DpKAc2HLel8BLTbLOwoVBvP8rtHenP+
         9iVjKAjq7GQUXnViAClidA+OMbpJ40CVGXLWkRnOAvk4aNMs0N5O1ukz2kopsAJ++LTo
         fLJlj8MP3Av1j/0c6v10vSzV4XRPzdCWl5DjVaK0BHqMl2/uuRZm3Bk8L9YLvA9selrZ
         D/QTc01MWD7mEpIw9Bl0U6bMywcY/piRFMIrHDJ8SNkXpIdyNj5hSN5LW5+2D3U4kEOW
         r8BZk7zZSZrtRqbOAo5fxp4lC4/QAefFcDck93UtZH47J2w2bQVeiFIOqbAEP1jFAuGa
         34gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=t8mR0Ke/oBjK3rDeF36MjY20WjWplunat8rEiItk5HE=;
        b=er+omgEe9L/MBbNRjG72m1yxCxOYBAE0PjhU5f8P29avKWSARaLR1RKGRDSggreq4R
         I9K4GzTsmnuezCTPMAVW4OF/Xu92CF6djUS9grHHwjqFP8nzy/1jIE5dt0pxh0RiIyB4
         KH90AX3s35x+ngJDJBKrkboGLNBkU1N+ZWB9FpgprrW5y3fM14/WIhg2PIgCjg1ZiBsj
         Y0lAnIWoG2nwN8w5aNTaudwVG0hYDSBo20WFQdSmoQ3RUDl6rqFefsKoVfle0AYcrtxL
         HkI2z+LuFJ/hTJFXgQnW6krMr3GytEMPKeM5Y7Ll3vrYXOtnvigsN8LvsoxFInmrkE/g
         Ir+A==
X-Gm-Message-State: ACgBeo2dXGzuGOCPBVtZF9bb1hY2ugz2khzqv6O85ySNmd9ZuYQrtm13
        BVgfd5s5AOOphwAqyJDDrcmXK9qxmlw=
X-Google-Smtp-Source: AA6agR77/nMy8aW0VXTqb30FfYAUaJrDG7SSXGz4y/mSSEkjNAukWTUB/JhSHTJ5DAu+paO8zOugSg==
X-Received: by 2002:a63:484a:0:b0:42b:2e71:6665 with SMTP id x10-20020a63484a000000b0042b2e716665mr23305142pgk.407.1661978252889;
        Wed, 31 Aug 2022 13:37:32 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6e53:d7eb:98a7:ba7e])
        by smtp.gmail.com with ESMTPSA id 192-20020a6218c9000000b00535e950aa28sm11692291pfy.131.2022.08.31.13.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 13:37:32 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in SYN_RECV state
Date:   Wed, 31 Aug 2022 13:37:29 -0700
Message-Id: <20220831203729.458000-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

This is a followup of commit c67b85558ff2 ("ipv6: tcp: send consistent
autoflowlabel in TIME_WAIT state"), but for SYN_RECV state.

In some cases, TCP sends a challenge ACK on behalf of a SYN_RECV request.
WHen this happens, we want to use the flow label that was used when
the prior SYNACK packet was sent, instead of another one.

After his patch, following packetdrill passes:

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

  +.2 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > (flowlabel 0x11) S. 0:0(0) ack 1 <...>
// Test if a challenge ack is properly sent (same flowlabel than prior SYNACK)
   +.01 < . 4000000000:4000000000(0) ack 1 win 320
   +0  > (flowlabel 0x11) . 1:1(0) ack 1

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ff5c4fc135fcc165f92f3cbf3a89d5e7099eece6..35013497e4078c99c046cc6970e1a87768f08ff1 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -858,7 +858,7 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
-				 u8 tclass, __be32 label, u32 priority)
+				 u8 tclass, __be32 label, u32 priority, u32 txhash)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcphdr *t1;
@@ -949,16 +949,16 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	}
 
 	if (sk) {
-		if (sk->sk_state == TCP_TIME_WAIT) {
+		if (sk->sk_state == TCP_TIME_WAIT)
 			mark = inet_twsk(sk)->tw_mark;
-			/* autoflowlabel relies on buff->hash */
-			skb_set_hash(buff, inet_twsk(sk)->tw_txhash,
-				     PKT_HASH_TYPE_L4);
-		} else {
+		else
 			mark = sk->sk_mark;
-		}
 		skb_set_delivery_time(buff, tcp_transmit_time(sk), true);
 	}
+	if (txhash) {
+		/* autoflowlabel/skb_get_hash_flowi6 rely on buff->hash */
+		skb_set_hash(buff, txhash, PKT_HASH_TYPE_L4);
+	}
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, skb->mark) ?: mark;
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
@@ -1085,7 +1085,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority);
+			     ipv6_get_dsfield(ipv6h), label, priority, 0);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
@@ -1096,10 +1096,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    u32 ack, u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key, u8 tclass,
-			    __be32 label, u32 priority)
+			    __be32 label, u32 priority, u32 txhash)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority);
+			     tclass, label, priority, txhash);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
@@ -1111,7 +1111,8 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_time_stamp_raw() + tcptw->tw_ts_offset,
 			tcptw->tw_ts_recent, tw->tw_bound_dev_if, tcp_twsk_md5_key(tcptw),
-			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority);
+			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority,
+			tw->tw_txhash);
 
 	inet_twsk_put(tw);
 }
@@ -1138,7 +1139,8 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
-			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority);
+			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
+			tcp_rsk(req)->txhash);
 }
 
 
-- 
2.37.2.672.g94769d06f0-goog

