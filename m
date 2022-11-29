Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5227963BA45
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiK2HJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiK2HJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:11 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A1C391F7;
        Mon, 28 Nov 2022 23:09:10 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nF8XM1Bnr/Qv5MtuKPAYXJRVg+7rYkUBNR+4U/ZUOLg=;
        b=m2jXhCCTzBhS1MraKp8Cj9m3Y9ILX7ZqD8KPJzeujxI7x+UbRMZXSWuyNjB3iQrI/YPBC7
        JajuWZfTYxAkMoLwX8dHDB7j+Oz14L4lDLBbUgrYbSYXP0Tl4Pmvvfjsxz9fq6ZqlEuYcT
        3iskEX7jPM33r89Unl3fwFySSD+yLrA=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 1/7] selftests/bpf: Use if_nametoindex instead of reading the /sys/net/class/*/ifindex
Date:   Mon, 28 Nov 2022 23:08:54 -0800
Message-Id: <20221129070900.3142427-2-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

When switching netns, the setns_by_fd() is doing dances in mount/umounting
the /sys directories.  One reason is the tc_redirect.c test is depending
on the /sys/net/class/*/ifindex instead of using the if_nametoindex().
if_nametoindex() uses ioctl() to get the ifindex.

This patch is to move all /sys/net/class/*/ifindex usages to
if_nametoindex().  The current code checks ifindex >= 0 which is
incorrect.  ifindex > 0 should be checked instead.  This patch also
stores ifindex_veth_src and ifindex_veth_dst since the latter patch
will need them.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 46 ++++++++-----------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index cb6a53b3e023..2d85742efdd3 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -11,12 +11,12 @@
  */
 
 #include <arpa/inet.h>
-#include <linux/if.h>
 #include <linux/if_tun.h>
 #include <linux/limits.h>
 #include <linux/sysctl.h>
 #include <linux/time_types.h>
 #include <linux/net_tstamp.h>
+#include <net/if.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <sys/stat.h>
@@ -115,7 +115,9 @@ static void netns_setup_namespaces_nofail(const char *verb)
 }
 
 struct netns_setup_result {
+	int ifindex_veth_src;
 	int ifindex_veth_src_fwd;
+	int ifindex_veth_dst;
 	int ifindex_veth_dst_fwd;
 };
 
@@ -139,27 +141,6 @@ static int get_ifaddr(const char *name, char *ifaddr)
 	return 0;
 }
 
-static int get_ifindex(const char *name)
-{
-	char path[PATH_MAX];
-	char buf[32];
-	FILE *f;
-	int ret;
-
-	snprintf(path, PATH_MAX, "/sys/class/net/%s/ifindex", name);
-	f = fopen(path, "r");
-	if (!ASSERT_OK_PTR(f, path))
-		return -1;
-
-	ret = fread(buf, 1, sizeof(buf), f);
-	if (!ASSERT_GT(ret, 0, "fread ifindex")) {
-		fclose(f);
-		return -1;
-	}
-	fclose(f);
-	return atoi(buf);
-}
-
 #define SYS(fmt, ...)						\
 	({							\
 		char cmd[1024];					\
@@ -182,11 +163,20 @@ static int netns_setup_links_and_routes(struct netns_setup_result *result)
 	if (get_ifaddr("veth_src_fwd", veth_src_fwd_addr))
 		goto fail;
 
-	result->ifindex_veth_src_fwd = get_ifindex("veth_src_fwd");
-	if (result->ifindex_veth_src_fwd < 0)
+	result->ifindex_veth_src = if_nametoindex("veth_src");
+	if (!ASSERT_GT(result->ifindex_veth_src, 0, "ifindex_veth_src"))
 		goto fail;
-	result->ifindex_veth_dst_fwd = get_ifindex("veth_dst_fwd");
-	if (result->ifindex_veth_dst_fwd < 0)
+
+	result->ifindex_veth_src_fwd = if_nametoindex("veth_src_fwd");
+	if (!ASSERT_GT(result->ifindex_veth_src_fwd, 0, "ifindex_veth_src_fwd"))
+		goto fail;
+
+	result->ifindex_veth_dst = if_nametoindex("veth_dst");
+	if (!ASSERT_GT(result->ifindex_veth_dst, 0, "ifindex_veth_dst"))
+		goto fail;
+
+	result->ifindex_veth_dst_fwd = if_nametoindex("veth_dst_fwd");
+	if (!ASSERT_GT(result->ifindex_veth_dst_fwd, 0, "ifindex_veth_dst_fwd"))
 		goto fail;
 
 	SYS("ip link set veth_src netns " NS_SRC);
@@ -1034,8 +1024,8 @@ static void test_tc_redirect_peer_l3(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK_PTR(skel, "test_tc_peer__open"))
 		goto fail;
 
-	ifindex = get_ifindex("tun_fwd");
-	if (!ASSERT_GE(ifindex, 0, "get_ifindex tun_fwd"))
+	ifindex = if_nametoindex("tun_fwd");
+	if (!ASSERT_GT(ifindex, 0, "if_indextoname tun_fwd"))
 		goto fail;
 
 	skel->rodata->IFINDEX_SRC = ifindex;
-- 
2.30.2

