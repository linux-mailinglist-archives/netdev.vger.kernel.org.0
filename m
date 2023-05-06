Return-Path: <netdev+bounces-730-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 652496F951E
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E3B21C20F98
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB25710960;
	Sat,  6 May 2023 23:59:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE2810F2
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:59:13 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D94E14355
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:59:10 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id C7D6B846AB;
	Sun,  7 May 2023 01:59:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1683417547;
	bh=ZUhS1ZWLrGpvQnUbZA/62/O7dcd8ZbzQP4fKgZ8kAT0=;
	h=From:To:Cc:Subject:Date:From;
	b=ucU7siYSnzqN0W0WYGubOpR9qIOtKlfsdYOGyXQqWD0hOpAAACsVymjVSNfpuKWcy
	 +qTHuJDyKOMVBFCyH59kr8SsZnMw+yzJMQQ/8VF7QUnNRERt7AXGBTm+y0dUnsTBRb
	 TcADCYsPOYm4MNjh8f2kv+aW2b06d+Plqz+M3u/r6aQ50uJ+9avK0OFApzXsiE0dtX
	 UaRqRZhzH3ucgoCiX0E29wNbIiN7jPqwc7LcRULnbonf3Q7TQIermthOSh1FJ0G3ys
	 YLkrb2czuIUTa+XrD8ZXsaoWm6OJojHpLVrFBY8IhEDy0AlzquxoT+lK3IxTmSxm5i
	 axdWLJddhZ9JQ==
From: Marek Vasut <marex@denx.de>
To: netdev@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Eric Dumazet <edumazet@google.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Harald Seiler <hws@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <joabreu@synopsys.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
Date: Sun,  7 May 2023 01:58:45 +0200
Message-Id: <20230506235845.246105-1-marex@denx.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
be sent out.

i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
defines this register as:
"
This register controls the generation of the Reference time (1 microsecond
tic) for all the LPI timers. This timer has to be programmed by the software
initially.
...
The application must program this counter so that the number of clock cycles
of CSR clock is 1us. (Subtract 1 from the value before programming).
For example if the CSR clock is 100MHz then this field needs to be programmed
to value 100 - 1 = 99 (which is 0x63).
This is required to generate the 1US events that are used to update some of
the EEE related counters.
"

The reset value is 0x63 on i.MX8M Plus, which means expected CSR clock are
100 MHz. However, the i.MX8M Plus "enet_qos_root_clk" are 266 MHz instead,
which means the LPI timers reach their count much sooner on this platform.

This is visible using a scope by monitoring e.g. exit from LPI mode on TX_CTL
line from MAC to PHY. This should take 30us per STMMAC_DEFAULT_TWT_LS setting,
during which the TX_CTL line transitions from tristate to low, and 30 us later
from low to high. On i.MX8M Plus, this transition takes 11 us, which matches
the 30us * 100/266 formula for misconfigured MAC_ONEUS_TIC_COUNTER register.

Configure MAC_ONEUS_TIC_COUNTER based on CSR clock, so that the LPI timers
have correct 1us reference. This then fixes EEE on i.MX8M Plus with Micrel
KSZ9131RNX PHY.

Signed-off-by: Marek Vasut <marex@denx.de>
---
NOTE: The hint that this might be related to LPI timer misconfiguration
      came from sending large fragmented ICMP request, i.e.
      ping -4 -c 1 -s 4096 -I eth1 192.168.1.1
      The received packets consistently missed the 1st fragment, because
      the LPI exit time was too short and the first packet was likely
      pushed out of the MAC while the PHY was still not ready for it.
NOTE: I suspect this can help with Toradex ELB-3757, Marcel, can you please
      test this patch on i.MX8M Plus Verdin ?
      https://developer-archives.toradex.com/software/linux/release-details?module=Verdin+iMX8M+Plus&key=ELB-3757
NOTE: STM32MP15xx sets 'ethmac' clock to 266.5 MHz, so this patch likely
      helps there as well. The default value of MAC_ONEUS_TIC_COUNTER on
      this platform is also 0x63, i.e. expected 100 MHz CSR clock. I can
      not test this with KSZ9131RNX as I do not have any STM32MP15xx
      board with this PHY. Harald, can you please test ?
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Harald Seiler <hws@denx.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 4538f334df576..d3c5306f1c41f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -181,6 +181,7 @@ enum power_event {
 #define GMAC4_LPI_CTRL_STATUS	0xd0
 #define GMAC4_LPI_TIMER_CTRL	0xd4
 #define GMAC4_LPI_ENTRY_TIMER	0xd8
+#define GMAC4_MAC_ONEUS_TIC_COUNTER	0xdc
 
 /* LPI control and status defines */
 #define GMAC4_LPI_CTRL_STATUS_LPITCSE	BIT(21)	/* LPI Tx Clock Stop Enable */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index afaec3fb9ab66..03b1c5a97826e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -25,6 +25,7 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONFIG);
+	u32 clk_rate;
 
 	value |= GMAC_CORE_INIT;
 
@@ -47,6 +48,10 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 
 	writel(value, ioaddr + GMAC_CONFIG);
 
+	/* Configure LPI 1us counter to number of CSR clock ticks in 1us - 1 */
+	clk_rate = clk_get_rate(priv->plat->stmmac_clk);
+	writel((clk_rate / 1000000) - 1, ioaddr + GMAC4_MAC_ONEUS_TIC_COUNTER);
+
 	/* Enable GMAC interrupts */
 	value = GMAC_INT_DEFAULT_ENABLE;
 
-- 
2.39.2


