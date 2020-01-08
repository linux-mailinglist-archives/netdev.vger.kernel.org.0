Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7690134C3A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgAHT5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:57:12 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:42017 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgAHT5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:57:12 -0500
Received: by mail-io1-f65.google.com with SMTP id n11so4533183iom.9
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 11:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6KOmJ7BgHwRceeS/GeuXO6fsrhGehC/i6W3wAeZP0k=;
        b=HUx+hoF9gG6XkvLTx5IPjllw1PzoUxnnK82Vw24ZxJQg9HjDO692CpHi2FdO+yREff
         pw0ZRvA4XNg7KZK9aGzCvrcQdrEwXHeWZt7aaewEDeqBGLFrWYOh+5sxYQw/p4s2hiae
         s/eMftkWYdgPWliTsD1gUhW3rxaqMT96vNAbvfKDbyMAkbduFfgizs7XT05kBkM8TAln
         rnBT1MZMtnDkiNW7I0b+5f040I+enKsbMWJelCXOwH3SNQAIbo+haM/7JNaJWjM+Otvr
         cqmseypJqsWVN7B4l0EapegEC6uaMVAMMBiMEQoMfk3N3q04WFrNaA95wg+doWVDVoDM
         UL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6KOmJ7BgHwRceeS/GeuXO6fsrhGehC/i6W3wAeZP0k=;
        b=MunAbqcIBzfKiyD4uASuGrjRteCplITpR75vF/x4P07aSpw9hTbCtqHRfedDdX68pQ
         WAMpBs0Q8uWS03OQQggJiB8DSIj2E2Zr2aq0/moJPDBrpDxbZHCmC6mYgUun2pe4k8N2
         r3KseIKyVrlx/i3vMCu/Z2gD6HELcjaBlYEiNkrGMjst1aeFW2cfXZs4t6CQWA9wKe8F
         TnaQQmDnt2GukSW+a/oYjKbtUJ2GOKd+TUNad8bpLZFZ61VO0b43eYbNPxWVrODCluYL
         K4/gPAwnfSozu0S6uMiT85yBYf9CDPSNZvr2u8XEg80o0tJbFP5uvFtwsrhPzGwBxj76
         3khQ==
X-Gm-Message-State: APjAAAWvSacC7k3vn4EP0vORPRTQSuQqByKXBeqB4Tzb3fUwkX4VTIhx
        bVeie0Z17xOjvlRQM3EVc5o/qD7B
X-Google-Smtp-Source: APXvYqwJXVomo6z6+ClCy1DjIAF20LU7y2HPNy47weBTsZr7jvsuf1izdp52G7HtarBKlztPIYeoCA==
X-Received: by 2002:a6b:5b0e:: with SMTP id v14mr4313330ioh.154.1578513431093;
        Wed, 08 Jan 2020 11:57:11 -0800 (PST)
Received: from localhost.localdomain ([216.249.49.15])
        by smtp.googlemail.com with ESMTPSA id w5sm868730iob.26.2020.01.08.11.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 11:57:10 -0800 (PST)
From:   Ethan Sommer <e5ten.arch@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ethan Sommer <e5ten.arch@gmail.com>
Subject: [PATCH iproute2] make yacc usage POSIX compatible
Date:   Wed,  8 Jan 2020 14:57:05 -0500
Message-Id: <20200108195705.15348-1-e5ten.arch@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

config: put YACC in config.mk and use environmental variable if present

ss:
use YACC variable instead of hardcoding bison
place options before source file argument
use -b to specify file prefix instead of output file, as -o isn't POSIX
compatible, this generates ssfilter.tab.c instead of ssfilter.c
replace any references to ssfilter.c with references to ssfilter.tab.c

tc:
use -p flag to set name prefix instead of bison-specific api.prefix
directive
remove unneeded bison-specific directives
use -b instead of -o, replace references to previously generated
emp_ematch.yacc.[ch] with references to newly generated
emp_ematch.tab.[ch]

Signed-off-by: Ethan Sommer <e5ten.arch@gmail.com>
---
 configure       |  2 ++
 misc/.gitignore |  2 +-
 misc/Makefile   |  6 +++---
 tc/.gitignore   |  4 ++--
 tc/Makefile     | 13 ++++++-------
 tc/emp_ematch.l |  2 +-
 tc/emp_ematch.y |  5 -----
 7 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/configure b/configure
index 45fcffb6..f415bf49 100755
--- a/configure
+++ b/configure
@@ -16,9 +16,11 @@ check_toolchain()
     : ${PKG_CONFIG:=pkg-config}
     : ${AR=ar}
     : ${CC=gcc}
+    : ${YACC=bison}
     echo "PKG_CONFIG:=${PKG_CONFIG}" >>$CONFIG
     echo "AR:=${AR}" >>$CONFIG
     echo "CC:=${CC}" >>$CONFIG
