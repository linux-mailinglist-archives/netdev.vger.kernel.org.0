Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0764121B82D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGJORc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:17:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:32698 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgGJORa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:17:30 -0400
IronPort-SDR: GpbzhEB2ihNkTHsI3fVBMtn1XSbIDnTXWJ3CbtnB6YtFAjgsT4N9jcsHl0cw+EZU2wc78KZJZp
 ScrwOmPe/KEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="209731707"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="209731707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 07:17:30 -0700
IronPort-SDR: p4geW7vI2ggQk02oyV59fYjRxw2KxEw2sNbcbFCuiEhE9VgyDSZgUegxZn1Byn+/Z6cwtkZBf0
 uWrOzi7kNZ/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="428575492"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.54.29])
  by orsmga004.jf.intel.com with ESMTP; 10 Jul 2020 07:17:27 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v2 11/14] xsk: add shared umem support between devices
Date:   Fri, 10 Jul 2020 16:16:39 +0200
Message-Id: <1594390602-7635-12-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to share a umem between different devices. This mode
can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
sharing was only supported within the same device. Note that when
sharing a umem between devices, just as in the case of sharing a
umem between queue ids, you need to create a fill ring and a
completion ring and tie them to the socket (with two setsockopts,
one for each ring) before you do the bind with the
XDP_SHARED_UMEM flag. This so that the single-producer
single-consumer semantics of the rings can be upheld.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 05fadd9..4bf47d3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -695,14 +695,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			sockfd_put(sock);
 			goto out_unlock;
 		}
-		if (umem_xs->dev != dev) {
-			err = -EINVAL;
-			sockfd_put(sock);
-			goto out_unlock;
-		}
 
-		if (umem_xs->queue_id != qid) {
-			/* Share the umem with another socket on another qid */
+		if (umem_xs->queue_id != qid || umem_xs->dev != dev) {
+			/* Share the umem with another socket on another qid
+			 * and/or device.
+			 */
 			xs->pool = xp_create_and_assign_umem(xs,
 							     umem_xs->umem);
 			if (!xs->pool) {
-- 
2.7.4

