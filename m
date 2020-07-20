Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB88225FE3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgGTMwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgGTMsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23789C061794;
        Mon, 20 Jul 2020 05:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=sgYWyMfm87Lwp87OiHiXBGeztL7pp9vtxgWCGygwlyQ=; b=ohlAv+VYwEBD8MZ2GI6LDCZyTj
        +2dygLPuHwB4q01kC05RSq3Dr+sPFXczHgi0nOgfC+b4SmHYTZerQFRXvPa1y1h6Sb7yBJMpgPxPj
        bIHqMKdY+yDXM0FeLNQFGLH3ZmDZd56XNZ3dvQL19CJPxySpKLErEfzKmf8uwwXZkotGjvEn82DsQ
        Rlao5M7ezXGmItEie2BE4Bm1hJ+YyoD/PaGZSNZTz+x5KM+oXsP+ygCRk2ia3dvcXL43IdfFFl00j
        Is5pnhTz2uV8XvZlYuMUCO8iRi6faULVlv2d0g7DJVpQ/ayBLUp13B2uyjGIPQdVR/lCd8rsoQmNG
        KqzoRfXQ==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVD3-0004XQ-2H; Mon, 20 Jul 2020 12:47:58 +0000
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
Subject: [PATCH 06/24] net: switch sock_set_timeout to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:19 +0200
Message-Id: <20200720124737.118617-7-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
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
index bd20fc5cce0850..d45bb1c2c36abf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -360,7 +360,8 @@ static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 	return sizeof(tv);
 }
 
-static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool old_timeval)
+static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
+			    bool old_timeval)
 {
 	struct __kernel_sock_timeval tv;
 
@@ -370,7 +371,7 @@ static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool
 		if (optlen < sizeof(tv32))
 			return -EINVAL;
 
-		if (copy_from_user(&tv32, optval, sizeof(tv32)))
+		if (copy_from_sockptr(&tv32, optval, sizeof(tv32)))
 			return -EFAULT;
 		tv.tv_sec = tv32.tv_sec;
 		tv.tv_usec = tv32.tv_usec;
@@ -379,14 +380,14 @@ static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool
 
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
@@ -1050,12 +1051,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
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

