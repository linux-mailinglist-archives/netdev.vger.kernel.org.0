Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7308C3B9AF1
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhGBDQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbhGBDQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:16:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D60C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 20:14:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w13-20020a056902100db0290559a715f5bbso10775586ybt.23
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 20:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SNDX35d8qCG/og3qkyCbtgJdC3v6hE1jOVYNB3mBoDU=;
        b=IRiWHwxg1hDjv2ZtuQs9GTqSjWnwcJF/wRGbjOW15j4KG44S/VetKaOQgeKnxv1rHg
         pJp9WtwxXg9q/vPNmg7Hg26rIE3Z8JYVFmU38U2sjBBQFvy71TySzH6H1JbPl5ZTL7Xb
         fZDwrCYJJd2S48xVD9y9Y9c01b64xasXPqwLku5tXQ7ZxwxfHi6kpDx2/4fQkOJPMoWW
         xlsL4/vpN2ULg3LQMyGQ7IOi3Zt+nCJOxRb9RtZ+ZGe/7wjuwwtQuqn6+SKULIqqIE0L
         8fAetVZDjZoR6+8D/NRKBgBm5bI6KR0dXzD2yUYPWfa+DqiMZFYD2cED3nOgt0ry0yFP
         XgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SNDX35d8qCG/og3qkyCbtgJdC3v6hE1jOVYNB3mBoDU=;
        b=cf102zMk5I27EC21myQ61E9dPoxHKxRusjkKsNzQwvCGrICGaZOpbdSiZVg2N516bX
         PP1ohbHWO4W40Iao2L5jQuOqfhZDgRMiQ2iLSDqWqkBXi86awJ6Xd/efrMoxsyYrX4aW
         U0N5YelduOAPBFnfkDARiDMxx2U2ZWp3FjVS+sGPelYl7gWnhqEhu268iI6RppiE1Cxl
         w0OgwqOU98qsk/23YDUYjLA4aS3DuyXr8WPpSYeDNzEZRNcv2swoGUQ6DtafxokmyDcr
         nAUL7wCf6qlq2up9ux2gOrR+0T2GHc3qDqPYUHGE0C/fQLb1xFYdN/hnrvAI70k+VtNl
         OKRA==
X-Gm-Message-State: AOAM533Or82mO9r8ug7oQXWHD3B8PqcQ2N73gs8JKd+LWPtd4Wb3NChi
        oj11oo1g6i6EMo5DinlPm2zUGmQ=
X-Google-Smtp-Source: ABdhPJz7fGFUKyjrcOlPuovwpZ1orHZ9ZTBRZSXsn+1HVFIWZrrq3jnNc3awigkGbmah8Hu/Bxr2kL0=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:25bf:4c6:5da8:bb57])
 (user=bcf job=sendgmr) by 2002:a25:9981:: with SMTP id p1mr4275044ybo.246.1625195649190;
 Thu, 01 Jul 2021 20:14:09 -0700 (PDT)
Date:   Thu,  1 Jul 2021 20:13:36 -0700
Message-Id: <20210702031336.3517086-1-bcf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net] gve: DQO: Remove incorrect prefetch
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The prefetch is incorrectly using the dma address instead of the virtual
address.

It's supposed to be:
prefetch((char *)buf_state->page_info.page_address +
	 buf_state->page_info.page_offset)

However, after correcting this mistake, there is no evidence of
performance improvement.

Fixes: 9b8dd5e5ea48 ("gve: DQO: Add RX path")
Signed-off-by: Bailey Forrest <bcf@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 77bb8227f89b..8500621b2cd4 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -566,13 +566,6 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 		return 0;
 	}
 
-	/* Prefetch the payload header. */
-	prefetch((char *)buf_state->addr + buf_state->page_info.page_offset);
-#if L1_CACHE_BYTES < 128
-	prefetch((char *)buf_state->addr + buf_state->page_info.page_offset +
-		 L1_CACHE_BYTES);
-#endif
-
 	if (eop && buf_len <= priv->rx_copybreak) {
 		rx->skb_head = gve_rx_copy(priv->dev, napi,
 					   &buf_state->page_info, buf_len, 0);
-- 
2.32.0.93.g670b81a890-goog

