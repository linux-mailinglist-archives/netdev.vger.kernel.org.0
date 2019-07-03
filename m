Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053215DC97
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfGCCmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:42:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37499 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCCmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:42:03 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so1217642iok.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=52S7tfnGwupTucYk3kPiJmVpaIGDH/ktLPp0Mv0+9HI=;
        b=K5lPMF9pNwmSY4N+lzwNXWvyMAgY6AE4DI92KpJ9A2fDJn78huAV3U04gb/XV87OTo
         sx8tygkOSGzRkKJVHv+OhanWbOuzTWgcTpU6Ed5ZaA7AKKlHxhCi8De33EaXRuNoCahC
         h3alwI2nc7xrOIs6XdtjsHLrStUcxE1RX5gnpz8l/5bMAfuWyUAfW2rVdNHxh1PUPed1
         CV1M3gQUDB/STe0iX/xuI5MCUwDFpAA16bSDoY/ETvo4njploVBoH+gk635/+K0AXMA4
         wSeZEJrRQeVe6GykRljKH89gG/ePbomg0zR4oDMT3oYaF2+Xv9doaXzLp1RWwxhqLt8k
         KSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=52S7tfnGwupTucYk3kPiJmVpaIGDH/ktLPp0Mv0+9HI=;
        b=tyz1iz2hSj4I2E/HoOT9UTX/HDwEUHFTSnUobg/zZwIAZtnm/DCJ78F4k/bZBu2I28
         EK2Y/f2HXijOslU8PUWXImbp92DzLi4p9yzsoGOQ9NQwohibHYrY/UJJE2FKq1bXADGf
         pdKBWFcD75Cyc/4xuFNswisHg4Iq8MOQtRjnKv9PDseOEuWLdyi3V33JvcnQJJGen/qz
         s7STLEIa7Fyxyc2No/+yiM544uViTd7ujD95Q9h1HH83wF+eLmSqLCHQTV68iAto3oys
         SDJoQem+6Kh8Ca8Qsc/KpQfHpgJ3xYYXQVHUXfRt/if8YTq+vP7RGkp2ElNxv1Qrx3dg
         egzA==
X-Gm-Message-State: APjAAAW8st5JpbljtIQ/1JKNn0J96mgPCwJ/AkIo5dH3RSddSPuTEBPT
        SZo0PNAZ3wfqL5k+uz0XAVXbtw==
X-Google-Smtp-Source: APXvYqzovCghJKQzkMQbofXkDql/RfW8f2670KGrpYGAQ06ZqxY12GLHp0K4slmrU8MTJaopcsI8bw==
X-Received: by 2002:a5d:8844:: with SMTP id t4mr2734145ios.91.1562121722410;
        Tue, 02 Jul 2019 19:42:02 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:57:4bb:2258:42f6])
        by smtp.gmail.com with ESMTPSA id w26sm1638114iom.59.2019.07.02.19.42.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 19:42:02 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 2/3] tc-testing: Allow tdc plugins to see test case data
Date:   Tue,  2 Jul 2019 22:41:20 -0400
Message-Id: <1562121681-9365-3-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
References: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of only passing the test case name and ID, pass the
entire current test case down to the plugins. This change
allows plugins to start accepting commands and directives
from the test cases themselves, for greater flexibility
in testing.
---
 tools/testing/selftests/tc-testing/TdcPlugin.py |  5 ++---
 tools/testing/selftests/tc-testing/tdc.py       | 10 +++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/TdcPlugin.py b/tools/testing/selftests/tc-testing/TdcPlugin.py
index b980a56..79f3ca8 100644
--- a/tools/testing/selftests/tc-testing/TdcPlugin.py
+++ b/tools/testing/selftests/tc-testing/TdcPlugin.py
@@ -18,12 +18,11 @@ class TdcPlugin:
         if self.args.verbose > 1:
             print(' -- {}.post_suite'.format(self.sub_class))
 
-    def pre_case(self, testid, test_name, test_skip):
+    def pre_case(self, caseinfo, test_skip):
         '''run commands before test_runner does one test'''
         if self.args.verbose > 1:
             print(' -- {}.pre_case'.format(self.sub_class))
-        self.args.testid = testid
-        self.args.test_name = test_name
+        self.args.caseinfo = caseinfo
         self.args.test_skip = test_skip
 
     def post_case(self):
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 1afa803..de7da9a 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -126,15 +126,15 @@ class PluginMgr:
         for pgn_inst in reversed(self.plugin_instances):
             pgn_inst.post_suite(index)
 
-    def call_pre_case(self, testid, test_name, *, test_skip=False):
+    def call_pre_case(self, caseinfo, *, test_skip=False):
         for pgn_inst in self.plugin_instances:
             try:
-                pgn_inst.pre_case(testid, test_name, test_skip)
+                pgn_inst.pre_case(caseinfo, test_skip)
             except Exception as ee:
                 print('exception {} in call to pre_case for {} plugin'.
                       format(ee, pgn_inst.__class__))
                 print('test_ordinal is {}'.format(test_ordinal))
-                print('testid is {}'.format(testid))
+                print('testid is {}'.format(caseinfo['id']))
                 raise
 
     def call_post_case(self):
@@ -379,14 +379,14 @@ def run_one_test(pm, args, index, tidx):
             res = TestResult(tidx['id'], tidx['name'])
             res.set_result(ResultState.skip)
             res.set_errormsg('Test case designated as skipped.')
-            pm.call_pre_case(tidx['id'], tidx['name'], test_skip=True)
+            pm.call_pre_case(tidx, test_skip=True)
             pm.call_post_execute()
             return res
 
     # populate NAMES with TESTID for this test
     NAMES['TESTID'] = tidx['id']
 
-    pm.call_pre_case(tidx['id'], tidx['name'])
+    pm.call_pre_case(tidx)
     prepare_env(args, pm, 'setup', "-----> prepare stage", tidx["setup"])
 
     if (args.verbose > 0):
-- 
2.7.4

