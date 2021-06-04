Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189BB39B43E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFDHrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:47:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39862 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFDHrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:47:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id k15so6852317pfp.6;
        Fri, 04 Jun 2021 00:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0P3clYHJ8xPqDi3WVcB6xT6PzzERN4OuPznkW2CQFF8=;
        b=g4fXBITkPbYHA9gjCozwnxx42egWBrMd3l9/mls5oXHBxa7ca7H34JEUB+axqOrCUX
         Kad2rD0PBr+acM048D45qEAO12mhTghECOsZfJsNRLlXeXVQRCQ6DDrWTXepWkU614fO
         a6gfh29sdwtIdn0w/wLqSmI52XfvYL+Uk9OL5B33vnPo4Ft3x9fnDoSJ1wxKThCFVTcL
         ujjtEILJI3GCo1gUI0Wga5fR8B80076KqwATZhuUxTgLdMOFqH/DKafcNJXo04J8HW54
         2N2KrlN8NbraNESounoqpi2L8GOr3js17s7r3NpsZOAp02JrKpsVwZLCJreOvs+r/Hh/
         SjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0P3clYHJ8xPqDi3WVcB6xT6PzzERN4OuPznkW2CQFF8=;
        b=JLrSc6NPg/q847vV93dHI3zqvsfNcrL1HiCqG1PKIPGPqYGF6Y9u9rX/0sXBbV/M3A
         0z9uy3zRUC8ZnBp/iOlNvfRZSaTNigB3mOKCO2RPg8QhLNm7udlbgPTRB5+Nc/bGgc2k
         FZUnoNHGix2acim6gp/aQNCs803ZZdrFQoUYVHalrYegaNZpcJZpQsZEIXWwhYkQ8ZHJ
         5REjVH5iHUWTc/AKsYrLhqT1QAUr9JDBREM5swNALTKvmz5H6Xo9SsEG5EOLLTYrR8lE
         Ag64rVKZYL9zT7+fPzkD4G2fL8sXu+R/jvuPpS5zVDtWe+Ox2qgLRn4ExRkxZcESkMIf
         i+mg==
X-Gm-Message-State: AOAM5326Izkv5wqk6+nwpqbiGXIDdS8/ny3Wlf3KOPxWBvDIcq4JTJno
        sw6CKaxNkLuKng2CAH8dN94=
X-Google-Smtp-Source: ABdhPJx9rpwqq9P3pg8/JRb4+1WFPIDGLD/c4qtEmgvQOqTcqbwNu4rAKw7CfhXFF1zdvgH4uSPr9w==
X-Received: by 2002:a62:87c9:0:b029:2ea:572c:e4b1 with SMTP id i192-20020a6287c90000b02902ea572ce4b1mr3468411pfe.34.1622792694604;
        Fri, 04 Jun 2021 00:44:54 -0700 (PDT)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b23sm1051946pfi.34.2021.06.04.00.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 00:44:54 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
Date:   Fri,  4 Jun 2021 00:44:19 -0700
Message-Id: <20210604074419.53956-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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
          - SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))

Fixes: 4c94cc2d3d57 ("tipc: fall back to smaller MTU if allocation of local send skb fails")

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/tipc/bcast.c |  1 +
 net/tipc/msg.c   |  8 +------
 net/tipc/msg.h   |  1 -
 net/tipc/mtu.h   | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 8 deletions(-)
 create mode 100644 net/tipc/mtu.h

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index d4beca895992..c641b68e0812 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -41,6 +41,7 @@
 #include "bcast.h"
 #include "link.h"
 #include "name_table.h"
+#include "mtu.h"
 
 #define BCLINK_WIN_DEFAULT  50	/* bcast link window size (default) */
 #define BCLINK_WIN_MIN      32	/* bcast minimum link window size */
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index ce6ab54822d8..ec70d271c2da 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -40,15 +40,9 @@
 #include "addr.h"
 #include "name_table.h"
 #include "crypto.h"
+#include "mtu.h"
 
 #define MAX_FORWARD_SIZE 1024
-#ifdef CONFIG_TIPC_CRYPTO
-#define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
-#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
-#else
-#define BUF_HEADROOM (LL_MAX_HEADER + 48)
-#define BUF_TAILROOM 16
-#endif
 
 static unsigned int align(unsigned int i)
 {
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 5d64596ba987..e83689d0f0f6 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -99,7 +99,6 @@ struct plist;
 #define MAX_H_SIZE                60	/* Largest possible TIPC header size */
 
 #define MAX_MSG_SIZE (MAX_H_SIZE + TIPC_MAX_USER_MSG_SIZE)
-#define FB_MTU                  3744
 #define TIPC_MEDIA_INFO_OFFSET	5
 
 struct tipc_skb_cb {
diff --git a/net/tipc/mtu.h b/net/tipc/mtu.h
new file mode 100644
index 000000000000..033f0b178f9d
--- /dev/null
+++ b/net/tipc/mtu.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2021 ZTE Corporation.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the names of the copyright holders nor the names of its
+ *    contributors may be used to endorse or promote products derived from
+ *    this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _TIPC_MTU_H
+#define _TIPC_MTU_H
+
+#include <linux/tipc.h>
+#include "crypto.h"
+
+#ifdef CONFIG_TIPC_CRYPTO
+#define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
+#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
+#define FB_MTU	(PAGE_SIZE - \
+		 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
+		 SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))
+#else
+#define BUF_HEADROOM (LL_MAX_HEADER + 48)
+#define BUF_TAILROOM 16
+#define FB_MTU	(PAGE_SIZE - \
+		 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
+		 SKB_DATA_ALIGN(BUF_HEADROOM + 3))
+#endif
+
+#endif
-- 
2.25.1

