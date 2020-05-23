Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F2B1DF444
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387562AbgEWCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:37984 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387540AbgEWCvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:13 -0400
IronPort-SDR: izUY7hYcYhubNemwmW7pp29sAeqoBKSAjHDhJiY9GzfS6ZZxt/y08I08WgxXA8SH4vAhIweUqr
 YkOP5Ff64jTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:12 -0700
IronPort-SDR: cKsAKHyJgfZEbdKOltAUCdUsubUYahyU5Omk2WcFYGWDk10PkVOjY8yhfdS5BtYBm35Y3Y4kdW
 IDITFcTQIs9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291069"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/17] igc: Fix NFC rule overwrite cases
Date:   Fri, 22 May 2020 19:50:56 -0700
Message-Id: <20200523025109.3313635-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

When the 'loc' argument is passed in ethtool, the input rule overwrites
any rule present in that location. In this situation we must disable the
old rule otherwise it is left enabled in hardware. This patch fixes
the issue by always calling igc_disable_nfc_rule() when deleting the
old rule, no matter the value of 'input' argument.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index decd29fbfbe2..f01a7ec0c1c2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1270,8 +1270,7 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 
 	/* if there is an old rule occupying our place remove it */
 	if (rule && rule->location == location) {
-		if (!input)
-			err = igc_disable_nfc_rule(adapter, rule);
+		err = igc_disable_nfc_rule(adapter, rule);
 
 		hlist_del(&rule->nfc_node);
 		kfree(rule);
-- 
2.26.2

