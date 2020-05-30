Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8916E1E941A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgE3WAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgE3WAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4737FC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f5so7638261wmh.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G3SmlJEu+nXUUZ8I3M3XdO7W+0Iisl0lSQ/BqjFKrmA=;
        b=CcHLodR8d6nPJ8W2hma2/zt9LNtYHR+xQEltc3YmlV9ozPb6qYWGxUOGgoDLSf1Ngq
         eOjrbmmbuMA6SenAkdJDCFbLpUu0ZZd5SeOsBmMMeQS5n609Qv581DiXteGOF2FTEJ6Q
         F+2FsxHqYs70YtDDIoHq9oCFlCSF6e+Q/CM00DPQMVtPgePJVEA47Q0jiKSCkQZMOSuT
         gsHXtOdWvp3L2fcoC69RukQ+N0ruALAR19gngiSKcUAb3KZgXlGcK49ch+BExq7heEkl
         rHnAU1Az8SchjsbNRhxUM2sgHXczwqsnQE3+bAUoW6drBnyPnvsBmS3OmCIRUYLMZsj3
         jNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G3SmlJEu+nXUUZ8I3M3XdO7W+0Iisl0lSQ/BqjFKrmA=;
        b=UOTATXiFODTLgKI+v8Vm33zSrReH1oFIWCw+QLmKLOYZiRqHYNKErqv7tCyCewiAEr
         N6H8IQTx2pc3uRv2ARjrOhbPCXII0E1AfYeKmOhffE+V32/QL0EQBNhrPBiOOazpK6X5
         c42bTEoDMl6QnGFn3FyN1XPX+PQqCewZucwaZEnoM0UU46GSHB/nl1FmXkaXAhj9MSPp
         ervj8WOSx0BockmkdDECVUzbm2SGbZ4G9LkT2zXJP3GgCXx8xBrQYWdrearL3R+eXZk5
         W0/83dAQOzpMBAj4ek5WnUnq/taY9c8OyVSALHwqVYKnvoAxUosqMAK/r+obVLrum25a
         NgOA==
X-Gm-Message-State: AOAM531GaBxsenRXZSZb294VbCiAblgAM3A8tkmSblF12SFa77S4phBC
        U9WNiOB4wX7CQlzXEfyKpmI409ag
X-Google-Smtp-Source: ABdhPJwgjJWKlqvHTmERQrF/3LPQQ19jVFhYcaq78w3t1UWGoaqA2VT9kXWM6n/ndktJHmwupWFCGw==
X-Received: by 2002:a1c:6446:: with SMTP id y67mr14821599wmb.156.1590876018834;
        Sat, 30 May 2020 15:00:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id o15sm4673827wmh.35.2020.05.30.15.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:18 -0700 (PDT)
Subject: [PATCH net-next 3/6] r8169: don't reset tx ring indexes in
 rtl8169_tx_clear
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <261f63a4-1027-ca1b-6a76-e0eacda72998@gmail.com>
Date:   Sat, 30 May 2020 23:56:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In places where the indexes have to be reset, we call
rtl8169_init_ring_indexes() anyway after rtl8169_tx_clear().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6fcd35ac8..43652c450 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3955,7 +3955,6 @@ static void rtl8169_tx_clear_range(struct rtl8169_private *tp, u32 start,
 static void rtl8169_tx_clear(struct rtl8169_private *tp)
 {
 	rtl8169_tx_clear_range(tp, tp->dirty_tx, NUM_TX_DESC);
-	tp->cur_tx = tp->dirty_tx = 0;
 	netdev_reset_queue(tp->dev);
 }
 
-- 
2.26.2


