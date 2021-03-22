Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4701D34518C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhCVVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:4992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhCVVJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:35 -0400
IronPort-SDR: v3fvxF5OEMuLfyUDviOefUKwfoNZPe764NgCtEzj4Tg+uCFhz1CVPwJe3XKFJotDsWqiVlzDEE
 OXi4j4q/o+RQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423777"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423777"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:35 -0700
IronPort-SDR: JLh01sEw3vyw4Ur3m1KiqpMWghaoL+SJTZpkkVFzsBbWvWHGx6bedf1h15FlUyxCpuR7naSHAS
 1adTckBPkapg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448934"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:33 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH v3 bpf-next 17/17] selftests: xsk: Remove unused defines
Date:   Mon, 22 Mar 2021 21:58:16 +0100
Message-Id: <20210322205816.65159-18-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Remove two unused defines.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 7 +++----
 tools/testing/selftests/bpf/xdpxceiver.h | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 084ba052fa89..0a7c5a8ca585 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -456,7 +456,7 @@ static void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
 	if (!xsk->outstanding_tx)
 		return;
 
-	if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
+	if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
@@ -544,9 +544,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
 	if (!tx_invalid_test) {
 		xsk->outstanding_tx += batch_size;
-	} else {
-		if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
-			kick_tx(xsk);
+	} else if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
+		kick_tx(xsk);
 	}
 	*frameptr += batch_size;
 	*frameptr %= num_frames;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index ef219c0785eb..6c428b276ab6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -34,13 +34,11 @@
 #define IP_PKT_TOS 0x9
 #define UDP_PKT_SIZE (IP_PKT_SIZE - sizeof(struct iphdr))
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
-#define TMOUT_SEC (3)
 #define EOT (-1)
 #define USLEEP_MAX 200000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
-#define NEED_WAKEUP true
 #define DEFAULT_PKT_CNT 10000
 #define RX_FULL_RXQSIZE 32
 
-- 
2.20.1

