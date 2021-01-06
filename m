Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80DC2EBEAA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbhAFNaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFNaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:30:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3228C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:29:31 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r7so2442234wrc.5
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OUzk47HBaWxY+fVcCNsyUMU5tZsT6IexSmrC5pHLmCQ=;
        b=iTrkuOw7gkPjlxE4v0hoN0/AXduZZP4mmao5yHYCKtmmo5SgfzL1gh9PQkEMaRLuDb
         DgXm70AjDvDb345lIwZzESOvNXJ8hRCV2iziOQHM6bviXUuqvuiWC5hW4IsyAAFUkOOX
         Sb05Pj0cCY636BVsJ4zWDQbLOXa33xVsdXb3xT+gXMNDf/REvsG/go9ULxgA6VRSXc/r
         4zIcqIk/oNWjtBTQjtrJq9fNKiu9z44Hwh9Hy9wAgEdEg3Z/pQrCKUM3kF2yk3++XkhB
         Asfw8R4m6+uJlZTi7XG6j0Psp2xNYA0Ay7vDw5Khwma9PcsUvwbt5F+Hg82GYE0G3a5t
         ou7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OUzk47HBaWxY+fVcCNsyUMU5tZsT6IexSmrC5pHLmCQ=;
        b=VQlfz5waO8+8XhZulIz9WxdW0ZQw8aNuNligRvArYiIe7LyYYTRSM52xe6uAKQ0XaQ
         jJ0HY4DyQz2BRQl4oHtw9X0sdOIr0C1qQrAjHGnBRQeLHbgJMN5RG+BRbZIAErkB/+Oi
         YLGe/kQeTAaQCM0AAU7tXe91hmaFHJ5iwiZHAPGm7ODYJS6/3BKy+rHFTn8O1HMm6ZXk
         yvQCbr5xlsyxfvYYeW/7tq/rDO8xIe59KGs2cIg0mJ6RdwgDUTsDAAdfosKXEM8gicMz
         U299YAag8uirc75jH32/G/LiPLGhSBvB5CkzwrG7PEomXFcztDdQdZg0XlW2igpjst0R
         OATw==
X-Gm-Message-State: AOAM532NRdVhHcNmOdRP3v1x91XQi10kmitUW8bDKu6TjU/XIG1ee2i2
        b/QI3ZMoFwERUu0u84kz5IPqVRdKnNs=
X-Google-Smtp-Source: ABdhPJzkm061xY5Zaz8Fcp7MGQDAlAE90IsyvTy0s3KXJru6aisY7U/kal4QBTLrMA0ktrl4COD6lg==
X-Received: by 2002:adf:90e3:: with SMTP id i90mr4507932wri.248.1609939770410;
        Wed, 06 Jan 2021 05:29:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id a12sm3413933wrh.71.2021.01.06.05.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:29:29 -0800 (PST)
Subject: [PATCH net-next 1/3] r8169: replace BUG_ON with WARN in
 _rtl_eri_write
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Message-ID: <619e6cc2-9253-fd1e-564a-eec944ee31e1@gmail.com>
Date:   Wed, 6 Jan 2021 14:28:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use WARN here to avoid stopping the system. In addition print the addr
and mask values that triggered the warning.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 024042f37..9af048ad0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -763,7 +763,7 @@ static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 {
 	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
 
-	BUG_ON((addr & 3) || (mask == 0));
+	WARN(addr & 3 || !mask, "addr: 0x%x, mask: 0x%08x\n", addr, mask);
 	RTL_W32(tp, ERIDR, val);
 	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
 	RTL_W32(tp, ERIAR, cmd);
-- 
2.30.0


