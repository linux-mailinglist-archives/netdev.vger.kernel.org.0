Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EFD3189AA
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhBKLju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:39:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19345 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhBKLhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:37:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602516ab0002>; Thu, 11 Feb 2021 03:36:11 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 11:36:11 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 11:36:08 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/3] net/sock: Add kernel config SOCK_RX_QUEUE_MAPPING
Date:   Thu, 11 Feb 2021 13:35:51 +0200
Message-ID: <20210211113553.8211-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210211113553.8211-1-tariqt@nvidia.com>
References: <20210211113553.8211-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613043371; bh=wNkSxJ6qtjKj+T+YVA4Wae9vaJko1V7d8jqLFvarVkA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=ecP3glvF+wnj+Bwcqx56agC+kZJRKsBFPkceh11D2S6avxm5XDhaS1pCqoOr9ByXd
         +H2b03e/QOsvDEe3V2v/rR12sL9dZwRVA8ArPKB6zWtUZV/Iv9ulNsQpK0nJrZJ0Wi
         iWowxvc7LOGbFiHC5s0WTu24HgFAz0RPuE7a8mi75WtW8k8taUsbgZBZM5w8GiC9uP
         T5gXbVQyOHJ9M1tYRTy1+IdxJH1Z8MKzZRlJEZaSgWzhEH2Uqyibn43qGtRdM0L/VZ
         l36liP16IHbWbxeIemMwJWY7oOa34vmdeP8IQo84g7sUefyBAojITChoakbKxWi64T
         bGPUZ+kjVfopA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a new config SOCK_RX_QUEUE_MAPPING to compile-in the socket
RX queue field and logic, instead of the XPS config.
This breaks dependency in XPS, and allows selecting it from non-XPS
use cases, as we do in the next patch.

In addition, use the new flag to wrap the logic in sk_rx_queue_get()
and protect access to the sk_rx_queue_mapping field, while keeping
the function exposed unconditionally, just like sk_rx_queue_set()
and sk_rx_queue_clear().

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/net/sock.h | 12 ++++++------
 net/Kconfig        |  4 ++++
 net/core/filter.c  |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 690e496a0e79..855c068c6c86 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -226,7 +226,7 @@ struct sock_common {
 		struct hlist_nulls_node skc_nulls_node;
 	};
 	unsigned short		skc_tx_queue_mapping;
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	unsigned short		skc_rx_queue_mapping;
 #endif
 	union {
@@ -356,7 +356,7 @@ struct sock {
 #define sk_nulls_node		__sk_common.skc_nulls_node
 #define sk_refcnt		__sk_common.skc_refcnt
 #define sk_tx_queue_mapping	__sk_common.skc_tx_queue_mapping
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 #define sk_rx_queue_mapping	__sk_common.skc_rx_queue_mapping
 #endif
=20
@@ -1838,7 +1838,7 @@ static inline int sk_tx_queue_get(const struct sock *=
sk)
=20
 static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *=
skb)
 {
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	if (skb_rx_queue_recorded(skb)) {
 		u16 rx_queue =3D skb_get_rx_queue(skb);
=20
@@ -1852,20 +1852,20 @@ static inline void sk_rx_queue_set(struct sock *sk,=
 const struct sk_buff *skb)
=20
 static inline void sk_rx_queue_clear(struct sock *sk)
 {
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	sk->sk_rx_queue_mapping =3D NO_QUEUE_MAPPING;
 #endif
 }
=20
-#ifdef CONFIG_XPS
 static inline int sk_rx_queue_get(const struct sock *sk)
 {
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	if (sk && sk->sk_rx_queue_mapping !=3D NO_QUEUE_MAPPING)
 		return sk->sk_rx_queue_mapping;
+#endif
=20
 	return -1;
 }
-#endif
=20
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
diff --git a/net/Kconfig b/net/Kconfig
index f4c32d982af6..8cea808ad9e8 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -256,9 +256,13 @@ config RFS_ACCEL
 	select CPU_RMAP
 	default y
=20
+config SOCK_RX_QUEUE_MAPPING
+	bool
+
 config XPS
 	bool
 	depends on SMP
+	select SOCK_RX_QUEUE_MAPPING
 	default y
=20
 config HWBM
diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d660..2ba03f6597bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8816,7 +8816,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type =
type,
 				       target_size));
 		break;
 	case offsetof(struct bpf_sock, rx_queue_mapping):
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 		*insn++ =3D BPF_LDX_MEM(
 			BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
 			si->dst_reg, si->src_reg,
--=20
2.21.0

