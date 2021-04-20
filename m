Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE9B365C7F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhDTPpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:45:38 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:57654 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhDTPpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1618933505; x=1650469505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vdumPG+hHodAMIi+5gcUXgp5jGw2xWA/8qR5K8tSe0=;
  b=FsRh+WMWANCzAXETfCPNeIqLW/gC0MaLx+KbDgKOP0fuOKmGRC4ni3g2
   oiDHElhvyQGwgPzOvU0Na52/rk1rrQ1Mk+/IaZtYvp5em5CYSPjJUTiTc
   ZQIqNkIOps+MBbvwgXnemv60GwqgeSRtwKQp4i48GaTFLyKw3OdJGeL9X
   k=;
X-IronPort-AV: E=Sophos;i="5.82,237,1613433600"; 
   d="scan'208";a="107202499"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 20 Apr 2021 15:45:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 2D216A1D90;
        Tue, 20 Apr 2021 15:45:02 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:45:01 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:44:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 bpf-next 08/11] bpf: Support BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Wed, 21 Apr 2021 00:41:37 +0900
Message-ID: <20210420154140.80034-9-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420154140.80034-1-kuniyu@amazon.co.jp>
References: <20210420154140.80034-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13P01UWB001.ant.amazon.com (10.43.161.59) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will call sock_reuseport.prog for socket migration in the next commit,
so the eBPF program has to know which listener is closing to select a new
listener.

We can currently get a unique ID of each listener in the userspace by
calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.

This patch makes the pointer of sk available in sk_reuseport_md so that we
can get the ID by BPF_FUNC_get_socket_cookie() in the eBPF program.

Link: https://lore.kernel.org/netdev/20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 10 ++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 49371eba98ba..ab8584701334 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5299,6 +5299,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__bpf_md_ptr(struct bpf_sock *, sk);
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d08a670..3d0f989f5d38 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10135,6 +10135,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
 		return &sk_reuseport_load_bytes_proto;
 	case BPF_FUNC_skb_load_bytes_relative:
 		return &sk_reuseport_load_bytes_relative_proto;
+	case BPF_FUNC_get_socket_cookie:
+		return &bpf_get_socket_ptr_cookie_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -10164,6 +10166,10 @@ sk_reuseport_is_valid_access(int off, int size,
 	case offsetof(struct sk_reuseport_md, hash):
 		return size == size_default;
 
+	case offsetof(struct sk_reuseport_md, sk):
+		info->reg_type = ARG_PTR_TO_SOCKET;
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10236,6 +10242,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_reuseport_md, bind_inany):
 		SK_REUSEPORT_LOAD_FIELD(bind_inany);
 		break;
+
+	case offsetof(struct sk_reuseport_md, sk):
+		SK_REUSEPORT_LOAD_FIELD(sk);
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 69902603012c..5fd94d632792 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5293,6 +5293,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__bpf_md_ptr(struct bpf_sock *, sk);
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.30.2

