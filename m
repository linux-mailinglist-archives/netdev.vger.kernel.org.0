Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17EA225FC1
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgGTMsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgGTMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6859FC0619D2;
        Mon, 20 Jul 2020 05:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qqSXdt/0/kfIYmhxAmEpiFRzMh1TsKqQoMELThw3G/I=; b=Ri8VLRhEKVWjMNRsh2yUT4emOf
        P0lFd6B/MInuauhmUppRaPEzw+xKr6XUx6WvwDMMh/NpYwTIXe6n71llcDe5D034yUkVOJMgRZ7fE
        oYodq0FEjAIe16P8s1uZzQtrVelmOgzfm9QKf3ls5XzHPbpsURnLhMYphR1+d4ZSXJSspJijbjQ+2
        uoCZR6U+CnU3OhLHwnGxvwMvVRPbWYbRCZCzvAc+3EZy0qljIJfZPYF9RuiboWVvp2GQlI62qnWjg
        UmnNlPHh+sDoTHE4iUPtCkCKAZlMc8cgMmuX43OGc60EjnJ9a1S9bNgzrAzfIO/f+DhRWM5Ni3XIw
        JNzeulWQ==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVCx-0004Wh-JK; Mon, 20 Jul 2020 12:47:53 +0000
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
Subject: [PATCH 04/24] net: switch copy_bpf_fprog_from_user to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:17 +0200
Message-Id: <20200720124737.118617-5-hch@lst.de>
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
 include/linux/filter.h | 3 ++-
 net/core/filter.c      | 6 +++---
 net/core/sock.c        | 6 ++++--
 net/packet/af_packet.c | 4 ++--
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4d049c8e1fbeaa..87954ef126df77 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -20,6 +20,7 @@
 #include <linux/kallsyms.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/sockptr.h>
 #include <crypto/sha.h>
 
 #include <net/sch_generic.h>
@@ -1276,6 +1277,6 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
-int copy_bpf_fprog_from_user(struct sock_fprog *dst, void __user *src, int len);
+int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
 
 #endif /* __LINUX_FILTER_H__ */
diff --git a/net/core/filter.c b/net/core/filter.c
index 2bf6624796d86f..4cc1d381a273fd 100644
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
index d828bfe1c47dfa..91224709869389 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1062,7 +1062,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_ATTACH_FILTER: {
 		struct sock_fprog fprog;
 
-		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
+		ret = copy_bpf_fprog_from_user(&fprog, USER_SOCKPTR(optval),
+					       optlen);
 		if (!ret)
 			ret = sk_attach_filter(&fprog, sk);
 		break;
@@ -1083,7 +1084,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
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

