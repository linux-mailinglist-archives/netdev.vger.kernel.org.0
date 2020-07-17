Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99740223475
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgGQG1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgGQGYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC16C061755;
        Thu, 16 Jul 2020 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=f8sxF6lqgSOtJgTg8maQxOEGY1f8ZNeToFNAXuRekpY=; b=ZEqOtR7YleQvC92xGmKC91Kk8L
        WTEXAQTf/mF9q9Sr6E1umt3uL5isI+jl33iT6B+NTWGjBQCHmj5vR2cqc1gH3RLw87ZBI2KJCyK4j
        OsS524C9XTPJYGNJrzCJ0VEVOeyFwAvP/JchrRtBr8ED8bo6wbJFPIQWRaekV0RZYb5LDDC0UrqeR
        Kus4x/xm2hTJTg5FJATe/2UhIbHHDHlA3jUWlAv1s3QZx4Q0PEQpxDBuCxzrE9R/3L9T6dPjNnTit
        /CDWgXJrbMMzBa/1e6cziI38mK/P6j9Kyif5s6YoYnAzkO1g0wtsXDHyWgAfdl3/mbxZnLS51qNWF
        JN+mKrIg==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJmi-00051X-6v; Fri, 17 Jul 2020 06:23:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 02/22] net: streamline __sys_setsockopt
Date:   Fri, 17 Jul 2020 08:23:11 +0200
Message-Id: <20200717062331.691152-3-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return early when sockfd_lookup_light fails to reduce a level of
indentation for most of the function body.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/socket.c | 57 +++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 770503c4ca76c9..49a6daf0293b83 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2107,43 +2107,40 @@ static int __sys_setsockopt(int fd, int level, int optname,
 		return -EINVAL;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock != NULL) {
-		err = security_socket_setsockopt(sock, level, optname);
-		if (err)
-			goto out_put;
+	if (!sock)
+		return err;
 
-		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level,
-						     &optname, optval, &optlen,
-						     &kernel_optval);
+	err = security_socket_setsockopt(sock, level, optname);
+	if (err)
+		goto out_put;
 
-		if (err < 0) {
-			goto out_put;
-		} else if (err > 0) {
-			err = 0;
-			goto out_put;
-		}
+	err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
+					     optval, &optlen, &kernel_optval);
+	if (err < 0)
+		goto out_put;
+	if (err > 0) {
+		err = 0;
+		goto out_put;
+	}
 
-		if (kernel_optval) {
-			set_fs(KERNEL_DS);
-			optval = (char __user __force *)kernel_optval;
-		}
+	if (kernel_optval) {
+		set_fs(KERNEL_DS);
+		optval = (char __user __force *)kernel_optval;
+	}
 
-		if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
-			err =
-			    sock_setsockopt(sock, level, optname, optval,
+	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
+		err = sock_setsockopt(sock, level, optname, optval, optlen);
+	else
+		err = sock->ops->setsockopt(sock, level, optname, optval,
 					    optlen);
-		else
-			err =
-			    sock->ops->setsockopt(sock, level, optname, optval,
-						  optlen);
 
-		if (kernel_optval) {
-			set_fs(oldfs);
-			kfree(kernel_optval);
-		}
-out_put:
-		fput_light(sock->file, fput_needed);
+	if (kernel_optval) {
+		set_fs(oldfs);
+		kfree(kernel_optval);
 	}
+
+out_put:
+	fput_light(sock->file, fput_needed);
 	return err;
 }
 
-- 
2.27.0

