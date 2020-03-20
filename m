Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EF418D377
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCTQC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:02:27 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:40408 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgCTQC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:02:27 -0400
Received: by mail-qv1-f65.google.com with SMTP id cy12so3211620qvb.7
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nEXV7f7OLrPPpLBkVTxsyZh4hXKceEQGD47QjUNsjwI=;
        b=rTvYxlF/pGTLWPLsFEoyRwq0ScuYph3nxQEse3YxKoayW7g1jB1rjMRQicqRbga34t
         k9+Xvu908nwggeZFO7UMovn8+U9jcSz9ygjM4XTqbB5YXwZufY+U0EcID8TTkvgrY/ee
         m8F0+ifzVGPORWcGgwB5FhQaXnO+KIzu0drZU8Wu6W7IHERJY2UHOU7C71Fibch6xL2u
         KVC2sBA0QLCstDS2vg3LBwGr44Pf69X1eqtUkLitSHgNdpKxcNK33d2Kfu6+YzoQvOjp
         /vuvz7q9YtKa4cJFCoLjK1N+GCD7k6bcsDWPYkN2NSOm+BXECvzNPtUf/0vlKSHjk6h7
         5SBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nEXV7f7OLrPPpLBkVTxsyZh4hXKceEQGD47QjUNsjwI=;
        b=EzHztG6JnEPG1l0Xo1NlIAXwFWmBu1nagtSm2M1fiNITSzKgClVO7iwN09piEGYlfi
         em/8CTozaBCun1GyBHilNVgd97j5Fm7VmyZd7lkn81ZhuF43XxORsZM5EzevlYRrDo66
         YKNhSo8blgoPPjSkjoRiEJt/lgnMoftYwd9qIrMoK36yBwoSh6cCRhpuIN3/49LYTuDm
         uZI6B53h1pWpIlCdF2BaNeRNe1YPwrLI0wF+zG5PA/F4TuQTc3eFhRey2jznmKPbrWhq
         B+ki8K2xd01waOjO4H3wybf59cXxwPMIP3uRBHsqUrTEJPvgCeGu/6hIrHwlIxHncbXr
         uqQA==
X-Gm-Message-State: ANhLgQ0aI6dml643pqOqMvIaREDc5Q+F7wreYmiJSHXJWfEzfTBK7vAI
        etam6ct6I8d5BBG6sOUgjztCLg==
X-Google-Smtp-Source: ADFU+vvTpfHka/t7GmFisaLRGj+Pw/RaMT+OgZv8d398Bsml8mWd7ly8I2zR5w28CPShZVo+7mLwlw==
X-Received: by 2002:a05:6214:1703:: with SMTP id db3mr9065713qvb.28.1584720145521;
        Fri, 20 Mar 2020 09:02:25 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y17sm5066925qth.59.2020.03.20.09.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:02:24 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
Date:   Fri, 20 Mar 2020 11:02:20 -0500
Message-Id: <20200320160220.21425-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't assume the receive buffer size is a power-of-2 number of pages.
Instead, define the receive buffer size independently, and then
compute the page order from that size when needed.

This fixes a build problem that arises when the ARM64_PAGE_SHIFT
config option is set to have a page size greater than 4KB.  The
problem was identified by Linux Kernel Functional Testing.

The IPA code basically assumed the page size to be 4KB.  A larger page
size caused the receive buffer size to become correspondingly larger
(32KB or 128KB for ARM64_16K_PAGES and ARM64_64K_PAGES, respectively).
The receive buffer size is used to compute an "aggregation byte limit"
value that gets programmed into the hardware, and the large page sizes
caused that limit value to be too big to fit in a 5 bit field.  This
triggered a BUILD_BUG_ON() call in ipa_endpoint_validate_build().

This fix causes a lot of receive buffer memory to be wasted if
system is configured for page size greater than 4KB.  But such a
misguided configuration will now build successfully.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---

Dave, I *hope* this is it for IPA for this release.	-Alex

 drivers/net/ipa/ipa_endpoint.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 217cbf337ad7..6de03be28784 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -26,8 +26,8 @@
 
 #define IPA_REPLENISH_BATCH	16
 
-#define IPA_RX_BUFFER_SIZE	(PAGE_SIZE << IPA_RX_BUFFER_ORDER)
-#define IPA_RX_BUFFER_ORDER	1	/* 8KB endpoint RX buffers (2 pages) */
+/* RX buffer is 1 page (or a power-of-2 contiguous pages) */
+#define IPA_RX_BUFFER_SIZE	8192	/* PAGE_SIZE > 4096 wastes a LOT */
 
 /* The amount of RX buffer space consumed by standard skb overhead */
 #define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
@@ -758,7 +758,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 	u32 len;
 	int ret;
 
-	page = dev_alloc_pages(IPA_RX_BUFFER_ORDER);
+	page = dev_alloc_pages(get_order(IPA_RX_BUFFER_SIZE));
 	if (!page)
 		return -ENOMEM;
 
@@ -787,7 +787,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 err_trans_free:
 	gsi_trans_free(trans);
 err_free_pages:
-	__free_pages(page, IPA_RX_BUFFER_ORDER);
+	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
 
 	return -ENOMEM;
 }
@@ -1073,7 +1073,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 		struct page *page = trans->data;
 
 		if (page)
-			__free_pages(page, IPA_RX_BUFFER_ORDER);
+			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
 	}
 }
 
-- 
2.20.1

