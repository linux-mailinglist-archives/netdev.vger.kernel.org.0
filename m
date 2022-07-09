Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CC456C60E
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGICxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGICxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DE07AB18
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D4762587
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762C8C341D0;
        Sat,  9 Jul 2022 02:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335184;
        bh=KQXt3Gzss8YBzMSp8mhEUEoZL4eHvrrPa1Jt06umoKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAbLsGp5ojbeIxu/32nWa+6RdTFSB0pD0ihFT3wsvaQjDBKktPRgiV0b+8YSKuF4f
         i5cZv5nodnrE3+yVqcOguZwwSaR58VpZL8A44wXR+NZSrUsmysPS5wd4iEM7j4Ygbf
         qC9tsFCtV5FmAZ9L6yM4bxAhTmZfBYh54swNY2T0Po52vOzojj2Guzvn4sXaPB+Jq5
         cmVpW1bHpxgLH61a49mtR5xVyBXJQDVE4he1jDM/LEzNRBzfL2Nt1vDGophqJDa6as
         KsL9aM8FysApzhQBldnI9QRBV5ebqtqY5C7VY8zczC1ieUcnp3Rt8bgb3Y8MTLV9im
         G8eD1C9502XHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] selftests: tls: add test for NoPad getsockopt
Date:   Fri,  8 Jul 2022 19:52:55 -0700
Message-Id: <20220709025255.323864-5-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220709025255.323864-1-kuba@kernel.org>
References: <20220709025255.323864-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure setsockopt / getsockopt behave as expected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e71ec5846be9..dc26aae0feb0 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1674,6 +1674,57 @@ TEST(keysizes) {
 	close(cfd);
 }
 
+TEST(no_pad) {
+	struct tls12_crypto_info_aes_gcm_256 tls12;
+	int ret, fd, cfd, val;
+	socklen_t len;
+	bool notls;
+
+	memset(&tls12, 0, sizeof(tls12));
+	tls12.info.version = TLS_1_3_VERSION;
+	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_256;
+
+	ulp_sock_pair(_metadata, &fd, &cfd, &notls);
+
+	if (notls)
+		exit(KSFT_SKIP);
+
+	ret = setsockopt(fd, SOL_TLS, TLS_TX, &tls12, sizeof(tls12));
+	EXPECT_EQ(ret, 0);
+
+	ret = setsockopt(cfd, SOL_TLS, TLS_RX, &tls12, sizeof(tls12));
+	EXPECT_EQ(ret, 0);
+
+	val = 1;
+	ret = setsockopt(cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+			 (void *)&val, sizeof(val));
+	EXPECT_EQ(ret, 0);
+
+	len = sizeof(val);
+	val = 2;
+	ret = getsockopt(cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+			 (void *)&val, &len);
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(val, 1);
+	EXPECT_EQ(len, 4);
+
+	val = 0;
+	ret = setsockopt(cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+			 (void *)&val, sizeof(val));
+	EXPECT_EQ(ret, 0);
+
+	len = sizeof(val);
+	val = 2;
+	ret = getsockopt(cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+			 (void *)&val, &len);
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(val, 0);
+	EXPECT_EQ(len, 4);
+
+	close(fd);
+	close(cfd);
+}
+
 TEST(tls_v6ops) {
 	struct tls_crypto_info_keys tls12;
 	struct sockaddr_in6 addr, addr2;
-- 
2.36.1

