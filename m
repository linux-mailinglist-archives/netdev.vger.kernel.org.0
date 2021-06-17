Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15383AAF9D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFQJZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhFQJZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 05:25:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C9C061574;
        Thu, 17 Jun 2021 02:23:12 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m3so2946167wms.4;
        Thu, 17 Jun 2021 02:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jh2akKGSh7LAIPi3C0DLkYCaURaKcZYFmLApSTkQ1F8=;
        b=WPdd6kMOfCu+NLkJSgNBB/n4X4u4ZCfG1/IMkwYQbwEd3lDufWM5Bn/X4a6j1lrbmR
         yTsRALciGZy148WDSJfMNAaPo1RT41X+KFtq5qGYnaVO1RYtLF0Zrbiq8REIgZnbbuUM
         bg6/07QbUxWcq96gckBOHnPxike6H/g1vAg0W8w5Qc7jkXEhPoGCwtMYy0krJv5obQSl
         M3sJqEx12r3DuCCmB81sgbje7d9WN+4M2XlxHAYWx+N0Rey3EnZ9ZbTHxCJA1JIXhoDL
         mTR01qlpPZX5FMJs0zyKGHCGgObUZNu1oIPO++rRkLaVMDyefnTkVPJtnl1q0r4GRlwv
         diwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jh2akKGSh7LAIPi3C0DLkYCaURaKcZYFmLApSTkQ1F8=;
        b=aC9pXwKTNMaKTYvqQmlWLYM7SmrYJ3tk1c7Ke5lE3a+aAItFMfyEfI0l31XDgrIdUp
         BaVK2Khn3hx4zkTTCKD7wCFc/EM1FtgdEtzrAweeu9ifrp9PgRaygATDWuAIprH2i2+O
         3hzFnANd+vhBHKMUgx+e8kIfhlavPWnaXAS793TxtfsHTgyqAUQ8wZBU/pc0cUdEQnAd
         7M9MQrcqeeI7rO6uCr/ceBXhAUc8/65mquItdHrHw1ScLxdDgmyN8egcyk3vsQk92amh
         wb0iCx9G+BSjKWwEvVHdkk6YMcqcxCUvHZnsT669jkc6LQdWWlVO73zq44Vvf4zWQmZc
         BbKw==
X-Gm-Message-State: AOAM5321PLZxLQU5ztQ5tIt070f/3xCpLITZ7rsgU6wDKgtw1DDu/vIm
        alUVz46ahJgd/4Szb76wfCY=
X-Google-Smtp-Source: ABdhPJy3ocaQ6c5SvqBD+t15FkdUZS44XNiGdGbN0Kj/kLJL94sNf6ZeRMxXhcOtHAEfDFn8p08wfg==
X-Received: by 2002:a05:600c:4f4e:: with SMTP id m14mr3875175wmq.157.1623921789968;
        Thu, 17 Jun 2021 02:23:09 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r2sm5021770wrv.39.2021.06.17.02.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 02:23:09 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix missing validation for skb and unaligned mode
Date:   Thu, 17 Jun 2021 11:22:55 +0200
Message-Id: <20210617092255.3487-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a missing validation of a Tx descriptor when executing in skb mode
and the umem is in unaligned mode. A descriptor could point to a
buffer straddling the end of the umem, thus effectively tricking the
kernel to read outside the allowed umem region. This could lead to a
kernel crash if that part of memory is not mapped.

In zero-copy mode, the descriptor validation code rejects such
descriptors by checking a bit in the DMA address that tells us if the
next page is physically contiguous or not. For the last page in the
umem, this bit is not set, therefore any descriptor pointing to a
packet straddling this last page boundary will be rejected. However,
the skb path does not use this bit since it copies out data and can do
so to two different pages. (It also does not have the array of DMA
address, so it cannot even store this bit.) The code just returned
that the packet is always physically contiguous. But this is
unfortunately also returned for the last page in the umem, which means
that packets that cross the end of the umem are being allowed, which
they should not be.

Fix this by introducing a check for this in the SKB path only, not
penalizing the zero-copy path.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xsk_buff_pool.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index eaa8386dbc63..7a9a23e7a604 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -147,11 +147,16 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 {
 	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
 
-	if (pool->dma_pages_cnt && cross_pg) {
+	if (likely(!cross_pg))
+		return false;
+
+	if (pool->dma_pages_cnt) {
 		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
 			 XSK_NEXT_PG_CONTIG_MASK);
 	}
-	return false;
+
+	/* skb path */
+	return addr + len > pool->addrs_cnt;
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)

base-commit: da5ac772cfe2a03058b0accfac03fad60c46c24d
-- 
2.29.0

