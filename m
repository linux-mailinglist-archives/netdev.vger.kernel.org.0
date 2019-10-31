Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C9BEAE36
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfJaLBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:45 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59462 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbfJaLBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:04 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 69311C08AB;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=V8PYaIxRBCd5CjKybZ8TOnz5iajxJsSRMUjscFeKcrU=;
        h=From:To:Cc:Subject:Date:From;
        b=PO3w6IibOhFkxjwWRg11eNllWPLX+y9tkr4SttSB67beRc+cRHHjP6iRn6DM+GjEO
         LqZ231z1+9KaOUORitebZ9DIzR9SKVRDBBR0jtNUFGi5h63+M5rBy98/POd8TLLtS3
         NTVaCYeYvZuUJZepDmruo50QV171HfQdTa6YWwyHlANv5Je5F83Qg+DGBOUPdLTxfw
         2mnMF3WBPXQME0RqhoBXP6i8Z2KhhfC5om++R9GdXgxPvfNZgZGSsQWRDzKbxaFKdc
         og88xysv/VLcUuQawRm44GeREezN3dabsxpOuumGmDa6p5EcZ9xC4scKrVM9O+bhqB
         EFSvwK9nOcVJg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2F6B6A0057;
        Thu, 31 Oct 2019 11:00:59 +0000 (UTC)
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
Subject: [PATCH net v2 00/10] net: stmmac: Fixes for -net
Date:   Thu, 31 Oct 2019 12:00:38 +0100
Message-Id: <cover.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc fixes for stmmac.

Patch 1/10, corrects a sparse warning reported by kbuild.

Patch 2/10 and 3/10, use the correct variable type for bitrev32() calls.

Patch 4/10, fixes the random failures the we were seing when running selftests.
This commit was re-worded because the old commit log no longer applied so we
didn't add the history log to the commit. So far, no selftests failures were
seen with the new re-worked commit.

Patch 5/10, prevents a crash that can occur when receiving AVB packets and with
SPH feature enabled on XGMAC.

Patch 6/10, fixes the correct settings for CBS on XGMAC.

Patch 7/10, corrects the interpretation of AVB feature on XGMAC.

Patch 8/10, disables Flow Control for AVB enabled queues on XGMAC.

Patch 9/10, disables MMC interrupts on XGMAC, preventing a storm of interrupts.

Patch 10/10, was added in this version and it fixes the incorrect number of
packets that were being passed to NAPI.

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

Jose Abreu (10):
  net: stmmac: Fix sparse warning
  net: stmmac: gmac4: bitrev32 returns u32
  net: stmmac: xgmac: bitrev32 returns u32
  net: stmmac: selftests: Prevent false positives in filter tests
  net: stmmac: xgmac: Only get SPH header len if available
  net: stmmac: xgmac: Fix TSA selection
  net: stmmac: xgmac: Fix AV Feature detection
  net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in
    AV
  net: stmmac: xgmac: Disable MMC interrupts by default
  net: stmmac: Fix the packet count in stmmac_rx()

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   5 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 134 +++++++++++++++------
 8 files changed, 115 insertions(+), 53 deletions(-)

-- 
2.7.4

