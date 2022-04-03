Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3E64F09A1
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358647AbiDCNKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358685AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D686D1158
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:30 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c7so10754674wrd.0
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CFbFT18LoVBpsWkCx5QJjbFpMIJZnGfm91ftNPGZ6o8=;
        b=lZG5o7+jtayx39U76t/VSPCW2evRVlkyt6L0YK580aRwadkRD9iHF/hqIk1m/XiMdu
         HjJZANuV1wnaeV/wF6fYryacodWUOCH1aVPXDSNYN049A6O+QTsUK5FlWAMmdqwHaLt3
         xYlbI97dfnKvaPl7r8opP8VYjgUwoqfcFuPprKpZjCn8dB6Rc/oZopeBqL2VCjd7EvDN
         XQ6zkKCO/pxpfn8+9vkx4xvSK0Hvm31wMmChAGWnIzu4OSgPUOdyOJdcQkLH9Yt2SnBs
         y+zdTa1hUIua2uEPgnOidOwpC4mzOXXWZMFVQoRMTrnF6ZkY5P4v5pS9xxZ5OL6TYED2
         RqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFbFT18LoVBpsWkCx5QJjbFpMIJZnGfm91ftNPGZ6o8=;
        b=YdTKCKrGU01G9UbuvvnBX/oTgMAERy7i9oronM1M8FoQL/K/V2YUVo6ylKFSBE/Jj+
         31XoksKEOXeN8F8od7DMX+qdGkqwCBgp41OBHMPGHE40lmQI72uiMuXOXSkdkBUkh5e2
         r3EvbThtAFZ/UGuoTTDydy6Kwk/4sApDXmgjwJnDs0rx2MNCxzEyHxwL3e2YOUFiTtr0
         cG7aZ3YRlgSamProOzpdGrsEPV7E3Hd7YDRRkP8wbiNNVoCgjsv74c2t2S9yn4iQhwsH
         bMGpdItcdNo0/AKQ1G9FPuxmMMB4ZtEsETeoErx2Y2LMnEp6QWFRgH6eaMCM7KndzI3K
         bkIA==
X-Gm-Message-State: AOAM532eQYmf2UcX4yyZcG0NZikQlcL5TFtEsj6gb8GmLwxqQ7Rd+JQa
        JpRrjKdDFmAKiIxodPZFN9lsTT4CzJM=
X-Google-Smtp-Source: ABdhPJz3y+nl2Un9KxPO9j5qe7nBtWSnUfiUwlS/d2lhmPRstm4Y793J0ROCFVlFuex2e5rIOnNFbg==
X-Received: by 2002:a05:6000:1acb:b0:204:1ce4:7c2a with SMTP id i11-20020a0560001acb00b002041ce47c2amr13612368wry.234.1648991309351;
        Sun, 03 Apr 2022 06:08:29 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 16/27] ipv6: partially inline fl6_update_dst()
Date:   Sun,  3 Apr 2022 14:06:28 +0100
Message-Id: <1c35d43fdee5ae1de64b1bb1acea48a40eb9a6ba.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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
index 0320bea599c9..48a25f663646 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1114,9 +1114,18 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset, int target,
 
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
index 658d5eabaf7e..0b37b11cd2a9 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1365,8 +1365,8 @@ struct ipv6_txoptions *__ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 EXPORT_SYMBOL_GPL(__ipv6_fixup_options);
 
 /**
- * fl6_update_dst - update flowi destination address with info given
- *                  by srcrt option, if any.
+ * __fl6_update_dst - update flowi destination address with info given
+ *                    by srcrt option.
  *
  * @fl6: flowi6 for which daddr is to be updated
  * @opt: struct ipv6_txoptions in which to look for srcrt opt
@@ -1375,13 +1375,10 @@ EXPORT_SYMBOL_GPL(__ipv6_fixup_options);
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
@@ -1403,4 +1400,4 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
 
 	return orig;
 }
-EXPORT_SYMBOL_GPL(fl6_update_dst);
+EXPORT_SYMBOL_GPL(__fl6_update_dst);
-- 
2.35.1

