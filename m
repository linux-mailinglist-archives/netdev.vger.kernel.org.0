Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8297E183D6A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCLXg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:36:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39277 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCLXg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id w65so4046384pfb.6;
        Thu, 12 Mar 2020 16:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lw6QEzzBw1Lxh2UgelEeAfoq5kTaJOU7nxuWI23gcZU=;
        b=Gim6Q3WPTPVvvNjQ0sV6c9bIcpY3YCUknK23F523ey6ZRlcyWh6IOI+Zlr7Tsgxzv1
         YQvgK7eqoglePB+4wI9LxCj0p6ONu1lXyuhYkSNgY01zG3DdsFWa2LhXky2+X/4I8hvi
         IJ4ZGCa20T9wPp+KmLZqU5VwxQmrUS70yN/BRxx5b9CksenFfdXc3oSIZd3wtsMs4CgR
         i6jY7edUh52etSUVxaO2aC9LqMDbF7Hgs7r+RZ5lrvpxvJPDngBM0pSX//Pk+doEBE4r
         BdFT8WmP6uxk+5Eb4ChmCfB5jl+wL5nlv2aBgsW4ng72ls2bmkCogXOEfW47+TSVibbT
         qfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lw6QEzzBw1Lxh2UgelEeAfoq5kTaJOU7nxuWI23gcZU=;
        b=aysXn7nDP6xxUx+egBoCEelpUuVMnl1LcNB/FHSc78lboEsfUIUkvMkiMo0TUX10cY
         anyIbw+fBAmZBvGgZFbfIFamaY0KQKnpbgVRTQMMgs/AMtxHk2rYCO9mF8Co3/reLc/b
         WANd8EFFTH8VaZb7zdeWth6Q+9zy81TRGcxssifrBkkOFDq8Xog6W9Tbiw1l97MonRGw
         kHUsrx/zd6tm5geBFAXDCm3jF/pu0wQKne9mlHADdMC6EioSAztE5KK+cKYw/VIRLmkz
         psaWcpLGIDAv14zPZJQN1cpngA6r4EUlSAewvWs++YG+syuLHudtjm2HSgfPIPwiDB4w
         Yr2A==
X-Gm-Message-State: ANhLgQ0Wp6VLiIU6hoi7rnltl5zTDIFeh7DRMowYP7Qu+p/RHWMmhOJB
        rk/usb3Swf+Aj525s9t/LwnO/073
X-Google-Smtp-Source: ADFU+vvns2HupLinY0b8i2y3/LsxGFp7z67Afr1v4F8hURxZeu0k0F2ZEa1rWLAU7xDv3aZjTB68Eg==
X-Received: by 2002:aa7:991c:: with SMTP id z28mr8508136pff.294.1584056215980;
        Thu, 12 Mar 2020 16:36:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:55 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 4/7] dst: Prefetch established socket destinations
Date:   Thu, 12 Mar 2020 16:36:45 -0700
Message-Id: <20200312233648.1767-5-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enhance the dst_sk_prefetch logic to temporarily store the socket
receive destination, to save the route lookup later on. The dst
reference is kept alive by the caller's socket reference.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 include/net/dst_metadata.h |  2 +-
 net/core/dst.c             | 20 +++++++++++++++++---
 net/core/filter.c          |  2 +-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 31574c553a07..4f16322b08d5 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -230,7 +230,7 @@ static inline bool skb_dst_is_sk_prefetch(const struct sk_buff *skb)
 	return dst_is_sk_prefetch(skb_dst(skb));
 }
 
-void dst_sk_prefetch_store(struct sk_buff *skb);
+void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk);
 void dst_sk_prefetch_fetch(struct sk_buff *skb);
 
 /**
diff --git a/net/core/dst.c b/net/core/dst.c
index cf1a1d5b6b0a..5068d127d9c2 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -346,11 +346,25 @@ EXPORT_SYMBOL(dst_sk_prefetch);
 
 DEFINE_PER_CPU(unsigned long, dst_sk_prefetch_dst);
 
-void dst_sk_prefetch_store(struct sk_buff *skb)
+void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk)
 {
-	unsigned long refdst;
+	unsigned long refdst = 0L;
+
+	WARN_ON(!rcu_read_lock_held() &&
+		!rcu_read_lock_bh_held());
+	if (sk_fullsock(sk)) {
+		struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+
+		if (dst)
+			dst = dst_check(dst, 0);
+		if (dst)
+			refdst = (unsigned long)dst | SKB_DST_NOREF;
+	}
+	if (!refdst)
+		refdst = skb->_skb_refdst;
+	if (skb->_skb_refdst != refdst)
+		skb_dst_drop(skb);
 
-	refdst = skb->_skb_refdst;
 	__this_cpu_write(dst_sk_prefetch_dst, refdst);
 	skb_dst_set_noref(skb, (struct dst_entry *)&dst_sk_prefetch.dst);
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index bae0874289d8..db9b7b8b4a04 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5858,7 +5858,7 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 	skb_orphan(skb);
 	skb->sk = sk;
 	skb->destructor = sock_edemux;
-	dst_sk_prefetch_store(skb);
+	dst_sk_prefetch_store(skb, sk);
 
 	return 0;
 }
-- 
2.20.1

