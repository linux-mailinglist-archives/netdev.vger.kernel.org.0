Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A740157BF3E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 22:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGTUhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGTUhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 16:37:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED0213D7B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 13:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5128C61CC4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 20:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61847C341CA;
        Wed, 20 Jul 2022 20:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658349425;
        bh=iqeBpZtFe+6HoId0VelVWRF8fqQi70TiPkmYkSSWVqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NR/FBEbea3+zK0Pu9wi/emqYeLyfBANF+MJTfGWK2jRYP/kgTW+tSk63//nKLWByi
         ++5nHJ/VKl7JMq8YnXkJOEric1JWQqEAPZ1jfzIizohl+/lIBbtiWdp4xzAwZXl939
         q2qijYg7Sep5ke5B02NUK/vx60jW/cbVFCWPCOEhNN5JNnT0CmfTyQsFpFKbfcPlj3
         p24Hhppck/tMcc6NwI7Y1r1+jD9uN8+glgbxbPZVnnn9/eMqcVV8OVA5oZQCq3KehN
         qBrY6zWBrNWDYP485dG7rMslu4rq1kWSpRyxNfmDul/AaK+EUWbRQtLbzc/oKtoFDu
         9HbsOvacYNslw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] selftests: tls: add a test for timeo vs lock
Date:   Wed, 20 Jul 2022 13:37:01 -0700
Message-Id: <20220720203701.2179034-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220720203701.2179034-1-kuba@kernel.org>
References: <20220720203701.2179034-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test for recv timeout. Place it in the tls_err
group, so it only runs for TLS 1.2 and 1.3 but not
for every AEAD out there.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 32 +++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 6ada4c28c188..2cbb12736596 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1605,6 +1605,38 @@ TEST_F(tls_err, bad_cmsg)
 	EXPECT_EQ(errno, EBADMSG);
 }
 
+TEST_F(tls_err, timeo)
+{
+	struct timeval tv = { .tv_usec = 10000, };
+	char buf[128];
+	int ret;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	ret = setsockopt(self->cfd2, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
+	ASSERT_EQ(ret, 0);
+
+	ret = fork();
+	ASSERT_GE(ret, 0);
+
+	if (ret) {
+		usleep(1000); /* Give child a head start */
+
+		EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+		EXPECT_EQ(errno, EAGAIN);
+
+		EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+		EXPECT_EQ(errno, EAGAIN);
+
+		wait(&ret);
+	} else {
+		EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+		EXPECT_EQ(errno, EAGAIN);
+		exit(0);
+	}
+}
+
 TEST(non_established) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.36.1

