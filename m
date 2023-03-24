Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F316C84A0
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCXSSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjCXSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:18:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C084D212B;
        Fri, 24 Mar 2023 11:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ECC6B825BC;
        Fri, 24 Mar 2023 18:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C66C433A0;
        Fri, 24 Mar 2023 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679681880;
        bh=QoUn567074XC9ppRqtawp3lrQ+338iFlTv1JFRF1hh8=;
        h=From:To:Cc:Subject:Date:From;
        b=YtvE4YWYlI8iIj0cCq34UY91N8ixrk4Ji/szMRwVEWXf408Hh9hEZVc1yxk0r5II+
         PlqKhZIZ8ATT6fWI0gehUgT2j8c89LtwPXSW9/Ghcl8KSfCTV9dCIzJN90iv/QAgRf
         YBWJs4Yx6SwnRLGiPSANhFsTcc41vKsKw/W6GjFAlzR8SU26UZGICJDvZUhFEPqdY/
         VV6/8ZXIDy0rTPjFdwVi8wyhd6NqLiuUa1YBMdeHPko3/aIxc37XqaDPH0BnPiCDJ2
         0nqPwNuUYzfx8inbz0zilOwo6JQpNS6rxRxVxyRb1WaMluvORHOq6ktZnIEWwjT0EH
         kheLtybhkTA/A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next] selftests: tls: add a test for queuing data before setting the ULP
Date:   Fri, 24 Mar 2023 11:17:57 -0700
Message-Id: <20230324181757.2407412-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other tests set up the connection fully on both ends before
communicating any data. Add a test which will queue up TLS
records to TCP before the TLS ULP is installed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/net/tls.c | 45 +++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 2cbb12736596..e699548d4247 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1820,4 +1820,49 @@ TEST(tls_v6ops) {
 	close(sfd);
 }
 
+TEST(prequeue) {
+	struct tls_crypto_info_keys tls12;
+	char buf[20000], buf2[20000];
+	struct sockaddr_in addr;
+	int sfd, cfd, ret, fd;
+	socklen_t len;
+
+	len = sizeof(addr);
+	memrnd(buf, sizeof(buf));
+
+	tls_crypto_info_init(TLS_1_2_VERSION, TLS_CIPHER_AES_GCM_256, &tls12);
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	addr.sin_port = 0;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	sfd = socket(AF_INET, SOCK_STREAM, 0);
+
+	ASSERT_EQ(bind(sfd, &addr, sizeof(addr)), 0);
+	ASSERT_EQ(listen(sfd, 10), 0);
+	ASSERT_EQ(getsockname(sfd, &addr, &len), 0);
+	ASSERT_EQ(connect(fd, &addr, sizeof(addr)), 0);
+	ASSERT_GE(cfd = accept(sfd, &addr, &len), 0);
+	close(sfd);
+
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	if (ret) {
+		ASSERT_EQ(errno, ENOENT);
+		SKIP(return, "no TLS support");
+	}
+
+	ASSERT_EQ(setsockopt(fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
+	EXPECT_EQ(send(fd, buf, sizeof(buf), MSG_DONTWAIT), sizeof(buf));
+
+	ASSERT_EQ(setsockopt(cfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls")), 0);
+	ASSERT_EQ(setsockopt(cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
+	EXPECT_EQ(recv(cfd, buf2, sizeof(buf2), MSG_WAITALL), sizeof(buf2));
+
+	EXPECT_EQ(memcmp(buf, buf2, sizeof(buf)), 0);
+
+	close(fd);
+	close(cfd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.39.2

