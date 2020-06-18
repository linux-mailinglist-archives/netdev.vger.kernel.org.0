Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97DF1FE4F4
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgFRBSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgFRBSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBE621D80;
        Thu, 18 Jun 2020 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443096;
        bh=yB7wWyi9+IYrPrdKr8DWQdWd+iR//4lrmBwaUYqQMNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTMHOvG1agfF3XBQM0RYU5fjW/BOo/t7SUuDW47YQ3mKtZmuEA+t508XJkXsVT0yZ
         mdEhB+tUr+NtU1DGusJiS4zDPe2I/b8BRR1f2o6fAevcBAnx+kWwRv0G8zntNdBlps
         +tENtbM8Fscwp3rXrf3CKg+UGwcfTJd/EJ1OXH5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 076/266] net: dsa: lantiq_gswip: fix and improve the unsupported interface error
Date:   Wed, 17 Jun 2020 21:13:21 -0400
Message-Id: <20200618011631.604574-76-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 4d3da2d8d91f66988a829a18a0ce59945e8ae4fb ]

While trying to use the lantiq_gswip driver on one of my boards I made
a mistake when specifying the phy-mode (because the out-of-tree driver
wants phy-mode "gmii" or "mii" for the internal PHYs). In this case the
following error is printed multiple times:
  Unsupported interface: 3

While it gives at least a hint at what may be wrong it is not very user
friendly. Print the human readable phy-mode and also which port is
configured incorrectly (this hardware supports ports 0..6) to improve
the cases where someone made a mistake.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index a69c9b9878b7..636966e93517 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1451,7 +1451,8 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 
 unsupported:
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	dev_err(ds->dev, "Unsupported interface: %d\n", state->interface);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
 	return;
 }
 
-- 
2.25.1

