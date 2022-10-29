Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338D9612332
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJ2NMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJ2NLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4816A486;
        Sat, 29 Oct 2022 06:11:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f193so7107760pgc.0;
        Sat, 29 Oct 2022 06:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vssy2QIzKmHydtkjFhF+7Vo85h49gdfydYy5+cmw3Ec=;
        b=VecOJpnfnlcWgbsOAt8v7vlGdj9AvfBevtzjZeCqGGjrUrzbs0IEPmeJcf94/m72S1
         hiWqVPJQFsFjNAMuIKjoXmhq9OFFVhPkdS/DcnzNPIzxdclHeET0prVMIaNTT4cdnCVN
         S8ciX2rdIZsRkCgsb9heNWDw0jQXc31HV15n/3Ab75dinK7L5sjpeTA1slH3TyE5UoAU
         TWLyj2gNWNr1/iH/w9qyEf3PJF75Jba/53NLjI+orO093uZtVlPI5Odb0LthCBWZlKAP
         XLcFdqS37qUqI57NVYABzR0pK1BQfOSvCjKbFseNzm0oWOHgwCTDUIRtpmSH5mqQKpOF
         AJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vssy2QIzKmHydtkjFhF+7Vo85h49gdfydYy5+cmw3Ec=;
        b=3KKSx75o6TT/WXwthy+8sOViF4Kh4qRQteUYt+RnqTZxFb0Vdc41gP2mQxmEnbnd6z
         6cI0qLTkADKtcRZ9VQ2Wl7f4uj1NQ5e1+QOuoTyISccMv2ETLBqR8vqER5USUvI7p1iH
         kqlEqCHaC8Hgb2/AhPOOOa8YGlbhJztOkgC+JyD3zwZlfEwNJIF3ivkGIu4bSPcF2CEW
         SIO/MNwyNgFrPMzV5IaBxBpDlyraRPIIDQtwo3oEebbUAOy6jBCQ3/chMuHEVwgnbQ1i
         Rs1BFgqRFqIkHOCINCcP97+Wnk58MAqzQbqx0wphepXfMfsAVvR0J7F50GUc2EGkQz4J
         sVxg==
X-Gm-Message-State: ACrzQf0ASv8TsLUQ5hKQ7mDIWnHI8/ynLU/YrzIswCto7PKwyFPI73hn
        /N79GyP7PaoLLCz9v20XXJw=
X-Google-Smtp-Source: AMsMyM5c3oETS+dPiczxlxdCcqwqIW8zxQfJnhFRazM6YX5nC1ITTX09MohQzVgA0rT4DTU91M0hyg==
X-Received: by 2002:a05:6a00:1912:b0:564:f6be:11fd with SMTP id y18-20020a056a00191200b00564f6be11fdmr4492077pfi.32.1667049089869;
        Sat, 29 Oct 2022 06:11:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:29 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 7/9] net: tcp: store drop reasons in tcp_rcv_state_process()
Date:   Sat, 29 Oct 2022 21:09:55 +0800
Message-Id: <20221029130957.1292060-8-imagedong@tencent.com>
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

Store the drop reasons for skb to the tcp_skb_cb in
tcp_rcv_state_process() when it returns non-zero, which means that
the skb need to be dropped.

The new drop reasons 'TCP_ABORTONDATA' and 'TCP_ABORTONLINGER' are
added.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h | 12 ++++++++++++
 net/ipv4/tcp_input.c     | 11 +++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 633a05c95026..364811bce63f 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -72,6 +72,8 @@
 	FN(TIMEWAIT)			\
 	FN(LISTENOVERFLOWS)		\
 	FN(TCP_REQQFULLDROP)		\
+	FN(TCP_ABORTONDATA)		\
+	FN(TCP_ABORTONLINGER)		\
 	FNe(MAX)
 
 /**
@@ -324,6 +326,16 @@ enum skb_drop_reason {
 	 * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
 	 */
 	SKB_DROP_REASON_TCP_REQQFULLDROP,
+	/**
+	 * @SKB_DROP_REASON_TCP_ABORTONDATA: corresponding to
+	 * LINUX_MIB_TCPABORTONDATA
+	 */
+	SKB_DROP_REASON_TCP_ABORTONDATA,
+	/**
+	 * @SKB_DROP_REASON_TCP_ABORTONLINGER: corresponding to
+	 * LINUX_MIB_TCPABORTONLINGER
+	 */
+	SKB_DROP_REASON_TCP_ABORTONLINGER,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ad088e228b1e..e08842f999f8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6459,8 +6459,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		goto discard;
 
 	case TCP_LISTEN:
-		if (th->ack)
+		if (th->ack) {
+			TCP_SKB_DR(skb, TCP_FLAGS);
 			return 1;
+		}
 
 		if (th->rst) {
 			SKB_DR_SET(reason, TCP_RESET);
@@ -6533,8 +6535,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				      FLAG_NO_CHALLENGE_ACK) > 0;
 
 	if (!acceptable) {
-		if (sk->sk_state == TCP_SYN_RECV)
+		if (sk->sk_state == TCP_SYN_RECV) {
+			TCP_SKB_DR(skb, TCP_FLAGS);
 			return 1;	/* send one RST */
+		}
 		tcp_send_challenge_ack(sk);
 		SKB_DR_SET(reason, TCP_OLD_ACK);
 		goto discard;
@@ -6605,6 +6609,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+			TCP_SKB_DR(skb, TCP_ABORTONLINGER);
 			return 1;
 		}
 		if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
@@ -6614,6 +6619,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				tcp_fastopen_active_disable(sk);
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+			TCP_SKB_DR(skb, TCP_ABORTONDATA);
 			return 1;
 		}
 
@@ -6678,6 +6684,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
 			    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
 				NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+				TCP_SKB_DR(skb, TCP_ABORTONDATA);
 				tcp_reset(sk, skb);
 				return 1;
 			}
-- 
2.37.2

