Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4716E1DF43D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbgEWCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387589AbgEWCvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:19 -0400
IronPort-SDR: BkAtn/JZWT9r616gHhLBHjZir3pw57wtODlfY+Dgl8xlNncbKnV0ezloGtKZ8/6TmR3LWqQqto
 gsLadY9BEb9w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:14 -0700
IronPort-SDR: RxtJ/ZqCuFLySEqyekGjKQd4DI1X9VvuoK+mCDVKWK9+hmF/2+wizWg/ZmdpMbLQcFuSJSMXOB
 ygI0WpJhkcwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291137"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        stable <stable@vger.kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/17] e1000e: Disable TSO for buffer overrun workaround
Date:   Fri, 22 May 2020 19:51:08 -0700
Message-Id: <20200523025109.3313635-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

Commit b10effb92e27 ("e1000e: fix buffer overrun while the I219 is
processing DMA transactions") imposes roughly 30% performance penalty.

The commit log states that "Disabling TSO eliminates performance loss
for TCP traffic without a noticeable impact on CPU performance", so
let's disable TSO by default to regain the loss.

CC: stable <stable@vger.kernel.org>
Fixes: b10effb92e27 ("e1000e: fix buffer overrun while the I219 is processing DMA transactions")
BugLink: https://bugs.launchpad.net/bugs/1802691
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e0b074820b47..66609cf689de 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5294,6 +5294,10 @@ static void e1000_watchdog_task(struct work_struct *work)
 					/* oops */
 					break;
 				}
+				if (hw->mac.type == e1000_pch_spt) {
+					netdev->features &= ~NETIF_F_TSO;
+					netdev->features &= ~NETIF_F_TSO6;
+				}
 			}
 
 			/* enable transmits in the hardware, need to do this
-- 
2.26.2

