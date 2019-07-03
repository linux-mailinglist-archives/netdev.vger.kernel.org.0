Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB0C5DC96
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfGCCmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:42:01 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32983 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCCmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:42:01 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so1265945iop.0
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8surXWlhR/NOdnwsJQSi4SvNGDS4Im6WlsDSvSnRDdU=;
        b=T/qeKSrRiQyhSZ4G2MYS4kUyYCmdcX6A005Ckn67WTROM8RP4pgwrS4zXXk2gPPbJP
         tyOEanvMpA9eDJI2V0joK/GG4ZK1zMHS6X8pdoRTPC6gDnq6+dpy5jWTA7uAohSy7ObL
         P+BOEaUhMvPjVSQUTbjJ9KLdst+qIxKCQmUV+/+BScczukfwhv1EaJEpNJtsuWWbfqc+
         dfHTwsLotP24CoSuRCuZgLS9R6JJG+3LembhJeU4xHNt0MDdg5PpkADUHKcVdsOHhMCP
         tA9EW0+SKzAI8J8/2SUAFh25kTBMH0Wu3s3wYRCz0yy9EUKGkxLttIIdEdDtkvIuc9Ug
         0WnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8surXWlhR/NOdnwsJQSi4SvNGDS4Im6WlsDSvSnRDdU=;
        b=iKQ132TI3mBrSDCZHgz6+d5C28HwyKNdAU5qPFISfi15DYRxJetQSb0587EVMF8Oqa
         avMmCA+1R+QmoniJKQ/KZrRlLmmUSv2cPUd9PKkbipQKqA9vb2hQo+ktvmpPkA8rYJig
         KPwpQYQUMlmSCrYB6Q8EEeHopeQM004q2dmN+EdjOCvBHb0blm0w17I/nzXy5bA7Yey2
         sEX7FFIri+WWbs7btwkkbDJpPHy0IVMbkOX5W6bPU4tOPSWIldu+7b4HkhovMPdaVW1T
         tPmci6K56GKeZR9NkdBVDNsVf0Dq/UFagtFhDNgM/pIPt2jw7DRNgZa1DcskuWlg0tbB
         43Xw==
X-Gm-Message-State: APjAAAXSC6JmBNZYPZyyFukcOBw9vvU7jAYaA5UwTYdIsZgB5JlD6wSF
        G34xcD3A50QMuk+/X1C/YtZpgg==
X-Google-Smtp-Source: APXvYqwrUfTJjQTaJR7aIN+YoHJ5oRa+gStEJTDCJBuLTFH8bUUW0lgME87tNP8IS5vOFWyDcGD/zg==
X-Received: by 2002:a6b:7b01:: with SMTP id l1mr5283572iop.60.1562121720513;
        Tue, 02 Jul 2019 19:42:00 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:57:4bb:2258:42f6])
        by smtp.gmail.com with ESMTPSA id w26sm1638114iom.59.2019.07.02.19.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 19:42:00 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 1/3] tc-testing: Add JSON verification to tdc
Date:   Tue,  2 Jul 2019 22:41:19 -0400
Message-Id: <1562121681-9365-2-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
References: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows tdc to process JSON output to perform secondary
verification of the command under test. If the verifyCmd generates
JSON, one can provide the 'matchJSON' key to process it
instead of a regex.

matchJSON has two elements: 'path' and 'value'. The 'path' key is a
list of integers and strings that provide the key values for tdc to
navigate the JSON information. The value is an integer or string
that tdc will compare against what it finds in the provided path.

If the numerical position of an element can vary, it's possible to
substitute an asterisk as a wildcard. tdc will search all possible
entries in the array.

Multiple matches are possible, but everything specified must
match for the test to pass.

If both matchPattern and matchJSON are present, tdc will only
operate on matchPattern. If neither are present, verification
is skipped.

Example:

  "cmdUnderTest": "$TC actions add action pass index 8",
  "verifyCmd": "$TC actions list action gact",
  "matchJSON": [
      {
          "path": [
              0,
              "actions",
              0,
              "control action",
              "type"
          ],
          "value": "gact"
      },
      {
          "path": [
              0,
              "actions",
              0,
              "index"
          ],
          "value": 8
      }
  ]
---
 tools/testing/selftests/tc-testing/tdc.py | 136 +++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 678182a..1afa803 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -35,6 +35,10 @@ class PluginMgrTestFail(Exception):
         self.output = output
         self.message = message
 
+class ElemNotFound(Exception):
+    def __init__(self, path_element):
+        self.path_element = path_element
+
 class PluginMgr:
     def __init__(self, argparser):
         super().__init__()
@@ -167,6 +171,40 @@ class PluginMgr:
         self.argparser = argparse.ArgumentParser(
             description='Linux TC unit tests')
 
