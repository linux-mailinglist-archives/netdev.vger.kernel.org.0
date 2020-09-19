Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3ED270D1E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 12:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgISKil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 06:38:41 -0400
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40249 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgISKil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 06:38:41 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id JaGMk898lS0n1JaGNkobO3; Sat, 19 Sep 2020 12:38:39 +0200
From:   Antony Antony <antony@phenome.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Antony Antony <antony@phenome.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next RFC] ip xfrm: support setting XFRMA_SET_MARK_MASK attribute in states
Date:   Sat, 19 Sep 2020 12:38:30 +0200
Message-Id: <20200919103830.49082-1-antony@phenome.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20200919103027.48991-1-antony@phenome.org>
References: <20200919103027.48991-1-antony@phenome.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfG98fdCx72Kmxv4qXZoeWFKlF153erxmU4ve/SKukL4aInsm6eYDxPk3aan/FbpULlJxK0QH0Id/nppmpSbxS8NE/FP2icXmg8t5f3a/c/pDsZbdHv7D
 R27k37V6iJZCG8gTiP2LJPN8OJnjYWQDkRSHdflfCFoXZ3rGwkTjOZMOJEuNw76ltPwoQARJ3JbNMr6o2Q8FD4sXPuNEved/kLaWjn53S1o7NsmhCqpHH7nk
 O5VnU5PLAKbkaQ/rLFyjwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XFRMA_SET_MARK_MASK attribute can be set in states (4.19+)
It is the mask of XFRMA_SET_MARK(a.k.a. XFRMA_OUTPUT_MARK in 4.18)
It is optional and the kernel default is 0xffffffff

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

NOTE: a disadavantage of this version: error message would be the same
for the option 'mark' and  'output-mark'
e.g
./ip/ip xfrm state add output-mark 0xZZ mask 0xab proto \
 esp auth digest_null 0 enc cipher_null ''
Error: argument "0xZZ" is wrong: MARK value is invalid

./ip/ip xfrm state add mark 0xZZ mask 0xab proto esp auth \
 digest_null 0 enc cipher_null ''
Error: argument "0xZZ" is wrong: MARK value is invalid

Signed-off-by: Antony Antony <antony@phenome.org>
---
 ip/xfrm_state.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index ddf784ca..a258a1a5 100644
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
 
@@ -447,9 +447,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 				is_offload = false;
 			}
 		} else if (strcmp(*argv, "output-mark") == 0) {
-			NEXT_ARG();
-			if (get_u32(&output_mark, *argv, 0))
-				invarg("value after \"output-mark\" is invalid", *argv);
+			xfrm_parse_mark(&output_mark, &argc, &argv);
 		} else if (strcmp(*argv, "if_id") == 0) {
 			NEXT_ARG();
 			if (get_u32(&if_id, *argv, 0))
@@ -741,8 +739,11 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 		}
 	}
 
-	if (output_mark)
-		addattr32(&req.n, sizeof(req.buf), XFRMA_OUTPUT_MARK, output_mark);
+	if (output_mark.v)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_OUTPUT_MARK, output_mark.v);
+	if (output_mark.m)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_SET_MARK_MASK,
+			  output_mark.m);
 
 	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
 		exit(1);
-- 
2.21.3

