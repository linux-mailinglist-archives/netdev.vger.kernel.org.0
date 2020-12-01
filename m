Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4352C9E01
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391208AbgLAJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387900AbgLAI6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 03:58:17 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456E2C0613D2
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 00:57:37 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a6so1630781wmc.2
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 00:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=pATMwjcygT9AkthrFzsMCRTD5iOTr1gj6Zd3ahL9hm4=;
        b=iUlHxlQslTPsF4nGMHFQw76o5BDkFoZSgJeXaW7SqzH72vuCU9rQZJ+FDDyBuq+IQE
         CW9cutAhnjIGCht3G3L+CGOooqr1WZ4pn09/hxpEyMdaFAhYpDScV5MeZwpdfP45FjnR
         qriJSqFJpfOK0HmJwC0Ac1ulex+Z7VKFE7QMNdjJeyL8b5rZsiHCJYfKaFE8H97Ovr/0
         Bo1JsuQpKlk+0q4AXtUyXzVa0WGim0vn0CG0Z9f/CqlT8Ax4zGDFDi4MHd8mii4R8xGS
         bo9FcH3fXnMF4W9lhpGcWbj5/6x2UcEJenS0L9wGlH5lxNm/LOcYxyuCBAlmXcPVhnPA
         DwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=pATMwjcygT9AkthrFzsMCRTD5iOTr1gj6Zd3ahL9hm4=;
        b=HIpt37awKKhQK7/hrL8CAvbiS5+iZB36SjXSxBrRVH3mh3XrGzlEkJWKcaXnsvtFly
         0obKcYpSXuqRwHlFLlkxPb4D8VoX91DgVpCkBM4ZyhBGSrJVB6ym839AxtVwxNxGBDZV
         DBC8amKgfXkbIEK609XvGfHlY0FnfMudDS9/R6ksqY92YA0JSasAuy0+NvJptIzkQa6L
         o6tuB5srtP7YRVh9EVMgypD7iZAyA+E1D/JmxIdh5zqZw43x6/fuQdzVYR3KJw3Tjs/I
         Ku90+tJnArB+hJXY0TVTnjkWXJZKRYDRMf0l48GjRkXQWzJCrO/8pHRL4OSsCboU4Pam
         guJw==
X-Gm-Message-State: AOAM5311h6kwLUPkbzhJTxPCvo7oOUoXNDcFMyBl+xoHn829BR3qoZcz
        HZJ4cO8lX2dmHVIOo4K/Y1JdWbteWQ8+ZA==
X-Google-Smtp-Source: ABdhPJySO6pTDr4L2FgdEC8MtJ22rf2qM7LdG33lBo2GKWifYTf0X+a3EeHQixr+p9TCakv9wOL1AA==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr1628881wmg.109.1606813055611;
        Tue, 01 Dec 2020 00:57:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:c8da:c2a2:5860:ab22? (p200300ea8f232800c8dac2a25860ab22.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c8da:c2a2:5860:ab22])
        by smtp.googlemail.com with ESMTPSA id a12sm1891602wrq.58.2020.12.01.00.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 00:57:35 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: set tc_offset only if tally counter reset
 isn't supported
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <526618b2-b1bf-1844-b82a-dab2df7bdc8f@gmail.com>
Date:   Tue, 1 Dec 2020 09:57:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On chip versions supporting tally counter reset we currently update
the counters after a reset although we know all counters are zero.
Skip this unnecessary step.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 25 ++++++++---------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 32a4c8c0b..3ef1b31c9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1562,16 +1562,6 @@ static void rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 	rtl_loop_wait_low(tp, &rtl_counters_cond, 10, 1000);
 }
 
-static void rtl8169_reset_counters(struct rtl8169_private *tp)
-{
-	/*
-	 * Versions prior to RTL_GIGA_MAC_VER_19 don't support resetting the
-	 * tally counters.
-	 */
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_19)
-		rtl8169_do_counters(tp, CounterReset);
-}
-
 static void rtl8169_update_counters(struct rtl8169_private *tp)
 {
 	u8 val = RTL_R8(tp, ChipCmd);
@@ -1606,13 +1596,16 @@ static void rtl8169_init_counter_offsets(struct rtl8169_private *tp)
 	if (tp->tc_offset.inited)
 		return;
 
-	rtl8169_reset_counters(tp);
-	rtl8169_update_counters(tp);
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_19) {
+		rtl8169_do_counters(tp, CounterReset);
+	} else {
+		rtl8169_update_counters(tp);
+		tp->tc_offset.tx_errors = counters->tx_errors;
+		tp->tc_offset.tx_multi_collision = counters->tx_multi_collision;
+		tp->tc_offset.tx_aborted = counters->tx_aborted;
+		tp->tc_offset.rx_missed = counters->rx_missed;
+	}
 
-	tp->tc_offset.tx_errors = counters->tx_errors;
-	tp->tc_offset.tx_multi_collision = counters->tx_multi_collision;
-	tp->tc_offset.tx_aborted = counters->tx_aborted;
-	tp->tc_offset.rx_missed = counters->rx_missed;
 	tp->tc_offset.inited = true;
 }
 
-- 
2.29.2

