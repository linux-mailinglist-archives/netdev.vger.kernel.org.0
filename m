Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C863B0EAC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFVU0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:26:46 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42501 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhFVU0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:26:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 59A4B882;
        Tue, 22 Jun 2021 16:24:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 22 Jun 2021 16:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oVCYQkxRhNd+aFw0c
        NF63sYj+NDNylOO4Do8L8S4nl4=; b=bZgMlN05tPVPlGfq/CdPYJ6zxMl7R2zkJ
        KZSNr0lq8eUoje9PZIK6qfLp3HrtGiKpYhI6UjsyGIsXhkeAhd78Ztd58+RBwVJd
        TxGOMDVQZFtJOUCieTvjScjw3PDE+YIUhii0pmgtiSxXmJcCxHI9z5NTUZYXs1lp
        FV6fxgFr8Rp/rkmWBD+fUdoCtbJru49LAd9506+l8kgQ+7TabwdQKPVCP7lGEs0M
        gWAmRKtm2Es7hNwmVI6WABtGZIXUhNaBuytt2ceN/5PwJfdOtqOjcDeMEuw+0O7P
        plo6KaCPvZSSJZENBKmA7zgPPidqX7a8TcMVO58ibAB/5Uu1C0F6g==
X-ME-Sender: <xms:-0bSYMSEOW7dRy_qxdt6R94BEihVlFXb3MLTUM0GZaveypp3wqXVXA>
    <xme:-0bSYJy7a0CdGaOKUxyleq6pYGnX_7ZHhcqbbwsREAdpQzYlyyOvr7Q5jcuMUz4Iz
    Ga-uznZeONOAWoCIbo>
X-ME-Received: <xmr:-0bSYJ1hnWuF9csRlypW_tE-qj-fORjwWgvoRL7WLj3t6n6hY9xIMa22G5ocNY7oLWra9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeguddgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeforghrthihnhgrshcurfhumhhpuhhtihhsuceomheslhgrmhgs
    uggrrdhltheqnecuggftrfgrthhtvghrnhepvddvgeeuvdehjeeguedtueffheeffffhtd
    egueejkeduudeigfegkeegjeffgfehnecuffhomhgrihhnpehkkehsrdhiohenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmsehlrghmsggurg
    drlhht
X-ME-Proxy: <xmx:-0bSYAAKVZ81CtEqYHcKFWAwKPGuBHcyIY-MosH9LdmB9aFG50qM0w>
    <xmx:-0bSYFgGdbJMuhCDG8uOdTVnSEmfBiK74qFjHKf_cJ811JIv_f0LBw>
    <xmx:-0bSYMpfjcm8BO6HoJ1ITtlEjzF7CCXLhejR4SvL3LsUuMpq91Z_IQ>
    <xmx:-0bSYKs0kv2p52OgL1KspwP8rf3DMZOobALuj5x12kaUZZpF5Nvk8g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 16:24:25 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        Martynas Pumputis <m@lambda.lt>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH net-next 1/2] net: retrieve netns cookie via getsocketopt
Date:   Tue, 22 Jun 2021 22:26:22 +0200
Message-Id: <20210622202623.1311901-1-m@lambda.lt>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's getting more common to run nested container environments for
testing cloud software. One of such examples is Kind [1] which runs a
Kubernetes cluster in Docker containers on a single host. Each container
acts as a Kubernetes node, and thus can run any Pod (aka container)
inside the former. This approach simplifies testing a lot, as it
eliminates complicated VM setups.

Unfortunately, such a setup breaks some functionality when cgroupv2 BPF
programs are used for load-balancing. The load-balancer BPF program
needs to detect whether a request originates from the host netns or a
container netns in order to allow some access, e.g. to a service via a
loopback IP address. Typically, the programs detect this by comparing
netns cookies with the one of the init ns via a call to
bpf_get_netns_cookie(NULL). However, in nested environments the latter
cannot be used given the Kubernetes node's netns is outside the init ns.
To fix this, we need to pass the Kubernetes node netns cookie to the
program in a different way: by extending getsockopt() with a
SO_NETNS_COOKIE option, the orchestrator which runs in the Kubernetes
node netns can retrieve the cookie and pass it to the program instead.

Thus, this is following up on Eric's commit 3d368ab87cf6 ("net:
initialize net->net_cookie at netns setup") to allow retrieval via
SO_NETNS_COOKIE.  This is also in line in how we retrieve socket cookie
via SO_COOKIE.

  [1] https://kind.sigs.k8s.io/

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Martynas Pumputis <m@lambda.lt>
Cc: Eric Dumazet <edumazet@google.com>
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 9 +++++++++
 6 files changed, 19 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 57420356ce4c..6b3daba60987 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -127,6 +127,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 2d949969313b..cdf404a831b2 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -138,6 +138,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index f60904329bbc..5b5351cdcb33 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -119,6 +119,8 @@
 #define SO_PREFER_BUSY_POLL	0x4043
 #define SO_BUSY_POLL_BUDGET	0x4044
 
+#define SO_NETNS_COOKIE		0x4045
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 848a22fbac20..92675dc380fa 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -120,6 +120,8 @@
 #define SO_PREFER_BUSY_POLL	 0x0048
 #define SO_BUSY_POLL_BUDGET	 0x0049
 
+#define SO_NETNS_COOKIE          0x0050
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 4dcd13d097a9..d588c244ec2f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -122,6 +122,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index ddfa88082a2b..462fe1fb2056 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1635,6 +1635,15 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+#ifdef CONFIG_NET_NS
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len != lv)
+			return -EINVAL;
+		v.val64 = sock_net(sk)->net_cookie;
+		break;
+#endif
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.32.0

