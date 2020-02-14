Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DED15ED01
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390579AbgBNQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390581AbgBNQHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E7F206D7;
        Fri, 14 Feb 2020 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696427;
        bh=KuEgsFhctq+NMX/iGUxTFyaBIdZHanXPB/FL5E3J6L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zs/bz6QQLVX0FF6S79rCqXCECztxDTY0I+r7Ecn9okGC1gd+UNiqLF1VvoEFMt+qQ
         f4g4o4CtRjna7RLjqZtbOd3vZytWUBzJcx4RB4922vdMUCu0N9SY/Mq2TE1qBvuqgX
         sqAQxlXcmgo2iAx8V0wMfRtR4kA2KoIS3ITMUl48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 247/459] net: phy: fixed_phy: fix use-after-free when checking link GPIO
Date:   Fri, 14 Feb 2020 10:58:17 -0500
Message-Id: <20200214160149.11681-247-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit d266f19f3ae7fbcaf92229639b78d2110ae44f33 ]

If we fail to locate GPIO for any reason other than deferral or
not-found-GPIO, we try to print device tree node info, however if might
be freed already as we called of_node_put() on it.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/fixed_phy.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 7c5265fd2b94d..4190f9ed5313d 100644
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
2.20.1

