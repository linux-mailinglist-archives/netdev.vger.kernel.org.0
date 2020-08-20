Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404124B793
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgHTK7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:59:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46282 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731171AbgHTK56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:57:58 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597921073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YIkdj2DyvYAhQ7RBBwnYw5GJ1OBharqxpJPUklg5BVY=;
        b=sQO1KRzu+ln6rYasVnJrj+dGujnRJIpdNi4SZQtH+HfrsqdMiTtzuNUcWd+pR2CoNW0rCB
        QvrGeuIQTuBdDAri4DtyW05dShPyZxpGqXYOmdWOgyqTlOXsiQ4PfFMzlHg2b37lWXVyIs
        OapnL0xcMSIt0iVPgXP2Tar+YU4CDjW+NqCgAtB+5mal2kxMNyCaWYNhOI2IdL5V7zEklv
        sJHnoBnVnMUWxSXhSM4+KIt1vvM6hqgabUWoqTR0AaWapyjHuiOXFDCBhNNRzikKGcFG48
        Xgwe7xDdmWD1SLEm7eDXKKN24d1L0Rqw4HCpQCz4PnEavoNCViZ0uXWguW7FsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597921073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YIkdj2DyvYAhQ7RBBwnYw5GJ1OBharqxpJPUklg5BVY=;
        b=GLQ1GQMkBs9itAqx6i75aleyoPHKCFjC143w8bmpAZT8W4yQ72xQ2NT1XNirW4bEmSUexd
        ea6Ua9vT7ucZ+ZDA==
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH] net: bridge: Don't reset time stamps on SO_TXTIME enabled sockets
Date:   Thu, 20 Aug 2020 12:57:37 +0200
Message-Id: <20200820105737.5089-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using the ETF Qdisc in combination with a bridge and DSA, then all packets
gets dropped due to invalid time stamps. The setup looks like this:

Transmit path:

Application -> bridge (br0) -> DSA slave ports (lan0, lan1) -> ETF Qdisc
            -> ethernet (eth0)

The user space application uses SO_TXTIME to attach a sending time stamp for
each packet using the corresponding interface. That time stamp is then attached
to the skb in the kernel. The first network device involved in the chain is the
bridge device. However, in br_forward_finish() the time stamp is reset to zero
unconditionally. Meaning when the skb arrives at the ETF Qdisc, it's dropped as
invalid because the time stamp is zero.

The reset of the time stamp in the bridge code is there for a good reason. See
commit 41d1c8839e5f ("net: clear skb->tstamp in bridge forwarding path")
Therefore, add a conditional for SO_TXTIME enabled sockets.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/bridge/br_forward.c | 9 +++++++++
 1 file changed, 9 insertions(+)

RFC, because I don't know if that's the correct way to solve that issue.

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 7629b63f6f30..e5f7e49ed91d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_vlan.h>
 #include <linux/netfilter_bridge.h>
+#include <net/sock.h>
 #include "br_private.h"
 
 /* Don't forward packets to originating port or forwarding disabled */
@@ -61,7 +62,15 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);
 
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	/* When applications provide time stamps for packets via SO_TXTIME
+	 * socket option, then don't reset it.
+	 */
+	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME))
+		goto finish;
+
 	skb->tstamp = 0;
+
+finish:
 	return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
 		       net, sk, skb, NULL, skb->dev,
 		       br_dev_queue_push_xmit);
-- 
2.20.1

