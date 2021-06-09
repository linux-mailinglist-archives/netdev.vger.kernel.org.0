Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF53A1136
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbhFIKg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:36:27 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34636 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbhFIKgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:36:21 -0400
Received: by mail-pj1-f65.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso3378483pjx.1;
        Wed, 09 Jun 2021 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3/PEdGfKw4jNv3dNtMbhxTAX0lqrz/wz/xndFk5yLFU=;
        b=ONrehfMovWQq+c13KvSioMsrrd3rXvSLRAxdEf30sFV8NPk9J00+GPiqHJ9lRm6phA
         tbrn5Hi1CCi7fFdyVYBBAacnXNwRIoc5D76D+FXWNELi++50UR7eWNArqi8dJex0PRDZ
         +QrW8Jv1z/TwJggw87QOTixX6Eif3XWdr7/yRCsOiHsxWdCyaI+ajE34VOnOStSB8MXY
         amz+h2Rr0+lpzLzLK9JJ94wVywyHuRn7phuo2oGap2hkgSwxTfJPQLmm+j/QL6MdTtmE
         jdoQjMwJ0zATKi5vz0A7zQB6Eso+pHSUtUQBVvyTK2ZrySZCQbB23wzv/wypjatkPhLj
         CzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3/PEdGfKw4jNv3dNtMbhxTAX0lqrz/wz/xndFk5yLFU=;
        b=toziLp2d3JGYLk0E+JwW+JWe4zrnhw7ZE3Ku4YZG63Al3IJp/JhyHuxB4d/3u9L18Y
         ztBQDBH0yQEiAUh5Gu4HTCxsTgn+o5BzfTpghjkWlmn37eddr9W7P6pNyxlndrjCRxQ8
         KtzTWMOpUmdpyT+5twYp1D7B9b+ewQxh6LTXKsHjoalQhqvTz9xd/eFWsH2TxK/FfNJC
         gc36PUddbllvKFn8K483MdsL4QzyvAYb3Yr/HRKp3VfPmI26j+oZe3ajBmIqAwi6ggQM
         gYalBYu0sCgERqzFqArFDAOc5q5yPrhcCjy6nLvg/Qnqaraxs9BIdHkTz4edqZYq2h6G
         gEfw==
X-Gm-Message-State: AOAM533P9Ch/YiyM337VQKy5D7UmxrMJdnQ1Ivr3CatvNfLPxo/o8+MG
        ieSLBvVe2pOjTkW9sli01jI=
X-Google-Smtp-Source: ABdhPJyBzT20ZeYDcXexcUuUYdaavKO+6m3pqh1h991c2YOSnf0ysMiYlZ4a0P2uWvXPeQkoH/ev2g==
X-Received: by 2002:a17:90b:881:: with SMTP id bj1mr31339360pjb.119.1623234794326;
        Wed, 09 Jun 2021 03:33:14 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id x33sm12436422pfh.108.2021.06.09.03.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:13 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2 net-next 1/2] net: tipc: fix FB_MTU eat two pages
Date:   Wed,  9 Jun 2021 18:32:50 +0800
Message-Id: <20210609103251.534270-2-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210609103251.534270-1-dong.menglong@zte.com.cn>
References: <20210609103251.534270-1-dong.menglong@zte.com.cn>
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

FB_MTU = (PAGE_SIZE - SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
          - SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM))

What's more, alloc_skb_fclone() will call SKB_DATA_ALIGN for data size,
and it's not unnecessary to make alignment for buf_size in
tipc_buf_acquire(). So, just remove it.

Fixes: 4c94cc2d3d57 ("tipc: fall back to smaller MTU if allocation of local send skb fails")

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
V2:
- define FB_MTU in msg.c instead of introduce a new file
- remove align for buf_size in tipc_buf_acquire()
---
 net/tipc/bcast.c |  2 +-
 net/tipc/msg.c   | 15 ++++++++-------
 net/tipc/msg.h   |  3 ++-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index d4beca895992..9daace9542f4 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -699,7 +699,7 @@ int tipc_bcast_init(struct net *net)
 	spin_lock_init(&tipc_net(net)->bclock);
 
 	if (!tipc_link_bc_create(net, 0, 0, NULL,
-				 FB_MTU,
+				 fb_mtu,
 				 BCLINK_WIN_DEFAULT,
 				 BCLINK_WIN_DEFAULT,
 				 0,
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index ce6ab54822d8..a5c030ca7065 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -47,8 +47,14 @@
 #define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
 #else
 #define BUF_HEADROOM (LL_MAX_HEADER + 48)
-#define BUF_TAILROOM 16
+#define BUF_TAILROOM 0
 #endif
+#define FB_MTU (PAGE_SIZE - \
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
+		SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM) \
+		)
+
+const int fb_mtu = FB_MTU;
 
 static unsigned int align(unsigned int i)
 {
@@ -69,13 +75,8 @@ static unsigned int align(unsigned int i)
 struct sk_buff *tipc_buf_acquire(u32 size, gfp_t gfp)
 {
 	struct sk_buff *skb;
-#ifdef CONFIG_TIPC_CRYPTO
-	unsigned int buf_size = (BUF_HEADROOM + size + BUF_TAILROOM + 3) & ~3u;
-#else
-	unsigned int buf_size = (BUF_HEADROOM + size + 3) & ~3u;
-#endif
 
-	skb = alloc_skb_fclone(buf_size, gfp);
+	skb = alloc_skb_fclone(BUF_HEADROOM + size + BUF_TAILROOM, gfp);
 	if (skb) {
 		skb_reserve(skb, BUF_HEADROOM);
 		skb_put(skb, size);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 5d64596ba987..2c214691037c 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -99,9 +99,10 @@ struct plist;
 #define MAX_H_SIZE                60	/* Largest possible TIPC header size */
 
 #define MAX_MSG_SIZE (MAX_H_SIZE + TIPC_MAX_USER_MSG_SIZE)
-#define FB_MTU                  3744
 #define TIPC_MEDIA_INFO_OFFSET	5
 
+extern const int fb_mtu;
+
 struct tipc_skb_cb {
 	union {
 		struct {
-- 
2.32.0

