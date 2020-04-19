Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD991AFDCB
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDSTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:45114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgDSTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:34 -0400
IronPort-SDR: BX5VXGLdEgdvWfoHZRdT98iWVcUy854/AkAQDQHqp75MJs0lth3gnR5G66JiHkyOnBog7kap7w
 7MZIc2lr05Dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:33 -0700
IronPort-SDR: eCGx7qVgOEEzDSNhtM3k/6oTgzNKK4MmIWHPoXYdMGL0SZ9LdUZOfVOnTY1Do59OW0qUo2ylW4
 G/Ul/CEipFsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034404"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/14] igc: Check unsupported flag in igc_add_mac_filter()
Date:   Sun, 19 Apr 2020 12:51:21 -0700
Message-Id: <20200419195131.1068144-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The IGC_MAC_STATE_SRC_ADDR flags is not supported by igc_add_mac_
filter() so this patch adds a check for it and returns -ENOTSUPP
in case it is set.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ade460f08ed1..66b3a689bb05 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2200,6 +2200,8 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 
 	if (is_zero_ether_addr(addr))
 		return -EINVAL;
+	if (flags & IGC_MAC_STATE_SRC_ADDR)
+		return -ENOTSUPP;
 
 	/* Search for the first empty entry in the MAC table.
 	 * Do not touch entries at the end of the table reserved for the VF MAC
-- 
2.25.2