+    echo "YACC:=${YACC}" >>$CONFIG
 }
 
 check_atm()
diff --git a/misc/.gitignore b/misc/.gitignore
index f73f7f21..d7df0b02 100644
--- a/misc/.gitignore
+++ b/misc/.gitignore
@@ -1,7 +1,7 @@
 arpd
 ifstat
 ss
-ssfilter.c
+ssfilter.tab.c
 nstat
 lnstat
 rtacct
diff --git a/misc/Makefile b/misc/Makefile
index 6a849af4..1debfb15 100644
--- a/misc/Makefile
+++ b/misc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-SSOBJ=ss.o ssfilter.o
+SSOBJ=ss.o ssfilter.tab.o
 LNSTATOBJ=lnstat.o lnstat_util.o
 
 TARGETS=ss nstat ifstat rtacct lnstat
@@ -27,8 +27,8 @@ rtacct: rtacct.c
 arpd: arpd.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -I$(DBM_INCLUDE) $(CPPFLAGS) $(LDFLAGS) -o arpd arpd.c $(LDLIBS) -ldb
 
-ssfilter.c: ssfilter.y
-	$(QUIET_YACC)bison ssfilter.y -o ssfilter.c
+ssfilter.tab.c: ssfilter.y
+	$(QUIET_YACC)$(YACC) -b ssfilter ssfilter.y
 
 lnstat: $(LNSTATOBJ)
 	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@
diff --git a/tc/.gitignore b/tc/.gitignore
index e8e86c97..0dbe9195 100644
--- a/tc/.gitignore
+++ b/tc/.gitignore
@@ -1,5 +1,5 @@
-*.yacc.c
+*.tab.c
 *.lex.c
 *.output
-*.yacc.h
+*.tab.h
 tc
diff --git a/tc/Makefile b/tc/Makefile
index 14171a28..a378c403 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 TCOBJ= tc.o tc_qdisc.o tc_class.o tc_filter.o tc_util.o tc_monitor.o \
        tc_exec.o m_police.o m_estimator.o m_action.o m_ematch.o \
-       emp_ematch.yacc.o emp_ematch.lex.o
+       emp_ematch.tab.o emp_ematch.lex.o
 
 include ../config.mk
 
@@ -125,7 +125,6 @@ ifneq ($(IPT_LIB_DIR),)
 	CFLAGS += -DIPT_LIB_DIR=\"$(IPT_LIB_DIR)\"
 endif
 
-YACC := bison
 LEX := flex
 CFLAGS += -DYY_NO_INPUT
 
@@ -158,8 +157,8 @@ install: all
 	fi
 
 clean:
-	rm -f $(TCOBJ) $(TCLIB) libtc.a tc *.so emp_ematch.yacc.h; \
-	rm -f emp_ematch.yacc.*
+	rm -f $(TCOBJ) $(TCLIB) libtc.a tc *.so emp_ematch.tab.h; \
+	rm -f emp_ematch.tab.*
 
 q_atm.so: q_atm.c
 	$(QUIET_CC)$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -shared -fpic -o q_atm.so q_atm.c -latm
@@ -178,8 +177,8 @@ ifeq ($(TC_CONFIG_XT),y)
   LDLIBS += $$($(PKG_CONFIG) xtables --libs)
 endif
 
-%.yacc.c: %.y
-	$(QUIET_YACC)$(YACC) $(YACCFLAGS) -o $@ $<
+%.tab.c: %.y
+	$(QUIET_YACC)$(YACC) $(YACCFLAGS) -p ematch_ -b $(basename $(basename $@)) $<
 
 %.lex.c: %.l
 	$(QUIET_LEX)$(LEX) $(LEXFLAGS) -o$@ $<
@@ -187,7 +186,7 @@ endif
 # our lexer includes the header from yacc, so make sure
 # we don't attempt to compile it before the header has
 # been generated as part of the yacc step.
-emp_ematch.lex.o: emp_ematch.yacc.c
+emp_ematch.lex.o: emp_ematch.tab.c
 
 ifneq ($(SHARED_LIBS),y)
 
diff --git a/tc/emp_ematch.l b/tc/emp_ematch.l
index d7a99304..2f4926d4 100644
--- a/tc/emp_ematch.l
+++ b/tc/emp_ematch.l
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 %{
- #include "emp_ematch.yacc.h"
+ #include "emp_ematch.tab.h"
  #include "m_ematch.h"
 
  extern int ematch_argc;
diff --git a/tc/emp_ematch.y b/tc/emp_ematch.y
index a02e831a..4da3daed 100644
--- a/tc/emp_ematch.y
+++ b/tc/emp_ematch.y
@@ -6,11 +6,6 @@
  #include "m_ematch.h"
 %}
 
-%locations
-%token-table
-%define parse.error verbose
-%define api.prefix {ematch_}
-
 %union {
 	unsigned int i;
 	struct bstr *b;
-- 
2.24.1

