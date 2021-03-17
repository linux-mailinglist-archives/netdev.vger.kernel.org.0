Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58D33E484
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCQBAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhCQA6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A1564FC9;
        Wed, 17 Mar 2021 00:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942692;
        bh=ryleGtj8EIXRDb+NrHQj52DR2z0e0CXCODhsYyXnwFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDNMvEg2ngOef3yfyqBWzHk8Hi9MGLePo/yLVSobYjokFo/8KnmRmCQuKaIS0cygG
         4e4ydkWBdYmn1qI6fueTZKRHvAFJBvOVjq7YXRQDqSuJ1+/uoTjVIhG/gknnK7T+Fd
         lRDCdM95X6hlN8IeCCmDIRfSEzQolhr0MQ9XgkFL3IfFOgLD2IHKA/iESowCl/RFHT
         E6lPyP/EEjCD4OBVnm0WkCS2TWHEk7oUB74rLYMlzHSUBkYUeCw+oLBpiNyoM41BJH
         7JXPzeJhnvLGBeYFrodGlQErH0gkR1UfzLI93tHp5tUv0gU2gl5eEoVeU62cpdYTsf
         gdrZJi2ju5ulg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/37] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Tue, 16 Mar 2021 20:57:32 -0400
Message-Id: <20210317005802.725825-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 7a766381634da19fc837619b0a34590498d9d29a ]

When ixgbe_fdir_write_perfect_filter_82599() fails,
input allocated by kzalloc() has not been freed,
which leads to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f60554064403..1b8e70585c44 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9595,8 +9595,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
 	ixgbe_atr_compute_perfect_hash_82599(&input->filter, mask);
 	err = ixgbe_fdir_write_perfect_filter_82599(hw, &input->filter,
 						    input->sw_idx, queue);
-	if (!err)
-		ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
+	if (err)
+		goto err_out_w_lock;
+
+	ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
 	spin_unlock(&adapter->fdir_perfect_lock);
 
 	if ((uhtid != 0x800) && (adapter->jump_tables[uhtid]))
-- 
2.30.1

