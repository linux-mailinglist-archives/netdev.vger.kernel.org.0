Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3798FBF8E3
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfIZSLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:11:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:22811 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:11:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:11:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="364882891"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 11:11:24 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Brandon Streiff <brandon.streiff@ni.com>
Subject: [net-next v3 3/7] mv88e6xxx: reject unsupported external timestamp flags
Date:   Thu, 26 Sep 2019 11:11:05 -0700
Message-Id: <20190926181109.4871-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.23.0.245.gf157bbb9169d
In-Reply-To: <20190926181109.4871-1-jacob.e.keller@intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the mv88e6xxx PTP support to explicitly reject any future flags that
get added to the external timestamp request ioctl.

In order to maintain currently functioning code, this patch accepts all
three current flags. This is because the PTP_RISING_EDGE and
PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
have interpreted them slightly differently.

Cc: Brandon Streiff <brandon.streiff@ni.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 073cbd0bb91b..076e622a64d6 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -273,6 +273,12 @@ static int mv88e6352_ptp_enable_extts(struct mv88e6xxx_chip *chip,
 	int pin;
 	int err;
 
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
 	pin = ptp_find_pin(chip->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
 
 	if (pin < 0)
-- 
2.23.0.245.gf157bbb9169d

