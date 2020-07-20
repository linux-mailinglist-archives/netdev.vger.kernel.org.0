Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0316226000
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgGTMwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbgGTMsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A97C061794;
        Mon, 20 Jul 2020 05:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NOaRlO8PH56EoeQ6wPKZ+NHx4xWBn4wtfdyd3UU7j5Q=; b=r3wFqS6HvDtdd0R6F6qyrxhLxQ
        0UmwqQvsG/ORHCNVtcyBkrRyN8Jl7NMUK+kN9rgMr7dJqvgRbNpsmGad7MyMT0Cslsg7ne9Zs1UlE
        /RwPyLdiHDpNgBjCzw/HmZWsORXbrednhTKLDHU0qAnYKNBOOFKeNoZ82aOb0D1SeYW1aLzwzDOBP
        heWVXUEQRk3EcbcAs4HVrc9bFRGjDJl3iUtWA6BGC9ZrXLSjvOE0L6VJHRbQKC45uIe6QuMjN7Gk/
        O53gfIacoSmqnhrDUA7vy0qZZc0gL1aupHUgKPNVJamV2BJZVG7ttr+EMAYA95puN7nmqMY+irCXk
        KTg4Ltzw==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVD0-0004Ww-Nu; Mon, 20 Jul 2020 12:47:55 +0000
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
Subject: [PATCH 05/24] net: switch sock_setbindtodevice to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:18 +0200
Message-Id: <20200720124737.118617-6-hch@lst.de>
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
 net/core/sock.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 91224709869389..bd20fc5cce0850 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -608,8 +608,7 @@ int sock_bindtoindex(struct sock *sk, int ifindex, bool lock_sk)
 }
 EXPORT_SYMBOL(sock_bindtoindex);
 
-static int sock_setbindtodevice(struct sock *sk, char __user *optval,
-				int optlen)
+static int sock_setbindtodevice(struct sock *sk, sockptr_t optval, int optlen)
 {
 	int ret = -ENOPROTOOPT;
 #ifdef CONFIG_NETDEVICES
@@ -631,7 +630,7 @@ static int sock_setbindtodevice(struct sock *sk, char __user *optval,
 	memset(devname, 0, sizeof(devname));
 
 	ret = -EFAULT;
-	if (copy_from_user(devname, optval, optlen))
+	if (copy_from_sockptr(devname, optval, optlen))
 		goto out;
 
 	index = 0;
@@ -839,7 +838,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	 */
 
 	if (optname == SO_BINDTODEVICE)
-		return sock_setbindtodevice(sk, optval, optlen);
+		return sock_setbindtodevice(sk, USER_SOCKPTR(optval), optlen);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-- 
2.27.0

