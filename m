Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60A1E92A2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgE3Qce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgE3Qce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:32:34 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B370C03E969;
        Sat, 30 May 2020 09:32:33 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1590856351;
        bh=GwxEBYKjdurL28A5qj78AaAAHwwAsPprqlObqqEBNwg=;
        h=From:To:Cc:Subject:Date:From;
        b=Komy0b4lNNGg0YgpCQoVIf+/fem2pAQf6CGBC6Cd6XqElgLLmHeXolRCh8f7sDzyB
         yhwhpQLPNVG7swJrctmP1CoxqVaYb2HiauhiB4kX+hYFOlPOAXeqa5gMzv7amHQVG1
         tojVG1K5ZfCq6Xdb7doIIEQFuLwdpIbfYDK6NjaWFEBZGTlm93sXGaQw6t7OghqJ6+
         ydrJjG9rK1T0aem9epD3GX2PQxv+skSZrQwlgq4WfzL3IioH55HZxCAA9LtuuD2AUC
         okrzINLEpXc++11ek0/sBNXHAFj4j1HXePrLkCaxsYMZYG0AyM+sO5+GQbw4948VV/
         Yw8e7Ls7c0xDA==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net: dccp: Add SIOCOUTQ IOCTL support (send buffer fill)
Date:   Sat, 30 May 2020 18:31:59 +0200
Message-Id: <20200530163159.932749-1-richard_siegfried@systemli.org>
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

Signed-off-by: Richard Sailer <richard_siegfried@systemli.org>
---
v2: Add Signed-off-by line and fix tab-vs-space error produced by badly
configuerd emacs
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
index 4af8a98fe7846..53ed36705b820 100644
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
+		       break;
 	case SIOCINQ: {
 		struct sk_buff *skb;
 		unsigned long amount = 0;
-- 
2.26.2

