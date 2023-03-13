Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEDD6B84FC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCMWnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCMWm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:42:56 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D2BD907BD;
        Mon, 13 Mar 2023 15:42:43 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 9FFDAE0EB1;
        Tue, 14 Mar 2023 01:42:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:message-id
        :mime-version:reply-to:subject:subject:to:to; s=post; bh=RStMyZ7
        cBJJaQ8YqXMFu9E5nYUg4R2IbXkunNku2UuU=; b=XS/stumZLCchCpcKAz0Q5Yn
        9w2jDm7NU/69v1757wisSfIWZrXsJ15n2CrgPVv+oivieHPOw5rL6FbluKh2nwcc
        4LGo+y/3VLwF1rSxiWP6hltVkW8+B9yFwuFnM3wDpHVUw0GkONcn57Iqm6DMSta0
        9QRY3jk/nrNLmit8tCTs=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 60970E0E6A;
        Tue, 14 Mar 2023 01:42:42 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:41 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 00/13] net: stmmac: Fixes bundle #1
Date:   Tue, 14 Mar 2023 01:42:24 +0300
Message-ID: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even a mere glance at the STMMAC driver code reveals multiple problematic
parts. Here just the brightest of them: intermix of the platform-specific,
runtime and even LLDD-specific (Hello Intel) parameters defined in the
platform data, redundant (sometimes up to four) parameters defining a
device feature state, very unfortunate DW MAC id (MAC100, GMAC, QoS,
X-GMAC) and versioning interface, too bulky and clumsy HW-abstraction
interface with non-unified function prototypes accepting device-dependent
arguments instead of taking a single HW descriptor or STMMAC driver
private data aside with algo-dependent parameters, non-unified
declarations and definitions spread out between four header files
"stmmac.h", "stmmac_platform.h", <linux/stmmac.h>, common.h, hwif.h, code
snippet duplicated all over the driver code (i.e. DMA descriptors ring
access), and so on and so forth.

All of that makes the STMMAC driver very hard to read, maintain and
update. Thus any more-or-less complicated change not only turns to be
larger than it could be (which besides makes it harder to review) but also
may have higher risks to break things in unexpected places of the driver.
Therefore at the very least the code cleanup suggests itself here.

At first we didn't want to change the driver much in a hope to add Baikal
SoC GMAC and X-GMAC (based on the DW GMAC and X-GMAC IP-cores) support
with as less modifications as possible. But the more features we developed
the more problems we discovered including actual bugs (currently there are
three fixes patchset we managed to collect). So after a lot of thoughts we
decided first to provide a series of patchsets with bug fixes, cleanups,
optimizations and refactoring of the driver parts thus having a driver
more ready to be updated with our versions DW GMAC/X-GMAC features and
getting more stable, simpler to read and maintain code after all.

All the work which was done in regards to the announced alterations
(and yet to be done) is split up into a set of more-or-less coherent
patchsets which will be submitted one after another upon review process
advance. The only exception is the DT-bindings series which contains
independent changes and can be delivered before ahead the rest of the
patchsets.

This patchset is the first one in the series of updates implemented in the
framework of activity to simplify the DW MAC/STMMAC driver code and
provide Baikal GMAC/X-GMAC support after all:

