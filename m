Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C698452033
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbfFYBA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:00:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37021 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729889AbfFYBAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 21:00:52 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so176752iok.4
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 18:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Z8PQ3wKhmVVLjHpnU4vD8v0+qT3YiJv/XVj0L8daRDo=;
        b=2FUf5u4UxYaX3BpMBN8IK4BAzMKIXw+RVU0WWk540uIJhsTL8VN1RHJImxtm9F89oQ
         jwd2E+0nmyeOe6RxKwMxpBITl+Ieoaz+MGfR2TaVby5haGCk7XlBzoE3UFV1fFHEOti7
         W+bcnk2keoDqFOsmqEE46V5bqCxsZVMJay/yT+tI+8lZGjYq6WjPFu2V7OMmtI9T6sBr
         a3N3lznzdE12DfIPajhGBtYUh16pyNTALvY/5EsG4GCX08clce+wmqenVcEe/f6UN/i5
         tG97qbo1GqwBZtfObEF8lZOwOpNnV2Ghet5tVMfLE+e4xeDCGDfeK6Wi+4a+GWmD60xv
         2cIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z8PQ3wKhmVVLjHpnU4vD8v0+qT3YiJv/XVj0L8daRDo=;
        b=aeiLnvQuNRwk+NSRrZZj+kxBSRl2XHVvCJ/6sBcm2qKyxAoH5g9Br683PPB2rdcUf9
         mHdSt+6+M1ab3kxMzYM8k9XNHu8uayHM4luD6UFRi8CFVfxaf3/tYo/oEULpuBqxEahA
         Aqgg/PoKfvIBukL4t3wos6LFuCqlx+lUwwiKEWHW3YYMOmxQ2CXqrZYil8+QUsho0yC7
         eCUPelWtbIa/upCddgp9J5hq17z/X9WHW++CEmOfF3VHusd1QTHfJlrivLVmCiCbzCuU
         VTqSsVUbWLzPhFrQ3B5eqUTVdbTvf/clIsOt5fhxxF4qag+6V+4p57k0+oHcgCrLrRX9
         fG2Q==
X-Gm-Message-State: APjAAAVmLXXo3gqMI2T+xXmMSgfdKEYwWKMg13L4Iuq7rg9UonMgBy+8
        eE8MPi29DWbEbTSZ/V+CKFTvZw==
X-Google-Smtp-Source: APXvYqyeohHKUAxNsDywxARPS6nJ4mVFvQvC0Y2uvQ2q3U+RHYl/OEVPZ4UdG4TiAdAftcAHsfMitg==
X-Received: by 2002:a05:6638:29a:: with SMTP id c26mr24371429jaq.98.1561424451187;
        Mon, 24 Jun 2019 18:00:51 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:b44f:20aa:14dc:ee27])
        by smtp.gmail.com with ESMTPSA id m7sm10592874iob.69.2019.06.24.18.00.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Jun 2019 18:00:50 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        kernel@mojatatu.com, Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing:  Restore original behaviour for namespaces in tdc
Date:   Mon, 24 Jun 2019 21:00:27 -0400
Message-Id: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

buildebpfPlugin's -B option is also deprecated.

If a test cases requires the features of a specific plugin
in order to pass, it should instead include a new key/value
pair describing plugin interactions:

        "plugins": {
                "requires": "buildebpfPlugin"
        },

A test case can have more than one required plugin: a list
can be inserted as the value for 'requires'.

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
---
 tools/testing/selftests/tc-testing/README          |  22 ++-
 .../tc-testing/plugin-lib/buildebpfPlugin.py       |   5 +-
 .../selftests/tc-testing/plugin-lib/nsPlugin.py    |  26 +++-
 .../selftests/tc-testing/tc-tests/actions/bpf.json |   6 +
 .../selftests/tc-testing/tc-tests/filters/fw.json  | 162 +++++++++++++++++++++
 .../tc-testing/tc-tests/filters/tests.json         |  12 ++
 tools/testing/selftests/tc-testing/tdc.py          |  78 +++++++++-
 tools/testing/selftests/tc-testing/tdc_helper.py   |   5 +-
 8 files changed, 296 insertions(+), 20 deletions(-)

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
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
index 9f0ba10..e98c367 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
@@ -34,8 +34,9 @@ class SubPlugin(TdcPlugin):
             'buildebpf',
             'options for buildebpfPlugin')
         self.argparser_group.add_argument(
-            '-B', '--buildebpf', action='store_true',
-            help='build eBPF programs')
+            '--nobuildebpf', action='store_false', default=True,
+            dest='buildebpf',
+            help='Don\'t build eBPF programs')
 
         return self.argparser
 
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py
index a194b1a..affa7f2 100644
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
+            dest='namespace', help='Don\'t run commands in namespace')
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
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index b074ea9..47a3082 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -54,6 +54,9 @@
             "actions",
             "bpf"
         ],
+        "plugins": {
+                "requires": "buildebpfPlugin"
+        },
         "setup": [
             [
                 "$TC action flush action bpf",
@@ -78,6 +81,9 @@
             "actions",
             "bpf"
         ],
+        "plugins": {
+                "requires": "buildebpfPlugin"
+        },
         "setup": [
             [
                 "$TC action flush action bpf",
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json b/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
index 6944b90..5272049 100644
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
@@ -44,6 +50,114 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -872,6 +986,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: protocol 802_3 prio 3 handle 7 fw action ok"
@@ -892,6 +1009,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: prio 6 handle 2 fw action continue index 5"
@@ -912,6 +1032,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -931,6 +1054,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -950,6 +1076,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -972,6 +1101,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -994,6 +1126,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 5 prio 7 fw action pass",
@@ -1015,6 +1150,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 4 fw action ok",
@@ -1036,6 +1174,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 chain 13 fw action pipe",
@@ -1057,6 +1198,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 2 prio 4 fw action drop"
@@ -1077,6 +1221,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 3 prio 4 fw action continue"
@@ -1097,6 +1244,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 protocol arp fw action pipe"
@@ -1117,6 +1267,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 4 prio 2 fw action pipe flowid 45"
@@ -1137,6 +1290,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 2 fw action ok"
@@ -1157,6 +1313,9 @@
             "filter",
             "fw"
         ],
+	"plugins": {
+		"requires": "nsPlugin"
+	},
         "setup": [
             "$TC qdisc add dev $DEV1 ingress",
             "$TC filter add dev $DEV1 parent ffff: handle 1 prio 2 fw action ok"
@@ -1177,6 +1336,9 @@
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

