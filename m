Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9CB2BC12D
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgKURw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 12:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgKURw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 12:52:26 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE9622201;
        Sat, 21 Nov 2020 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605981146;
        bh=CKnLxQ3uHonPe6Kfh25rVXkY7XtA3b5QLj9601LwXE4=;
        h=From:To:Cc:Subject:Date:From;
        b=2iQahGgz4rjwEPx+iXgkG2LkERBEsMYmvadI2kWIrcDo+w56CsPT58hgg30ocumdF
         lEfJ6N4hKtkuyYRRV69MRnhNq7/RmCCmtFLEFI+13iGNih60R3eB/pDnbbKRCUjz6w
         o0N55i75iauuVu1EfaC+xejBLe97FqS6ZZLahpiE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, hch@lst.de, arnd@arndb.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] compat: always include linux/compat.h from net/compat.h
Date:   Sat, 21 Nov 2020 09:52:24 -0800
Message-Id: <20201121175224.1465831-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're about to do some reshuffling in networking headers and make
some of the file lose the implicit includes. This results in:

In file included from net/ipv4/netfilter/arp_tables.c:26:
include/net/compat.h:57:23: error: conflicting types for ‘uintptr_t’
 #define compat_uptr_t uintptr_t
                       ^~~~~~~~~
include/asm-generic/compat.h:22:13: note: in expansion of macro ‘compat_uptr_t’
 typedef u32 compat_uptr_t;
             ^~~~~~~~~~~~~
In file included from include/linux/limits.h:6,
                 from include/linux/kernel.h:7,
                 from net/ipv4/netfilter/arp_tables.c:14:
include/linux/types.h:37:24: note: previous declaration of ‘uintptr_t’ was here
 typedef unsigned long  uintptr_t;
                        ^~~~~~~~~

Currently net/compat.h depends on linux/compat.h being included
first. After the upcoming changes this would break the 32bit build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Not sure who officially maintains this. Arnd, Christoph any objections?

 include/net/compat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 745db0d605b6..08a089bbaecc 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -5,10 +5,10 @@
 
 struct sock;
 
-#if defined(CONFIG_COMPAT)
-
 #include <linux/compat.h>
 
+#if defined(CONFIG_COMPAT)
+
 struct compat_msghdr {
 	compat_uptr_t	msg_name;	/* void * */
 	compat_int_t	msg_namelen;
-- 
2.24.1

