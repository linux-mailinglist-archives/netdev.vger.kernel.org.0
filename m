Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CD318618E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgCPCdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:33:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32808 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgCPCdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:33:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id n7so9085507pfn.0;
        Sun, 15 Mar 2020 19:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xb6eGJlkZ3RraRHjQRFPyKktg2A5qqYgiyd1407X5EA=;
        b=Pohao3v5ffnYH82Bpcrje8LKI2euQ7YrSlftyPJ4Jc8Ec8NGvKWcpvmRoeKHikOb3r
         837gsq8lUXizljokzz8H5PbW+/TMjuq5HHwLgIX9GMuTOAdR/bSTcNds2bavWHp3xtpn
         Z6Alq41OV466QZ0ADWh0RCa9Nmw+00oHWfTiktPK/HxXYCe87p8hGVoInDwkiqoRul9q
         ztYtexo7kVkl10voUg3TbX6aUdZXncEGICG/ETcp2Uo4UAOP1MCM9xTymmbVdwvj07ns
         x/d7VCj7LY8DKxVUDClu2udaKd7lVnY+dTSNUKrxFswTxdPFU61qjwu5kf1FiwKL1gKH
         vOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xb6eGJlkZ3RraRHjQRFPyKktg2A5qqYgiyd1407X5EA=;
        b=oKOUw59R62ocb09p92yrywO2lQEA9NtHt76Fjxyh3SK81Z3i4//IMc32Ra70PKXpaA
         rXPaH8TxxM+u0QBMSaIytlnAsVpXJ4K80UKjob8xxmpy5lYo023lHF4fSqSultwq3Sff
         +PyvE7/T7zGnupbeKzW9/ej7fZE0b3NVeJe3PqJd1NHmFcjm+z2U/h6samvkqDDVmrbJ
         KrzWO6lJdHXL0FGuI2upwrLhPCalbXeA8dHCVCPlZluHlP2tXs8KIviUAykmJwHaH+Lc
         xfErivBKWgfnXegmcDdsd+yCB13eo1lpDerr7YE4uw4vgzILHhanEwDGh0CxgAv/UpKP
         jR/g==
X-Gm-Message-State: ANhLgQ0ceZw4o2zwemAWUJloQfPTks7g3tSIHJEgLNUfBWtNLTbtYDLa
        Cvxk+rEE9VYm2dzxVBuA0MQ=
X-Google-Smtp-Source: ADFU+vsxw9h2MVwPsE6eZQTxRHk3CCZ6ymGRtR278/lnLeTe6Ya8bd+1lmtqV6ceAlKNVHLfVDeY6w==
X-Received: by 2002:aa7:9307:: with SMTP id 7mr22826246pfj.273.1584325983934;
        Sun, 15 Mar 2020 19:33:03 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id f19sm54950752pgf.33.2020.03.15.19.33.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 19:33:03 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, andrew@lunn.ch
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 1/2] net: stmmac: use readl_poll_timeout() function in init_systime()
Date:   Mon, 16 Mar 2020 10:32:53 +0800
Message-Id: <20200316023254.13201-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200316023254.13201-1-zhengdejin5@gmail.com>
References: <20200316023254.13201-1-zhengdejin5@gmail.com>
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
v2 -> v3:
	- return whatever error code by readl_poll_timeout() returned.
v1 -> v2:
	- no changed.

 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 020159622559..fcf080243a0f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -10,6 +10,7 @@
 *******************************************************************************/
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include "common.h"
 #include "stmmac_ptp.h"
@@ -53,7 +54,6 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 
 static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 {
-	int limit;
 	u32 value;
 
 	writel(sec, ioaddr + PTP_STSUR);
@@ -64,16 +64,9 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	limit = 10;
-	while (limit--) {
-		if (!(readl(ioaddr + PTP_TCR) & PTP_TCR_TSINIT))
-			break;
-		mdelay(10);
-	}
-	if (limit < 0)
-		return -EBUSY;
-
-	return 0;
+	return readl_poll_timeout(ioaddr + PTP_TCR, value,
+				 !(value & PTP_TCR_TSINIT),
+				 10000, 100000);
 }
 
 static int config_addend(void __iomem *ioaddr, u32 addend)
-- 
2.25.0

