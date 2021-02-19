Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1531FF43
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 20:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBSTPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 14:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBSTPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 14:15:21 -0500
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Feb 2021 11:14:40 PST
Received: from orthanc.universe-factory.net (orthanc.universe-factory.net [IPv6:2001:19f0:6c01:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6064C061574;
        Fri, 19 Feb 2021 11:14:40 -0800 (PST)
Received: from avalon.. (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id D026D1F4A7;
        Fri, 19 Feb 2021 20:06:23 +0100 (CET)
From:   Matthias Schiffer <mschiffer@universe-factory.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Parkin <tparkin@katalix.com>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH net] net: l2tp: reduce log level when passing up invalid packets
Date:   Fri, 19 Feb 2021 20:06:15 +0100
Message-Id: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 5ee759cda51b ("l2tp: use standard API for warning log
messages"), it was possible for userspace applications to use their own
control protocols on the backing sockets of an L2TP kernel device, and as
long as a packet didn't look like a proper L2TP data packet, it would be
passed up to userspace just fine.

After the mentioned change, this approach would lead to significant log
spam, as the previously hidden warnings are now shown by default. Not
even setting the T flag on the custom control packets is sufficient to
surpress these warnings, as packet length and L2TP version are checked
before the T flag.

Reduce all warnings debug level when packets are passed to userspace.

Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages")
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---

I'm unsure what to do about the pr_warn_ratelimited() in
l2tp_recv_common(). It feels wrong to me that an incoming network packet
can trigger a kernel message above debug level at all, so maybe they
should be downgraded as well? I believe the only reason these were ever
warnings is that they were not shown by default.


 net/l2tp/l2tp_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7be5103ff2a8..40852488c62a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		pr_warn_ratelimited("%s: recv short packet (len=%d)\n",
-				    tunnel->name, skb->len);
+		pr_debug_ratelimited("%s: recv short packet (len=%d)\n",
+				     tunnel->name, skb->len);
 		goto error;
 	}
 
@@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
-				    tunnel->name, version, tunnel->version);
+		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
+				     tunnel->name, version, tunnel->version);
 		goto error;
 	}
 
@@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
-				    tunnel->name, tunnel_id, session_id);
+		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",
+				     tunnel->name, tunnel_id, session_id);
 		goto error;
 	}
 
-- 
2.30.1

