Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A50A3CB1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfH3QzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 12:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbfH3QzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 12:55:23 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2145D308FEC1;
        Fri, 30 Aug 2019 16:55:23 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34D426012E;
        Fri, 30 Aug 2019 16:55:21 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lucas Bates <lucasb@mojatatu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] tc-testing: don't hardcode 'ip' in nsPlugin.py
Date:   Fri, 30 Aug 2019 18:51:47 +0200
Message-Id: <8ade839e21c5231d2d6b8690b39587f802642306.1567180765.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 30 Aug 2019 16:55:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following tdc test fails on Fedora:

 # ./tdc.py -e 2638
  -- ns/SubPlugin.__init__
 Test 2638: Add matchall and try to get it
 -----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 clsact"
 -----> prepare stage *** Error message: "/bin/sh: ip: command not found"
 returncode 127; expected [0]
 -----> prepare stage *** Aborting test run.

Let nsPlugin.py use the 'IP' variable introduced with commit 92c1a19e2fb9
("tc-tests: added path to ip command in tdc"), so that the path to 'ip' is
correctly resolved to the value we have in tdc_config.py.

 # ./tdc.py -e 2638
  -- ns/SubPlugin.__init__
 Test 2638: Add matchall and try to get it
 All test results:
 1..1
 ok 1 2638 - Add matchall and try to get it

Fixes: 489ce2f42514 ("tc-testing: Restore original behaviour for namespaces in tdc")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../tc-testing/plugin-lib/nsPlugin.py         | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
index affa7f2d9670..9539cffa9e5e 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
@@ -64,7 +64,7 @@ class SubPlugin(TdcPlugin):
             cmdlist.insert(0, self.args.NAMES['NS'])
             cmdlist.insert(0, 'exec')
             cmdlist.insert(0, 'netns')
-            cmdlist.insert(0, 'ip')
+            cmdlist.insert(0, self.args.NAMES['IP'])
         else:
             pass
 
@@ -78,16 +78,16 @@ class SubPlugin(TdcPlugin):
         return command
 
     def _ports_create(self):
-        cmd = 'ip link add $DEV0 type veth peer name $DEV1'
+        cmd = '$IP link add $DEV0 type veth peer name $DEV1'
         self._exec_cmd('pre', cmd)
-        cmd = 'ip link set $DEV0 up'
+        cmd = '$IP link set $DEV0 up'
         self._exec_cmd('pre', cmd)
         if not self.args.namespace:
-            cmd = 'ip link set $DEV1 up'
+            cmd = '$IP link set $DEV1 up'
             self._exec_cmd('pre', cmd)
 
     def _ports_destroy(self):
-        cmd = 'ip link del $DEV0'
+        cmd = '$IP link del $DEV0'
         self._exec_cmd('post', cmd)
 
     def _ns_create(self):
@@ -97,16 +97,16 @@ class SubPlugin(TdcPlugin):
         '''
         self._ports_create()
         if self.args.namespace:
-            cmd = 'ip netns add {}'.format(self.args.NAMES['NS'])
+            cmd = '$IP netns add {}'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
-            cmd = 'ip link set $DEV1 netns {}'.format(self.args.NAMES['NS'])
+            cmd = '$IP link set $DEV1 netns {}'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
-            cmd = 'ip -n {} link set $DEV1 up'.format(self.args.NAMES['NS'])
+            cmd = '$IP -n {} link set $DEV1 up'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
             if self.args.device:
-                cmd = 'ip link set $DEV2 netns {}'.format(self.args.NAMES['NS'])
+                cmd = '$IP link set $DEV2 netns {}'.format(self.args.NAMES['NS'])
                 self._exec_cmd('pre', cmd)
-                cmd = 'ip -n {} link set $DEV2 up'.format(self.args.NAMES['NS'])
+                cmd = '$IP -n {} link set $DEV2 up'.format(self.args.NAMES['NS'])
                 self._exec_cmd('pre', cmd)
 
     def _ns_destroy(self):
@@ -115,7 +115,7 @@ class SubPlugin(TdcPlugin):
         devices as well)
         '''
         if self.args.namespace:
-            cmd = 'ip netns delete {}'.format(self.args.NAMES['NS'])
+            cmd = '$IP netns delete {}'.format(self.args.NAMES['NS'])
             self._exec_cmd('post', cmd)
 
     def _exec_cmd(self, stage, command):
-- 
2.20.1

