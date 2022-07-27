Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751D5581E10
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiG0DPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240249AbiG0DPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9291F618;
        Tue, 26 Jul 2022 20:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8DAE6179E;
        Wed, 27 Jul 2022 03:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC23C43470;
        Wed, 27 Jul 2022 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891728;
        bh=98m1MP/BsUSS1HT5ZOJ6sMn10injMVph2ZMCGFuPrsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIBybeH8Vv+ALbEwqhddGczxN/v8jvBikvgOkDwKuiil0kPdiGk94TnuV4sZxKecY
         y3nP9COxHmObRFf97kr4k6ZoEmW/T5UEgTzOUfIeIQePXJwOEBVZsrs0DQG1Ql3FOh
         4/c6gHvBNRb191C8p9xTFKXOe1Mdj6OVu66EPsqA/7dbLdIkWMepLWuarkm+gFYa78
         URhKcDWPKGh1/WhjSSrLFizYTJN/repVz8wlzLJ5eUlY+0lpf0UxUHw9bVr1nNO7Z6
         v5qEZfE72B9NiyzhXJUHxHobLYOlJHy+xdG/PlN2w31fbPG50DmP4bWZ743Mvg0ThR
         uKnp6uSW9iVaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/4] selftests: tls: handful of memrnd() and length checks
Date:   Tue, 26 Jul 2022 20:15:21 -0700
Message-Id: <20220727031524.358216-2-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727031524.358216-1-kuba@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a handful of memory randomizations and precise length checks.
Nothing is really broken here, I did this to increase confidence
when debugging. It does fix a GCC warning, tho. Apparently GCC
recognizes that memory needs to be initialized for send() but
does not recognize that for write().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/net/tls.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 4ecbac197c46..2cbb12736596 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -644,12 +644,14 @@ TEST_F(tls, splice_from_pipe2)
 	int p2[2];
 	int p[2];
 
+	memrnd(mem_send, sizeof(mem_send));
+
 	ASSERT_GE(pipe(p), 0);
 	ASSERT_GE(pipe(p2), 0);
-	EXPECT_GE(write(p[1], mem_send, 8000), 0);
-	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, 8000, 0), 0);
-	EXPECT_GE(write(p2[1], mem_send + 8000, 8000), 0);
-	EXPECT_GE(splice(p2[0], NULL, self->fd, NULL, 8000, 0), 0);
+	EXPECT_EQ(write(p[1], mem_send, 8000), 8000);
+	EXPECT_EQ(splice(p[0], NULL, self->fd, NULL, 8000, 0), 8000);
+	EXPECT_EQ(write(p2[1], mem_send + 8000, 8000), 8000);
+	EXPECT_EQ(splice(p2[0], NULL, self->fd, NULL, 8000, 0), 8000);
 	EXPECT_EQ(recv(self->cfd, mem_recv, send_len, MSG_WAITALL), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
@@ -683,10 +685,12 @@ TEST_F(tls, splice_to_pipe)
 	char mem_recv[TLS_PAYLOAD_MAX_LEN];
 	int p[2];
 
+	memrnd(mem_send, sizeof(mem_send));
+
 	ASSERT_GE(pipe(p), 0);
-	EXPECT_GE(send(self->fd, mem_send, send_len, 0), 0);
-	EXPECT_GE(splice(self->cfd, NULL, p[1], NULL, send_len, 0), 0);
-	EXPECT_GE(read(p[0], mem_recv, send_len), 0);
+	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), send_len);
+	EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
@@ -875,6 +879,8 @@ TEST_F(tls, multiple_send_single_recv)
 	char recv_mem[2 * 10];
 	char send_mem[10];
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_GE(send(self->fd, send_mem, send_len, 0), 0);
 	EXPECT_GE(send(self->fd, send_mem, send_len, 0), 0);
 	memset(recv_mem, 0, total_len);
@@ -891,6 +897,8 @@ TEST_F(tls, single_send_multiple_recv_non_align)
 	char recv_mem[recv_len * 2];
 	char send_mem[total_len];
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
 	memset(recv_mem, 0, total_len);
 
@@ -936,10 +944,10 @@ TEST_F(tls, recv_peek)
 	char buf[15];
 
 	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
-	EXPECT_NE(recv(self->cfd, buf, send_len, MSG_PEEK), -1);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_PEEK), send_len);
 	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
 	memset(buf, 0, sizeof(buf));
-	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
 	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
 }
 
-- 
2.37.1

