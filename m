Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C875B4FF272
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiDMIq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiDMIqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789D651E4E;
        Wed, 13 Apr 2022 01:44:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 12so1347604pll.12;
        Wed, 13 Apr 2022 01:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nn5ehz1JljjQt7PVKp4W3PCmW0VJQ3wpLAJidr2EZYs=;
        b=PlFjF35CJhi08uwawPP8dRPtW+tR+6lJc9E+xeHa/Cf6Zt9FjNUFK8weQHJx79koic
         AAZ43x2AkSDzQNPoJMC/HUT8ay0QWLwbg07AI/L2Bqb2ZvPmSR01MQdxhGOZg1eLR57z
         MvUhe0ebNoEr0Kf36pSluApG9Fw0YEE9ChE8mgz/IUo97nQcAKbwa6B1TMV4D3F1pqoa
         VxB5i5F/CpLw9oKzitSD0OaO17V71Pub4qzMku17CiyTf8aNqD3u4yEA3v9ueKjnr+RS
         CzTd9lBzZa9G6yKC7eDmEX/uLIRFfVH0LNRtPci2maQDPKXOuLz1ErkoUOa/mclF0su/
         e42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn5ehz1JljjQt7PVKp4W3PCmW0VJQ3wpLAJidr2EZYs=;
        b=tHJobACOLg6nVXL585qGxST1e9Rg64iLwCZsOQSKOCWk53Xf4Q1p0VUcq0WZEsZYdP
         Lc5vZAod+VHRfpz7guDIKP8+RJePQDOrP2eEnSWXzpW1UZCvOG7OhxBl5Bbk0rT6mly1
         f++JaNN4R7/s+XM2iEw9BSTee6PFJWASeSH0cC3kZkW5RqvfS7tcfoOqKv1y+QPmo3rk
         BR+QPDKFgFwnzRkvG7/ytW+3pIkPx0F6swZz0HRJ7kxJQ6hMg65xzDyh1279N1OAH5To
         qWaXmr/vmNFcFDKqrJ3YoeLWbfC402RdJquMQ23OaFa4friOiBlWAvGHz9OdtUc4vnvr
         5GwQ==
X-Gm-Message-State: AOAM532A2IOyyWu5QlwvffxDiF5OodsXO/+JHAXS4u39UEH8wEpPlVly
        IwWROiZQh4ya8aHNCTueGZw=
X-Google-Smtp-Source: ABdhPJypLUHh89foqY9qeVvhHumtO4WjZ7j/ZWCWVVQCnp7lvugij82PIvDmTN6s0div6fPSJCjVTw==
X-Received: by 2002:a17:902:d88a:b0:156:1609:1e62 with SMTP id b10-20020a170902d88a00b0015616091e62mr41577476plz.143.1649839450332;
        Wed, 13 Apr 2022 01:44:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:09 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 5/9] net: icmp: introduce function icmpv6_param_prob_reason()
Date:   Wed, 13 Apr 2022 16:15:56 +0800
Message-Id: <20220413081600.187339-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
References: <20220413081600.187339-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

In order to add the skb drop reasons support to icmpv6_param_prob(),
introduce the function icmpv6_param_prob_reason() and make
icmpv6_param_prob() an inline call to it. This new function will be
used in the following patches.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 include/linux/icmpv6.h | 11 +++++++++--
 net/ipv6/icmp.c        |  7 ++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 9055cb380ee2..db0f4fcfdaf4 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -79,8 +79,9 @@ extern int				icmpv6_init(void);
 extern int				icmpv6_err_convert(u8 type, u8 code,
 							   int *err);
 extern void				icmpv6_cleanup(void);
-extern void				icmpv6_param_prob(struct sk_buff *skb,
-							  u8 code, int pos);
+extern void				icmpv6_param_prob_reason(struct sk_buff *skb,
+								 u8 code, int pos,
+								 enum skb_drop_reason reason);
 
 struct flowi6;
 struct in6_addr;
@@ -91,6 +92,12 @@ extern void				icmpv6_flow_init(struct sock *sk,
 							 const struct in6_addr *daddr,
 							 int oif);
 
+static inline void icmpv6_param_prob(struct sk_buff *skb, u8 code, int pos)
+{
+	icmpv6_param_prob_reason(skb, code, pos,
+				 SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 static inline bool icmpv6_is_err(int type)
 {
 	switch (type) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 01c8003c9fc9..61770220774e 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -629,12 +629,13 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 }
 EXPORT_SYMBOL(icmp6_send);
 
-/* Slightly more convenient version of icmp6_send.
+/* Slightly more convenient version of icmp6_send with drop reasons.
  */
-void icmpv6_param_prob(struct sk_buff *skb, u8 code, int pos)
+void icmpv6_param_prob_reason(struct sk_buff *skb, u8 code, int pos,
+			      enum skb_drop_reason reason)
 {
 	icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL, IP6CB(skb));
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 }
 
 /* Generate icmpv6 with type/code ICMPV6_DEST_UNREACH/ICMPV6_ADDR_UNREACH
-- 
2.35.1

