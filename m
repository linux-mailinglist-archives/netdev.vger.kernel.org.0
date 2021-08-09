Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A523E4C74
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhHISyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbhHISyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:54:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D35C061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:54:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so1419445pjb.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVzqBxR/DNsVDsAqg23OHVpD/90VIgIQWvil1h3GW3Y=;
        b=fqxYI4khJjHjABi34XG9sQJ4mL2qG1eTs6ijgjbZgIKx5szwNGRZDpJ66iglt5/Jjx
         XbzO+7xRCTCfXMW/6kxnDUlNEFn4SBYCSrC3lDEqliVrcWBiXrFCOV2cPJ8W08ybBk5K
         1MuhD1CUFwrspI6AfeK8BHINXh+M9i7guMro+ks44t+dczFUeGKuLX1EtoOjaa4LieT5
         YCzspa9HwrsYt7NGPDweKbQZ2aG3k+aKUG1Shi5HztJgsIVGL5AqpcF7f+VrnriDjkWr
         cGRVfBUeLi9kQnvhWfdHJRp4nysIuTn9mgAW/1Rnvq0glQeC2pjj4XyzOIDjmvy8hzyY
         iOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVzqBxR/DNsVDsAqg23OHVpD/90VIgIQWvil1h3GW3Y=;
        b=It/AwmeDmoqwVI36OM5wd3WNBuJ4JuhLMPwbz1adRcrctH5N/Uk1DtUYfhvSmSBeVc
         eEUoR2wxZEdQf9FHDo95TVsj6rGFa6CMsOAmf1MWb3IhOmMi3Uzu1LiSl7fX8WPOTqD8
         Ewojx1Pze1BpUfp37zN+YuqGxw7Y9mhjtRTajKqg6W17kcr+77VSBaMK+R5Zc6DqZRvs
         BJyppVPrX2HqBY/XSw6ocmoDqwMPAQR1g/mfcwhGp3+3VtzF6Uf5EQi2NOWJdBg8Yo8Y
         P/YtJHxenyQgd8zNkJpLeUtxf7Dy5Ue96CdI9T5Fgh75a+QUQ59uqTc0RL5WkFD183i1
         dQ4w==
X-Gm-Message-State: AOAM5312e0ITysrs0RS6u6mmcigzdM1Uv6wu09/Z6TeuW5L1oyd10NMG
        AhuRvCpiA/NP8nXDqfU98T/KMxwWPiAcT3dc
X-Google-Smtp-Source: ABdhPJxZBX5rRGcAker3mq8ffPFDxi32ncV+69+Yllk2VeDMMf/vhEO0sB/n9Lx36xrAnDaQx2A8fQ==
X-Received: by 2002:a17:90a:4681:: with SMTP id z1mr12545435pjf.131.1628535249474;
        Mon, 09 Aug 2021 11:54:09 -0700 (PDT)
Received: from localhost.localdomain ([12.33.129.114])
        by smtp.gmail.com with ESMTPSA id b28sm21255364pff.155.2021.08.09.11.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 11:54:09 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        ycheng@google.com, eric.dumazet@gmail.com, a.e.azimov@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 2/3] txhash: Add socket option to control TX hash rethink behavior
Date:   Mon,  9 Aug 2021 11:53:13 -0700
Message-Id: <20210809185314.38187-3-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809185314.38187-1-tom@herbertland.com>
References: <20210809185314.38187-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SO_TXREHASH_MODE socket option to control hash rethink behavior
per socket. The setsockopt argument is a mask of rethink modes
(SOCK_TXREHASH_MODE_NEG_ADVICE, SOCK_TXREHASH_MODE_SYN_RTO,
and SOCK_TXREHASH_MODE_RTO). The argument may also be -1U
(SOCK_TXREHASH_MODE_DEFAULT) which indicates that the default system
value should be used (see txrehash_mode sysctl)
---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  3 ++-
 include/net/sock.h                    |  8 +++++++-
 include/uapi/asm-generic/socket.h     |  2 ++
 net/core/sock.c                       | 16 ++++++++++++++++
 7 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 1dd9baf4a6c2..1165cdab5277 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -131,6 +131,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH_MODE	73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 1eaf6a1ca561..91412f7725bd 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -142,6 +142,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH_MODE	73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 8baaad52d799..80e0eddc6730 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -123,6 +123,8 @@
 
 #define SO_BUF_LOCK		0x4046
 
+#define SO_TXREHASH_MODE	0x4047
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index e80ee8641ac3..2fd5679e4116 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -124,8 +124,9 @@
 
 #define SO_BUF_LOCK              0x0051
 
-#if !defined(__KERNEL__)
+#define SO_TXREHASH_MODE	 0x0052
 
+#if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
 #define SO_TIMESTAMP		SO_TIMESTAMP_OLD
diff --git a/include/net/sock.h b/include/net/sock.h
index 6ef5314e8eed..b6ddb5278b8c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -313,6 +313,7 @@ struct bpf_local_storage;
   *	@sk_rcvtimeo: %SO_RCVTIMEO setting
   *	@sk_sndtimeo: %SO_SNDTIMEO setting
   *	@sk_txhash: computed flow hash for use on transmit
+  *	@sk_txrehash_mode: configuration bits for controlling TX hash rethink
   *	@sk_filter: socket filtering instructions
   *	@sk_timer: sock cleanup timer
   *	@sk_stamp: time stamp of last packet received
@@ -462,6 +463,7 @@ struct sock {
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
 	__u32			sk_txhash;
+	unsigned int		sk_txrehash_mode;
 
 	/*
 	 * Because of non atomicity rules, all
@@ -1953,7 +1955,11 @@ static inline bool sk_rethink_txhash(struct sock *sk, unsigned int level)
 	if (!sk->sk_txhash)
 		return false;
 
-	rehash_mode = READ_ONCE(sock_net(sk)->core.sysctl_txrehash_mode);
+	if (sk->sk_txrehash_mode == SOCK_TXREHASH_MODE_DEFAULT)
+		rehash_mode =
+			READ_ONCE(sock_net(sk)->core.sysctl_txrehash_mode);
+	else
+		rehash_mode = sk->sk_txrehash_mode;
 
 	if (level & rehash_mode) {
 		sk_set_txhash(sk);
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 1f0a2b4864e4..daa775cc4108 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -126,6 +126,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH_MODE	73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index aada649e07e8..946d9e9242c8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1367,6 +1367,17 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 					  ~SOCK_BUF_LOCK_MASK);
 		break;
 
+	case SO_TXREHASH_MODE:
+		if (val == SOCK_TXREHASH_MODE_DEFAULT ||
+		    (val & ~SOCK_TXREHASH_MODE_MASK)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		sk->sk_txrehash_mode =  val;
+
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1733,6 +1744,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
 		break;
 
+	case SO_TXREHASH_MODE:
+		v.val = sk->sk_txrehash_mode;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
@@ -3158,6 +3173,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
+	sk->sk_txrehash_mode = SOCK_TXREHASH_MODE_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
-- 
2.25.1

