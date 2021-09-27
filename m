Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA334194ED
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhI0NTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234421AbhI0NTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 09:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350CE60FED;
        Mon, 27 Sep 2021 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632748655;
        bh=42QBDntERyc+aM/df+V25KL01A6wcdArOVewCg/bvEI=;
        h=From:To:Cc:Subject:Date:From;
        b=ZMT4sHluyoDMXrByXz8jEqUKG17f655yYSujAhmrAfe/ohZ+EHa4vZst23ImLwYo8
         GGqvR8GVDb2G28tEx1/b+h10WqaEsONV4nj4p9ZcNwD492uFE6vP6tgDajlr1XngWc
         O1eICLm0hWAtaDDqiW9VXwLVeLOItBaWUZ5/+9BHI/o91i+MA3gv+RuD8gLPVh7tqi
         JJ7lMbJduHH3blDAvs00GtXpFIIps8skGinxVpSbNj/eGJIjI0WL1IAOiqRpief4jG
         QQHuQd4sM3WhRQyk+prGv2e2belJYTJ60rNHoGgY+rcWk+YHQjtbsKzdDmqwENNRVb
         AoXKwGlZ54DVg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Dave Ertman <david.m.ertman@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] igc: fix PTP dependency
Date:   Mon, 27 Sep 2021 15:17:19 +0200
Message-Id: <20210927131730.1587671-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The igc driver was accidentally left out of the Kconfig rework for PTP,
it needs the same dependency as the others:

arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_tsync_interrupt':
igc_main.c:(.text+0x1b288): undefined reference to `ptp_clock_event'
arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b308): undefined reference to `ptp_clock_event'
arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b8cc): undefined reference to `ptp_clock_event'
arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':

Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/intel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index b0b6f90deb7d..ed8ea63bb172 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -335,6 +335,7 @@ config IGC
 	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
 	default n
 	depends on PCI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
 	  family of adapters.
-- 
2.29.2

