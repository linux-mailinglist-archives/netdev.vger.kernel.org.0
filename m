Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAD236661
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfFEVJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:09:19 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42691 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFEVJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:09:19 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so98043ior.9
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=oNUfEAB5gxFcbYo9jDKJ2qror3YVUx1ybtG7dNZnfHU=;
        b=Dn+M1Ae86YBf5yp+6GwjQz9eWJfcCsN/L+iXDDQlz/UkHxA8XeaEn+RdkF+hgmfwOl
         aMRIP9QS1IR8jIw7jcza3aPYHUOzU4ov+FXoVHYvZ2Yy0kQYwdf6M55LWPCmbZyrETPD
         F32D4FY0is5uLuW+Jmk849P0DZpUAv6dO8Z1p51eyRKLLThrZJna/4PXFl0Ak4ef60uX
         iS4viT5mVKBh93foZhnCSCsFre39f2BZwJkZQqUKNVRQto6Uz7BRln559N6HmUx9kEmi
         RBJ5IDo+ovxN4YtXEvT1Qhmo+LsVIPXdn47C2uJ5pTi4uPw5G+vjfEfZhhTXoQZk40br
         flYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oNUfEAB5gxFcbYo9jDKJ2qror3YVUx1ybtG7dNZnfHU=;
        b=nLew259E091tdO1vZ6XFARWLhO51df/8EvBRaJMHmF4Rn5ChfkXP9LF+LCKbxjqM6x
         tx3O8wdCn3vdCPU2t5KKcR94jX8Em0GaeX+Ga0fIW9WqSzXSlyX71Pd1Hr4CMs//kLt9
         2Z0QvI5BaFG/t2iKTRf04gTPzzGo3692KNPWZwh6vZm5tM67Wo549u6yEqWnYLdTSBf6
         BkDNIAVTk38yN42U8nZk/1f13mtizIXnuHCe8Jka3F1F56Xf5UPv1wMzk/RVvwDMT3V5
         p4Z/1O8tglnrjNORlb5q/XqcrN4VfdlgypKHe8+Pc+tAPBy/MUNEN2YLAP2keAtY2H6m
         pmtg==
X-Gm-Message-State: APjAAAU1df8OZosHZrQMEOsSvcDn8D3o+GPFhF1qeWHFJhz/ehFltr+9
        BpW/TGKZkiwtY0TPqNU9ByDqHPqjfYjFFTwV
X-Google-Smtp-Source: APXvYqxma42256Ci1BdvZ5uTr+a/xZYFQmWzSjt/0PeQngTH37QTIRF/NyZPz5oiLzP1MXJOLI5iPw==
X-Received: by 2002:a6b:ef06:: with SMTP id k6mr528462ioh.70.1559768957350;
        Wed, 05 Jun 2019 14:09:17 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id q13sm6998359iob.55.2019.06.05.14.09.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 14:09:16 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.dichtel@6wind.com, davem@davemloft.net, jhs@mojatatu.com,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour for namespaces in tdc
Date:   Wed,  5 Jun 2019 17:08:02 -0400
Message-Id: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for the delay in getting this out. I've been busy
with other things and this change was a little trickier than
I expected.

This patch restores the original behaviour for tdc prior to the
introduction of the plugin system, where the network namespace
functionality was split from the main script.

It introduces the concept of required plugins for testcases,
and will automatically load any plugin that isn't already
enabled when said plugin is required by even one testcase.

Additionally, the -n option for the nsPlugin is deprecated
so the default action is to make use of the namespaces.
Instead, we introduce -N to not use them, but still create
the veth pair.

Comments welcome!
---
 tools/testing/selftests/tc-testing/README          |  22 ++-
 .../selftests/tc-testing/plugin-lib/nsPlugin.py    |  26 +++-
 .../selftests/tc-testing/tc-tests/filters/fw.json  | 162 +++++++++++++++++++++
 .../tc-testing/tc-tests/filters/tests.json         |  12 ++
 tools/testing/selftests/tc-testing/tdc.py          |  78 +++++++++-
 tools/testing/selftests/tc-testing/tdc_helper.py   |   5 +-
 6 files changed, 287 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/README b/tools/testing/selftests/tc-testing/README
