Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99B3658EF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhDTM3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhDTM3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:29:03 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7900FC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:28:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n127so8255538wmb.5
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GsyGKufi5wHCisc4G59o/96x9Xn+H/DMjNSI77b5beU=;
        b=l3Ji/ViW/UOhE9jP9CoFr1WNOlWh7mSk3O2btmRwJ3fDCjDpuVEO8p8eNI4TdFrVoE
         YW4QyiO0Sk/8ryul8Q9/K5jvun/fCPeYDS6ADqUq0nRsXFc4S3iO78iqOYI55ybtLhNP
         TNMB9oI3OVeLXOVW8kgeVFdPJb43WR9YC0lrGnrFSKAZQInLDRQKQBNP3EY1wnG7rv7f
         SBZYECbuF6PTt5hl1Mfi/nLaKU2w3KghxQIg0s0lN+xRrI/ado2pyKaLVgWT6HxHM/pe
         eT2n709B5KOTJzSCNOPlXgSH1njo+K2TCQBxssxnNxU2xGWirq2zqJVjN9pTP00nqiG/
         TfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GsyGKufi5wHCisc4G59o/96x9Xn+H/DMjNSI77b5beU=;
        b=EwaW7E5e2oFLM8SKCU4hRmKAYAayf8SCMU8bUix0HcWU52BBYz3l/X9o1bDihZqIqP
         0jpQKs4Idlf4oPW2K/kSEfmHTM9+Ey73KVXF+0p9LT02Jaq5qJ3+CLLqDxl5DoFUn6AT
         4ynGvAaCl8u+GnA/FpElmZkMBEMAQpp5z8zYi+9yqxooZdx//R2TjDTpYsik6wNJJwBG
         vrS9iWnA/kdMQsOSEhL/n335KCWsAlfJa+z9Y7+ADXP5fPc7gu0hlADzbrTk3E058Zny
         4l+bnKF97hypxtpXCp45JsqB8Wy5Ff5PZLpU6ZN9Mo39cfaIQjN+5iFy20FvDVXugV8C
         xFzg==
X-Gm-Message-State: AOAM530hPteO0y/xJahYuiNu8b6P0FkIiI9Zrn2Fdr2vqjWOk99jm5g+
        Qf9HzUd+AfpJtVD8huvF6wgC7vPPcy48rw==
X-Google-Smtp-Source: ABdhPJz9NE4uS9qljtgwbrfwTo2CsfXSIWCPqYpycCFHJ988VobvRMRxFlp+dtdN2GiIa/eaM2viPA==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr4412297wmj.84.1618921710351;
        Tue, 20 Apr 2021 05:28:30 -0700 (PDT)
Received: from [10.108.8.69] ([149.199.80.129])
        by smtp.gmail.com with ESMTPSA id s16sm3133716wmh.11.2021.04.20.05.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 05:28:30 -0700 (PDT)
Subject: [PATCH net 2/3] sfc: farch: fix TX queue lookup in TX event handling
From:   Edward Cree <ecree.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, themsley@voiceflex.com
References: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
Message-ID: <6f8dc43a-4693-3f2e-51d9-c941e2256a2c@gmail.com>
Date:   Tue, 20 Apr 2021 13:28:28 +0100
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
 efx_channel_get_tx_queue() is inappropriate (and could return NULL,
 leading to panics).

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/farch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index f89ebe0073dd..49df02ecee91 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -835,14 +835,14 @@ static void efx_farch_magic_event(struct efx_channel *channel, u32 magic)
 		/* Transmit completion */
 		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_DESC_PTR);
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
-		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue +
+				(tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 		efx_xmit_done(tx_queue, tx_ev_desc_ptr);
 	} else if (EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_WQ_FF_FULL)) {
 		/* Rewrite the FIFO write pointer */
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
-		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue +
+				(tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 		netif_tx_lock(efx->net_dev);
 		efx_farch_notify_tx_desc(tx_queue);
-- 
1.8.3.1
