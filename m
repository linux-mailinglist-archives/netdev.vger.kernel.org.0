Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DA86ABE05
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCFLU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCFLUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:20:55 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C3325942;
        Mon,  6 Mar 2023 03:20:51 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.uk.vpn [10.172.194.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 875363F261;
        Mon,  6 Mar 2023 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678101644;
        bh=sOYKKn1+ndyAa3vO5ercVplZyfjuZNClfnktikXiNHU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=JHMVzPV5PZwFc2kbK8EgXw2fPBoMOFiagVNhuLcpU3Oa/IPS/k7yPiztmHeDM0sFh
         c93H4sTXEM5SC+B2tWVzKNqRjvT+p5oJcird3YQUGg3dQ0tUzRZg18tzvB9Q/h2l7c
         npNoEeVl/df1+skwdOUkgXGOyBw4d8+30Ll8Ehm9s8p+FU/m3q0/Kp/QBtdMcxEEUi
         W9YJxyFdaFzQtcANo372Uf9aiGQG4moQekP089Y3OJz4RfQRJd7+7rH55r3i8HS9uc
         x10QZFI86KX8UW6kh1wlWCMzIuSh4qdRIdrbCKETMm4NzPuA6dr+0CKi/tULgXT48Q
         5NutbcNe6aIgw==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     idosch@mellanox.com, danieller@mellanox.com, petrm@mellanox.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, po-hsu.lin@canonical.com
Subject: [PATCH] selftests: net: devlink_port_split.py: skip test if no suitable device available
Date:   Mon,  6 Mar 2023 19:19:59 +0800
Message-Id: <20230306111959.429680-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `devlink -j dev show` command output may not contain the "flavour"
key, for example:
  $ devlink -j dev show
  {"dev":{"pci/0001:00:00.0":{},"pci/0002:00:00.0":{}}}

This will cause a KeyError exception. Fix this by checking the key
existence first.

Also, if max lanes is 0 the port splitting won't be tested at all.
but the script will end normally and thus causing a false-negative
test result.

Use a test_ran flag to determine if these tests were skipped and
return KSFT_SKIP accordingly.

Link: https://bugs.launchpad.net/bugs/1937133
Fixes: f3348a82e727 ("selftests: net: Add port split test")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/devlink_port_split.py | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 2b5d6ff..462f3df 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -61,7 +61,7 @@ class devlink_ports(object):
 
         for port in ports:
             if dev in port:
-                if ports[port]['flavour'] == 'physical':
+                if 'flavour' in ports[port] and ports[port]['flavour'] == 'physical':
                     arr.append(Port(bus_info=port, name=ports[port]['netdev']))
 
         return arr
@@ -231,6 +231,7 @@ def make_parser():
 
 
 def main(cmdline=None):
+    test_ran = False
     parser = make_parser()
     args = parser.parse_args(cmdline)
 
@@ -277,6 +278,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        test_ran = True
+
+    if not test_ran:
+        print("No suitable device for the test, test skipped")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
-- 
2.7.4

