Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9931FC55
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBSPpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhBSPpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:45:04 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F11C06178A
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:44:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v15so9169200wrx.4
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sMU/474niJQj74EWPB7ar7d8CwvMR9zjeg5qYrRHBtU=;
        b=e6XmzVmiNDv1jFLy81QXEu3OB7/FsqpPlIV4z+Wkv/4Q0aKnYqCGto8dBzIWWjcB3u
         pQPKV2LHB3rzdgSbp+/hvtV58CFpdp0KnlUgmYd3Dv1NsUJCLjRwv5baTA2qgtKslPrY
         kygSriy+4fHaYXgIh1nklrNxU0XO1uKpBAr2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sMU/474niJQj74EWPB7ar7d8CwvMR9zjeg5qYrRHBtU=;
        b=P7N0ws/lXZnYAQDcaV99U22pstU2/P/CxaFVeSP1r0LcsrR4PAe2ywXaoCP8/uGO46
         cUjhIXQsecGril+LUrehKPFpHOpVrF/halAaWdWlv2Et/+narmYnwn14lRbtglkslS/3
         ceCpxcBVsnP7O4gZmIZU3cxPx/qV+OqWStbL8pymWs/XLixK7KQsyku7le/IyyjsKjNm
         7C5cXRo+rXWm6zg+pWoLakU9zCTHWaIn/INCtXhfepV/JvJ8WHo0QHy9OA9fTuslxNqC
         v1YpFNwwlz+6zpNVlZ7RkmH1RljJsmVDl3o2PaBvTvYwZ/bdL1jpER2c43LLFvNljkVQ
         Jx/Q==
X-Gm-Message-State: AOAM531EqADXPWc8xaaYj5woyiZwTNAyd7QhWg9KJ3f6iGUcuMGbZ/jg
        GOI+XgpQ5cpNXL9noC0EGEIozQ==
X-Google-Smtp-Source: ABdhPJzOoql5zQuFXrrpUF0H+bnB+d+zp+KV1dw+6ihptbQ8krZXZq3Csd9OrZQHtx1Y13J6PI+Q9w==
X-Received: by 2002:a5d:43cd:: with SMTP id v13mr6227146wrr.427.1613749450862;
        Fri, 19 Feb 2021 07:44:10 -0800 (PST)
Received: from antares.lan (b.3.5.8.9.a.e.c.e.a.6.2.c.1.9.b.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:b91c:26ae:cea9:853b])
        by smtp.gmail.com with ESMTPSA id v204sm12321929wmg.38.2021.02.19.07.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 07:44:10 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     eric.dumazet@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 1/4] net: add SO_NETNS_COOKIE socket option
Date:   Fri, 19 Feb 2021 15:43:27 +0000
Message-Id: <20210219154330.93615-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210219154330.93615-1-lmb@cloudflare.com>
References: <20210219154330.93615-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to distinguish which network namespace a socket belongs to.
BPF has the useful bpf_get_netns_cookie helper for this, but accessing
it from user space isn't possible. Add a read-only socket option that
returns the netns cookie, similar to SO_COOKIE. If network namespaces
are disabled, SO_NETNS_COOKIE returns the cookie of init_net.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 7 +++++++
 6 files changed, 17 insertions(+)

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
index 848a22fbac20..ff79db753dce 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -120,6 +120,8 @@
 #define SO_PREFER_BUSY_POLL	 0x0048
 #define SO_BUSY_POLL_BUDGET	 0x0049
 
+#define SO_NETNS_COOKIE		 0x004a
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
index 0ed98f20448a..84db011a192f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1614,6 +1614,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len != lv)
+			return -EINVAL;
+		v.val64 = sock_net(sk)->net_cookie;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.27.0

