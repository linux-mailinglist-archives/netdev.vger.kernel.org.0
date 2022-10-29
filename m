Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9958612331
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJ2NMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJ2NLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B926969F55;
        Sat, 29 Oct 2022 06:11:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d24so7119258pls.4;
        Sat, 29 Oct 2022 06:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e72HAxh6P1H/A+cQtAP2/BT2cWTj2acR1HBaWNLsTXA=;
        b=VZh6IoGsSJ9GAYWi9Zk0dr97OxI3Vz3zTfp1PMZvYKSN/yx/b5KS1OVwQt1XtVBqiR
         O5lt41RqRL89Q+k4OyGmGtIuaoHh7C5MqXVNIqvHorQXpTTMUWXXpG6Qnb24pKS1y1YU
         2lg18XhZnWrf2tLMQpPuhrYEsF2S6ND6Eyq26EROoGxA3fxi/Ei9YaDqvgz+60An5SRt
         ltKetpBK2Wu0FUdGgKxhNrSEhL+Z55W9OYnORaOIrZ/JTo1rYX5BhikzFGOvEPHKncds
         n178NpTfNG+QMppI7dX9Vr4DyWyr256PyJy1qETGe7Na6eJ5pVvx9AI8M44Z91vNz/D6
         Gv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e72HAxh6P1H/A+cQtAP2/BT2cWTj2acR1HBaWNLsTXA=;
        b=QG/5UuezcVQy9cJDxh1/b3EgqXp5Kf8MVFf90QZAQNcKyK/+igNj/Eqk897xtXY1oG
         SQlOF+mAqf6DAdFMEwOta+W979VVR6d1nu14JuOCrA3hzbl/z6mGjw2ZzF6KY4mAyXpT
         0fsWlTNHdIx+tya8ZUwCxj0PNGtrsnonsQ5aNQ6aid95FSI+rt2PncAArxChfwN0/aMG
         4NE6T9mgojgXVkeECRaQCia5cOnsbEko5tv/4p5zbHXg1dcBL77PZw9SmryfLoXvT9lp
         F3unrT32+XvzB21qAC0gm+fXKi5SEZoUNoHIMDU2YcR91Snyw6ft/Riy2knfl5nwbjpm
         X1TQ==
X-Gm-Message-State: ACrzQf2yq5yu5IdZIUneUcQP30g2T+2S1lRHE4lMjGNCA0f38LYS3WDS
        XkPWqoKpq6ByeM78AQjNBYo=
X-Google-Smtp-Source: AMsMyM5IfK8MomSFw/Cm2DxK/QnTTJcaBS+TxB/kKEmJilFvMU0LIdbOgUbS5Q551CHTE52LvEE7qw==
X-Received: by 2002:a17:902:f789:b0:17f:8cb6:7da3 with SMTP id q9-20020a170902f78900b0017f8cb67da3mr4225755pln.167.1667049086249;
        Sat, 29 Oct 2022 06:11:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:25 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 6/9] net: tcp: store drop reasons in tcp_conn_request()
Date:   Sat, 29 Oct 2022 21:09:54 +0800
Message-Id: <20221029130957.1292060-7-imagedong@tencent.com>
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

Store the skb drop reasons to tcp_skb_cb for tcp_conn_request(). When
the skb should be freed normally, 'TCP_SKB_CB(skb)->drop_reason' will be
set to SKB_NOT_DROPPED_YET, which means consume_skb() will be called for
the skb.

Now, we can replace the consume_skb() with try_kfree_skb() in
tcp_rcv_state_process() if the skb needs to be dropped.

The new drop reasons 'LISTENOVERFLOWS' and 'TCP_REQQFULLDROP' are added,
which are used for 'accept queue' and 'request queue' full.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
--
---
 include/net/dropreason.h | 12 ++++++++++++
 net/ipv4/tcp_input.c     | 11 +++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index cbfd88493ef2..633a05c95026 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -70,6 +70,8 @@
 	FN(PKT_TOO_BIG)			\
 	FN(TCP_PAWSACTIVEREJECTED)	\
 	FN(TIMEWAIT)			\
+	FN(LISTENOVERFLOWS)		\
+	FN(TCP_REQQFULLDROP)		\
 	FNe(MAX)
 
 /**
@@ -312,6 +314,16 @@ enum skb_drop_reason {
 	 * 'SYN' packet
 	 */
 	SKB_DROP_REASON_TIMEWAIT,
+	/**
+	 * @SKB_DROP_REASON_LISTENOVERFLOWS: accept queue of the listen
+	 * socket is full, corresponding to LINUX_MIB_LISTENOVERFLOWS
+	 */
+	SKB_DROP_REASON_LISTENOVERFLOWS,
+	/**
+	 * @SKB_DROP_REASON_TCP_REQQFULLDROP: request queue of the listen
+	 * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
+	 */
+	SKB_DROP_REASON_TCP_REQQFULLDROP,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c0e5c4a29a4e..ad088e228b1e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6482,7 +6482,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 			if (!acceptable)
 				return 1;
-			consume_skb(skb);
+
+			reason = TCP_SKB_CB(skb)->drop_reason;
+			try_kfree_skb(skb, reason);
 			return 0;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
@@ -6928,12 +6930,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	 */
 	if ((syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
-		if (!want_cookie)
+		if (!want_cookie) {
+			TCP_SKB_DR(skb, TCP_REQQFULLDROP);
 			goto drop;
+		}
 	}
 
 	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		TCP_SKB_DR(skb, LISTENOVERFLOWS);
 		goto drop;
 	}
 
@@ -6991,6 +6996,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			TCP_SKB_DR(skb, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7005,6 +7011,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			inet_rsk(req)->ecn_ok = 0;
 	}
 
+	TCP_SKB_CB(skb)->drop_reason = SKB_NOT_DROPPED_YET;
 	tcp_rsk(req)->snt_isn = isn;
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	tcp_rsk(req)->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
-- 
2.37.2

