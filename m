Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5418333E548
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhCQBCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhCQA7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0CA64F94;
        Wed, 17 Mar 2021 00:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942795;
        bh=Bsb9GxR6IJOpaaWV/R4ZI/vtusZilELj2sF9xj+J20Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbBhkDZoovc6fhvBHpTiwxJNTzD1gS3FgQvEd7wwfdb2+O9FfKzwcB9irBxc/Z5VL
         0e+fpnGxvGb69YsJ2a6c0AJDkbzUIpJwc+BcWCvs3oEtQEX1yZWQcTt+MOyP5AAsPu
         NjKBLxSeyZFvZ/0yze8mUzKKlr7VQpdCIviPFJqGoaeUIqS3JM1BA1oUH9R9ebsG8u
         VJYJOutMpnaS+dT8WM0Hp3sxEDL79gzS3HlwKJ7omFlK54I3xYK+mE4uMH8fgthmO3
         yROEjIpvfUwlPO/DBBRTHdl0cGbl4+560MkNAaKpttsD4E9zy42h8gq/VCJ8H542Ko
         FU2LfpY91wHqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/16] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Tue, 16 Mar 2021 20:59:36 -0400
Message-Id: <20210317005948.727250-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005948.727250-1-sashal@kernel.org>
References: <20210317005948.727250-1-sashal@kernel.org>
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
index 4c729faeb713..343fa79efe3e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8675,8 +8675,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
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

