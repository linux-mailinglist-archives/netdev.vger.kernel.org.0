Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95BC6C699D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCWNgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 09:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCWNgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FC1B2D4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679578525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K27IZX464mWQtsVcC4c4esTy67JhctZOt0kmxbhYXjY=;
        b=Zc3zmKWURbLei22H5T5kWcJIWFvLgPanvxXrfvtmdKrzpuXUHARcVtb+kgsDX8bKA93V8V
        k5gMbyAxsIB4+6BwtA6l+tsq6N5fpxaxUg8je7wcAxWlU7sMIqbhMnupjnff+P2fmB145T
        V40ScLQTU+zlVdYo7fFyVJqvgMlE0K4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-585wl8wWPr2SbsGScXpv0A-1; Thu, 23 Mar 2023 09:35:19 -0400
X-MC-Unique: 585wl8wWPr2SbsGScXpv0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5A3280D598;
        Thu, 23 Mar 2023 13:35:18 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.225.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B1831410F1C;
        Thu, 23 Mar 2023 13:35:17 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 2/4] selftests: tc-testing: extend the "skip" property
Date:   Thu, 23 Mar 2023 14:34:41 +0100
Message-Id: <29e811befea5e751f938e3bf46ca870ec214d53d.1679569719.git.dcaratti@redhat.com>
In-Reply-To: <cover.1679569719.git.dcaratti@redhat.com>
References: <cover.1679569719.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently, users can skip individual test cases by means of writing

  "skip": "yes"

in the scenario file. Extend this functionality by allowing the execution
of a command, written in the "skip" property for a specific test case. If
such property is present, tdc executes that command and skips the test if
the return value is non-zero.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../creating-testcases/AddingTestCases.txt    |  4 +++-
 tools/testing/selftests/tc-testing/tdc.py     | 21 +++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
index a28571aff0e1..130c49ef8576 100644
--- a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
+++ b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
@@ -37,7 +37,9 @@ skip:         A completely optional key, if the corresponding value is "yes"
               then tdc will not execute the test case in question. However,
               this test case will still appear in the results output but
               marked as skipped. This key can be placed anywhere inside the
-              test case at the top level.
+              test case at the top level. It's possible to specify a command
+              in the value of "skip": in this case, the test is skipped when
+              the return value is not zero.
 category:     A list of single-word descriptions covering what the command
               under test is testing. Example: filter, actions, u32, gact, etc.
 setup:        The list of commands required to ensure the command under test
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 7bd94f8e490a..cc355ead1ff0 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -361,13 +361,22 @@ def run_one_test(pm, args, index, tidx):
     print("Test " + tidx["id"] + ": " + tidx["name"])
 
     if 'skip' in tidx:
+        if (args.verbose > 0):
+            print('probe command for test skip')
         if tidx['skip'] == 'yes':
-            res = TestResult(tidx['id'], tidx['name'])
-            res.set_result(ResultState.skip)
-            res.set_errormsg('Test case designated as skipped.')
-            pm.call_pre_case(tidx, test_skip=True)
-            pm.call_post_execute()
-            return res
+            # 'yes' would block forever: preserve existing skipped test
+            #  replacing 'yes' with 'false'
+            (p, procout) = exec_cmd(args, pm, 'execute', '/bin/false')
+        else:
+            (p, procout) = exec_cmd(args, pm, 'execute', tidx['skip'])
+        if p:
+            if (p.returncode != 0):
+                res = TestResult(tidx['id'], tidx['name'])
+                res.set_result(ResultState.skip)
+                res.set_errormsg('probe command failed: test skipped.')
+                pm.call_pre_case(tidx, test_skip=True)
+                pm.call_post_execute()
+                return res
 
     # populate NAMES with TESTID for this test
     NAMES['TESTID'] = tidx['id']
-- 
2.39.2

