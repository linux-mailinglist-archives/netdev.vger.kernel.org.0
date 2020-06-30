Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766B620F5AA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgF3NdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732971AbgF3NdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:33:11 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02281C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id a12so20984255ion.13
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=riisFCPpfIy+ddIeKemrrsU0BmBozz0Ml8rD1KyP5/o=;
        b=ktsLrCTc/Su3iZGXae226c0RZ8TahBwtS3/Dt7AIozO9WfjMBKih7FkhSYt1fxrd0/
         yR6k0TlCcG5GCV80FF+WW7HVUzzltC1l7tW5M8j+XiE9zZOjeetKjDQa4EQ8mGkSkaiO
         RwmSvFCuXcrHLyTP+P6HiPUcdP+6hAILeqgXSYW5xbEKwr/rHsr8hNgCaF+DTVIbxPH+
         gRDyLDtdmzzgX5tOfgdjiZRxrBHcZZmZ4mI1Sq3MMPfUW6OSWYlh8NA95WyOVCUI9eqX
         7kWqrGc3XXVxxfsjnE1V58KffQMqI/taU7buHFFkVyuz+VGs0lxFJeeVQdj9pr0v7u5f
         F2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=riisFCPpfIy+ddIeKemrrsU0BmBozz0Ml8rD1KyP5/o=;
        b=Ygu+3jW2Qti0lshIs8KSAEIruFDu4DGWM2cERfJl03FQ0Pxu4FVbZYPDUNFASfwxd6
         3J/KS1MI0k2c8cX90h+gaEyk13XlvRuMrEN2RhBUyjwDzOS903bW+6jPR6Iiex2UUw9/
         8UXybUFpmOLiKGHRFNqEClIQoVir4PSDtN8ypXzSIXXdjur/6so2p7XR4pt+p5JuXwUv
         02/EJ0cctOo2gBALY013UBfCYkA/YaJFnT2JwDFhMMqM80Ma8EHC5HocBfyDl6MKw5i9
         lCE2fF6ds6RZde1llEn9j5z+xH36tKX7aciLsOKjQBrU8Gmq+npb+K6pJ+w6Uk6NnZoa
         IQIg==
X-Gm-Message-State: AOAM530F9AXJuir5p81YJLwwuixJAzYsJJvTZ7kGBRGl8MtnebEbquQe
        aSn82g1pGFNGaW8qs2AJx9H9GQ==
X-Google-Smtp-Source: ABdhPJyxkdvw3QKz0HMO2AiqGyCAIpBnZDMY5qytsopl8ajmuCMHUpnwfXppdlrX47I2lC/rIJPUmA==
X-Received: by 2002:a6b:8e56:: with SMTP id q83mr21855491iod.61.1593523989803;
        Tue, 30 Jun 2020 06:33:09 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15sm1538776iog.18.2020.06.30.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 06:33:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/5] net: ipa: metadata_mask register is RX only
Date:   Tue, 30 Jun 2020 08:33:01 -0500
Message-Id: <20200630133304.1331058-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630133304.1331058-1-elder@linaro.org>
References: <20200630133304.1331058-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The INIT_HDR_METADATA_MASK endpoint configuration register is only
valid for RX endpoints.  Rather than writing a zero to that register
for TX endpoints, avoid writing the register at all.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: The commented call to assert() that was added is now gone.

 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 31afe282f347..1babcfc79360 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -530,7 +530,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
-	if (!endpoint->toward_ipa && endpoint->data->qmap)
+	if (endpoint->data->qmap)
 		val = cpu_to_be32(IPA_ENDPOINT_QMAP_METADATA_MASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -1302,10 +1302,10 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 			(void)ipa_endpoint_program_suspend(endpoint, false);
 		ipa_endpoint_init_hdr_ext(endpoint);
 		ipa_endpoint_init_aggr(endpoint);
+		ipa_endpoint_init_hdr_metadata_mask(endpoint);
 	}
 	ipa_endpoint_init_cfg(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
-	ipa_endpoint_init_hdr_metadata_mask(endpoint);
 	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_status(endpoint);
 }
-- 
2.25.1

