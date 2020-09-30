Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE9F27DF9B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 06:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgI3Ehx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 00:37:53 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45591 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI3Ehx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 00:37:53 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud8.xs4all.net with ESMTPSA
        id NTsCkJZinTHgxNTsDkaiic; Wed, 30 Sep 2020 06:37:50 +0200
Date:   Wed, 30 Sep 2020 06:37:48 +0200
From:   Antony Antony <antony@phenome.org>
To:     stephen@networkplumber.org, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next] ip xfrm: support setting XFRMA_SET_MARK_MASK
 attribute in states
Message-ID: <20200930043748.GA14318@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CMAE-Envelope: MS4wfAsuPZ5xTeD7s3vfUO3YUjKdKtRzBbmzMhL0iJ/AxLphm8t7atS6ySdF21w1y4YQae3Jil9wNaRafQ49EsGuGoSYOZ7BCD6v05wV05SzTYkuVaVqp562
 YB0oGoBwW6aombZQrKdbBiQlf5H2IKLjAILQRfgQAcJID/fAy7m3vAbqIPmvWgOtCXGv8+l/d0J8MCCo9T5wTB/hIaKvv8GEi9/gbDd/PlidVOm4ds8rIftG
 Wr7OKzxKnInzsh+8E7x9E8JHXmQobL4/RWYuP9shvHU41Tk0JRauhJ919UmWFoPg3af/Rr7/tYXIy66IwUfiF7cDxekrvmxiBV95oYnNnxE=
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
 ip/xfrm_state.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index ddf784ca..779ccf0e 100644
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
-- 
2.21.3

