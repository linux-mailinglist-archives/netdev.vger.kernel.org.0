Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1A2D4F21
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgLIX4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:56:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:19330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgLIX4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:56:04 -0500
IronPort-SDR: 4JXBTBgpY3KxP7U2vKOjkbq8Ickc23cSHeLxBHahrW4ZfTGzfmG10k+9SLHzD5mcFvQY3jfgmH
 smAj8mWdRbJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763090"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763090"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
IronPort-SDR: kADvpS/dywXNwoPsW28sVZR/hx0YeArH8D8xhexz71sv2pW7xC2wudlulqIdbQYKpsYu9lXAAt
 b1y+2Pb0X5lg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582183"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/11] mptcp: add port support for ADD_ADDR suboption writing
Date:   Wed,  9 Dec 2020 15:51:20 -0800
Message-Id: <20201209235128.175473-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

In rfc8684, the length of ADD_ADDR suboption with IPv4 address and port
is 18 octets, but mptcp_write_options is 32-bit aligned, so we need to
pad it to 20 octets. All the other port related option lengths need to
be added up 2 octets similarly.

This patch added a new field 'port' in mptcp_out_options. When this
field is set with a port number, we need to add up 4 octets for the
ADD_ADDR suboption, and put the port number into the suboption.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |  1 +
 net/mptcp/options.c  | 30 +++++++++++++++++++++++++++---
 net/mptcp/protocol.h | 10 +++++-----
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index b6cf07143a8a..5694370be3d4 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -46,6 +46,7 @@ struct mptcp_out_options {
 #endif
 	};
 	u8 addr_id;
+	u16 port;
 	u64 ahmac;
 	u8 rm_id;
 	u8 join_id;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 639d47e6e2d0..51f560a26890 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1088,6 +1088,9 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 #endif
 
+		if (opts->port)
+			len += TCPOLEN_MPTCP_PORT_LEN;
+
 		if (opts->ahmac) {
 			len += sizeof(opts->ahmac);
 			echo = 0;
@@ -1105,9 +1108,30 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			ptr += 4;
 		}
 #endif
-		if (opts->ahmac) {
-			put_unaligned_be64(opts->ahmac, ptr);
-			ptr += 2;
+
+		if (!opts->port) {
+			if (opts->ahmac) {
+				put_unaligned_be64(opts->ahmac, ptr);
+				ptr += 2;
+			}
+		} else {
+			if (opts->ahmac) {
+				u8 *bptr = (u8 *)ptr;
+
+				put_unaligned_be16(opts->port, bptr);
+				bptr += 2;
+				put_unaligned_be64(opts->ahmac, bptr);
+				bptr += 8;
+				put_unaligned_be16(TCPOPT_NOP << 8 |
+						   TCPOPT_NOP, bptr);
+
+				ptr += 3;
+			} else {
+				put_unaligned_be32(opts->port << 16 |
+						   TCPOPT_NOP << 8 |
+						   TCPOPT_NOP, ptr);
+				ptr += 1;
+			}
 		}
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4db8c905b0db..987046d9d1d4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -49,14 +49,14 @@
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 #define TCPOLEN_MPTCP_ADD_ADDR		16
-#define TCPOLEN_MPTCP_ADD_ADDR_PORT	18
+#define TCPOLEN_MPTCP_ADD_ADDR_PORT	20
 #define TCPOLEN_MPTCP_ADD_ADDR_BASE	8
-#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	10
+#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	12
 #define TCPOLEN_MPTCP_ADD_ADDR6		28
-#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	30
+#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	32
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE	20
-#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
-#define TCPOLEN_MPTCP_PORT_LEN		2
+#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
+#define TCPOLEN_MPTCP_PORT_LEN		4
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 
 /* MPTCP MP_JOIN flags */
-- 
2.29.2

