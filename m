Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB932D952B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbgLNJ0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:26:08 -0500
Received: from ns2.baikalchip.com ([94.125.187.42]:46572 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgLNJ0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:26:03 -0500
Date:   Mon, 14 Dec 2020 12:25:16 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC] net: stmmac: Problem with adding the native GPIOs support
Message-ID: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello folks,

I've got a problem, which has been blowing by head up for more than three
weeks now, and I'm desperately need your help in that matter. See our
Baikal-T1 SoC is created with two DW GMAC v3.73a IP-cores. Each core
has been synthesized with two GPIOs: one as GPI and another as GPO. There
are multiple Baikal-T1-based devices have been created so far with active
GMAC interface usage and each of them has been designed like this:

 +------------------------+
 | Baikal-T1 +------------+       +------------+
 |   SoC     | DW GMAC    |       |   Some PHY |
 |           |      Rx-clk+<------+Rx-clk      |
 |           |            |       |            |
 |           |         GPI+<------+#IRQ        |
 |           |            |       |            |
 |           |       RGMII+<----->+RGMII       |
 |           |        MDIO+<----->+MDIO        |
 |           |            |       |            |
 |           |         GPO+------>+#RST        |
 |           |            |       |            |
 |           |      Tx-clk+------>+Tx-clk      |
 |           |            |       |            |
 |           +------------+       +------------+
 +------------------------+

Each of such devices has got en external RGMII-PHY attached configured via the
MDIO bus with Rx-clock supplied by the PHY and Tx-clock consumed by it. The
main peculiarity of such configuration is that the DW GMAC GPIOs have been used
to catch the PHY IRQs and to reset the PHY. Seeing the GPIOs support hasn't
been added to the STMMAC driver it's the very first setup for now, which has
been using them. Anyway the hardware setup depicted above doesn't seem
problematic at the first glance, but in fact it is. See, the DW *MAC driver
(STMMAC ethernet driver) is doing the MAC reset each time it performs the
device open or resume by means of the call-chain:

  stmmac_open()---+
                  +->stmmac_hw_setup()->stmmac_init_dma_engine()->stmmac_reset().
  stmmac_resume()-+

Such reset causes the whole interface reset: MAC, DMA and, what is more
important, GPIOs as being exposed as part of the MAC registers. That
in our case automatically causes the external PHY reset, what neither
the STTMAC driver nor the PHY subsystem expect at all.

Moreover the stmmac_reset() method polls the DMA_BUS_MODE.SFT_RESET flag
state to be sure the MAC is successfully completed. But since the external
PHY has got in reset state it doesn't generate the Rx-clk signal. Due to
that the MAC-DMA won't get out of the reset state so the stmmac_reset()
method will return timeout error. Of course I could manually restore the
GPIOs state in the stmmac_reset() before start to poll the SFT_RESET flag,
which may release the PHY reset. But that seems more like a workaround,
because the PHY still has been in reset and need to be reinitialized
anyway. Moreover some PHY may need to have more complicated reset cycle
with certain delays between RST assertion/de-assertion, so the workaround
won't work well for them.

To sum it up my question is what is the right way to resolve the problem
described above? My first idea was to just move the MAC reset from the
net-device open()/close() callbacks to the
stmmac_dvr_probe()/stmmac_dvr_remove() functions and don't reset the whole
interface on each device open. The problems we may have in that case is
due to the suspend/resume procedures, which for some reason require the
MAC reset too. That's why I need your help in this matter. Do you have any
idea how to gently add the GPIOs support and don't break the STMMAC
driver?

One more tiny question regarding the DW *MAC drivers available in kernel.
Aside of the DW GMAC Baikal-T1 SoC has also got DW xGMAC v2.11a embedded
with XPCS PHY attached. My question is what driver should we better use to
handle our xGMAC interface? AFAICS there are three DW *MAC-related drivers
the kernel currently provides:
1) drivers/net/ethernet/stmicro/stmmac
2) drivers/net/ethernet/amd/
3) drivers/net/ethernet/synopsys/
xGBE interface is supported by the drivers 1) and 2). In accordance with
https://www.spinics.net/lists/netdev/msg414148.html all xGMAC related
parts should have been added to 2), but recently the XGMAC support has
been added to 1). So I am confused what driver is now supposed to be used
for new xGMACs?

Regards,
-Sergey
