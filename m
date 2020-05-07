Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB171C8E42
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEGOV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:21:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54949 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgEGOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:21:28 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jWhOn-00036d-BO; Thu, 07 May 2020 14:21:17 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Raanan Avargil <raanan.avargil@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] e1000e: Disable TSO for buffer overrun workaround
Date:   Thu,  7 May 2020 22:21:07 +0800
Message-Id: <20200507142108.13090-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b10effb92e27 ("e1000e: fix buffer overrun while the I219 is
processing DMA transactions") imposes roughly 30% performance penalty.

The commit log states that "Disabling TSO eliminates performance loss
for TCP traffic without a noticeable impact on CPU performance", so
let's disable TSO by default to regain the loss.

Fixes: b10effb92e27 ("e1000e: fix buffer overrun while the I219 is processing DMA transactions")
BugLink: https://bugs.launchpad.net/bugs/1802691
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 177c6da80c57..9b5509149578 100644
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
2.17.1

