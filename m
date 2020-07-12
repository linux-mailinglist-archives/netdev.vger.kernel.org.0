Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CFF21CBF8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgGLXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgGLXEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 19:04:22 -0400
X-Greylist: delayed 515 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jul 2020 16:04:22 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA7C061794;
        Sun, 12 Jul 2020 16:04:22 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1594594540;
        bh=4KALp17+PzECmJ80qb9HTCoovw7GWDveDKMk0+jvLFw=;
        h=From:To:Cc:Subject:Date:From;
        b=khgnqnvCTq7R0XeZiQKpCRVuiR3TMUKwc1BkdAWupSoTDslvqf1DCP5JCISkAbv42
         ixQiUvsBM5PoJaRdCboWC9DlZ/F+JhaJj3zaSvUpw1E2w9ijqvuGsyQNAkD5E1AFd1
         sdocNVYVXo77oOaJUqRm4STKjFVcFdND2LnMm0z3+oj1S6I7ervYNT3BxkGbbAtwQP
         QHLUb7PxumRA4Xen4gVGjwiZYfROrA8PG/e2S/sz4JXOv25UADIKGci+iRt1lmcZqm
         MNZsZhhr6srRI/DA3FpctavJruBIZ/LU4ukHXe1mXzhop+GwIv4MVnANzpvQktsp6a
         TCF5Gz9cXSIng==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v4] net: dccp: Add SIOCOUTQ IOCTL support (send buffer fill)
Date:   Mon, 13 Jul 2020 00:55:20 +0200
Message-Id: <20200712225520.269542-1-richard_siegfried@systemli.org>
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
v4: Update to apply to .rst doc file
---
 Documentation/networking/dccp.rst | 2 ++
 net/dccp/proto.c                  | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/networking/dccp.rst b/Documentation/networking/dccp.rst
index dde16be044562..74659da107f6b 100644
--- a/Documentation/networking/dccp.rst
+++ b/Documentation/networking/dccp.rst
@@ -192,6 +192,8 @@ FIONREAD
 	Works as in udp(7): returns in the ``int`` argument pointer the size of
 	the next pending datagram in bytes, or 0 when no datagram is pending.
 
+SIOCOUTQ
+  Returns the number of data bytes in the local send queue.
 
 Other tunables
 ==============
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index c13b6609474b6..dab74e8a8a69b 100644
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
2.27.0

