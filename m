Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBB7B02AA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 19:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfIKR0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 13:26:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:17453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbfIKR0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 13:26:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 10:26:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="384772720"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.223.65])
  by fmsmga005.fm.intel.com with ESMTP; 11 Sep 2019 10:26:45 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kevin.laatz@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 3/3] samples/bpf: fix xdpsock l2fwd tx for unaligned mode
Date:   Wed, 11 Sep 2019 17:24:35 +0000
Message-Id: <20190911172435.21042-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190911172435.21042-1-ciara.loftus@intel.com>
References: <20190911172435.21042-1-ciara.loftus@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preserve the offset of the address of the received descriptor, and include
it in the address set for the tx descriptor, so the kernel can correctly
locate the start of the packet data.

Fixes: 03895e63ff97 ("samples/bpf: add buffer recycling for unaligned chunks to xdpsock")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 102eace22956..df011ac33402 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -685,7 +685,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	for (i = 0; i < rcvd; i++) {
 		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
 		u32 len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
-		u64 orig = xsk_umem__extract_addr(addr);
+		u64 orig = addr;
 
 		addr = xsk_umem__add_offset_to_addr(addr);
 		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
-- 
2.17.1

