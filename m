Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ACF3A203E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhFIWi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:38:26 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:38622 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhFIWiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:38:22 -0400
Received: by mail-il1-f180.google.com with SMTP id d1so25078676ils.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZrDcpMMlqQu3fRlEZdQrN5iR4OJZ5NusdCMN67AVgE=;
        b=VbBBEnLk5xTZzb/Cb2h0QG052xVazdTaNFC9Ne4MPDWmHwZVI1eml2LfDSVsYrPYzQ
         0Lwmhh8zfTil+/PVpu9d1BOEVunxHLuNarzy7Iu61t+0fKku3GUIpX4Rl00/iqyxm2my
         yJ+lwHU61V8PmRCLijwoGkjbWG4X3OrQktTMo41JXZTvoVQDGAFpkQJTIa/x+lbWCt7k
         gLk/3Qyu2F4/jh/6hHojgXRgHXt8/AwPXwGWKhh5hWDsfVUrec6yNXI0vRyPK4n0iErD
         bCPNw+VgqJ1+D75PXzcjr60A4vpI3Gk0IPYrXTAyufM/i+SjmDtXKghUokm461nAXGFO
         8YPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZrDcpMMlqQu3fRlEZdQrN5iR4OJZ5NusdCMN67AVgE=;
        b=Oj1/AeQgg0qXES8soNElCqULOolhg+6IYzuWQpGjSIy8SQfEO4Z0WgQWINpan5bAIM
         sNylUJx5BL7TSw1V0cLpqVmIvyBIWd5RIDm8hgEmXgeFZuerujSmGRZ3LNMexa+BDvwM
         FnuBIMbf18wGaSIPYGTPZioenQuH5TfIniQAtnCjv583PZqD1B+kZdncfBo8yE4Wixqu
         7S569z1bG6n0w/LzxFBxH13FySn37fhubeQu1cE6ZkOh/SKXnRU3kS1F/GBqLL3pKw+s
         N2KTD34GQKhD3640NSvE230jXnhE1Dl/tLaH3DhrzJ78emUFve9Oc6LD3Fe/PThjxYFh
         25kw==
X-Gm-Message-State: AOAM532XtxEZJBFZI+tMzv4cfZOFf/UxHTSDKnXOLzBy2iacML+38iX7
        whgRigmfSOqZSfbXLiMslCzasw==
X-Google-Smtp-Source: ABdhPJwojNRR81zbsSbZ/Jyrq2irJoQxLzBQrqQbEYIrJZqjvlarKRQfq9Ipy0Y+MgW61CgekQY0pw==
X-Received: by 2002:a92:c68c:: with SMTP id o12mr1473796ilg.6.1623278112288;
        Wed, 09 Jun 2021 15:35:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/11] net: ipa: validate memory regions at init time
Date:   Wed,  9 Jun 2021 17:34:58 -0500
Message-Id: <20210609223503.2649114-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the memory region validation check so it happens earlier when
initializing the driver, at init time rather than config time (i.e.,
before access to hardware is required).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index f245e1a60a44b..b2d149e7c5f0e 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -215,10 +215,6 @@ int ipa_mem_config(struct ipa *ipa)
 	ipa->zero_virt = virt;
 	ipa->zero_size = IPA_MEM_MAX;
 
-	/* Make sure all defined memory regions are valid */
-	if (!ipa_mem_valid(ipa))
-		goto err_dma_free;
-
 	/* For each region, write "canary" values in the space prior to
 	 * the region's base address if indicated.
 	 */
@@ -528,6 +524,10 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_count = mem_data->local_count;
 	ipa->mem = mem_data->local;
 
+	/* Make sure all defined memory regions are valid */
+	if (!ipa_mem_valid(ipa))
+		goto err_unmap;
+
 	ret = ipa_imem_init(ipa, mem_data->imem_addr, mem_data->imem_size);
 	if (ret)
 		goto err_unmap;
-- 
2.27.0

