Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E513AD8AB
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFSInj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhFSIni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:43:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2E6C061767;
        Sat, 19 Jun 2021 01:41:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g4so7095732pjk.0;
        Sat, 19 Jun 2021 01:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=02q4ufpZB3QimNvbx/fOJmDSqWcODZSe1WSuIeiXxO8=;
        b=WZ2lZfU3X6Qj8Vx40Iz0h0axYRsby/apIHxiL3OYPw0iK6zePZfmQu3x6Q9wcGDBAy
         zRtz6J5O+8Z9gez/4oVw0wOfdM1aMLP7iO1UKfSEppvGZsssRj0AhGT2jXQtbf5XIV0L
         y86P3F0hndD+zl4wg5msZpwdAnAfH3iJxciYhbRo70L2L1gOAKS5m7CK/dCxxwG+uuOp
         5VtN7SYP8jHugi2Xon/Y1YLtYwu/IYo6EXSG5G3sKemJJB27/a8vvIoxxxkivXfcDz/f
         0UxVXfwQ7q+lsgtu7DhmIVb30d5l0tBpEbj1+Zb8byKfb9l3rAEY35zz7sgD3Qv0m8D4
         xIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=02q4ufpZB3QimNvbx/fOJmDSqWcODZSe1WSuIeiXxO8=;
        b=RyMLTLBbbknFAgfLl8+tae76kfMIQ1meeIQttyxddY93O2ZYI9Q/S0IyICX850tmwx
         n0JBV5NA08WiHLmXFQ198SSKPM5h05Av8uVvmYVtO8CGm7yOFsDGLf+C5pMtX815jU2D
         V7eWKtkZdiikN8uewCQGlfLGI6BRJm0jlQxBWoa42Xr9YWd7LbIZQMkR9q6xp9UfSJgG
         jyp3LNCu7f+4sFpfPtyPu/8dauv6L6NfzbvT7TVAwCiN5h/INxtNjxtohGYZAoLhT3T7
         LTXOKV518E+51KhPFhJJkdeuZb48AsnTMlnvDpbO4B9Wv9JZ4OeNebzZo+1kHlc/mr7h
         KFFQ==
X-Gm-Message-State: AOAM533Pxjwn0UCz0MYH/YQHsjZ8UZw6XdQdhZWhcNTlCiuio9w1PBYV
        G4X4WmFbVMnId3vwodUTbP8=
X-Google-Smtp-Source: ABdhPJzD+dfgdwu1zpQTSq5nBZ7XgFYlzEJWVM1sZsZfgHT8q4lBTU2omUK9MQ9pLJ3qnQc24Wtkxw==
X-Received: by 2002:a17:90a:890a:: with SMTP id u10mr13174006pjn.205.1624092086675;
        Sat, 19 Jun 2021 01:41:26 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id v9sm9586967pgq.54.2021.06.19.01.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 01:41:26 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v5 net-next 1/2] net: tipc: fix FB_MTU eat two pages
Date:   Sat, 19 Jun 2021 16:41:05 +0800
Message-Id: <20210619084106.3657-2-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619084106.3657-1-dong.menglong@zte.com.cn>
References: <20210619084106.3657-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

FB_MTU is used in 'tipc_msg_build()' to alloc smaller skb when memory
allocation fails, which can avoid unnecessary sending failures.

The value of FB_MTU now is 3744, and the data size will be:

  (3744 + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
    SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))

which is larger than one page(4096), and two pages will be allocated.

To avoid it, replace '3744' with a calculation:

  (PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) - \
    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

What's more, alloc_skb_fclone() will call SKB_DATA_ALIGN for data size,
and it's not necessary to make alignment for buf_size in
tipc_buf_acquire(). So, just remove it.

Fixes: 4c94cc2d3d57 ("tipc: fall back to smaller MTU if allocation of local send skb fails")

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
V5:
- remove ONE_PAGE_SKB_SZ and replace it with one_page_mtu

V4:
- fallback to V2

V3:
- split tipc_msg_build to tipc_msg_build and tipc_msg_frag
- introduce tipc_buf_acquire_flex, which is able to alloc skb for
  local message
- add the variate 'local' in tipc_msg_build to check if this is a
  local message.

V2:
- define FB_MTU in msg.c instead of introduce a new file
- remove align for buf_size in tipc_buf_acquire()
---
 net/tipc/bcast.c |  2 +-
 net/tipc/msg.c   | 17 ++++++++---------
 net/tipc/msg.h   |  3 ++-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index d4beca895992..593846d25214 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -699,7 +699,7 @@ int tipc_bcast_init(struct net *net)
 	spin_lock_init(&tipc_net(net)->bclock);
 
 	if (!tipc_link_bc_create(net, 0, 0, NULL,
-				 FB_MTU,
+				 one_page_mtu,
 				 BCLINK_WIN_DEFAULT,
 				 BCLINK_WIN_DEFAULT,
 				 0,
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index ce6ab54822d8..7053c22e393e 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -44,12 +44,15 @@
 #define MAX_FORWARD_SIZE 1024
 #ifdef CONFIG_TIPC_CRYPTO
 #define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
-#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
+#define BUF_OVERHEAD (BUF_HEADROOM + TIPC_AES_GCM_TAG_SIZE)
 #else
 #define BUF_HEADROOM (LL_MAX_HEADER + 48)
-#define BUF_TAILROOM 16
+#define BUF_OVERHEAD BUF_HEADROOM
 #endif
 
+const int one_page_mtu = PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) -
+			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 static unsigned int align(unsigned int i)
 {
 	return (i + 3) & ~3u;
@@ -69,13 +72,8 @@ static unsigned int align(unsigned int i)
 struct sk_buff *tipc_buf_acquire(u32 size, gfp_t gfp)
 {
 	struct sk_buff *skb;
-#ifdef CONFIG_TIPC_CRYPTO
-	unsigned int buf_size = (BUF_HEADROOM + size + BUF_TAILROOM + 3) & ~3u;
-#else
-	unsigned int buf_size = (BUF_HEADROOM + size + 3) & ~3u;
-#endif
 
-	skb = alloc_skb_fclone(buf_size, gfp);
+	skb = alloc_skb_fclone(BUF_OVERHEAD + size, gfp);
 	if (skb) {
 		skb_reserve(skb, BUF_HEADROOM);
 		skb_put(skb, size);
@@ -395,7 +393,8 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 		if (unlikely(!skb)) {
 			if (pktmax != MAX_MSG_SIZE)
 				return -ENOMEM;
-			rc = tipc_msg_build(mhdr, m, offset, dsz, FB_MTU, list);
+			rc = tipc_msg_build(mhdr, m, offset, dsz,
+					    one_page_mtu, list);
 			if (rc != dsz)
 				return rc;
 			if (tipc_msg_assemble(list))
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 5d64596ba987..64ae4c4c44f8 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -99,9 +99,10 @@ struct plist;
 #define MAX_H_SIZE                60	/* Largest possible TIPC header size */
 
 #define MAX_MSG_SIZE (MAX_H_SIZE + TIPC_MAX_USER_MSG_SIZE)
-#define FB_MTU                  3744
 #define TIPC_MEDIA_INFO_OFFSET	5
 
+extern const int one_page_mtu;
+
 struct tipc_skb_cb {
 	union {
 		struct {
-- 
2.32.0

