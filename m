Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832A2693CE1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 04:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBMD0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 22:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBMD0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 22:26:51 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B08EF82
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 19:26:50 -0800 (PST)
From:   Sam James <sam@gentoo.org>
To:     sam@gentoo.org
Cc:     dwfreed@mtu.edu, freswa@archlinux.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, toolchain@gentoo.org
Subject: [PATCH] ip: fix UB in strncpy (e.g. truncated ip route output)
Date:   Mon, 13 Feb 2023 03:26:31 +0000
Message-Id: <20230213032631.143810-1-sam@gentoo.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <0011AC38-4823-4D0A-8580-B108D08959C2@gentoo.org>
References: <0011AC38-4823-4D0A-8580-B108D08959C2@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix overlapping buffers passed to strncpy which is UB. format_host_rta_r writes
to the buffer passed to it, so hostname (derived from b1) & b1 partly overlap.

This gets worse with sys-libs/glibc-2.37 where the ip route output can be truncated,
but it was UB anyway and you can see it occurring w/ glibc-2.36.

Bug: https://lore.kernel.org/netdev/0011AC38-4823-4D0A-8580-B108D08959C2@gentoo.org/T/#u
Bug: https://sourceware.org/bugzilla/show_bug.cgi?id=30112
Thanks-to: Doug Freed <dwfreed@mtu.edu>
Signed-off-by: Sam James <sam@gentoo.org>
---
 ip/iproute.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 0bab0fdf..a7cd9543 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -748,6 +748,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 	int ret;
 
 	SPRINT_BUF(b1);
+	SPRINT_BUF(b2);
 
 	if (n->nlmsg_type != RTM_NEWROUTE && n->nlmsg_type != RTM_DELROUTE) {
 		fprintf(stderr, "Not a route: %08x %08x %08x\n",
@@ -809,7 +810,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 				 r->rtm_dst_len);
 		} else {
 			const char *hostname = format_host_rta_r(family, tb[RTA_DST],
-					  b1, sizeof(b1));
+					  b2, sizeof(b2));
 			if (hostname)
 				strncpy(b1, hostname, sizeof(b1) - 1);
 		}
@@ -832,7 +833,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 				 r->rtm_src_len);
 		} else {
 			const char *hostname = format_host_rta_r(family, tb[RTA_SRC],
-					  b1, sizeof(b1));
+					  b2, sizeof(b2));
 			if (hostname)
 				strncpy(b1, hostname, sizeof(b1) - 1);
 		}
-- 
2.39.1

