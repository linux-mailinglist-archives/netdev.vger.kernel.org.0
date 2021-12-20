Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9492847B0B3
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhLTPxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:53:12 -0500
Received: from mga17.intel.com ([192.55.52.151]:62764 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhLTPxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 10:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640015592; x=1671551592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nC6dj0eJwD1rfJcRXhiAdZ14NtyD+O21VfFsZ8MSDaU=;
  b=Vzx0TOlyWu13+IT9gx/bs5IIGivUMzF6bnUEHzLqS0axRoXImaY+fOrN
   0bu/U5XEMuY7uw3fJDB+3b4JEQVs+l7FkH1MIARKs4mLifFIBa2XtNq1Y
   uz7/PcSB5nMTLkm+rgFh7cgH2kAVelzdmeaTddXsiC78Xwv7X9rE7VnaU
   qkE+gIRr6D3LqVMFm+LpihTQVJnuVO4JRU6b0IGPygvuzcxrgLTPWd7Am
   ENpXceZ0abhfuhHocx6FCbRHE7lCGmhJAR9huU+pJLqNBaVl/RYxe0pjJ
   BxnHAUygqeMAe9WkYQgIYioa17EY+z+G89yt8h94GdTU7K5T7/HgU8AKe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="220883576"
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="220883576"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 07:53:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="507729813"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.139])
  by orsmga007.jf.intel.com with ESMTP; 20 Dec 2021 07:53:09 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     bpf@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf] xsk: Initialise xskb free_list_node
Date:   Mon, 20 Dec 2021 15:52:50 +0000
Message-Id: <20211220155250.2746-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit initialises the xskb's free_list_node when the xskb is
allocated. This prevents a potential false negative returned from a call
to list_empty for that node, such as the one introduced in commit
199d983bc015 ("xsk: Fix crash on double free in buffer pool")

In my environment this issue caused packets to not be received by
the xdpsock application if the traffic was running prior to application
launch. This happened when the first batch of packets failed the xskmap
lookup and XDP_PASS was returned from the bpf program. This action is
handled in the i40e zc driver (and others) by allocating an skbuff,
freeing the xdp_buff and adding the associated xskb to the
xsk_buff_pool's free_list if it hadn't been added already. Without this
fix, the xskb is not added to the free_list because the check to determine
if it was added already returns an invalid positive result. Later, this
caused allocation errors in the driver and the failure to receive packets.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 net/xdp/xsk_buff_pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index bc4ad48ea4f0..fd39bb660ebc 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -83,6 +83,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		xskb = &pool->heads[i];
 		xskb->pool = pool;
 		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
+		INIT_LIST_HEAD(&xskb->free_list_node);
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-- 
2.17.1

