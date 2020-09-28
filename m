Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2627B7BB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgI1XPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5AAC05BD17
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:57 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q4so3007882ils.4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IejZ9HVKdCtJgxeP/Wkw81HQgdzY8PLcZSPCdSMKGqs=;
        b=IuqZoPEAt8lZh+LH8stxOo7V1yhewO+HcnokthjTxP2EN0zz7cqBeSZ7AhPgfb2XEf
         mkeRnkEVb568MfrMG/ECWGzFuYmG1fHXcF8g6V+1R+6R+u3PFxEIUSp7QNfxF5QTD3Sb
         xevQc0awQWvpeNpdNOQ3uxKp+cjKlzZ89xclqi6aH90TGnmmweqhIlQtzodGKNuf/PVq
         PiY996t/tY8Xk1l+onrHiA9zrm+LgH42de3Fn8ao5sq176vi+zRalM7g6QjCSloQa9gw
         ZHWPHlZnpOyiPL2NGa6p4kJF1h99vkZj8hCj9pq5dUuidDqBh+BeCOlhmDryoPsVyjMF
         yELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IejZ9HVKdCtJgxeP/Wkw81HQgdzY8PLcZSPCdSMKGqs=;
        b=K/YyXwGenanuivA24GVIFucQ+2UzeXWxv5Uetu0Ad5PUQcbdUEhPfO6l/sqQl9xiWU
         J+VdgKHwwZwuJKSa5iVvdo+4RfLnGyI+Q7aA51gr1oCIqshFjH8lpcZkP88A2cuUYVGW
         vkpTlYvBjJbEBKBeFfrmjcjbxjcWZMXvpfT5L0YTPoOzEjciZILvsbym17xe/D5l5lXK
         rcOu5WqK++Kd0VpjbfjxryY57ifCoFMeNsDclZMd1n0+IWhF7ugp4t9inyQrVJyItn/9
         CQ+gXeUna3opAhq2pQCvsQxFf/v7T/nTItcHDdguBihLfal9/cRwee4sTEjm/7ke9P/+
         qkjg==
X-Gm-Message-State: AOAM533WvTK5zFRXG89sT/PkFPLKdowPIPqpkdjGV/7mpaA9BCFYd/uN
        b4AFdYRQbHw2ZAh1igzHqwnkazCwlY2eLg==
X-Google-Smtp-Source: ABdhPJzY21tQ1IcsTPzkr/fxeX1zf0OND1STpUfVwi49+pDQJN4uJScWAt4g3wYXTFEH3I6F9zCnlw==
X-Received: by 2002:a92:1952:: with SMTP id e18mr539572ilm.189.1601334297118;
        Mon, 28 Sep 2020 16:04:57 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:56 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/10] net: ipa: share field mask values for GSI general interrupt
Date:   Mon, 28 Sep 2020 18:04:43 -0500
Message-Id: <20200928230446.20561-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI general interrupt is managed by three registers: enable;
status; and clear.  The three registers have same set of field bits
at the same locations.  Use a common set of field masks for all
three registers to avoid duplication.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  2 +-
 drivers/net/ipa/gsi_reg.h | 21 ++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 203d079c481c4..cb676083dfa73 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -271,7 +271,7 @@ static void gsi_irq_enable(struct gsi *gsi)
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	/* Never enable GSI_BREAK_POINT */
-	val = GSI_CNTXT_GSI_IRQ_ALL & ~EN_BREAK_POINT_FMASK;
+	val = GSI_CNTXT_GSI_IRQ_ALL & ~BREAK_POINT_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index b789e0f866fa0..8e0e9350c3831 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -340,29 +340,20 @@
 			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(ee) \
 			(0x0001f118 + 0x4000 * (ee))
-#define BREAK_POINT_FMASK		GENMASK(0, 0)
-#define BUS_ERROR_FMASK			GENMASK(1, 1)
-#define CMD_FIFO_OVRFLOW_FMASK		GENMASK(2, 2)
-#define MCS_STACK_OVRFLOW_FMASK		GENMASK(3, 3)
-
 #define GSI_CNTXT_GSI_IRQ_EN_OFFSET \
 			GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(ee) \
 			(0x0001f120 + 0x4000 * (ee))
-#define EN_BREAK_POINT_FMASK		GENMASK(0, 0)
-#define EN_BUS_ERROR_FMASK		GENMASK(1, 1)
-#define EN_CMD_FIFO_OVRFLOW_FMASK	GENMASK(2, 2)
-#define EN_MCS_STACK_OVRFLOW_FMASK	GENMASK(3, 3)
-#define GSI_CNTXT_GSI_IRQ_ALL		GENMASK(3, 0)
-
 #define GSI_CNTXT_GSI_IRQ_CLR_OFFSET \
 			GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(ee) \
 			(0x0001f128 + 0x4000 * (ee))
-#define CLR_BREAK_POINT_FMASK		GENMASK(0, 0)
-#define CLR_BUS_ERROR_FMASK		GENMASK(1, 1)
-#define CLR_CMD_FIFO_OVRFLOW_FMASK	GENMASK(2, 2)
-#define CLR_MCS_STACK_OVRFLOW_FMASK	GENMASK(3, 3)
+/* The masks below are used for the general IRQ STTS, EN, and CLR registers */
+#define BREAK_POINT_FMASK		GENMASK(0, 0)
+#define BUS_ERROR_FMASK			GENMASK(1, 1)
+#define CMD_FIFO_OVRFLOW_FMASK		GENMASK(2, 2)
+#define MCS_STACK_OVRFLOW_FMASK		GENMASK(3, 3)
+#define GSI_CNTXT_GSI_IRQ_ALL		GENMASK(3, 0)
 
 #define GSI_CNTXT_INTSET_OFFSET \
 			GSI_EE_N_CNTXT_INTSET_OFFSET(GSI_EE_AP)
-- 
2.20.1

