Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4B3AAF99
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhFQJYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhFQJYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 05:24:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BAAC061574;
        Thu, 17 Jun 2021 02:22:37 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso3267063wmj.2;
        Thu, 17 Jun 2021 02:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hz2p89oeNBlAog0R62THQ2ZPT9jlZo0zwuN+lGU1qug=;
        b=paBQK6TUBE5T3mZ43694fRe4UQX3yPmts230slaXuaMrabblrpN3EAq8Wag83J91wL
         gdQosCafprCOLWYQKwYjTo3i5LUiIY+SHVhl54UpkZ12vb03SDPc4y/3F8bV73YMhkR+
         ykyoBijiUav5XK/2qfrGGfJJLiNu0REk80c3wH6OpakR4IzcMPq4g2WbL6zY9o9knwsJ
         AlgpVSyYptixzV24BrhGjKWtA0wNQccBUziGwIJGaDgakbhy08MGv7JYo/x+4peslN3G
         FHMCM3++7fOpaWuZ+gDCGnYzmIZZ64sZ9FLsrtalKcsn36SObyZDtPJLIEp43qgY0MXW
         Yj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hz2p89oeNBlAog0R62THQ2ZPT9jlZo0zwuN+lGU1qug=;
        b=uU+0RRhwgzz0KJP9iuPnsstAdfefVLBLzmey6UTHT4e5RWM0COqUCq/i1G/Hod9D5g
         Rs4iPGYB/ftrO5ureIrlXuoVKnLzP+vT2FnvQHOAvXyDzEB2Qltgq2r8Ov99EJGeisbF
         YQrd2tLqmxneSL3EOnvO16GX8nFo+yfkY07zhbEVZ32l+6j+KT5hNF8IQo8nyGb8oj/F
         tJ/4UnbmPV/yywxguDVakPTTXxLcLhkH4aVM0nki1f2UlAlHxxzx5QrXI3vrK6RQu2st
         3upiC3exYz/EaX9mIUQZXBf/J/C9ztL7tco4o2xRikymDdxoejz8S4dl1EFLDfSRD2wD
         6pgA==
X-Gm-Message-State: AOAM53298HyM7vGsWbSAGUw9+r+brAydF8ZFswlJvk0J2cTT/YnAYHxd
        m9pqnRjrU7JFEgbBrLFUXqo=
X-Google-Smtp-Source: ABdhPJzVS9kPY3TWGtgwe1IkSjhjunnKg0DwJ4OE65sO3/0VKMkfjwJopoGJ3IJ5JE2Q4DQtDrDAEA==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr3922169wmc.88.1623921755947;
        Thu, 17 Jun 2021 02:22:35 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i15sm4492604wmq.23.2021.06.17.02.22.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 02:22:35 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix broken Tx ring validation
Date:   Thu, 17 Jun 2021 11:22:08 +0200
Message-Id: <20210617092208.3288-1-magnus.karlsson@gmail.com>
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
chunk boundary which they are not allowed to do. Worse is that they
are let through even if they straddle the end of the umem itself,
tricking the kernel to read data outside the allowed umem region which
might or might not be mapped at all.

Fix this by reintroducing the old code, but subtract the length by one
to fix the off-by-one error that the original patch was
addressing. Note that packets of zero length are allowed in the
interface, therefore the test if the length is non-zero.

Fixes: ac31565c2193 ("xsk: Fix for xp_aligned_validate_desc() when len == chunk_size")
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

