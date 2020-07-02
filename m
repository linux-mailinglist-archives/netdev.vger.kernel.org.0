Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F75E212330
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgGBMUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:20:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgGBMUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:20:05 -0400
IronPort-SDR: ay+MW/Ebgtuwo8JEiNpHGVl88r2i4Pxeb8dxyS3wzCDNpaCd+69+jbNbrXegRvYX0EdRsc1D6n
 Wh/L6MGgiG+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486138"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486138"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:20:05 -0700
IronPort-SDR: SQgjYFJ9ELTM428SdkHWWDY/ZgfcZFPJCSm/iDLjvAyQgI60CCQsAuMHTsXctSrqg5t+PCKyXN
 of7W2cV8XVww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933401"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:20:02 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 11/14] xsk: add shared umem support between devices
Date:   Thu,  2 Jul 2020 14:19:10 +0200
Message-Id: <1593692353-15102-12-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
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
index 1abc222..b240221 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -692,14 +692,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
 			new_pool = xp_assign_umem(xs->pool, umem_xs->umem);
 			if (!new_pool) {
 				sockfd_put(sock);
-- 
2.7.4

