Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA74C3BCC4A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhGFLSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhGFLSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7591661C78;
        Tue,  6 Jul 2021 11:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570160;
        bh=2jpKFm/eHXDLASWunnrUcyht/8Lx+mOSqFZbJoYKCbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM765qP4lU9scrKUWxG/lI2sHsjN2pkntSh99PCJXWGKJlFGfdVzG4W+2FZDPwKLE
         bC0TCw9TJHNNg8kGdrIyvBIaPQSu4hzchHnRd92QLzJg5pGVqmIe0kQsj0Z2ZBFAYV
         JD2aeubVxXEG8K3FxhEAmMk1fuAL6+9gTaoHUuhmjq5TVLSjLsBheuUTktPaIYwDP5
         fXPcuC8Qv8PkNMJ9uZ+LabbIjUt+HwxoDtxLO2yeYy2cAaUdeftSEBRhBm0OE6zMEB
         e7qnAYvp0wITi4dn8MP+uDzI9GZifCgYChN0vtcmHfltXyG4/cRZfOtY9dFOAd7bIl
         jL7gJbFiRkWiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 081/189] ice: fix clang warning regarding deadcode.DeadStores
Date:   Tue,  6 Jul 2021 07:12:21 -0400
Message-Id: <20210706111409.2058071-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 7e94090ae13e1ae5fe8bd3a9cd08136260bb7039 ]

clang generates deadcode.DeadStores warnings when a variable
is used to read a value, but then that value isn't used later
in the code. Fix this warning.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 99301ad95290..1f30f24648d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3462,13 +3462,9 @@ static int
 ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		    struct ice_ring_container *rc)
 {
-	struct ice_pf *pf;
-
 	if (!rc->ring)
 		return -EINVAL;
 
-	pf = rc->ring->vsi->back;
-
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
@@ -3480,7 +3476,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(pf), "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", c_type);
 		return -EINVAL;
 	}
 
-- 
2.30.2

