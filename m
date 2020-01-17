Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE2140FDD
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAQR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:28:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgAQR2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579282113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBDtcl9yyAwsU0YycnOUqw4cE1Uy83rNYI+1gtuFE0Y=;
        b=VzjQ4mG8lBcKGBn+FMIxMTWMeJPLVV5wO4KHAQ1Ka/HUatcYcYoN2B8QKFfN8IyqzhPmjp
        /K9zpUije2/ZQU+shigNARFpDASkpQpFgXbf/qWwCsiqgW72O5bgPj3ePVhBvIjjJxh4DH
        ZdbP378ckiXuYshKK3z+oDgxCEO0gXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-SOnLulG5ORGnxv1Un_EZ4g-1; Fri, 17 Jan 2020 12:28:30 -0500
X-MC-Unique: SOnLulG5ORGnxv1Un_EZ4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81A20100551A;
        Fri, 17 Jan 2020 17:28:29 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 905BA5D9CD;
        Fri, 17 Jan 2020 17:28:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net 3/3] udp: avoid bulk memory scheduling on memory pressure.
Date:   Fri, 17 Jan 2020 18:27:56 +0100
Message-Id: <749f8a12b2caf634249e7590597f0c53e5b37c7a.1579281705.git.pabeni@redhat.com>
In-Reply-To: <cover.1579281705.git.pabeni@redhat.com>
References: <cover.1579281705.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
free even if the rx sk queue is empty") the memory allocated by
an almost idle system with many UDP sockets can grow a lot.

This change addresses the issue enabling memory pressure tracking
for UDP and flushing the fwd allocated memory on dequeue if the
UDP protocol is under memory pressure.

Note that with this patch applied, the system allocates more
liberally memory for UDP sockets while the total memory usage is
below udp_mem[1], while the vanilla kernel would allow at most a
single page per socket when UDP memory usage goes above udp_mem[0]
- see __sk_mem_raise_allocated().

Reported-and-diagnosed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.=
com>
Fixes: commit 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk que=
ue is empty")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/udp.h |  2 ++
 net/ipv4/udp.c    | 13 ++++++++++++-
 net/ipv6/udp.c    |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index bad74f780831..cff730798291 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -94,6 +94,8 @@ static inline struct udp_hslot *udp_hashslot2(struct ud=
p_table *table,
 extern struct proto udp_prot;
=20
 extern atomic_long_t udp_memory_allocated;
+extern unsigned long udp_memory_pressure;
+extern struct percpu_counter udp_sockets_allocated;
=20
 /* sysctl variables for udp */
 extern long sysctl_udp_mem[3];
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 93a355b6b092..3a68ec6c3410 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -119,6 +119,12 @@ EXPORT_SYMBOL(udp_table);
 long sysctl_udp_mem[3] __read_mostly;
 EXPORT_SYMBOL(sysctl_udp_mem);
=20
+unsigned long udp_memory_pressure __read_mostly;
+EXPORT_SYMBOL(udp_memory_pressure);
+
+struct percpu_counter udp_sockets_allocated;
+EXPORT_SYMBOL(udp_sockets_allocated);
+
 atomic_long_t udp_memory_allocated;
 EXPORT_SYMBOL(udp_memory_allocated);
=20
@@ -1368,7 +1374,8 @@ static void udp_rmem_release(struct sock *sk, int s=
ize, int partial,
 	if (likely(partial)) {
 		up->forward_deficit +=3D size;
 		size =3D up->forward_deficit;
-		if (size < (sk->sk_rcvbuf >> 2))
+		if (size < (sk->sk_rcvbuf >> 2) &&
+		    !READ_ONCE(udp_memory_pressure))
 			return;
 	} else {
 		size +=3D up->forward_deficit;
@@ -2789,7 +2796,9 @@ struct proto udp_prot =3D {
 	.unhash			=3D udp_lib_unhash,
 	.rehash			=3D udp_v4_rehash,
 	.get_port		=3D udp_v4_get_port,
+	.memory_pressure	=3D &udp_memory_pressure,
 	.memory_allocated	=3D &udp_memory_allocated,
+	.sockets_allocated	=3D &udp_sockets_allocated,
 	.sysctl_mem		=3D sysctl_udp_mem,
 	.sysctl_wmem_offset	=3D offsetof(struct net, ipv4.sysctl_udp_wmem_min),
 	.sysctl_rmem_offset	=3D offsetof(struct net, ipv4.sysctl_udp_rmem_min),
@@ -3062,6 +3071,8 @@ void __init udp_init(void)
 	sysctl_udp_mem[1] =3D limit;
 	sysctl_udp_mem[2] =3D sysctl_udp_mem[0] * 2;
=20
+	percpu_counter_init(&udp_sockets_allocated, 0, GFP_KERNEL);
+
 	__udp_sysctl_init(&init_net);
=20
 	/* 16 spinlocks per cpu */
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9fec580c968e..b29d92574ccc 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1670,7 +1670,9 @@ struct proto udpv6_prot =3D {
 	.unhash			=3D udp_lib_unhash,
 	.rehash			=3D udp_v6_rehash,
 	.get_port		=3D udp_v6_get_port,
+	.memory_pressure	=3D &udp_memory_pressure,
 	.memory_allocated	=3D &udp_memory_allocated,
+	.sockets_allocated	=3D &udp_sockets_allocated,
 	.sysctl_mem		=3D sysctl_udp_mem,
 	.sysctl_wmem_offset     =3D offsetof(struct net, ipv4.sysctl_udp_wmem_m=
in),
 	.sysctl_rmem_offset     =3D offsetof(struct net, ipv4.sysctl_udp_rmem_m=
in),
--=20
2.21.0

