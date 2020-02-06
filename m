Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1E1545EF
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgBFOSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:18:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43543 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFOSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:18:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id s1so3187915pfh.10;
        Thu, 06 Feb 2020 06:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tlgS5FHChO1CGBWXTjxXUP4mkvuvW/nEiNannwwjUKs=;
        b=C5fKtB+HfWa9s3R1yA90NR/reVyYx5PpUorZVhZhyxP8LEYRU34BddbXV657OB3yVg
         aUlRzqD2KzLwXLEVCEV2isyrS6k/qilnKMlKF28I33QP/ZjF0OEvvCk6DNqGepF+tWEC
         fAVLPs8p1E4iOwgJD29JREWzS7yUUWMev+5XSy3cKElgs81rAePv5maOhZqzv8J+yem8
         6Cr5+xsL9gaZyla9r3zRhJ3V4E3ZvQ8Jq9BBWf6hZUFj6OOPyqcQv8v2ejVF22yVJ5xj
         2qBYjtCInRJIomYHfGtwJKsXnoe/h40K9OfLC7SYR4/SjgjzEjPIMrwVK7cDLZPU/ymu
         oZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tlgS5FHChO1CGBWXTjxXUP4mkvuvW/nEiNannwwjUKs=;
        b=JdnCVgvnwjKQHMEvaq7SpWnX3mrzSJEkYkzFsUVouAcktJprvj684PzIuolshVouHm
         EjXYe0nOZdFq1Mg+aFCCMmd2FxDITaHni9hy22LIxS67AGsZ+5IiiMGXJJP04/5XoUC5
         OlhFV1xhnvsq5vXMs6SouYaBHiGBLMykTwJlRc9qbKzci/onLJ0kBmYjEvb5WTiEryQh
         49YqRP9MJeGLz3QdiP2p0+hQyIYuf5GJ4ane0mMuFVTzuViHOXnSqLXEhWpw+WdAMLBw
         XAK1NoV2cqxMBNRdQxqv/9NlCBxefi0CU8KJXQ3uNcLOg0IcD8CvUTX8GYpcnulDXjPg
         /CYQ==
X-Gm-Message-State: APjAAAV2ZOqFSQXcdL4pf0dpDlbISo5EihgEF9sPyzJZE4JKsEqIdUGU
        xkfdw08wbEVUAqb8RPpk2z0=
X-Google-Smtp-Source: APXvYqx6YAdoUhb5FnTWPi7Ak9w5qYjmWF1npBNQTFTivhTR5tidkJgtIV0fl6Haso1hJLuMCgwXOA==
X-Received: by 2002:a63:e007:: with SMTP id e7mr3793478pgh.414.1580998699750;
        Thu, 06 Feb 2020 06:18:19 -0800 (PST)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id i9sm3656678pfk.24.2020.02.06.06.18.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 06:18:19 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     vkoul@kernel.org, peppe.cavallaro@st.com, joabreu@synopsys.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        niklas.cassel@linaro.org, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v2] net: stmmac: fix a possible endless loop
Date:   Thu,  6 Feb 2020 22:18:11 +0800
Message-Id: <20200206141811.24862-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It forgot to reduce the value of the variable retry in a while loop
in the ethqos_configure() function. It may cause an endless loop and
without timeout.

Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
---

Vinod Koul and David Miller, Thanks for your comments!

V2:
add an appropriate Fixes tag.

 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 7ec895407d23..e0a5fe83d8e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -413,6 +413,7 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
 			dll_lock = rgmii_readl(ethqos, SDC4_STATUS);
 			if (dll_lock & SDC4_STATUS_DLL_LOCK)
 				break;
+			retry--;
 		} while (retry > 0);
 		if (!retry)
 			dev_err(&ethqos->pdev->dev,
-- 
2.25.0

