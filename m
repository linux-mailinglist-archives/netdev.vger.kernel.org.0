Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99EB42FE66
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbhJOWzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:55:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:46076 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243406AbhJOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:55:40 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mbW4y-000Bf1-5F; Sat, 16 Oct 2021 00:53:32 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next 3/4] ip, neigh: Add missing NTF_USE support
Date:   Sat, 16 Oct 2021 00:53:18 +0200
Message-Id: <20211015225319.2284-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211015225319.2284-1-daniel@iogearbox.net>
References: <20211015225319.2284-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26323/Fri Oct 15 10:25:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ip neigh does not support the NTF_USE flag. Similar to other flags
such as extern_learn, add cmdline support. The flag dump support is explicitly
missing here, since the kernel does not propagate the flag back to user space.

Usage example:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
  [...]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 ip/ipneigh.c            | 4 +++-
 man/man8/ip-neighbour.8 | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 564e787c..9510e03e 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -51,7 +51,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip neigh { add | del | change | replace }\n"
 		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
-		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
+		"		[ dev DEV ] [ router ] [ use ] [ extern_learn ] [ protocol PROTO ]\n"
 		"\n"
 		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
 		"				  [ vrf NAME ]\n"
@@ -148,6 +148,8 @@ static int ipneigh_modify(int cmd, int flags, int argc, char **argv)
 			req.ndm.ndm_flags |= NTF_PROXY;
 		} else if (strcmp(*argv, "router") == 0) {
 			req.ndm.ndm_flags |= NTF_ROUTER;
+		} else if (strcmp(*argv, "use") == 0) {
+			req.ndm.ndm_flags |= NTF_USE;
 		} else if (matches(*argv, "extern_learn") == 0) {
 			req.ndm.ndm_flags |= NTF_EXT_LEARNED;
 		} else if (strcmp(*argv, "dev") == 0) {
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index a27f9ef8..ed2dcd5a 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -25,6 +25,7 @@ ip-neighbour \- neighbour/arp tables management.
 .B  dev
 .IR DEV " ] [ "
 .BR router " ] [ "
+.BR use " ] [ "
 .BR extern_learn " ]"
 
 .ti -8
@@ -91,6 +92,13 @@ indicates whether we are proxying for this neighbour entry
 .BI router
 indicates whether neighbour is a router
 
+.TP
+.BI use
+this neigh entry is in "use". This option can be used to indicate to
+the kernel that a controller is using this dynamic entry. If the entry
+does not exist, the kernel will resolve it. If it exists, an attempt
+to refresh the neighbor entry will be triggered.
+
 .TP
 .BI extern_learn
 this neigh entry was learned externally. This option can be used to
-- 
2.27.0

