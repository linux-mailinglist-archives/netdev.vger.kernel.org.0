Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC7E2B9C69
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgKSVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKSVAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:00:20 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0581C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:00:19 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a186so5666177wme.1
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=FqtmZwBBU2ipiuRuMDrgFar7Ah+yE3POXmBZUc/Tsv8=;
        b=TvJQt4NPx60VtyYYLzPlMOqy+vjIjst3naQnahGgBo9LuEL5XZBpUKJy50tj/9bx7S
         uMG70/a7jFfxW3TNL1zC8GRJIy9AjtrmrRqi/f6cAH6CdVCIXQCke/8VIe8MVuzaJGx1
         Oc0qiL8+GdBLtgq0fVZlZdDu9/ZFr9wi9cJqwY9ZG4WrJCctkUg9bH/E+BZzpOOiTBcD
         FUYoaz0H0HuLZvWAYRsCAj7cWa6OjshoUeo4NU91NZoehAeAWp3exK3RW3j3ATM9jNNi
         0ksjKZIfY0900qyfqyKQrmrkUQnhtaLU+rI2vaG4yEuq86JHknjVGsHnawn8060BdDp2
         TdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=FqtmZwBBU2ipiuRuMDrgFar7Ah+yE3POXmBZUc/Tsv8=;
        b=AJT5Eiql8YPemsnWr5UqBTEBETuGJnuAQs2sYgpm0kw5iPK4SdkQXrr44AwR/J7we5
         nREjSEKwjb5iKpOx/JsAQjWJFrtkfWfey+Z05Q+zmPsxbbu017YpmY9xv/Wi2WHlcY+J
         OuOtzHQf1JGJCaVMITTnDtma8z1kFrPcP/jv/lWzBrw4HLowdZlTXiYGi/zvuvDk3Gl4
         up8kzorcmRnFLriN1vZ5yV/O/yo70yLm1d8gZszRW1zaQCEe1XXk/qeLMmQxU+mX8S3s
         qQyV2HNKsvCUa6hjJHiIBdRMh11cG9fwWTrCUMp0RYcZ1H4g300uw05UTmpJFf8Ra4lz
         Grsg==
X-Gm-Message-State: AOAM532h82mqTRinlhV6Z97qcgOySCx9AGckFp6NYjt2ob0bPDfVj1Bl
        TCowpBtql7TM5ayAYEDYtnfR2EUZABi+Yg==
X-Google-Smtp-Source: ABdhPJzKSphKyC0I18qkpNzmN8kxuE3i5pGO/zddSqhVD4+wTKE3mHImnW//TVBFAi/k5JYLmxUILw==
X-Received: by 2002:a1c:1b85:: with SMTP id b127mr6703805wmb.163.1605819618448;
        Thu, 19 Nov 2020 13:00:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id f16sm1621153wrp.66.2020.11.19.13.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 13:00:18 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use dev_err_probe in rtl_get_ether_clk
Message-ID: <b0c4ebcf-2047-e933-b890-8a20e4bdb19f@gmail.com>
Date:   Thu, 19 Nov 2020 22:00:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tiny improvement, let dev_err_probe() deal with EPROBE_DEFER.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7dd643f53..a5c7a3935 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5165,8 +5165,8 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
 		if (rc == -ENOENT)
 			/* clk-core allows NULL (for suspend / resume) */
 			rc = 0;
-		else if (rc != -EPROBE_DEFER)
-			dev_err(d, "failed to get clk: %d\n", rc);
+		else
+			dev_err_probe(d, rc, "failed to get clk\n");
 	} else {
 		tp->clk = clk;
 		rc = clk_prepare_enable(clk);
-- 
2.29.2

