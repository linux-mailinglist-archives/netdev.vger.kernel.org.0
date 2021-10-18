Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8615430E2D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJRDcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:32:24 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:39880 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhJRDcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:32:22 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id F14A820223; Mon, 18 Oct 2021 11:30:05 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH net 1/2] mctp: unify sockaddr_mctp types
Date:   Mon, 18 Oct 2021 11:29:34 +0800
Message-Id: <20211018032935.2092613-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the more precise __kernel_sa_family_t for smctp_family, to match
struct sockaddr.

Also, use an unsigned int for the network member; negative networks
don't make much sense. We're already using unsigned for mctp_dev and
mctp_skb_cb, but need to change mctp_sock to suit.

Fixes: 60fc63981693 ("mctp: Add sockaddr_mctp to uapi")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 Documentation/networking/mctp.rst | 10 +++++-----
 include/net/mctp.h                |  2 +-
 include/uapi/linux/mctp.h         |  5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/mctp.rst b/Documentation/networking/mctp.rst
index 6100cdc220f6..fa7730dbf7b9 100644
--- a/Documentation/networking/mctp.rst
+++ b/Documentation/networking/mctp.rst
@@ -59,11 +59,11 @@ specified with a ``sockaddr`` type, with a single-byte endpoint address:
     };
 
     struct sockaddr_mctp {
-            unsigned short int	smctp_family;
-            int			smctp_network;
-            struct mctp_addr	smctp_addr;
-            __u8		smctp_type;
-            __u8		smctp_tag;
+            __kernel_sa_family_t smctp_family;
+            unsigned int         smctp_network;
+            struct mctp_addr     smctp_addr;
+            __u8                 smctp_type;
+            __u8                 smctp_tag;
     };
 
     #define MCTP_NET_ANY	0x0
diff --git a/include/net/mctp.h b/include/net/mctp.h
index a824d47c3c6d..ffd2c23bd76d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -54,7 +54,7 @@ struct mctp_sock {
 	struct sock	sk;
 
 	/* bind() params */
-	int		bind_net;
+	unsigned int	bind_net;
 	mctp_eid_t	bind_addr;
 	__u8		bind_type;
 
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 52b54d13f385..f384962d8ff2 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -10,6 +10,7 @@
 #define __UAPI_MCTP_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
 
 typedef __u8			mctp_eid_t;
 
@@ -18,8 +19,8 @@ struct mctp_addr {
 };
 
 struct sockaddr_mctp {
-	unsigned short int	smctp_family;
-	int			smctp_network;
+	__kernel_sa_family_t	smctp_family;
+	unsigned int		smctp_network;
 	struct mctp_addr	smctp_addr;
 	__u8			smctp_type;
 	__u8			smctp_tag;
-- 
2.30.2

