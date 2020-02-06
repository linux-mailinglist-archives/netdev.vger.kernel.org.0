Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EF1154819
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgBFPaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:30:13 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45098 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgBFPaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:30:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so2468201pls.12;
        Thu, 06 Feb 2020 07:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yvImeWdanhuXuKTpYgc+fUvWT1XXGf47f3QA3cS1IIo=;
        b=rFy8JI1vDm33O8mChanZAaw9Ljfkv2cbVdDfPeB6ygWnADagveeIi5z8zmtsfjhtXk
         tX/Hcd+yx6frFoD5raNVuvjk/3vnNIdFDP7R8yiJy2CxUbmqvk6e7GJoqIFIg2Byj4EA
         XMSjcshvC9HFUwkmuc2dZP0x5lfcWssoZVFuunuHnSZEuTX5HfAQzUJjQIz+PQPbmwz8
         GKRiviOt/4ZkcDTyuXqcrq3xuyinxw/KC2HxZAzjL+V+pTp1uHOJC7Tv01vRNfCYGtkK
         4ATt7SzL7W7MvrYlowHvzlAmdqN+Y6UxmRwxpRZcHWZMlv4o6zEfEhISBxlAbX5xTxcC
         dOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yvImeWdanhuXuKTpYgc+fUvWT1XXGf47f3QA3cS1IIo=;
        b=W5FaGgSc4uM14xTgxh6A1HRuuUuaBdvnbvhxyWj8M3z2i+Yy5w/+b79J0DaTgNDx3O
         fxt29EKy+XscdD4Ond4D3AlRflbtTaknIqrgEWLmaruNNeiH3gTUvPMk41rxx66EosQ5
         yE0wC5UX7RmJm1awfN57BoEcQwvYWKkExUK87dJdo/8GKvqE3027YF2+JcVzG9SSu1dV
         FH7vbXYWXgc59I1BPX6Ij9MfuBnMJxY8zfmodiBnurRuTc92DCrL7kXhFEq+uuFxTv+4
         qxmxrHaRotDjnkEP4JndlTf/1mvbPkKD163PVNSd2qhB1n/ugBdfH+m2amAtvDPo+rme
         Fe3Q==
X-Gm-Message-State: APjAAAVLg9QE1vRpD8i3BEfHkCxTL/yX/NUAHmXus/BMjPyi7Nm3kDyf
        7VE0h8A6iW5SbaEShn6dW/0=
X-Google-Smtp-Source: APXvYqzpVmwc8UDf4PLytIuzNQu7ecLLGVgM3QijN3zs88b3yKr+R6UlvDt1Mn1NA3D4q/iXZ4uqmA==
X-Received: by 2002:a17:90a:2ec5:: with SMTP id h5mr5063197pjs.79.1581003011165;
        Thu, 06 Feb 2020 07:30:11 -0800 (PST)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id f43sm3879247pje.23.2020.02.06.07.30.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 07:30:10 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     vkoul@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, niklas.cassel@linaro.org,
        netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v3] net: stmmac: fix a possible endless loop
Date:   Thu,  6 Feb 2020 23:29:17 +0800
Message-Id: <20200206152917.25564-1-zhengdejin5@gmail.com>
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

Hi David, I'm so sorry for that.

v3:
remove an empty line between Fixes and other tags.

v2:
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

