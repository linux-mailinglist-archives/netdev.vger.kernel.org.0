Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947811E13B6
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbgEYRw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYRw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:52:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F002C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so17799108wrt.5
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Trfgp8bWvPxJvXOLgtrXL0ImE+Teauq8YPcMJxUnrjU=;
        b=fxlV+4IfKzrtU6g6JIJp8OZ5qWQnHxLW2TIsLg0iOAUTQX1yJElEVpbYG/PmOn/5oz
         PNGAb4FE4UZ2t3j3jQLtpK/GlBOwFhbaB9ILS+Jdlgq6RFd0o6BfQ/uD6iDM/MMR2v3t
         ESc2iJqJ1Kq760oCbnHjuCHfE3K+C/2hzZlpJXFZclpcJRwL+E/3NHXGFA0crSacPaIz
         PqJtyFARsCMEvlU+Ru48IK1vO8BEXrSNg0ZVZUEOdjU3Q6JwgoC6P5uJwNPyWByCwggn
         cNAIh6yz/Th+Cd8Y1mkjURA+I8pEJb0/vG7o0HPyFelJVZ4ChF6iO+knP/O940EozrRa
         R8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Trfgp8bWvPxJvXOLgtrXL0ImE+Teauq8YPcMJxUnrjU=;
        b=rznF3opEzAHOcrPpHTI+7MwFvMFAvU6XmnlvdxzXuSJeYwjcg5QbAiea7NZi6Pvg+r
         O9S9JYkH4G7aYcY5wBrAOwPaWqBgmvJdmyKHTKc4Wmj42nFSYBWC4fCl5jARs2O76/nN
         evQDR6hwRLECT3I/AbRKu6y5IoUgcv7U7nhmH33Jqtebd1xFbnG0aZfuDnxL3SkGEkML
         H8ut4aede6M1mHgETWsYSj2Yhey9GC2EvT6t4r+8vbynbqvF+u6VYYUNLlmCKxVt86NK
         NgofUvs/wvjzmLPSiYwuBEjqbA14Nes6/C2YYckEna5PkeCioJ7LwmEC9kJcPWJHQrHO
         6WbA==
X-Gm-Message-State: AOAM531VRc4pBpQ+lFWC0dpX+sB1ZFYRySTbkMD9raysiVLj9rpp4F9N
        7eTnCmASGGHn+/5XtYATEv/2cZWp
X-Google-Smtp-Source: ABdhPJzD/+jTHezJcrNRG/oAqJPinUEqnLVMQVWPlv6GY4McsP6zjz7cuMQfXJLXInNnpOeBl1x3+g==
X-Received: by 2002:adf:ce05:: with SMTP id p5mr17104266wrn.423.1590429173703;
        Mon, 25 May 2020 10:52:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id c16sm18711653wrv.62.2020.05.25.10.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 10:52:53 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: sync RTL8168h hw config with vendor
 driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Message-ID: <2ff383a5-3ec5-1b14-0317-bd20a44fbc4a@gmail.com>
Date:   Mon, 25 May 2020 19:49:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync hw config for RTL8168h with r8168 vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d034a57a0..173a4c41c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3250,9 +3250,8 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xdc, BIT(4));
-
 	rtl_eri_set_bits(tp, 0xd4, 0x1f00);
+	rtl_eri_set_bits(tp, 0xdc, 0x001c);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
-- 
2.26.2


