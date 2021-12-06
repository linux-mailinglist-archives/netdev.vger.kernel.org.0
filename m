Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C974698C4
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbhLFO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344187AbhLFO1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:27:31 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3555C061746;
        Mon,  6 Dec 2021 06:24:02 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q3so22776337wru.5;
        Mon, 06 Dec 2021 06:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCJ8tZmZjGJuO1Z9w5NQSatzAirMVyzvfUd8Ef5O3JM=;
        b=YO+5wbYJte23YOyBURdCM1INLLe+qrJ+EHmwzPZ5zkyUY1sGpnuPkBMWR5r5VrYDfa
         M6J8dBbeGKsFBaBtLDb6JKLZeWcWHic4Bo4P6YwAQq8oBXx8gMd35Xqt6n7VT0bTlP4c
         TskAAvtt7aaGUOFk4jE80D3ig9BJFsf4YWObyiBBG1P0ZzQefomDpTOdUWmorR/gwQNf
         drpDRmJjgEYPdAkifcf/LDMoETKwMl+yGQqgsIjavKqi0VJaU6+s4GlpqFhsH0MPN4if
         W+IMj5zj8w55kC6fOinn0RyowFT0Imo/ilsu4DBvb0Z68HPGhuLXGB3UxbDeDZ4ebr9G
         9E4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCJ8tZmZjGJuO1Z9w5NQSatzAirMVyzvfUd8Ef5O3JM=;
        b=ipMnd/AvkTrMHkJ4fv+2cW4JrUEuAY0VZdJ8VusMFzVWlWL1Y/7HbXzSI/RthlVMFx
         SHCFchhk1lCTNW0nFpn6C6xwPAXrxoDk9+q7My8resvjx+7WdI1CpI8DgPj8GX4aTTLH
         vq2NPUg81upenXGZ4ZxJ7witSAH0Ka2T/89BWSpR/HhyrqYnaiSPDzySADhVX8AzUSuz
         XYIF0KjHTRgRs06+wejt98Uw5nF0QI+a+5kHRcDWDtFcWAjhjM8742qUHSphXlDeYOhs
         qxIVzqYkO8Vq8ZkS7plyeSgdNP/5lGevBP3lIQq4WJwWTCBaX9Wn4u9tuc+kJuE4gzOK
         7o4A==
X-Gm-Message-State: AOAM531m3yiuS/Iw6jWEQaRxkg2QCxRaW1USvwRXRM0iVNWVw01n0RJ1
        spQRTL2oMvCO6fbXLZwkvXo=
X-Google-Smtp-Source: ABdhPJwAvBQpbdwnhQHtQ7Jq9mPqsIOVzD8q9i4e+RpvxETTS3aho5s8Iyfy3JjVJZrnsmHAspLokQ==
X-Received: by 2002:adf:9e4b:: with SMTP id v11mr44522421wre.531.1638800641261;
        Mon, 06 Dec 2021 06:24:01 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id y15sm13939293wry.72.2021.12.06.06.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 06:24:00 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     amhamza.mgc@gmail.com, h.assmann@pengutronix.de
Subject: [PATCH v2] net: stmmac: Fix possible division by zero
Date:   Mon,  6 Dec 2021 19:23:37 +0500
Message-Id: <20211206142337.28602-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211203173708.7fdbed06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211203173708.7fdbed06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In stmmac_init_tstamp_counter() routine, there is a possiblity of division
by zero. If priv->plat->clk_ptp_rate becomes greater than 1 GHz,
config_sub_second_increment() subroutine may calculate sec_inc as zero
depending upon the PTP_TCR_TSCFUPDT register value, which will cause
divide by zero exception.

Fixes: a6da2bbb0005e ("net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls")
Addresses-Coverity: 1494557 ("Division or modulo by zero")
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>

---
Changes in v2:
Added fix tag, bug justification, and commit author.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index da8306f60730..f44400323407 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -863,7 +863,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
 					   priv->plat->clk_ptp_rate,
 					   xmac, &sec_inc);
-	temp = div_u64(1000000000ULL, sec_inc);
+	temp = div_u64(1000000000ULL, (sec_inc > 0) ? sec_inc : 1);
 
 	/* Store sub second increment for later use */
 	priv->sub_second_inc = sec_inc;
-- 
2.25.1

