Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F144A8459
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350642AbiBCM6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:58:17 -0500
Received: from mga12.intel.com ([192.55.52.136]:25537 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238168AbiBCM6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643893095; x=1675429095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xFNr9LXlw/fHixJarYDrR4gqfTJ3LVkRhIllicB9G3U=;
  b=CI2w1UA65IMSsTqknYVqd2XYwCjtPUMNu9nNGvDGp6HPVhX43ELuPB0U
   ZSPNqVOeAlXRFEhy0JoJw/+jRgpwi+U06vCG7n+kbQ1KN7f4nlavsKRU4
   74hyWi7lWG3ThCsEeI98LN+OnpJ+8+aXco9mD8P4ryCjkDRda/tNhi/fm
   gTK/mJHgYE5e/I7AVKz3ZK1CGV72obFEelQKJzzYOwjdGjxMq3rOFtrWN
   +KjyVS6BBRwX3a/ejWGpPsmdP36TGwbPLS1X4NFWHCwefMafQ+CZ7OuZk
   w0aC3sZnA5JfNcazYrJxuOVQqEmnO90UgUxFVzjaRdNKQKkwX9X8EnH3s
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228104450"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="228104450"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 04:58:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="627426703"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2022 04:58:13 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Maurice Baijens <maurice.baijens@ellips.com>
Subject: [PATCH intel-net] ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()
Date:   Thu,  3 Feb 2022 13:58:03 +0100
Message-Id: <20220203125803.19407-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if
netif is not OK") addressed the ring transient state when
MEM_TYPE_XSK_BUFF_POOL was being configured which in turn caused the
interface to through down/up. Maurice reported that when carrier is not
ok and xsk_pool is present on ring pair, ksoftirqd will consume 100% CPU
cycles due to the constant NAPI rescheduling as ixgbe_poll() states that
there is still some work to be done.

To fix this, do not set work_done to false for a !netif_carrier_ok().

Fixes: c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if netif is not OK")
Reported-by: Maurice Baijens <maurice.baijens@ellips.com>
Tested-by: Maurice Baijens <maurice.baijens@ellips.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index b3fd8e5cd85b..6a5e9cf6b5da 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	u32 cmd_type;
 
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
-		    !netif_carrier_ok(xdp_ring->netdev)) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done = false;
 			break;
 		}
 
+		if (!netif_carrier_ok(xdp_ring->netdev))
+			break;
+
 		if (!xsk_tx_peek_desc(pool, &desc))
 			break;
 
-- 
2.33.1

