Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8722C321D04
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhBVQa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:30:28 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60986 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhBVQ22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8r6qIde3sFs9t093eU9Rh2Ii/O2i5YprmtUZTFEX6Y0=;
        b=FuAlNWrOVbAuxVSoW/J3PYzAqhJXVVDTrwdVLoEByc+3KEbYLcJFgM5DuFxXC7wkPw4ChR
        uEbFd3tq8osPLt1I5s8fxKXRmhTNYcL5qz6Q3SRVX38maAuA8Iz5d1fEGqliQrDaUNjYgH
        joQWkgZzgeSIr/LkQCpb+Pg9eE4TNJs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08ff0b9b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:26:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 7/7] wireguard: kconfig: use arm chacha even with no neon
Date:   Mon, 22 Feb 2021 17:25:49 +0100
Message-Id: <20210222162549.3252778-8-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The condition here was incorrect: a non-neon fallback implementation is
available on arm32 when NEON is not supported.

Reported-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 260f9f46668b..63339d29be90 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -87,7 +87,7 @@ config WIREGUARD
 	select CRYPTO_CURVE25519_X86 if X86 && 64BIT
 	select ARM_CRYPTO if ARM
 	select ARM64_CRYPTO if ARM64
-	select CRYPTO_CHACHA20_NEON if (ARM || ARM64) && KERNEL_MODE_NEON
+	select CRYPTO_CHACHA20_NEON if ARM || (ARM64 && KERNEL_MODE_NEON)
 	select CRYPTO_POLY1305_NEON if ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_ARM if ARM
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
-- 
2.30.1

