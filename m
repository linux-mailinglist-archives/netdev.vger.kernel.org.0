Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B34556E8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbhKRI27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244270AbhKRI26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:28:58 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA4C061764
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 00:25:58 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:8d84:8075:bcc:d376])
        by albert.telenet-ops.be with bizsmtp
        id KkRv260044DeBRs06kRv0q; Thu, 18 Nov 2021 09:25:55 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mncjy-00DJaP-D6; Thu, 18 Nov 2021 09:25:54 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mnci4-0047wv-Dz; Thu, 18 Nov 2021 09:23:56 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Alexander Aring <aahringo@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc:     "Reported-by : Randy Dunlap" <rdunlap@infradead.org>,
        cluster-devel@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fs: dlm: Protect IPV6 field access by CONFIG_IPV6
Date:   Thu, 18 Nov 2021 09:23:55 +0100
Message-Id: <20211118082355.983825-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IPV6=n:

    In file included from fs/dlm/lowcomms.c:46:
    fs/dlm/lowcomms.c: In function ‘lowcomms_error_report’:
    ./include/net/sock.h:386:34: error: ‘struct sock_common’ has no member named ‘skc_v6_daddr’; did you mean ‘skc_daddr’?
      386 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
	  |                                  ^~~~~~~~~~~~
    ./include/linux/printk.h:422:19: note: in expansion of macro ‘sk_v6_daddr’
      422 |   _p_func(_fmt, ##__VA_ARGS__);    \
	  |                   ^~~~~~~~~~~
    ./include/linux/printk.h:450:26: note: in expansion of macro ‘printk_index_wrap’
      450 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
	  |                          ^~~~~~~~~~~~~~~~~
    ./include/linux/printk.h:644:3: note: in expansion of macro ‘printk’
      644 |   printk(fmt, ##__VA_ARGS__);    \
	  |   ^~~~~~
    fs/dlm/lowcomms.c:612:3: note: in expansion of macro ‘printk_ratelimited’
      612 |   printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
	  |   ^~~~~~~~~~~~~~~~~~

Fix this by protecting the code that accesses IPV6-only fields by a
check for CONFIG_IPV6.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 4c3d90570bcc2b33 ("fs: dlm: don't call kernel_getpeername() in error_report()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/dlm/lowcomms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 203470189011102d..f7fc1ac76ce83a5f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -608,6 +608,7 @@ static void lowcomms_error_report(struct sock *sk)
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "sending to node %d at %pI6c, "
@@ -616,6 +617,7 @@ static void lowcomms_error_report(struct sock *sk)
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
 		break;
+#endif
 	default:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "invalid socket family %d set, "
-- 
2.25.1

