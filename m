Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24152B5C03
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgKQJmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:42:35 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8913 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgKQJme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606153; x=1637142153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OeOCcafXw5F3JQeGaXDQErSXG44umN5sS/1hxlRsSz0=;
  b=ba9b2fiJnRGjs6Ztt3Dy1Os25P5ZXd59BPcvJf8K8Qxaf71fVQupab3Z
   oc1NH10EQFvkyx41vRDyErkNRr7TAdyv+Sj7HXRbyS+q1P/aNkRVZfVBZ
   wSSWYWbd7PdoPw/2UwTT7ic8p4bBCyeqJY+kb/gJ0O1RAO8Nx3/SxyKtg
   8=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="65440695"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Nov 2020 09:42:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id D3F46281F8D;
        Tue, 17 Nov 2020 09:42:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:29 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH bpf-next 6/8] bpf: Add cookie in sk_reuseport_md.
Date:   Tue, 17 Nov 2020 18:40:21 +0900
Message-ID: <20201117094023.3685-7-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will call sock_reuseport.prog for socket migration in the next commit,
so the eBPF program has to know which listener is closing in order to
select the new listener.

Currently, we can get a unique ID for each listener in the userspace by
calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.
This patch exposes the ID to the eBPF program.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 8 ++++++++
 tools/include/uapi/linux/bpf.h | 1 +
 4 files changed, 11 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 581b2a2e78eb..c0646eceffa2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1897,6 +1897,7 @@ struct sk_reuseport_kern {
 	u32 hash;
 	u32 reuseport_id;
 	bool bind_inany;
+	u64 cookie;
 };
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 162999b12790..3fcddb032838 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4403,6 +4403,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u64 cookie;		/* ID of the listener in map */
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..01e28f283962 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9862,6 +9862,7 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 	reuse_kern->hash = hash;
 	reuse_kern->reuseport_id = reuse->reuseport_id;
 	reuse_kern->bind_inany = reuse->bind_inany;
+	reuse_kern->cookie = sock_gen_cookie(sk);
 }
 
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
@@ -10010,6 +10011,9 @@ sk_reuseport_is_valid_access(int off, int size,
 	case offsetof(struct sk_reuseport_md, hash):
 		return size == size_default;
 
+	case bpf_ctx_range(struct sk_reuseport_md, cookie):
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10082,6 +10086,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_reuseport_md, bind_inany):
 		SK_REUSEPORT_LOAD_FIELD(bind_inany);
 		break;
+
+	case offsetof(struct sk_reuseport_md, cookie):
+		SK_REUSEPORT_LOAD_FIELD(cookie);
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 162999b12790..3fcddb032838 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4403,6 +4403,7 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	__u64 cookie;		/* ID of the listener in map */
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.17.2 (Apple Git-113)

