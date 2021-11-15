Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00494514B9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbhKOUM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345821AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E61DC0BC9B9
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:27 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y7so15380768plp.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouXZBTAruen0qmI6aoDktc7jK1BqHvnZk0CNJ3/THFM=;
        b=ke4UK86FAUj+32OE8ArBE1LfWuwf9mHJqspuMEr3o1uLtJDkJ/Ek7T3WMLneRTiF8g
         d4SXbYJtspyLln2B4bdObZrISQ5rLmZ1F1OY6sj54UEif7sUZsqytCLEQetog798N8s2
         50k+D87b0UoNr6gsPA/Rk0y222NDx8ZDw8ohdZ2PngKrHeEFQRnwEuB8EipBtQi5NnNq
         JYvDcit+VFn5a3+tVJkTAfFQe7oZHp6WhURn7pGUSsD+l3txTbPtBmB+vm5lgja5D7tN
         +Ck72CC5IkgxqgbqBwCaxpS8i2k546oSG3MzUVbYlifqEKy014SD6D2MHmNFy/kRUngV
         aHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouXZBTAruen0qmI6aoDktc7jK1BqHvnZk0CNJ3/THFM=;
        b=Tnv2r3QQYFpBdblCBUHStEruSH2J3/EG7ivejPm9czAqwKsOQCN1APVsZNTSoaQlBU
         4ebbqg1agf/74cq9CFHwUp/1UDXDQqS6gIYI9LFR5pju5avi8d1mGXTaclBzpiAF/F1p
         HoyKY+o/5ejsRm4nNgVBLtZOd2LkaJpdHTqw1V7rW8dmVy7dJ28eQQFf/PvqE5RTWP+Y
         FXvMoiacxl8JPzCKmD8d7xWhmMHkyfrnoWJEhDOJkDdSGwT5Ue40anZHzJKN5FgX8ql7
         +1/nEwm5pSBS6dgcjZ2/x5ZdEi+ByzSyg2v9n3m0B0H3dZrDbSoSKOUewNXAq+YV5cEN
         oyaw==
X-Gm-Message-State: AOAM533N5cD/y8nJsIrWYAufgH5PPuYDRq8LhefoH5bv+hqgHWSXGWfv
        SK9LHRTxl78xTq9nDXVabo0=
X-Google-Smtp-Source: ABdhPJxgZeGsPg2+1q/8AoQ9/uuzYFSpzczh4KkamemXqDK1ey8gfU55pZP0X8lkFWXjRz0Wp348sA==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr989755pjb.57.1637003006747;
        Mon, 15 Nov 2021 11:03:26 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:26 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 20/20] net: move early demux fields close to sk_refcnt
Date:   Mon, 15 Nov 2021 11:02:49 -0800
Message-Id: <20211115190249.3936899-21-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_rx_dst/sk_rx_dst_ifindex/sk_rx_dst_cookie are read in early demux,
and currently spans two cache lines.

Moving them close to sk_refcnt makes more sense, as only one cache
line is needed.

New layout for this hot cache line is :

struct sock {
	struct sock_common         __sk_common;          /*     0  0x88 */
	/* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
	struct dst_entry *         sk_rx_dst;            /*  0x88   0x8 */
	int                        sk_rx_dst_ifindex;    /*  0x90   0x4 */
	u32                        sk_rx_dst_cookie;     /*  0x94   0x4 */
	socket_lock_t              sk_lock;              /*  0x98  0x20 */
	atomic_t                   sk_drops;             /*  0xb8   0x4 */
	int                        sk_rcvlowat;          /*  0xbc   0x4 */
	/* --- cacheline 3 boundary (192 bytes) --- */

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2578d1f455a7af0d7f4ce5d3b4ac25ee41fdaeb4..95cc03bd3fac0f3f5ea49bfd540a1f0eda4ebf59 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -390,6 +390,11 @@ struct sock {
 #define sk_flags		__sk_common.skc_flags
 #define sk_rxhash		__sk_common.skc_rxhash
 
+	/* early demux fields */
+	struct dst_entry	*sk_rx_dst;
+	int			sk_rx_dst_ifindex;
+	u32			sk_rx_dst_cookie;
+
 	socket_lock_t		sk_lock;
 	atomic_t		sk_drops;
 	int			sk_rcvlowat;
@@ -432,9 +437,6 @@ struct sock {
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
-	struct dst_entry	*sk_rx_dst;
-	int			sk_rx_dst_ifindex;
-	u32			sk_rx_dst_cookie;
 
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
-- 
2.34.0.rc1.387.gb447b232ab-goog

