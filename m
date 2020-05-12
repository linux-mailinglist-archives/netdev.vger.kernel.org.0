Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EE51D003B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbgELVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731349AbgELVLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35607C061A0C;
        Tue, 12 May 2020 14:11:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so10628964wmd.0;
        Tue, 12 May 2020 14:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OY3vNHlapeEjakaFn6yCzHumviKMyl5frOy9KAAuLbc=;
        b=OiO8Wis3VDyMB7dnvd0E7wJPqM/0z6PNwEWg4fXyVsQg9BqMqXLtI7vgW/aFewdfvT
         nt0xYWXHjez6nekOAqnFec9B+o/Vpghwq7UO+fKl1pzE5t2zYC3dmFC3mE9pCg1HT2pn
         /YVk0K0W79p/mkgVWzMTdyFW52ocRtcGtkJuRQXSDEwlnGNZrWABXXcYqa5WRRgwAV2l
         JlY/Fsr0jkKDf6DhDBcQKsjE+Fd1udb5DLziGCslZJzw9Q6wzOpkR1hZ9t9rWI3vGHYP
         XAusR6sSbe1VN6LxmG0z0nYaufEgaO6VT2lGIfeXIFWLaXBMNPHzsn2aHCHpN5C2T2XI
         X+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OY3vNHlapeEjakaFn6yCzHumviKMyl5frOy9KAAuLbc=;
        b=TNBAUKcf+nqfAMHh3nWNvj2fCjnd+Y58NuC4d6RTbpoNOqcIsQ6RGzQG4P3jhvool1
         trZCaxsromQpG515wlQzw2fHa57PoX0VcD4sV27ODqDjufe2gKpPeh1mFiwXPbxktJg+
         qNXt1uqvek8NLmCKKHeABnkdR1w6n6mT5wEqMmQNxZn3HPQELE98xXZWqG6/xdsOehZ0
         qjSffzuSKNccKH2YhWz+zm5yj6diSiMBT3E7MolRpkdeUc87uMdq6/v79vjr0ALpfPNZ
         l7SOnh1KfNDZxqW9RZhpZVRb99e7Fq8MFFssljUGdWjh1oRmRMqF+tuVaQq62awLQmLF
         7oJA==
X-Gm-Message-State: AGi0Pub9cEc6YtvTrXYYuzfQJKaynoymWuXdE2DGCtPkQVMMCR2/b42V
        uHa8B3dxh5NxuFzlp4rQGLo=
X-Google-Smtp-Source: APiQypKo4FfhjEB0jvse1SzrdPMKKMpYk6wtVndZPK5RYEm8G9S1oNCzaSXJRUIPPcXA7ymfIlWncg==
X-Received: by 2002:a1c:1b96:: with SMTP id b144mr15118813wmb.6.1589317882863;
        Tue, 12 May 2020 14:11:22 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:22 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 6/8] net: stmmac: dwmac-meson8b: Fetch the "timing-adjustment" clock
Date:   Tue, 12 May 2020 23:11:01 +0200
Message-Id: <20200512211103.530674-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETHERNET registers have a built-in timing adjustment circuit
which can provide the RX delay in RGMII mode. This is driven by an
external (to this IP, but internal to the SoC) clock input. Fetch this
clock as optional (even though it's there on all supported SoCs) since
we just learned about it and existing .dtbs don't specify it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 70075628c58e..41f3ef6bea66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -85,6 +85,7 @@ struct meson8b_dwmac {
 	phy_interface_t			phy_mode;
 	struct clk			*rgmii_tx_clk;
 	u32				tx_delay_ns;
+	struct clk			*timing_adj_clk;
 };
 
 struct meson8b_dwmac_clk_configs {
@@ -380,6 +381,13 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
+	dwmac->timing_adj_clk = devm_clk_get_optional(dwmac->dev,
+						      "timing-adjustment");
+	if (IS_ERR(dwmac->timing_adj_clk)) {
+		ret = PTR_ERR(dwmac->timing_adj_clk);
+		goto err_remove_config_dt;
+	}
+
 	ret = meson8b_init_rgmii_tx_clk(dwmac);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.26.2

