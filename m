Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF55483B2B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiADDse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiADDse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:48:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF11C061761;
        Mon,  3 Jan 2022 19:48:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFF58B81097;
        Tue,  4 Jan 2022 03:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C52C36AED;
        Tue,  4 Jan 2022 03:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641268111;
        bh=5LCZIuAEU9VEEYcUacketTtZ45/TX/jS7+iR46o4+b4=;
        h=From:To:Cc:Subject:Date:From;
        b=hBLX91dPaJ5m7coXPc0vYUzoTQvDz5OEqG/JGstFAz8r5oQtT4ldw6W0A4ub81Ls3
         /HxkH731k2CDr55eQBRAI1sFwd2Frx4L/2nFKPlxDM2Le7fWDWymrymYG5Fg1PYnNx
         is0owU/UfAz7GZcmFWj6M6bzEDB/lRTwzTxIwXQ7l/iEi/I4++uhjKfAPzItwDLelB
         K/rU03Y6gQeoCXzvn5oIGhyaJjmr0Rt3CrM47cOoB6z5T/DOEKQvZzCL5e4+AAvkj9
         6ld3TIIAh/adL3LyeIm3nKoilUgZJ2b4sXQSZ0yybzNcOEVRwmpxTiaDlwDHVYwRfB
         P8CyNdYhFuJaA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, leon@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next] net: fixup build after bpf header changes
Date:   Mon,  3 Jan 2022 19:48:27 -0800
Message-Id: <20220104034827.1564167-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent bpf-next merge brought in header changes which uncovered
includes missing in net-next which were not present in bpf-next.
Build problems happen only on less-popular arches like hppa,
sparc, alpha etc.

I could repro the build problem with ice but not the mlx5 problem
Abdul was reporting. mlx5 does look like it should include filter.h,
anyway.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Fixes: e63a02348958 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next")
Link: https://lore.kernel.org/all/7c03768d-d948-c935-a7ab-b1f963ac7eed@linux.vnet.ibm.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: intel-wired-lan@lists.osuosl.org
CC: linux-rdma@vger.kernel.org
CC: bpf@vger.kernel.org
---
 drivers/net/ethernet/intel/ice/ice_nvm.c          | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index cd739a2c64e8..4eb0599714f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018, Intel Corporation. */
 
+#include <linux/vmalloc.h>
+
 #include "ice_common.h"
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index efcf9d30b131..31c911182498 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -37,6 +37,7 @@
 #include <net/geneve.h>
 #include <linux/bpf.h>
 #include <linux/if_bridge.h>
+#include <linux/filter.h>
 #include <net/page_pool.h>
 #include <net/xdp_sock_drv.h>
 #include "eswitch.h"
-- 
2.31.1

