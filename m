Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E735B3DC2
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389272AbfIPPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:36:35 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:58118 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389266AbfIPPge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:36:34 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id AF32131965C;
        Mon, 16 Sep 2019 17:36:32 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, julien.floret@6wind.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Matt Ellison <matt@arroyo.io>
Subject: [PATCH iproute2] link_xfrm: don't forcce to set phydev
Date:   Mon, 16 Sep 2019 17:36:27 +0200
Message-Id: <20190916153627.19458-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since linux commit 22d6552f827e ("xfrm interface: fix management of
phydev"), phydev is not mandatory anymore.

Note that it also could be useful before the above commit to not force the
user to put a phydev (the kernel was checking it anyway).
For example, it was useful to not set it in case of x-netns, because the
phydev is not available in the current netns:

Before the patch:
$ ip netns add foo
$ ip link add xfrm1 type xfrm dev eth1 if_id 1
$ ip link set xfrm1 netns foo
$ ip -n foo link set xfrm1 type xfrm dev eth1 if_id 2
Cannot find device "eth1"
$ ip -n foo link set xfrm1 type xfrm if_id 2
must specify physical device

CC: Matt Ellison <matt@arroyo.io>
Fixes: 286446c1e8c7 ("ip: support for xfrm interfaces")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=22d6552f827e
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/link_xfrm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/ip/link_xfrm.c b/ip/link_xfrm.c
index 7a3285b42045..a28f308d5610 100644
--- a/ip/link_xfrm.c
+++ b/ip/link_xfrm.c
@@ -17,7 +17,7 @@ static void xfrm_print_help(struct link_util *lu, int argc, char **argv,
 			    FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %-4s dev PHYS_DEV [ if_id IF-ID ]\n"
+		"Usage: ... %-4s dev [ PHYS_DEV ] [ if_id IF-ID ]\n"
 		"\n"
 		"Where: IF-ID := { 0x0..0xffffffff }\n",
 		lu->id);
@@ -46,12 +46,8 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--; argv++;
 	}
 
-	if (link) {
+	if (link)
 		addattr32(n, 1024, IFLA_XFRM_LINK, link);
-	} else {
-		fprintf(stderr, "must specify physical device\n");
-		return -1;
-	}
 
 	return 0;
 }
-- 
2.21.0

