Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D18D1194D2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfLJVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbfLJVNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7482465A;
        Tue, 10 Dec 2019 21:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012383;
        bh=ZwC9R2gwg7CqpsLyXbIovA1NDpp7Eh9h2N7McZ70buQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuiCd/JIEFCz+zOL8fscWigdlxYLXd8lIZOU6tAvzReyRVk1wmm6RXfzMFTRJNdvj
         kC1IxYnGItOuNepiPXlrZOm1DlP3+t+dxWtlsxk/YFF7641rDPwTZG9Ememdfla9WY
         CqxSjo7nv7Hu8oHMp+BGwXOlxyMxTp7byooQdQyE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 306/350] selftests, bpf: Fix test_tc_tunnel hanging
Date:   Tue, 10 Dec 2019 16:06:51 -0500
Message-Id: <20191210210735.9077-267-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 3b054b7133b4ad93671c82e8d6185258e3f1a7a5 ]

When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
starting it again every time it is expected to terminate. The exception is
the final client_connect: the server is not started anymore, which ensures
no process is kept running after the test is finished.

For a sit test, though, the script is terminated prematurely without the
final client_connect and the 'nc' process keeps running. This in turn causes
the run_one function in kselftest/runner.sh to hang forever, waiting for the
runaway process to finish.

Ensure a remaining server is terminated on cleanup.

Fixes: f6ad6accaa99 ("selftests/bpf: expand test_tc_tunnel with SIT encap")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/bpf/60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index ff0d31d38061f..7c76b841b17bb 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -62,6 +62,10 @@ cleanup() {
 	if [[ -f "${infile}" ]]; then
 		rm "${infile}"
 	fi
+
+	if [[ -n $server_pid ]]; then
+		kill $server_pid 2> /dev/null
+	fi
 }
 
 server_listen() {
@@ -77,6 +81,7 @@ client_connect() {
 
 verify_data() {
 	wait "${server_pid}"
+	server_pid=
 	# sha1sum returns two fields [sha1] [filepath]
 	# convert to bash array and access first elem
 	insum=($(sha1sum ${infile}))
-- 
2.20.1

