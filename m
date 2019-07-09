Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3762D76
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfGIBe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:34:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32929 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIBe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:34:59 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so24696920iog.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RHK7SlJqiYa2Rq9rqHsf5d7QBoTdkJldScxSF9BOtuU=;
        b=q6cAO1OXcn4mBQoyQDcYfjOUN54zEwYE564Q5vLO0th1IZtP50qfdKpZvc8m0aKBZP
         iUGUBMugaRSI+xQC8dG9eHlMmkxCFSapiutHg4oWEd/IzKmKeGT3npIDBmzOPWwr7mjq
         2u4zhb8Bkw/DbLy75QzxtiM3PmLj/5uKIy/xHG0o6WnSOpHoYvmjMq+5rT3Z7t8A4Qhy
         Hy5VvlTamZ86ZfmSGXPl8UBUakuHNBlLbdzNlQ2JN2O8w4nVOd3Ss5SWLCSeZZZi6Q39
         zPIIeW58aDeijOGox2U4hvnW+4QHipsW2yRqpcakG8JiHcAv1isf/GgvpEbBm79yxgoJ
         0V6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RHK7SlJqiYa2Rq9rqHsf5d7QBoTdkJldScxSF9BOtuU=;
        b=kETKDBwfu8g1f92g0Ggkd5PKHziSGOhbPo+6KIq+DG7mEP+4TRvsFD/d7Bii7bpglT
         GqpZ4ufvExi+1AhcbTiuR1Hl0XU//vgsUs5Loy0cs4Ak07UTdIvpvW3B6KEPTnT6/N9I
         +CmdYOI6NSJvOcoxIkjc6XvHUunyDfpFJZ0tLj2ZGzQkAR6bdL32CJkmh/9x513uEDFi
         fjWggti/r+4chliTDJqtFsQs0AvFAvh8Y6zx+AlvaSZPhXjmQjDeSHDXxyf3Ol85Dgu5
         yffI2qi9tT8XEiW8CivEAGmTAfojNMuEPVvfYX5bciJn9TdAGP18l0Kas3UBemsiNubL
         MZmA==
X-Gm-Message-State: APjAAAV0vo46qgpA995XEEvAEdpDmcT7pxa9J8aZYBGBeRRkiLbJYo3P
        cA5l9Ycv7/TzWVYxx93nklnLIQ==
X-Google-Smtp-Source: APXvYqxKsK+ZI2Ot3AHR2DwtE32MQJIZn52cbGqDGj02KnAKLvSEr/KBpiue669QdlBAhEQu7gCIQw==
X-Received: by 2002:a05:6602:2256:: with SMTP id o22mr21326732ioo.95.1562636097992;
        Mon, 08 Jul 2019 18:34:57 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:80be:fc0b:d6c4:7dbc])
        by smtp.gmail.com with ESMTPSA id n17sm17894248iog.63.2019.07.08.18.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 18:34:57 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 1/2] tc-testing: Allow tdc plugins to see test case data
Date:   Mon,  8 Jul 2019 21:34:26 -0400
Message-Id: <1562636067-1338-2-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
References: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of only passing the test case name and ID, pass the
entire current test case down to the plugins. This change
allows plugins to start accepting commands and directives
from the test cases themselves, for greater flexibility
in testing.

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
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

