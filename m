Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1963D7A723
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfG3Li3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:38:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40240 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbfG3Li3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 07:38:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so65383490wrl.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 04:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fNgx7LSZsCgbXKdsyr24bMY9+rQUrrZFZQRC4AZtF9c=;
        b=UzuA4+3dWD5gJ/bdWkmp+oOn2TquUqRLyhTvpv71pz7iZ2sw04Dfi/dVMU4rPFxtYF
         zcafGzR25HcoGTuB2y6cMFwz1ybVu1AguN6miO5wUzRZ7j7sRtem7g6Q6+auwoAhpzVz
         qCzhMOWs34dfxcAg2dx64MnMRAdLen7WE1g38sa22lJRwwiHHlk7KZ35yq1lrK5aWI66
         l1c7ytZfhr5kiQrJ8s/w/amYJf5nkGFW5IYYdh5xMogGWyEQQ3KamGRmD/GrgzgrvAJ2
         52WnysO1TMySTSb5Z3nGjpIdG+YdE/b+LxWVdczZ9H9YUb4eM9+Gk9uN7YCn/zx3Uq+y
         M0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fNgx7LSZsCgbXKdsyr24bMY9+rQUrrZFZQRC4AZtF9c=;
        b=pkjw1XGY+W0DsNYgnKJK12B/F9uFP+nIC4IZZ6Vk+XC95Oc62wIPliX12eyX8+dJOg
         ylxcx1q2oGV1JU5P1rTO2K+ywMiaSLb40WRKTm/uyMJnMlIjBrbAdPCEEw6NglP8AtrS
         DYcVYSVK6Wlnf8af0xjLwsFUALtkB99MZrxXh6+0c0seNrdGhh9rvdWN1eVT9ZgR8wIf
         RuSWA3Hhv4yUWcaW5AKvc6vM9pRNxQkL2cUu+AZWvPTVY3mvgmnQlstyKNYArpQzoGNb
         Ozx0WIqNULV2zQ1IMmYoleZ0T6+y0cVIB2ECXMjAZYm3L8C4kjsmhwUAcfmdN+CI6Xr+
         J4KA==
X-Gm-Message-State: APjAAAWCRi8BqGbkO7HuJgw8VfzZ/v7FAL0UrySeKRoSGOdt4GvzdqOw
        dT5SI9sedolz563TQKgpCH0=
X-Google-Smtp-Source: APXvYqyrOWXJtJJE/Z8rh0NjaFzqXq9A4xuhHNIQKEOvXvJTncEPAOI8h6PfJJZs4V3dUopUN741Pg==
X-Received: by 2002:adf:f646:: with SMTP id x6mr134917936wrp.18.1564486707429;
        Tue, 30 Jul 2019 04:38:27 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:e921:c4e4:a1d5:45d1])
        by smtp.gmail.com with ESMTPSA id r11sm99600810wre.14.2019.07.30.04.38.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 04:38:26 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frode Isaksen <fisaksen@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] net: stmmac: Use netif_tx_napi_add() for TX polling function
Date:   Tue, 30 Jul 2019 13:38:14 +0200
Message-Id: <20190730113814.13825-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frode Isaksen <fisaksen@baylibre.com>

This variant of netif_napi_add() should be used from drivers
using NAPI to exclusively poll a TX queue.

Signed-off-by: Frode Isaksen <fisaksen@baylibre.com>
Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 98b1a5c6d537..390dad5b9819 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4313,8 +4313,9 @@ int stmmac_dvr_probe(struct device *device,
 				       NAPI_POLL_WEIGHT);
 		}
 		if (queue < priv->plat->tx_queues_to_use) {
-			netif_napi_add(ndev, &ch->tx_napi, stmmac_napi_poll_tx,
-				       NAPI_POLL_WEIGHT);
+			netif_tx_napi_add(ndev, &ch->tx_napi,
+					  stmmac_napi_poll_tx,
+					  NAPI_POLL_WEIGHT);
 		}
 	}
 
-- 
2.21.0

