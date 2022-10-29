Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AE861232E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJ2NLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJ2NLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C038E69ED9;
        Sat, 29 Oct 2022 06:11:22 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y4so7127583plb.2;
        Sat, 29 Oct 2022 06:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJ08uRmM1fk/kBxamD2GYhMoonJypcExaYdhAS5+vYY=;
        b=gQKasM9QfgTopmhCKxXkRzTulCfogWPr90HNVnkgnOIkOhfqdXLH/Fc3jYFRQ//Ah1
         jEcGUQGAxoNaJk9Kw5jSJqdsKSbV4nu1R+A4SBTM3lRUDx5VYrPE4T0UlQ8bPT/krtCN
         FPq7Wt0xrHFx2NpQcAIHdDgs/hTayfP11UBUZnEqz1KnMhZsGO4G1LNpgOB613YGdsW4
         1fcTyLekvGLTKNz5Ki3x65HyTyu5b8BkkFrLyxiTXsf9nFTwCtJuHjKKtoUUQpWZWwr1
         /rLEw25C6TE5/Y5MecROd6FvvF7pmBc/uFea+/wMI5E8ZC5uXpoZu7FAHXG7Sb0Hbtts
         R2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJ08uRmM1fk/kBxamD2GYhMoonJypcExaYdhAS5+vYY=;
        b=C9IkDKhv6sorzzCn+PFzwPkpBu9/hw+6mDqUmnPI1ZmqTrOhL7i9Wy31q3e2ep3EoJ
         WatV3O0RYQXSaur1QFpH/avqkAcGdFa2XDBo0b+9evqUdE4YlzzL4DlFcwlJDBAt8BSJ
         4HNp30LPNIqggHshpG4z+jYhF6CF66G48GTF4txhlKFjxkGAw8FwOr+npzbLEnzo3etq
         iKDblmPzuHN5aukgidcgQCXgiil18SVy6D7paDGm7Seag0mfnAJoBtw47ZKSoH6Vj1bk
         9VTrmcZAWD91n+2ak3phURwWr2zBgiIIf1iWlwPAYJ3Eil1L9QXvA9sHvEmgjATcH0hJ
         RiMw==
X-Gm-Message-State: ACrzQf3sb1+lkLYITJNI4Te7emq9KesugY7QVzoHIzHODwqk3YgulyhY
        OeMz0P5R21ttd+ge4sEDZsoeE01OsdM=
X-Google-Smtp-Source: AMsMyM5R6pNxRLjYxw2yNEDVPMkwLmqPgIDtbt6yMk7E4UHdwd9eGL3yF3Fy9DvKzcEyG209tfJoeg==
X-Received: by 2002:a17:902:b598:b0:184:e49d:3042 with SMTP id a24-20020a170902b59800b00184e49d3042mr4361859pls.16.1667049082221;
        Sat, 29 Oct 2022 06:11:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:21 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 5/9] net: tcp: store drop reasons in tcp_timewait_state_process()
Date:   Sat, 29 Oct 2022 21:09:53 +0800
Message-Id: <20221029130957.1292060-6-imagedong@tencent.com>
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

Store the drop reason to the tcp_skb_cb in tcp_timewait_state_process()
when the skb is going to be dropped. The new drop reason 'TIMEWAIT' is
added.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h |  7 +++++++
 net/ipv4/tcp_minisocks.c | 15 +++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 0f0edcd5f95f..cbfd88493ef2 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -69,6 +69,7 @@
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
 	FN(TCP_PAWSACTIVEREJECTED)	\
+	FN(TIMEWAIT)			\
 	FNe(MAX)
 
 /**
@@ -305,6 +306,12 @@ enum skb_drop_reason {
 	 * LINUX_MIB_PAWSACTIVEREJECTED
 	 */
 	SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED,
+	/**
+	 * @SKB_DROP_REASON_TIMEWAIT: socket is in time-wait state and all
+	 * packet that received will be treated as 'drop', except a good
+	 * 'SYN' packet
+	 */
+	SKB_DROP_REASON_TIMEWAIT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c375f603a16c..e1963394dc4a 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -113,11 +113,16 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			return tcp_timewait_check_oow_rate_limit(
 				tw, skb, LINUX_MIB_TCPACKSKIPPEDFINWAIT2);
 
-		if (th->rst)
+		if (th->rst) {
+			TCP_SKB_DR(skb, TCP_RESET);
 			goto kill;
+		}
 
-		if (th->syn && !before(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt))
+		if (th->syn && !before(TCP_SKB_CB(skb)->seq,
+				       tcptw->tw_rcv_nxt)) {
+			TCP_SKB_DR(skb, TCP_FLAGS);
 			return TCP_TW_RST;
+		}
 
 		/* Dup ACK? */
 		if (!th->ack ||
@@ -143,6 +148,9 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		}
 
 		inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
+
+		/* skb should be free normally on this case. */
+		TCP_SKB_CB(skb)->drop_reason = SKB_NOT_DROPPED_YET;
 		return TCP_TW_ACK;
 	}
 
@@ -174,6 +182,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * protocol bug yet.
 			 */
 			if (!READ_ONCE(twsk_net(tw)->ipv4.sysctl_tcp_rfc1337)) {
+				TCP_SKB_DR(skb, TCP_RESET);
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
@@ -232,9 +241,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		if (paws_reject || th->ack)
 			inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
 
+		TCP_SKB_DR(skb, TIMEWAIT);
 		return tcp_timewait_check_oow_rate_limit(
 			tw, skb, LINUX_MIB_TCPACKSKIPPEDTIMEWAIT);
 	}
+	TCP_SKB_DR(skb, TCP_RESET);
 	inet_twsk_put(tw);
 	return TCP_TW_SUCCESS;
 }
-- 
2.37.2

