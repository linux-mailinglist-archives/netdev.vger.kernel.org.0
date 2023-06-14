Return-Path: <netdev+bounces-10560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4106172F0F9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 212BD1C20A86
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C5B194;
	Wed, 14 Jun 2023 00:28:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A3E160
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986FAC433C8;
	Wed, 14 Jun 2023 00:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686702481;
	bh=AgIAMuUI/VRd+VfzG2wO9Vzk99A9i5L5hN+b9X4+U9E=;
	h=From:To:Cc:Subject:Date:From;
	b=LKCRfpIfK/O2+U6/lYsybRTCrsfmYEGo/amdh0NxXoNDz3ZJxHBPNxQa89qQ0so/f
	 b9D6XDHOwGIQLaz03RyqW27ZF7BxhBSPV3AtFdmUYOvFL2ris+32BjaKPnH1I8PRYK
	 Gshe6g6GjSBo2BtWhkSNnCnXGVSkdmhIid+0t4NpcRDLAKORzbYefKrVKRNpeujpXZ
	 gLS7na7LDMKhhn4MrWPVREM/EpoTg56mQ9339nmgaBXafNnziq6GAo/WbXBiHa1zqT
	 PkTMXr+VpPVtAVX26OvOQ6rfwMhBSiq5VuOUUp5utpQs47mUnVRm+iUg6cl2R45Vc8
	 gel4Rx1Zj+20A==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tools: ynl: work around stale system headers
Date: Tue, 13 Jun 2023 17:28:00 -0700
Message-Id: <20230614002800.2034459-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The inability to include the uAPI headers directly in tools/
is one of the bigger annoyances of compiling user space code.
Most projects trade the pain for smaller inconvenience of having
to copy the headers under tools/include.

In case of netlink headers I think that we can avoid both.
Netlink family headers are simple and should be self-contained.
We can try to twiddle the Makefile a little to force-include
just the family header, and use system headers for the rest.

This works fairly well. There are two warts - for some reason
if we specify -include $path/family.h as a compilation flag,
the #ifdef header guard does not seem to work. So we need
to throw the guard in on the command line as well. Seems like
GCC detects that the header is different and tries to include
both. Second problem is that make wants hash sign to be escaped
or not depending on the version. Sigh.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/Makefile.deps      | 28 ++++++++++++++++++++++++++++
 tools/net/ynl/generated/Makefile |  6 ++++--
 tools/net/ynl/samples/Makefile   |  4 +++-
 3 files changed, 35 insertions(+), 3 deletions(-)
 create mode 100644 tools/net/ynl/Makefile.deps

diff --git a/tools/net/ynl/Makefile.deps b/tools/net/ynl/Makefile.deps
new file mode 100644
index 000000000000..524fc4bb586b
--- /dev/null
+++ b/tools/net/ynl/Makefile.deps
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Try to include uAPI headers from the kernel uapi/ path.
+# Most code under tools/ requires the respective kernel uAPI headers
+# to be copied to tools/include. The duplication is annoying.
+# All the family headers should be self-contained. We avoid the copying
+# by selectively including just the uAPI header of the family directly
+# from the kernel sources.
+
+UAPI_PATH:=../../../../include/uapi/
+
+# If the header does not exist at all in the system path - let the
+# compiler fall back to the kernel header via -Idirafter.
+# GCC seems to ignore header guard if the header is different, so we need
+# to specify the -D$(hdr_guard).
+# And we need to define HASH indirectly because GNU Make 4.2 wants it escaped
+# and Gnu Make 4.4 wants it without escaping.
+
+HASH := \#
+
+get_hdr_inc=$(if $(shell echo "$(HASH)include <linux/$(2)>" | \
+			 cpp >>/dev/null 2>/dev/null && echo yes),\
+		-D$(1) -include $(UAPI_PATH)/linux/$(2))
+
+CFLAGS_devlink:=$(call get_hdr_inc,_UAPI_LINUX_DEVLINK_H_,devlink.h)
+CFLAGS_ethtool:=$(call get_hdr_inc,_LINUX_ETHTOOL_NETLINK_H_,ethtool_netlink.h)
+CFLAGS_handshake:=$(call get_hdr_inc,_UAPI_LINUX_HANDSHAKE_H,handshake.h)
+CFLAGS_netdev:=$(call get_hdr_inc,_UAPI_LINUX_NETDEV_H,netdev.h)
diff --git a/tools/net/ynl/generated/Makefile b/tools/net/ynl/generated/Makefile
index f15c24893296..f8817d2e56e4 100644
--- a/tools/net/ynl/generated/Makefile
+++ b/tools/net/ynl/generated/Makefile
@@ -2,11 +2,13 @@
 
 CC=gcc
 CFLAGS=-std=gnu11 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
-	-I../lib/
+	-I../lib/ -idirafter $(UAPI_PATH)
 ifeq ("$(DEBUG)","1")
   CFLAGS += -g -fsanitize=address -fsanitize=leak -static-libasan
 endif
 
+include ../Makefile.deps
+
 YNL_GEN_ARG_ethtool:=--user-header linux/ethtool_netlink.h \
 	--exclude-op stats-get
 
@@ -33,7 +35,7 @@ protos.a: $(OBJS)
 
 %-user.o: %-user.c %-user.h
 	@echo -e "\tCC $@"
-	@$(COMPILE.c) -c -o $@ $<
+	@$(COMPILE.c) $(CFLAGS_$*) -o $@ $<
 
 clean:
 	rm -f *.o
diff --git a/tools/net/ynl/samples/Makefile b/tools/net/ynl/samples/Makefile
index 714316cad45f..f2db8bb78309 100644
--- a/tools/net/ynl/samples/Makefile
+++ b/tools/net/ynl/samples/Makefile
@@ -1,8 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
+include ../Makefile.deps
+
 CC=gcc
 CFLAGS=-std=gnu11 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
-	-I../lib/ -I../generated/
+	-I../lib/ -I../generated/ -idirafter $(UAPI_PATH)
 ifeq ("$(DEBUG)","1")
   CFLAGS += -g -fsanitize=address -fsanitize=leak -static-libasan
 endif
-- 
2.40.1


