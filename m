Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7E4FE99A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiDLUoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiDLUoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:44:16 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C287B0A6A
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:38:21 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id e22so60143qvf.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3BVO86C+Bp5oTmscok1L9LDu9RzUD1FUdTUb5CffVs=;
        b=IhQC7HpgwoqGH+D6BJVCKdRcabHBEfjo4k9AIFPHU6WCEmgGIsZOXzR1KJNSzw+rIp
         p91YiO60i2OLegii7cVRow35HismQXnxq2dkARrjNM5qkLLH03qK52zjSgu77u1nDDNh
         XsVC5HYtvuKyRPBXGWWmmkLiXj60bxQJQ2cY3oCETykhHSAAayv5aWE2H4REy1R8zkP9
         yWbFfr7O3oWUoIm7F1yb4ndrL71iQDmTuA676rnR3TaleXh7dlbwfFcM82xT5gi1o3FU
         HwPjy4oOZLOXeczqsoiBUU54hoHF3dKsjek2CAboayMXvFwAUnPWwqNCQOWR1zqPtzlu
         y5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3BVO86C+Bp5oTmscok1L9LDu9RzUD1FUdTUb5CffVs=;
        b=aDs2nWnTBT558UCkNuKC7Rsv6l4VTOadbs+srdNv3AKLKjldSCvnFXXpHiU7mYVeIN
         ccNTHNZR+lKQ6fS6Y4MvjHVej6xArOoeCubjrzV9EgDfhFMbNh3of3zy+bO6VBRtd9bo
         /MWQHGJAjt4cqEnenZ5ZX/9diSO/7FDqkaPjvz72RciJNYWCdbKWwq0DitDFG16cx7OX
         VE+jjsTWKRxGK4efCX7Rek035jF1uBAreb66AaIkyOgTW3BYnhsCMaB3C5//YgBttRVI
         INSQMmDcZ3tCUGGWeFZpAtNpOpQd5qUQ/CQbjuv3tE4DvikmGO5nin22TfgMgllkRSnu
         jmPQ==
X-Gm-Message-State: AOAM533puWy6RIWVmSuikcdM8c2Uq39T+kHI6znN7kVnqYYInZjglPPx
        tW2Id2ImXByVJG7OHLyy7pO3bepSNV1XAX34
X-Google-Smtp-Source: ABdhPJx7U5RACtQ7eexyrDXrCZCXkQNJpXPgwtvjpTvzPqecB/HoWRpqT55YIWX2aXbldvutt/tXmw==
X-Received: by 2002:a05:6a00:3309:b0:505:ffd5:f146 with SMTP id cq9-20020a056a00330900b00505ffd5f146mr4180628pfb.60.1649795176635;
        Tue, 12 Apr 2022 13:26:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm3609084pgf.17.2022.04.12.13.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:26:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] net: add sock 'sk_no_lock' member
Date:   Tue, 12 Apr 2022 14:26:10 -0600
Message-Id: <20220412202613.234896-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202613.234896-1-axboe@kernel.dk>
References: <20220412202613.234896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for allowing lockless access to the socket for specialized
use cases, add a member denoting that the socket supports this.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/sock.h | 3 +++
 net/core/sock.c    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..e8283a65b757 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -131,6 +131,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_reuseport: %SO_REUSEPORT setting
  *	@skc_ipv6only: socket is IPV6 only
  *	@skc_net_refcnt: socket is using net ref counting
+ *	@skc_no_lock: socket is private, no locking needed
  *	@skc_bound_dev_if: bound device index if != 0
  *	@skc_bind_node: bind hash linkage for various protocol lookup tables
  *	@skc_portaddr_node: second hash linkage for UDP/UDP-Lite protocol
@@ -190,6 +191,7 @@ struct sock_common {
 	unsigned char		skc_reuseport:1;
 	unsigned char		skc_ipv6only:1;
 	unsigned char		skc_net_refcnt:1;
+	unsigned char		skc_no_lock:1;
 	int			skc_bound_dev_if;
 	union {
 		struct hlist_node	skc_bind_node;
@@ -382,6 +384,7 @@ struct sock {
 #define sk_reuseport		__sk_common.skc_reuseport
 #define sk_ipv6only		__sk_common.skc_ipv6only
 #define sk_net_refcnt		__sk_common.skc_net_refcnt
+#define sk_no_lock		__sk_common.skc_no_lock
 #define sk_bound_dev_if		__sk_common.skc_bound_dev_if
 #define sk_bind_node		__sk_common.skc_bind_node
 #define sk_prot			__sk_common.skc_prot
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..fec892b384a4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2101,6 +2101,7 @@ EXPORT_SYMBOL(sk_free);
 
 static void sk_init_common(struct sock *sk)
 {
+	sk->sk_no_lock = false;
 	skb_queue_head_init(&sk->sk_receive_queue);
 	skb_queue_head_init(&sk->sk_write_queue);
 	skb_queue_head_init(&sk->sk_error_queue);
-- 
2.35.1

