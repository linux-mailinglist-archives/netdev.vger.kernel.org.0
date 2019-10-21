Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69931DE616
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfJUIRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 04:17:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:55532 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfJUIRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 04:17:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 01:17:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,322,1566889200"; 
   d="scan'208";a="348672712"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.41])
  by orsmga004.jf.intel.com with ESMTP; 21 Oct 2019 01:17:02 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kal.conley@dectris.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix registration of Rx-only sockets
Date:   Mon, 21 Oct 2019 10:16:58 +0200
Message-Id: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having Rx-only AF_XDP sockets can potentially lead to a crash in the
system by a NULL pointer dereference in xsk_umem_consume_tx(). This
function iterates through a list of all sockets tied to a umem and
checks if there are any packets to send on the Tx ring. Rx-only
sockets do not have a Tx ring, so this will cause a NULL pointer
dereference. This will happen if you have registered one or more
Rx-only sockets to a umem and the driver is checking the Tx ring even
on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
Rx-only and other sockets tied to the same umem.

Fixed by only putting sockets with a Tx component on the list that
xsk_umem_consume_tx() iterates over.

Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xdp_umem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 16d5f35..3049af2 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -27,6 +27,9 @@ void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
+	if (!xs->tx)
+		return;
+
 	spin_lock_irqsave(&umem->xsk_list_lock, flags);
 	list_add_rcu(&xs->list, &umem->xsk_list);
 	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
@@ -36,6 +39,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
+	if (!xs->tx)
+		return;
+
 	spin_lock_irqsave(&umem->xsk_list_lock, flags);
 	list_del_rcu(&xs->list);
 	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
-- 
2.7.4

