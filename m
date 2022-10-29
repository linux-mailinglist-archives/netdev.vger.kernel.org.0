Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FA161232B
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJ2NLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJ2NLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E417169BCB;
        Sat, 29 Oct 2022 06:11:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j7so3216988pjn.5;
        Sat, 29 Oct 2022 06:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA5WMUBCQaBZijA3RMGledp+Muz3yfsvc2v9AgiacX4=;
        b=QjKTulxLRb6ErdePNpnKf9PX+RWzvw401FPFW3Tgj/6RuI1XABe2/zwFGihp7UYK8A
         qFEuuVlidaP5GEOhjd/2VLagU2MjcEu6nPICwQp7lTdIspZjHTuWpXvrIpiSFBaU16Xq
         AmBsWOH2sMoViJO0LuN7Dn2mDISNUmQZoKfKkdp5Xzq2f1a/ORizRU4SVHnAGROTkdXs
         F2kXghADcFEHLAQd7loWmzAYMqOBFvJGZ631mTxqtYFUJKaLypUumx2/shnq9VjzAVSx
         Pbqv+wsh/r5FkT+z5WxSLq0soyEAtyrPuEDVF7zvEZ0fqi8p5vQFjMPdhwC+8+cba9aL
         J5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VA5WMUBCQaBZijA3RMGledp+Muz3yfsvc2v9AgiacX4=;
        b=oM6Ffb1LM6PkmsmcdRFSpT3hlGwX8w7kUkKT5g/tbeNPV6J0H/Y+2qEpEiVLYg+F8z
         vObYVxCzaetbcGVl9UmSt7HiVm65GMbul8t0CwSkfhtSp9WX0ciWzCUe3Qn6Yy2CvwFj
         4ckJPdhW679We0PrFEEL/wA8xVYzOZlnGTUuOLbm72B/g7gD2i3PneYAoD7CnX8OOYOx
         y6HRnNL9dJD3er7O5MxN5wrVUfux1NH0qdmcTtpetRyXNQyJR9NcQWZO0jij03Llmehf
         UxUs8SvinZjzfgQpkUWYK+jIEvpyl035CfBz6Uh/mko/DgS6yvBtwAiHZ1FYNR6hARp/
         bDDw==
X-Gm-Message-State: ACrzQf1GDDuJnzfw3LCFTlz8SB75ppEC0ukCHgGVGoEiaXH+y2Htub7F
        kCBMo8mScOf5nji+ffc1PaM=
X-Google-Smtp-Source: AMsMyM6EV8jn2uSgK1bSR6HgJx7ts1FVPy3sfB/SZy7ostAo0TGJha8waZYasKthJLX9G7+emrggug==
X-Received: by 2002:a17:902:c745:b0:186:b287:7d02 with SMTP id q5-20020a170902c74500b00186b2877d02mr4349931plq.87.1667049074934;
        Sat, 29 Oct 2022 06:11:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:14 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/9] net: tcp: use the drop reasons stored in tcp_skb_cb
Date:   Sat, 29 Oct 2022 21:09:51 +0800
Message-Id: <20221029130957.1292060-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221029130957.1292060-1-imagedong@tencent.com>
References: <20221029130957.1292060-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

The drop reasons for skb can be stored in tcp_skb_cb in some function
when it needs to be dropped. The following functions will do it in the
latter commits:

  tcp_rcv_state_process
  tcp_conn_request
  tcp_rcv_state_process
  tcp_timewait_state_process
  tcp_rcv_synsent_state_process

