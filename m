Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5131A15D6D2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgBNLsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:48:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:41106 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgBNLsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 06:48:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 03:48:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="228468524"
Received: from dsitkin-mobl.ccr.corp.intel.com (HELO localhost.localdomain) ([10.252.24.179])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 03:48:42 -0800
From:   Sebastien Boeuf <sebastien.boeuf@intel.com>
To:     netdev@vger.kernel.org
Cc:     sgarzare@redhat.com, stefanha@redhat.com, davem@davemloft.net,
        Sebastien Boeuf <sebastien.boeuf@intel.com>
Subject: [PATCH v3 1/2] net: virtio_vsock: Enhance connection semantics
Date:   Fri, 14 Feb 2020 12:48:01 +0100
Message-Id: <20200214114802.23638-2-sebastien.boeuf@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214114802.23638-1-sebastien.boeuf@intel.com>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the vsock backend on the host sends a packet through the RX
queue, it expects an answer on the TX queue. Unfortunately, there is one
case where the host side will hang waiting for the answer and might
effectively never recover if no timeout mechanism was implemented.

This issue happens when the guest side starts binding to the socket,
which insert a new bound socket into the list of already bound sockets.
At this time, we expect the guest to also start listening, which will
trigger the sk_state to move from TCP_CLOSE to TCP_LISTEN. The problem
occurs if the host side queued a RX packet and triggered an interrupt
right between the end of the binding process and the beginning of the
listening process. In this specific case, the function processing the
packet virtio_transport_recv_pkt() will find a bound socket, which means
it will hit the switch statement checking for the sk_state, but the
state won't be changed into TCP_LISTEN yet, which leads the code to pick
the default statement. This default statement will only free the buffer,
while it should also respond to the host side, by sending a packet on
its TX queue.

In order to simply fix this unfortunate chain of events, it is important
that in case the default statement is entered, and because at this stage
we know the host side is waiting for an answer, we must send back a
packet containing the operation VIRTIO_VSOCK_OP_RST.

One could say that a proper timeout mechanism on the host side will be
enough to avoid the backend to hang. But the point of this patch is to
ensure the normal use case will be provided with proper responsiveness
when it comes to establishing the connection.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
 net/vmw_vsock/virtio_transport_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d9f0c9c5425a..2f696124bab6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1153,6 +1153,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		virtio_transport_free_pkt(pkt);
 		break;
 	default:
+		(void)virtio_transport_reset_no_sock(t, pkt);
 		virtio_transport_free_pkt(pkt);
 		break;
 	}
-- 
2.20.1

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

