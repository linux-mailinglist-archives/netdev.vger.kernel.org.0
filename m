Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4000911956F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLJVUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbfLJVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A08246B4;
        Tue, 10 Dec 2019 21:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012316;
        bh=8keJoVDJcCZfsw467TcPzFQmkinK6RE0pvbE92Y/pJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0SC+9n2wAzy6ABWnbPLprh5pLMbzG7AG+pPwE4ZNndK+MQZjAD6V1ygLSs2tDmPn
         UkR2j8wcJenKRf6xWP/lqZn0T6MkrCQOoe1BJn4hGeAYJnTH3NqzMZ0ZjlNRC/WHaX
         UzgL8CWA8ZbvlQ5dC7nb9tyzGobp+RYM2vLQDihU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 250/350] selftests: net: Fix printf format warnings on arm
Date:   Tue, 10 Dec 2019 16:05:55 -0500
Message-Id: <20191210210735.9077-211-sashal@kernel.org>
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

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 670cd6849ea36ea4df2f2941cf4717dff8755abe ]

Fix printf format warnings on arm (and other 32bit arch).

 - udpgso.c and udpgso_bench_tx use %lu for size_t but it
   should be unsigned long long on 32bit arch.

 - so_txtime.c uses %ld for int64_t, but it should be
   unsigned long long on 32bit arch.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_txtime.c       | 4 ++--
 tools/testing/selftests/net/udpgso.c          | 3 ++-
 tools/testing/selftests/net/udpgso_bench_tx.c | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 53f598f066470..34df4c8882afb 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -105,8 +105,8 @@ static void do_recv_one(int fdr, struct timed_send *ts)
 	tstop = (gettime_ns() - glob_tstart) / 1000;
 	texpect = ts->delay_us >= 0 ? ts->delay_us : 0;
 
-	fprintf(stderr, "payload:%c delay:%ld expected:%ld (us)\n",
-			rbuf[0], tstop, texpect);
+	fprintf(stderr, "payload:%c delay:%lld expected:%lld (us)\n",
+			rbuf[0], (long long)tstop, (long long)texpect);
 
 	if (rbuf[0] != ts->data)
 		error(1, 0, "payload mismatch. expected %c", ts->data);
diff --git a/tools/testing/selftests/net/udpgso.c b/tools/testing/selftests/net/udpgso.c
index 614b31aad168b..c66da6ffd6d8d 100644
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -440,7 +440,8 @@ static bool __send_one(int fd, struct msghdr *msg, int flags)
 	if (ret == -1)
 		error(1, errno, "sendmsg");
 	if (ret != msg->msg_iov->iov_len)
-		error(1, 0, "sendto: %d != %lu", ret, msg->msg_iov->iov_len);
+		error(1, 0, "sendto: %d != %llu", ret,
+			(unsigned long long)msg->msg_iov->iov_len);
 	if (msg->msg_flags)
 		error(1, 0, "sendmsg: return flags 0x%x\n", msg->msg_flags);
 
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index ada99496634aa..17512a43885e7 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -405,7 +405,8 @@ static int send_udp_segment(int fd, char *data)
 	if (ret == -1)
 		error(1, errno, "sendmsg");
 	if (ret != iov.iov_len)
-		error(1, 0, "sendmsg: %u != %lu\n", ret, iov.iov_len);
+		error(1, 0, "sendmsg: %u != %llu\n", ret,
+			(unsigned long long)iov.iov_len);
 
 	return 1;
 }
-- 
2.20.1

