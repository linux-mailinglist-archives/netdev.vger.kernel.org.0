Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC64242F70
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 21:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgHLThJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 15:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLThG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 15:37:06 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEAC061383;
        Wed, 12 Aug 2020 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6upE0YaOoO/ag38SB8jo+t0fs4seFaLVaVB2MuIhyRw=; b=E1kL5RqKGQWYpR7ND0VkADIj1F
        KJCusvkNuLbJx2hVqFN46suMqIlBCzYiKjFpzUbHjcihWcoFA21KUcBy7GTNELseJwlTCwnQ5OLY2
        1QT7giubWcyjXdRYglUT+dxmvkiamvQLk3+gQ+LmkwEr3lUMYCEtnJafqEtt4BU1PNKTDp/OWGK0x
        LRvoHRE4I1reJ2ZbB59xxdLjZmunDwi5+SG99hOeXJB8cIDldoIGsmOdF4+zMDddsDB0e19zf4COG
        NGXmk+g8TfPrdjgHZoFDaz10Q9+ppE9wvcXna+DLR41B/zXk7jRegdbUH2DFgy6sivsMEvFmenQbP
        T9Y5ZOPw==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k5wYX-0002o7-HJ; Wed, 12 Aug 2020 20:37:01 +0100
Date:   Wed, 12 Aug 2020 20:37:01 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: stmmac: dwmac1000: provide multicast filter
 fallback
Message-ID: <69708c8942a1f3717d15da861609344bd9a16bae.1597260787.git.noodles@earth.li>
References: <cover.1597260787.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1597260787.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't have a hardware multicast filter available then instead of
silently failing to listen for the requested ethernet broadcast
addresses fall back to receiving all multicast packets, in a similar
fashion to other drivers with no multicast filter.

Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index efc6ec1b8027..fc8759f146c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -164,6 +164,9 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 		value = GMAC_FRAME_FILTER_PR | GMAC_FRAME_FILTER_PCF;
 	} else if (dev->flags & IFF_ALLMULTI) {
 		value = GMAC_FRAME_FILTER_PM;	/* pass all multi */
+	} else if (!netdev_mc_empty(dev) && (mcbitslog2 == 0)) {
+		/* Fall back to all multicast if we've no filter */
+		value = GMAC_FRAME_FILTER_PM;
 	} else if (!netdev_mc_empty(dev)) {
 		struct netdev_hw_addr *ha;
 
-- 
2.20.1

