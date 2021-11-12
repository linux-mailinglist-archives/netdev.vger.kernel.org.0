Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB41E44EF2D
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 23:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhKLWZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKLWZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 17:25:09 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7BC061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:22:18 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w22so13061631ioa.1
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vBvf+NulIyt0LTL/apruhCuQuT1ch+DwHu+pDQ7AiQw=;
        b=RRVA0tA2+HDRrngBIjTLvD9iiLWFFT1PXs2jwihVCqapwBP30Z1UPD4y7M1mFe6/a0
         JUbWBeZneQDSyrIyrfApEJeP5ghlXt9aTIKWrEkGcx/RxzDsSePjQYF+PWL56N+9R5nx
         sQH49N0O764b40Uu1qaEvrqiD2512e/qtJMkp+0ER+byhlvT/pgVbWlSKjodwNJai4V1
         1sZ4ZsB9ApTlVmf3pTzMuP7PmOymMvM8P5qbJb2OyAVjU0DByqo3NYPg+AIdO5HwMHE1
         5e5SB+F3pRtVf2711swQy04i9maplbZ33qLkdWn2OhDBA6Pwd1YOVQGFR8cU05iO60lx
         01iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vBvf+NulIyt0LTL/apruhCuQuT1ch+DwHu+pDQ7AiQw=;
        b=nsJDI4NrF1pgKVbxB5GGdNnBZE0NZVHdy19OsrMxb2ObhzCPdTlZY5DDRVSU/Ah0Nf
         eh760QeF1JjCbV47Y5Xpsmcf5rO94Nqe8DHWFXz+SbsXtdHFPLxc4/uFpLmfXH1FwSnS
         5z8yKGgppTG+I7ODLbjcxX8m8hTQQ99zLTU1vUDXLAzZhLBNn2ZtJ4kiGfaVVoYEJa17
         B77ZpgTQbKXW2RKfFN0jYv2gTkSosiG+aY1zgvAUsE39VxvjbFF4UhFhznyQp/4pjmDn
         6CFhy2P1DeCG7PPtQnsDPtsTiIg97vWXMa66pqufgk62/b/Qee3PaA5MI+DNIOQ8Bl+4
         YL8g==
X-Gm-Message-State: AOAM532t2ucrlxjgMwz2sI3lWV47Schpd/Y5SQCmBm7B7pS6IWux+GuV
        fN8AYPYBgG/6XlKTX0OQdbInmQ==
X-Google-Smtp-Source: ABdhPJwWtlycZTqGisu6Ug8roHF41gN5Bw9kANuFsx+AcIeRV3NfUqORFWEADHDWMISB8wPg4692Sw==
X-Received: by 2002:a05:6602:140d:: with SMTP id t13mr12888620iov.120.1636755737658;
        Fri, 12 Nov 2021 14:22:17 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y6sm5241117ilu.38.2021.11.12.14.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 14:22:17 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: disable HOLB drop when updating timer
Date:   Fri, 12 Nov 2021 16:22:10 -0600
Message-Id: <20211112222210.224057-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112222210.224057-1-elder@linaro.org>
References: <20211112222210.224057-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The head-of-line blocking timer should only be modified when
head-of-line drop is disabled.

One of the steps in recovering from a modem crash is to enable
dropping of packets with timeout of 0 (immediate).  We don't know
how the modem configured its endpoints, so before we program the
timer, we need to ensure HOL_BLOCK is disabled.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 006da4642a0ba..ef790fd0ab56a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -853,6 +853,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	u32 offset;
 	u32 val;
 
+	/* This should only be changed when HOL_BLOCK_EN is disabled */
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
 	val = hol_block_timer_val(ipa, microseconds);
 	iowrite32(val, ipa->reg_virt + offset);
@@ -883,6 +884,7 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 		if (endpoint->toward_ipa || endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
+		ipa_endpoint_init_hol_block_enable(endpoint, false);
 		ipa_endpoint_init_hol_block_timer(endpoint, 0);
 		ipa_endpoint_init_hol_block_enable(endpoint, true);
 	}
-- 
2.32.0

