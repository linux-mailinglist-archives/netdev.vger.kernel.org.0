Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0474257EE
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242712AbhJGQ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242701AbhJGQ1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:43 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5A4C061765
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i14-20020a63d44e000000b002955652e9deso131889pgj.16
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZvOQdeVvcW2ZfRct+SD+7QAtcz5vYsq7/z/gYOSNUAU=;
        b=hhoVlR0Dhv8Ifkx1awhfhn8PRMO8pqxKYkYRnU5NfB6XSNNaXtvQwwVaF47moh4hPU
         gN12wOMekg4+ZlBlu5tHyuI6J+KqKFrfbTc5YnSo1WJjRUNPsOKpx15CKeMhVeRLvN64
         0T9SGwC7EZFqNsKjhX3R1+FUJEXkFDqOq5avulAsZYFR2jM7gw/MR5ieVDc8GGZDL98M
         94tPmZzEJ01eLBVNBbWbWJ1cva2yJ9l0Vwc5B6vUw7sSNYW79zaigy4zPS5HcTl/wvVv
         aGLV9P2I44FGpOkW7PAD00JU8LoaxH585KWE5BAOD/pi7hAseMOJFbFcHa0DAHR1SDSm
         vXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZvOQdeVvcW2ZfRct+SD+7QAtcz5vYsq7/z/gYOSNUAU=;
        b=topScKw5GSUqe+ChvRRzS4hx/k7uE9Lf2Mj0NTfwGrwBh2mMU4CsCpcedOB36Tdrfe
         iUdcicHlTuecBGjb5D+LOuxlnLeQZO0GgOxaDLxDgYPoWxrvI6/HUEI9UcGhNpdqLQib
         gHET4e8P16x+1klKOkzp8LWjtE/tBcFshUpd0OJJSjnkXB7Ieg5V6apoyzFXj28a1mv+
         /JEfsjiysH5zNbV1IingMaa/KMkqcK936JFGefOSw+gAho5WfUd7WTJLxMbDWI4KQEcI
         ZdVaDwpjSWmIqPi7GP6QviGT1UQ1aKX5ghHap8DcGI7Le/wCj/axiR2YpoAIwxoVkExX
         CDnA==
X-Gm-Message-State: AOAM533fYa4E3nLt/hw1CuR0y004bAJAW2Qiwz0o6YSIVqGyoEZhDddE
        drfa/qNvoB6Tv27sYFTwP1bAbO9OhBaR537wJS7rL0nCLzIR7LAtIv4ouYFE8zrpwiFNDeysXoK
        LJyUqXUVOV30DHpizkjtN2OWYveQE64JiCs0EYxBXTpl8Hn2ZATHdVv9+fbk4Az7Vq4k=
X-Google-Smtp-Source: ABdhPJxn1EYFKOIRAFi0YbgKfNJSFFxL9dcBKpf8s1IbnEBdyJUCiZ7aT6FeBaSS51fttDyj6D4uVRVGJFpuKg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:a62:8f53:0:b0:44c:5d10:9378 with SMTP id
 n80-20020a628f53000000b0044c5d109378mr4999469pfd.19.1633623948567; Thu, 07
 Oct 2021 09:25:48 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:34 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-7-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 7/7] gve: Track RX buffer allocation failures
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

The rx_buf_alloc_fail counter wasn't getting updated.

Fixes: 433e274b8f7b0 ("gve: Add stats for gve.")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c6e95e1409a9..69f6db9ffdfc 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -526,8 +526,13 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 				gve_rx_free_buffer(dev, page_info, data_slot);
 				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot))
+				if (gve_rx_alloc_buffer(priv, dev, page_info,
+							data_slot)) {
+					u64_stats_update_begin(&rx->statss);
+					rx->rx_buf_alloc_fail++;
+					u64_stats_update_end(&rx->statss);
 					break;
+				}
 			}
 		}
 		fill_cnt++;
-- 
2.33.0.800.g4c38ced690-goog

