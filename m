Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D835E6C9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbhDMTD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhDMTD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15FD8613C7;
        Tue, 13 Apr 2021 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618340616;
        bh=024RQYE9FOwSubSEu8+U+9O/gSbth/Wav0L2yaIq/CE=;
        h=Date:From:To:Cc:Subject:From;
        b=W9GfPXo6hE3q/OpLX9wNTbZjLXShA7tzwr8wzyMijum7OMWJsbTnqTy1cypdHf8Vv
         1/hrOdrXOWrsNG6HGJqCVnB5lQ0yPbNOV6ot6SH2ryuDh4UBYITLEZgF8pV9UVR6Ur
         GksGKBQ4WSEp4zpGgNp6FVS/X9BBb4pF5l1X+DlMAM76Yougyp6xuGbodqw3xzHptb
         dIfoP6qlh2jt/oBJltDErEaHC35wDR6IiQsUpk0BOecS/j8uWgPebtD43WQfd1zJo6
         IXhzMJ5Iq5Zc5LBA6cpxkMkcaAVROZlHD62p3cMGFD6CH3EVsTrHxqqueXN2b76y3E
         fgUtf1572LoCQ==
Date:   Tue, 13 Apr 2021 14:03:45 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] ixgbe: Fix out-bounds warning in
 ixgbe_host_interface_command()
Message-ID: <20210413190345.GA304933@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.27.0

