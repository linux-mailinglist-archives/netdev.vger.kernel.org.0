Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228CB451D92
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345701AbhKPAbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345794AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6514CC0BC9B0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso86551pji.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bmlR2S3oZD9NxWeZ2mafGLPdjBu6b2blaSlpRGXl3og=;
        b=MMhjxDt6skHg/0ST3ZizhL2lCzgcleL6d19aq1EvdkZUWL1kAW3rnE59lzceizSOGu
         zOoD5xJ0mtklR2cG6VpRAFRAHlWLH1nf+tL/VTticNTJGEABWW/eBw0TvS7Uek4eiqvh
         42Fjdee3R4+vFppLasy0h5+mYIB06fJFNnPMb5eqfQALJoqEM47Z61iuTEfDLgA3qrd5
         RdddGQLDZMLU4rHw1SfbXa1Hi64Wxgr84vvvgObOzGHW+1Fb1EDTtBQgVRZxB6DweSkX
         UYvgJaZeq6Lxtmv2vK5LGgMYgM4yj6qpxVGG0GfkWmcUK78kUpBKKQ4dMIKqnBXpbmkA
         ATDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bmlR2S3oZD9NxWeZ2mafGLPdjBu6b2blaSlpRGXl3og=;
        b=GnrqM7kwVHIDTzXb836kJDas5aBnx/c1DswetiA1R2S90l6nshXFg1/5S77u78Sw/5
         VlChJ8hbE5mct0ObKbRYRBYBm6ZHbaj/TAIVaxB2i61KGGOuANRH6ui7A7pw4O7Gu/Uw
         aTYX7fMjjiA7/fcwzTlKUvxr1bYrY/9hhJhDDTphPld1DMwTu9eJB/EggeB9vnOOh1Y+
         cr/O2MHoWSGTloMkhoDYIHePQhrsSPuusx5IKMnOGRzRZEQt2eneWr5HHwji3bT6mQ6r
         uVy+PPPiuMkYRsMdxX6FVC5pWf9VvVPf5bVF2Gmgwe1rLgwTrrfFEYdEld/GeuRmIJNn
         IQPQ==
X-Gm-Message-State: AOAM532sqCDv2bmQW30kbgvvfC+Yxi/s+hBtKBiWbOSZoocxp0Tk6cx2
        /VKHPsxKBgw9AjFjaHX+4aQZyIpzXS8=
X-Google-Smtp-Source: ABdhPJy3dcg+sq4BDht6hU4FO4zvdBw/46sjkWUIBFxRTdLNj0MCM/bjOtkleW2I1cMwjrievvINfA==
X-Received: by 2002:a17:903:245:b0:143:c5ba:8bd8 with SMTP id j5-20020a170903024500b00143c5ba8bd8mr13289957plh.64.1637002993819;
        Mon, 15 Nov 2021 11:03:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 10/20] net: cache align tcp_memory_allocated, tcp_sockets_allocated
Date:   Mon, 15 Nov 2021 11:02:39 -0800
Message-Id: <20211115190249.3936899-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_memory_allocated and tcp_sockets_allocated often share
a common cache line, source of false sharing.

Also take care of udp_memory_allocated and mptcp_sockets_allocated.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c       | 4 ++--
 net/ipv4/udp.c       | 2 +-
 net/mptcp/protocol.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4fa4b29260bd4c08da70b3fb199e3459013114f3..862e8cb8dda51e76300a427783a7d8c32e82cc7f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -292,7 +292,7 @@ EXPORT_PER_CPU_SYMBOL_GPL(tcp_orphan_count);
 long sysctl_tcp_mem[3] __read_mostly;
 EXPORT_SYMBOL(sysctl_tcp_mem);
 
-atomic_long_t tcp_memory_allocated;	/* Current allocated memory. */
+atomic_long_t tcp_memory_allocated ____cacheline_aligned_in_smp;	/* Current allocated memory. */
 EXPORT_SYMBOL(tcp_memory_allocated);
 
 #if IS_ENABLED(CONFIG_SMC)
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(tcp_have_smc);
 /*
  * Current number of TCP sockets.
  */
-struct percpu_counter tcp_sockets_allocated;
+struct percpu_counter tcp_sockets_allocated ____cacheline_aligned_in_smp;
 EXPORT_SYMBOL(tcp_sockets_allocated);
 
 /*
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 319dd7bbfe33d64d25c36bc3a1cd3bd4caf0a779..d3cea98a5d5dbf4deea5b06bd95c38eebccd6a55 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL(udp_table);
 long sysctl_udp_mem[3] __read_mostly;
 EXPORT_SYMBOL(sysctl_udp_mem);
 
-atomic_long_t udp_memory_allocated;
+atomic_long_t udp_memory_allocated ____cacheline_aligned_in_smp;
 EXPORT_SYMBOL(udp_memory_allocated);
 
 #define MAX_UDP_PORTS 65536
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b7e32e316738b88d4b9f907f584b12785e396dae..6db93da59843a830c00e8707b7a35f90dfe8047d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -48,7 +48,7 @@ enum {
 	MPTCP_CMSG_TS = BIT(0),
 };
 
-static struct percpu_counter mptcp_sockets_allocated;
+static struct percpu_counter mptcp_sockets_allocated ____cacheline_aligned_in_smp;
 
 static void __mptcp_destroy_sock(struct sock *sk);
 static void __mptcp_check_send_data_fin(struct sock *sk);
-- 
2.34.0.rc1.387.gb447b232ab-goog