+def find_in_json(jsonobj, path):
+    if type(jsonobj) == list:
+        if type(path[0]) == int:
+            if len(jsonobj) > path[0]:
+                return find_in_json(jsonobj[path[0]], path[1:])
+            else:
+                raise ElemNotFound(path[0])
+        elif path[0] == '*':
+            res = []
+            for index in jsonobj:
+                try:
+                    res.append(find_in_json(index, path[1:]))
+                except ElemNotFound:
+                    continue
+            if len(res) == 0:
+                raise ElemNotFound(path[0])
+            else:
+                return res
+    elif type(jsonobj) == dict:
+        if path[0] in jsonobj:
+            if len(path) > 1:
+                return find_in_json(jsonobj[path[0]], path[1:])
+            return jsonobj[path[0]]
+        else:
+            raise ElemNotFound(path[0])
+    else:
+        # Assume we have found the correct depth in the object
+        if len(path) >= 1:
+            print('The remainder of the specified path cannot be found!')
+            print('Path values: {}'.format(path))
+            raise ElemNotFound(path[0])
+        return jsonobj
+
+
 def replace_keywords(cmd):
     """
     For a given executable command, substitute any known
@@ -246,6 +284,86 @@ def prepare_env(args, pm, stage, prefix, cmdlist, output = None):
                 stage, output,
                 '"{}" did not complete successfully'.format(prefix))
 
+def verify_by_regex(res, tidx, args, pm):
+    if 'matchCount' not in tidx:
+        res.set_result(ResultState.skip)
+        fmsg = 'matchCount was not provided in the test case. '
+        fmsg += 'Unable to complete pattern match.'
+        res.set_failmsg(fmsg)
+        print(fmsg)
+        return res
+    (p, procout) = exec_cmd(args, pm, 'verify', tidx["verifyCmd"])
+    match_pattern = re.compile(
+        str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
+    if procout:
+        match_index = re.findall(match_pattern, procout)
+        if len(match_index) != int(tidx["matchCount"]):
+            res.set_result(ResultState.fail)
+            fmsg = 'Verify stage failed because the output did not match '
+            fmsg += 'the pattern in the test case.\nMatch pattern is:\n'
+            fmsg += '\t{}\n'.format(tidx["matchPattern"])
+            fmsg += 'Output generated by the verify command:\n'
+            fmsg += '{}\n'.format(procout)
+            res.set_failmsg(fmsg)
+        else:
+            res.set_result(ResultState.success)
+    elif int(tidx["matchCount"]) != 0:
+        res.set_result(ResultState.fail)
+        res.set_failmsg('No output generated by verify command.')
+    else:
+        res.set_result(ResultState.success)
+    return res
+
+def verify_by_json(res, tidx, args, pm):
+    # Validate the matchJSON struct
+    for match in tidx['matchJSON']:
+        if 'path' in match and 'value' in match:
+            pass
+        else:
+            res.set_result(ResultState.skip)
+            res.set_failmsg('matchJSON missing required keys for this case.')
+            return res
+    (p, procout) = exec_cmd(args, pm, 'verify', tidx["verifyCmd"])
+    # Run procout through the JSON decoder
+    try:
+        jsonobj = json.loads(procout)
+    except json.JSONDecodeError:
+        if len(tidx['matchJSON']) > 0:
+            res.set_result(ResultState.fail)
+            res.set_failmsg('Cannot decode verify command\'s output. Is it JSON?')
+            return res
+    # Then recurse through the object
+    valuesmatch = True
+    for match in tidx['matchJSON']:
+        try:
+            value = find_in_json(jsonobj, match['path'])
+        except ElemNotFound as ENF:
+            fmsg = 'Could not find the element {} specified in the path.'.format(ENF.path_element)
+            valuesmatch = False
+            break
+        if type(value) == list:
+            if match['value'] not in value:
+                valuesmatch = False
+                fmsg = 'Verify stage failed because the value specified in the path\n'
+                fmsg += '{}\n'.format(match['path'])
+                fmsg += 'Expected value: {}\nReceived value: {}'.format(
+                    match['value'], value)
+                break
+        elif match['value'] != value:
+            valuesmatch = False
+            fmsg = 'Verify stage failed because the value specified in the path\n'
+            fmsg += '{}\n'.format(match['path'])
+            fmsg += 'Expected value: {}\nReceived value: {}'.format(
+                match['value'], value)
+            break
+    if valuesmatch:
+        res.set_result(ResultState.success)
+    else:
+        res.set_result(ResultState.fail)
+        res.set_failmsg(fmsg)
+        print(fmsg)
+    return res
+
 def run_one_test(pm, args, index, tidx):
     global NAMES
     result = True
@@ -292,21 +410,13 @@ def run_one_test(pm, args, index, tidx):
     else:
         if args.verbose > 0:
             print('-----> verify stage')
-        match_pattern = re.compile(
-            str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
-        (p, procout) = exec_cmd(args, pm, 'verify', tidx["verifyCmd"])
-        if procout:
-            match_index = re.findall(match_pattern, procout)
-            if len(match_index) != int(tidx["matchCount"]):
-                res.set_result(ResultState.fail)
-                res.set_failmsg('Could not match regex pattern. Verify command output:\n{}'.format(procout))
-            else:
-                res.set_result(ResultState.success)
-        elif int(tidx["matchCount"]) != 0:
-            res.set_result(ResultState.fail)
-            res.set_failmsg('No output generated by verify command.')
+        if 'matchPattern' in tidx:
+            res = verify_by_regex(res, tidx, args, pm)
+        elif 'matchJSON' in tidx:
+            res = verify_by_json(res, tidx, args, pm)
         else:
             res.set_result(ResultState.success)
+            print('No match method defined in current test case, skipping verify')
 
     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
     pm.call_post_case()
-- 
2.7.4

