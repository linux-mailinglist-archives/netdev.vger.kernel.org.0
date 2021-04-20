Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6053658F5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhDTMaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhDTMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:30:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30429C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:29:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so19950285wmg.0
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=idEPD5rUsjS/1PdgK8Eh+SNp8CsoHFKI5gJGmL9uNIQ=;
        b=unNhaT3HHUaEvMEpsWhFTfTa6aS5R5yuMwBQqlzNbdAbgRnLV/tWvDaiMBJxl1yt2P
         ExiCQJbm4Gulcdv66YbvJdVdx504nfKyg0k3iKF8ovl/ajyXJfA/dAi2EroyOWQs5dTJ
         qPSqge3F5rVdht3d9IHuDQk/aDvDtKe7FX6oTWWcI4AD9FWV7jVJC1faPeMk5fLQqcdk
         itLt6O7uGwrZQfO4hO+SHLLnOiIVk3UT2vNp7VeKW7WEOaNG2z9wFlFKaM0Hbgl87gxr
         I+7tUrtfIquiWlUtp+lDarQAwOCCFQZ7vQxPb0SA+ceY9ZZgVj3ZPtMzHabRcNTHgeE0
         YxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=idEPD5rUsjS/1PdgK8Eh+SNp8CsoHFKI5gJGmL9uNIQ=;
        b=SDMdwBhmEKKUqqUkqAyfLMfLCFdxFcTq6dHHg6ib4LoaUP5uuWgMMpI3lsb6Mb25J2
         2PmxMxa96blhyNorLK6JYu0bXdwo5ByGfnHs/gvonS8JPV6Edknl20nnU8G9Wo0VvXc9
         0+h0qcBTLWNPQqkN2FHcxF+n+4X2n2Ss5Y/FjOcN8AG0HGWND3Uefr14tywmj0cxsMJM
         7v/0BieBeyZtOcGtVoTVrGwCGhEcZIMarROI3UED9ccV7Sw50vYUGmXB5AH2/uX3Kbyp
         rfX7CSzTOrlYo92QhjY9YG89/5xBiF0pxQ2yTQf2Ybtpapnx/xypv9J4sCpr579a6rQa
         bKYQ==
X-Gm-Message-State: AOAM532YhY6wLv7KZ78EUQr4xDmwDmtcoKxTPsqc4Sx/Az3jwM6TEXp7
        xrKuAJVh6QuvspcM6RVngSdKdDUIo0GtWg==
X-Google-Smtp-Source: ABdhPJyrqUoVPrOhpcNevSZVayI4V8qCgNXT1Pv2Tn4ANrXCdpEJ8dgAhz3NO3Um1fu/hu3noTY5jw==
X-Received: by 2002:a7b:cc10:: with SMTP id f16mr4108402wmh.131.1618921776971;
        Tue, 20 Apr 2021 05:29:36 -0700 (PDT)
Received: from [10.108.8.69] ([149.199.80.129])
        by smtp.gmail.com with ESMTPSA id b15sm3140130wmj.46.2021.04.20.05.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 05:29:36 -0700 (PDT)
Subject: [PATCH net 3/3] sfc: ef10: fix TX queue lookup in TX event handling
From:   Edward Cree <ecree.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, themsley@voiceflex.com
References: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
Message-ID: <f40bb10e-5c61-5f04-7fbf-931cc7d57e66@gmail.com>
Date:   Tue, 20 Apr 2021 13:29:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're starting from a TXQ label, not a TXQ type, so
 efx_channel_get_tx_queue() is inappropriate.  This worked by chance,
 because labels and types currently match on EF10, but we shouldn't
 rely on that.

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index da6886dcac37..4fa72b573c17 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2928,8 +2928,7 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
 
 	/* Get the transmit queue */
 	tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
-	tx_queue = efx_channel_get_tx_queue(channel,
-					    tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+	tx_queue = channel->tx_queue + (tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 	if (!tx_queue->timestamping) {
 		/* Transmit completion */
-- 
1.8.3.1
