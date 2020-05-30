Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1A1E9272
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgE3QFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3QFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:05:20 -0400
X-Greylist: delayed 340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 30 May 2020 09:05:20 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9740CC03E969;
        Sat, 30 May 2020 09:05:20 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1590854376;
        bh=PSCFebsclWLpMlJ88YilwWY9YlLfR4NbLCDCYYd/tpw=;
        h=From:To:Cc:Subject:Date:From;
        b=4zAUrrc8cpbp+paOQlfqwneRwWpHLtUTS0yAUOeah81bvGbw7CxZ10sXwZvtZbkwC
         8EU9QIIe6rLlPbMYWvWSfcXEikg164JY0hFQPQH+N2abrl2q2dppNpWy1Pqn4d9VTy
         d/AOlJRusmokchHN6z9boqZM/ZmBMvSQ42mwiRYqa+hwJs0hzATGXbx9788IvRNaEI
         PthZocb5jDfKSUmlhq7uph5mGo2p5h1L4b7e9wc7xh2/VRvbXNWv4rpFG1LS4AX2J7
         +yTKOU9SX9cWFvjx+0+XNxmq/l7khNx1WAVV6LCKB0XnaMo/ZifjNhYMB0sOWuPYkn
         sof26Osx7NGMA==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: dccp: Add SIOCOUTQ IOCTL support (send buffer fill)
Date:   Sat, 30 May 2020 17:59:00 +0200
Message-Id: <20200530155900.930808-1-richard_siegfried@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Sailer <rs@tuxedocomputers.com>

This adds support for the SIOCOUTQ IOCTL to call send buffer fill
from the DCCP socket, like UDP and TCP already have.

Regarding the used data field. DCCP uses per packet sequence numbers,
not per byte, so sequence numbers can't be used like in TCP. sk_wmem_queued
is not used by DCCP and always 0, even in test on highly congested paths.
Therefore this uses sk_wmem_alloc like in UDP.
---
 Documentation/networking/dccp.txt | 2 ++
 net/dccp/proto.c                  | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/networking/dccp.txt b/Documentation/networking/dccp.txt
index 55c575fcaf17d..682ecf8288827 100644
--- a/Documentation/networking/dccp.txt
+++ b/Documentation/networking/dccp.txt
@@ -185,6 +185,8 @@ FIONREAD
 	Works as in udp(7): returns in the `int' argument pointer the size of
 	the next pending datagram in bytes, or 0 when no datagram is pending.
 
+SIOCOUTQ
+  Returns the number of data bytes in the local send queue.
 
 Other tunables
 ==============
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 4af8a98fe7846..b286346a8c626 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -375,6 +375,14 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		goto out;
 
 	switch (cmd) {
+	case SIOCOUTQ: {
+		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
+     * always 0, comparably to UDP.
+		 */
+		int amount = sk_wmem_alloc_get(sk);
+		rc = put_user(amount, (int __user *)arg);
+	}
+		       break;
 	case SIOCINQ: {
 		struct sk_buff *skb;
 		unsigned long amount = 0;
-- 
2.26.2

