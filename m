Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4C41BFE1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhI2H2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:47 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33128 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244656AbhI2H2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:31 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 69938214E4; Wed, 29 Sep 2021 15:26:49 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 08/10] doc/mctp: Add a little detail about kernel internals
Date:   Wed, 29 Sep 2021 15:26:12 +0800
Message-Id: <20210929072614.854015-9-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

Describe common flows and refcounting behaviour.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 Documentation/networking/mctp.rst | 59 +++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/networking/mctp.rst b/Documentation/networking/mctp.rst
index 6100cdc220f6..2c54b029f990 100644
--- a/Documentation/networking/mctp.rst
+++ b/Documentation/networking/mctp.rst
@@ -211,3 +211,62 @@ remote address is already known, or the message does not require a reply.
 
 Like the send calls, sockets will only receive responses to requests they have
 sent (TO=1) and may only respond (TO=0) to requests they have received.
+
+Kernel internals
+================
+
+There are a few possible packet flows in the MCTP stack:
+
+1. local TX to remote endpoint, message <= MTU::
+
+	sendmsg()
+	 -> mctp_local_output()
+	    : route lookup
+	    -> rt->output() (== mctp_route_output)
+	       -> dev_queue_xmit()
+
+2. local TX to remote endpoint, message > MTU::
+
+	sendmsg()
+	-> mctp_local_output()
+	    -> mctp_do_fragment_route()
+	       : creates packet-sized skbs. For each new skb:
+	       -> rt->output() (== mctp_route_output)
+	          -> dev_queue_xmit()
+
+3. remote TX to local endpoint, single-packet message::
+
+	mctp_pkttype_receive()
+	: route lookup
+	-> rt->output() (== mctp_route_input)
+	   : sk_key lookup
+	   -> sock_queue_rcv_skb()
+
+4. remote TX to local endpoint, multiple-packet message::
+
+	mctp_pkttype_receive()
+	: route lookup
+	-> rt->output() (== mctp_route_input)
+	   : sk_key lookup
+	   : stores skb in struct sk_key->reasm_head
+
+	mctp_pkttype_receive()
+	: route lookup
+	-> rt->output() (== mctp_route_input)
+	   : sk_key lookup
+	   : finds existing reassembly in sk_key->reasm_head
+	   : appends new fragment
+	   -> sock_queue_rcv_skb()
+
+Key refcounts
+-------------
+
+ * keys are refed by:
+
+   - a skb: during route output, stored in ``skb->cb``.
+
+   - netns and sock lists.
+
+ * keys can be associated with a device, in which case they hold a
+   reference to the dev (set through ``key->dev``, counted through
+   ``dev->key_count``). Multiple keys can reference the device.
-- 
2.30.2

