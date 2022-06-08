Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8545E543858
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245114AbiFHQFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245088AbiFHQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429C427F5FD
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h1so18001506plf.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=57cyzJoBPE7FvApVXx2h64j/hlX4+tffn7QLQfhu8gE=;
        b=CBqNoz3lw4byw6JuohqwVQykFbv7bK5KmSvFDQV2CbYeJRzxc25uwetVke2/8Tg91d
         J8vupRKBatko26oXgQmuF4pGpeVqtV2dXswPK9hOvjUMEfGK2wHETAtCQqdwN1KLEvBg
         VYL77RMenB4LV6M/zaGsuHMOs8bVC8vPdQV/gJJZ5W3DC2nVZBmQY58GCfF+KXOar71s
         tLtvihrpT07D5LfBrA6671VvCWTRzw4ldEdtjW8ml7n6ffK36/RvUNFElYvxxZsZaHPY
         GsBZQpPoMtcYCc3qJQlChAnnbtA5decgfvjdJG0ofjjWGJqc5tcsIsIllrJSW3/J5kF3
         O4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=57cyzJoBPE7FvApVXx2h64j/hlX4+tffn7QLQfhu8gE=;
        b=U8aj6oRP89ze+Tuf1vAYXTPjm4u/ZUmuO4fB3hkXLyaWlG4hbdiGMDSSn7o1eafUgM
         UkC7Vrji0gvVGo2ip1xurj2m+9ib3fjPOT7BH6DmKytlo0si21G91z5TD5itoYz/2mDt
         BQNKcgZswlxpusecSpMBjySMyE0RRLEvqYT2X7OUgBxsaHW8j7oFHsMGw7gjFmcD4rZx
         /+TOgsdn9vGUEkYK8COPAhM+s+xy7RFyQDoksST0WPKTVzDGQCAzYX/JCyu2ByDxrwBE
         TpcV6aTyejljbNvidxYpZARBY7b0fL+szZlfhCXaUPdOBjbpA5L1vkUgzcLQ38iKFLJZ
         ePMA==
X-Gm-Message-State: AOAM533x0oCAa+4G22yruwZcYJwzY6Eu+XokzWBk+Ci/ixXvKNlHKyl2
        R+EWf20zAXMVSAzAW2SvVe8=
X-Google-Smtp-Source: ABdhPJyb0+g6o4Oy+H8nAKmZC1sBP3BGPuU4M8cMQDrRk2tX1kc4+7WCJHocuIGNMJFi0kzXxIystg==
X-Received: by 2002:a17:902:ea08:b0:163:ec68:ae08 with SMTP id s8-20020a170902ea0800b00163ec68ae08mr4226846plg.52.1654704292879;
        Wed, 08 Jun 2022 09:04:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 8/8] net: add napi_get_frags_check() helper
Date:   Wed,  8 Jun 2022 09:04:38 -0700
Message-Id: <20220608160438.1342569-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

This is a follow up of commit 3226b158e67c
("net: avoid 32 x truesize under-estimation for tiny skbs")

When/if we increase MAX_SKB_FRAGS, we better make sure
the old bug will not come back.

Adding a check in napi_get_frags() would be costly,
even if using DEBUG_NET_WARN_ON_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 27ad09ad80a4550097ce4d113719a558b5e2a811..4ce9b2563a116066d85bae7a862e38fb160ef0e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6351,6 +6351,23 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
+/* Double check that napi_get_frags() allocates skbs with
+ * skb->head being backed by slab, not a page fragment.
+ * This is to make sure bug fixed in 3226b158e67c
+ * ("net: avoid 32 x truesize under-estimation for tiny skbs")
+ * does not accidentally come back.
+ */
+static void napi_get_frags_check(struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+
+	local_bh_disable();
+	skb = napi_get_frags(napi);
+	WARN_ON_ONCE(skb && skb->head_frag);
+	napi_free_frags(napi);
+	local_bh_enable();
+}
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6378,6 +6395,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
+	napi_get_frags_check(napi);
 	/* Create kthread for this napi if dev->threaded is set.
 	 * Clear dev->threaded if kthread creation failed so that
 	 * threaded mode will not be enabled in napi_enable().
-- 
2.36.1.255.ge46751e96f-goog

