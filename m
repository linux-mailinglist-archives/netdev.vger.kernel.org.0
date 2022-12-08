Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930D964708E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLHNNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHNNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:13:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAEC6E55E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 05:13:50 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B373820BEE
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670505228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc;
        bh=FA9kNyWapP3+XytLWF4Cj7RGbK6DK3xyLVbcJCeKmQk=;
        b=ourKxSRBO3LGDpk/dOoDoumzC4OUrdwikNk61ujwxwJuqhkV5E7IhrxKPXatHDy+NPeY6H
        WCkWiFu/fssMCRbMcshO1o3g2KoqMY6Izbc8j5n/Fu3suT9uwgg41t/yCjm7OEpZwP5eoi
        nM9hoFHGU0JfeYc5q6Se6FuWn3bSUmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670505228;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc;
        bh=FA9kNyWapP3+XytLWF4Cj7RGbK6DK3xyLVbcJCeKmQk=;
        b=1MtdbAJLcn5bmNkzhbCIa9oIilxhtTQ95NEFy6rp1aFRz0Hopjf8Y31F0LceVsByzaFTH1
        9UJjY63azP+eINBQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BC1922C142;
        Thu,  8 Dec 2022 13:13:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7B7166045E; Thu,  8 Dec 2022 14:13:48 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] misc: header includes cleanup
To:     netdev@vger.kernel.org
Message-Id: <20221208131348.7B7166045E@lion.mk-sys.cz>
Date:   Thu,  8 Dec 2022 14:13:48 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An attempt to build with -std=c99 or -std=c11 revealed few problems with
system header includes.

- strcasecmp() and strncasecmp() need <strings.h>
- ioctl() needs <linux/ioctl.h>
- struct ifreq needs <linux/if.h> (unless _USE_MISC is defined)
- fileno() needs _POSIX_C_SOURCE
- strdup() needs _POSIX_C_SOURCE >= _200809L
- inet_aton() would require _DEFAULT_SOURCE

Add missing includes and define _POSIX_C_SOURCE=200809L. Replace
inet_aton() with inet_pton(); the latter has slightly different
semantics (it does not support addresses like "1.2.3" or "1.2") but the
function is only called in code which is not actually used.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am   | 2 +-
 ethtool.c     | 4 +++-
 internal.h    | 2 +-
 netlink/fec.c | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fcc912edd7e4..663f40a07b7d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -Wall -Wextra
+AM_CFLAGS = -Wall -Wextra -D_POSIX_C_SOURCE=200809L
 AM_CPPFLAGS = -I$(top_srcdir)/uapi
 LDADD = -lm
 
diff --git a/ethtool.c b/ethtool.c
index 3207e49137c4..526be4cfb523 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -31,6 +31,7 @@
 
 #include "internal.h"
 #include <string.h>
+#include <strings.h>
 #include <stdlib.h>
 #include <sys/stat.h>
 #include <stdio.h>
@@ -46,6 +47,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
+#include <linux/ioctl.h>
 #include <linux/sockios.h>
 #include <linux/netlink.h>
 
@@ -301,7 +303,7 @@ static void parse_generic_cmdline(struct cmd_context *ctx,
 				case CMDL_IP4: {
 					u32 *p = info[idx].wanted_val;
 					struct in_addr in;
-					if (!inet_aton(argp[i], &in))
+					if (!inet_pton(AF_INET, argp[i], &in))
 						exit_bad_args();
 					*p = in.s_addr;
 					break;
diff --git a/internal.h b/internal.h
index dd7d6ac70ad4..b80f77afa4c0 100644
--- a/internal.h
+++ b/internal.h
@@ -21,7 +21,7 @@
 #include <unistd.h>
 #include <endian.h>
 #include <sys/ioctl.h>
-#include <net/if.h>
+#include <linux/if.h>
 
 #include "json_writer.h"
 #include "json_print.h"
diff --git a/netlink/fec.c b/netlink/fec.c
index 695724eff896..6027dc05b992 100644
--- a/netlink/fec.c
+++ b/netlink/fec.c
@@ -9,6 +9,7 @@
 #include <ctype.h>
 #include <inttypes.h>
 #include <string.h>
+#include <strings.h>
 #include <stdio.h>
 
 #include "../internal.h"
-- 
2.38.1

