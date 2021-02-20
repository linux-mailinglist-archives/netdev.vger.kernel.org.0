Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A635B320443
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 08:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBTG7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 01:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhBTG7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 01:59:09 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57535C061574;
        Fri, 19 Feb 2021 22:58:29 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id a207so9631105wmd.1;
        Fri, 19 Feb 2021 22:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vwrkpEL71NpFTJHy3ngrO6p4FfCqPpFxaFL4h0AeKK8=;
        b=m/ldRO6Yf+qs9nBx2UOJdwnjRZB7jcR2ovjoyvVsWglu9tSjX/yixDqEFxC5kDldJ/
         t/Ssp+x96nxFa4teXICU4G5pmetJKoEZtUOsiOor5EwAd4IhjY57cmqw54z7hYy7kdNv
         ZmPAF+Jyw+7HoOPfnGoO4nNkEDCVc4yUZPADjfzL3AvsP0kxJspYdR4ZbaYT10HbyKeG
         572DCiKS5qTShkcbSTKRIdHaEnKCCPvqfhX7D8xAUZ2QRrksEMagZLmPLDWVrwYzx6EY
         I4AmKzl3rtQ1wT6KZNmLQFUZyYS5QcrDzcHV2r//FemdMiGDIX2JoMzLOgx3OxfY8Zvs
         pxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vwrkpEL71NpFTJHy3ngrO6p4FfCqPpFxaFL4h0AeKK8=;
        b=b6ladaI4QQP0gPcTdj9x3R3HjHumjoaTiFg72OUTStGUgiUZIa48pkhFwDer9rlt3w
         2pgt4zfGa9ZCNeFqWAL4E/ViONwj57AxgcHIJjnrtL1QwjRhtBW1S4ymRF6O22mIZc+a
         quzvfdvtxcaBCkVERewtPh/tP0BU2Sv78h2OeWBDa17/LIVLrQfUrWtIrBB2U/Dz5Ywc
         KZkPKQCkfMWIYxpbIDpo6DtDrMvdiqANQBVJAsSfoJ3XxO4tsLwoM7s+7rqHBQnc3j7o
         sv6kFnIBvqc+n7Ow8dg9ENKpeSQom7bB/WHIpHUGRpWa5DZNhj9+uzWvCWNOVr4OAqPX
         eV3w==
X-Gm-Message-State: AOAM532K4O06zSoB6R2SNdn2PsxFaRxExXvS0/Td4scOsbG33ZrODeVL
        /907uvDBF/6qy26WGyRxsfbrDGX4/FxQZA==
X-Google-Smtp-Source: ABdhPJxNLSmehVwEyUwnGmYvR51HktCsKm5MnQWCbZMFPz2Rc6BMSBaFTlcdMNtJddPLXCTO0Md2Iw==
X-Received: by 2002:a1c:1d16:: with SMTP id d22mr11306530wmd.110.1613804307731;
        Fri, 19 Feb 2021 22:58:27 -0800 (PST)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id y4sm10732857wrs.66.2021.02.19.22.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 22:58:27 -0800 (PST)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Sat, 20 Feb 2021 07:56:55 +0100
Message-Id: <20210220065654.25598-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When accessing the timecounter register on an i.MX8MQ the kernel hangs.
This is only the case when the interface is down. This can be reproduced
by reading with 'phc_ctrl eth0 get'.

Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
the igp clock is disabled when the interface is down and leads to a
system hang.

So we check if the ptp clock status before reading the timecounter
register.

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e344aada4c6..c9882083da02 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -377,6 +377,9 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
+	/* Check the ptp clock */
+	if (!adapter->ptp_clk_on)
+		return -EINVAL;
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	ns = timecounter_read(&adapter->tc);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-- 
2.30.0

