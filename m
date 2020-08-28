Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3178255D3B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgH1O7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:59:13 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53493 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgH1O7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 10:59:12 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud7.xs4all.net with ESMTPSA
        id BfqNk0dqyooQSBfqOkDwfl; Fri, 28 Aug 2020 16:59:09 +0200
Date:   Fri, 28 Aug 2020 16:59:07 +0200
From:   Antony Antony <antony@phenome.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next] ip xfrm: support printing XFRMA_SET_MARK_MASK
 attribute in states
Message-ID: <20200828145907.GA17185@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CMAE-Envelope: MS4wfOeCd9jfhzOSvvsZqT/eMjUoF49T1fnmgWXrJ7gdjR0S4z3xo4qrUZ/4Wrv1B6GROWC+IJ6kn7Ehp/aah/kmKllJ/6XIOugqxjkUjpfymwxxrDcRhxV2
 JwDrXOAKAWgTLpSZasIW/pvwqfk4JFl0uNapRAEWQ/oQKnKnqfIyXXZsjYjkdeqLjhoEcimWQlHVbTWrZGG3ssrcPNAm/KyeWpenn5F6l8IcS1r1feDc/RAM
 4M9337yf6nLMJNmCRJKGprTnkIwIdBZsl3zVJcRoQZ0b0zUvNj0flCLeo5lCLyi26+8WrH4cLsE/mJ1kvZruLQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XFRMA_SET_MARK_MASK attribute is set in states (4.19+).
It is the mask of XFRMA_SET_MARK(a.k.a. XFRMA_OUTPUT_MARK in 4.18)

sample output: note the output-mark mask
ip xfrm state
	src 192.1.2.23 dst 192.1.3.33
	proto esp spi 0xSPISPI reqid REQID mode tunnel
	replay-window 32 flag af-unspec
	output-mark 0x3/0xffffff
	aead rfc4106(gcm(aes)) 0xENCAUTHKEY 128
	if_id 0x1

Signed-off-by: Antony Antony <antony@phenome.org>
---
 ip/ipxfrm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index cac8ba25..e4a72bd0 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -649,6 +649,10 @@ static void xfrm_output_mark_print(struct rtattr *tb[], FILE *fp)
 	__u32 output_mark = rta_getattr_u32(tb[XFRMA_OUTPUT_MARK]);
 
 	fprintf(fp, "output-mark 0x%x", output_mark);
+	if (tb[XFRMA_SET_MARK_MASK]) {
+		__u32 mask = rta_getattr_u32(tb[XFRMA_SET_MARK_MASK]);
+		fprintf(fp, "/0x%x", mask);
+	}
 }
 
 int xfrm_parse_mark(struct xfrm_mark *mark, int *argcp, char ***argvp)
-- 
2.21.3

