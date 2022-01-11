Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA448A4FC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346434AbiAKBZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbiAKBZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:25:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4044C06173F;
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l25so19233499wrb.13;
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BjXWOH5wrWztd6i7p0jL5/v39iYb4LIPGSHy9klVSRw=;
        b=g69qarQTFT4uz2Fj4M4Nxle/qtQwXnwMv2lw7EZtVrGyxrlfrOXt0+eMVcaXEfR4eJ
         4Fl4q8Dp2467IRttdetDoN2MKH1s+f0KddnCfRW7ezRIwCk9CMeyki6jqBxkyEmyN0Mn
         SI0RHbK56xgO+ZHuIebRzXuhQAPNZ+HTDzCxK3afR7GLnEfRb5GDLoEXebjZyNmaSqtt
         /0DuOlTbRvTo7srcmPqrg26mX+tKZV4Zlxt+8NmBNyPvZFSHj257HmGua2joh+U78iIg
         B8NNqxaSSHPoXQmE7c/vutkQLV+rKY3PF/bU7CnqV6H/CmvFANlihlnDJP/5y1tA4Ewy
         rshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BjXWOH5wrWztd6i7p0jL5/v39iYb4LIPGSHy9klVSRw=;
        b=j1jowB7njXo7bq8ZMfY2LNQbYdU08aMQCUr1tisekBnSoZjVtDTPaOEEI7xHSdUUcj
         dBsaH4Xempz4w0OR2tVmclsbrA3Z6uO9t0t3BqScdNO/jZnDNuXqKrHH3ZIrnA8+SRgl
         /6csBk+oKBOBVVdnhgS01v9TZk8+bLEEnhnFtpnv7z5SqBmOsOVpnRAx3hUNx1G+mTbt
         naXAIpgkmS3TPYiMQA0YlORJX8aNAAxKDlN22PWA/AmkHcGsI6Wy/QRMxvc0eEVrw5Zf
         LoEk9LzmKVo8vgIGUxRH/O7/0CDSSxyzQbWgAxCmxRAlXHaGvIweH87LQACD53uC+Ci8
         0PDA==
X-Gm-Message-State: AOAM531/xjDZqURe+ZCqlZzXdRFvnmLL5MLlX2AEJEzrtbqC2vfg0hPw
        gsBWK3TrN7beAkJLRFe3S6S+vL2k/x0=
X-Google-Smtp-Source: ABdhPJw35QsuQoC2G7905+UuKYpKBDkhY4MVXmEH6xzrX9/YClSJxBE1aBm6x2XWfosWAyul3B6Dfw==
X-Received: by 2002:a05:6000:15c5:: with SMTP id y5mr1688211wry.473.1641864296428;
        Mon, 10 Jan 2022 17:24:56 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Date:   Tue, 11 Jan 2022 01:21:46 +0000
Message-Id: <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline a HW csum'ed part of skb_csum_hwoffload_help().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/netdevice.h | 16 ++++++++++++++--
 net/core/dev.c            | 13 +++----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3213c7227b59..fbe6c764ce57 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4596,8 +4596,20 @@ void netdev_rss_key_fill(void *buffer, size_t len);
 
 int skb_checksum_help(struct sk_buff *skb);
 int skb_crc32c_csum_help(struct sk_buff *skb);
-int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features);
+int __skb_csum_hwoffload_help(struct sk_buff *skb,
+			      const netdev_features_t features);
+
+static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
+					  const netdev_features_t features)
+{
+	if (unlikely(skb_csum_is_sctp(skb)))
+		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
+			skb_crc32c_csum_help(skb);
+
+	if (features & NETIF_F_HW_CSUM)
+		return 0;
+	return __skb_csum_hwoffload_help(skb, features);
+}
 
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
diff --git a/net/core/dev.c b/net/core/dev.c
index 877ebc0f72bd..e65a3b311810 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3513,16 +3513,9 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 	return skb;
 }
 
-int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features)
+int __skb_csum_hwoffload_help(struct sk_buff *skb,
+			      const netdev_features_t features)
 {
-	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
-			skb_crc32c_csum_help(skb);
-
-	if (features & NETIF_F_HW_CSUM)
-		return 0;
-
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
@@ -3533,7 +3526,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 
 	return skb_checksum_help(skb);
 }
-EXPORT_SYMBOL(skb_csum_hwoffload_help);
+EXPORT_SYMBOL(__skb_csum_hwoffload_help);
 
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
-- 
2.34.1

