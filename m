Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495AF22A78C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgGWGKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgGWGJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E40C0619DC;
        Wed, 22 Jul 2020 23:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=W9DCuh+32aeos/novSkbFq+x7P6ru3xc8ujj+xYmqPk=; b=fJ+b1K7ZCdgn1uMZIKEm5HMeBR
        0cIOSj/xV0MndLXB38ioamT2fc/m1Ax6l0HP5ni25UAb3ciFwPAFvcfK8iMgJOTrnPfJ4a+lPRZbr
        sGPRZxDlz2wnHW2sr7HnoERsDkThHWPxehSVn1fdikFweIgYpxItFOdf/kTtrgpueInOcKg4K/XT+
        fzkHXbim1yQAU8DDym+kUNqF2vH76iCHONXu2eXi1quSbjcmU8oPbYyYJV7RbFsry7z90ak2XM3Pr
        fdoogmLDYgKBNbdv7llf8EKbFsoHvSRq/nBvwBkhuKQUifvS0NA745IiONvfik2+SRxgIN6Ddwzra
        qMFG8L5Q==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQH-0003p4-T5; Thu, 23 Jul 2020 06:09:42 +0000
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
Subject: [PATCH 23/26] net/tcp: switch ->md5_parse to sockptr_t
Date:   Thu, 23 Jul 2020 08:09:05 +0200
Message-Id: <20200723060908.50081-24-hch@lst.de>
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
 include/net/tcp.h   | 2 +-
 net/ipv4/tcp.c      | 3 ++-
 net/ipv4/tcp_ipv4.c | 4 ++--
 net/ipv6/tcp_ipv6.c | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9f7f7c0c110451..e3c8e1d820214c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2002,7 +2002,7 @@ struct tcp_sock_af_ops {
 					 const struct sk_buff *skb);
 	int		(*md5_parse)(struct sock *sk,
 				     int optname,
-				     char __user *optval,
+				     sockptr_t optval,
 				     int optlen);
 #endif
 };
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 58ede3d62b2e2c..49bf15c27deac7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3249,7 +3249,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
-		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
+		err = tp->af_specific->md5_parse(sk, optname,
+						 USER_SOCKPTR(optval), optlen);
 		break;
 #endif
 	case TCP_USER_TIMEOUT:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index daa39d33702b13..f8913923a6c05e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1195,7 +1195,7 @@ static void tcp_clear_md5_list(struct sock *sk)
 }
 
 static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
-				 char __user *optval, int optlen)
+				 sockptr_t optval, int optlen)
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpm_addr;
@@ -1206,7 +1206,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
 
-	if (copy_from_user(&cmd, optval, sizeof(cmd)))
+	if (copy_from_sockptr(&cmd, optval, sizeof(cmd)))
 		return -EFAULT;
 
 	if (sin->sin_family != AF_INET)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c34b7834fd84a8..305870a72352d6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -567,7 +567,7 @@ static struct tcp_md5sig_key *tcp_v6_md5_lookup(const struct sock *sk,
 }
 
 static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
-				 char __user *optval, int optlen)
+				 sockptr_t optval, int optlen)
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
@@ -577,7 +577,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
 
-	if (copy_from_user(&cmd, optval, sizeof(cmd)))
+	if (copy_from_sockptr(&cmd, optval, sizeof(cmd)))
 		return -EFAULT;
 
 	if (sin6->sin6_family != AF_INET6)
-- 
2.27.0

