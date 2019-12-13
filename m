Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBD611EBD1
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfLMUZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:25:02 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:34602 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfLMUZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1576268700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RwiZx6j+DyBiYsNObAy5UY+snnk7orIrottOERohqro=;
        b=EZ6EepEhT4FhJbquChhDi6RgH2KvRqwu1gK6B6gAD6oWoDjI6zN6be/su1QSdgND4eh51m
        WQkTEuDNBVPVNIBe0Iy2gaaHaQToXsVMNLDHnD9FCYYUtVqB5wH05tVmkDqo6l8uHK1swQ
        kYBehJ2DR2SlcYkSjCB0nIhRH+QrEdA=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 2/2] ipv6: Annotate ipv6_addr_is_* bitwise pointer casts
Date:   Fri, 13 Dec 2019 21:24:28 +0100
Message-Id: <20191213202428.13869-2-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213202428.13869-1-sven@narfation.org>
References: <20191213202428.13869-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse commit 6002ded74587 ("add a flag to warn on casts to/from
bitwise pointers") introduced a check for non-direct casts from/to
restricted datatypes (when -Wbitwise-pointer is enabled).

This triggered a warning in the 64 bit optimized ipv6_addr_is_*() functions
because sparse doesn't know that the buffer already points to some data in
the correct bitwise integer format. But these were correct and can
therefore be marked with __force to signalize sparse an intended cast to a
specific bitwise type.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 include/net/addrconf.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 1bab88184d3c..a088349dd94f 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -437,7 +437,7 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
 static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-	__be64 *p = (__be64 *)addr;
+	__be64 *p = (__force __be64 *)addr;
 	return ((p[0] ^ cpu_to_be64(0xff02000000000000UL)) | (p[1] ^ cpu_to_be64(1))) == 0UL;
 #else
 	return ((addr->s6_addr32[0] ^ htonl(0xff020000)) |
@@ -449,7 +449,7 @@ static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
 static inline bool ipv6_addr_is_ll_all_routers(const struct in6_addr *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-	__be64 *p = (__be64 *)addr;
+	__be64 *p = (__force __be64 *)addr;
 	return ((p[0] ^ cpu_to_be64(0xff02000000000000UL)) | (p[1] ^ cpu_to_be64(2))) == 0UL;
 #else
 	return ((addr->s6_addr32[0] ^ htonl(0xff020000)) |
@@ -466,7 +466,7 @@ static inline bool ipv6_addr_is_isatap(const struct in6_addr *addr)
 static inline bool ipv6_addr_is_solict_mult(const struct in6_addr *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-	__be64 *p = (__be64 *)addr;
+	__be64 *p = (__force __be64 *)addr;
 	return ((p[0] ^ cpu_to_be64(0xff02000000000000UL)) |
 		((p[1] ^ cpu_to_be64(0x00000001ff000000UL)) &
 		 cpu_to_be64(0xffffffffff000000UL))) == 0UL;
@@ -481,7 +481,7 @@ static inline bool ipv6_addr_is_solict_mult(const struct in6_addr *addr)
 static inline bool ipv6_addr_is_all_snoopers(const struct in6_addr *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-	__be64 *p = (__be64 *)addr;
+	__be64 *p = (__force __be64 *)addr;
 
 	return ((p[0] ^ cpu_to_be64(0xff02000000000000UL)) |
 		(p[1] ^ cpu_to_be64(0x6a))) == 0UL;
-- 
2.20.1

