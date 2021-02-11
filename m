Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8631944C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 21:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhBKUVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 15:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhBKUU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 15:20:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D169C061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 12:20:18 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l12so5457022wry.2
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 12:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qUZPPTjxypuIsOSEwHiV1oADSOUC3Aajk7rQCjLylg8=;
        b=IMFFu2GIuGkBf3laXfXuM7qEF5I3e1BNnAxKjiPP2nJc9+FIAeTNFFaoRq9/9b+y6Z
         LI0O9Rr4LyTU5V0xeCYcxIPcqmAr7FaXwHZx0WgR8DYyXyWEN/nHSRNeBKv0tPbr46Zj
         TjT84pdXpLHCc/TQhpiDcpgkdeZEK2+tJNd1qUs6qvqKHyi2ym2mHmwTBOeTFvPraTbq
         mVdXDBLTdWtj34qcbaeqMlJ20lckL12qX2J6Tu6bkBUlLDOoE7qgNDQJoMVdj2BWxlbd
         pykDtgGZnJy1kqG21qY52ywTaOUVC5rO3Ql1Y4U+bxzzGAKuYnLZZn+sRGDmTxBT/EnZ
         OZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qUZPPTjxypuIsOSEwHiV1oADSOUC3Aajk7rQCjLylg8=;
        b=hHpddispClhkMvMWr0MJBaiy0Vvy5z2pSjJhWP9jK7RpreXnpk7B54KHPKz5Abwlpc
         UZwbS4Xz+X+xrx7LlJfKbAMsLXtSUP2YUA97k2J5bpQBJTdw/b/mqTW8YDOKn4/J+7NI
         PinIxhNG6dXCsO3WdeDbWvNkHV6QnEZuAxf6A1FNFtPpVpNlWLG7AABbB9J6Oh4YnjG5
         2Ov4LRMMhRL8Uk6YillGXw8chzEiLYOXHv1GzI4AuLAk+eaMvU52SmjhacYAtTBbcJiP
         RF1+bF8wpPLTQz6ZmMmHiP2+G2fWCiLV7pgdoYjZ8QaCAukwB3FoeroONn5fyqbFKLAb
         xK8g==
X-Gm-Message-State: AOAM531rvexdbpkW25DxSDqefsGT5toWJhno+f+KfLtyK6FFOLs3A2VP
        3h5ZWnH1s9VVpkh96wYp9W2wGFz9ANmx+w==
X-Google-Smtp-Source: ABdhPJyKwI0Vv7ZHwbT1BYaeqhmq7PjI58nCEQY/1QxjALvsYL+yP7AL4IwKGrusdFCtBBbu0eQyfQ==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr7233202wrz.86.1613074816665;
        Thu, 11 Feb 2021 12:20:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:1524:b28c:2a1c:169e? (p200300ea8f1fad001524b28c2a1c169e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:1524:b28c:2a1c:169e])
        by smtp.googlemail.com with ESMTPSA id c11sm6499849wrs.28.2021.02.11.12.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 12:20:16 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: handle tx before rx in napi poll
Message-ID: <5ef5322d-cc83-747b-5995-2e60f2c39d93@gmail.com>
Date:   Thu, 11 Feb 2021 21:20:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleaning up tx descriptors first increases the chance that
rtl_rx() can allocate new skb's from the cache.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index de439db75..44a438bad 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4588,10 +4588,10 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = tp->dev;
 	int work_done;
 
-	work_done = rtl_rx(dev, tp, budget);
-
 	rtl_tx(dev, tp, budget);
 
+	work_done = rtl_rx(dev, tp, budget);
+
 	if (work_done < budget && napi_complete_done(napi, work_done))
 		rtl_irq_enable(tp);
 
-- 
2.30.1