index f9281e8..22e5da9 100644
--- a/tools/testing/selftests/tc-testing/README
+++ b/tools/testing/selftests/tc-testing/README
@@ -12,10 +12,10 @@ REQUIREMENTS
 *  Minimum Python version of 3.4. Earlier 3.X versions may work but are not
    guaranteed.

-*  The kernel must have network namespace support
+*  The kernel must have network namespace support if using nsPlugin

 *  The kernel must have veth support available, as a veth pair is created
-   prior to running the tests.
+   prior to running the tests when using nsPlugin.

 *  The kernel must have the appropriate infrastructure enabled to run all tdc
    unit tests. See the config file in this directory for minimum required
@@ -53,8 +53,12 @@ commands being tested must be run as root.  The code that enforces
 execution by root uid has been moved into a plugin (see PLUGIN
 ARCHITECTURE, below).

-If nsPlugin is linked, all tests are executed inside a network
-namespace to prevent conflicts within the host.
+Tests that use a network device should have nsPlugin.py listed as a
+requirement for that test. nsPlugin executes all commands within a
+network namespace and creates a veth pair which may be used in those test
+cases. To disable execution within the namespace, pass the -N option
+to tdc when starting a test run; the veth pair will still be created
+by the plugin.

 Running tdc without any arguments will run all tests. Refer to the section
 on command line arguments for more information, or run:
@@ -154,8 +158,8 @@ action:
 netns:
   options for nsPlugin (run commands in net namespace)

-  -n, --namespace
-                        Run commands in namespace as specified in tdc_config.py
+  -N, --no-namespace
+                        Do not run commands in a network namespace.

 valgrind:
   options for valgrindPlugin (run command under test under Valgrind)
@@ -171,7 +175,8 @@ was in the tdc.py script has been moved into the plugins.

 The plugins are in the directory plugin-lib.  The are executed from
 directory plugins.  Put symbolic links from plugins to plugin-lib,
-and name them according to the order you want them to run.
+and name them according to the order you want them to run. This is not
+necessary if a test case being run requires a specific plugin to work.

 Example:

@@ -223,7 +228,8 @@ directory:
   - rootPlugin.py:
       implements the enforcement of running as root
   - nsPlugin.py:
-      sets up a network namespace and runs all commands in that namespace
+      sets up a network namespace and runs all commands in that namespace,
+      while also setting up dummy devices to be used in testing.
   - valgrindPlugin.py
       runs each command in the execute stage under valgrind,
       and checks for leaks.
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
index a194b1a..7042618 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
@@ -18,6 +18,8 @@ class SubPlugin(TdcPlugin):

         if self.args.namespace:
             self._ns_create()
+        else:
+            self._ports_create()

     def post_suite(self, index):
         '''run commands after test_runner goes into a test loop'''
@@ -27,6 +29,8 @@ class SubPlugin(TdcPlugin):

         if self.args.namespace:
             self._ns_destroy()
+        else:
+            self._ports_destroy()

     def add_args(self, parser):
         super().add_args(parser)
@@ -34,8 +38,8 @@ class SubPlugin(TdcPlugin):
             'netns',
             'options for nsPlugin(run commands in net namespace)')
         self.argparser_group.add_argument(
-            '-n', '--namespace', action='store_true',
-            help='Run commands in namespace')
+            '-N', '--no-namespace', action='store_false', default=True,
+            dest='namespace', help='Run commands in namespace')
         return self.argparser

     def adjust_command(self, stage, command):
@@ -73,20 +77,30 @@ class SubPlugin(TdcPlugin):
             print('adjust_command:  return command [{}]'.format(command))
         return command

+    def _ports_create(self):
+        cmd = 'ip link add $DEV0 type veth peer name $DEV1'
+        self._exec_cmd('pre', cmd)
+        cmd = 'ip link set $DEV0 up'
+        self._exec_cmd('pre', cmd)
+        if not self.args.namespace:
+            cmd = 'ip link set $DEV1 up'
+            self._exec_cmd('pre', cmd)
+
+    def _ports_destroy(self):
+        cmd = 'ip link del $DEV0'
+        self._exec_cmd('post', cmd)
+
     def _ns_create(self):
         '''
         Create the network namespace in which the tests will be run and set up
         the required network devices for it.
         '''
+        self._ports_create()
         if self.args.namespace:
             cmd = 'ip netns add {}'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