+> [1: In-review v1]: net: stmmac: Fixes bundle #1
+> Link: ---you are looking at it---
[2: Stalled   v1]: net: stmmac: Fixes bundle #2
Link: ---not submitted yet---
[3: Stalled   v1]: net: stmmac: Fixes bundle #3
Link: ---not submitted yet---
[4: Stalled   v1]: dt-bindings: net: dwmac: Extend clocks, props desc and constraints
Link: ---not submitted yet---
[5: Stalled   v1]: dt-bindings: net: dwmac: Fix MTL queues and AXI-bus props
Link: ---not submitted yet---
[6: Stalled   v1]: net: stmmac: Generic platform res, props and DMA cleanups
Link: ---not submitted yet---
[7: Stalled   v1]: net: stmmac: Generic platform rst, phy and clk cleanups
Link: ---not submitted yet---
[8: Stalled   v1]: net: stmmac: Main driver code cleanups bundle #1
Link: ---not submitted yet---
[9: Stalled   v1]: net: stmmac: Main driver code cleanups bundle #2
Link: ---not submitted yet---
[10: Stalled  v1]: net: stmmac: DW MAC HW info init refactoring
Link: ---not submitted yet---
[11: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #1
Link: ---not submitted yet---
[12: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #2
Link: ---not submitted yet---
[13: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #3
Link: ---not submitted yet---
[14: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #4
Link: ---not submitted yet---
[15: Stalled  v1]: net: stmmac: Unify/simplify HW-interface
Link: ---not submitted yet---
[16: Stalled  v1]: net: stmmac: Norm/Enh/etc DMA descriptor init fixes
Link: ---not submitted yet---
[17: Stalled  v1]: net: stmmac: Norm/Enh/etc DMA descriptor init cleanups
Link: ---not submitted yet---
[18: Stalled  v1]: net: stmmac: Main driver code cleanups bundle #3
Link: ---not submitted yet---
[..: In-prep] to be continued (IRQ handling refactoring, SW-reset-less config,
                               generic GPIO support, ARP offload support,
                               In-band RGMII link state, etc)
[..: In-prep] to be continued (Baikal-{T,M,L,S} SoCs GMAC, X-GMAC and XPCS
                               support)

Here is a short summary of what is introduced in this patchset.

The series starts with a fix, which I submitted two years ago. It concerns
the RTL8211E PHY working in the LPI-mode with the RX clock gating. In
particular it was discovered that disabling RXC in LPI (EEE) causes
RTL8211E PHY partial freeze until the next MDIO read operation from the
PHY CSRs. We suggest to fix that problem by dummy reading from the MMD
Data register each time the PC1R.10 bit is intended to be set. See the
patch log for more details.

Afterwards a set of the DW (G)MAC chain-mode fixes go. In particular the
first fix concerns setting the LS flag for jumbos if not the last segment
of the payload is passed within skb (similar fix was provided for the ring
mode sometime ago). The second patch fixes the invalid DMA descriptors
pointer calculation for jumbo frame transmission procedure. The third
modification prevents the global chain-mode flag modification for the
Sun8i NICs. Final update makes sure that ATDS flag (Extended Enhanced DMA
descriptors support is activated) is set no matter whether ring or chain
mode is activated.

Then two fixes of the data corruption and memory leaks are introduced. The
first one concerns the SKB saved in the Rx-state cache, which left
available after the NIC re-open cycle thus causing improper reception of
the first frame. The second patch fixes the Rx DMA descriptors memory
left allocated on the Tx DMA descriptors allocation failure.

Afterwards the Rx-mitigation algorithm fix is provided. Currently it
turned out to be malfunction since the Rx interrupt is only triggered
based on the Rx watchdog timer meanwhile it is supposed to be triggered
either by the watchdog timer or after receiving a defined number of
frames.

Then a fix of the buf_sz kernel module parameter goes. In particular
it converts the parameter to indicating the minimal value of the Rx DMA
buffers size instead of being completely useless.

The next patch fixes the inconsistency in the DW GMAC v4.10 DMA ops
descriptor, which for unknown reason was initialized with the pointer to
dwmac4_disable_dma_irq() procedure instead of using the dedicated for
v4.10 dwmac410_disable_dma_irq() method. That didn't cause any problem
because the modified bits matches in both IP-core revisions, but for
consistency we suggest to fix that.

The patchset continues with the PTP-part of the driver fix. The
corresponding patch prevents the stmmac_ptp_register() procedure from
modifying the fields of the ptp_clock_info static structure instance.

Finally the series is closed with a patch fixing the Loongson PCI MAC
glue-driver, which erroneously accepts the zero IRQ number as valid
(see of_irq_get*() semantics for details).

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc: Christian Marangi <ansuelsmth@gmail.com>
Cc: Biao Huang <biao.huang@mediatek.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Serge Semin (13):
  net: phy: realtek: Fix events detection failure in LPI mode
  net: stmmac: Omit last desc flag for non-linear jumbos in chain-mode
  net: stmmac: Fix extended descriptors usage for jumbos in chain-mode
  net: stmmac: dwmac-sun8i: Don't modify chain-mode module parameter
  net: stmmac: Enable ATDS for chain-mode
  net: stmmac: Free temporary Rx SKB on request
  net: stmmac: Free Rx descs on Tx allocation failure
  net: stmmac: Fix Rx IC bit setting procedure for Rx-mitigation
  net: stmmac: Remove default maxmtu DT-platform setting
  net: stmmac: Make buf_sz module parameter useful
  net: stmmac: gmac4: Use dwmac410_disable_dma_irq for DW MAC v4.10 DMA
  net: stmmac: Stop overriding the PTP clock info static instance
  net: dwmac-loongson: Perceive zero IRQ as invalid

 .../net/ethernet/stmicro/stmmac/chain_mode.c  | 14 +++++--
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  |  6 +--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 39 +++++++++----------
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  5 ---
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 19 ++++-----
 drivers/net/phy/realtek.c                     | 37 ++++++++++++++++++
 7 files changed, 77 insertions(+), 45 deletions(-)

-- 
2.39.2


