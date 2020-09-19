Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E30270D16
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 12:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgISKhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 06:37:52 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40503 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgISKhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 06:37:51 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2020 06:37:50 EDT
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id Ja8Zk874PS0n1Ja8akoaQs; Sat, 19 Sep 2020 12:30:44 +0200
From:   Antony Antony <antony@phenome.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Antony Antony <antony@phenome.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next RFC] ip xfrm: support setting XFRMA_SET_MARK_MASK attribute in states
Date:   Sat, 19 Sep 2020 12:30:27 +0200
Message-Id: <20200919103027.48991-1-antony@phenome.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOncMPiZ77rcSUtnq7mUoQQQPs+AX6CxdM61/xo9LELsfZUyCzE0kGYuSmk3GHkS03jTrTY0A60JyR/SN6iEsbjLhCnbOCVoFs7157bXeTki+19B6hr9
 yBwvCY2YfBbK4o/kSVsE0zIONemjmwqg7sKQKGsdx0s4ANWsD3TmOtUfdfI1yfSRcGlQhfrbdIVV6jmRSpr0ZO34q5xAHdl23wWURn5NTpMrYnDk9OhwNiUT
 MArZQLtsSjpHWDjx7Xz6Sg==
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

NOTE: I am sending two versions. Is there preference for the next one
over this? A diference is in error message for "mark" and "output-mark"

./ip/ip xfrm state add output-mark 0xZZ mask 0xab proto esp \
 auth digest_null 0 enc cipher_null ''
Error: argument "0xZZ" is wrong: value after "output-mark" is invalid

vs

./ip/ip xfrm state add mark 0xZZ mask 0xab proto esp \
 auth digest_null 0 enc cipher_null ''
Error: argument "0xZZ" is wrong: MARK value is invalid

Signed-off-by: Antony Antony <antony@phenome.org>
---
 ip/xfrm_state.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index ddf784ca..c45d993b 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -328,7 +328,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 		struct xfrm_user_sec_ctx sctx;
 		char    str[CTX_BUF_SIZE];
 	} ctx = {};
-	__u32 output_mark = 0;
+	struct xfrm_mark output_mark = {0, 0};
 	bool is_if_id_set = false;
 	__u32 if_id = 0;
 
@@ -403,7 +403,6 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 			coap = *argv;
 
 			NEXT_ARG();
-
 			get_prefix(&coa, *argv, preferred_family);
 			if (coa.family == AF_UNSPEC)
 				invarg("value after \"coa\" has an unrecognized address family", *argv);
@@ -448,8 +447,18 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
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
@@ -741,8 +750,11 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
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
-- 
2.21.3

