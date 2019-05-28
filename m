Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451DC2D297
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfE1X6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:58:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54823 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfE1X6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:58:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id i3so291914wml.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xi6hRmlV/rkYRZXwRwO7EpD99nzQCtGBu1E4jVd0OG0=;
        b=VsUcsClDxmxFGBU2L8HFR32JcFa3nZsyfahOOLLZqs0g7mck9Y+U5CTEd2ANOWDPUG
         pTknEURPjQmaV5qsYcwscdw1ZIcFbCRf4HhZSpxDQZ2bZGSDpCAdi//WSdRYPpGtkYy0
         Pu2W9wzbq9JW6lJD8SjVq7aWpLSJqkIHHt7dIJR2KzLg1WFN2NjjlWOejU/V6NRQQ9hp
         RxpTV7XWPHp/psAKOfX+nwWYL9yzZRFoY6JRda2YSMFOlLTXspqyeKQD+hiAkmgTs65K
         8GHQS7qi4DnpWNHxDnHwHdwAT3q4cnKXOxK9SQK8o0Nu7KiKCb5QI4c2GvOa1hTJmyIu
         ZX1A==
X-Gm-Message-State: APjAAAXLi5EXG9iSRuHFmOQ12aWhA8CBfXqmjccJI4bBdBGIvGDcSvyN
        Zz4Tw+kKOJRJ7JbnsqN2jbLes5yiMCk=
X-Google-Smtp-Source: APXvYqxfl6xm2qcJA8awYqlEkYvzsKyFY1ok6e7KAzVB9YFi3gVE4bn35EcLiejKxDcMlJOYMcHy+Q==
X-Received: by 2002:a05:600c:1109:: with SMTP id b9mr4658543wma.107.1559087926470;
        Tue, 28 May 2019 16:58:46 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.vodafonedsl.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id a10sm17826941wrm.94.2019.05.28.16.58.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 16:58:45 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: avoid indirect calls in L4 checksum calculation
Date:   Wed, 29 May 2019 01:58:44 +0200
Message-Id: <20190528235844.19360-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up
indirect calls of builtin") introduces some macros to avoid doing
indirect calls.

Use these helpers to remove two indirect calls in the L4 checksum
calculation for devices which don't have hardware support for it.

As a test I generate packets with pktgen out to a dummy interface
with HW checksumming disabled, to have the checksum calculated in
every sent packet.
The packet rate measured with an i7-6700K CPU and a single pktgen
thread raised from 6143 to 6608 Kpps, an increase by 7.5%

Suggested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/core/skbuff.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be6282693..a24a7ef55ce9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,7 @@
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
+#include <net/sctp/checksum.h>
 #include <net/xfrm.h>
 
 #include <linux/uaccess.h>
@@ -76,9 +77,22 @@
 #include <linux/highmem.h>
 #include <linux/capability.h>
 #include <linux/user_namespace.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include "datagram.h"
 
+#if IS_ENABLED(CONFIG_IP_SCTP)
+#define CSUM_UPDATE(f, ...) \
+	INDIRECT_CALL_2(f, csum_partial_ext, sctp_csum_update, __VA_ARGS__)
+#define CSUM_COMBINE(f, ...) \
+	INDIRECT_CALL_2(f, csum_block_add_ext, sctp_csum_combine, __VA_ARGS__)
+#else
+#define CSUM_UPDATE(f, ...) \
+	INDIRECT_CALL_1(f, csum_partial_ext, __VA_ARGS__)
+#define CSUM_COMBINE(f, ...) \
+	INDIRECT_CALL_1(f, csum_block_add_ext, __VA_ARGS__)
+#endif
+
 struct kmem_cache *skbuff_head_cache __ro_after_init;
 static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
 #ifdef CONFIG_SKB_EXTENSIONS
@@ -2507,7 +2521,7 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		csum = ops->update(skb->data + offset, copy, csum);
+		csum = CSUM_UPDATE(ops->update, skb->data + offset, copy, csum);
 		if ((len -= copy) == 0)
 			return csum;
 		offset += copy;
@@ -2534,9 +2548,9 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 					      frag->page_offset + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
-				csum2 = ops->update(vaddr + p_off, p_len, 0);
+				csum2 = CSUM_UPDATE(ops->update, vaddr + p_off, p_len, 0);
 				kunmap_atomic(vaddr);
-				csum = ops->combine(csum, csum2, pos, p_len);
+				csum = CSUM_COMBINE(ops->combine, csum, csum2, pos, p_len);
 				pos += p_len;
 			}
 
@@ -2559,7 +2573,7 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 				copy = len;
 			csum2 = __skb_checksum(frag_iter, offset - start,
 					       copy, 0, ops);
-			csum = ops->combine(csum, csum2, pos, copy);
+			csum = CSUM_COMBINE(ops->combine, csum, csum2, pos, copy);
 			if ((len -= copy) == 0)
 				return csum;
 			offset += copy;
-- 
2.21.0

