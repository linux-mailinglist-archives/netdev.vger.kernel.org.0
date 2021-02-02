Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1498930C9F0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhBBSdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbhBBSbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:31:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9228CC061788
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 10:31:03 -0800 (PST)
Received: from localhost ([::1]:36592 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l70S4-0001CD-Ek; Tue, 02 Feb 2021 19:31:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [iproute PATCH] tc: u32: Fix key folding in sample option
Date:   Tue,  2 Feb 2021 19:30:51 +0100
Message-Id: <20210202183051.21022-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In between Linux kernel 2.4 and 2.6, key folding for hash tables changed
in kernel space. When iproute2 dropped support for the older algorithm,
the wrong code was removed and kernel 2.4 folding method remained in
place. To get things functional for recent kernels again, restoring the
old code alone was not sufficient - additional byteorder fixes were
needed.

While being at it, make use of ffs() and thereby align the code with how
kernel determines the shift width.

Fixes: 267480f55383c ("Backout the 2.4 utsname hash patch.")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Initially I considered changing the kernel's key folding instead as the
old method didn't just ignore key bits beyond the first byte. Yet I am
not sure if this would cause problems with hardware offloading. And
given the fact that this simplified key folding is in place since the
dawn of 2.6, it is probably not such a big problem anyway.
---
 tc/f_u32.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 2ed5254a40d5f..a5747f671e1ea 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -978,6 +978,13 @@ show_k:
 	goto show_k;
 }
 
+static __u32 u32_hash_fold(struct tc_u32_key *key)
+{
+	__u8 fshift = key->mask ? ffs(ntohl(key->mask)) - 1 : 0;
+
+	return ntohl(key->val & key->mask) >> fshift;
+}
+
 static int u32_parse_opt(struct filter_util *qu, char *handle,
 			 int argc, char **argv, struct nlmsghdr *n)
 {
@@ -1110,9 +1117,7 @@ static int u32_parse_opt(struct filter_util *qu, char *handle,
 				}
 				NEXT_ARG();
 			}
-			hash = sel2.keys[0].val & sel2.keys[0].mask;
-			hash ^= hash >> 16;
-			hash ^= hash >> 8;
+			hash = u32_hash_fold(&sel2.keys[0]);
 			htid = ((hash % divisor) << 12) | (htid & 0xFFF00000);
 			sample_ok = 1;
 			continue;
-- 
2.28.0

