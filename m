Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C5153056
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBEMGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:06:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:56042 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgBEMG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:06:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 04:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="254742602"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2020 04:06:26 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maximmi@mellanox.com
Subject: [PATCH bpf 1/3] i40e: Relax i40e_xsk_wakeup's return value when PF is busy
Date:   Wed,  5 Feb 2020 05:58:32 +0100
Message-Id: <20200205045834.56795-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
References: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return -EAGAIN instead of -ENETDOWN to provide a slightly milder
information to user space so that an application will know to retry the
syscall when __I40E_CONFIG_BUSY bit is set on pf->state.

Fixes: b3873a5be757 ("net/i40e: Fix concurrency issues between config flow and XSK")
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 42058fad6..0b7d29192 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -791,7 +791,7 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	struct i40e_ring *ring;
 
 	if (test_bit(__I40E_CONFIG_BUSY, pf->state))
-		return -ENETDOWN;
+		return -EAGAIN;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
-- 
2.20.1