-            cmd = 'ip link add $DEV0 type veth peer name $DEV1'
-            self._exec_cmd('pre', cmd)
             cmd = 'ip link set $DEV1 netns {}'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
-            cmd = 'ip link set $DEV0 up'
-            self._exec_cmd('pre', cmd)
             cmd = 'ip -n {} link set $DEV1 up'.format(self.args.NAMES['NS'])
             self._exec_cmd('pre', cmd)
             if self.args.device:
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json b/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
index 3b97cfd..e364c77 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
@@ -6,6 +6,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -25,6 +28,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -44,6 +50,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -63,6 +72,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -82,6 +94,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -101,6 +116,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -120,6 +138,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -139,6 +160,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -158,6 +182,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -177,6 +204,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -196,6 +226,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -215,6 +248,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -234,6 +270,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -253,6 +292,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -272,6 +314,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -291,6 +336,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -310,6 +358,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -329,6 +380,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -348,6 +402,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -367,6 +424,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -386,6 +446,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -405,6 +468,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -424,6 +490,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -443,6 +512,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -462,6 +534,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -481,6 +556,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -500,6 +578,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -519,6 +600,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -538,6 +622,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -557,6 +644,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -576,6 +666,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -595,6 +688,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -614,6 +710,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -633,6 +732,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -652,6 +754,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -671,6 +776,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -690,6 +798,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -709,6 +820,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -728,6 +842,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: protocol 802_3 prio 3 handle 7 fw action ok"
@@ -748,6 +865,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: prio 6 handle 2 fw action continue index 5"
@@ -768,6 +888,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -787,6 +910,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -806,6 +932,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -828,6 +957,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -850,6 +982,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -871,6 +1006,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 4 fw action ok",
@@ -892,6 +1030,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 chain 13 fw action pipe",
@@ -913,6 +1054,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 2 prio 4 fw action drop"
@@ -933,6 +1077,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 3 prio 4 fw action continue"
@@ -953,6 +1100,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 protocol arp fw action pipe"
@@ -973,6 +1123,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 fw action pipe flowid 45"
@@ -993,6 +1146,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 2 fw action ok"
@@ -1013,6 +1169,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 2 fw action ok"
@@ -1033,6 +1192,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 2 fw action ok index 3"
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index e2f92ce..8135778 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -6,6 +6,9 @@
             "filter",
             "u32"
         ],
+        "plugins": {
+                "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -25,6 +28,9 @@
             "filter",
             "matchall"
         ],
+        "plugins": {
+                "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 clsact",
             "$TC filter add dev $DEV1 protocol all pref 1 ingress handle 0x1234 matchall action ok"
@@ -45,6 +51,9 @@
             "filter",
             "flower"
         ],
+        "plugins": {
+                "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV2 ingress",
             "./tdc_batch.py $DEV2 $BATCH_FILE --share_action -n 1000000"
@@ -66,6 +75,9 @@
             "filter",
             "flower"
         ],
