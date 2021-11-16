Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8C452C5D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhKPIGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhKPIGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:06:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD99EC061570;
        Tue, 16 Nov 2021 00:03:42 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637049819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FteyQfbIgJx3ib+ogxM6J1I2KQpLjIzS+DlwgvLilnI=;
        b=3p0H7i3+4SOsv7kN1EOC12EXToXhOpfF+Lyz4QLstBDZeev8GgqXRNpkywXQ5C9HQbsAwg
        TfnF9JaTkzzle6Q+WJ6sG+CcM2EC5ipSwbt3w8+i+OIgWUe58Bce3E1o2k7wG5durpbhqn
        afKQ9EchPO533tSJxJOJr36tJa/oybMYQp5ywpx0Yb8yaTNGRf9wESQQtMWQPfduhw1m5a
        jhhEOqSjcNYYTagm78gFKma1RzNM7CCW+Q7cRtVQM8sHIwodkbgSwS5pmDyc/c16yyaQpE
        P53sjWSUvN7Cikm3l8SG4nv1c6jmU/0mGb8kH1pFq7W51NwfwZksHPSfSJou4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637049819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FteyQfbIgJx3ib+ogxM6J1I2KQpLjIzS+DlwgvLilnI=;
        b=WS/0Up9IHDqldGoUyVfy+OVZb8It2O0qBUR7Bni1dAwvdZM05aJZOrz+H1U5er4CfIgfNf
        xOiVttxtoIseCzCQ==
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: Enable PHY timestamping
Date:   Tue, 16 Nov 2021 09:03:25 +0100
Message-Id: <20211116080325.92830-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the used PHYs also support hardware timestamping, all configuration requests
should be forwared to the PHYs instead of being processed by the MAC driver
itself.

This enables PHY timestamping in combination with the cpsw driver.

Tested with an am335x based board with two DP83640 PHYs connected to the cpsw
switch.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/ti/cpsw_priv.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index ecc2a6b7e28f..c99dd9735087 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -710,20 +710,26 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 	struct cpsw_priv *priv = netdev_priv(dev);
 	struct cpsw_common *cpsw = priv->cpsw;
 	int slave_no = cpsw_slave_index(cpsw, priv);
+	struct phy_device *phy;
 
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		return cpsw_hwtstamp_set(dev, req);
-	case SIOCGHWTSTAMP:
-		return cpsw_hwtstamp_get(dev, req);
+	phy = cpsw->slaves[slave_no].phy;
+
+	if (!phy_has_hwtstamp(phy)) {
+		switch (cmd) {
+		case SIOCSHWTSTAMP:
+			return cpsw_hwtstamp_set(dev, req);
+		case SIOCGHWTSTAMP:
+			return cpsw_hwtstamp_get(dev, req);
+		}
 	}
 
-	if (!cpsw->slaves[slave_no].phy)
-		return -EOPNOTSUPP;
-	return phy_mii_ioctl(cpsw->slaves[slave_no].phy, req, cmd);
+	if (phy)
+		return phy_mii_ioctl(phy, req, cmd);
+
+	return -EOPNOTSUPP;
 }
 
 int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
-- 
2.30.2

