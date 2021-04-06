Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3B355E98
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbhDFWMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243688AbhDFWMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B6A613CF;
        Tue,  6 Apr 2021 22:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747120;
        bh=024eEXW6rUm55DFWDo7bYXYV3B9uGF+OotVDi1OOyw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbSl9mFkXCsB8dy8iv1Q9wWTLkcdNAIY0PycXWrJZUPi80dFlKwncxK1ROVIPEVEG
         VYFYF9v/7+HMC+9ma1YqZEC7zec0jCuc+WU0XOoVL9nO1UkQCaG1XJJ13gWmup9hl6
         bojskzaz2QinRc4Ww/BH6jqbjAAn1qAy5eeeKx6Hn+xrFAUqC82+8RoodSJ3hmZ1/p
         CR5kt45gY7mOCdF5AHmhfdTztCRySpWMlCeusvAzxpPpALkV9ayRWTFjoz2tXJfpCI
         Gy8cAzW3uS5UWLNdJD15WNt8Q7cVbcouVWgEteFQ9OXNa2diBeoLKh0soLi4ySxdA7
         rTpQAcA9C/FfA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 09/18] include: bitmap: add macro for bitmap initialization
Date:   Wed,  7 Apr 2021 00:10:58 +0200
Message-Id: <20210406221107.1004-10-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new variadic-macro.h library to implement macro
INITIALIZE_BITMAP(nbits, ...), which can be used for compile time bitmap
initialization in the form
  static DECLARE_BITMAP(bm, 100) = INITIALIZE_BITMAP(100, 7, 9, 66, 98);

The macro uses the BUILD_BUG_ON_ZERO mechanism to ensure a compile-time
error if an argument is out of range.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 include/linux/bitmap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 70a932470b2d..a9e74d3420bf 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -8,6 +8,7 @@
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/variadic-macro.h>
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
@@ -114,6 +115,29 @@
  * contain all bit positions from 0 to 'bits' - 1.
  */
 
+/**
+ * DOC: initialize bitmap
+ * The INITIALIZE_BITMAP(bits, args...) macro expands to a designated
+ * initializer for bitmap of length 'bits', setting each bit specified
+ * in 'args...'.
+ */
+#define _BIT_MEMBER(bit) ((bit) / BITS_PER_LONG)
+#define _VERIFY_BIT(bit, nbits)						\
+	BUILD_BUG_ON_ZERO((bit) < 0 || (bit) >= (nbits))
+#define _INIT_BITMAP_MEMBER_VALUE(bit, member_bit)			\
+	| (_BIT_MEMBER(bit) == _BIT_MEMBER(member_bit)			\
+		? BIT((bit) % BITS_PER_LONG)				\
+		: 0)
+#define _INIT_BITMAP_MEMBER(bit, nbits, ...)				\
+	[_VERIFY_BIT((bit), (nbits)) + _BIT_MEMBER(bit)] =		\
+		(0 EXPAND_FOR_EACH(_INIT_BITMAP_MEMBER_VALUE,		\
+				   (bit), ##__VA_ARGS__)),
+#define INITIALIZE_BITMAP(nbits, ...)					\
+	{								\
+		EXPAND_FOR_EACH_PASS_ARGS(_INIT_BITMAP_MEMBER, (nbits),	\
+					  ##__VA_ARGS__)		\
+	}
+
 /*
  * Allocation and deallocation of bitmap.
  * Provided in lib/bitmap.c to avoid circular dependency.
-- 
2.26.2

