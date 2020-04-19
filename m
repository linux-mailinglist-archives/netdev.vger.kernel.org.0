Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2E81AFCDE
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDSRop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgDSRok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:44:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929D7C061A0F
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so8646599wml.2
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nnbu7QD2qyTA6JaxSpYxb4MzZ17/wb+qBFxK9gvWoZc=;
        b=Q60rGzm7mdiPiT8sGUJKVuukukiQVpNebx3U3M5tyTizSdVcTcaL74H2R3szWZWlg+
         jbzL72n2EgyhoXHPiLiOdvfq8VRYJS0uQaMDCBZhZku9xEo1Yvt6svgVf8tMxFc6d3VO
         WbmcrwmwurPFb8veN1GaQzCY1aLmxrOoyvApga/nOf9PNa3iKLNYDzuKDA5/v1IzcY9S
         5nP4o5UgzY3az3eYZODK7T2jgcp/8uYS31rmg12Y6Rfk+mJrbk3lTnQzJwhS58PZFYQC
         3KIucs/3h/D/3K41eCytxoTOkgWJiBBVT6uDbLT0ZXyb6dgzq+dK/6xwqlBV14Erm+OY
         8MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nnbu7QD2qyTA6JaxSpYxb4MzZ17/wb+qBFxK9gvWoZc=;
        b=ofioJPk1EAzIVehD18+Kd1TG7vrqMDpXb5W4is2xiizIciBK9VSjSV/sC2yE97VbTy
         e8TchZGgm4B6sloDsYDi8O1+SFfMwTd6xCMDb8Ma56YzGjyuxmym/P0eGqXk1Jhvnq0W
         /diEJlfuvifwMMlWmQF1HpSMD6bWWCgsCkC220q3XO9leN43hIv5XGxUAA5SJQEPspSU
         zUlM3DyxVYDQfUpOqLiCRR5n6HE08NOENCQBHaiclJqbxS1gQyOW5hfa3sZl3b40OOMY
         HzFccEDDfYTEV+A9STVO7yvLumx54XAAv6rVSRXENGSSUNIPaY0gQDq4LyK5TaUPH1P3
         08MQ==
X-Gm-Message-State: AGi0PuaDXkhjzkfxeIRJwKaWJHUhAZHPULrM8/IeUexhOnyV931RjdWf
        n//pCSDx6Us2BWb0CYtcSLa2BmPR
X-Google-Smtp-Source: APiQypK4707u36I8Gw2Whot3FjGeJNqyYy90Cm/Kbvx/4KZYLS71bl2YmXqq/Unq6Sk+ODbOXrbVdQ==
X-Received: by 2002:a1c:c2d4:: with SMTP id s203mr14606040wmf.128.1587318279114;
        Sun, 19 Apr 2020 10:44:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id s18sm7183713wra.94.2020.04.19.10.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: use WRITE_ONCE instead of dma_wmb in
 rtl8169_mark_to_asic
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Message-ID: <3b2f28d9-8161-ce07-a7f6-01163664c410@gmail.com>
Date:   Sun, 19 Apr 2020 19:44:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to ensure that desc->opts1 is written as last descriptor field.
This doesn't require a full compiler barrier, WRITE_ONCE provides the
ordering guarantee we need.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index df788063e..8e9944692 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
 
-	desc->opts2 = 0;
-	/* Force memory writes to complete before releasing descriptor */
-	dma_wmb();
-
-	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
+	/* Ensure ordering of writes */
+	WRITE_ONCE(desc->opts2, 0);
+	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
 }
 
 static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
@@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
 		return NULL;
 	}
 
-	desc->addr = cpu_to_le64(mapping);
+	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
 	rtl8169_mark_to_asic(desc);
 
 	return data;
-- 
2.26.1


