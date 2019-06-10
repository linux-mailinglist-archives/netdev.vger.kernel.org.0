Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58AC3ACE4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbfFJCVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:21:10 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:34870 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbfFJCVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:21:10 -0400
Received: by mail-it1-f196.google.com with SMTP id n189so10928077itd.0
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 19:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=cBV99ANlBKByx2hkSLaGjll2uuTtaAONo368sj5bc30=;
        b=1dxC21JqxfxT5matM6X2/ef5BojPswHAc6Mhdn+o4Tz+NGZ9jghXpJGGn4EWsfCCYq
         H/CU1EGUPcGIiX5blwkXGReEl7qKRi4Cr3gxwt832zn+CUaBWJuaD++P/1rxNJyyt4UO
         aZ2SS+swUwkRgEGcsUEX1AfDuu6AfkR4GFCklnLvTxjlpR1u/vngXW5vtb98fx7dHJkV
         znUMK7L83UYnAzeB5jeirbMANXvfphepVHBCVgCq+GPq4HKFPvMWaOyA40ZjqgzTi/hL
         oze4E66bHXgbfzftnAPOaTzO41VPkuL2ANq40av/1N63Xh0qgs2dCU5K9WF+CVS7dGXP
         aSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cBV99ANlBKByx2hkSLaGjll2uuTtaAONo368sj5bc30=;
        b=E8f12lGqvVvF3zoId5SBObY8SwQiDLmRu5JKIMxXuBvN9tJZ4WfTtwhvrAKYsqEIsE
         BfxFtjb9+3Hto/HCtfWHAiiUBJcqw2IWtn5ma9+NbVgShwxbKi9rJatQPA1S8uSP6s5z
         5FcgT86QEW9KuOyjVOVOUhuqoECTm5LMxuOc2mmxMtBtb9yWxziwSZfXzE4YVhU0Vl2w
         sJIoqv0zfMdtbm+f4u8i4atJhtB4Az8IDX3Zm0AzbfBl1K5lCrRjZEokYv53JNvcxUQh
         mJCX2f8fU3qH7KT3RJ8mgSU/IJp30E0scfWQFVDKMuDYID3kTsAvd8FGxiMN5i4rXImD
         V6qA==
X-Gm-Message-State: APjAAAVFP+mWvDlGAalDL1MrDPCVVT9mKTGkg2HDo0/X80mA8+kwtiO/
        TwLMOcsfvqPgz4gfnM/FBrGfoK+rulGM0g==
X-Google-Smtp-Source: APXvYqyZk+O9eBk3YBi9fV91Vn7PPOS2rxMZifyVzwcp4rPkQwtIImS/ZAHVLN+sHgmv0FXDnp121w==
X-Received: by 2002:a02:a581:: with SMTP id b1mr9720574jam.84.1560133269028;
        Sun, 09 Jun 2019 19:21:09 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:f109:ec04:686e:6ab0])
        by smtp.gmail.com with ESMTPSA id i3sm3417273ion.9.2019.06.09.19.21.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 09 Jun 2019 19:21:08 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, kernel@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, mleitner@redhat.com,
        vladbu@mellanox.com, dcaratti@redhat.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [RFC PATCH net-next 1/1] tc-testing: Scapy plugin and JSON verification for tdc
Date:   Sun,  9 Jun 2019 22:20:32 -0400
Message-Id: <1560133232-17880-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a draft version of two new tdc features.

First, the scapy plugin. This requires the scapy Python module
installed on the system (plugin was tested against v2.4.2).
The intent is to install a given rule (as the command under test)
and then generate packets to create statistics for that rule.
The stats are checked in the verify phase.

A new "scapy" entry appears in the test cases, which currently
have three requirements: the source interface for the packets,
the number of packets to be sent, and a string that is processed
by scapy's eval() function to construct the packets.

Limitations: For now, only one type of packet can be crafted
per test case. Also, knowledge of scapy's syntax is required.

Secondly, we add JSON processing as a method of performing the
verification stage. Each test case can now have a "matchPattern"
or "matchJSON" field which governs the method tdc will use to
process the results. The intent is to make it easier to handle
the verify stage by not requiring complex regular expressions

