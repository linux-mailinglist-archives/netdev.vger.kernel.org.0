Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA93729D27D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJ1Vct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:32:49 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:46179 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ1Vcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:32:45 -0400
Received: by mail-il1-f194.google.com with SMTP id a20so920580ilk.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s43f85+WbHjGIt0fEgoku0r8l29LSpKBU8YM5eW/h3c=;
        b=aXL55zqiNE0mMnQt+yR2/P2FG1Gg0c33k6O5L/MPe6rK/dYDoSPeB9CRfPYVPtocEP
         Ir7yE9gozl5H6q2FsBs6TPu1gIcXByKSIAIo46fcK8rNUnfrAgYKkP7BevUqZaAbFueR
         j/YGSZq99VWicSeBrDovoycoDIOngbnqGBXrBA/8FQaIBu6rdrc7WtsC+OyYwcMS6tBi
         Zug3bRiTpPCj8nXR9QaaWMBtCStvwIR2xLI7cGqrL8aAMqOHDXs88KAImgD9N3+Gx04A
         4hFwv/Nu3gqQFZ48nPZHGqkyYsDI4NWTQR9R6R7FkC2gLUBR1QQ0vkjlWWd1YF+h++Gd
         tNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s43f85+WbHjGIt0fEgoku0r8l29LSpKBU8YM5eW/h3c=;
        b=U/yYwA5CVGjNSZnGFIy2Fcq/WzpY5plRh6aqEjvRwxrobROZ6q7SNOcoNixUgUBZ+D
         quGE9AbwdgNQYJ27aN4RQnk6yd9Za0/1Ny24o9ZObhkhtOxY5SLu3/BVItpYNB9qFleB
         zSIcGodL04/0kiFvo4COot60UM0rycMuNqfgx/S6Z+U/gk2zorONnzgnLpEq923TwF8c
         flcVjtpwnZA5o7C0AwnpxVR7i3zAMpO3Kjx2vpmlbBNSh/lL90CkJbjATrWdVFuW+MTf
         djyqIW2y8RhFGNzx5/Y+XijZIX+1FCy7d0+N7au5Lu9z1ZvA4yxySPUl2F4aFE/TxfN3
         XXzw==
X-Gm-Message-State: AOAM533+93vpoq4ABbnqVNhteggcX/O3chyAWkiVoFzfxb0AL5GAFOSO
        5HMsicOJhPH3EHazv5mo1TBSMowpU15JlgU3
X-Google-Smtp-Source: ABdhPJz67PzC+3Wvsw8DNWphJhyUwxKjOFsLopMwrao+z3oypgBaWbA3EQIOQs6lqOs79QVntzAvyA==
X-Received: by 2002:a6b:3c14:: with SMTP id k20mr849364iob.12.1603914114829;
        Wed, 28 Oct 2020 12:41:54 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m66sm359828ill.69.2020.10.28.12.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 12:41:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/5] net: ipa: assign proper packet context base
Date:   Wed, 28 Oct 2020 14:41:44 -0500
Message-Id: <20201028194148.6659-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028194148.6659-1-elder@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the end of ipa_mem_setup() we write the local packet processing
context base register to tell it where the processing context memory
is.  But we are writing the wrong value.

The value written turns out to be the offset of the modem header
memory region (assigned earlier in the function).  Fix this bug.

Fixes: ba764c4dad7bd ("soc: qcom: ipa: clocking, interrupts, and memory")
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 2d45c444a67fa..ecfd1f91fce3b 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -89,7 +89,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	gsi_trans_commit_wait(trans);
 
 	/* Tell the hardware where the processing context area is located */
-	iowrite32(ipa->mem_offset + offset,
+	iowrite32(ipa->mem_offset + ipa->mem[IPA_MEM_MODEM_PROC_CTX].offset,
 		  ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET);
 
 	return 0;
-- 
2.20.1

