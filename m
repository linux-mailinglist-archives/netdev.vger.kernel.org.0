Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018B52736A4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgIUX2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUX2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:28:17 -0400
X-Greylist: delayed 339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Sep 2020 16:28:16 PDT
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBA0C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 16:28:16 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 9588B587774C3; Tue, 22 Sep 2020 01:22:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id BFFC258735898;
        Tue, 22 Sep 2020 01:22:31 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] build: avoid make jobserver warnings
Date:   Tue, 22 Sep 2020 01:22:31 +0200
Message-Id: <20200921232231.11543-1-jengelh@inai.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I observe:

	» make -j8 CCOPTS=-ggdb3
	lib
	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
	make[1]: Nothing to be done for 'all'.
	ip
	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
	    CC       ipntable.o

MFLAGS is a historic variable of some kind; removing it fixes the
jobserver issue.
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index cadda235..5b040415 100644
--- a/Makefile
+++ b/Makefile
@@ -63,7 +63,7 @@ LDLIBS += $(LIBNETLINK)
 all: config.mk
 	@set -e; \
 	for i in $(SUBDIRS); \
-	do echo; echo $$i; $(MAKE) $(MFLAGS) -C $$i; done
+	do echo; echo $$i; $(MAKE) -C $$i; done
 
 .PHONY: clean clobber distclean check cscope version
 
@@ -101,11 +101,11 @@ version:
 
 clean:
 	@for i in $(SUBDIRS) testsuite; \
-	do $(MAKE) $(MFLAGS) -C $$i clean; done
+	do $(MAKE) -C $$i clean; done
 
 clobber:
 	touch config.mk
-	$(MAKE) $(MFLAGS) clean
+	$(MAKE) clean
 	rm -f config.mk cscope.*
 
 distclean: clobber
-- 
2.28.0

