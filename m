Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC8529BABC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807536AbgJ0QLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:11:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37704 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807514AbgJ0QL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:29 -0400
Received: by mail-io1-f68.google.com with SMTP id q25so2127285ioh.4
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K0yM3M4HRHPMW9aRwUGo0JZZrI7I9AQrqcJLw5GYIWw=;
        b=yBByF+VqG3N+unBFnvTP8XpxBlm1eMtr3vA/X6lLyAmCUJHOjxtXmkxaGWFP1l7FU+
         boL7PYJP3IiYakpInMix/CAH+/C97s/iLGYEfWkOXv3QmecirTc+5LZJByjhu8zWdsm5
         4gv5PnoLeysZHqVDbb9xxohd2oAzPLFeVIm0uASGap4EC5G55uvOAYyeNeQqJZhFPCZV
         2Nd8ZUqb2Uqp5lVsBk0MsDQXISRyqbJBC+36xt8sp6rCZSHTbxQ9BT7mb6bbWlW3cm0J
         DmwxfZ20FQn3CGPmnCDRjC+uVFv4UtIw/cltlcQs174VRT4WsMuVyHBlC4rMJUM/B7/v
         E0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K0yM3M4HRHPMW9aRwUGo0JZZrI7I9AQrqcJLw5GYIWw=;
        b=LPU5x0Kow812L0qzjuh3nZNsmsf1Sm3NxRWcH3J6i2w2Z/NMqqeIvxY47Mi0C7Tssn
         EXJvKyPwmTBvEx4qRjqv5jzLmcGgB4qrju5kHrCt0nWLCKQheRTHZ1NHSioeLP80pRhM
         KXr6L2OoDJXXckuUkW/AISTN+wJK4tOty3NvBSZv9Gnb+JT2XCX2tsEsOVhYqUr5GpCF
         DFnVM8vuVRjHNA2YaMwOhCEt4Npi/50+2m6Lv0qrRvNztMuV+7fS86TN6qLl+X8l4mpo
         VGpLZhfciLc1LWefSIJ2z14Ut1/6ywygMdXS0eAfHKfrCGreGDQ7tasJ/Ue4lIrjR5RI
         HQqw==
X-Gm-Message-State: AOAM533fjBN8/jxIeXCrcppV5VGguO4vSo9Q7ZKinb1bT9HfB3kH0Vvc
        jI3EX9Eq/K77cwbsTe86jcRk2g==
X-Google-Smtp-Source: ABdhPJx3neAapFqcccbFscS5tFthGTx7+4okWPJS8e8WwQYI0BYSkh9mq6ugrFleyclHe2RZavKZaA==
X-Received: by 2002:a02:ec3:: with SMTP id 186mr3081153jae.92.1603815088531;
        Tue, 27 Oct 2020 09:11:28 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/5] net: ipa: assign proper packet context base
Date:   Tue, 27 Oct 2020 11:11:16 -0500
Message-Id: <20201027161120.5575-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201027161120.5575-1-elder@linaro.org>
References: <20201027161120.5575-1-elder@linaro.org>
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

