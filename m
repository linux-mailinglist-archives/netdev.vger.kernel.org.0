Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E881E13B7
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbgEYRw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYRw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:52:57 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776AC05BD43
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:56 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q11so5646870wrp.3
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BNjyKVzwici4RinYlcKbM+8VHzbVdQswveuWvZVOx3Q=;
        b=nBPKzkPCKRBVAWx9jl36Tsz7xJpiXl7T7NwPIdLhxDKUYM4feCVYLX1hbrfCh7xg6L
         KhKwS50hPAgQrtDCUlkhS14Fol2sXeIDo2/HxfeFADbwe1UD6FNyI8IpXGoQD+IA3Kv7
         tQbgdfb4vGuiIZn2EdSeYGNVocPLO+KQw8VIt7KUo6kbGSx2Hc/pn0CGLHgTxa90joKN
         EmiISVeoc7SE0W0UGMaoqd+acoXMS+aCxteTFKP85lw1YSyvdDMCI9/0Piy69VXUPfcW
         vfsxG5gWsnSN0EBFypyqjAY0CrF/u0NU2zWBvKZzTsZV0AKEiI9MV5hPJek9/JjDo1qx
         r8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BNjyKVzwici4RinYlcKbM+8VHzbVdQswveuWvZVOx3Q=;
        b=KVZm+FGF16Fi9zdtV1vM5CnUD33uXw6RAQlRnC3AeXlhDO/96kzX6CfQ/dGPWsKo8L
         qPnhHpesGX/axFE2+Pn9bQQPe2/1K53Mgnw/8QlRkAjkvzUSXSZXwDmc1/neRMt5Bslz
         +tu6j/3kmdX5p76BKq7eWyPPZEjoeHSi9SGvXeFTpqON4/22PRcR0zqwt5MNZ2WwIRDM
         CFQDNrrQWpKGHIUE0vhfU8ZufTSpRDk2new/3C5whOmEy1kXqlo1XBtOip4Cm4E/c9ba
         uRANKqhbUpEPB0yvSjtR08svVAVwiyNKkhPPniJHskDY+7qVmF6W8zh410RQf7vp8Lhb
         uB3w==
X-Gm-Message-State: AOAM531JwOaHhCNhYugMc+1xRoHlF27Cjp8FQPL7wXDq2DMf26b5dQt5
        L8gkOYWGxz85bG+sY0a+TxlIX1TG
X-Google-Smtp-Source: ABdhPJySeAiPLKmg5jwbpx1clDePWgKzV/zM3CtADcZ2px6xJFcIcRICicovH/+wE4I5bVfveGQDWw==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr15633494wrx.133.1590429174596;
        Mon, 25 May 2020 10:52:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:fd94:3db4:1774:4731? (p200300ea8f285200fd943db417744731.dip0.t-ipconnect.de. [2003:ea:8f28:5200:fd94:3db4:1774:4731])
        by smtp.googlemail.com with ESMTPSA id p7sm13869630wro.26.2020.05.25.10.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 10:52:54 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: sync RTL8168evl hw config with vendor
 driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
Message-ID: <84946870-9257-0246-e403-4fc0f48d9eb9@gmail.com>
Date:   Mon, 25 May 2020 19:50:38 +0200
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

Sync hw config for RTL8168evl with r8168 vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 173a4c41c..dfb07df47 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2926,12 +2926,14 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8168e_2);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
-	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
+	rtl_eri_write(tp, 0xb8, ERIAR_MASK_1111, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
+	rtl_eri_set_bits(tp, 0x0d4, 0x1f00);
+	rtl_eri_set_bits(tp, 0x1d0, BIT(1));
+	rtl_reset_packet_filter(tp);
+	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x07ff0060);
-	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
-	rtl_w0w1_eri(tp, 0x0d4, 0x0c00, 0xff00);
 
 	rtl_disable_clock_request(tp);
 
-- 
2.26.2


