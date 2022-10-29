Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC82861232C
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJ2NLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ2NLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4EA691A6;
        Sat, 29 Oct 2022 06:11:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q1so7042962pgl.11;
        Sat, 29 Oct 2022 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT7TXRUVve09bvGpQVooCnQqDIlFLDJNPk73T/NQyZ4=;
        b=EILN7IQF8JSD9YT6/do0bu89xzeyB6mPrqpeWmgf5nalrduu8cHcaQRbRv1V7daZLE
         itAt/7YgcG19WXbhHwzw6UNg/aqKI6zANd34a4BPYnyt94wK4OalEpkbu5g3AKXFSHcK
         SsYowF0i+LUsHEK4J+hYxVPghXzGcadS98G+2ZoYHK/WWIOtTzWQnwqUfABgny3rrcgA
         NJwY/Q9gVW91jwUkng0O5zeF9EEtueUbSvK2OVI0RtBpv7IJ4PDQwZIQ0DTLqV6RbGPq
         BpY1iKI3DebgFY7zIlkVWXp7MAfxzl0PH2XmiHoChg3PNINpUPENLHKvlEqFeL9KtA7a
         Tu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QT7TXRUVve09bvGpQVooCnQqDIlFLDJNPk73T/NQyZ4=;
        b=JduD5/QUJ42mbBeol8QQBQi87E1IyzwAVzq00hYupPgd1hxl3/c0ymMp6XSeQME6lP
         TdNWPMVTZb6OuysBXAyRdtZkdkH4w4tkU6hNs9/feuk73EW7r++W8G66SufIp41qb/Sh
         FNsObUhJ6QDgsvfABymzItMHpwLaSzu6/hUZK6K1RYqso8TqfXrDSmll33a4BeCtlZsG
         iDHzbWT+qIav6trXN580AT9SnrBWbn8IJRUX4dzuQve010QduEBsuE4MGNjm+uJ7L+IR
         4wZIvD5v90V+r9sVmhg7+gcXSFREWICWp/3YTehNlRF884SSxlyfNBa9JgD2UrrDdASQ
         T15g==
X-Gm-Message-State: ACrzQf2F7Kxv547C9NwP2o5Yalew4AX/BvBtkbaT1pfQjghGR2ev/te8
        2b2JtSVwB5jYbEZdkHXT7Lg=
X-Google-Smtp-Source: AMsMyM4/KOUewUvEFkgE0q22q1nulfsnLiVxM0ZidWFBY6mUxV8vTGFXMIiXlbOjSTXJvELNZECpAw==
X-Received: by 2002:a65:5583:0:b0:461:25fe:e982 with SMTP id j3-20020a655583000000b0046125fee982mr4005524pgs.4.1667049078560;
        Sat, 29 Oct 2022 06:11:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:18 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/9] net: tcp: store drop reasons in tcp_rcv_synsent_state_process()
Date:   Sat, 29 Oct 2022 21:09:52 +0800
Message-Id: <20221029130957.1292060-5-imagedong@tencent.com>
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

The skb drop reasons for the 'reset' code path in
tcp_rcv_synsent_state_process() is not handled yet. Now, we can store the
drop reason to tcp_skb_cb for such case.

The new reason 'TCP_PAWSACTIVEREJECTED' is added, which is corresponding
to LINUX_MIB_PAWSACTIVEREJECTED.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h | 7 +++++++
 net/ipv4/tcp_input.c     | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c1cbcdbaf149..0f0edcd5f95f 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -68,6 +68,7 @@
 	FN(IP_INADDRERRORS)		\
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
+	FN(TCP_PAWSACTIVEREJECTED)	\
 	FNe(MAX)
 
 /**
@@ -298,6 +299,12 @@ enum skb_drop_reason {
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/**
+	 * @SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED: PAWS check failed for
+	 * active TCP connection, corresponding to
+	 * LINUX_MIB_PAWSACTIVEREJECTED
+	 */
+	SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54..c0e5c4a29a4e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6195,6 +6195,10 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 				inet_csk_reset_xmit_timer(sk,
 						ICSK_TIME_RETRANS,
 						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
+			if (after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+				TCP_SKB_DR(skb, TCP_ACK_UNSENT_DATA);
+			else
+				TCP_SKB_DR(skb, TCP_TOO_OLD_ACK);
 			goto reset_and_undo;
 		}
 
@@ -6203,6 +6207,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			     tcp_time_stamp(tp))) {
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_PAWSACTIVEREJECTED);
+			TCP_SKB_DR(skb, TCP_PAWSACTIVEREJECTED);
 			goto reset_and_undo;
 		}
 
-- 
2.37.2

