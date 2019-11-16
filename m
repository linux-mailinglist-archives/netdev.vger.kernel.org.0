Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC105FEF34
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbfKPP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731533AbfKPPzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:55:09 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0ABB2186D;
        Sat, 16 Nov 2019 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919709;
        bh=U/6tRCUAgN7vLtq1CMV91hKOfrocRssLaPKmD5mtqa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwFeVxkzGTf2iOygAThV7TjwKE47Zg+tH7tRE8RO+4muIFsqRhSiJOQ/qCLXKddo2
         f6/QWV+pAdicqENlSHTqwZyKtb5ZENoaluDUW2VjKHBB2EU+VKNI5qgWaWjZAo2/Mb
         STmj8i0riVYD3n2A4MzmtKmdQud9PwJhRKmO4CGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 53/77] igb: shorten maximum PHC timecounter update interval
Date:   Sat, 16 Nov 2019 10:53:15 -0500
Message-Id: <20191116155339.11909-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 094bf4d0e9657f6ea1ee3d7e07ce3970796949ce ]

The timecounter needs to be updated at least once per ~550 seconds in
order to avoid a 40-bit SYSTIM timestamp to be misinterpreted as an old
timestamp.

Since commit 500462a9d ("timers: Switch to a non-cascading wheel"),
scheduling of delayed work seems to be less accurate and a requested
delay of 540 seconds may actually be longer than 550 seconds. Shorten
the delay to 480 seconds to be sure the timecounter is updated in time.

This fixes an issue with HW timestamps on 82580/I350/I354 being off by
~1100 seconds for few seconds every ~9 minutes.

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index c44df87c38de2..5e65d8a78c3ed 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -65,9 +65,15 @@
  *
  * The 40 bit 82580 SYSTIM overflows every
  *   2^40 * 10^-9 /  60  = 18.3 minutes.
+ *
+ * SYSTIM is converted to real time using a timecounter. As
+ * timecounter_cyc2time() allows old timestamps, the timecounter
+ * needs to be updated at least once per half of the SYSTIM interval.
+ * Scheduling of delayed work is not very accurate, so we aim for 8
+ * minutes to be sure the actual interval is shorter than 9.16 minutes.
  */
 
-#define IGB_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 9)
+#define IGB_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 8)
 #define IGB_PTP_TX_TIMEOUT		(HZ * 15)
 #define INCPERIOD_82576			(1 << E1000_TIMINCA_16NS_SHIFT)
 #define INCVALUE_82576_MASK		((1 << E1000_TIMINCA_16NS_SHIFT) - 1)
-- 
2.20.1

