Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F46E567B03
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiGEX7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiGEX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E75183BE;
        Tue,  5 Jul 2022 16:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C723161180;
        Tue,  5 Jul 2022 23:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45840C341CB;
        Tue,  5 Jul 2022 23:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065576;
        bh=TrH56UL/QeqbrnEZBublNVut2fy8/OJX5zbLk8R9wGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf4TZx2UTV7n7pDHCG7g+A8ZWGgN2Cq3NxMZfl3FU454FnvZRni+LbOY8X7ni7ok1
         XeBnhJHfAPscqXTQl87tdy3+THwwXwKE9SSmiwfhQqOuTAUbFV0kLLWLOZL/KJbdyv
         FD5NvHBTNz0yEvxPGrmuUqbcXO0mNWERDG9PWsBKc18yiHSw2WfGNWy/1KHW4omvsF
         EPkcjhtTUa1GZ7KrVNdvj4p7/GqCr18SIjZCXgbdYZpASrHAVG4wJK6/GxImK1NvJa
         /X4E5+GTpY38GICp0L+v8/4Ts+1IGWqHXtMmGTlGJZb/PYgqRmzlSJdzZy6GbXIcOn
         bZpe4sfp8H0OQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/5] selftests: tls: add selftest variant for pad
Date:   Tue,  5 Jul 2022 16:59:25 -0700
Message-Id: <20220705235926.1035407-5-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
References: <20220705235926.1035407-1-kuba@kernel.org>
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

Add a self-test variant with TLS 1.3 nopad set.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 5a149ee94330..51d84f7fe3be 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -235,6 +235,7 @@ FIXTURE_VARIANT(tls)
 {
 	uint16_t tls_version;
 	uint16_t cipher_type;
+	bool nopad;
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_aes_gcm)
@@ -297,9 +298,17 @@ FIXTURE_VARIANT_ADD(tls, 13_aes_gcm_256)
 	.cipher_type = TLS_CIPHER_AES_GCM_256,
 };
 
+FIXTURE_VARIANT_ADD(tls, 13_nopad)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_128,
+	.nopad = true,
+};
+
 FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
+	int one = 1;
 	int ret;
 
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
@@ -315,6 +324,12 @@ FIXTURE_SETUP(tls)
 
 	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len);
 	ASSERT_EQ(ret, 0);
+
+	if (variant->nopad) {
+		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX_EXPECT_NO_PAD,
+				 (void *)&one, sizeof(one));
+		ASSERT_EQ(ret, 0);
+	}
 }
 
 FIXTURE_TEARDOWN(tls)
-- 
2.36.1

