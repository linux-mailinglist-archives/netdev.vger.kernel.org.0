Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99188522A98
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbiEKDzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241266AbiEKDzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:55:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9818F218FFE
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so3746410pju.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HVRP118ZOlUZuoG/hDkho2/EllajCBtZWJSv42QBoCc=;
        b=GEO29e6cFLU3C6rQeRvcHHx1B7Gl6areArEPEnkD1l5qphc906h2sIwiQ9NEQT3nxy
         hnqzbFtx/vuGJLQlvdprTdtvWNTrHhwoY3C4BKHov0yQYeFQb7vB7W02Zx/MJLmHLzIm
         0waUvGXOJQ5G3GNz0yafi51anAAeRtIfzso7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HVRP118ZOlUZuoG/hDkho2/EllajCBtZWJSv42QBoCc=;
        b=NKMq72hAsdqKy6J1LD1fYVshJZP1pGB61sUem9/X0Ts+VnaWK5/zSbg+l+Hkx+yB9p
         9MHfQEHpXh1CqrHCvCMQ71GJs9f6DXcP20Q7bnuZxGLhTjfG181Hgtsr6/pT51wzkNAM
         V466yu9eHVdJNMDHsGvwTHrqQ8DFmCJHH+vaB2mnOSoootCpBZjMiVRIknEWj+ZRlLou
         BW4LlCq247ffCN4IY/b8ssoIOhObcJE5Xy2Hr/Bk1rNHLZgN+LbPYI+/LCGwbj8tdARt
         Hp939jmFAbUEcI307PAk72iYN4bzT/GYaj4/RhQq35HSU5uH+FLCIgOzVseEzV5trBca
         Ozjg==
X-Gm-Message-State: AOAM5338Eu/EI6MJhu5D2SngGUhreyzRHral+hWICQQ8h4Ysqfp/BFMu
        fg692t1xf0vFPhT6ZF0MtzGdeh8FAaxQMcGK0WJeYenjylqyA86mTotnVXpqZdF//7rstatr4Lg
        tLyxWfM0S0bPLhRit6xUzKaPodgm69GUFRUJVSnz2L0b1c/T7VkAulH7l0wOx320sHzCA
X-Google-Smtp-Source: ABdhPJx2cBOX8TKr/h/WTeqUC4FZm457izcVFqtGtuZ/tZr6Sm6aO2hN978l1aOE3sJBvl184EerOw==
X-Received: by 2002:a17:902:8644:b0:15a:3b4a:538a with SMTP id y4-20020a170902864400b0015a3b4a538amr23511594plt.146.1652241336651;
        Tue, 10 May 2022 20:55:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0015e8d4eb1f7sm442789plh.65.2022.05.10.20.55.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 20:55:35 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next 5/6] net: Add a way to copy skbs without affect cache
Date:   Tue, 10 May 2022 20:54:26 -0700
Message-Id: <1652241268-46732-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an skb_copier, skb_nocache_copier, which contains function pointers to
nontemporal copy routines.

Using skb_nocache_copier and do_skb_copy_datagram implement
skb_copy_datagram_from_iter_nocache. This function is intended to be used
by callers which would like to copy data into SKBs using nontemporal
instructions to avoid the CPU cache.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/linux/skbuff.h |  2 ++
 net/core/datagram.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 97de40b..32c0cba 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3918,6 +3918,8 @@ int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 			   struct ahash_request *hash);
 int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 struct iov_iter *from, int len);
+int skb_copy_datagram_from_iter_nocache(struct sk_buff *skb, int offset,
+				 struct iov_iter *from, int len);
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *frm);
 void skb_free_datagram(struct sock *sk, struct sk_buff *skb);
 void __skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb, int len);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index a87c41b..da8557b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -543,6 +543,11 @@ struct skb_copier skb_copier = {
 	.copy_page_from_iter = copy_page_from_iter
 };
 
+struct skb_copier skb_nocache_copier = {
+	.copy_from_iter = copy_from_iter_nocache,
+	.copy_page_from_iter = copy_page_from_iter_nocache
+};
+
 static int do_skb_copy_datagram(struct sk_buff *skb, int offset,
 				struct iov_iter *from, int len, struct skb_copier copier)
 {
@@ -611,6 +616,13 @@ static int do_skb_copy_datagram(struct sk_buff *skb, int offset,
 	return -EFAULT;
 }
 
+int skb_copy_datagram_from_iter_nocache(struct sk_buff *skb, int offset,
+					struct iov_iter *from, int len)
+{
+	return do_skb_copy_datagram(skb, offset, from, len, skb_nocache_copier);
+}
+EXPORT_SYMBOL(skb_copy_datagram_from_iter_nocache);
+
 /**
  *	skb_copy_datagram_from_iter - Copy a datagram from an iov_iter.
  *	@skb: buffer to copy
-- 
2.7.4

