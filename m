Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0225F0C8
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGDAp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:45:59 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45891 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGDAp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:45:59 -0400
Received: by mail-io1-f68.google.com with SMTP id g20so1525858ioc.12
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f8fcnM09WvnMgREWvby4Pkdfwla53pclgGTRiqTO+eE=;
        b=J+Piyr8rXnls530bCEVtD8i1WycCEigz9uO2IyXXJXVSdFohmClkBePiVVqMJdI8fD
         FxL9XYDSKHFxfGpPh2zbMM5M2l/Ux/RKdJvcrSJnlplfRL24pMrEJPqBbIG5laU9/Hs3
         Z1uKhUXpXtJjsILAmYeZSD+yFyYHf5MpQvdd1aSSSeq7afGuMthy5G1I5mh7LEplVICC
         hIf7K1xTEsb3B5sanXhDxMUgaRpdoQ0zDjaeiF/f1KreICA9tRxbavD9RR5JFNMVnfEH
         BfN55YC40ZbI6br5VrNlzWwKdCcxUcIgVAfx7xn3LNaNjwWknhXULVd3Lw5my79piY4S
         c55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f8fcnM09WvnMgREWvby4Pkdfwla53pclgGTRiqTO+eE=;
        b=W52kepY3oCfnDy01OUtDn6XmWoW+slAm4Xxnvwn7AwQkUOCaCrA8G3d/JyUAhw1ab1
         1wWhuviHn+GRwx+entJYldYDzqF7RUH21iM0SBl8R8HoDmHEY2Iq0UNGk2Aq02w+5lt6
         ag+t8W1ZfUUxk+iE++iOgibgC+a3sPoXRn9rrQsY0ZIUDeR/ArzwEtwbc6XEL3UUwdb3
         pQJZm7WNo8ciwbJwz+xb8mozGrYD8EOeGmYis3j16xy38wMCnbt58dT1jlVFCDLy/2Ow
         TNqE6gGd6ZkeN8s4bSAL0aaekztw3GuKZK+uM+wjg+5+XCIzQ8xG1l1yXB9qkjAcnzD7
         pWFQ==
X-Gm-Message-State: APjAAAVP2U32lMHGo/HNjaLHgA/1FjxjobUnrhBUXkg+WQ15BAKJ9VEA
        /8ZMgwT4HmOZjWrzcSOGQZvPWA==
X-Google-Smtp-Source: APXvYqz/3mpMW+1iAdECDMY5YHdy1dQAKp8Jg1dhOC9fiYe/ZxalnETbOgcE25dXEfEkrdvpakRirw==
X-Received: by 2002:a5e:9e0a:: with SMTP id i10mr16745548ioq.44.1562201157501;
        Wed, 03 Jul 2019 17:45:57 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:4494:a7b3:9aab:d513])
        by smtp.gmail.com with ESMTPSA id l5sm5619776ioq.83.2019.07.03.17.45.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 17:45:56 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH v2 net-next 1/3] tc-testing: Add JSON verification to tdc
Date:   Wed,  3 Jul 2019 20:45:00 -0400
Message-Id: <1562201102-4332-2-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
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

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
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

