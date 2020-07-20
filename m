Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED02268E6
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbgGTQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733065AbgGTQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:06:33 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25D7C061794;
        Mon, 20 Jul 2020 09:06:32 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1595261185;
        bh=fSmUacZ5Dg91YFOQgxAFUtEfdxmnPPb1AjKxh6rk76U=;
        h=From:To:Cc:Subject:Date:From;
        b=VJL/qrnycOuj9TZAR0VLmkLaWRbpqX1qip8Mgafa9KKO99pLy0tsHPoJgdBynb5r8
         QAq2dl86nk2Jwvk1dMr7zT4CZep7sh5NYLMwsd0ouEo6+nm16c6OK4YZRhJyL6TuFZ
         R5vKK4lkpDatsnAsKYx2LuP7RyGil7Ml5sREs0jSvQttSC320yEiADYtp1jeOCxAlF
         RtFmZ9YM4WfghTf761/G/uH/1hfPwJxtXUwo2qrCx4wwyF/Fbv7ImSyYzqmjiPwyLL
         PC7cVT3J89hIDYOH9zwtKLQmMFHQNrZ4+GHMRZpKFytZYCAnplpTjB6+T67QjNv8I7
         x5hWGcfU2CXyw==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5] net: dccp: Add SIOCOUTQ IOCTL support (send buffer fill)
Date:   Mon, 20 Jul 2020 18:06:14 +0200
Message-Id: <20200720160614.117090-1-richard_siegfried@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the SIOCOUTQ IOCTL to get the send buffer fill
of a DCCP socket, like UDP and TCP sockets already have.

Regarding the used data field: DCCP uses per packet sequence numbers,
not per byte, so sequence numbers can't be used like in TCP. sk_wmem_queued
is not used by DCCP and always 0, even in test on highly congested paths.
Therefore this uses sk_wmem_alloc like in UDP.

Signed-off-by: Richard Sailer <richard_siegfried@systemli.org>
---
v5: More infos into dccp.rst, +empty line after declarations
---
 Documentation/networking/dccp.rst | 3 +++
 net/dccp/proto.c                  | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/networking/dccp.rst b/Documentation/networking/dccp.rst
index dde16be044562..91e5c33ba3ff5 100644
--- a/Documentation/networking/dccp.rst
+++ b/Documentation/networking/dccp.rst
@@ -192,6 +192,9 @@ FIONREAD
 	Works as in udp(7): returns in the ``int`` argument pointer the size of
 	the next pending datagram in bytes, or 0 when no datagram is pending.
 
+SIOCOUTQ
+	Returns the number of unsent data bytes in the socket send queue as ``int``
+	into the buffer specified by the argument pointer.
 
 Other tunables
 ==============
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index fd92d3fe321f0..9e453611107f1 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -375,6 +375,15 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		goto out;
 
 	switch (cmd) {
+	case SIOCOUTQ: {
+		int amount = sk_wmem_alloc_get(sk);
+		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
+		 * always 0, comparably to UDP.
+		 */
+
+		rc = put_user(amount, (int __user *)arg);
+	}
+		break;
 	case SIOCINQ: {
 		struct sk_buff *skb;
 		unsigned long amount = 0;
-- 
2.27.0

