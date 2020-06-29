Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8A020E414
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390922AbgF2VUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390659AbgF2VUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:20:45 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65D6C03E979
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:44 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id s21so666941ilk.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ikmoMwgWrI1HSTvIu3OsRZsmkzSggb5efR8I4lGwKfU=;
        b=sNLU/2+B0nxI/itWKc1EQzh6GK7KMZMGj5NLUcnvhUyQrjoZJUGpniCudLZIxJRNH6
         lu6+5OQe+k6rqJZ1/QFthfraObsnIne4IodPSIBP05ya0avWoVWlC85uVgbF2DzYo6eK
         ZZucb9PINrN62vWvBTLNTRqpmIeyx5BVy2PKB+Xoipglj1h7B3SZshMox+7qySHR2N5H
         XMjGf4qMiAd2WR8jXGaee1sSeSzEQ7Diyzhm1Jg5n2fHjGD3I8VSFpdPBMaszoT2OW1c
         bXlVYGy3kcIsLw2YMc999fZ9kWiT9JUAAJSO22+X8FmWmDdqDkKpbPLd9TezaY7+nS0D
         +apw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ikmoMwgWrI1HSTvIu3OsRZsmkzSggb5efR8I4lGwKfU=;
        b=t9ufcqFwAn1rBvoZv4LLAIzEhhXJdQ//dPL4MMT6Y3MkYu51ty/K+MXVB/3R2Pv2J1
         2wSCJW94kyeA3rLM6xbOJPaQVp3awPs3fqdUw3z+2UvUUrDSg47zV/6AvNP3pohdshza
         mpHcweu3HVf7IBrtEmwQHxDlc6dO/x7josX6f25zAhASlKNNQg+Pl9BxVAbzSYnIHPfv
         2aMemMPC+/IWXcUOCFAMuUdYpOb0vbMk3HlFAf5R/kxKOTAf259sXd1fvt2znpNp2Ao8
         kArj3yEQspnLmnGCp8iAN2aR1TL33vwyi7B+MLLOFPuSbyQN9XtSwuZ8PELPbaJ+yojm
         8deQ==
X-Gm-Message-State: AOAM532xQA3G3fQbP8hJmdhqV+bUIcCa5vi7HFUv0ZB9JF2pSC9EnQLP
        i1AX7zn5yLV+Z9Gavk2eGLdMcA==
X-Google-Smtp-Source: ABdhPJzaAN/WcKfob045owqNeJnOq0QdhsRI7nvnbKBceIkYWSW5Vf6REkPoEjNAFbKHvMTEj0l51w==
X-Received: by 2002:a92:d843:: with SMTP id h3mr18802430ilq.255.1593465644108;
        Mon, 29 Jun 2020 14:20:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm564588ilj.15.2020.06.29.14.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:20:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: ipa: no checksum offload for SDM845 LAN RX
Date:   Mon, 29 Jun 2020 16:20:37 -0500
Message-Id: <20200629212038.1153054-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629212038.1153054-1-elder@linaro.org>
References: <20200629212038.1153054-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AP LAN RX endpoint should not have download checksum offload
enabled.

The receive handler does properly accomodate the trailer that's
added by the hardware, but we ignore it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sdm845.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 52d4b84e0dac..de2768d71ab5 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -44,7 +44,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
-				.checksum	= true,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
-- 
2.25.1

