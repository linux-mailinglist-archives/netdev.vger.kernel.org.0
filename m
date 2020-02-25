Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75E16BE3E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgBYKFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:05:51 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55067 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgBYKFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 05:05:51 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5f16b5ca;
        Tue, 25 Feb 2020 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=rFarOihGr3FtWoqKNukURcqdxmo=; b=vYr08/Ul9tuEvdKlOFah
        mjUtkps5emfNby518axYszxIFT/i4aCykwTehBhSDhqSava7ImLhLxyVIpWvTaeh
        iJ+asgA1DYTHywehw0U2I9bzooq9n8gnSi/f2Jc8GvS0NlYpjod5Nj0LoG9VgNj5
        LxozWP12IX/VaW1W7vSOa6UzWZx1hclVh8R2FxzlQ4KAlF0CI2p3FsDWzWKrAscV
        V4n4MC7JY0XMAFdxENr25ZFmzhWlxoyBQQbiQ89x8HFNvzR82VcPkTyxPl+11yxK
        YlA9AHdw/NKcPlyZ9IGLxPkE3Nfp6ergI6lUf50IMyOSSQf0DDwxNAYSbBiMMW9Y
        0A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f8295899 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 25 Feb 2020 10:02:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net] icmp: allow icmpv6_ndo_send to work with CONFIG_IPV6=n
Date:   Tue, 25 Feb 2020 18:05:35 +0800
Message-Id: <20200225100535.45146-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The icmpv6_send function has long had a static inline implementation
with an empty body for CONFIG_IPV6=n, so that code calling it doesn't
need to be ifdef'd. The new icmpv6_ndo_send function, which is intended
for drivers as a drop-in replacement with an identical function
signature, should follow the same pattern. Without this patch, drivers
that used to work with CONFIG_IPV6=n now result in a linker error.

Cc: Chen Zhou <chenzhou10@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 0b41713b6066 ("icmp: introduce helper for nat'd source address in network device context")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/icmpv6.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 93338fd54af8..33d379602314 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -22,19 +22,23 @@ extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
 int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 			       unsigned int data_len);
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
+#else
+#define icmpv6_ndo_send icmpv6_send
+#endif
+
 #else
 
 static inline void icmpv6_send(struct sk_buff *skb,
 			       u8 type, u8 code, __u32 info)
 {
-
 }
-#endif
 
-#if IS_ENABLED(CONFIG_NF_NAT)
-void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
-#else
-#define icmpv6_ndo_send icmpv6_send
+static inline void icmpv6_ndo_send(struct sk_buff *skb,
+				   u8 type, u8 code, __u32 info)
+{
+}
 #endif
 
 extern int				icmpv6_init(void);
-- 
2.25.0

