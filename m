Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F202A85DD
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbgKESOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732074AbgKESO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:28 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397A4C0613D3
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:28 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id g7so2198509ilr.12
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6hqCj0tMKM1EuB0m76cT3vI06GLzDxohCD5yuyuwLw=;
        b=B59okf/n9Ls0Wdu8ltBD/DJnBqNEs4ppbxg7628Ru7FSm6W7rJIAcyNWWfUAODuuEg
         Z430rsxDNLTtap7BlQc0rmyJurfl+Vul23DOZp9UUtTnj8PSN2/RYXHnaRYSdI6ZMcq8
         HlSQEtjmyOv31atxwEUAD9h6/+uWzSNClBejBVqVuEXswMxFt2RH65KxlLTt8NxYTcJb
         ZVPBiCMAf3l8stOd5SlYSgUUN5nwM9YLLgrpRuMJIMZ9IM9IlhbXqPUYF6lthrZeRWTZ
         u4oQd35847Z694U7ueWV/fLn2fe1x3aZG6ND1w+e1LlzG/S8T0Qymopc+b4OpghvvtvO
         OZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6hqCj0tMKM1EuB0m76cT3vI06GLzDxohCD5yuyuwLw=;
        b=Q33gHuigvjrX0pC8OMG8ggUwLwLrdHOLZCYBViA3pc56ljO3FoVtH0iZszo0E3sIa9
         fD/6OEmhpHLIQykuIWPAoVLsuTXD0H5/yiiufSuSYt9H2y5c70ZqhBcYxc9G4Hc8G3F9
         JOZlygEa1QUXlnSdVAa3uMhQIM2ua1FSRBuku5MwxY8xjUncAsN8jTIYwdeBL3ft1aCo
         XgGE+GI1pn0KUGSY69P4g/UA4LDvENzkxH1O4FBSqDfQSFiRm5OazZF/5c8GKprLE513
         8PI0ZK3S0iafyNpoE97CpjtUbfaGFSvVkld21TkF3OL+q2w90TW2COujapqqLGNdaVWv
         wvnA==
X-Gm-Message-State: AOAM531SWKeElAKKbyno3FmGvclp9uCAjEKUiGC7TWoWBo3JR/7cFa3U
        JspxD0AXy+5ogcFGoBtSBLrq9A==
X-Google-Smtp-Source: ABdhPJw+4DHtJN+UzL8orcCVgBrajxtK2tnXexbFSsnNW2MR+HQCAoGRMaIKKDMeWI3EjmWZnSp4Vg==
X-Received: by 2002:a92:ac0e:: with SMTP id r14mr2991363ilh.197.1604600067550;
        Thu, 05 Nov 2020 10:14:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/13] net: ipa: explicitly disallow inter-EE interrupts
Date:   Thu,  5 Nov 2020 12:14:05 -0600
Message-Id: <20201105181407.8006-12-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible for other execution environments (EEs, like the modem)
to request changes to local (AP) channel or event ring state.  We do
not support this feature.

In gsi_irq_setup(), explicitly zero the mask that defines which
channels are permitted to generate inter-EE channel state change
interrupts.  Do the same for the event ring mask.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index aae8ea852349d..5e10e5c1713b1 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -259,6 +259,8 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -307,8 +309,6 @@ static void gsi_irq_enable(struct gsi *gsi)
 	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
 
-	/* We don't use inter-EE channel or event interrupts */
-
 	/* Never enable GSI_BREAK_POINT */
 	val = GSI_CNTXT_GSI_IRQ_ALL & ~BREAK_POINT_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-- 
2.20.1

