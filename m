Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFDE5F0C9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfGDAqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:46:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38693 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGDAp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:45:59 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so9270832ioa.5
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RHK7SlJqiYa2Rq9rqHsf5d7QBoTdkJldScxSF9BOtuU=;
        b=pz/1pZEpqZKzvjCwryblYlm5TzBXTZ79bh34dYtgekZlnc/frPKC+bMOoqra881RMO
         DBG/c5XYpQi4vKAdcYu2R1s/lj9v8id2Vv2pzcglRW4DOs816EJULPdd2lQQCMITBpnz
         3LMLIX3om3uBXyv+cnbsQkAj3HT1ky1PPwlzo3fvSKv+eaNlwWwL7IuvQJSGzQAH48Nm
         FHhDtbE1W4cNG1gRgdAmHmPhcyOKma1VfHyF+I4JDh/QmFYVO4M/0/DDgoGythnPA+c1
         OTZfizSQJppTMZkhvxSFnO1pPnf/6R6mCr5pHrGABv9jcXQi4A64yvjPvFxliK8Qr+zx
         RHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RHK7SlJqiYa2Rq9rqHsf5d7QBoTdkJldScxSF9BOtuU=;
        b=ry3aXhl8IDCTfS8EMxPD2qlgKeSkZzbA/S0ri1cGb7Y3izSYUGfcFau2Mb94pgk8wQ
         FCnFfrlItJ6CCJtnRi5l/oCF78x0mMk8vy3Di5JWKXDt5Kg6Al45Cy5HABGZQLnhipuX
         oAJysIe6/mpmLXmsb/B/8lDm6CcHVJ3g2cyTfNhvkmfUF+AcmyJNNyNTxm91mUXHiWrU
         W6r7PQX+QYyFImKD5B/Fl/J8cgr2S95rB1WH2Buplw6hV5RmIPua2Y6ZA4pX1pIk2nQc
         e7sjBV1KaojqUe/59ZskYPWr/GAeTi41DVHihi6NcRyoTT5yvrc4U2D4NmRtHZ2VZZEy
         IjDg==
X-Gm-Message-State: APjAAAVPBfNue09dwu+NSrWAyaGVrwGRfVrvc9gCC7ZkoSwGBsE+gEs8
        9P0frx93vSdz24/g3K+aKz2vhg==
X-Google-Smtp-Source: APXvYqzdQYa+cczENRt6f03cb+9WnCIMchrkDSBeUtBG2vpc3iGNeT1Wbvubj+MUsnfXJydCzhxOcA==
X-Received: by 2002:a5d:8195:: with SMTP id u21mr12086889ion.260.1562201158884;
        Wed, 03 Jul 2019 17:45:58 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:4494:a7b3:9aab:d513])
        by smtp.gmail.com with ESMTPSA id l5sm5619776ioq.83.2019.07.03.17.45.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 17:45:58 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH v2 net-next 2/3] tc-testing: Allow tdc plugins to see test case data
Date:   Wed,  3 Jul 2019 20:45:01 -0400
Message-Id: <1562201102-4332-3-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
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

