Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597E41544C8
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgBFNWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:22:05 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38057 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbgBFNWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:22:05 -0500
Received: by mail-pj1-f67.google.com with SMTP id j17so2550574pjz.3;
        Thu, 06 Feb 2020 05:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MMEdhBkwc3vUygsidCCQyAeg+NALFLEwybGyK66dnDM=;
        b=ThufnkVcDU19LYejj+ltE3+1XMcAoY8Q+5t0KjvrkpxTrDaeOXYjjmvDvZN/xss2zg
         c51VN03oWDQJKeGWbijzI7CpMn4Nl1RO0c2uNhdpZURO1rGkaTGV1iXXXzZ1QvutbMy/
         LVSnZCHO4RmjIfUno4drB63Z33CNnlrYz3D/AATMdEg4kyx06lZ8PFkMMpjr3z3WV7/o
         Xq50QheauxttDJWQN971cFp4SWsyZM8Lr+bYDGY2svzGNgyZNzEGW6iPJF9bjJAE56Zo
         Th03yl9mlf985Cb/6oqKI6vrQhaMtcEGDcIAD0cp2d1QEt8m6fMtG1fniOeoygtxEInx
         JHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MMEdhBkwc3vUygsidCCQyAeg+NALFLEwybGyK66dnDM=;
        b=VLPM9TFk/3uWy+W+fpOCeBAvxGnSsZS+j52KXEVtIs7D1bjKO268CH+92rvmaY7vg8
         xXwC+7UG2I2Tc4L3QOM3LDoJwO3/qKmNjExiIlTws4GDWJXOje4v45JGUzMz2jwxUE9h
         lw5vEQHX/U7Zq6Y9fdVFUuNEeFn9K0YvMRls9EvK/VVUB3cdgeCKDIAGdGj8I0AX6V3Q
         slIwoLuP6C5YSroXf28Yvw5/+L9HeoFfC3vyorkYr/HtYexi4s/8snPAeUh9erla8J0n
         K6610wMzjOHG0hEZL/UYvW4QzlPKIaEcMdu79SV8Ut8V/elRIXsEUP5xYGaqcD/v/vGL
         I0eg==
X-Gm-Message-State: APjAAAV8pA+93SlTRz31Px36VqxdiZD9R+ZI3R4iqQy/peEfohTp0nr/
        2GpzypEMv92ZBgpDy2+Z0bc=
X-Google-Smtp-Source: APXvYqxnin0IXvtlv+L3JlOyDTCqX/MIheUeZ43LFgp9JPOckvDVyoULOK5DJ/d00XhbqGPuQwVrVw==
X-Received: by 2002:a17:902:680c:: with SMTP id h12mr3688016plk.102.1580995324525;
        Thu, 06 Feb 2020 05:22:04 -0800 (PST)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id f9sm3306849pfd.141.2020.02.06.05.22.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 05:22:04 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     vkoul@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: stmmac: fix a possible endless loop
Date:   Thu,  6 Feb 2020 21:21:47 +0800
Message-Id: <20200206132147.22874-1-zhengdejin5@gmail.com>
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

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

