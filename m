Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D82191EF4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 03:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgCYCX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 22:23:27 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45425 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbgCYCX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 22:23:27 -0400
Received: by mail-pg1-f202.google.com with SMTP id v29so578061pgo.12
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 19:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qssuXp8+hvjCs6aYybM8rTl3iuwh3ZYedZH+D3blY6M=;
        b=jX4G8CfbWoJKPoxh0ifknx8xSBxvuqzOi2n/oLGY+KvYcbR57SS/48oCFILbzKjFEv
         qyfHxLmwLNhSr1/o1aSu0HC/xLOVXjCK88qExz80qkqAilsdtQbHhecMX+ZzMpt1plZB
         /Qyt55BhEeHRAhi/T7Xolk4BMW9nR1jsap2+Fz1qNgnbWxi2xLtakXtGExeM53ldrNE5
         CGOqb5bKEROq3Vd6Rp5nUEvdB0N4csjgiN5MHzog21Dd8rhAd1sfkaUzohdYBog6M+AU
         ++HgKbLfyix/bUf19lkRxV8LQLNQ3UkF/2R+5OY79KfniMZJ8A+FiWBUKTjs6/tyzbBx
         j75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qssuXp8+hvjCs6aYybM8rTl3iuwh3ZYedZH+D3blY6M=;
        b=SXWSxOvfcAYlpyv/SgJX4mV8FuQd08UXXasvC1ByzxulEjMAiJ+178mQWJqkowME8r
         E1IbTtHN3FrwY2AUKEbJ3Q2NlgNVN68kqs4+RrYiQUsqex1EeCfiB6LkemKdVnlwxATg
         ey+eRpllkw74zquYF6XkBgJEvzw5ldonQxBcKw8CbaLGWuLejfTTkG4ADALrKpPnnreH
         DhvVqJPC9KO5sLF4D6ZhqHA2sh+3YG+FlErkor22sYh+9JIrc/ba/O1rk5EGZW84Bkqo
         kNd16midn3zquSq1XnIhmEe2gHMvYlh+7lI1HDLbviYmQLh/qB+vj5zx0vDyNVwTqoig
         AUVw==
X-Gm-Message-State: ANhLgQ2NG4HjYVkFfmw13N4+u/5gQp0yP1wB1dSZdlSviQOIw2/pzLtA
        prY4wFOIy4aLCaMODiQArhLdy9F+EMnh3g==
X-Google-Smtp-Source: ADFU+vvcvBceb6PZhhrWLVZdGyOT4Q1oPGKNN4+8GvG3GBXJP0Rcu51APnxawSEYXP+XYs/1T9xqTty+TvRM0Q==
X-Received: by 2002:a17:90a:7d07:: with SMTP id g7mr985706pjl.17.1585103004406;
 Tue, 24 Mar 2020 19:23:24 -0700 (PDT)
Date:   Tue, 24 Mar 2020 19:23:21 -0700
Message-Id: <20200325022321.21944-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH net-next] net: use indirect call wrappers for skb_copy_datagram_iter()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP recvmsg() calls skb_copy_datagram_iter(), which
calls an indirect function (cb pointing to simple_copy_to_iter())
for every MSS (fragment) present in the skb.

CONFIG_RETPOLINE=y forces a very expensive operation
that we can avoid thanks to indirect call wrappers.

This patch gives a 13% increase of performance on
a single flow, if the bottleneck is the thread reading
the TCP socket.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/datagram.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 4213081c6ed3d4fda69501641a8c76e041f26b42..639745d4f3b94a248da9a685f45158410a85bec7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/uio.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/protocol.h>
 #include <linux/skbuff.h>
@@ -403,6 +404,11 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
 }
 EXPORT_SYMBOL(skb_kill_datagram);
 
+INDIRECT_CALLABLE_DECLARE(static size_t simple_copy_to_iter(const void *addr,
+						size_t bytes,
+						void *data __always_unused,
+						struct iov_iter *i));
+
 static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 			       struct iov_iter *to, int len, bool fault_short,
 			       size_t (*cb)(const void *, size_t, void *,
@@ -416,7 +422,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		n = cb(skb->data + offset, copy, data, to);
+		n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+				    skb->data + offset, copy, data, to);
 		offset += n;
 		if (n != copy)
 			goto short_copy;
@@ -438,8 +445,9 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			n = cb(vaddr + skb_frag_off(frag) + offset - start,
-			       copy, data, to);
+			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+					vaddr + skb_frag_off(frag) + offset - start,
+					copy, data, to);
 			kunmap(page);
 			offset += n;
 			if (n != copy)
-- 
2.25.1.696.g5e7596f4ac-goog

