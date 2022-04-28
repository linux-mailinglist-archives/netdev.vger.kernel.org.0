Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC505131CE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344950AbiD1LBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344954AbiD1LBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C54D95A08;
        Thu, 28 Apr 2022 03:57:43 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso2805540wms.2;
        Thu, 28 Apr 2022 03:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=qJj/oEv/OB0rSmn1HTfjjWX7JmMm0LqkE6Ny+wD7ffBQC9IwmtfWkhybcuDNEKLSXH
         1TMbuqCT83AoqUhe0LltembCNXjptESab1BWgXO0WjFJpyHinrhpFfsU0pf5GxnCzss7
         /iS3bE5EkMLqPCWo5ovhnxxIu4v4QAW+fXwCxiIBBWBlOIYJaxW8thByM0Wrab3KC4lJ
         tDxaDqVFn/gK4R+3UCX0j/0xuo26zp+gQtCONKguTflJCOt5OAYbqj9hUtdzfjP5AEnR
         +qr/l1lg3MIMDaXE8lRF0C/CS2I1wUWxxpzlzrmLSlHBhkF9g5diiUeOciwhICsMKRO/
         AKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDy/baqCrS7ciidt4u0hxQhcY5iVuejvnMqLkeL0Gp4=;
        b=23c5l4vL3Emz16QgrNQAPaBXA/gShOoeZ5X6x8XHX7LafE/B3eyOJdH0o4NcakfwR2
         hka75KgkodibG83zAvhxwWwVrpZ1ZmkzGwHYihQnOQlGgDgzJ+K9Vc1v+g+Qfl6KJjR+
         JQUtZrT/l7/F+fpptvZ40norkus+mWYEBd4N6uJ6VnBWVPKZObhDHTUkqL/myOaKbLpA
         yn6kfZGMIncvWK3tD1WmQZmohQtzc0QsYDSnnJTISySCCBpiOSlrQ/RXz1q99yggN3My
         joXz+0rUPw6lsHwUXrg0RJ5zSqaxg2hs+UzioOOMoX/6N53TdJUqjjSsAa4pliL60tXp
         VWhQ==
X-Gm-Message-State: AOAM533PBcuSfqejjue6+ygf711/BzcSEH5z1xRKki9A0OvoqGOQMO6e
        6nAyvqhSoLNQAGSqNwNbo439O0q2vjc=
X-Google-Smtp-Source: ABdhPJySLzTTk7rY4bqmlhchQeKjsmfizffgksjQ+iy9cZrJzsT/UfZSHp9F6f2o7/6C5lHxwdGRkA==
X-Received: by 2002:a05:600c:3ba8:b0:393:ea84:965d with SMTP id n40-20020a05600c3ba800b00393ea84965dmr19975408wms.35.1651143461820;
        Thu, 28 Apr 2022 03:57:41 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 08/11] ipv6: partially inline fl6_update_dst()
Date:   Thu, 28 Apr 2022 11:56:39 +0100
Message-Id: <997b0b5bf91d23dc40e7002ab863ba2bd75a8ce9.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
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

