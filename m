Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D088ACC652
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfJDXOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:14:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36744 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731499AbfJDXOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:14:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so4802680pfr.3;
        Fri, 04 Oct 2019 16:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZadlJd2eMFSYQaib6E8yLWHcdXEQf3wWsyt11IKohFE=;
        b=p6er+I4Hb8i0cRBH0sjlBGLWEUvct3VIcX0CviTzChWdD7XpYHgHZT24eJ+ie5PRMg
         94rI7mac63NHpXZfIMOLUFJ42+PbS9GGRLNGQmvlSH2n3xQKzs9RSXi8TWcdiI/a+KzG
         UWkKLaAVEooBWrD82KHaAQYJWfwSf08oD99xcBLna42uh1ZibxBUHS9SBUtya1SBo2eR
         uxmNAYDpTWPN3FwwnyiEBedhBXtuxxsfnyfjcuP+MAmctCAhKgKlHUJt5gGo6BOPWjnN
         vBmcBYUghI9peKB1tqI3UhF4qxZRwws2MaHqYE759Pkv2T9qBAK0PUvbclF9XhuWc/6A
         IRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZadlJd2eMFSYQaib6E8yLWHcdXEQf3wWsyt11IKohFE=;
        b=NrF786LJqBOKnbcQ82sMSckmo+uF5eXzssqpBuFpKVcKlxi6YS3uDX/GEOKnTcMZPA
         jCm/7v+WSZjiouR3dVZLQpdA/ZiSp9PwI5qiKZyYqcuNXRgYM9r4uBiYlGPGguAR+S/Y
         aFNZ/qA8yW9GaGCNauNOOen1MmHcDcP9X8ZLfuxQJrjOeNf4nFjUT0x+5m/38fN7vANe
         K5Mm93i9exc534zg6Encs5fVkqRjAK5j2sBP7nq8+CEZ/lwsjrgo7IJM/Zb8ychMpcck
         oF1eg+eG/dtdV4SZDKpjTPYEIal8eWYWbygtFVDaPxtDdtBx7ElNLsQjC7ySrPqsCtYt
         ooZQ==
X-Gm-Message-State: APjAAAWlC4CXEWnboJra4NL6liJuzYVQIn7tqYTRPK6Jcz/L48Mg4cHL
        Cpx+1QmGrpD1xDnY3aZjvb0=
X-Google-Smtp-Source: APXvYqyzIQiOhi1A2hsEDzmCCo7kRxbmqUeRwQ8HJ6ZoW/hXjUuzomcqWwz+L63lh2cv5kIPt31CxQ==
X-Received: by 2002:a63:4243:: with SMTP id p64mr2826551pga.343.1570230841350;
        Fri, 04 Oct 2019 16:14:01 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id y6sm9514353pfp.82.2019.10.04.16.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:14:00 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/3] net: phy: fixed_phy: fix use-after-free when checking link GPIO
Date:   Fri,  4 Oct 2019 16:13:55 -0700
Message-Id: <20191004231356.135996-3-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
In-Reply-To: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we fail to locate GPIO for any reason other than deferral or
not-found-GPIO, we try to print device tree node info, however if might
be freed already as we called of_node_put() on it.

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
2.23.0.581.g78d2f28ef7-goog

