Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359EB1ECE04
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgFCLLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFCLLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 07:11:16 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE285C08C5C0;
        Wed,  3 Jun 2020 04:11:15 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1591182670;
        bh=0JtWQ8v/7Da7Qb/3mLnVazRXnZ5AEdLGU2IyjEYBZbQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bKM1VJRwpIx3XXeYzc0Xr8Bs0EA7t42xnL6/FtxiZ+rOm52y9N3urOXZ2yY8cX27G
         ADg4Artb0MWU9JCy6dvLcd52q+Hgw6eZwEaj94zuHa1To1+Sw91+DHmNGB0vjybLXl
         aj0oR2fibitnq6gkrZkkxLZ+qWtgi/tSyD1puIxzoFbTZuElXkU9EhA87tG53053O3
         dDEqVbDIaRdj4ly/a1jjw8IHzS/GiZP+8rT2NZTa+akJCtxbQ200xM8R1vx05Yo3mp
         U7UmCYab76Y7E4uHEKYF3fhOJy3jMpi+rVtpN83UQ7F9w/AHFbaI53vzKsLbnbaN5W
         Ai+MbbatsekLg==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v3] net: dccp: Add SIOCOUTQ IOCTL support (send buffer fill)
Date:   Wed,  3 Jun 2020 13:10:51 +0200
Message-Id: <20200603111051.12224-1-richard_siegfried@systemli.org>
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
v3: whitespace fixes
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
index 4af8a98fe7846..148de5ec585b2 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -375,6 +375,14 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		goto out;
 
 	switch (cmd) {
+	case SIOCOUTQ: {
+		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
+		 * always 0, comparably to UDP.
+		 */
+		int amount = sk_wmem_alloc_get(sk);
+		rc = put_user(amount, (int __user *)arg);
+	}
+		break;
 	case SIOCINQ: {
 		struct sk_buff *skb;
 		unsigned long amount = 0;
-- 
2.26.2

