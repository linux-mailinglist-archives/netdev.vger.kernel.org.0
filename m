Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B2A1CB9D9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgEHVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgEHVdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:33:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888C9C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:33:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id v12so3561421wrp.12
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h0YY9K796cNtOZD49R7JElFJhFwjstrWlkVjt8km85U=;
        b=C2fwbwAwHlfHYeAoLkENpgHYUl+gvLVvsMDyT5u3rfgW9YW125Pu69azXylNi3RYoU
         H6QagiKYpQhAXtmFSywBzVgMV/Lq0Wh49+I0C6J/4DZrBGrdIgz/vgv/VulJOl2EpiKx
         91zCkcU4V4pJmdTghtlkQODLiWkDkgETbEZ38EL8lylkLUMqVNVocb3Z1xlxtRMjaMD7
         p7rjcPF8+ni3/X45kNSQ8rIxoijqz/Kfxwsuub3WnKkQcLHITF97gC1ByvTphnhge6p0
         NlqHuIhd9RZebhHNIq7Nhw09uyJRowUKWzH/DU8fiZ7hO294lHk9QrfXFzkVm6Q46zBQ
         Mv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h0YY9K796cNtOZD49R7JElFJhFwjstrWlkVjt8km85U=;
        b=GWpcGAdvQt3tuuKYZ9J3eiRG91MrMns4c6revoKlisrqGlR9Bj4+iewGYUJhqLD1Jm
         murnu6qqCx9h+6qyo5FZCFhCdF3psfe1dq8EJ1QVEZr5Nv6g+rbnavctvqj23eaO1pxS
         RBef8INf4CBjxXk92IMx+xtwYgoI/ybzIg6A/ulTXINeXx7NVnGHba72ejUnebbi2UGp
         9+Rc9lOHDnkQ6Y/gcyUylseKm7UurP/jcFuO5U4ymdG7JiK8jt5rMC4yOogeq4ZNYMrP
         ubGDHljE0C/RlFPQV1xmKk7Q2c/BSXwSyxdGTWXT+Im6HNjyM1to6Ox7/h1Ww2+gWvkA
         SLRA==
X-Gm-Message-State: AGi0Pua2cqnuzlvzxZh+95TDl8rRh0zB8JUw2bQfYQB4p/oV0O1buRuA
        dSC0TtXnx9swcDXxJk+Dtdd8I78H
X-Google-Smtp-Source: APiQypKT5ZjWh9tOC71T/GVVyeiXCZ+PX49J+qdUJ6hbUgqjITrj3AYD5UDHqG8rSRNlYkp22+aOAQ==
X-Received: by 2002:a5d:408b:: with SMTP id o11mr4706097wrp.97.1588973582840;
        Fri, 08 May 2020 14:33:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:b9ec:f867:184c:fa95? (p200300EA8F285200B9ECF867184CFA95.dip0.t-ipconnect.de. [2003:ea:8f28:5200:b9ec:f867:184c:fa95])
        by smtp.googlemail.com with ESMTPSA id z7sm4903012wrl.88.2020.05.08.14.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 14:33:02 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: add helper rtl_enable_rxdvgate
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Message-ID: <f66cf5f2-da23-0ce9-671f-c540ec5f88c3@gmail.com>
Date:   Fri, 8 May 2020 23:30:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for setting RXDV_GATED_EN, the 2ms delay is copied from
the vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1c96fc219..eb26c3477 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2496,6 +2496,12 @@ DECLARE_RTL_COND(rtl_txcfg_empty_cond)
 	return RTL_R32(tp, TxConfig) & TXCFG_EMPTY;
 }
 
+static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
+{
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
+	fsleep(2000);
+}
+
 static void rtl8169_hw_reset(struct rtl8169_private *tp)
 {
 	/* Disable interrupts */
@@ -5133,7 +5139,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 
 static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 {
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
+	rtl_enable_rxdvgate(tp);
 
 	if (!rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42))
 		return;
@@ -5154,7 +5160,7 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 
 static void rtl_hw_init_8125(struct rtl8169_private *tp)
 {
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
+	rtl_enable_rxdvgate(tp);
 
 	if (!rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
 		return;
-- 
2.26.2


