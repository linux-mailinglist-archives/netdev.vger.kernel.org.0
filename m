Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1A6AE3F1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCGPIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCGPH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:07:58 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8F994755;
        Tue,  7 Mar 2023 07:01:37 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.uk.vpn [10.172.194.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 5FABC41ABE;
        Tue,  7 Mar 2023 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678201277;
        bh=Tktkkrpcs3rSHZyoHsHQYEN7vp4v2hInvSY2NkAVAZ8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=YEqiMoqSGXa5WR4yWutTRqV1u1RHpO5RjhhR/aEpBnzSg1e01EnSibDyiHOuTSNd6
         /mUdCu/1Y52GGupLdEnX1iSFxXPuKUVnIYMgRZLxDb8CYgSrRZz1VLCditKb5q95u1
         7YdPBF/Gi3LIvfNwh5gAT/bs2CD6HpidH4DqQgrDfqWzNAkAk5XRn3ow2Xf7WYh6xC
         nXnR5No1eD3p/H0M9fc2/irHCFQuE6WwJubCK5WMzYOw59Gf/oxzg7yKYnoncXGrfq
         ru3dsUMUK5vDYLVSqE/OzRegxwaPXGYprB6mK1Ab731QSQUNIBYkSykhUOrNZSEWKe
         Cv5tNENRvvASg==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     idosch@mellanox.com, danieller@mellanox.com, petrm@mellanox.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, po-hsu.lin@canonical.com
Subject: [PATCHv2] selftests: net: devlink_port_split.py: skip test if no suitable device available
Date:   Tue,  7 Mar 2023 23:00:30 +0800
Message-Id: <20230307150030.527726-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `devlink -j port show` command output may not contain the "flavour"
key, an example from s390x LPAR with Ubuntu 22.10 (5.19.0-37-generic),
iproute2-5.15.0:
  {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
           "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
           "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
           "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}

This will cause a KeyError exception.

Create a validate_devlink_output() to check for this "flavour" from
devlink command output to avoid this KeyError exception. Also let
it handle the check for `devlink -j dev show` output in main().

Apart from this, if the test was not started because of any reason
(e.g. "lanes" does not exist, max lanes is 0 or the flavour of the
designated device is not "physical" and etc.) The script will still
return 0 and thus causing a false-negative test result.

Use a test_ran flag to determine if these tests were skipped and
return KSFT_SKIP to make it more clear.

V2: factor out the skip logic from main(), update commit message and
    skip reasons accordingly.
Link: https://bugs.launchpad.net/bugs/1937133
Fixes: f3348a82e727 ("selftests: net: Add port split test")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/devlink_port_split.py | 36 +++++++++++++++++++----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 2b5d6ff..749606c 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -59,6 +59,8 @@ class devlink_ports(object):
         assert stderr == ""
         ports = json.loads(stdout)['port']
 
+        validate_devlink_output(ports, 'flavour')
+
         for port in ports:
             if dev in port:
                 if ports[port]['flavour'] == 'physical':
@@ -220,6 +222,27 @@ def split_splittable_port(port, k, lanes, dev):
     unsplit(port.bus_info)
 
 
+def validate_devlink_output(devlink_data, target_property=None):
+    """
+    Determine if test should be skipped by checking:
+      1. devlink_data contains values
+      2. The target_property exist in devlink_data
+    """
+    skip_reason = None
+    if any(devlink_data.values()):
+        if target_property:
+            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
+            for key in devlink_data:
+                if target_property in devlink_data[key]:
+                    skip_reason = None
+    else:
+        skip_reason = 'devlink output is empty, test skipped'
+
+    if skip_reason:
+        print(skip_reason)
+        sys.exit(KSFT_SKIP)
+
+
 def make_parser():
     parser = argparse.ArgumentParser(description='A test for port splitting.')
     parser.add_argument('--dev',
@@ -231,6 +254,7 @@ def make_parser():
 
 
 def main(cmdline=None):
+    test_ran = False
     parser = make_parser()
     args = parser.parse_args(cmdline)
 
@@ -240,12 +264,9 @@ def main(cmdline=None):
         stdout, stderr = run_command(cmd)
         assert stderr == ""
 
+        validate_devlink_output(json.loads(stdout))
         devs = json.loads(stdout)['dev']
-        if devs:
-            dev = list(devs.keys())[0]
-        else:
-            print("no devlink device was found, test skipped")
-            sys.exit(KSFT_SKIP)
+        dev = list(devs.keys())[0]
 
     cmd = "devlink dev show %s" % dev
     stdout, stderr = run_command(cmd)
@@ -277,6 +298,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        test_ran = True
+
+    if not test_ran:
+        print("Test not started, no suitable device for the test")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
-- 
2.7.4

