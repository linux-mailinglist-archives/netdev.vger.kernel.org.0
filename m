Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5912CE128
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgLCVvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgLCVvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:51:50 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDCCC061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 13:51:10 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id k8so3372731ilr.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wd769s62G4gN8UdQaMhWbJtu3s9snxdDxsxVfUgyu6s=;
        b=Tl57wZyFQ35JV9ULnHb7ud0z1dC4PwN4Ffs0qNqi20/WkvHpIW4i+xlGeJiS9DsmQ1
         QiTyp8cNV3WcqLOKMv5Ph1evKGbalcBFzSgGHb2UjvgaJUlnDQAmzC9jyNBzmLSJ3reu
         k8oF4pDht/TDZ/A232LflxUiSfCp3agyJXMTmb/AYGn1V0fjYOpFTatU703JLYx8yNfe
         RHI6ACsyy30qpVvFN0wusJKkMjPXdlDMWHcnpSfg6jYOP0baMo0zHZGb2QjInUf8K5rt
         FJRwEsL0HP39F6Ei1vci+NxLs7D8huhORkiCb3zE6pYG5Exxe8TYA7QhG1HrausQSFBh
         ejbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wd769s62G4gN8UdQaMhWbJtu3s9snxdDxsxVfUgyu6s=;
        b=q1FJdJsjAHUVd9hLOYBA27Co8xFEZaUlTgJ0VaczK3C9CiUl7MTm5oQ5sBktiBcQgQ
         +OOQfivUCUooSb/ytZPOa6c2RbLajMW1bucaEpZYIQuYnKO3TJzZk3r4Z1SqxREpZOzk
         AAr8x49R9EFeMfE16woSMfok8LPVw1voXoVxN+0wiBO/HZ+yY0IEmHFLatnX6ftO9+nw
         hFn7E8n5AmIHW91iepFosopHV7FxLhb+UOsFt8IXkPnc+wiWHDUlxyuLQ7zebjrPN1yD
         yKM1r+UonLprj6aTcx/rmf+dj2UaYOsG3RgI5igNOeX+Lvoydl5opsS0DkQu/5RzQgbg
         bfew==
X-Gm-Message-State: AOAM532U0+jxtPD6qPbJyqt5Pf3T/YIga4lUuXvQk+DwGwISNUHYEWUg
        /LPyK1/jN6B1u++Bez9RCdUhWQ==
X-Google-Smtp-Source: ABdhPJz35J/k8DIk5BA4cjlVStmKukUYkv8EkfEWEu90gmew247VJrA0EMb6fiJE7vR7akMu5Jbmdg==
X-Received: by 2002:a92:6410:: with SMTP id y16mr1615807ilb.126.1607032269579;
        Thu, 03 Dec 2020 13:51:09 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r10sm300035ilo.34.2020.12.03.13.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:51:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     swboyd@chromium.org, sujitka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/1] net: ipa: pass the correct size when freeing DMA memory
Date:   Thu,  3 Dec 2020 15:51:06 -0600
Message-Id: <20201203215106.17450-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the coherent memory is freed in gsi_trans_pool_exit_dma(), we
are mistakenly passing the size of a single element in the pool
rather than the actual allocated size.  Fix this bug.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index e8599bb948c08..6c3ed5b17b80c 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -156,6 +156,9 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	/* The allocator will give us a power-of-2 number of pages.  But we
 	 * can't guarantee that, so request it.  That way we won't waste any
 	 * memory that would be available beyond the required space.
+	 *
+	 * Note that gsi_trans_pool_exit_dma() assumes the total allocated
+	 * size is exactly (count * size).
 	 */
 	total_size = get_order(total_size) << PAGE_SHIFT;
 
@@ -175,7 +178,9 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 
 void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
 {
-	dma_free_coherent(dev, pool->size, pool->base, pool->addr);
+	size_t total_size = pool->count * pool->size;
+
+	dma_free_coherent(dev, total_size, pool->base, pool->addr);
 	memset(pool, 0, sizeof(*pool));
 }
 
-- 
2.20.1

