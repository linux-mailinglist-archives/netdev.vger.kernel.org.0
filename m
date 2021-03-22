Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8965344CA5
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhCVRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:03:58 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:41648 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCVRDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:03:36 -0400
Received: by mail-ej1-f53.google.com with SMTP id u5so22497421ejn.8;
        Mon, 22 Mar 2021 10:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBKBwFnLR6KheF+0+jTnrdx81GBF+PEZpOcMgLUdP0I=;
        b=Nn3DEO+5ZRwC+sqPxUomMSosil8ZsSmFHDRoqTrAiFH1HnerpjAPBpGno3Jca3q54O
         nE8ck5VOBK6/ju3uXhyfs5YKDeYJn77obcTvRhlxl/C+zmnnuDMMVIDNMn5GsXYXS6vz
         K2sw7LXt7omkmvRud/MKcN95Rq9E1qMDNK89krRpMPjnYkN+FfqExtckloZ4fKbXOW2x
         DqwU3jLajuk7RETZ/j1ofk9EiD4akR/vWxxY2Qd7or3FE+JmVPo3lDmyJOFSkJOe8UIl
         IAzQBjQHTD1S2LKorsRxkRf3uNZa7EeJqrcDgyUJQ654jcyZsiIEaBF9tDgzjyUZa+eO
         ++OA==
X-Gm-Message-State: AOAM531aulqwuSvmkP6aNuVrRqE+vL8WyYTc+vWBmuV/imP9fvrXtTVq
        u7nTLZJq1ileq77ATF1pXL3DWdORLic=
X-Google-Smtp-Source: ABdhPJxo+yUH2CwgMEXl0a2sW3KnFzSao8u0O9DQjdubFqBceXmjj96KFnMky7iRrTGUE+al/ab7mQ==
X-Received: by 2002:a17:906:23e9:: with SMTP id j9mr799383ejg.78.1616432615404;
        Mon, 22 Mar 2021 10:03:35 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:03:35 -0700 (PDT)
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
Subject: [PATCH net-next 1/6] xdp: reduce size of struct xdp_mem_info
Date:   Mon, 22 Mar 2021 18:02:56 +0100
Message-Id: <20210322170301.26017-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
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

