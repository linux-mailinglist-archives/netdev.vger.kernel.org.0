Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6E61BFA1A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgD3Nve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgD3Nvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D67B208D5;
        Thu, 30 Apr 2020 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254691;
        bh=RihZBV2HIqeSd4Zs1oz0PgSiSUHUetLAYV3q+QRh/Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4qRjVFYPCIXGUPqfAOdhKzQiQx/fRMm6dVAC8oHb9rlmP/KVIddd1TdRhuSB3niv
         fPYfeeapfupSQVkmRAUh5YXbG4yn7n4jR3pBcOizO8fc3WQnG0s219FKJkYknetpUc
         Og3LEVrZkrO8FNi0ZaOFNfb9PiTp3V8VzlbOtPp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Beraud <julien.beraud@orolia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 42/79] net: stmmac: Fix sub-second increment
Date:   Thu, 30 Apr 2020 09:50:06 -0400
Message-Id: <20200430135043.19851-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Beraud <julien.beraud@orolia.com>

[ Upstream commit 91a2559c1dc5b0f7e1256d42b1508935e8eabfbf ]

In fine adjustement mode, which is the current default, the sub-second
    increment register is the number of nanoseconds that will be added to
    the clock when the accumulator overflows. At each clock cycle, the
    value of the addend register is added to the accumulator.
    Currently, we use 20ns = 1e09ns / 50MHz as this value whatever the
    frequency of the ptp clock actually is.
    The adjustment is then done on the addend register, only incrementing
    every X clock cycles X being the ratio between 50MHz and ptp_clock_rate
    (addend = 2^32 * 50MHz/ptp_clock_rate).
    This causes the following issues :
    - In case the frequency of the ptp clock is inferior or equal to 50MHz,
      the addend value calculation will overflow and the default
      addend value will be set to 0, causing the clock to not work at
      all. (For instance, for ptp_clock_rate = 50MHz, addend = 2^32).
    - The resolution of the timestamping clock is limited to 20ns while it
      is not needed, thus limiting the accuracy of the timestamping to
      20ns.

    Fix this by setting sub-second increment to 2e09ns / ptp_clock_rate.
    It will allow to reach the minimum possible frequency for
    ptp_clk_ref, which is 5MHz for GMII 1000Mps Full-Duplex by setting the
    sub-second-increment to a higher value. For instance, for 25MHz, it
    gives ssinc = 80ns and default_addend = 2^31.
    It will also allow to use a lower value for sub-second-increment, thus
    improving the timestamping accuracy with frequencies higher than
    100MHz, for instance, for 200MHz, ssinc = 10ns and default_addend =
    2^31.

v1->v2:
 - Remove modifications to the calculation of default addend, which broke
 compatibility with clock frequencies for which 2000000000 / ptp_clk_freq
 is not an integer.
 - Modify description according to discussions.

Signed-off-by: Julien Beraud <julien.beraud@orolia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c    | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 0201596225592..e5d9007c8090b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -26,12 +26,16 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 	unsigned long data;
 	u32 reg_value;
 
-	/* For GMAC3.x, 4.x versions, convert the ptp_clock to nano second
-	 *	formula = (1/ptp_clock) * 1000000000
-	 * where ptp_clock is 50MHz if fine method is used to update system
+	/* For GMAC3.x, 4.x versions, in "fine adjustement mode" set sub-second
+	 * increment to twice the number of nanoseconds of a clock cycle.
+	 * The calculation of the default_addend value by the caller will set it
+	 * to mid-range = 2^31 when the remainder of this division is zero,
+	 * which will make the accumulator overflow once every 2 ptp_clock
+	 * cycles, adding twice the number of nanoseconds of a clock cycle :
+	 * 2000000000ULL / ptp_clock.
 	 */
 	if (value & PTP_TCR_TSCFUPDT)
-		data = (1000000000ULL / 50000000);
+		data = (2000000000ULL / ptp_clock);
 	else
 		data = (1000000000ULL / ptp_clock);
 
-- 
2.20.1

