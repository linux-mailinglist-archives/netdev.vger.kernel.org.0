Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91037D68B0
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbfJNRkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:40:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37602 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388622AbfJNRka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:40:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so10796965pfo.4;
        Mon, 14 Oct 2019 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YC7OuTz25ULgsZk3/xaxUiSD3IVX8OuT8dFOQHTV40E=;
        b=p/R7QSQB/JIgdcZLWg63WYXM9JqkIUj4KkL51SFfUzwIdlmjnaGcJ2Fts7ES0teWL2
         LDampenpFQMPtMe5xnU0wJcUxrwBX3m5PSWm9ktsFwBUrCWU4OMWnPucr6Lb3+QUN/+O
         m0B3BFGVKAHN5p994nZKa37kQv0DEEn86yN1Ouw2zYeCnUgvBbrUqN1/XlbjHnmSfUhg
         Fi/BHVx6eVPciQbHWaEVIhLoIZF8sKO4blUYoqs4uXiKN64Vvuf6rz0atVVfz/PTDSlj
         SMXpdr3xMeLX9wWbxyF5OwsJm8PmGRtfMXQ3tuvw7DfLAjZoizaMaXWJHutVN9PlVt0U
         jYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YC7OuTz25ULgsZk3/xaxUiSD3IVX8OuT8dFOQHTV40E=;
        b=CJtLutojD7mUOdLtDvGQ8nCbL0c/j2ZmmEUZreEHNGSA0+lBgiRwsEbCn6ZmSMSEHx
         4w4yvOn2kK0u4SkaKp0lpF48LCruzmdDrM5Gj6FnJ8qxqOig7ar+bb/TVXsbiBKTaBdk
         VcStmgMhLMWFi13YvRoIfapbKhIrCPskvaQZBB5uypDzlWpUEjpHZS+LQDrMoZFi12yw
         YYhVN67CNylTkgH3zVK1BkYQma9ntDSY7OhWUTC6chW+4bvOeU6NENmM/r65eweWXoiY
         HULcSs9hsF/gvhof/w1DzeJ5xJFayd5OZEjF2ya+WSB1/tyDhqwbK0Uf9SOAtQv0x8MS
         A8Pw==
X-Gm-Message-State: APjAAAWa6XlEOl7venNJKU7JbeX4FEK2S1Ki2pMG9TiPjk2OHB9kt0DZ
        GzOgoSshdejNgLPWS5YctOo=
X-Google-Smtp-Source: APXvYqxjOKCo3M7ZMV6KqJbNw2aP1f6Tu1bNKcPINJqxxAoKbD7tAVsN3USqmsrTUf1gVVvq8Fov5w==
X-Received: by 2002:a63:1423:: with SMTP id u35mr12871006pgl.122.1571074829319;
        Mon, 14 Oct 2019 10:40:29 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id k66sm18784535pjb.11.2019.10.14.10.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:40:27 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 2/3] net: phy: fixed_phy: fix use-after-free when checking link GPIO
Date:   Mon, 14 Oct 2019 10:40:21 -0700
Message-Id: <20191014174022.94605-3-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
In-Reply-To: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we fail to locate GPIO for any reason other than deferral or
not-found-GPIO, we try to print device tree node info, however if might
be freed already as we called of_node_put() on it.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/net/phy/fixed_phy.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 7c5265fd2b94..4190f9ed5313 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -212,16 +212,13 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 */
 	gpiod = gpiod_get_from_of_node(fixed_link_node, "link-gpios", 0,
 				       GPIOD_IN, "mdio");
-	of_node_put(fixed_link_node);
-	if (IS_ERR(gpiod)) {
-		if (PTR_ERR(gpiod) == -EPROBE_DEFER)
-			return gpiod;
-
+	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
 			       fixed_link_node);
 		gpiod = NULL;
 	}
+	of_node_put(fixed_link_node);
 
 	return gpiod;
 }
-- 
2.23.0.700.g56cf767bdb-goog

