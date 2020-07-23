Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DC922A870
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgGWGJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgGWGJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A30C0619DC;
        Wed, 22 Jul 2020 23:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oT1TzeBCiE7PYsKY3KaZ4zyLReXEZMRen8bFjdM9v/g=; b=V0YG7V4rx5A1qxxjwpwI1a6uuM
        HduyTdraT6ektr3EgWlWMGz0vGlHlbYPwfQQDUrhGndXtCF7Ushl0XM427AsckNecE4SZY8H6Gj6t
        1J6QRv06PoKrwom/lYsLRBb+Zxhi9iAvOJ6uF7iqbAWuHkbaBJHUaC+w9atEfs3y7AiQuNIo8FcW8
        Vxh2iQacihv7RJDO2nzPMS3hCbItupEWN4AWE/eDraKBNott6suYIUDVqeV8CB8hxS1xFsCHEc2nX
        S0MGXj1LmMc/GCEyFvGL0MRc0Hp7dLKkAwEkA4lbfPNdLiXxLHfp06GwUz+10rsGW1yVMIDkvb7SW
        EsRGr+aA==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUPs-0003kH-8u; Thu, 23 Jul 2020 06:09:16 +0000
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
Subject: [PATCH 05/26] net: switch copy_bpf_fprog_from_user to sockptr_t
Date:   Thu, 23 Jul 2020 08:08:47 +0200
Message-Id: <20200723060908.50081-6-hch@lst.de>
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
 include/linux/filter.h | 3 ++-
 net/core/filter.c      | 6 +++---
 net/core/sock.c        | 6 ++++--
 net/packet/af_packet.c | 4 ++--
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1c6b6d982bf498..d07a6e973a7d6f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -20,6 +20,7 @@
 #include <linux/kallsyms.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/sockptr.h>
 #include <crypto/sha.h>
 
 #include <net/sch_generic.h>
@@ -1276,7 +1277,7 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
-int copy_bpf_fprog_from_user(struct sock_fprog *dst, void __user *src, int len);
+int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
 
 struct bpf_sk_lookup_kern {
 	u16		family;
diff --git a/net/core/filter.c b/net/core/filter.c
index 3fa16b8c0d616a..29e3455122f772 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -77,14 +77,14 @@
 #include <net/transp_v6.h>
 #include <linux/btf_ids.h>
 
-int copy_bpf_fprog_from_user(struct sock_fprog *dst, void __user *src, int len)
+int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len)
 {
 	if (in_compat_syscall()) {
 		struct compat_sock_fprog f32;
 
 		if (len != sizeof(f32))
 			return -EINVAL;
-		if (copy_from_user(&f32, src, sizeof(f32)))
+		if (copy_from_sockptr(&f32, src, sizeof(f32)))
 			return -EFAULT;
 		memset(dst, 0, sizeof(*dst));
 		dst->len = f32.len;
@@ -92,7 +92,7 @@ int copy_bpf_fprog_from_user(struct sock_fprog *dst, void __user *src, int len)
 	} else {
 		if (len != sizeof(*dst))
 			return -EINVAL;
-		if (copy_from_user(dst, src, sizeof(*dst)))
+		if (copy_from_sockptr(dst, src, sizeof(*dst)))
 			return -EFAULT;
 	}
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 6da54eac2b3456..71fc7e4ddd0648 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1063,7 +1063,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_ATTACH_FILTER: {
 		struct sock_fprog fprog;
 
-		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
+		ret = copy_bpf_fprog_from_user(&fprog, USER_SOCKPTR(optval),
+					       optlen);
 		if (!ret)
 			ret = sk_attach_filter(&fprog, sk);
 		break;
@@ -1084,7 +1085,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_ATTACH_REUSEPORT_CBPF: {
 		struct sock_fprog fprog;
 
-		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
+		ret = copy_bpf_fprog_from_user(&fprog, USER_SOCKPTR(optval),
+					       optlen);
 		if (!ret)
 			ret = sk_reuseport_attach_filter(&fprog, sk);
 		break;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c240fb5de3f014..d8d4f78f78e451 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1536,7 +1536,7 @@ static void __fanout_set_data_bpf(struct packet_fanout *f, struct bpf_prog *new)
 	}
 }
 
-static int fanout_set_data_cbpf(struct packet_sock *po, char __user *data,
+static int fanout_set_data_cbpf(struct packet_sock *po, sockptr_t data,
 				unsigned int len)
 {
 	struct bpf_prog *new;
@@ -1584,7 +1584,7 @@ static int fanout_set_data(struct packet_sock *po, char __user *data,
 {
 	switch (po->fanout->type) {
 	case PACKET_FANOUT_CBPF:
-		return fanout_set_data_cbpf(po, data, len);
+		return fanout_set_data_cbpf(po, USER_SOCKPTR(data), len);
 	case PACKET_FANOUT_EBPF:
 		return fanout_set_data_ebpf(po, data, len);
 	default:
-- 
2.27.0

