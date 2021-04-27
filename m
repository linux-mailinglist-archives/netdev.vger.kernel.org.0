Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C1E36C5F4
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhD0MTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 08:19:51 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:42502 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236139AbhD0MTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 08:19:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UWzhhbo_1619525943;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UWzhhbo_1619525943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 20:19:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf] xsk: fix for xp_aligned_validate_desc() when len == chunk_size
Date:   Tue, 27 Apr 2021 20:19:03 +0800
Message-Id: <20210427121903.76556-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When desc->len is equal to chunk_size, it is legal. But
xp_aligned_validate_desc() got "chunk_end" by desc->addr + desc->len
pointing to the next chunk during the check, which caused the check to
fail.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Fixes: 26062b185eee ("xsk: Explicitly inline functions and move definitions")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk_queue.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2823b7c3302d..40f359bf2044 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -128,13 +128,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 chunk, chunk_end;
+	u64 chunk;
 
-	chunk = xp_aligned_extract_addr(pool, desc->addr);
-	chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
-	if (chunk != chunk_end)
+	if (desc->len > pool->chunk_size)
 		return false;
 
+	chunk = xp_aligned_extract_addr(pool, desc->addr);
 	if (chunk >= pool->addrs_cnt)
 		return false;
 
-- 
2.31.0

