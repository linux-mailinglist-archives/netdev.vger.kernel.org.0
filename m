Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4422A9B99
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKFSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbgKFSHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:07:53 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71B6C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 10:07:52 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id n63so1385307qte.4
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 10:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X/xemGqCPRhXMyrbMR4pd6jQ5DTz0W+8vPSQyjoFwV4=;
        b=eMk/2znrG2NRL/NN9fiPBSW8Z86mN06yg/wH8kNRuo5oz6lRD4M+satgAKI199DyK3
         YMUKugXOx00FJebIZilht7HF6+bYhEEk4ivDJw6II0UpkjbIf1f5nlAdltkj6VuwBr90
         7r9PRIaHZHyklOqPYphMEn7mXLU7dcb9gohnKpQ5DKi+brRBJyXBVdEudX+IQXOdgHKU
         BlRStfjrQm7NAXiO3mZ4no7kC8iBRbAHg1GDyQAHmG2AJhrfiOzcta9h6MGBg2YihgCR
         M5O/xMgM1I+XHiLV0c67bdKkHC5+GxLRrDCQ5QPxMt4R6txlTY0CP/Jax12f6xDVUsoT
         Lj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X/xemGqCPRhXMyrbMR4pd6jQ5DTz0W+8vPSQyjoFwV4=;
        b=YRe1R8ZU3iYlrTk9HdRVD78NylzG/8yfOo+wujz4dAs0ii7rZ49u4i6APQ3RGKra35
         JlqwUheCnyzbsFR8c/CE7f85gmewj7EHFJpf5egJzstmr7z0Rh6PonbKMOqyG0h9H2Id
         wzNgFTcgVYd9DS6Tz3U4rmwvRzBJm9DJF5SOVUT7WxRag3RekjTMqnt1/IeaNPCQ+sQn
         OotGMEvmgCq3y5HJCdlACzYYKvt41CpiMBWES9ZGU1QY3Aj5CxViTJhO3JvWe0Aq+/L+
         TJRNjEf+9BDQinBe/DteeI3smjIi/xGFvQtyTtRoUTy0VSTYIAZE+mPmX911JivGXq6+
         K/7Q==
X-Gm-Message-State: AOAM530RVC8H/6mjFIpP+xxae54QsrXZUZTs2bUHJjGOZeAsYoVglTqT
        X6B4b//Q50/SBtY/nhLMhH0/OXpU2LE=
X-Google-Smtp-Source: ABdhPJxZDNQTQwGC8xVzh3mXERhpzYPHCwyaBkzX5ehly0XkZN/ROZKNtNNfuNCuJW8mXAE9i4oldA==
X-Received: by 2002:ac8:5557:: with SMTP id o23mr2629776qtr.252.1604686071733;
        Fri, 06 Nov 2020 10:07:51 -0800 (PST)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id r133sm1018660qke.23.2020.11.06.10.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:07:51 -0800 (PST)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/2] net/packet: make packet_fanout.arr size configurable up to 64K
Date:   Fri,  6 Nov 2020 13:07:40 -0500
Message-Id: <20201106180741.2839668-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
In-Reply-To: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
References: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

One use case of PACKET_FANOUT is lockless reception with one socket
per CPU. 256 is a practical limit on increasingly many machines.

Increase PACKET_FANOUT_MAX to 64K. Expand setsockopt PACKET_FANOUT to
take an extra argument max_num_members. Also explicitly define a
fanout_args struct, instead of implicitly casting to an integer. This
documents the API and simplifies the control flow.

If max_num_members is not specified or is set to 0, then 256 is used,
same as before.

Signed-off-by: Tanner Love <tannerlove@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/if_packet.h | 12 +++++++++++
 net/packet/af_packet.c         | 37 +++++++++++++++++++++++-----------
 net/packet/internal.h          |  5 +++--
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 3d884d68eb30..c07caf7b40db 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_IF_PACKET_H
 #define __LINUX_IF_PACKET_H
 
+#include <asm/byteorder.h>
 #include <linux/types.h>
 
 struct sockaddr_pkt {
@@ -296,6 +297,17 @@ struct packet_mreq {
 	unsigned char	mr_address[8];
 };
 
+struct fanout_args {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u16		id;
+	__u16		type_flags;
+#else
+	__u16		type_flags;
+	__u16		id;
+#endif
+	__u32		max_num_members;
+};
+
 #define PACKET_MR_MULTICAST	0
 #define PACKET_MR_PROMISC	1
 #define PACKET_MR_ALLMULTI	2
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cefbd50c1090..62ebfaa7adcb 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1636,13 +1636,15 @@ static bool fanout_find_new_id(struct sock *sk, u16 *new_id)
 	return false;
 }
 
