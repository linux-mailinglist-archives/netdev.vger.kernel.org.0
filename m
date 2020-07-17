Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF82223399
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgGQGYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgGQGYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F00C08C5C0;
        Thu, 16 Jul 2020 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/E3yYoXC157551h6xowHq2pNR018OFBhJ9Arvav070Y=; b=o6zhOep28KSjcnYm3J9aHcpkgm
        O2Fcz0+9OvZMn6mbYHPBFH/fhpi9DoauQT0ncpn5viSfaoFF6bLsJITCRXjgfdyqFLmf4LW5Djzbq
        mVD4a9wW/2LPyab9lB73mzm+FvayvQ+EgI8+vOBPzlrpsBjPVCB3G88FaBPOFgmA9Mu2nVuQYxlZH
        5LqOFVBqwVr859Q4epbLvsmne1egzV1tTu7+l4QNJED3wUW/yW3Y/QVQJEeAZPJymdlnG4fe6WTAC
        BSzIX9qF0b7Pb8owGsYurQp2qXY/WMlbn+gcpCALS7U1mCseHNtxJKPafipfiMwCKx140COitXOWS
        xalq63Mw==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJmk-00051o-Jr; Fri, 17 Jul 2020 06:23:55 +0000
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
Subject: [PATCH 03/22] net: streamline __sys_getsockopt
Date:   Fri, 17 Jul 2020 08:23:12 +0200
Message-Id: <20200717062331.691152-4-hch@lst.de>
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
 net/socket.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 49a6daf0293b83..b79376b17b45b7 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2163,28 +2163,25 @@ static int __sys_getsockopt(int fd, int level, int optname,
 	int max_optlen;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock != NULL) {
-		err = security_socket_getsockopt(sock, level, optname);
-		if (err)
-			goto out_put;
+	if (!sock)
+		return err;
 
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+	err = security_socket_getsockopt(sock, level, optname);
+	if (err)
+		goto out_put;
 
-		if (level == SOL_SOCKET)
-			err =
-			    sock_getsockopt(sock, level, optname, optval,
+	max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+
+	if (level == SOL_SOCKET)
+		err = sock_getsockopt(sock, level, optname, optval, optlen);
+	else
+		err = sock->ops->getsockopt(sock, level, optname, optval,
 					    optlen);
-		else
-			err =
-			    sock->ops->getsockopt(sock, level, optname, optval,
-						  optlen);
 
-		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
-						     optval, optlen,
-						     max_optlen, err);
+	err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname, optval,
+					     optlen, max_optlen, err);
 out_put:
-		fput_light(sock->file, fput_needed);
-	}
+	fput_light(sock->file, fput_needed);
 	return err;
 }
 
-- 
2.27.0

