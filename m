Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07CE203778
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgFVNHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:07:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:14869 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgFVNHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:07:37 -0400
IronPort-SDR: GE6NBm1YbXTr8oQZMM94KM1T61oAvEI9eJDsUD9dM4qyPk4Krr0Yc4Uis0zcELktMpVAuVnOAx
 F5mOrz4SmhBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="123400584"
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="123400584"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 06:07:34 -0700
IronPort-SDR: nTE/JJ46Xst4SKPlqla4lLoWBObgoRIBYaRcPXGqIQPe61w2TTAhtYDu4q/UUsuJ9VjugwhQAv
 7/69NOiUbAIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="318774357"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.8])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 06:07:32 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH net-next 1/3] i40e: add xdp ring statistics to vsi stats
Date:   Mon, 22 Jun 2020 12:46:22 +0000
Message-Id: <20200622124624.18847-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this, only rx and tx ring statistics were accounted for.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5d807c8004f8..13aef0e51c24 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -811,6 +811,25 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_p += packets;
 		rx_buf += p->rx_stats.alloc_buff_failed;
 		rx_page += p->rx_stats.alloc_page_failed;
+
+		if (i40e_enabled_xdp_vsi(vsi)) {
+			/* locate xdp ring */
+			p = READ_ONCE(vsi->xdp_rings[q]);
+			if (!p)
+				continue;
+
+			do {
+				start = u64_stats_fetch_begin_irq(&p->syncp);
+				packets = p->stats.packets;
+				bytes = p->stats.bytes;
+			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+			tx_b += bytes;
+			tx_p += packets;
+			tx_restart += p->tx_stats.restart_queue;
+			tx_busy += p->tx_stats.tx_busy;
+			tx_linearize += p->tx_stats.tx_linearize;
+			tx_force_wb += p->tx_stats.tx_force_wb;
+		}
 	}
 	rcu_read_unlock();
 	vsi->tx_restart = tx_restart;
-- 
2.17.1

