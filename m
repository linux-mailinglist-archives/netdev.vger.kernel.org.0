Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B386F67C4B5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbjAZHOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAZHOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9DC46D42
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C44061756
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFC0C433A0;
        Thu, 26 Jan 2023 07:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717269;
        bh=5bx3UCvvOgOMcpOsOlksTtFP2jT80Mmv6NUQ5JH4OwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbxEaaC8iCTOFyKI63+I0g7wwYQ8IJnbnRYtLmc+R73ewh/84FvnVqGLtPmoAaC+i
         JdnCxgXdYvyiBss+4Ep8ktU/nwsx4JI83RPuvYVcwsYZfXj4uVrsc1QXg5JQwGfxVn
         ZXE+sLzLx3biu003LC6RvO35PIGbeBKwkt4QHKOJ2Z8mKNDjc2OE/FCw9DNVhvlkg3
         txALZPjJ4k82hpiZhjxItKRKuVpR1OOkaNoyJWP7DN3/B6CsHQCat4lObxKlbqdr8R
         hGiK/ldG14aWM5NBQ4kUzXKxJFj4c6Ydv8+EnDx5iD9Lhzvg5wPemzuR7Au5TvmYP6
         gC5BJagmvMW0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: [PATCH net-next 03/11] net: checksum: drop the linux/uaccess.h include
Date:   Wed, 25 Jan 2023 23:14:16 -0800
Message-Id: <20230126071424.1250056-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/checksum.h pulls in linux/uaccess.h which is large.

In the x86 header the include seems to not be needed at all.
ARM on the other hand does not include uaccess.h, even tho
it calls access_ok().

In the generic implementation guard the include of linux/uaccess.h
with the same condition as the code that needs it.

With this change pre-processed net/checksum.h shrinks on x86
from 30616 lines to just 1193.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: linux@armlinux.org.uk
CC: tglx@linutronix.de
CC: mingo@redhat.com
CC: bp@alien8.de
CC: dave.hansen@linux.intel.com
CC: x86@kernel.org
CC: hpa@zytor.com
---
 arch/arm/include/asm/checksum.h    | 1 +
 arch/x86/include/asm/checksum_64.h | 1 -
 include/net/checksum.h             | 4 +++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/checksum.h b/arch/arm/include/asm/checksum.h
index f0f54aef3724..d8a13959bff0 100644
--- a/arch/arm/include/asm/checksum.h
+++ b/arch/arm/include/asm/checksum.h
@@ -11,6 +11,7 @@
 #define __ASM_ARM_CHECKSUM_H
 
 #include <linux/in6.h>
+#include <linux/uaccess.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
diff --git a/arch/x86/include/asm/checksum_64.h b/arch/x86/include/asm/checksum_64.h
index 407beebadaf4..4d4a47a3a8ab 100644
--- a/arch/x86/include/asm/checksum_64.h
+++ b/arch/x86/include/asm/checksum_64.h
@@ -9,7 +9,6 @@
  */
 
 #include <linux/compiler.h>
-#include <linux/uaccess.h>
 #include <asm/byteorder.h>
 
 /**
diff --git a/include/net/checksum.h b/include/net/checksum.h
index 6bc783b7a06c..1338cb92c8e7 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -18,8 +18,10 @@
 #include <linux/errno.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
-#include <linux/uaccess.h>
 #include <asm/checksum.h>
+#if !defined(_HAVE_ARCH_COPY_AND_CSUM_FROM_USER) || !defined(HAVE_CSUM_COPY_USER)
+#include <linux/uaccess.h>
+#endif
 
 #ifndef _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
 static __always_inline
-- 
2.39.1

