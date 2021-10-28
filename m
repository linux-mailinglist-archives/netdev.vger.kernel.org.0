Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72E543E803
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhJ1SLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:46220 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhJ1SLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427783"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427783"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849089"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 8/9] ice: Fix clang -Wimplicit-fallthrough in ice_pull_qvec_from_rc()
Date:   Thu, 28 Oct 2021 11:06:58 -0700
Message-Id: <20211028180659.218912-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Clang warns:

drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
        default:
        ^
drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: note: insert 'break;' to avoid fall-through
        default:
        ^
        break;
1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1482
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 77dceab9fbbe..159c52b9b9d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1983,6 +1983,7 @@ static struct ice_q_vector *ice_pull_qvec_from_rc(struct ice_ring_container *rc)
 	case ICE_TX_CONTAINER:
 		if (rc->tx_ring)
 			return rc->tx_ring->q_vector;
+		break;
 	default:
 		break;
 	}
-- 
2.31.1

