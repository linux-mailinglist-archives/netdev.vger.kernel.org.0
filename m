Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE1185DBB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 16:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgCOPDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 11:03:13 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38556 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbgCOPDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 11:03:12 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so6323244pje.3;
        Sun, 15 Mar 2020 08:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8euPoU5e8gVJfEN+dqKJ4mb2aBkkDDZAefTe4BflGU=;
        b=HIbodmEHPL7BJVP1+vBLIeAl86VaRnzD3LjgYEmhF1Bcp2astEcQHLtvnTLtefzapZ
         2NxKakGRUfYUqoYAQQAhgGXFyTjR93j2o5pTgbDpeLcRTylKqnmDLLnw55UyOxZg1GiR
         XUcEUuLQgx3bjHv0eVcvpWwi5dMiOrICctc8TFUZGqOW3wL090KZYiL0RX6ZpKJynl9X
         ujTN56qMdeMBICyH5pvEUO9zEjenwL/tHusIgOT0UryA067Loiqe/wtbWLB2HV8cMyAv
         jUTsAk0SC0s2Lo3ybUGs5DioF2Pdwy4cSOHuivUo1MxF1vE5meI4fPv7COvvdkj3ypFs
         eF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8euPoU5e8gVJfEN+dqKJ4mb2aBkkDDZAefTe4BflGU=;
        b=pSOtceBMuATaa33AKPKWHPrQDxbLvIikNKFL2NuJLrTrrB/6/oiZnMnESEEpy6ROTo
         HVH41i/OUCz9i7IAqW99YyufvORDuadC6byTEdJEntRYVaWn+hZbCqr/jWuHvboSh2j3
         c93g1Oh8iO0XZnjb9INytg1VaJRQBkhDFhFzlxM87/hfI+mz7eMdL/IHdTxPkQPZcMSY
         X/UizIrQHD1pokoT8HYzhH7LrAcKe9dofopQIkw/LL64QDxWxVMhvT0GdGukUBiPbdhh
         ZP9El6SedHkRWhLIF6gDgVN21v1aaUxaDBLxoEA1SwmZ+mGdfS/i+AKPs2lsfVrnkPSR
         kAcg==
X-Gm-Message-State: ANhLgQ1qyG4ha7rempRaERK6badGWvxU2uuZRLRB7V+SO7+RVKlsanqF
        SnXpKWEzfVi2oXkCZHyFz9Lbishh
X-Google-Smtp-Source: ADFU+vuc3s3gOmDyjgqaA2Fbl1WL6S/lDyGeRqS4gyUQ6ZQijL0Hcz/WxwK/a63/DvsP0K83onsM9w==
X-Received: by 2002:a17:90b:4d0b:: with SMTP id mw11mr19745646pjb.45.1584284591722;
        Sun, 15 Mar 2020 08:03:11 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id l11sm17271115pjy.44.2020.03.15.08.03.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 08:03:11 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 1/2] net: stmmac: use readl_poll_timeout() function in init_systime()
Date:   Sun, 15 Mar 2020 23:03:00 +0800
Message-Id: <20200315150301.32129-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200315150301.32129-1-zhengdejin5@gmail.com>
References: <20200315150301.32129-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The init_systime() function use an open coded of readl_poll_timeout().
Replace the open coded handling with the proper function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- no changed.

 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 020159622559..2a24e2a7db3b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -10,6 +10,7 @@
 *******************************************************************************/
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include "common.h"
 #include "stmmac_ptp.h"
@@ -53,8 +54,8 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 
 static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 {
-	int limit;
 	u32 value;
+	int err;
 
 	writel(sec, ioaddr + PTP_STSUR);
 	writel(nsec, ioaddr + PTP_STNSUR);
@@ -64,13 +65,10 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	limit = 10;
-	while (limit--) {
-		if (!(readl(ioaddr + PTP_TCR) & PTP_TCR_TSINIT))
-			break;
-		mdelay(10);
-	}
-	if (limit < 0)
+	err = readl_poll_timeout(ioaddr + PTP_TCR, value,
+				 !(value & PTP_TCR_TSINIT),
+				 10000, 100000);
+	if (err)
 		return -EBUSY;
 
 	return 0;
-- 
2.25.0

