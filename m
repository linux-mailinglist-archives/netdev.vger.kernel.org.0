Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A675312D4CE
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfL3WTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfL3WTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B542080A;
        Mon, 30 Dec 2019 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743880;
        bh=1OZPQGiaKxX0+MQaHjiVlEte9ISj8Kql0BOqqLYcXTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU104/S2QaKrpZeNuS4b0AgRo6HpTnHDGLcybeNFX4tnaBNb4NWKvOoGJb3J6P63P
         PVMaSMhbvesQRg7yRlV9cZzLtPIcHyQc8yEo4SFnC2u+x4/l8ljrJMAJWZhyOIZogp
         +1SVN/ryMiBEtc7QRLvqkj+4OaSLOh40y7GlWH4E=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 5/9] net: Add device index to tcp_md5sig
Date:   Mon, 30 Dec 2019 14:14:29 -0800
Message-Id: <20191230221433.2717-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for userspace to specify a device index to limit the scope
of an entry via the TCP_MD5SIG_EXT setsockopt. The existing __tcpm_pad
is renamed to tcpm_ifindex and the new field is only checked if the new
TCP_MD5SIG_FLAG_IFINDEX is set in tcpm_flags. For now, the device index
must point to an L3 master device (e.g., VRF). The API and error
handling are setup to allow the constraint to be relaxed in the future
to any device index.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/tcp.h |  5 +++--
 net/ipv4/tcp_ipv4.c      | 18 ++++++++++++++++++
 net/ipv6/tcp_ipv6.c      | 20 +++++++++++++++++++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 74af1f759cee..d87184e673ca 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -317,14 +317,15 @@ enum {
 #define TCP_MD5SIG_MAXKEYLEN	80
 
 /* tcp_md5sig extension flags for TCP_MD5SIG_EXT */
-#define TCP_MD5SIG_FLAG_PREFIX		1	/* address prefix length */
+#define TCP_MD5SIG_FLAG_PREFIX		0x1	/* address prefix length */
+#define TCP_MD5SIG_FLAG_IFINDEX		0x2	/* ifindex set */
 
 struct tcp_md5sig {
 	struct __kernel_sockaddr_storage tcpm_addr;	/* address associated */
 	__u8	tcpm_flags;				/* extension flags */
 	__u8	tcpm_prefixlen;				/* address prefix */
 	__u16	tcpm_keylen;				/* key length */
-	__u32	__tcpm_pad;				/* zero */
+	int	tcpm_ifindex;				/* device index for scope */
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];		/* key (binary) */
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 30b3f19d6301..4adac9c75343 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1196,6 +1196,24 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			return -EINVAL;
 	}
 
+	if (optname == TCP_MD5SIG_EXT &&
+	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+
+		rcu_read_unlock();
+
+		/* ok to reference set/not set outside of rcu;
+		 * right now device MUST be an L3 master
+		 */
+		if (!dev || !l3index)
+			return -EINVAL;
+	}
+
 	addr = (union tcp_md5_addr *)&sin->sin_addr.s_addr;
 
 	if (!cmd.tcpm_keylen)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 71ad7d89be0f..95e4e1e95db2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -578,10 +578,28 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 		prefixlen = ipv6_addr_v4mapped(&sin6->sin6_addr) ? 32 : 128;
 	}
 
+	if (optname == TCP_MD5SIG_EXT &&
+	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		/* ok to reference set/not set outside of rcu;
+		 * right now device MUST be an L3 master
+		 */
+		if (!dev || !l3index)
+			return -EINVAL;
+	}
+
 	if (!cmd.tcpm_keylen) {
 		if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 			return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
-					      AF_INET, prefixlen, l3index);
+					      AF_INET, prefixlen,
+					      l3index);
 		return tcp_md5_do_del(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
 				      AF_INET6, prefixlen, l3index);
 	}
-- 
2.11.0

