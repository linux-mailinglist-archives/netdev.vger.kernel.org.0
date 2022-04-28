Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5400E5135FC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347878AbiD1OC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347899AbiD1OCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F054B53FD;
        Thu, 28 Apr 2022 06:58:57 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i19so9714204eja.11;
        Thu, 28 Apr 2022 06:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=Nv84QzVfOaj7yhylmcHRpG0PCFknDRzqZrfcfaKlok4O+NaLStjQE1wHTODpqlp8+Q
         hkqhAADE+Ntj/Be/Lk+ckKuD6Au2Puzk8KmwCQvf29VBjv0VAYKTEuLikXuIPpLPnubA
         818CnLl0TJxJZYJQkah7E0BkEr6RMnAZfFB+J3Q4SepACi2uqMPMWPqYF5qJWfVH9bdP
         +VCP4wXOcoYbYp1/32Hmk9Hr3sKrmueFfImZCt1cPW4nPxHxp/j05Q22TPInxROxPHbP
         BrQT8tWlbACS3e0bCehrzjdk/vuXD+UF5mOlZgKv4ceBDfGONYBHfqAv8nzBSOPE5OWi
         uoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=Tf0n+zvIPiGFyWg1BOFHjGWnt4KJ7rfYdxyNdtUaMmI/xK4ZaID9bA2a5LB5BTxf1f
         x0SJwEvG3ZLEUo3XHGCrGhD8ubX0oe+hHanKKu5HeoDqjpEmgWa0BcoVeOQ2KEaqovQd
         izgy2VPX07pKt23zkZRNrcbu/R0HmNWPH/jR5Yg26KJbS6eYs4WW0SCvV/rE0gT2dm7Z
         U99/vbmCokghiDwNkWuuVOKrIROBCABOU7358XF+PNTI7hC4/0k0ZdCwrgfo7DNqQH3X
         8rwwuxZrOV7uKY7Wlw00H88Ykw6b9ZUnDV2mJnqTQnftoLD1anGnoOla43VofIv93/22
         12iA==
X-Gm-Message-State: AOAM531iywge46f7nR3jXGVuBexP7nxpr92kHpjDbaUp3sMxha0fRiCz
        S3sbSUUpQ4XAy2G2eEDarydJICOfk78=
X-Google-Smtp-Source: ABdhPJzo88a4QiTQ8zybcIfjUzFWnrDVXK1ojqd5k6aG0Npx6wJ1wsSsE3kDmaB6COsHFE3PqvxyNQ==
X-Received: by 2002:a17:906:c147:b0:6df:f047:1677 with SMTP id dp7-20020a170906c14700b006dff0471677mr31371204ejc.4.1651154336018;
        Thu, 28 Apr 2022 06:58:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 08/11] ipv6: partially inline fl6_update_dst()
Date:   Thu, 28 Apr 2022 14:58:03 +0100
Message-Id: <997b0b5bf91d23dc40e7002ab863ba2bd75a8ce9.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
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