-static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
+static int fanout_add(struct sock *sk, struct fanout_args *args)
 {
 	struct packet_rollover *rollover = NULL;
 	struct packet_sock *po = pkt_sk(sk);
+	u16 type_flags = args->type_flags;
 	struct packet_fanout *f, *match;
 	u8 type = type_flags & 0xff;
 	u8 flags = type_flags >> 8;
+	u16 id = args->id;
 	int err;
 
 	switch (type) {
@@ -1700,11 +1702,21 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		}
 	}
 	err = -EINVAL;
-	if (match && match->flags != flags)
-		goto out;
-	if (!match) {
+	if (match) {
+		if (match->flags != flags)
+			goto out;
+		if (args->max_num_members &&
+		    args->max_num_members != match->max_num_members)
+			goto out;
+	} else {
+		if (args->max_num_members > PACKET_FANOUT_MAX)
+			goto out;
+		if (!args->max_num_members)
+			/* legacy PACKET_FANOUT_MAX */
+			args->max_num_members = 256;
 		err = -ENOMEM;
-		match = kzalloc(sizeof(*match), GFP_KERNEL);
+		match = kvzalloc(struct_size(match, arr, args->max_num_members),
+				 GFP_KERNEL);
 		if (!match)
 			goto out;
 		write_pnet(&match->net, sock_net(sk));
@@ -1720,6 +1732,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
 		match->prot_hook.id_match = match_fanout_group;
+		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
 	}
 	err = -EINVAL;
@@ -1730,7 +1743,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 	    match->prot_hook.type == po->prot_hook.type &&
 	    match->prot_hook.dev == po->prot_hook.dev) {
 		err = -ENOSPC;
-		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
+		if (refcount_read(&match->sk_ref) < match->max_num_members) {
 			__dev_remove_pack(&po->prot_hook);
 			po->fanout = match;
 			po->rollover = rollover;
@@ -1744,7 +1757,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 
 	if (err && !refcount_read(&match->sk_ref)) {
 		list_del(&match->list);
-		kfree(match);
+		kvfree(match);
 	}
 
 out:
@@ -3075,7 +3088,7 @@ static int packet_release(struct socket *sock)
 	kfree(po->rollover);
 	if (f) {
 		fanout_release_data(f);
-		kfree(f);
+		kvfree(f);
 	}
 	/*
 	 *	Now the socket is dead. No more input will appear.
@@ -3866,14 +3879,14 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	}
 	case PACKET_FANOUT:
 	{
-		int val;
+		struct fanout_args args = { 0 };
 
-		if (optlen != sizeof(val))
+		if (optlen != sizeof(int) && optlen != sizeof(args))
 			return -EINVAL;
-		if (copy_from_sockptr(&val, optval, sizeof(val)))
+		if (copy_from_sockptr(&args, optval, optlen))
 			return -EFAULT;
 
-		return fanout_add(sk, val & 0xffff, val >> 16);
+		return fanout_add(sk, &args);
 	}
 	case PACKET_FANOUT_DATA:
 	{
diff --git a/net/packet/internal.h b/net/packet/internal.h
index fd41ecb7f605..baafc3f3fa25 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -77,11 +77,12 @@ struct packet_ring_buffer {
 };
 
 extern struct mutex fanout_mutex;
-#define PACKET_FANOUT_MAX	256
+#define PACKET_FANOUT_MAX	(1 << 16)
 
 struct packet_fanout {
 	possible_net_t		net;
 	unsigned int		num_members;
+	u32			max_num_members;
 	u16			id;
 	u8			type;
 	u8			flags;
@@ -90,10 +91,10 @@ struct packet_fanout {
 		struct bpf_prog __rcu	*bpf_prog;
 	};
 	struct list_head	list;
-	struct sock		*arr[PACKET_FANOUT_MAX];
 	spinlock_t		lock;
 	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
+	struct sock		*arr[];
 };
 
 struct packet_rollover {
-- 
2.29.1.341.ge80a0c044ae-goog

