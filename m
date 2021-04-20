Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723E93658EA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhDTM15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhDTM14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:27:56 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292BAC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:27:25 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p10-20020a1c544a0000b02901387e17700fso958496wmi.2
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XoeIRb0eHe4jsIbV771Ps2kfvlWkmrvexCN/09xmdRg=;
        b=OUlETLIbze08UFiFmolckV0gz8pZXUmgDoaedMuU8i409mNQ2SBZm67EqPYYxCrSsT
         rhSYXMxLU8sMEyWZk4j4hnaSKGOpMXew6q8kIH45AUHsFv18zh9MLhrDBhRvMfO3BdIv
         WfDbWnOy0B2tOfIGgvc+2mvrwp4U92COMIsIE0ORSbHurMErzjSeC+DornLE9uF1O1+j
         vT8KYj1rhGDu+xBegMuyq3ZYzXz5ggl+pR6D1aMuAQyYN+yZZl4c8Rf3aXeBxnddKPh1
         INLyj9RvTTHVmVozXbYpZ3n6I0gLBO2F/lgIPfD5iUZcglcTWGqkdIjIr/eWI+56Ig2p
         d99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XoeIRb0eHe4jsIbV771Ps2kfvlWkmrvexCN/09xmdRg=;
        b=bHvvZWcBEHTkMyZA50i1gFbBGWUEqBUeRtd/RC7J6Rnnl15ShTKh/Xj2/f8hay6aWN
         W/Vek0KDZoL+iqevXopde4P3EQsfAAnc9WGxTyhuRlA5PnVME6L9Icqli+0wokl7XjU3
         k3cJfkWzcfViQv74XbznwUvr8+iOhgzJKs87dNYc89aalbD1v2NU1ljtCQ5XKtjmhS53
         wa3RLO0FYNWVVIcO8rsgAT3n0JmfTfDdPuEHCrnS7zWEiLPMUtvunuYmgu3lbFe/tYPQ
         p59p8UaXVU/WR6WLHzQkn+3ZEn98lHXjOZcX6O5/QSn1B5HE5AtWTljacVBtUwlnVjfh
         dLYg==
X-Gm-Message-State: AOAM532j30Tbw1jN5DfTh1Skqml1f1Qx1j+nO+6KrYrIsKnM5tzwIuVV
        gM0GT+L97wIg64XsOmc2nfDxdk9a12aIwA==
X-Google-Smtp-Source: ABdhPJxX5FY3R1Qh9PnNPbecdhi/s/Keko4Jy2sOXJHAU/QPA5k76AMJ+eEc/Xuhg5HJ6FbAF5fkMg==
X-Received: by 2002:a1c:4482:: with SMTP id r124mr4272038wma.42.1618921643980;
        Tue, 20 Apr 2021 05:27:23 -0700 (PDT)
Received: from [10.108.8.69] ([149.199.80.129])
        by smtp.gmail.com with ESMTPSA id e9sm28083181wrs.84.2021.04.20.05.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 05:27:23 -0700 (PDT)
Subject: [PATCH net 1/3] sfc: farch: fix TX queue lookup in TX flush done
 handling
From:   Edward Cree <ecree.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, themsley@voiceflex.com
References: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
Message-ID: <62859b67-9de0-55bc-f5d3-9ceba902ce08@gmail.com>
Date:   Tue, 20 Apr 2021 13:27:22 +0100
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

We're starting from a TXQ instance number ('qid'), not a TXQ type, so
 efx_get_tx_queue() is inappropriate (and could return NULL, leading
 to panics).

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Trevor Hemsley <themsley@voiceflex.com>
Cc: stable@vger.kernel.org
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/farch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index d75cf5ff5686..f89ebe0073dd 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1081,16 +1081,16 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 efx_farch_handle_tx_flush_done(struct efx_nic *efx, efx_qword_t *event)
 {
 	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
 	int qid;
 
 	qid = EFX_QWORD_FIELD(*event, FSF_AZ_DRIVER_EV_SUBDATA);
 	if (qid < EFX_MAX_TXQ_PER_CHANNEL * (efx->n_tx_channels + efx->n_extra_tx_channels)) {
-		tx_queue = efx_get_tx_queue(efx, qid / EFX_MAX_TXQ_PER_CHANNEL,
-					    qid % EFX_MAX_TXQ_PER_CHANNEL);
-		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0)) {
+		channel = efx_get_tx_channel(efx, qid / EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue + (qid % EFX_MAX_TXQ_PER_CHANNEL);
+		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0))
 			efx_farch_magic_event(tx_queue->channel,
 					      EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
-		}
 	}
 }
 
-- 
1.8.3.1
