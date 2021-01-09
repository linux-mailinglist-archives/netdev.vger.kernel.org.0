Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732852F03F9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhAIWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIWAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:00:47 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAB8C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:00:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g185so11443314wmf.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XnRBXE2Uk4fUuCY80HK3W9/qzTDABtTxWxYyxmg/WxU=;
        b=qy4nqhfp4+67Mgqcb23YFSFCBgkr8xYJb2piP1lp0mQKiY0B7asu61FZY8oBHiY3Dk
         N7aRBVD3lg2T2ZSGyCbuGSvTQQc+0a3MOKCyvz+APLoQtha9k7s2L99KSV9e/52FVZ35
         FcftjRxBQn3+TWbsLXl1plgbwxqGNSwd72CRX1Hmr+Ngvy+7g1XZ9CG6j6pYZO4unYj9
         LGYd9LNVPsOFOl+7XJdQ9kZpeYSEvAe/d0gRC1Oz2gWurk12cPgVnwumiFkOblFzaZm/
         DRPRGtGSTqWM/xqD7SOj1cRRV3gv9X9YoTedBSBCm7VFCCi0Ws0uvayxC9ivxkuJs9s+
         2kjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnRBXE2Uk4fUuCY80HK3W9/qzTDABtTxWxYyxmg/WxU=;
        b=As2IaYybFsOFsiYLRQSuguY+z0JH8cH2EdAwZm/jX+tZYEzJ61J/OMyz9pUxPZfU4K
         Tm1h4ABQpkhgASFD9Xpam1I/LS9x7jTWeAHgyG8p+L0RmbYQ/KyxclehvZ4IHNgDvVqF
         2/g0cWK0Pzu8mKE/vl3jvpTBxtvrJTwYVshsS5dgA3G7Ic63H98HvvOrMSD9EfIPWPxG
         zSTywWv8ryE2MLhDk3CdzbhibuArBKc7ZJnfGso+akYyuqA3ugLCbJ17m+mGKVAFFmae
         Aqe12sKIWAaxA4sJxfDW9fhqw/OCB/jo1THjAYCoLO5rHyWa5cgdJAUDbSCmBicZPhIL
         8xbQ==
X-Gm-Message-State: AOAM533u2QVgcoJdNhZmcezJJI/OwKW05+So97P5W57UTKhsqTYYtaTE
        GOU7ZExwnd6jYg9abzWCaRFEsgblmyo=
X-Google-Smtp-Source: ABdhPJxvTtL2YvHVPupr69xhvmd5fD/Gg3zUmwUWA9L5jtKbhfF2aILtEXL2BxDpZc73EJ9gSSaKLA==
X-Received: by 2002:a1c:9609:: with SMTP id y9mr8415509wmd.75.1610229605533;
        Sat, 09 Jan 2021 14:00:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a584:5efe:3c65:46c1? (p200300ea8f065500a5845efe3c6546c1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a584:5efe:3c65:46c1])
        by smtp.googlemail.com with ESMTPSA id x13sm19700096wrp.80.2021.01.09.14.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 14:00:04 -0800 (PST)
Subject: [PATCH net-next 1/2] r8169: align RTL8168e jumbo pcie read request
 size with vendor driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
Message-ID: <fa68a8b5-ac7a-3f95-5e08-5bc7e4b76992@gmail.com>
Date:   Sat, 9 Jan 2021 23:00:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align behavior with r8168 vendor driver and don't reduce max read
request size for RTL8168e in jumbo mode.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 74c8248ba..8336f1434 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2342,12 +2342,10 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 			r8168dp_hw_jumbo_disable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
-		if (jumbo) {
-			pcie_set_readrq(tp->pci_dev, 512);
+		if (jumbo)
 			r8168e_hw_jumbo_enable(tp);
-		} else {
+		else
 			r8168e_hw_jumbo_disable(tp);
-		}
 		break;
 	default:
 		break;
-- 
2.30.0


