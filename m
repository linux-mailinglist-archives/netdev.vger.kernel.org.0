Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7E6878F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfGOK7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 06:59:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:2039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbfGOK7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 06:59:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 03:59:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="169579197"
Received: from powerlab.fi.intel.com (HELO powerlab.backendnet) ([10.237.71.25])
  by orsmga003.jf.intel.com with ESMTP; 15 Jul 2019 03:59:34 -0700
From:   Artem Bityutskiy <dedekind1@gmail.com>
To:     "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] ethtool: igb: dump RR2DCDELAY register
Date:   Mon, 15 Jul 2019 13:59:33 +0300
Message-Id: <20190715105933.40924-1-dedekind1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
References: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

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

Changelog:
v2: Fixed a typo in the commentary.
v1: Initial pach version.


diff --git a/igb.c b/igb.c
index e0ccef9..cb24877 100644
--- a/igb.c
+++ b/igb.c
@@ -859,6 +859,18 @@ igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		"0x03430: TDFPC       (Tx data FIFO packet count)      0x%08X\n",
 		regs_buff[550]);
 
+	/*
+	 * Starting from kernel version 5.3 the registers dump buffer grew from
+	 * 739 4-byte words to 740 words, and word 740 contains the RR2DCDELAY
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

