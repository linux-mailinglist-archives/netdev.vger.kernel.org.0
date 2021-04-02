Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D10352F0F
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhDBSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:17:55 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38463 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhDBSRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:17:54 -0400
Received: by mail-wr1-f46.google.com with SMTP id i18so1925199wrm.5;
        Fri, 02 Apr 2021 11:17:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBKBwFnLR6KheF+0+jTnrdx81GBF+PEZpOcMgLUdP0I=;
        b=c4ZUXpuHepMniyq2pPmAdvX1uKehqSHeq47srWOIqXa38aqMLPNfjvkXLgzKt+fGaS
         8WWYJ/SbVwZijAj5eee9kbdy/BRYOMyESqBYbA4V/VIxus6v1AJqegDvITcjXhp814c/
         +tDnX5mW0rYDJ2CZGMmMRRZVOg21C8ZusAVRFTvNRPWczMxOfU6XgfJI2Xuef41XQ/qG
         0eGd8h8My2mhV3ru0mMMOenAbFC4OXpJncqs0PfDFYe3wa9O1o3gXnTSP8Rvj1d6R1Ug
         ki0W+L5PqMPXCRFMU01+0iXAQ16XvuLxUP6F8a5LWejtyykyYaKkYpmuGTCf7SOIP9Kx
         YE7Q==
X-Gm-Message-State: AOAM533SgBCezNIBA58dQBQmh28ACVsExFHTaHCL45gpoWm6MX0cy1yr
        PJri1EMwYMXYqbOuzkvfIGTSEN0SZ+I=
X-Google-Smtp-Source: ABdhPJxsviGRHcvDlacbJZu7qC82VCXMYNfPjsdToe0jC9OVA1nnVVuhpe6OFpIWBN40LYGh9j8Scg==
X-Received: by 2002:a05:6000:2c7:: with SMTP id o7mr16082046wry.78.1617387471672;
        Fri, 02 Apr 2021 11:17:51 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id l9sm11472831wmq.2.2021.04.02.11.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:17:51 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/5] xdp: reduce size of struct xdp_mem_info
Date:   Fri,  2 Apr 2021 20:17:29 +0200
Message-Id: <20210402181733.32250-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210402181733.32250-1-mcroce@linux.microsoft.com>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
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
2.30.2

