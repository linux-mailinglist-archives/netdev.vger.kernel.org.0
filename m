Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B51337E5B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCKToT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:44:19 -0500
Received: from mail-ed1-f49.google.com ([209.85.208.49]:42856 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCKToI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:44:08 -0500
Received: by mail-ed1-f49.google.com with SMTP id u4so4591996edv.9;
        Thu, 11 Mar 2021 11:44:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YI2nNQyDrWXPwhx/kaHbgpDnh31My7dSLdT5Tz8fthI=;
        b=Z1mgg0OpTBHOfMotJf23/+mSMaU8pQhqrU8kqKUcyTVBIyg0EYunArIDffVxRDvFKZ
         SVeOUJBaJHx3EcudZvAdwoEZ5RksxEcx+1eOxRLElALX/wY79DlWW1xbkAPsNDm+Eu/G
         jx6eepuXzbK7YS35GP72osg6cYn+eUYJ7uqc6+v7SacppgWg6Z3sZ7ZSvYjuyK7Cdq+x
         /IZXF7zUumYJwRYqzIAMD3rSeEVwUOAZSlEwpD4QfKYZCMHWjQ8PhXCbQEpj6tlMWioq
         L8IX3QIYaTpRh6j4KUXAymeKSwSpMGIrWA4HvD9On+UQKb/3V4S+g1rbaM5r1Zh2i057
         mILQ==
X-Gm-Message-State: AOAM5333blznhFD+ukOZ6SYa+z7YbDtvqhkrMvSuYENQJao1CuPTURg/
        qOTJXE8jcADL3GWAK3gFuSbhVWbLJk0=
X-Google-Smtp-Source: ABdhPJzWBMI7r7rqttoaQfPVOIOWY/0x7OAnEZvmah72avQr12GLynyurPmBfVK5PmXMQeKT91W+fQ==
X-Received: by 2002:a05:6402:1613:: with SMTP id f19mr10377447edv.222.1615491846680;
        Thu, 11 Mar 2021 11:44:06 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-188-216-41-250.cust.vodafonedsl.it. [188.216.41.250])
        by smtp.gmail.com with ESMTPSA id t16sm1875652edi.60.2021.03.11.11.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:44:06 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [RFC net-next 1/6] xdp: reduce size of struct xdp_mem_info
Date:   Thu, 11 Mar 2021 20:42:51 +0100
Message-Id: <20210311194256.53706-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311194256.53706-1-mcroce@linux.microsoft.com>
References: <20210311194256.53706-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

It is possible to compress/reduce the size of struct xdp_mem_info.
This change reduce struct xdp_mem_info from 8 bytes to 4 bytes.

The member xdp_mem_info.id can be reduced to u16, as the mem_id_ht
rhashtable in net/core/xdp.c is already limited by MEM_ID_MAX=0xFFFE
which can safely fit in u16.

The member xdp_mem_info.type could be reduced more than u16, as it stores
the enum xdp_mem_type, but due to alignment it is only reduced to u16.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h | 4 ++--
 net/core/xdp.c    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index a5bc214a49d9..c35864d59113 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -48,8 +48,8 @@ enum xdp_mem_type {
 #define XDP_XMIT_FLAGS_MASK	XDP_XMIT_FLUSH
 
 struct xdp_mem_info {
-	u32 type; /* enum xdp_mem_type, but known size type */
-	u32 id;
+	u16 type; /* enum xdp_mem_type, but known size type */
+	u16 id;
 };
 
 struct page_pool;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..3dd47ed83778 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -35,11 +35,11 @@ static struct rhashtable *mem_id_ht;
 
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 {
-	const u32 *k = data;
-	const u32 key = *k;
+	const u16 *k = data;
+	const u16 key = *k;
 
 	BUILD_BUG_ON(sizeof_field(struct xdp_mem_allocator, mem.id)
-		     != sizeof(u32));
+		     != sizeof(u16));
 
 	/* Use cyclic increasing ID as direct hash key */
 	return key;
@@ -49,7 +49,7 @@ static int xdp_mem_id_cmp(struct rhashtable_compare_arg *arg,
 			  const void *ptr)
 {
 	const struct xdp_mem_allocator *xa = ptr;
-	u32 mem_id = *(u32 *)arg->key;
+	u16 mem_id = *(u16 *)arg->key;
 
 	return xa->mem.id != mem_id;
 }
-- 
2.29.2

