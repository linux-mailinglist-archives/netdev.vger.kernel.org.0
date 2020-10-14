Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB2928E90D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388050AbgJNXCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:02:32 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42481 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbgJNXCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:02:18 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 075e12dc;
        Wed, 14 Oct 2020 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=EPozuoj+BDm/fNTp6nmCgRrnb
        EI=; b=gYz9PJ4B7EuU6vk6qPqdAddg4bDnwzOOhB6j96pC1QC6JhgGVLnYQz//V
        MCUGHyzXTkEynX7iFMjllnvi0ui1qLCCbWWq0E6/JfxIbFUmwx85fYInWLGTU2x8
        uGMPSFB6nnmKrmWU585OZjOG9jA9TOlN56cqtPJG6LWOlxlD0RJsWYdrar/f8hVM
        1zTcSfx+0yvy532DRFJMpXnnpv6TJp4EZ5C+x36/7kFXFanjjCpD+5ol4Sh/8jd6
        aj0bz65xTT3as0O4g2fOyDLcEbpkGSKn1Fh7X1lw7JrRZdsIiBt2eJ0C13DqlPUO
        kF+2z+5Ug6eHBHfoQXEPlMCqc9wZA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 992bda79 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Oct 2020 22:28:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] powerpc32: don't adjust unmoved stack pointer in csum_partial_copy_generic() epilogue
Date:   Thu, 15 Oct 2020 01:02:09 +0200
Message-Id: <20201014230209.427011-1-Jason@zx2c4.com>
In-Reply-To: <20201014222650.GA390346@zx2c4.com>
References: <20201014222650.GA390346@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change to the checksum code removed usage of some extra
arguments, alongside with storage on the stack for those, and the stack
pointer no longer needed to be adjusted in the function prologue. But, a
left over subtraction wasn't removed in the function epilogue, causing
the function to return with the stack pointer moved 16 bytes away from
where it should have. This corrupted local state and lead to weird
crashes. This commit simply removes the leftover instruction from the
epilogue.

Fixes: 70d65cd555c5 ("ppc: propagate the calling conventions change down to csum_partial_copy_generic()")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/lib/checksum_32.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/lib/checksum_32.S b/arch/powerpc/lib/checksum_32.S
index ec5cd2dede35..27d9070617df 100644
--- a/arch/powerpc/lib/checksum_32.S
+++ b/arch/powerpc/lib/checksum_32.S
@@ -236,7 +236,6 @@ _GLOBAL(csum_partial_copy_generic)
 	slwi	r0,r0,8
 	adde	r12,r12,r0
 66:	addze	r3,r12
-	addi	r1,r1,16
 	beqlr+	cr7
 	rlwinm	r3,r3,8,0,31	/* odd destination address: rotate one byte */
 	blr
-- 
2.28.0

