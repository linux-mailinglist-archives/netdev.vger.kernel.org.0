Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30BBF8E9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfIZSL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:11:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:22811 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:11:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:11:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="364882907"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 11:11:27 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v3 5/7] igb: reject unsupported external timestamp flags
Date:   Thu, 26 Sep 2019 11:11:07 -0700
Message-Id: <20190926181109.4871-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
In-Reply-To: <20190926181109.4871-1-jacob.e.keller@intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the igb PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 4997963149f6..0bce3e0f1af0 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -521,6 +521,12 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE))
+			return -EOPNOTSUPP;
+
 		if (on) {
 			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
 					   rq->extts.index);
-- 
2.23.0.245.gf157bbb9169d

