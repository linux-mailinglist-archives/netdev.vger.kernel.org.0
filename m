Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593D1AB731
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389461AbfIFLeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:34:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38045 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388752AbfIFLeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:34:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6CV2-0006NC-VZ; Fri, 06 Sep 2019 11:33:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     gJeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ixgbevf: make array api static const, makes object smaller
Date:   Fri,  6 Sep 2019 12:33:56 +0100
Message-Id: <20190906113356.9985-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array api on the stack but instead make it
static const. Makes the object code smaller by 58 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  82969	   9763	    256	  92988	  16b3c	ixgbevf/ixgbevf_main.o

After:
   text	   data	    bss	    dec	    hex	filename
  82815	   9859	    256	  92930	  16b02	ixgbevf/ixgbevf_main.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 8c011d4ce7a9..46c8e2501084 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2261,12 +2261,14 @@ static void ixgbevf_init_last_counter_stats(struct ixgbevf_adapter *adapter)
 static void ixgbevf_negotiate_api(struct ixgbevf_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	int api[] = { ixgbe_mbox_api_14,
-		      ixgbe_mbox_api_13,
-		      ixgbe_mbox_api_12,
-		      ixgbe_mbox_api_11,
-		      ixgbe_mbox_api_10,
-		      ixgbe_mbox_api_unknown };
+	static const int api[] = {
+		ixgbe_mbox_api_14,
+		ixgbe_mbox_api_13,
+		ixgbe_mbox_api_12,
+		ixgbe_mbox_api_11,
+		ixgbe_mbox_api_10,
+		ixgbe_mbox_api_unknown
+	};
 	int err, idx = 0;
 
 	spin_lock_bh(&adapter->mbx_lock);
-- 
2.20.1

