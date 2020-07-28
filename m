Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66573231231
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbgG1TI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:08:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:43607 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732584AbgG1TIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:08:55 -0400
IronPort-SDR: kcVacKA/21zmBhcby8xmpLZ17xCUfJ7ACMxTe9lHmhC/VosG3v2JZ7kuTaZoy7YYTwtbrkhWsT
 o5HpCmIth+UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="236163826"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="236163826"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 12:08:50 -0700
IronPort-SDR: NbTCAhMU6ctJ/Dku2W8Jxlc8lk6hesD0WJ54RGglZ5HdTAqZTJeduvDYzGzxpQH01d1MNfRRZu
 sBTvINkw8MRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="490006241"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jul 2020 12:08:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 5/6] i40e, xsk: increase budget for AF_XDP path
Date:   Tue, 28 Jul 2020 12:08:41 -0700
Message-Id: <20200728190842.1284145-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The napi_budget, meaning the number of received packets that are
allowed to be processed for each napi invocation, takes into
consideration that each received packet is aimed for the kernel
networking stack.

That is not the case for the AF_XDP receive path, where the cost of
each packet is significantly less. Therefore, this commit disregards
the napi budget and increases it to 256. Processing 256 packets
targeted for AF_XDP is still less work than 64 (napi budget) packets
going to the kernel networking stack.

The performance for the rx_drop scenario is up 7%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1f2dd591dbf1..99f4afdc403d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -265,6 +265,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
 	rx_ring->next_to_clean = ntc;
 }
 
+#define I40E_XSK_CLEAN_RX_BUDGET 256U
+
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
@@ -280,7 +282,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	bool failure = false;
 	struct sk_buff *skb;
 
-	while (likely(total_rx_packets < (unsigned int)budget)) {
+	while (likely(total_rx_packets < I40E_XSK_CLEAN_RX_BUDGET)) {
 		union i40e_rx_desc *rx_desc;
 		struct xdp_buff **bi;
 		unsigned int size;
-- 
2.26.2

