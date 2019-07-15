Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D3A683B1
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 08:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfGOGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 02:52:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:4497 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfGOGwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 02:52:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2019 23:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="157732738"
Received: from powerlab.fi.intel.com (HELO powerlab.backendnet) ([10.237.71.25])
  by orsmga007.jf.intel.com with ESMTP; 14 Jul 2019 23:52:29 -0700
From:   Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To:     "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] ethtool: igb: dump RR2DCDELAY register
Date:   Mon, 15 Jul 2019 09:52:28 +0300
Message-Id: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decode 'RR2DCDELAY' register which Linux kernel provides starting from version
5.3. The corresponding commit in the Linux kernel is:
    cd502a7f7c9c igb: add RR2DCDELAY to ethtool registers dump

The RR2DCDELAY register is present in I210 and I211 Intel Gigabit Ethernet
chips and it stands for "Read Request To Data Completion Delay". Here is how
this register is described in the I210 datasheet:

"This field captures the maximum PCIe split time in 16 ns units, which is the
maximum delay between the read request to the first data completion. This is
giving an estimation of the PCIe round trip time."

In practice, this register can be used to measure the time it takes the NIC to
read data from the host memory.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 igb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/igb.c b/igb.c
index e0ccef9..ab0896f 100644
--- a/igb.c
+++ b/igb.c
@@ -859,6 +859,18 @@ igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		"0x03430: TDFPC       (Tx data FIFO packet count)      0x%08X\n",
 		regs_buff[550]);
 
+	/*
+	 * Starting from kernel version 5.3 the registers dump buffer grew from
+	 * 739 4-byte words to 740 words, and word 740 contains the RR2DCDLAY
+	 * register.
+	 */
+	if (regs->len < 740)
+		return 0;
+
+	fprintf(stdout,
+		"0x05BF4: RR2DCDELAY  (Max. DMA read delay)            0x%08X\n",
+		regs_buff[739]);
+
 	return 0;
 }
 
-- 
2.20.1

