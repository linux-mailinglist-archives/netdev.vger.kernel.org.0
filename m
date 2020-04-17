Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABFA1AE500
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgDQSmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:42:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:56864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbgDQSmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:54 -0400
IronPort-SDR: BsUVu9f0NFrgRmVXO4rU5IcqQ6Ijxw4ZlFftTeDAs1/ECatgLrsoNgkUjrMBeF8OC9DHaRRb8F
 JUIZPbZkIS4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:52 -0700
IronPort-SDR: Wni5I8RBn1vB9LFAMEjd3cFcm8VyaF4Jwsp/cMehEJqUDshv5aMoQ3HlmGsuH3CSsKO+FP3men
 DqjD6EECjqJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294356"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/14] igc: Add GSO partial support
Date:   Fri, 17 Apr 2020 11:42:38 -0700
Message-Id: <20200417184251.1962762-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Partial generic segmentation offload is a hybrid between TSO and GSO.
What is effectively does is take advantage of certain traits of TCP and
tunnels so that instead of having to rewrite the packet headers for each
segment only in the inner-most transport header and possible the outer-most
network header need to be updated.
This allows devices that do not support tunnel offload or tunnels
offloads with checksum to still make use of segmentation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 69fa1ce1f927..46ab035c2032 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4727,6 +4727,16 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;
 
+#define IGC_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
+				  NETIF_F_GSO_GRE_CSUM | \
+				  NETIF_F_GSO_IPXIP4 | \
+				  NETIF_F_GSO_IPXIP6 | \
+				  NETIF_F_GSO_UDP_TUNNEL | \
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
+
+	netdev->gso_partial_features = IGC_GSO_PARTIAL_FEATURES;
+	netdev->features |= NETIF_F_GSO_PARTIAL | IGC_GSO_PARTIAL_FEATURES;
+
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
 	if (err)
-- 
2.25.2

