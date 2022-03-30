Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145DC4EB7D5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiC3Bdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241645AbiC3Bda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A36171570
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B20B81AB1
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB59C2BBE4;
        Wed, 30 Mar 2022 01:31:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BF+n7P1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648603902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rd1fOOTwIgXZFBVGAJtLb/E6QegeaOKBJvOuCRt1kYE=;
        b=BF+n7P1LS8im9hyFU/lYZhfZI7/crdrwiClu/Zvx8alrJkc8mP1DqTAyzK0KtxXdB/EuaY
        Mite+Wt0HSqKEtQaxm3Bu0pz5gHVJhL410hkr4KhmyZu4CfCgXk+P52lqsYLVhdDZc9Sfp
        y+3ONyDIZ/eykY/FKKceMeG8J3Gn9ig=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e399f012 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Mar 2022 01:31:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/4] wireguard: selftests: simplify RNG seeding
Date:   Tue, 29 Mar 2022 21:31:25 -0400
Message-Id: <20220330013127.426620-3-Jason@zx2c4.com>
In-Reply-To: <20220330013127.426620-1-Jason@zx2c4.com>
References: <20220330013127.426620-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The seed_rng() function was written to work across lots of old kernels,
back when WireGuard used a big compatibility layer. Now that things have
evolved, we can vastly simplify this, by just marking the RNG as seeded.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/init.c | 26 +++++--------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index c9698120ac9d..0b45055d9de0 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -56,26 +56,14 @@ static void print_banner(void)
 
 static void seed_rng(void)
 {
-	int fd;
-	struct {
-		int entropy_count;
-		int buffer_size;
-		unsigned char buffer[256];
-	} entropy = {
-		.entropy_count = sizeof(entropy.buffer) * 8,
-		.buffer_size = sizeof(entropy.buffer),
-		.buffer = "Adding real entropy is not actually important for these tests. Don't try this at home, kids!"
-	};
+	int bits = 256, fd;
 
-	if (mknod("/dev/urandom", S_IFCHR | 0644, makedev(1, 9)))
-		panic("mknod(/dev/urandom)");
-	fd = open("/dev/urandom", O_WRONLY);
+	pretty_message("[+] Fake seeding RNG...");
+	fd = open("/dev/random", O_WRONLY);
 	if (fd < 0)
-		panic("open(urandom)");
-	for (int i = 0; i < 256; ++i) {
-		if (ioctl(fd, RNDADDENTROPY, &entropy) < 0)
-			panic("ioctl(urandom)");
-	}
+		panic("open(random)");
+	if (ioctl(fd, RNDADDTOENTCNT, &bits) < 0)
+		panic("ioctl(RNDADDTOENTCNT)");
 	close(fd);
 }
 
@@ -270,10 +258,10 @@ static void check_leaks(void)
 
 int main(int argc, char *argv[])
 {
-	seed_rng();
 	ensure_console();
 	print_banner();
 	mount_filesystems();
+	seed_rng();
 	kmod_selftests();
 	enable_logging();
 	clear_leaks();
-- 
2.35.1

