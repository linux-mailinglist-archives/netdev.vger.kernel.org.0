Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1214F099B
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358589AbiDCNLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358536AbiDCNK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:28 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525271029
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso4074099wmz.4
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b4iQGbstpUOSsgNXmdUB67X47VRarOvzLhVtfaDU4Wo=;
        b=l+m80QqAOYTCuIdmyreEEQ6q7ged2RbmlEsNYc4X0pumPjYe3KlzonzAEjkmzxh9l/
         YW3eYunumE0mxPhHHhJ1n5zWmLKPeU0X/OnvnMNhcoalFlxiLSzwmGJUVx1jnydAIqx7
         Z8cX4eZbKy0APRYjCPIU5L/SvvNOy9wbHS5Z+pEEI+L3Gm/wxVdF4ouvHonyI8y422CX
         Yb/AGdHbskXMJ6EIi0I1l9MpvKId56p6HZWPJtuYwCqDc1NOic/pY/OiaGpF3Kpc08Wj
         KqxSol7jcLfAOJtM7D5Jx9rl8LfgYmDOyI67nQoak27wNJpo2td+tLi6o5g+w6mPAsrs
         4BJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b4iQGbstpUOSsgNXmdUB67X47VRarOvzLhVtfaDU4Wo=;
        b=uN1nXaAmxzKiAFhMfBWl/q1FuXkFuDr1R/zJA3gOOfg5xgGmDEt9t7sxL+dWXbdkGC
         FZtfPPDxscrceZFhdWjoZh1RMlocnTsh/pR+SWKmXgs5d4eu1kf8DR8eJX6uok5FzIXG
         rhqD2jB/DFxdQ+tgiPrajR3zmfXgiVtNVFlf4m8PHEjGb7pWDxTCVhvGOFODuDtD7KeB
         XKPQjww0nfUB2c27Voyacn2aC7m+2nZys77qM8Yvl6SFRh6gziWP8F7ihuS89941Mr4h
         ugreGMv45lAYD+4nfMXmppbP5ncyoiQdalkaWLgGS7NIUcn20vLaIQBXd/WpO4U3y37w
         XEqA==
X-Gm-Message-State: AOAM532EM/44rEDfti9FKdjSkpVyOO7hUeHnVgnYUZqRMFhlMb6icClh
        qI9lZ/ikP5tFQEzOb9q9UxGGHyL1XB8=
X-Google-Smtp-Source: ABdhPJxZczJk9E6frV2ldr1xnn1H/SaZHONMZE/fI4XArZ9Pyv4loDOyWRDR3/jqKxRGPZfyIkLVCQ==
X-Received: by 2002:a05:600c:1ca7:b0:38e:27a6:5546 with SMTP id k39-20020a05600c1ca700b0038e27a65546mr15501660wms.188.1648991302573;
        Sun, 03 Apr 2022 06:08:22 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 10/27] net: inline part of skb_csum_hwoffload_help
Date:   Sun,  3 Apr 2022 14:06:22 +0100
Message-Id: <8ca1d5139e1820ac7e55166f164a56b2993d10e1.1648981571.git.asml.silence@gmail.com>
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

Inline a part of skb_csum_hwoffload_help() responsible for skipping
for HW-accelerated cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/netdevice.h | 13 ++++++++++---
 net/core/dev.c            | 11 ++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cd7a597c55b1..a4e41f7edc47 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4699,9 +4699,16 @@ extern u8 netdev_rss_key[NETDEV_RSS_KEY_LEN] __read_mostly;
 void netdev_rss_key_fill(void *buffer, size_t len);
 
 int skb_checksum_help(struct sk_buff *skb);
-int skb_crc32c_csum_help(struct sk_buff *skb);
-int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features);
+int __skb_csum_hwoffload_help(struct sk_buff *skb,
+			      const netdev_features_t features);
+
+static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
+					  const netdev_features_t features)
+{
+	if ((features & NETIF_F_HW_CSUM) && !skb_csum_is_sctp(skb))
+		return 0;
+	return __skb_csum_hwoffload_help(skb, features);
+}
 
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4842a398f08d..6044b6124edc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3233,7 +3233,7 @@ int skb_checksum_help(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(skb_checksum_help);
 
-int skb_crc32c_csum_help(struct sk_buff *skb)
+static inline int skb_crc32c_csum_help(struct sk_buff *skb)
 {
 	__le32 crc32c_csum;
 	int ret = 0, offset, start;
@@ -3572,16 +3572,13 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 	return skb;
 }
 
-int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features)
+int __skb_csum_hwoffload_help(struct sk_buff *skb,
+			      const netdev_features_t features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
 		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	if (features & NETIF_F_HW_CSUM)
-		return 0;
-
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
@@ -3592,7 +3589,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 
 	return skb_checksum_help(skb);
 }
-EXPORT_SYMBOL(skb_csum_hwoffload_help);
+EXPORT_SYMBOL(__skb_csum_hwoffload_help);
 
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
-- 
2.35.1