Now, we initialize the drop_reason in tcp_skb_cb to
SKB_DROP_REASON_NOT_SPECIFIED. try_kfree_skb() should be used if any code
path makes the drop_reason to SKB_NOT_DROPPED_YET. Don't try to set it
to SKB_NOT_DROPPED_YET if the skb has any posibility to be dropped later.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_ipv4.c | 15 +++++++++++++--
 net/ipv6/tcp_ipv6.c | 20 ++++++++++++++++----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 87d440f47a70..a85bc7483c5a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1693,6 +1693,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 			goto discard;
 		if (nsk != sk) {
 			if (tcp_child_process(sk, nsk, skb)) {
+				reason = TCP_SKB_CB(skb)->drop_reason;
 				rsk = nsk;
 				goto reset;
 			}
@@ -1702,6 +1703,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 
 	if (tcp_rcv_state_process(sk, skb)) {
+		reason = TCP_SKB_CB(skb)->drop_reason;
 		rsk = sk;
 		goto reset;
 	}
@@ -1945,6 +1947,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	int ret;
 
 	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	TCP_SKB_DR(skb, NOT_SPECIFIED);
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -2050,6 +2053,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
 		} else if (tcp_child_process(sk, nsk, skb)) {
+			drop_reason = TCP_SKB_CB(skb)->drop_reason;
 			tcp_v4_send_reset(nsk, skb);
 			goto discard_and_relse;
 		} else {
@@ -2136,6 +2140,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
+free_it:
+	drop_reason = TCP_SKB_CB(skb)->drop_reason;
+	try_kfree_skb(skb, drop_reason);
+	return 0;
+
 discard_and_relse:
 	sk_drops_add(sk, skb);
 	if (refcounted)
@@ -2171,6 +2180,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		/* TCP_FLAGS or NO_SOCKET? */
+		TCP_SKB_DR(skb, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
@@ -2180,10 +2191,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	case TCP_TW_RST:
 		tcp_v4_send_reset(sk, skb);
 		inet_twsk_deschedule_put(inet_twsk(sk));
-		goto discard_it;
+		goto free_it;
 	case TCP_TW_SUCCESS:;
 	}
-	goto discard_it;
+	goto free_it;
 }
 
 static struct timewait_sock_ops tcp_timewait_sock_ops = {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f676be14e6b6..2c2048832714 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1515,8 +1515,10 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			goto discard;
 
 		if (nsk != sk) {
-			if (tcp_child_process(sk, nsk, skb))
+			if (tcp_child_process(sk, nsk, skb)) {
+				reason = TCP_SKB_CB(skb)->drop_reason;
 				goto reset;
+			}
 			if (opt_skb)
 				__kfree_skb(opt_skb);
 			return 0;
@@ -1524,8 +1526,10 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	} else
 		sock_rps_save_rxhash(sk, skb);
 
-	if (tcp_rcv_state_process(sk, skb))
+	if (tcp_rcv_state_process(sk, skb)) {
+		reason = TCP_SKB_CB(skb)->drop_reason;
 		goto reset;
+	}
 	if (opt_skb)
 		goto ipv6_pktoptions;
 	return 0;
@@ -1615,6 +1619,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 
 	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	TCP_SKB_DR(skb, NOT_SPECIFIED);
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1711,6 +1716,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			reqsk_put(req);
 			tcp_v6_restore_cb(skb);
 		} else if (tcp_child_process(sk, nsk, skb)) {
+			drop_reason = TCP_SKB_CB(skb)->drop_reason;
 			tcp_v6_send_reset(nsk, skb);
 			goto discard_and_relse;
 		} else {
@@ -1792,6 +1798,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
+free_it:
+	drop_reason = TCP_SKB_CB(skb)->drop_reason;
+	try_kfree_skb(skb, drop_reason);
+	return 0;
+
 discard_and_relse:
 	sk_drops_add(sk, skb);
 	if (refcounted)
@@ -1832,6 +1843,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		TCP_SKB_DR(skb, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
@@ -1841,11 +1853,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	case TCP_TW_RST:
 		tcp_v6_send_reset(sk, skb);
 		inet_twsk_deschedule_put(inet_twsk(sk));
-		goto discard_it;
+		goto free_it;
 	case TCP_TW_SUCCESS:
 		;
 	}
-	goto discard_it;
+	goto free_it;
 }
 
 void tcp_v6_early_demux(struct sk_buff *skb)
-- 
2.37.2

