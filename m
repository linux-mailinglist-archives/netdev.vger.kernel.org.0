Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0E1B6B1
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfEMNG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:06:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34933 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfEMNG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:06:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so9619794wmj.0
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 06:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=CXM/sAS6gtztrX2ItBHaQh/rCG7OOeN6BL0gyVWj5Hs=;
        b=GslG7+cZPvOdOZdTWehD3qyjIhEDcW2T5HIFyOCJTkkfLxc+l2hF9kWZo9gGxKg4Vr
         YQOKf4PSb4ovF9se5btS2Jix6wf/siXTKB4yos83DlZOxnHPh2PzMbJMct/NZU/4NUkm
         MPi+6cotGwhzHe7X2TycUvGBfdwS9wWD1n391CFVkHQ/A6JdBJOysmr5ofHJEkX2rts/
         5OhlR7r+1fvMZ/So59hGa3lgmD2Jo8zuRhVf/oBoQjiEpa7cji8C9JGEzAzJyhIEhbkx
         aLEeaeEKTpBTRvmL5eASQeQCBPGQvECRfhHzD7Bz+pJWAbTtVwu0Ft8rFek8NP1ULEB2
         /d/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CXM/sAS6gtztrX2ItBHaQh/rCG7OOeN6BL0gyVWj5Hs=;
        b=eZ3SzMjpLVcvmX5wXePF0gv/MOViWe8u0uhdyLdeuDXTpZihzpbNmioLU+cvOFyzt0
         U/lGzZYOduu1bfOuggm+hLsYmSAS5FsYS3Z/6GPwY5L8U3/EfOWEGp+2JYlCyGP0PB0R
         GTOc8LGV23I/VRx+RRXIen/gCbyxdzP5HzB/7Z4Zk+vZayRdIO4dBCH3HDqp3LWFYZN5
         innZ1ffktUqRD7U/KSt8u6Bf6wwNiaeyFzOLSUeFNhgQuNWOihkSry/tJ60/gPj6uQ8c
         AS6p34ZNlEPZ7CNiVmAI9FfHKQsbPNi5SJQLQ5jg1moB5l6P7EK0nHBPE9MJGTY2ySjw
         XAkg==
X-Gm-Message-State: APjAAAW/1Zb0CGSHdkZMo7k1htj+fpw/Os1itEcb4kZWrupptdyXPFmq
        T+nvzJxbXJN24f08dJvXi/nV7A==
X-Google-Smtp-Source: APXvYqzBz5EitlkDpf/Id1MzoeK9OnY9qfX/brhrBMq59YPXLx9oj7yX4jc4dlI7NopLVr++jeUGwg==
X-Received: by 2002:a1c:4083:: with SMTP id n125mr11793765wma.54.1557752817725;
        Mon, 13 May 2019 06:06:57 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m17sm15699206wmc.6.2019.05.13.06.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 May 2019 06:06:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        maxime.ripard@bootlin.com, peppe.cavallaro@st.com, wens@csie.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering
Date:   Mon, 13 May 2019 13:06:39 +0000
Message-Id: <1557752799-9989-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding more MAC address to a dwmac-sun8i interface, the device goes
directly in promiscuous mode.
This is due to IFF_UNICAST_FLT missing flag.

So since the hardware support unicast filtering, let's add IFF_UNICAST_FLT.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index ac19bf62db70..9d3112beb19f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1018,6 +1018,8 @@ static struct mac_device_info *sun8i_dwmac_setup(void *ppriv)
 	mac->mac = &sun8i_dwmac_ops;
 	mac->dma = &sun8i_dwmac_dma_ops;
 
+	priv->dev->priv_flags |= IFF_UNICAST_FLT;
+
 	/* The loopback bit seems to be re-set when link change
 	 * Simply mask it each time
 	 * Speed 10/100/1000 are set in BIT(2)/BIT(3)
-- 
2.21.0

