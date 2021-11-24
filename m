Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3525A45B755
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKXJZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:25:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:54155 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhKXJZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:25:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232735576"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232735576"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:21:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674799246"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 01:21:05 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for cleaning Tx
Date:   Wed, 24 Nov 2021 17:18:21 +0800
Message-Id: <20211124091821.3916046-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211124091821.3916046-1-boon.leong.ong@intel.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets tx-pkt-count and in case where there are invalid Tx frame,
the complete_tx_only_all() process polls indefinitely. So, this patch
adds a time-out mechanism into the process so that the application
can terminate automatically after it retries 3*polling interval duration.

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 136383         1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         35             245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      957            7011

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 0              1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         0              245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      1              7012

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 0              1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         0              245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      1              7013

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 0              1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         0              245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      1              7014

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 0              1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         0              245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      0              7014

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           0.00
rx                 0              0
tx                 0              1000000
rx dropped         0              0
rx invalid         0              0
tx invalid         0              245
rx queue full      0              0
fill ring empty    0              1
tx ring empty      0              7014

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 61d4063f11a..9c3311329ec 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1410,6 +1410,7 @@ static inline int get_batch_size(int pkt_cnt)
 
 static void complete_tx_only_all(void)
 {
+	u32 retries = 3;
 	bool pending;
 	int i;
 
@@ -1421,7 +1422,8 @@ static void complete_tx_only_all(void)
 				pending = !!xsks[i]->outstanding_tx;
 			}
 		}
-	} while (pending);
+		sleep(opt_interval);
+	} while (pending && retries-- > 0);
 }
 
 static void tx_only_all(void)
-- 
2.25.1

