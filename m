Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC9235011F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhCaNVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:21:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:41730 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235347AbhCaNUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 09:20:52 -0400
IronPort-SDR: Co7vcJdY3iZW0HR4nse/aAmEQGH4Yb+2Q7Dm8VAKsqqbjL1ukE2i+UVAKZ5W0C+1iCXu3c22p6
 4VozuV6ii5Dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="277184483"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="277184483"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 06:20:52 -0700
IronPort-SDR: XPkYDsek3QTykAZNgPrvVhgFyXkyxZa0cVvA8VCGZQMQWBKGNP5JB5vxjT7c6NjuJGqCQIlVF+
 kzSdoBGRd46A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="455482204"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2021 06:20:49 -0700
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
Subject: [PATCH net v2 1/1] xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model
Date:   Wed, 31 Mar 2021 21:25:03 +0800
Message-Id: <20210331132503.15926-1-boon.leong.ong@intel.com>
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

Changes in v2:
 - This patch fixes the issue by making xdp_return_frame_no_direct() is
   only called if napi_direct = true, as recommended for better by
   Jesper Dangaard Brouer. Thanks!

Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_return_frame")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..858276e72c68 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		napi_direct &= !xdp_return_frame_no_direct();
+		if (napi_direct && xdp_return_frame_no_direct())
+			napi_direct = false;
 		page_pool_put_full_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
-- 
2.25.1

