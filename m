Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0CF2813F0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgJBNWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:22:44 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56199 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgJBNWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 09:22:44 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud7.xs4all.net with ESMTPSA
        id OL1Dkh2CXv4gEOL1EkWqKU; Fri, 02 Oct 2020 15:22:41 +0200
Date:   Fri, 2 Oct 2020 15:22:38 +0200
From:   Antony Antony <antony@phenome.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-net v2] ip xfrm: support setting XFRMA_SET_MARK_MASK
 attribute in states
Message-ID: <20201002132238.GA36488@AntonyAntony.local>
References: <20200930043748.GA14318@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930043748.GA14318@AntonyAntony.local>
X-CMAE-Envelope: MS4wfOK3U0SbpwJ87FS6JX/qGXA6BKM/ZhW+BY5jlDFARu9YN5RoFXJaMHoeBLBtPYafxiCB/NPanPbVz8Zo4kCQ6n+Wx12xpgUq3M3BElRcqOnMxAEBrY0I
 rP4VkN4aaEkkA01bpYNorcaZ1P6vNlFQo0SH3A+v6WbvMewJuaK4bhTRqeA3nranWIkju9ElBiayqGIqkhm2BGplJk100fGyQBsg7RvzbmZKUmvE+A9iRz5Z
 i7FFCoK0KmWv/OiNysPR7TRCdYqubnPhsqkIkaWgUNRnz2Kb+kpGhQoHf6nXSHFxiPx+l7+loOLTbBGPqPmba9kMFn6Mi5Ytxoys8+Q9yUo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XFRMA_SET_MARK_MASK attribute can be set in states (4.19+)
It is optional and the kernel default is 0xffffffff
It is the mask of XFRMA_SET_MARK(a.k.a. XFRMA_OUTPUT_MARK in 4.18)

e.g.
./ip/ip xfrm state add output-mark 0x6 mask 0xab proto esp \
 auth digest_null 0 enc cipher_null ''
ip xfrm state
src 0.0.0.0 dst 0.0.0.0
	proto esp spi 0x00000000 reqid 0 mode transport
	replay-window 0
	output-mark 0x6/0xab
	auth-trunc digest_null 0x30 0
	enc ecb(cipher_null)
	anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
	sel src 0.0.0.0/0 dst 0.0.0.0/0

Signed-off-by: Antony Antony <antony@phenome.org>
---
 v1 -> v2
  - add man page and usage for mask
--
 ip/xfrm_state.c    | 23 ++++++++++++++++++-----
 man/man8/ip-xfrm.8 |  4 +++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index ddf784ca..a4f452fa 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -62,7 +62,7 @@ static void usage(void)
 		"        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n"
 		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
 		"        [ offload [dev DEV] dir DIR ]\n"
-		"        [ output-mark OUTPUT-MARK ]\n"
+		"        [ output-mark OUTPUT-MARK [ mask MASK ] ]\n"
 		"        [ if_id IF_ID ]\n"
 		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
 		"        [ reqid REQID ] [ seq SEQ ] [ min SPI max SPI ]\n"
@@ -328,7 +328,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 		struct xfrm_user_sec_ctx sctx;
 		char    str[CTX_BUF_SIZE];
 	} ctx = {};
-	__u32 output_mark = 0;
+	struct xfrm_mark output_mark = {0, 0};
 	bool is_if_id_set = false;
 	__u32 if_id = 0;
 
@@ -448,8 +448,18 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 			}
 		} else if (strcmp(*argv, "output-mark") == 0) {
 			NEXT_ARG();
-			if (get_u32(&output_mark, *argv, 0))
+			if (get_u32(&output_mark.v, *argv, 0))
 				invarg("value after \"output-mark\" is invalid", *argv);
+			if (argc > 1) {
+				NEXT_ARG();
+				if (strcmp(*argv, "mask") == 0) {
+					NEXT_ARG();
+					if (get_u32(&output_mark.m, *argv, 0))
+						invarg("mask value is invalid\n", *argv);
+				} else {
+					PREV_ARG();
+				}
+			}
 		} else if (strcmp(*argv, "if_id") == 0) {
 			NEXT_ARG();
 			if (get_u32(&if_id, *argv, 0))
@@ -741,8 +751,11 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 		}
 	}
 
-	if (output_mark)
-		addattr32(&req.n, sizeof(req.buf), XFRMA_OUTPUT_MARK, output_mark);
+	if (output_mark.v)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_OUTPUT_MARK, output_mark.v);
+
+	if (output_mark.m)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_SET_MARK_MASK, output_mark.m);
 
 	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
 		exit(1);
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 4fa31651..2669b386 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -60,7 +60,9 @@ ip-xfrm \- transform configuration
 .RB "[ " extra-flag
 .IR EXTRA-FLAG-LIST " ]"
 .RB "[ " output-mark
-.IR OUTPUT-MARK " ]"
+.IR OUTPUT-MARK
+.RB "[ " mask
+.IR MASK " ] ]"
 .RB "[ " if_id
 .IR IF-ID " ]"
 
-- 
2.21.3

