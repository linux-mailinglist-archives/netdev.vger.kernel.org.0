Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC7347B09
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhCXOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:45:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:2051 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236269AbhCXOo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:44:58 -0400
IronPort-SDR: vU17JzfMV/kzat9tDvFLqbDfSDR6ZgW37O+sfbbRWkcFt+9txVax0MZHJpnGIJDTA/4yJM9Ef5
 Kp4j5iirqX8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="177834557"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="177834557"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 07:44:58 -0700
IronPort-SDR: yvIM/ZQjg1VokVLh3UkfAtuaUPaLwXkG28iqDd0cW8UjMNr53/DNGx+LPdaE+L57YBdOmTm8xO
 rbfggYg9yytg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="608127991"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 07:44:57 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf 3/3] libbpf: ignore return values of setsockopt for XDP rings.
Date:   Wed, 24 Mar 2021 14:13:37 +0000
Message-Id: <20210324141337.29269-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324141337.29269-1-ciara.loftus@intel.com>
References: <20210324141337.29269-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During xsk_socket__create the XDP_RX_RING and XDP_TX_RING setsockopts
are called to create the rx and tx rings for the AF_XDP socket. If the ring
has already been set up, the setsockopt will return an error. However,
in the event of a failure during xsk_socket__create(_shared) after the
rings have been set up, the user may wish to retry the socket creation
using these pre-existing rings. In this case we can ignore the error
returned by the setsockopts. If there is a true error, the subsequent
call to mmap() will catch it.

Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index ec3c23299329..1f1c4c11c292 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -904,24 +904,22 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
-		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
-				 &xsk->config.rx_size,
-				 sizeof(xsk->config.rx_size));
-		if (err) {
-			err = -errno;
-			goto out_put_ctx;
-		}
-	}
-	if (tx) {
-		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
-				 &xsk->config.tx_size,
-				 sizeof(xsk->config.tx_size));
-		if (err) {
-			err = -errno;
-			goto out_put_ctx;
-		}
-	}
+	/* The return values of these setsockopt calls are intentionally not checked.
+	 * If the ring has already been set up setsockopt will return an error. However,
+	 * this scenario is acceptable as the user may be retrying the socket creation
+	 * with rings which were set up in a previous but ultimately unsuccessful call
+	 * to xsk_socket__create(_shared). The call later to mmap() will fail if there
+	 * is a real issue and we handle that return value appropriately there.
+	 */
+	if (rx)
+		setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
+			   &xsk->config.rx_size,
+			   sizeof(xsk->config.rx_size));
+
+	if (tx)
+		setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
+			   &xsk->config.tx_size,
+			   sizeof(xsk->config.tx_size));
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (err) {
-- 
2.17.1

