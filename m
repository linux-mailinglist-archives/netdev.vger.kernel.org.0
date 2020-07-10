Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB2921AFAB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGJGqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:46:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:11952 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgGJGqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 02:46:02 -0400
IronPort-SDR: tzVtC/UvZMZcadw65VEY8cj+agtdWAsX/A4vwdRy7svqXh6KLwWVGOq9lUR7yQGS5jAplI95YO
 cHBE8zexhJkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="127751241"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="127751241"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 23:46:02 -0700
IronPort-SDR: bb31EOr9tODV2cAOP7NYoxmbtgRyPoO5w9IyFJLx4JuaphPGrdjpbiTEansHqFLx0p7M/7bHpV
 ebLm6jevOZoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="428479086"
Received: from amyskov-mobl.ccr.corp.intel.com (HELO localhost.localdomain) ([10.252.54.29])
  by orsmga004.jf.intel.com with ESMTP; 09 Jul 2020 23:45:59 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
Subject: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb path
Date:   Fri, 10 Jul 2020 08:45:54 +0200
Message-Id: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the skb Tx path, transmission of a packet is performed with
dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
routines, it returns NETDEV_TX_BUSY signifying that it was not
possible to send the packet now, please try later. Unfortunately, the
xsk transmit code discarded the packet, missed to free the skb, and
returned EBUSY to the application. Fix this memory leak and
unnecessary packet loss, by not discarding the packet in the Tx ring,
freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
application, it can then retry the send operation and the packet will
finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
state anymore. So EAGAIN tells the application that the packet was not
discarded from the Tx ring and that it needs to call send()
again. EBUSY, on the other hand, signifies that the packet was not
sent and discarded from the Tx ring. The application needs to put the
packet on the Tx ring again if it wants it to be sent.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
---
The v1 of this patch was called "xsk: do not discard packet when
QUEUE_STATE_FROZEN".
---
 net/xdp/xsk.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3700266..5304250 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb->destructor = xsk_destruct_skb;
 
 		err = dev_direct_xmit(skb, xs->queue_id);
-		xskq_cons_release(xs->tx);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
-		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
+		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
+			xskq_cons_release(xs->tx);
 			err = -EBUSY;
 			goto out;
+		} else if  (err == NETDEV_TX_BUSY) {
+			/* QUEUE_STATE_FROZEN, tell application to
+			 * retry sending the packet
+			 */
+			skb->destructor = NULL;
+			kfree_skb(skb);
+			err = -EAGAIN;
+			goto out;
 		}
+		xskq_cons_release(xs->tx);
 
 		sent_frame = true;
 	}
-- 
2.7.4

