Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E234C561
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2H5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:57:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:45546 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhC2H4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 03:56:38 -0400
IronPort-SDR: 204H9fM/sa1Hx08e6eWxIN5rufE+umgHijetPnNxs4aNCHaboqvKbXIcLFNFl4lxIeXsXB1R5f
 4BvciCCMiHLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="170902063"
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="170902063"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 00:56:37 -0700
IronPort-SDR: ZFyBHCYC06SwwoqQpsRe3C6SngPxBjApGKfIFwyAVOUAppYzUZaUydiczd9LUIYqCg84kg2TnR
 DQ4VenUd49eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="410960207"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga008.fm.intel.com with ESMTP; 29 Mar 2021 00:56:34 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net 1/1] xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model
Date:   Mon, 29 Mar 2021 16:00:39 +0800
Message-Id: <20210329080039.32753-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_return_frame() may be called outside of NAPI context to return
xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
napi_direct = false. For page_pool memory model, __xdp_return() calls
xdp_return_frame_no_direct() unconditionally and below false negative
kernel BUG throw happened under preempt-rt build:

[  430.450355] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/3884
[  430.451678] caller is __xdp_return+0x1ff/0x2e0
[  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E     5.12.0-rc2+ #45

So, this patch fixes the issue by adding "if (napi_direct)" condition
to skip calling xdp_return_frame_no_direct() if napi_direct = false.

Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_return_frame")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..4eaa28972af2 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		napi_direct &= !xdp_return_frame_no_direct();
+		if (napi_direct)
+			napi_direct &= !xdp_return_frame_no_direct();
 		page_pool_put_full_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
-- 
2.25.1

