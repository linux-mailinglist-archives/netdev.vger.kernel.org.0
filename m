Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C498FB35A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfKMPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:12:41 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51288 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727988AbfKMPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:12:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 15049C0E8F;
        Wed, 13 Nov 2019 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573657941; bh=BR2u1Q88cqsbGfAOXXojwkBp8kfiWQs0auglmg6xKq0=;
        h=From:To:Cc:Subject:Date:From;
        b=SZ7fERxeeCqN95S198ncRqPWVSI2Xh37hy9kqJHakuBUp801CGk81EOvtnSicH+9J
         LaNdjb9uHs5uuxtiXL/J74Mc7HaT6CyN1HovlU8LEtQfDpIWa9JlVGSS3qODUo1vbz
         lUS/WnTFdlgykScXmS6KOvpttIaKpggAPP2JVms1PwXxHydYfv9tZTy6FX9O2T+QDn
         rtTNZPMrgxlxw8/9yVa8x0EJ/qa5rrR1XLregBBKhTqMr6MW23LBNmOVB2ccHk6Lzb
         jPQ2iY6hjelAkB7kvM9TRb/LAdMOzi6f3mIWos7Bi9yvTYAEkivu9r+GXMDzItN4ly
         NYtk10bzSmoBw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id BBDF6A0078;
        Wed, 13 Nov 2019 15:12:18 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: stmmac: CPU Performance Improvements
Date:   Wed, 13 Nov 2019 16:12:01 +0100
Message-Id: <cover.1573657592.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU Performance improvements for stmmac. Please check bellow for results
before and after the series.

Patch 1/7, allows RX Interrupt on Completion to be disabled and only use the
RX HW Watchdog.

Patch 2/7, setups the default RX coalesce settings instead of using the
minimum value.

Patch 3/7, enables the Transmit Buffer Unavailable interrupt on GMAC4+ cores
so that we don't miss any packet that could have been coalesced.

Patch 4/7 and 5/7, removes the uneeded computations for RX Flow Control
activation/de-activation, on some cases.

Patch 6/7, tunes-up the default coalesce settings.

Patch 7/7, corrects the interpretation of TX Coalesce.


NetPerf UDP Results:
--------------------

Socket  Message  Elapsed      Messages                   CPU      Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB
--- XGMAC@2.5G: Before
212992    1400   10.00     2100620      0     2351.7     36.69    5.112
212992           10.00     2100539            2351.6     26.18    3.648
--- XGMAC@2.5G: After
212992    1400   10.00     2116860      0     2370.4     27.61    3.816 
212992           10.00     2111552            2364.5     17.41    2.407

--- GMAC5@1G: Before
212992    1400   10.00      786000      0      880.2     34.71    12.923
212992           10.00      786000             880.2     23.42    8.719
--- GMAC5@1G: After
212992    1400   10.00      847702      0      949.3     15.07    5.201 
212992           10.00      847702             949.3     12.91    4.456


Perf TCP Results on RX Path:
----------------------------
--- XGMAC@2.5G: Before
22.51%  swapper          [stmmac]           [k] dwxgmac2_dma_interrupt
10.82%  swapper          [stmmac]           [k] dwxgmac2_host_mtl_irq_status
 5.21%  swapper          [stmmac]           [k] dwxgmac2_host_irq_status
 4.67%  swapper          [stmmac]           [k] dwxgmac3_safety_feat_irq_status
 3.63%  swapper          [kernel.kallsyms]  [k] stack_trace_consume_entry
 2.74%  iperf3           [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
 2.52%  swapper          [kernel.kallsyms]  [k] update_stack_state
 1.94%  ksoftirqd/0      [stmmac]           [k] dwxgmac2_dma_interrupt
 1.45%  iperf3           [kernel.kallsyms]  [k] queued_spin_lock_slowpath
 1.26%  swapper          [kernel.kallsyms]  [k] create_object
--- XGMAC@2.5G: After
12.00%  swapper          [stmmac]           [k] dwxgmac2_dma_interrupt
 5.96%  swapper          [kernel.kallsyms]  [k] stack_trace_consume_entry
 5.65%  swapper          [stmmac]           [k] dwxgmac2_host_mtl_irq_status
 4.36%  swapper          [kernel.kallsyms]  [k] update_stack_state
 3.91%  iperf3           [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
 2.82%  swapper          [stmmac]           [k] dwxgmac2_host_irq_status
 2.62%  swapper          [stmmac]           [k] dwxgmac3_safety_feat_irq_status
 2.25%  swapper          [kernel.kallsyms]  [k] create_object
 2.03%  swapper          [stmmac]           [k] stmmac_napi_poll_rx
 1.97%  swapper          [kernel.kallsyms]  [k] unwind_next_frame.part.4

--- GMAC5@1G: Before
31.29%  swapper          [stmmac]           [k] dwmac4_dma_interrupt
14.57%  swapper          [stmmac]           [k] dwmac4_irq_mtl_status
10.66%  swapper          [stmmac]           [k] dwmac4_irq_status
 1.97%  swapper          [kernel.kallsyms]  [k] stack_trace_consume_entry
 1.73%  iperf3           [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
 1.59%  swapper          [kernel.kallsyms]  [k] update_stack_state
 1.15%  iperf3           [kernel.kallsyms]  [k] do_syscall_64
 1.01%  ksoftirqd/0      [stmmac]           [k] dwmac4_dma_interrupt
 0.89%  swapper          [kernel.kallsyms]  [k] __default_send_IPI_dest_field
 0.75%  swapper          [stmmac]           [k] stmmac_napi_poll_rx
--- GMAC5@1G: After
 9.27%  swapper          [stmmac]           [k] dwmac4_dma_interrupt
 6.35%  swapper          [kernel.kallsyms]  [k] stack_trace_consume_entry
 4.94%  swapper          [kernel.kallsyms]  [k] update_stack_state
 4.70%  swapper          [stmmac]           [k] dwmac4_irq_mtl_status
 3.58%  swapper          [stmmac]           [k] dwmac4_irq_status
 3.42%  iperf3           [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
 2.18%  swapper          [kernel.kallsyms]  [k] unwind_next_frame.part.4
 2.17%  swapper          [stmmac]           [k] stmmac_napi_poll_rx
 2.15%  swapper          [kernel.kallsyms]  [k] create_object
 1.26%  swapper          [kernel.kallsyms]  [k] unwind_get_return_address

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (7):
  net: stmmac: Do not set RX IC bit if RX Coalesce is zero
  net: stmmac: Setup a default RX Coalesce value instead of the minimum
  net: stmmac: gmac4+: Enable the TBU Interrupt
  net: stmmac: gmac4+: Remove uneeded computation for RFA/RFD
  net: stmmac: xgmac: Remove uneeded computation for RFA/RFD
  net: stmmac: Tune-up default coalesce settings
  net: stmmac: TX Coalesce should be per-packet

 drivers/net/ethernet/stmicro/stmmac/common.h       |  5 +++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   | 14 ++------------
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 14 ++------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 14 ++++++++------
 5 files changed, 17 insertions(+), 32 deletions(-)

-- 
2.7.4

