Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0362E7C14
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgL3TNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:13:48 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57570 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726663AbgL3TNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:48 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@nvidia.com)
        with SMTP; 30 Dec 2020 21:13:01 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BUJD0Cn020823;
        Wed, 30 Dec 2020 21:13:01 +0200
From:   Roi Dayan <roid@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2] build: Fix link errors on some systems
Date:   Wed, 30 Dec 2020 21:11:43 +0200
Message-Id: <1609355503-7981-1-git-send-email-roid@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since moving get_rate() and get_size() from tc to lib, on some
systems we fail to link because of missing the math lib.
Move the link flag from tc makefile to the main makefile.

../lib/libutil.a(utils.o): In function `get_rate':
utils.c:(.text+0x10dc): undefined reference to `floor'
../lib/libutil.a(utils.o): In function `get_size':
utils.c:(.text+0x1394): undefined reference to `floor'
../lib/libutil.a(json_print.o): In function `sprint_size':
json_print.c:(.text+0x14c0): undefined reference to `rint'
json_print.c:(.text+0x14f4): undefined reference to `rint'
json_print.c:(.text+0x157c): undefined reference to `rint'

Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add print_size()")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 Makefile    | 1 +
 tc/Makefile | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e64c65992585..2a604ec58905 100644
--- a/Makefile
+++ b/Makefile
@@ -59,6 +59,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man
 
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
+LDFLAGS += -lm
 
 all: config.mk
 	@set -e; \
diff --git a/tc/Makefile b/tc/Makefile
index 5a517af20b7c..8d91900716c1 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -110,7 +110,7 @@ ifneq ($(TC_CONFIG_NO_XT),y)
 endif
 
 TCOBJ += $(TCMODULES)
-LDLIBS += -L. -lm
+LDLIBS += -L.
 
 ifeq ($(SHARED_LIBS),y)
 LDLIBS += -ldl
-- 
1.8.3.1

