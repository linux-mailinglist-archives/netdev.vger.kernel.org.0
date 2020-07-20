Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E36822615B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgGTNxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:53:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:9780 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgGTNxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:53:09 -0400
IronPort-SDR: iUaGPPev7/ueXtQn9mijO0nKd1+HUlWYgHvrFQ0u7pXLxipsMmTOuD55dEgpeXJNHJW38xC47y
 d9Ok3FTsHKKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="147409152"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="147409152"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 06:53:08 -0700
IronPort-SDR: z+kCXETzDW/7PdXvHZYeLl0sgjaF7pSHztzGhabOOXTxsZo9nZvSYmosnbHUh9dTjerOMO9h7H
 erIbxnHJoorQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="431618361"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.34.51])
  by orsmga004.jf.intel.com with ESMTP; 20 Jul 2020 06:53:06 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
Subject: [PATCH bpf v3] xsk: do not discard packet when QUEUE_STATE_FROZEN
Date:   Mon, 20 Jul 2020 15:53:03 +0200
Message-Id: <1595253183-14935-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the skb Tx path, transmission of a packet is performed with
dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
routines, it returns NETDEV_TX_BUSY signifying that it was not
possible to send the packet now, please try later. Unfortunately, the
xsk transmit code discarded the packet and returned EBUSY to the
application. Fix this unnecessary packet loss, by not discarding the
packet in the Tx ring and return EAGAIN. As EAGAIN is returned to the
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
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
---
v1->v3:
* Hinder dev_direct_xmit() from freeing and completing the packet to
  user space by manipulating the skb->users count as suggested by
  Daniel Borkmann.
---
 net/xdp/xsk.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3700266..9e95c85 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -375,10 +375,23 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
+		/* Hinder dev_direct_xmit from freeing the packet and
+		 * therefore completing it in the destructor
+		 */
+		refcount_inc(&skb->users);
 		err = dev_direct_xmit(skb, xs->queue_id);
+		if  (err == NETDEV_TX_BUSY) {
+			/* QUEUE_STATE_FROZEN, tell app to retry the send */
+			skb->destructor = NULL;
+			kfree_skb(skb);
+			err = -EAGAIN;
+			goto out;
+		}
+
 		xskq_cons_release(xs->tx);
+		kfree_skb(skb);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
-		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
+		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
 			err = -EBUSY;
 			goto out;
-- 
2.7.4

