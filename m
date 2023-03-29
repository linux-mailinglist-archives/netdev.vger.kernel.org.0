Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B406CD713
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjC2J4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjC2J4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FF012E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680083763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpGUdm6uNFxOBXKRYkU5O9q8UlmK4cYm7j0EP5G6fhQ=;
        b=Qhb+QxqkSfv2iRcU9/A20UCBZVbxy1vCDRx7Rp/NGAxLDIual42I5kGnK/p2kvLuBrPjtb
        mZFnxkejf1Syi1mb3w3y0oKWb1NKis0MGhBFMRwhiC3z1kLeVhVUbFKzbHVP77xjsUgp7a
        rC1mQTRIKfc0r5UN3cgJ+jyAVWM8E9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-gFxISLojOg-Ts8vzuFq87A-1; Wed, 29 Mar 2023 05:56:01 -0400
X-MC-Unique: gFxISLojOg-Ts8vzuFq87A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB48185A78F;
        Wed, 29 Mar 2023 09:56:00 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4304418EC2;
        Wed, 29 Mar 2023 09:55:59 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 2/4] selftests: tc-testing: add "depends_on" property to skip tests
Date:   Wed, 29 Mar 2023 11:54:53 +0200
Message-Id: <3e63597d0e495266158dbd9100d1fc438ac8487c.1680082990.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680082990.git.dcaratti@redhat.com>
References: <cover.1680082990.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

in the scenario file. Extend this functionality, introducing 'dependsOn':
it's optional property like "skip", but the value contains a command (for
example, a probe on iproute2 to check if it supports a specific feature).
If such property is present, tdc executes that command and skips the test
when the return value is non-zero.

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../creating-testcases/AddingTestCases.txt          |  2 ++
 tools/testing/selftests/tc-testing/tdc.py           | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
index a28571aff0e1..ff956d8c99c5 100644
--- a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
+++ b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
@@ -38,6 +38,8 @@ skip:         A completely optional key, if the corresponding value is "yes"
               this test case will still appear in the results output but
               marked as skipped. This key can be placed anywhere inside the
               test case at the top level.
+dependsOn:    Same as 'skip', but the value is executed as a command. The test
+              is skipped when the command returns non-zero.
 category:     A list of single-word descriptions covering what the command
               under test is testing. Example: filter, actions, u32, gact, etc.
 setup:        The list of commands required to ensure the command under test
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 7bd94f8e490a..b98256f38447 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -369,6 +369,19 @@ def run_one_test(pm, args, index, tidx):
             pm.call_post_execute()
             return res
 
+    if 'dependsOn' in tidx:
+        if (args.verbose > 0):
+            print('probe command for test skip')
+        (p, procout) = exec_cmd(args, pm, 'execute', tidx['dependsOn'])
+        if p:
+            if (p.returncode != 0):
+                res = TestResult(tidx['id'], tidx['name'])
+                res.set_result(ResultState.skip)
+                res.set_errormsg('probe command: test skipped.')
+                pm.call_pre_case(tidx, test_skip=True)
+                pm.call_post_execute()
+                return res
+
     # populate NAMES with TESTID for this test
     NAMES['TESTID'] = tidx['id']
 
-- 
2.39.2

