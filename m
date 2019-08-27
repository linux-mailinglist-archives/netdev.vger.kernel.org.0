Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B9D9F051
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfH0QhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:37:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:10269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfH0QhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="187959999"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Aug 2019 09:37:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id DDDCDBD; Tue, 27 Aug 2019 19:37:17 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider use
Date:   Tue, 27 Aug 2019 19:37:17 +0300
Message-Id: <20190827163717.44101-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are users already and will be more of BITS_TO_BYTES() macro.
Move it to bitops.h for wider use.

In the case of ocfs2 the replacement is identical.

As for bnx2x, there are two places where floor version is used.
In the first case to calculate the amount of structures that can fit
one memory page. In this case obviously the ceiling variant is correct and
original code might have a potential bug, if amount of bits % 8 is not 0.
In the second case the macro is used to calculate bytes transmitted in one
microsecond. This will work for all speeds which is multiply of 1Gbps without
any change, for the rest new code will give ceiling value, for instance 100Mbps
will give 13 bytes, while old code gives 12 bytes and the arithmetically
correct one is 12.5 bytes. Further the value is used to setup timer threshold
which in any case has its own margins due to certain resolution. I don't see
here an issue with slightly shifting thresholds for low speed connections, the
card is supposed to utilize highest available rate, which is usually 10Gbps.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
- described bnx2x cases in the commit message
- appended Rb (for ocfs2)

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
 fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
 include/linux/bitops.h                           | 1 +
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
index 066765fbef06..0a59a09ef82f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
@@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
  *    possible, the driver should only write the valid vnics into the internal
  *    ram according to the appropriate port mode.
  */
-#define BITS_TO_BYTES(x) ((x)/8)
 
 /* CMNG constants, as derived from system spec calculations */
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index aaf24548b02a..0463dce65bb2 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -688,10 +688,6 @@ struct dlm_begin_reco
 	__be32 pad2;
 };
 
-
-#define BITS_PER_BYTE 8
-#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
-
 struct dlm_query_join_request
 {
 	u8 node_idx;
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cf074bce3eb3..79d80f5ddf7b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -5,6 +5,7 @@
 #include <linux/bits.h>
 
 #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
 
 extern unsigned int __sw_hweight8(unsigned int w);
-- 
2.23.0.rc1

