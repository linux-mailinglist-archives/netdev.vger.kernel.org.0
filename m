Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F81EE23D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 15:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfKDO1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 09:27:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:40298 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDO1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 09:27:18 -0500
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iRdK4-00007m-8c; Mon, 04 Nov 2019 15:27:12 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net-next] bpf: re-fix skip write only files in debugfs
Date:   Mon,  4 Nov 2019 15:27:02 +0100
Message-Id: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25623/Mon Nov  4 10:57:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5bc60de50dfe ("selftests: bpf: Don't try to read files without
read permission") got reverted as the fix was not working as expected
and real fix came in via 8101e069418d ("selftests: bpf: Skip write
only files in debugfs"). When bpf-next got merged into net-next, the
test_offload.py had a small conflict. Fix the resolution in ae8a76fb8b5d
iby not reintroducing 5bc60de50dfe again.

Fixes: ae8a76fb8b5d ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Alexei Starovoitov <ast@kernel.org>
---
 [
   Hey Jakub, please take a look at the below merge fix ... still trying
   to figure out why the netdev doesn't appear on my test node when I
   wanted to run the test script, but seems independent of the fix.

   [...]
   [ 1901.270493] netdevsim: probe of netdevsim4 failed with error -17
   [...]

   # ./test_offload.py
   Test destruction of generic XDP...
   Traceback (most recent call last):
    File "./test_offload.py", line 800, in <module>
     simdev = NetdevSimDev()
    File "./test_offload.py", line 355, in __init__
     self.wait_for_netdevs(port_count)
    File "./test_offload.py", line 390, in wait_for_netdevs
     raise Exception("netdevices did not appear within timeout")
   Exception: netdevices did not appear within timeout
 ]

 tools/testing/selftests/bpf/test_offload.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index fc8a4319c1b2..1afa22c88e42 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -314,7 +314,10 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
                 continue
 
             p = os.path.join(path, f)
-            if os.path.isfile(p) and os.access(p, os.R_OK):
+            if not os.stat(p).st_mode & stat.S_IRUSR:
+                continue
+
+            if os.path.isfile(p):
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
             elif os.path.isdir(p):
-- 
2.21.0

