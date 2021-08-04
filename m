Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386823DFDCC
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbhHDJSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbhHDJSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:18:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83472C06179B
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 02:18:40 -0700 (PDT)
Received: from localhost ([::1]:33036 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mBD2r-0000qt-4E; Wed, 04 Aug 2021 11:18:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [iproute PATCH RESEND] tc: u32: Fix key folding in sample option
Date:   Wed,  4 Aug 2021 11:18:28 +0200
Message-Id: <20210804091828.3783-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
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
Resending because the original post was archived in Patchwork.
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
2.32.0

