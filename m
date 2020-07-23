Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC97322A840
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgGWGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGWGJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798F8C0619E2;
        Wed, 22 Jul 2020 23:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=xqGJvoPJ0+pH4qYG06e/7bN83cyQPL98EGqqjHTTiVQ=; b=tp0Qjqxv0RF9S9VMvHxOQakmQ+
        NHHCC0pZ4D54ej/cePwKmpeQERvhgixf2rr+yFCMAku4YwZ7qHeZ23zUko4Runxz4X2FA51oNK9RB
        G71rtpRMLN+TsNxoueQ+MRUu2h3xtmBHPMKP/izudC5N1oy/s4c0lP2BwaH2EI/Tr0TB9gDhdqJ6a
        rycFr/S96lGHvxszuLGeDv20/dHJLbjMO/W0HRsKz2fbUItwUz/GhoTeBU/3lzVe84kUEMznjTO9R
        ZoRl8WaL9OyZSPxjaiWAD5kw4pVGMaXBipOjPZoChto8wAEpQi6Fg9FEFIqXI5trxbLidsCIfPpe2
        WB6TV97Q==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUPv-0003kl-1X; Thu, 23 Jul 2020 06:09:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 07/26] net: switch sock_set_timeout to sockptr_t
Date:   Thu, 23 Jul 2020 08:08:49 +0200
Message-Id: <20200723060908.50081-8-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a sockptr_t to prepare for set_fs-less handling of the kernel
pointer from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/core/sock.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5b55bc9397f282..8b9eddaff868a5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -361,7 +361,8 @@ static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 	return sizeof(tv);
 }
 
-static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool old_timeval)
+static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
+			    bool old_timeval)
 {
 	struct __kernel_sock_timeval tv;
 
@@ -371,7 +372,7 @@ static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool
 		if (optlen < sizeof(tv32))
 			return -EINVAL;
 
-		if (copy_from_user(&tv32, optval, sizeof(tv32)))
+		if (copy_from_sockptr(&tv32, optval, sizeof(tv32)))
 			return -EFAULT;
 		tv.tv_sec = tv32.tv_sec;
 		tv.tv_usec = tv32.tv_usec;
@@ -380,14 +381,14 @@ static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool
 
 		if (optlen < sizeof(old_tv))
 			return -EINVAL;
-		if (copy_from_user(&old_tv, optval, sizeof(old_tv)))
+		if (copy_from_sockptr(&old_tv, optval, sizeof(old_tv)))
 			return -EFAULT;
 		tv.tv_sec = old_tv.tv_sec;
 		tv.tv_usec = old_tv.tv_usec;
 	} else {
 		if (optlen < sizeof(tv))
 			return -EINVAL;
-		if (copy_from_user(&tv, optval, sizeof(tv)))
+		if (copy_from_sockptr(&tv, optval, sizeof(tv)))
 			return -EFAULT;
 	}
 	if (tv.tv_usec < 0 || tv.tv_usec >= USEC_PER_SEC)
@@ -1051,12 +1052,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_RCVTIMEO_OLD:
 	case SO_RCVTIMEO_NEW:
-		ret = sock_set_timeout(&sk->sk_rcvtimeo, optval, optlen, optname == SO_RCVTIMEO_OLD);
+		ret = sock_set_timeout(&sk->sk_rcvtimeo, USER_SOCKPTR(optval),
+				       optlen, optname == SO_RCVTIMEO_OLD);
 		break;
 
 	case SO_SNDTIMEO_OLD:
 	case SO_SNDTIMEO_NEW:
-		ret = sock_set_timeout(&sk->sk_sndtimeo, optval, optlen, optname == SO_SNDTIMEO_OLD);
+		ret = sock_set_timeout(&sk->sk_sndtimeo, USER_SOCKPTR(optval),
+				       optlen, optname == SO_SNDTIMEO_OLD);
 		break;
 
 	case SO_ATTACH_FILTER: {
-- 
2.27.0

