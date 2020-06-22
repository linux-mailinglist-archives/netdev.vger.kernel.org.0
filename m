Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13445203F28
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbgFVS3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730139AbgFVS3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:29:45 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD63C061573;
        Mon, 22 Jun 2020 11:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CHDPQRCF8RcUn1ZfKaD8qjSY2WQnALFRzpAXrVpnKI0=; b=izC/D2DnG2aP9tepJ2H+BFC2Ug
        JmxyKdCL6mkil1f9KdbZtEzf5zpYswLlpRJdw6bFUlydhcq9hcCKGr58lrKn99BiLzNLAxb4V8TGi
        rEvMoKFqE0s/Q0GTDTx7WpJkwBjtQjlh6R3qwswx2zaL73Ds6QhadbawwNTxdbZ9dpfSeOIi/oOT8
        mBIQOfrjgxfsU44yloKOvNlwGRqYQtp+u4Zwrbpl8ZvjRxg/uC0oXKgcWsdEXdD/yUdeiiCg0YH96
        WHR7QVCiY9J5wGPv2B06iVP4ArqXPlyUFtxocDOubenxs7phzDiTanRq7cN7Zz1XZ8kOFNEV6ZGCW
        6CYixE6Q==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jnRCO-00020W-KS; Mon, 22 Jun 2020 19:29:40 +0100
Date:   Mon, 22 Jun 2020 19:29:40 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mathieu Olivari <mathieu@codeaurora.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH] net: stmmac: Set FIFO sizes for ipq806x
Message-ID: <20200622182940.GA6991@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(This is an RFC in the hope someone with better knowledge of the
Qualcomm IPQ806x hardware can confirm 8k is the correct FIFO depth. I've
plucked that value from the MikroTik kernel patch, and it works for me,
and 0 definitely isn't the right value.)

Commit eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
started using the TX FIFO size to verify what counts as a valid MTU
request for the stmmac driver.  This is unset for the ipq806x variant.
Looking at older patches for this it seems the RX + TX buffers can be
up to 8k, so set appropriately.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 02102c781a8c..546b37ebd3b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -351,6 +351,8 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	plat_dat->has_gmac = true;
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
+	plat_dat->tx_fifo_size = 8192;
+	plat_dat->rx_fifo_size = 8192;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)
-- 
2.20.1