+        "plugins": {
+                "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV2 ingress",
             "$TC filter add dev $DEV2 protocol ip prio 1 parent ffff: flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop"
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 5cee156..678182a 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -25,6 +25,9 @@ from tdc_helper import *
 import TdcPlugin
 from TdcResults import *

+class PluginDependencyException(Exception):
+    def __init__(self, missing_pg):
+        self.missing_pg = missing_pg

 class PluginMgrTestFail(Exception):
     def __init__(self, stage, output, message):
@@ -37,7 +40,7 @@ class PluginMgr:
         super().__init__()
         self.plugins = {}
         self.plugin_instances = []
-        self.args = []
+        self.failed_plugins = {}
         self.argparser = argparser

         # TODO, put plugins in order
@@ -53,6 +56,64 @@ class PluginMgr:
                     self.plugins[mn] = foo
                     self.plugin_instances.append(foo.SubPlugin())

+    def load_plugin(self, pgdir, pgname):
+        pgname = pgname[0:-3]
+        foo = importlib.import_module('{}.{}'.format(pgdir, pgname))
+        self.plugins[pgname] = foo
+        self.plugin_instances.append(foo.SubPlugin())
+        self.plugin_instances[-1].check_args(self.args, None)
+
+    def get_required_plugins(self, testlist):
+        '''
+        Get all required plugins from the list of test cases and return
+        all unique items.
+        '''
+        reqs = []
+        for t in testlist:
+            try:
+                if 'requires' in t['plugins']:
+                    if isinstance(t['plugins']['requires'], list):
+                        reqs.extend(t['plugins']['requires'])
+                    else:
+                        reqs.append(t['plugins']['requires'])
+            except KeyError:
+                continue
+        reqs = get_unique_item(reqs)
+        return reqs
+
+    def load_required_plugins(self, reqs, parser, args, remaining):
+        '''
+        Get all required plugins from the list of test cases and load any plugin
+        that is not already enabled.
+        '''
+        pgd = ['plugin-lib', 'plugin-lib-custom']
+        pnf = []
+
+        for r in reqs:
+            if r not in self.plugins:
+                fname = '{}.py'.format(r)
+                source_path = []
+                for d in pgd:
+                    pgpath = '{}/{}'.format(d, fname)
+                    if os.path.isfile(pgpath):
+                        source_path.append(pgpath)
+                if len(source_path) == 0:
+                    print('ERROR: unable to find required plugin {}'.format(r))
+                    pnf.append(fname)
+                    continue
+                elif len(source_path) > 1:
+                    print('WARNING: multiple copies of plugin {} found, using version found')
+                    print('at {}'.format(source_path[0]))
+                pgdir = source_path[0]
+                pgdir = pgdir.split('/')[0]
+                self.load_plugin(pgdir, fname)
+        if len(pnf) > 0:
+            raise PluginDependencyException(pnf)
+
+        parser = self.call_add_args(parser)
+        (args, remaining) = parser.parse_known_args(args=remaining, namespace=args)
+        return args
+
     def call_pre_suite(self, testcount, testidlist):
         for pgn_inst in self.plugin_instances:
             pgn_inst.pre_suite(testcount, testidlist)
@@ -98,6 +159,9 @@ class PluginMgr:
             command = pgn_inst.adjust_command(stage, command)
         return command

+    def set_args(self, args):
+        self.args = args
+
     @staticmethod
     def _make_argparser(args):
         self.argparser = argparse.ArgumentParser(
@@ -550,6 +614,7 @@ def filter_tests_by_category(args, testlist):

     return answer

+
 def get_test_cases(args):
     """
     If a test case file is specified, retrieve tests from that file.
@@ -611,7 +676,7 @@ def get_test_cases(args):
     return allcatlist, allidlist, testcases_by_cats, alltestcases


-def set_operation_mode(pm, args):
+def set_operation_mode(pm, parser, args, remaining):
     """
     Load the test case data and process remaining arguments to determine
     what the script should do for this run, and call the appropriate
@@ -649,6 +714,12 @@ def set_operation_mode(pm, args):
             exit(0)

     if len(alltests):
+        req_plugins = pm.get_required_plugins(alltests)
+        try:
+            args = pm.load_required_plugins(req_plugins, parser, args, remaining)
+        except PluginDependencyException as pde:
+            print('The following plugins were not found:')
+            print('{}'.format(pde.missing_pg))
         catresults = test_runner(pm, args, alltests)
         if args.format == 'none':
             print('Test results output suppression requested\n')
@@ -686,11 +757,12 @@ def main():
     parser = pm.call_add_args(parser)
     (args, remaining) = parser.parse_known_args()
     args.NAMES = NAMES
+    pm.set_args(args)
     check_default_settings(args, remaining, pm)
     if args.verbose > 2:
         print('args is {}'.format(args))

-    set_operation_mode(pm, args)
+    set_operation_mode(pm, parser, args, remaining)

     exit(0)

diff --git a/tools/testing/selftests/tc-testing/tdc_helper.py b/tools/testing/selftests/tc-testing/tdc_helper.py
index 9f35c96..0440d25 100644
--- a/tools/testing/selftests/tc-testing/tdc_helper.py
+++ b/tools/testing/selftests/tc-testing/tdc_helper.py
@@ -17,7 +17,10 @@ def get_categorized_testlist(alltests, ucat):

 def get_unique_item(lst):
     """ For a list, return a list of the unique items in the list. """
-    return list(set(lst))
+    if len(lst) > 1:
+        return list(set(lst))
+    else:
+        return lst


 def get_test_categories(alltests):
--
2.7.4

