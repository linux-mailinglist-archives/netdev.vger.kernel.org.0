Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36572FC115
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbhASU0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbhASUZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:25:36 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547BBC0613C1;
        Tue, 19 Jan 2021 12:24:54 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b5so13941743ejv.4;
        Tue, 19 Jan 2021 12:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFyr2V+Jzdi4YW1yffMaIUqKhZ3/Vi5CLcZD0g+G3W0=;
        b=o+4RLf0mOmonrScZu/JxFwoEr0HqSw4KJX7HorYpAUIAC3Z4pFXORzdwqXx0ELKJQv
         8jtosQrDAVVlwbeObGSkKXhJjIC6QWTdF9cRpQ7Eefmxi+gTLqvmRANRFHV0LuNNClqU
         jgscy3xuF5QZVAPUnw/SS5ctnagl0/iKvOobiusKJA0uvujbONo7kMgpwXogk3a31d5A
         i/yfg7+FSeBGtKzh9NMRxiOOe5nkCPrVLReLB+FoM0Lx1QSbSfNFSiRvRSB+jcqrsF3Q
         kU+izgGu38oIpK+jBaKmDsng+8FLAp6oi88N10LwOacMLGiTnvtS7rhTYeABR3Ru3ZQB
         Pfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFyr2V+Jzdi4YW1yffMaIUqKhZ3/Vi5CLcZD0g+G3W0=;
        b=dPZsUsShAeFhfT5ryJp3NCpA2ddFgt2+F/mK37R9XaWO/M9k39EJxg7DX6FHF2UjP6
         bI0NUFOi75+Tul4DB3PIBS253fPl17W81VOTS1ZFp5KwQmRb1oEt7e1onxNO0Rs2o81F
         ZR9cy2p70CEqbs7V/4EYaUU3a8uiewqyfQx3LHhVU5GufXPqNWlNsI/grK4Ll11Cnyib
         PBLVq0WvjkjnT+6Ugl45oL35Xb/Du/4SN+aNNB37FosbGsuej2Eak3pHG0aX27ynDEF/
         aJgmv9VlOY7h/jR9GsnHgARcwHKIJ60C/TGxF46Lr8KqIVZjX/P5gp8dZLluaCHwdO4V
         uzQQ==
X-Gm-Message-State: AOAM533wh919+sfbbL/dok9O1YKc5AK8EcOA603cR5za6PO/H2l7VVF5
        7u9sZeJhUX6d8eioC+qWEiM=
X-Google-Smtp-Source: ABdhPJzgJWBS8Glb8O8e1TWNjzrEWbp0SXKsfSt9zOga9qYGgKUcy74g3uI6DG+n0NBnuIHe4x4Csw==
X-Received: by 2002:a17:906:87c3:: with SMTP id zb3mr4123114ejb.244.1611087893049;
        Tue, 19 Jan 2021 12:24:53 -0800 (PST)
Received: from localhost.localdomain (p200300f1373d4700428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:373d:4700:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id g18sm12876367edt.2.2021.01.19.12.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:24:52 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Martijn van Deventer <martijn@martijnvandeventer.nl>
Subject: [PATCH] net: stmmac: dwmac-meson8b: fix the RX delay validation
Date:   Tue, 19 Jan 2021 21:24:24 +0100
Message-Id: <20210119202424.591349-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When has_prg_eth1_rgmii_rx_delay is true then we support RX delays
between 0ps and 3000ps in 200ps steps. Swap the validation of the RX
delay based on the has_prg_eth1_rgmii_rx_delay flag so the 200ps check
is now applied correctly on G12A SoCs (instead of only allow 0ps or
2000ps on G12A, but 0..3000ps in 200ps steps on older SoCs which don't
support that).

Fixes: de94fc104d58ea ("net: stmmac: dwmac-meson8b: add support for the RGMII RX delay on G12A")
Reported-by: Martijn van Deventer <martijn@martijnvandeventer.nl>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Many thanks to Martijn for this excellent catch and for reporting this
issue (off-list)!


 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 55152d7ba99a..848e5c37746b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -443,16 +443,16 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 	}
 
 	if (dwmac->data->has_prg_eth1_rgmii_rx_delay) {
-		if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
+		if (dwmac->rx_delay_ps > 3000 || dwmac->rx_delay_ps % 200) {
 			dev_err(dwmac->dev,
-				"The only allowed RGMII RX delays values are: 0ps, 2000ps");
+				"The RGMII RX delay range is 0..3000ps in 200ps steps");
 			ret = -EINVAL;
 			goto err_remove_config_dt;
 		}
 	} else {
-		if (dwmac->rx_delay_ps > 3000 || dwmac->rx_delay_ps % 200) {
+		if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
 			dev_err(dwmac->dev,
-				"The RGMII RX delay range is 0..3000ps in 200ps steps");
+				"The only allowed RGMII RX delays values are: 0ps, 2000ps");
 			ret = -EINVAL;
 			goto err_remove_config_dt;
 		}
-- 
2.30.0

