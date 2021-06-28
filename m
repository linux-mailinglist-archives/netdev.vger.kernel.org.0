Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A13B63AE
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhF1O6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:58:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38658 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbhF1O4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:56:54 -0400
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1lxseW-0005sL-Sk; Mon, 28 Jun 2021 14:54:24 +0000
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: devlink_port_split: check devlink returned an element before dereferencing it
Date:   Mon, 28 Jun 2021 16:54:24 +0200
Message-Id: <20210628145424.69146-1-paolo.pisati@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And thus avoid a Python stacktrace:

~/linux/tools/testing/selftests/net$ ./devlink_port_split.py
Traceback (most recent call last):
  File "/home/linux/tools/testing/selftests/net/./devlink_port_split.py",
line 277, in <module> main()
  File "/home/linux/tools/testing/selftests/net/./devlink_port_split.py",
line 242, in main
    dev = list(devs.keys())[0]
IndexError: list index out of range

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/net/devlink_port_split.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 834066d465fc..d162915311fd 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -239,6 +239,9 @@ def main(cmdline=None):
         assert stderr == ""
 
         devs = json.loads(stdout)['dev']
+        if len(devs.keys()) == 0:
+            print("no devlink device found")
+            sys.exit(1)
         dev = list(devs.keys())[0]
 
     cmd = "devlink dev show %s" % dev
-- 
2.30.2

