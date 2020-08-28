Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDEB255677
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgH1I2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:28:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:23538 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbgH1I1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:45 -0400
IronPort-SDR: FVh2b4vEj7NEqVYWVOyObiBR9IHl/hrnX5LA0DqS1hMpR4WBRHb42xtkigKMPQS/S3vfn54jZa
 mK4v7jUtnKQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156634043"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156634043"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:27:26 -0700
IronPort-SDR: v18x8kLv9AVZmhff2FhpqbqpW3nZ2NHj0qVoCCpkvC1I5dHo1g0GjHTJastiiJzj1ULre+NSJI
 PcRipm4OZfpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762889"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:27:23 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 12/15] xsk: add shared umem support between devices
Date:   Fri, 28 Aug 2020 10:26:26 +0200
Message-Id: <1598603189-32145-13-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ea8d2ec..5eb6662 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -701,14 +701,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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

