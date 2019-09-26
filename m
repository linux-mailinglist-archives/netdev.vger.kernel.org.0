Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A0DBF8EC
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfIZSLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:11:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:22811 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:11:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="364882919"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 11:11:29 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [net-next v3 7/7] renesas: reject unsupported external timestamp flags
Date:   Thu, 26 Sep 2019 11:11:09 -0700
Message-Id: <20190926181109.4871-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
In-Reply-To: <20190926181109.4871-1-jacob.e.keller@intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the renesas PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/renesas/ravb_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 638f1fc2166f..666dbee48097 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -182,6 +182,12 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
 
+	/* Reject requests with unsupported flags */
+	if (req->flags & ~(PTP_ENABLE_FEATURE |
+			   PTP_RISING_EDGE |
+			   PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	if (req->index)
 		return -EINVAL;
 
-- 
2.23.0.245.gf157bbb9169d

