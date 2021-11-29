Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355D74613B5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbhK2LTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbhK2LRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:17:01 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74317C0619D7
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:28 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so69597937edv.1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRQqucCrnamTlX+tGhjWyYvcx8+/9ibHWaNBuRU1okg=;
        b=Jl7c3RJdfR1aN72MxV18HoPB4/9eke9eUCdSwt8ulnIhzLc4rCl73Wh8C+h5ZOGyWc
         X6N1dw8p9cUyDSbqgd2tgChppuwT0It9RPI4Z7XvtlNFNpCKMgMOkrCnWhV+s19X85PF
         cIAaVT3E9G1p5HtQgDTqhXpW7e+jWW0S0VClQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRQqucCrnamTlX+tGhjWyYvcx8+/9ibHWaNBuRU1okg=;
        b=qWKZd34rccdObgTSrdg0atbSTH8n5LuLFymJRTc4mB4pWG0HNauoOHsj/nu/gYTxqq
         JCIVFy/B5psxyUC7MJV7ERVpQ8OWzhG5hE13u4d/XCEoKvv9jbLrlCgg8nZ+hXSdMuhx
         Ic1KkxBDyuwH0DeWfqnSvUelhqPlpQ9bYQjWjMKMif8EpxkagirTrVnGeork/peg6OLC
         9Svch8WWq99EiDN0pZ72R1bwGvtY+hG11aZMRm6EFoUDGxEfbTlyzjfRip96W8pIIQDO
         90Ax05E06BsuoQngZw4rEjZOUBPWZCJe+6KgHxz88Rk3CR3yRH1C71LnGn8jaOQVXWbS
         wwVw==
X-Gm-Message-State: AOAM533aXXkARf8JPirk+s11ge8xiJWqcthn9GNB6+GirD16SYY6EPMt
        PVhSEfolZPF5HpogL7Hv5e32silPPYuKjqUA
X-Google-Smtp-Source: ABdhPJw3g3iFpN5Rh4hrsgL8P7OfcwEGpMJFod6mZqeb0WxhA3dsr5G7X0cTnRT/jNtbQ+RLz5j6PA==
X-Received: by 2002:a05:6402:42d4:: with SMTP id i20mr73555919edc.372.1638181827033;
        Mon, 29 Nov 2021 02:30:27 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cy26sm9008402edb.7.2021.11.29.02.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 02:30:26 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
Date:   Mon, 29 Nov 2021 11:30:17 +0100
Message-Id: <20211129103019.1997018-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Probe deferral is not an error, so don't log this as an error:

[0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek-smi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: use dev_err_probe() instead of manually checking ret

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index c66ebd0ee217..aae46ada8d83 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -456,7 +456,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	smi->ds->ops = var->ds_ops;
 	ret = dsa_register_switch(smi->ds);
 	if (ret) {
-		dev_err(dev, "unable to register switch ret = %d\n", ret);
+		dev_err_probe(dev, ret, "unable to register switch\n");
 		return ret;
 	}
 	return 0;
-- 
2.34.0

