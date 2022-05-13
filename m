Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE89526615
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382058AbiEMP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382009AbiEMP1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8E020BE8;
        Fri, 13 May 2022 08:26:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so16892158ejj.10;
        Fri, 13 May 2022 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=LshU9/1jjUekd5qQFD1YNEmSfgMX1tJfwK7Tg8HB9IDHIC/4Cqy4riAvjUXzsdNyqQ
         Ted+HL9KvDDc2CZRpgZkYBGna+48T5y7uakRkzQzZ6Fwx8imlTaLLrC+oOFJsHNTP9sd
         EHxg/1j9u90pci2DBZDbWcHtK58qAiUaTf8kU7MqW840m01gOR6kDGANYyDFhTR4uzvT
         fi4RP7fr7NiasnAhAtFxpC1C7EbMpUuFF1MHh+CSrccv4tsGPGsZxo27yoA13nlV+UGa
         i68rs3I7mNlDeOYYbJ6Ukk7C01n+sc3cmGGYXH1Wz39XN27BrSU8yA5XZJzjTLTbMxHA
         hY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=n8b9Vrk5ugN1UbqMnm0p4V6JSqFO0kGOx0BIzlBDO/aplSB04x+i6JWqH9rgnju75o
         tOMLWYX6cQzrgvNdpb7OF3hBkpw3Zk+n5ORJ3sBIBKKPV3ePldU09Kuqr3bnK9KJuw0R
         YyfSkWgsKemmRZpwckCMChQd0cjNs61P5R+sCuw1ndakeuCdhy1n9CrlYnOD+cwNLF82
         ijdXidgGztgnAuizUJuw/gW3poYvuCtRFOsq3ksnKLXUwgZ9+8lQG/l1hFoZYpNaK1hq
         LpnSqkCpYsw/gGaVhDPbsWH86JbouiTqn7QcdpvQvjVgb5witBJiyOp7WquTDsWuslT6
         OFiQ==
X-Gm-Message-State: AOAM532OGAWahX44fKoEI7+35AM3kt5jYWgK5PpKwGapejPYJmNSwEkL
        uXa3fkiJdhkN/iPlnzjmvzItaFZ8tSE=
X-Google-Smtp-Source: ABdhPJz5350Z2tA4TxG8Yw5oq2blWgH73d4InzjH5+r8bz9pmoG2c1KIe8Vb5YI1WKtAFpZzeGlKIQ==
X-Received: by 2002:a17:907:90cf:b0:6f4:346f:f771 with SMTP id gk15-20020a17090790cf00b006f4346ff771mr4699837ejb.574.1652455614559;
        Fri, 13 May 2022 08:26:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 07/10] ipv6: partially inline fl6_update_dst()
Date:   Fri, 13 May 2022 16:26:12 +0100
Message-Id: <149e1cc1fea227e687ab63c2f33a7b314ecb91f0.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
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

fl6_update_dst() doesn't do anything when there are no opts passed.
Inline the null checking part.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ipv6.h | 15 ++++++++++++---
 net/ipv6/exthdrs.c | 15 ++++++---------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 30a3447e34b4..b9848fcd6954 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1094,9 +1094,18 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset, int target,
 
 int ipv6_find_tlv(const struct sk_buff *skb, int offset, int type);
 
-struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
-				const struct ipv6_txoptions *opt,
-				struct in6_addr *orig);
+struct in6_addr *__fl6_update_dst(struct flowi6 *fl6,
+				  const struct ipv6_txoptions *opt,
+				  struct in6_addr *orig);
+
+static inline struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
+					      const struct ipv6_txoptions *opt,
+					      struct in6_addr *orig)
+{
+	if (!opt || !opt->srcrt)
+		return NULL;
+	return __fl6_update_dst(fl6, opt, orig);
+}
 
 /*
  *	socket options (ipv6_sockglue.c)
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a8d961d3a477..d02c27d4f2c2 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1367,8 +1367,8 @@ struct ipv6_txoptions *__ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 EXPORT_SYMBOL_GPL(__ipv6_fixup_options);
 
 /**
- * fl6_update_dst - update flowi destination address with info given
- *                  by srcrt option, if any.
+ * __fl6_update_dst - update flowi destination address with info given
+ *                    by srcrt option.
  *
  * @fl6: flowi6 for which daddr is to be updated
  * @opt: struct ipv6_txoptions in which to look for srcrt opt
@@ -1377,13 +1377,10 @@ EXPORT_SYMBOL_GPL(__ipv6_fixup_options);
  * Returns NULL if no txoptions or no srcrt, otherwise returns orig
  * and initial value of fl6->daddr set in orig
  */
-struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
-				const struct ipv6_txoptions *opt,
-				struct in6_addr *orig)
+struct in6_addr *__fl6_update_dst(struct flowi6 *fl6,
+				  const struct ipv6_txoptions *opt,
+				  struct in6_addr *orig)
 {
-	if (!opt || !opt->srcrt)
-		return NULL;
-
 	*orig = fl6->daddr;
 
 	switch (opt->srcrt->type) {
@@ -1405,4 +1402,4 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
 
 	return orig;
 }
-EXPORT_SYMBOL_GPL(fl6_update_dst);
+EXPORT_SYMBOL_GPL(__fl6_update_dst);
-- 
2.36.0

