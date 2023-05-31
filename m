Return-Path: <netdev+bounces-6847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBCC71867E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 463991C20BDC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89321174D2;
	Wed, 31 May 2023 15:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1311F171C5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D3EC433A0;
	Wed, 31 May 2023 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685547356;
	bh=o5FPeUP281Tur/5s4It1VlOpopPVBJhReOl9Rq77ITQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzp6N6pfe8cN2LqPaW83b1IHY7nPdfG7Mge4J8UwTqK4rDNNH4aJozKxWP+nX0T08
	 7ZedXJYn4+6a1iVPehRbSARBZ1E0DzRGing4mC0zdeIuwlgxJcXzY8v+kKCsIfvsF2
	 w2kgBMI9wOJCZWoSzaFAxnvNeUL3rQL5f/qeoPvMRR7MLtAwsRTg/KW63exunahj62
	 rEjVNIbcw3FDGvOwfIHEDyHCE9GViSCWJovUs6+8CS+YH7cIcK8yJBxR7LoIvNEym5
	 kAu3P04hNl0yIdFyfQbEsROtnoF57djDsS+1GvTxe1k+hd5bKm6bGiSVRse10Ee+X4
	 ZfhywgyvNcGew==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] selftests: tls: add tests for poll behavior
Date: Wed, 31 May 2023 08:35:51 -0700
Message-Id: <20230531153551.187141-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230531153551.187141-1-kuba@kernel.org>
References: <20230531153551.187141-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure we don't generate premature POLLIN events.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 131 ++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e699548d4247..eccea9845c65 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -15,6 +15,7 @@
 #include <linux/tcp.h>
 #include <linux/socket.h>
 
+#include <sys/epoll.h>
 #include <sys/types.h>
 #include <sys/sendfile.h>
 #include <sys/socket.h>
@@ -1637,6 +1638,136 @@ TEST_F(tls_err, timeo)
 	}
 }
 
+TEST_F(tls_err, poll_partial_rec)
+{
+	struct pollfd pfd = { };
+	ssize_t rec_len;
+	char rec[256];
+	char buf[128];
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	pfd.fd = self->cfd2;
+	pfd.events = POLLIN;
+	EXPECT_EQ(poll(&pfd, 1, 1), 0);
+
+	memrnd(buf, sizeof(buf));
+	EXPECT_EQ(send(self->fd, buf, sizeof(buf), 0), sizeof(buf));
+	rec_len = recv(self->cfd, rec, sizeof(rec), 0);
+	EXPECT_GT(rec_len, sizeof(buf));
+
+	/* Write 100B, not the full record ... */
+	EXPECT_EQ(send(self->fd2, rec, 100, 0), 100);
+	/* ... no full record should mean no POLLIN */
+	pfd.fd = self->cfd2;
+	pfd.events = POLLIN;
+	EXPECT_EQ(poll(&pfd, 1, 1), 0);
+	/* Now write the rest, and it should all pop out of the other end. */
+	EXPECT_EQ(send(self->fd2, rec + 100, rec_len - 100, 0), rec_len - 100);
+	pfd.fd = self->cfd2;
+	pfd.events = POLLIN;
+	EXPECT_EQ(poll(&pfd, 1, 1), 1);
+	EXPECT_EQ(recv(self->cfd2, rec, sizeof(rec), 0), sizeof(buf));
+	EXPECT_EQ(memcmp(buf, rec, sizeof(buf)), 0);
+}
+
+TEST_F(tls_err, epoll_partial_rec)
+{
+	struct epoll_event ev, events[10];
+	ssize_t rec_len;
+	char rec[256];
+	char buf[128];
+	int epollfd;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	epollfd = epoll_create1(0);
+	ASSERT_GE(epollfd, 0);
+
+	memset(&ev, 0, sizeof(ev));
+	ev.events = EPOLLIN;
+	ev.data.fd = self->cfd2;
+	ASSERT_GE(epoll_ctl(epollfd, EPOLL_CTL_ADD, self->cfd2, &ev), 0);
+
+	EXPECT_EQ(epoll_wait(epollfd, events, 10, 0), 0);
+
+	memrnd(buf, sizeof(buf));
+	EXPECT_EQ(send(self->fd, buf, sizeof(buf), 0), sizeof(buf));
+	rec_len = recv(self->cfd, rec, sizeof(rec), 0);
+	EXPECT_GT(rec_len, sizeof(buf));
+
+	/* Write 100B, not the full record ... */
+	EXPECT_EQ(send(self->fd2, rec, 100, 0), 100);
+	/* ... no full record should mean no POLLIN */
+	EXPECT_EQ(epoll_wait(epollfd, events, 10, 0), 0);
+	/* Now write the rest, and it should all pop out of the other end. */
+	EXPECT_EQ(send(self->fd2, rec + 100, rec_len - 100, 0), rec_len - 100);
+	EXPECT_EQ(epoll_wait(epollfd, events, 10, 0), 1);
+	EXPECT_EQ(recv(self->cfd2, rec, sizeof(rec), 0), sizeof(buf));
+	EXPECT_EQ(memcmp(buf, rec, sizeof(buf)), 0);
+
+	close(epollfd);
+}
+
+TEST_F(tls_err, poll_partial_rec_async)
+{
+	struct pollfd pfd = { };
+	ssize_t rec_len;
+	char rec[256];
+	char buf[128];
+	char token;
+	int p[2];
+	int ret;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	ASSERT_GE(pipe(p), 0);
+
+	memrnd(buf, sizeof(buf));
+	EXPECT_EQ(send(self->fd, buf, sizeof(buf), 0), sizeof(buf));
+	rec_len = recv(self->cfd, rec, sizeof(rec), 0);
+	EXPECT_GT(rec_len, sizeof(buf));
+
+	ret = fork();
+	ASSERT_GE(ret, 0);
+
+	if (ret) {
+		int status, pid2;
+
+		close(p[1]);
+		usleep(1000); /* Give child a head start */
+
+		EXPECT_EQ(send(self->fd2, rec, 100, 0), 100);
+
+		EXPECT_EQ(read(p[0], &token, 1), 1); /* Barrier #1 */
+
+		EXPECT_EQ(send(self->fd2, rec + 100, rec_len - 100, 0),
+			  rec_len - 100);
+
+		pid2 = wait(&status);
+		EXPECT_EQ(pid2, ret);
+		EXPECT_EQ(status, 0);
+	} else {
+		close(p[0]);
+
+		/* Child should sleep in poll(), never get a wake */
+		pfd.fd = self->cfd2;
+		pfd.events = POLLIN;
+		EXPECT_EQ(poll(&pfd, 1, 5), 0);
+
+		EXPECT_EQ(write(p[1], &token, 1), 1); /* Barrier #1 */
+
+		pfd.fd = self->cfd2;
+		pfd.events = POLLIN;
+		EXPECT_EQ(poll(&pfd, 1, 5), 1);
+
+		exit(!_metadata->passed);
+	}
+}
+
 TEST(non_established) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.40.1


