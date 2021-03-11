Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3919733784B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhCKPma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:42:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:42370 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234187AbhCKPly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:54 -0500
IronPort-SDR: +N65CiXcYkGsOOg5HwrQiIXez1LB717+1R77WZNyesAloPMZMFmskeV3dIritagvoCFmES2Y4B
 DQ9EN3AcXS+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188050757"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188050757"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:54 -0800
IronPort-SDR: fQqm941zTngOZe2+87J0Q6nQcmulLYrGf5Oeu/+Q9jkgUKNEh6Bhx4d7D+cUw7Y5iZ+/Va7lRa
 SYVIYcUxcRmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253672"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:51 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH v2 bpf-next 17/17] selftests: xsk: Remove unused defines
Date:   Thu, 11 Mar 2021 16:29:10 +0100
Message-Id: <20210311152910.56760-18-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
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
 tools/testing/selftests/bpf/xdpxceiver.c | 5 ++---
 tools/testing/selftests/bpf/xdpxceiver.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 0a2a383e8c97..931aa9ffa522 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -456,7 +456,7 @@ static void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
 	if (!xsk->outstanding_tx)
 		return;
 
-	if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
+	if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
@@ -544,8 +544,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
 	if (!tx_invalid_test) {
 		xsk->outstanding_tx += batch_size;
-	} else {
-		if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
+	} else if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			kick_tx(xsk);
 	}
 	*frameptr += batch_size;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 20943228b5e5..b592012115cc 100644
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

