Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C07133F07
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgAHKNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:13:01 -0500
Received: from a3.inai.de ([88.198.85.195]:34310 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgAHKNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 05:13:01 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2020 05:13:00 EST
Received: by a3.inai.de (Postfix, from userid 65534)
        id 1745E587694C3; Wed,  8 Jan 2020 11:04:27 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id B382C58742E72;
        Wed,  8 Jan 2020 11:04:24 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, jengelh@inai.de
Subject: [PATCH] build: fix build failure with -fno-common
Date:   Wed,  8 Jan 2020 11:04:24 +0100
Message-Id: <20200108100424.26642-1-jengelh@inai.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ make CCOPTS=-fno-common
gcc ... -o ip
ld: rt_names.o (symbol from plugin): in function "rtnl_rtprot_n2a":
(.text+0x0): multiple definition of "numeric"; ip.o (symbol from plugin):(.text+0x0): first defined here

gcc ... -o tipc
ld: ../lib/libutil.a(utils.o):(.bss+0xc): multiple definition of `pretty';
tipc.o:tipc.c:28: first defined here

References: https://bugzilla.opensuse.org/1160244
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ** this is for iproute2 **

 include/rt_names.h | 2 ++
 ip/ip.c            | 2 +-
 misc/ss.c          | 2 +-
 tc/tc.c            | 2 +-
 tipc/tipc.c        | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index 62ebbd6a..7afce170 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -33,4 +33,6 @@ int ll_proto_a2n(unsigned short *id, const char *buf);
 const char *nl_proto_n2a(int id, char *buf, int len);
 int nl_proto_a2n(__u32 *id, const char *arg);
 
+extern int numeric;
+
 #endif
diff --git a/ip/ip.c b/ip/ip.c
index fed26f8d..90392c2a 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -23,6 +23,7 @@
 #include "ip_common.h"
 #include "namespace.h"
 #include "color.h"
+#include "rt_names.h"
 
 int preferred_family = AF_UNSPEC;
 int human_readable;
@@ -36,7 +37,6 @@ int timestamp;
 int force;
 int max_flush_loops = 10;
 int batch_mode;
-int numeric;
 bool do_all;
 
 struct rtnl_handle rth = { .fd = -1 };
diff --git a/misc/ss.c b/misc/ss.c
index 95f1d37a..1e8bca5a 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -35,6 +35,7 @@
 #include "libnetlink.h"
 #include "namespace.h"
 #include "SNAPSHOT.h"
+#include "rt_names.h"
 
 #include <linux/tcp.h>
 #include <linux/sock_diag.h>
@@ -121,7 +122,6 @@ static int follow_events;
 static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
-int numeric;
 int oneline;
 
 enum col_id {
diff --git a/tc/tc.c b/tc/tc.c
index 37294b31..b72657ec 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -29,6 +29,7 @@
 #include "tc_util.h"
 #include "tc_common.h"
 #include "namespace.h"
+#include "rt_names.h"
 
 int show_stats;
 int show_details;
@@ -43,7 +44,6 @@ bool use_names;
 int json;
 int color;
 int oneline;
-int numeric;
 
 static char *conf_file;
 
diff --git a/tipc/tipc.c b/tipc/tipc.c
index f85ddee0..60176a04 100644
--- a/tipc/tipc.c
+++ b/tipc/tipc.c
@@ -22,10 +22,10 @@
 #include "node.h"
 #include "peer.h"
 #include "cmdl.h"
+#include "utils.h"
 
 int help_flag;
 int json;
-int pretty;
 
 static void about(struct cmdl *cmdl)
 {
-- 
2.24.1

