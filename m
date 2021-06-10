Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FC3A3536
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFJU7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJU7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:59:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9839C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 13:57:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z8so3723691wrp.12
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PcVsyl7oW1anoDDHhJ7lHbzDz4lctsxe2Zc0mi6uQUA=;
        b=P3ZJOlH4RxiM45NV3gPY1k9laZ5FS9NcZpeqBc/A/84IHV1et5o7NskLe/NEwHnWi1
         SyA0R5rWpQg34ofTSLCMXFkpV+eKo91/eLAectMfrwsI78pHwtVb/vMeXRULyxzgSBo7
         ozQL60FwVfqsVmtDsRGyzC+lR1wcTm3Guq7ZddwfmoqGyWCsAEVGv9+o34aoa/VPE2JH
         Ifuk/fC1o3esBRFUdjwviEiKY0ftF60T4bn8ZImCNgPj/LPbTm/lZhtVYWpEZSNWiND/
         0spQSwZKb87BP0X5/IuXMoYt3n/09UaAh8h1/puuADmTZJjXyITDw0lnu6T2D1506kp9
         4dAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PcVsyl7oW1anoDDHhJ7lHbzDz4lctsxe2Zc0mi6uQUA=;
        b=kkQJvBOpheNKkdtHIItHziMBx21QU1qvwG+hMylwl9D9YTIfjEdvUq1y7L292ng6cy
         7U1bLskH8/pG/F+vqNNtdkqvaYAtbbq/rxVErW4WQnC0JlJ/NlbEQ8ABYjLuaTivKOrm
         IMizTn0/XBw1AzzaCuK+0l1GHcUru4kUkO+OnusZkndOukLjZqByyiBmz+9IeG8BbOld
         sHPHPXakCL2sWAwQb/QsMh4Hhlq0H0g2W3URxnXOb4+tKGs7kqEDyvyw0wPpw6ldO8qQ
         b0gsZyEqF2jWMIfA9NU/oYCS4X5p9qIgiPGTuVU6nzhLb+f5berlEV/Bp5JY7sseaCRM
         HXRQ==
X-Gm-Message-State: AOAM531R6Z+K17Hl5LnXuvgc5lDDHhnYGSiylNQA9yfLGkn7VGMFsZH0
        mU7qg67BrZYZXkQ64JrLSG1AOTrF8BE=
X-Google-Smtp-Source: ABdhPJxTPYLlAJ9tm3onwLwaeCUaE0gVB0R7vM7DEHlaqwl60oSthWWd1F6+gqp4OPOZriwu70eRYQ==
X-Received: by 2002:adf:fc0e:: with SMTP id i14mr329973wrr.71.1623358626377;
        Thu, 10 Jun 2021 13:57:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:108e:718f:a44f:76c6? (p200300ea8f293800108e718fa44f76c6.dip0.t-ipconnect.de. [2003:ea:8f29:3800:108e:718f:a44f:76c6])
        by smtp.googlemail.com with ESMTPSA id q19sm2536261wmf.22.2021.06.10.13.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 13:57:05 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Koba Ko <koba.ko@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: avoid link-up interrupt issue on RTL8106e if
 user enables ASPM
Message-ID: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
Date:   Thu, 10 Jun 2021 22:56:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been reported that on RTL8106e the link-up interrupt may be
significantly delayed if the user enables ASPM L1. Per default ASPM
is disabled. The change leaves L1 enabled on the PCIe link (thus still
allowing to reach higher package power saving states), but the
NIC won't actively trigger it.

Reported-by: Koba Ko <koba.ko@canonical.com>
Tested-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 64f94a3fe..6a9fe9f7e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3508,7 +3508,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
-- 
2.32.0

