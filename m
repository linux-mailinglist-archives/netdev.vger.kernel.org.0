Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C36F3AC58B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhFRIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhFRIA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:00:28 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B239C061574;
        Fri, 18 Jun 2021 00:58:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v9so9691812wrx.6;
        Fri, 18 Jun 2021 00:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XT9PsaveS2wI1C58XJPAB7cgQcAtkyBEo052+9tGtKM=;
        b=CjIctjhxB6j099eunr1UNTydC6I8DWATEDos/3xAlfpr+enFqMHadXj2MQJQ6Qcs8Y
         BabKe9ndbgKcPPKwIGFxuadpKPwbtmQ7nx/F2hSgU9fA0vc1OKaUDeyWhMYVtmX4IMzq
         PUxoue2BCFq48UPcgTDO/k5lzZh5YHhuj0q77/tWw9N1rTxdMVpgcpf4ZAm0/r5QpSJO
         9JbOA8OgR1wlc6Am1lq32UdYz5DFgFJGp9DCjIpd8b8ElJk3OYyEBM22GqlxBqldxiM8
         sjyCZKO9+CDnMvhDX067prYMDfaTFGPn3cPb6Huc+mi5MKENBaOK+Ru+naRMpj2lY7Mc
         4BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XT9PsaveS2wI1C58XJPAB7cgQcAtkyBEo052+9tGtKM=;
        b=L0/yYD1LbETUEfHtqUwm/MsutuB07ieDegwTrPqIP3swB52hIuMCe0VYe+wMiaNbkD
         4QrLTLrwDTStYf2Q3c1gSpUo3TjYlg5HLKhuVCWFjueBDWLI7np5QUga6LgApyAQN28X
         h2VAlF9MPWKE31bPNmyVBbRNnsh/65QWrZRwSm8hlDyAXpbcP0HuezbGMlpBMhyolTX2
         k6zZSD24U5kzIVHmok1MAIuUrlspTUtVNVjIWEL3OLvMomZMD8Hc3d0lJdiTi4W5z9fG
         Cjk6CoUAMYtf2D62k3fV2U3fsG8DgpDt7bGcaQbKzf5voKzaUvyQbZ5nGoVq3J6TLWix
         tdng==
X-Gm-Message-State: AOAM532X7lSAaQWRg6sYJ+Vd/aBWeSDaDoDOVX9ivjrKOL3KefaERqmL
        IJ4j5e4W+ALJcJGEcw3KrY4=
X-Google-Smtp-Source: ABdhPJzJ0uUVKjnZEY02JzGRkvDrkB7OSAvzuWAiSilGgIfBg/jQlOGJ5PcX+KOuDLjPXCMwgEUzYA==
X-Received: by 2002:a5d:410f:: with SMTP id l15mr10934663wrp.82.1624003096502;
        Fri, 18 Jun 2021 00:58:16 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i9sm4676705wrn.13.2021.06.18.00.58.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 00:58:15 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf v2] xsk: fix broken Tx ring validation
Date:   Fri, 18 Jun 2021 09:58:05 +0200
Message-Id: <20210618075805.14412-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix broken Tx ring validation for AF_XDP. The commit under the Fixes
tag, fixed an off-by-one error in the validation but introduced
another error. Descriptors are now let through even if they straddle a
chunk boundary which they are not allowed to do in aligned mode. Worse
is that they are let through even if they straddle the end of the umem
itself, tricking the kernel to read data outside the allowed umem
region which might or might not be mapped at all.

Fix this by reintroducing the old code, but subtract the length by one
to fix the off-by-one error that the original patch was
addressing. The test chunk != chunk_end makes sure packets do not
straddle chunk boundraries. Note that packets of zero length are
allowed in the interface, therefore the test if the length is
non-zero.

v1 -> v2:
* Improved commit message

Fixes: ac31565c2193 ("xsk: Fix for xp_aligned_validate_desc() when len == chunk_size")
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9d2a89d793c0..9ae13cccfb28 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -128,12 +128,15 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 chunk;
-
-	if (desc->len > pool->chunk_size)
-		return false;
+	u64 chunk, chunk_end;
 
 	chunk = xp_aligned_extract_addr(pool, desc->addr);
+	if (likely(desc->len)) {
+		chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len - 1);
+		if (chunk != chunk_end)
+			return false;
+	}
+
 	if (chunk >= pool->addrs_cnt)
 		return false;
 

base-commit: da5ac772cfe2a03058b0accfac03fad60c46c24d
-- 
2.29.0

