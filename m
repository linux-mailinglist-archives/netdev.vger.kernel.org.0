Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133882EBEAC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAFNaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbhAFNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:30:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38149C061358
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:29:34 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d26so2407766wrb.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qjUxkdGfZy17IlPm7nlnqedjqmFUxudQh8FDLcrpSgc=;
        b=tPJLLYxQPfclMCSwS9KudCYhYQtevVW/+eQt0wyDbANKZ4DObvKVKb5RD+n9XOi3bq
         rZpEYk+rZzk299Hpl4NARYWFugOlaBLU4WlanSYJV7w6OxP60YA3Qa8gHg5r2vKBzjzi
         ovmcWOY8M9g9mljXu+VgMVLvBSbD6F5oL0uoW7H0hrkgDZAuzsUC2c60osCKgKvv/9xQ
         2UB3nJ40O8UD03IZtujrNe2XNq9q1WWsxyT73orf7iYwB/5fwFE5GymedJKY0pWXdH2+
         /DPhDKO4HLj63jKvBVTbqAZD+Px9CK74De8J52oa90pNN/3+IXIdh1YAXvk4rQhY7U6N
         Liig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qjUxkdGfZy17IlPm7nlnqedjqmFUxudQh8FDLcrpSgc=;
        b=X8DBr3CtrBElD0oneDPX3e35ZAEWIXkXLb0slVI5ZdOqMp7FUFJtnhJQYt3ZkX/iV/
         cx9uHjG/GJCim0lj0woQnSSw0jVnk+XiKX+2+G9LhuVDWQzxc03c9Jj9heipq1bG3fHQ
         h1M+VA9gCpqFo/xfoCYpZwkuAsFjFXKfTfwBL4kk9Q4QQWfhzcQ3MPV21nBS+GtjpdAv
         jjLzFtR9K6/dDewTkqERzB/I9QibC1WbyMlsXCLNSz96BfRz5Kza5rhg68LHuWsOS4uP
         OJsA7Smyter+IV5uJGPV2ztJScG6ak+QBVT7GEDjwuhJbABygIF4a+OcYBmAvf7wfYpr
         wdcA==
X-Gm-Message-State: AOAM533wp6YN/xQDA9g1ndcFHKh5ixXv3qe0cpoto8k1L+cCGua9qJLI
        JNA5OTZ751hWQya4Lz8otUuQE5v4fz8=
X-Google-Smtp-Source: ABdhPJyrT95Oz1flZCJ5OsnRWJw/Q3sF2HTAqKnaE72RHuf9TStWiESNwOPXrjo0A3xWcGoYvv1o+Q==
X-Received: by 2002:adf:9506:: with SMTP id 6mr4295432wrs.172.1609939772734;
        Wed, 06 Jan 2021 05:29:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id z63sm3243326wme.8.2021.01.06.05.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:29:32 -0800 (PST)
Subject: [PATCH net-next 3/3] r8169: don't wakeup-enable device on shutdown if
 WOL is disabled
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Message-ID: <62ad5326-b4b5-5453-7763-bee9b09942b2@gmail.com>
Date:   Wed, 6 Jan 2021 14:29:25 +0100
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

If WOL isn't enabled, then there's no need to enable wakeup from D3.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6005d37b6..982e6b2f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4876,7 +4876,7 @@ static void rtl_shutdown(struct pci_dev *pdev)
 			rtl_wol_shutdown_quirk(tp);
 		}
 
-		pci_wake_from_d3(pdev, true);
+		pci_wake_from_d3(pdev, tp->saved_wolopts);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 }
-- 
2.30.0


