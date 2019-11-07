Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1230F3616
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbfKGRr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:47:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:33465 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbfKGRry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:47:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 09:47:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="353858409"
Received: from unknown (HELO VM.jf.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2019 09:47:54 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, u9012063@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/5] libbpf: allow for creating Rx or Tx only AF_XDP sockets
Date:   Thu,  7 Nov 2019 18:47:38 +0100
Message-Id: <1573148860-30254-4-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The libbpf AF_XDP code is extended to allow for the creation of Rx
only or Tx only sockets. Previously it returned an error if the socket
was not initialized for both Rx and Tx.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8ebd810..303ed63 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -562,7 +562,8 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		}
 	}
 
-	err = xsk_set_bpf_maps(xsk);
+	if (xsk->rx)
+		err = xsk_set_bpf_maps(xsk);
 	if (err) {
 		xsk_delete_bpf_maps(xsk);
 		close(xsk->prog_fd);
@@ -583,7 +584,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	struct xsk_socket *xsk;
 	int err;
 
-	if (!umem || !xsk_ptr || !rx || !tx)
+	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
 
 	xsk = calloc(1, sizeof(*xsk));
-- 
2.7.4

