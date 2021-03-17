Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F3933EAAE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCQHmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCQHmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 03:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC80264F7E;
        Wed, 17 Mar 2021 07:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615966920;
        bh=EYGJXau039RZLyL38UOfqfxwXxGxY0dFocwb73Hllnk=;
        h=Date:From:To:Cc:Subject:From;
        b=opVdpcE6BozNAt187Nv5guzqHXXdZIL/CO9KsOCPP+dnYbXVBfkRio46QrzoRNN5I
         ff2B13XPhWGhGBU+y/1Mze5xfFUtQ0xX6GqdEJ9kz6C0j3Uzs/kXpX4aCQyAQ7UAQA
         +JA3gCpKajN50U1WUNyxpZQPBQo4wElcoI1WDUUJEuRv6U0CnK71rEAnCEaAGD+Mz9
         dTzMhpkf+mV+9FTbTvnGZ39gZTorw6uxRKTNzFQLmYtwDjslvjRgBe0C8C23nKT19r
         LTOcCn/Ku7OnvZ5+akmumHxLLF+H+7HYAxEy7pIW8nf+ha442kF1gbTACRyb6RFCGr
         mMRYGrWLP5APg==
Date:   Wed, 17 Mar 2021 01:41:48 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ixgbe: Fix out-of-bounds warning in
 ixgbe_host_interface_command()
Message-ID: <20210317064148.GA55123@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning by replacing the one-element
array in an anonymous union with a pointer:

  CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function ‘ixgbe_host_interface_command’:
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: array subscript 1 is above array bounds of ‘u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
 3729 |   bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
      |   ~~~~~~~~~~^~~~
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while referencing ‘u32arr’
 3682 |   u32 u32arr[1];
      |       ^~~~~~

This helps with the ongoing efforts to globally enable -Warray-bounds.

Notice that, the usual approach to fix these sorts of issues is to
replace the one-element array with a flexible-array member. However,
flexible arrays should not be used in unions. That, together with the
fact that the array notation is not being affected in any ways, is why
the pointer approach was chosen in this case.

Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 62ddb452f862..bff3dc1af702 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3679,7 +3679,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
 	u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
 	union {
 		struct ixgbe_hic_hdr hdr;
-		u32 u32arr[1];
+		u32 *u32arr;
 	} *bp = buffer;
 	u16 buf_len, dword_len;
 	s32 status;
-- 
2.27.0

