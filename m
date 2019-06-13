Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9501D44A16
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfFMSAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfFMSAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:00:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AB2085A07;
        Thu, 13 Jun 2019 18:00:27 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-117-172.ams2.redhat.com [10.36.117.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0CF11001B05;
        Thu, 13 Jun 2019 18:00:24 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next v2] Makefile: use make -C to change directory
Date:   Thu, 13 Jun 2019 19:59:29 +0200
Message-Id: <3734f49cbe4b7543f09236d02cbe78b515af1e28.1560448299.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 13 Jun 2019 18:00:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make provides a handy -C option to change directory before reading
the makefiles or doing anything else.

Use that instead of the "cd dir && make && cd .." pattern, thus
simplifying sintax for some makefiles.

Changes from v1:
- Drop an obviously wrong leftover in testsuite/iproute2/Makefile

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 Makefile                    | 3 ++-
 testsuite/Makefile          | 6 +++---
 testsuite/iproute2/Makefile | 6 +++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 48f469b0d0a85..a87826fee84dd 100644
--- a/Makefile
+++ b/Makefile
@@ -114,7 +114,8 @@ clobber:
 distclean: clobber
 
 check: all
-	cd testsuite && $(MAKE) && $(MAKE) alltests
+	$(MAKE) -C testsuite
+	$(MAKE) -C testsuite alltests
 	@if command -v man >/dev/null 2>&1; then \
 		echo "Checking manpages for syntax errors..."; \
 		$(MAKE) -C man check; \
diff --git a/testsuite/Makefile b/testsuite/Makefile
index 7f247bbc1c803..94a4a8c646ef7 100644
--- a/testsuite/Makefile
+++ b/testsuite/Makefile
@@ -26,10 +26,10 @@ endif
 .PHONY: compile listtests alltests configure $(TESTS)
 
 configure:
-	echo "Entering iproute2" && cd iproute2 && $(MAKE) configure && cd ..;
+	$(MAKE) -C iproute2 configure
 
 compile: configure generate_nlmsg
-	echo "Entering iproute2" && cd iproute2 && $(MAKE) && cd ..;
+	$(MAKE) -C iproute2
 
 listtests:
 	@for t in $(TESTS); do \
@@ -51,7 +51,7 @@ clean: testclean
 	$(MAKE) -C tools clean
 
 distclean: clean
-	echo "Entering iproute2" && cd iproute2 && $(MAKE) distclean && cd ..;
+	$(MAKE) -C iproute2 distclean
 
 $(TESTS): generate_nlmsg testclean
 ifeq (,$(IPVERS))
diff --git a/testsuite/iproute2/Makefile b/testsuite/iproute2/Makefile
index b8a7d5153175a..f8946058b3a99 100644
--- a/testsuite/iproute2/Makefile
+++ b/testsuite/iproute2/Makefile
@@ -4,7 +4,7 @@ SUBDIRS := $(filter-out Makefile,$(wildcard *))
 
 all: configure
 	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && cd $$dir && $(MAKE) && cd ..; \
+		$(MAKE) -C $$dir; \
 	done
 
 link:
@@ -19,12 +19,12 @@ configure: link
 
 clean: link
 	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && cd $$dir && $(MAKE) clean && cd ..; \
+		$(MAKE) -C $$dir clean; \
 	done
 
 distclean: clean
 	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && cd $$dir && $(MAKE) distclean && cd ..; \
+		$(MAKE) -C $$dir distclean; \
 	done
 
 show: link
-- 
2.20.1

