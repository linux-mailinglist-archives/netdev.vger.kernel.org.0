Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA744230FF5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbgG1Qiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731367AbgG1Qis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:38:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F31C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=38yhl6z8pLkoujYyYs/iGNy1UHgim84K0vplDqKrRRg=; b=vUJeEAPmVI2lRPiH0UP/VBlNxZ
        OmlK/KxePCcWzxK7fknk7UJkDOeQiOCeatSRtmFtrZ6+VDUAasyW8KwDKTQRP5ORKA6GdO+hRoTKy
        aWUwNRCcywtHZYMu64Eqhrz6a2xttEER3usg4WMWqedABjk7iHYIyNLsQMQQuRDG2c3UFdhjypuS/
        Sof3gnqkkXdGXva+OEuMIxPdRuDmqg5UXlJCQ6rDsgpFpu0750dzqa2hLg1fwi1Vy9haFyXC/tiOm
        JLKMIDuQ1cIvI+vJ1lyoQWt/OIV0Inf6d09zbapRWAR8hnHituls3K/uXRKDQxP65JFeOni/8njx+
        gZYusOsA==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Scl-0007Wq-Ck; Tue, 28 Jul 2020 16:38:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: [PATCH 4/4] net: improve the user pointer check in init_user_sockptr
Date:   Tue, 28 Jul 2020 18:38:36 +0200
Message-Id: <20200728163836.562074-5-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728163836.562074-1-hch@lst.de>
References: <20200728163836.562074-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure not just the pointer itself but the whole range lies in
the user address space.  For that pass the length and then use
the access_ok helper to do the check.

Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
Reported-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/sockptr.h     | 18 ++++++------------
 net/ipv4/bpfilter/sockopt.c |  2 +-
 net/socket.c                |  2 +-
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 9e6c81d474cba8..96840def9d69cc 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -27,14 +27,6 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
 {
 	return (sockptr_t) { .kernel = p };
 }
-
-static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
-{
-	if ((unsigned long)p >= TASK_SIZE)
-		return -EFAULT;
-	sp->user = p;
-	return 0;
-}
 #else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 typedef struct {
 	union {
@@ -53,14 +45,16 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
 {
 	return (sockptr_t) { .kernel = p, .is_kernel = true };
 }
+#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
-static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
+static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p,
+		size_t size)
 {
-	sp->user = p;
-	sp->is_kernel = false;
+	if (!access_ok(p, size))
+		return -EFAULT;
+	*sp = (sockptr_t) { .user = p };
 	return 0;
 }
-#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
 static inline bool sockptr_is_null(sockptr_t sockptr)
 {
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 94f18d2352d007..545b2640f0194d 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -65,7 +65,7 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
 
 	if (get_user(len, optlen))
 		return -EFAULT;
-	err = init_user_sockptr(&optval, user_optval);
+	err = init_user_sockptr(&optval, user_optval, len);
 	if (err)
 		return err;
 	return bpfilter_mbox_request(sk, optname, optval, len, false);
diff --git a/net/socket.c b/net/socket.c
index 94ca4547cd7c53..aff52e81653ce3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2105,7 +2105,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 	if (optlen < 0)
 		return -EINVAL;
 
-	err = init_user_sockptr(&optval, user_optval);
+	err = init_user_sockptr(&optval, user_optval, optlen);
 	if (err)
 		return err;
 
-- 
2.27.0

