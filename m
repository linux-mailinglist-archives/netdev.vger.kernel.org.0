Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92377B78
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388117AbfG0TV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:21:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54680 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0TV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:21:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so50515350wme.4;
        Sat, 27 Jul 2019 12:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hyCMqJ+djgLIJwfAojIwyPh/X7V6VrUbmzh9dzFGvRk=;
        b=KeD8rklkvJ07qbonyHkVcFLm5trOxt/Yee63IJFNjuX4015xbXSzXntmaTW9aTImNp
         oxTVmm5xSmXNVbNAfrkPp/VZAXkjM4u28ujlUHDrkhN6SFHf4Ng3cgumWYB413NUB1w8
         w+3lFm1IIB1qmSR3ddBEyzWZ5eGLZEmUlt8Z2nZm8RnPftx8W0Hj2NoBFSSNL6bnabZ+
         tRCtzXGiyYZpdBAwei9QqExKmbxAEpA0bponZxkmCU87Crd5nR/qmTrnGP9AiKcHUm9u
         i/7QJHnYUuthCTji0lgypHmuUnY/75CQaKghqbwmCixPlBumwxkUnpRukBV1ElABFEPI
         IbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hyCMqJ+djgLIJwfAojIwyPh/X7V6VrUbmzh9dzFGvRk=;
        b=eQlbDkwqNnNLYbz80csx+ZxOPqIAvawCnPHjdJsCGSif+rzd8uoWzx72TxwcwOCKGj
         4nv4FEHuE/eXACMaPtpiTKxbt1cEyi99XWBg8Kv+qRZpLrQ1llx3kZFo1052j1+iVrUr
         /3K/hpw5/kdyxkKKSg7l0ciyHmf3dmyRtBg3tvsKIr9+oxPXH6qc+g64iC5hUP4b1DRY
         OzmxSXyUl8iDhze93Ixhrfkk9FmxRiEfEe/e15HIQ9dXqM19bPaw+00XAsazN74o23+0
         RxMbi1sJN/e5+fvjXyBXB068ti1G/s9BkiiUlQrr6A6L6y1wvDDANNLKCzt0Q8twzmiR
         6tGA==
X-Gm-Message-State: APjAAAV9W3Xf9JNVhdi6qQu+48KB6odhA7fbTxAkY8MVhFGN7B+dxAK8
        JgKEhuFO6p9gLRj9H+7ADqvXBrcl
X-Google-Smtp-Source: APXvYqycHw5s2j9png7x0EIKV/GvqCO1yWsvU/74NThd+ynVk8oiaeULI52GZ8XNSc4h/2Wj5R34WQ==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr86098580wmb.4.1564255314634;
        Sat, 27 Jul 2019 12:21:54 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C65C00B418D0F4A25A19EC.dip0.t-ipconnect.de. [2003:f1:33c6:5c00:b418:d0f4:a25a:19ec])
        by smtp.googlemail.com with ESMTPSA id v15sm55542326wrt.25.2019.07.27.12.21.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 12:21:54 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: stmmac: manage errors returned by of_get_mac_address()
Date:   Sat, 27 Jul 2019 21:21:37 +0200
Message-Id: <20190727192137.27881-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
added support for reading the MAC address from an nvmem-cell. This
required changing the logic to return an error pointer upon failure.

If stmmac is loaded before the nvmem provider driver then
of_get_mac_address() return an error pointer with -EPROBE_DEFER.

Propagate this error so the stmmac driver will be probed again after the
nvmem provider driver is loaded.
Default to a random generated MAC address in case of any other error,
instead of using the error pointer as MAC address.

Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 73fc2524372e..154daf4d1072 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -370,6 +370,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		return ERR_PTR(-ENOMEM);
 
 	*mac = of_get_mac_address(np);
+	if (IS_ERR(*mac)) {
+		if (PTR_ERR(*mac) == -EPROBE_DEFER)
+			return ERR_CAST(*mac);
+
+		*mac = NULL;
+	}
+
 	plat->interface = of_get_phy_mode(np);
 
 	/* Some wrapper drivers still rely on phy_node. Let's save it while
-- 
2.22.0

