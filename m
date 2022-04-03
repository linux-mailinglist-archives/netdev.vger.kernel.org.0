Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32674F09A4
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358637AbiDCNLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358589AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D19EAE52
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c7so10754530wrd.0
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZHbqEh9VJDFpVedQY3QtrqYMVk07AEtmjeXokOr+nLg=;
        b=hAa118a6tlSth1mxXI6QGB/r6rT9KjdqK06rnWMflTjmflpbXsLWNnI0vhOznT2bGw
         iB86XKJElc1bO3YiS+iCkayTIR1Rpl/ws7BUiZ+m6E9oSyx4MEfQVA0uk99RtaLOYT/R
         RHNiiPtdP2GvnftekVuT/NMdPygeG0Pv+DJZUXDaD5kIxYU8470YBi3AUIJhzmwp6oKF
         s5OYDEzEevKsTuZ/vn2ORVIRgjt1oixy3klsZBnHvGRRsb0kcePSAB7WMKV/fwXOGvdO
         iLXcOzkwQvb2hH+eb3CH9HnYSPJPKo0iuCSCkVvI+anzZGCE4W+7fLM7T7r4Kb+yiF0Q
         4u7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZHbqEh9VJDFpVedQY3QtrqYMVk07AEtmjeXokOr+nLg=;
        b=AL2armbAVyzv38IynE+Kyp4au9U0bDwblJSs8EKimzVFUuWfAhHUrIL6q09c1lZPEB
         k+NIVtceoNwzGTpGae08SppDiTc80M2coQvDmU5s5ch5g2IXuIoDN2JH+MHDmmmK0PXz
         PqCGUrBDr250elfUcLljGbxAgONXZKtlvCk68lAxDyXJ55WmLfZD8j/50nd2JdclKIUn
         0RJD2OG4GZWzZVcV96VTZrrCgXcm3SpHVmJyRJ0vumB/LyUbqzv6ZzN7Zd+LECqm3dKt
         HQgViHcPZwsdRJRJ+z41umH1t3IBpa3OGIRq49DfL2+Fr/8V7tp/DeojIAHaHEuXvrtR
         tRNg==
X-Gm-Message-State: AOAM531e0cWoNQFrP1UfErhoZj2F8fCrVFEkJQmkImmDzcKlr4VDYFqg
        D81BSbge++hmzXJ8bqLzRqx7q5LubgE=
X-Google-Smtp-Source: ABdhPJx12JZDaMqZD6265XqQvX6hlwY3lrAcAuOtaG8nksSfH2UM31AdSmdE5SNu5p+/PIADwwq6Vw==
X-Received: by 2002:a05:6000:1687:b0:205:80b7:afca with SMTP id y7-20020a056000168700b0020580b7afcamr13199136wrd.665.1648991304712;
        Sun, 03 Apr 2022 06:08:24 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 12/27] ipv6: inline ip6_local_out()
Date:   Sun,  3 Apr 2022 14:06:24 +0100
Message-Id: <8f78232221e0f6e3ae136a183f0f11cb201d1063.1648981571.git.asml.silence@gmail.com>
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

ip6_local_out() is simple, inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ipv6.h     | 13 ++++++++++++-
 net/ipv6/output_core.c | 12 ------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c..0320bea599c9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1074,7 +1074,18 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			      bool have_final);
 
 int __ip6_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
-int ip6_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
+
+static inline int ip6_local_out(struct net *net, struct sock *sk,
+				struct sk_buff *skb)
+{
+	int err;
+
+	err = __ip6_local_out(net, sk, skb);
+	if (likely(err == 1))
+		err = dst_output(net, sk, skb);
+
+	return err;
+}
 
 /*
  *	Extension header (options) processing
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 2880dc7d9a49..f657e713561b 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -151,15 +151,3 @@ int __ip6_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 		       dst_output);
 }
 EXPORT_SYMBOL_GPL(__ip6_local_out);
-
-int ip6_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
-{
-	int err;
-
-	err = __ip6_local_out(net, sk, skb);
-	if (likely(err == 1))
-		err = dst_output(net, sk, skb);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(ip6_local_out);
-- 
2.35.1