matchJSON has two fields, path and value. Path is a list of
strings and integers which indicate the path through the nested
JSON data - an asterisk is also acceptable in place of
a number if the specific index of a list is unknown.

This structure may not be the best method of handling JSON
verification - suggestions have been made that include using a
third party module to process the JSON, but that creates an
external dependency for tdc.

To try the sample tests in this patch:

1) Ensure nsPlugin and scapyPlugin are linked in the plugins/
   subdirectory
2) Run:
    sudo ./tdc.py -f tc-tests/actions/scapy-example.json -n

The second test is designed to fail.

Comments and discussion are encouraged!

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
---
 tools/testing/selftests/tc-testing/TdcPlugin.py    |   5 +-
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py |  49 +++++++
 .../tc-testing/tc-tests/actions/scapy-example.json |  86 ++++++++++++
 tools/testing/selftests/tc-testing/tdc.py          | 149 ++++++++++++++++++---
 4 files changed, 268 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/scapy-example.json

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
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
new file mode 100644
index 0000000..b3ffc24
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -0,0 +1,49 @@
+#!/usr/bin/env python3
+
+import os
+import signal
+from string import Template
+import subprocess
+import time
+from TdcPlugin import TdcPlugin
+
+from tdc_config import *
+
+try:
+    from scapy.all import *
+except ImportError:
+    print("Unable to import the scapy python module. Is it installed?")
+    exit(1)
+
+class SubPlugin(TdcPlugin):
+    def __init__(self):
+        self.sub_class = 'scapy/SubPlugin'
+        super().__init__()
+
+    def post_execute(self):
+        if 'scapy' not in self.args.caseinfo:
+            if self.args.verbose:
+                print('{}.post_execute: no scapy info in test case'.format(self.sub_class))
+            return
+
+        # Check for required fields
+        scapyinfo = self.args.caseinfo['scapy']
+        scapy_keys = ['iface', 'count', 'eval']
+        missing_keys = []
+        keyfail = False
+        for k in scapy_keys:
+            if k not in scapyinfo:
+                keyfail = True
+                missing_keys.add(k)
+        if keyfail:
+            print('{}: Scapy block present in the test, but is missing info:'
+                .format(self.sub_class))
+            print('{}'.format(missing_keys))
+
+        pkt = eval(scapyinfo['eval'])
+        if '$' in scapyinfo['iface']:
+            tpl = Template(scapyinfo['iface'])
+            scapyinfo['iface'] = tpl.safe_substitute(NAMES)
+        for count in range(scapyinfo['count']):
+            sendp(pkt, iface=scapyinfo['iface'])
+
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/scapy-example.json b/tools/testing/selftests/tc-testing/tc-tests/actions/scapy-example.json
new file mode 100644
index 0000000..38895010
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/scapy-example.json
@@ -0,0 +1,86 @@
+[
+    {
+        "id": "b1e9",
+        "name": "Test matching of source IP",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 1,
+            "eval": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 ingress prio 3",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+		    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e9c4",
+        "name": "Test matching of source IP with wrong count",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 3,
+            "eval": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 parent ffff:",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+		    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 5cee156..b422491 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -32,6 +32,10 @@ class PluginMgrTestFail(Exception):
         self.output = output
         self.message = message

+class ElemNotFound(Exception):
+    def __init__(self, path_element):
+        self.path_element = path_element
+
 class PluginMgr:
     def __init__(self, argparser):
         super().__init__()
@@ -61,15 +65,15 @@ class PluginMgr:
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
@@ -103,6 +107,43 @@ class PluginMgr:
         self.argparser = argparse.ArgumentParser(
             description='Linux TC unit tests')

+def find_in_json(jsonobj, path):
+    print('DEBUG: jsonobj is {}'.format(jsonobj))
+    print('DEBUG: path is {}'.format(path))
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
+        print('DEBUG: Value found at path is {}'.format(jsonobj))
+        return jsonobj
+
+
 def replace_keywords(cmd):
     """
     For a given executable command, substitute any known
@@ -182,6 +223,86 @@ def prepare_env(args, pm, stage, prefix, cmdlist, output = None):
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
@@ -197,14 +318,14 @@ def run_one_test(pm, args, index, tidx):
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
@@ -228,21 +349,13 @@ def run_one_test(pm, args, index, tidx):
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

