Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD33934DC
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhE0Rdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:33:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:2483 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234529AbhE0Rdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:33:42 -0400
IronPort-SDR: j1REXI6KAWaBI1Y3lbNVoXEoD+z6uvSog2d0vUSRenyV95ZT2NZHVDWth0nHEtHJYz10EZ13UN
 eVGqgYKCAtUw==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224002846"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224002846"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 10:32:02 -0700
IronPort-SDR: gA2Yxs4X0N8AQ2mToCFF++Q+ERZXOTt1e6vcTFWsEVF8rLpG6fv1GdSi96UxXKvPIuayhUrkX4
 Tr29eC4ev6GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="547704438"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 27 May 2021 10:32:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Kees Cook <keescook@chromium.org>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 1/1] ixgbe: Fix out-bounds warning in ixgbe_host_interface_command()
Date:   Thu, 27 May 2021 10:34:24 -0700
Message-Id: <20210527173424.362456-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Replace union with a couple of pointers in order to fix the following
out-of-bounds warning:

  CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function ‘ixgbe_host_interface_command’:
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: array subscript 1 is above array bounds of ‘u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
 3729 |   bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
      |   ~~~~~~~~~~^~~~
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while referencing ‘u32arr’
 3682 |   u32 u32arr[1];
      |       ^~~~~~

This helps with the ongoing efforts to globally enable -Warray-bounds.

Link: https://github.com/KSPP/linux/issues/109
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 03ccbe6b66d2..e90b5047e695 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3678,10 +3678,8 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
 				 bool return_data)
 {
 	u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
-	union {
-		struct ixgbe_hic_hdr hdr;
-		u32 u32arr[1];
-	} *bp = buffer;
+	struct ixgbe_hic_hdr *hdr = buffer;
+	u32 *u32arr = buffer;
 	u16 buf_len, dword_len;
 	s32 status;
 	u32 bi;
@@ -3707,12 +3705,12 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
 
 	/* first pull in the header so we know the buffer length */
 	for (bi = 0; bi < dword_len; bi++) {
-		bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
-		le32_to_cpus(&bp->u32arr[bi]);
+		u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
+		le32_to_cpus(&u32arr[bi]);
 	}
 
 	/* If there is any thing in data position pull it in */
-	buf_len = bp->hdr.buf_len;
+	buf_len = hdr->buf_len;
 	if (!buf_len)
 		goto rel_out;
 
@@ -3727,8 +3725,8 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
 
 	/* Pull in the rest of the buffer (bi is where we left off) */
 	for (; bi <= dword_len; bi++) {
-		bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
-		le32_to_cpus(&bp->u32arr[bi]);
+		u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
+		le32_to_cpus(&u32arr[bi]);
 	}
 
 rel_out:
-- 
2.26.2

