Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA842BC255
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgKUVsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgKUVsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:48:46 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D1521D7E;
        Sat, 21 Nov 2020 21:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605995326;
        bh=9xebCy/5h9a08NqCBUdtKx6/KbhB5sEnm1537FibNDY=;
        h=From:To:Cc:Subject:Date:From;
        b=S2vg9Kstz5Ia/EHqsNQHZTI3cmm6jxD3CQKyxBxXHWmQjqy1fjpIabD3u26iculdG
         Gb5KDYo28zOjWxUS7OCxcKWop8VtFkhFjadsVSO2Q6BoE+wcXyDod6U0a519G3l7r4
         VDsjc83TXQMNe9GPjvpaWI0n1kPOvfxE2FgOg/sw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, hch@lst.de, arnd@arndb.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] compat: always include linux/compat.h from net/compat.h
Date:   Sat, 21 Nov 2020 13:48:44 -0800
Message-Id: <20201121214844.1488283-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're about to do reshuffling in networking headers and
eliminate some implicit includes. This results in:

In file included from ../net/ipv4/netfilter/arp_tables.c:26:
include/net/compat.h:60:40: error: unknown type name ‘compat_uptr_t’; did you mean ‘compat_ptr_ioctl’?
    struct sockaddr __user **save_addr, compat_uptr_t *ptr,
                                        ^~~~~~~~~~~~~
                                        compat_ptr_ioctl
include/net/compat.h:61:4: error: unknown type name ‘compat_size_t’; did you mean ‘compat_sigset_t’?
    compat_size_t *len);
    ^~~~~~~~~~~~~
    compat_sigset_t

Currently net/compat.h depends on linux/compat.h being included
first. After the upcoming changes this would break the 32bit build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2:
 - correct the commit message
 - remove the ifdef completely (Arnd)
---
 include/net/compat.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 745db0d605b6..84805bdc4435 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -5,8 +5,6 @@
 
 struct sock;
 
-#if defined(CONFIG_COMPAT)
-
 #include <linux/compat.h>
 
 struct compat_msghdr {
@@ -48,14 +46,6 @@ struct compat_rtentry {
 	unsigned short  rt_irtt;        /* Initial RTT                  */
 };
 
-#else /* defined(CONFIG_COMPAT) */
-/*
- * To avoid compiler warnings:
- */
-#define compat_msghdr	msghdr
-#define compat_mmsghdr	mmsghdr
-#endif /* defined(CONFIG_COMPAT) */
-
 int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg,
 			struct sockaddr __user **save_addr, compat_uptr_t *ptr,
 			compat_size_t *len);
-- 
2.24.1

