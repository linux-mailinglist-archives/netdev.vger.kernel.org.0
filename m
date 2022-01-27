Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B8749D6D2
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiA0Agt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiA0Ago (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E9C06173B;
        Wed, 26 Jan 2022 16:36:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w25so585189edt.7;
        Wed, 26 Jan 2022 16:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDqDCJ5NL4LuLdFrIrWhPcUdc5NRFY/X6Wj3QPHSD+0=;
        b=dbwE2UZJaBfWlzco9zRjfOlhlIpzG/xZyaJKOUSu1yt8bXlyguuEM3KNKyantOJUF4
         dgllJb9j1ScQTFkVM1YVkge+GlR+ux+OJ9/x3VRAPVCuxLokWthjDuf50zpd+dXo7SQL
         7K+P1M4+OrTgtEMQpm5xZgpCv4zMzfYzG+dm8FInh+AHEmMG2CFFPpImilkUoIRl88DI
         286GejQIlZEZQG1A7FofDIRjAUQy75vBgy2SCouCY664B9uegMoamGqAnDvmDEkmGHJD
         cQ47/qzcadSYWhik+yABV3Axd8xA9zklQrlU2qK4fkH3IL6q5rbT/zzuqkeLTgLJ0cqc
         zn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDqDCJ5NL4LuLdFrIrWhPcUdc5NRFY/X6Wj3QPHSD+0=;
        b=6NnnH/p0U65a08gyneraubt9WrM91YDjcfffRXgy4aMtc46xXCC4ojU9yKVLhZ/KDn
         buON435Ux1sUJTcMgZRD9I4jCpf0gpLTiWe32SmXqctp4kIK5h7lvK3alIMhGEFsMR7G
         9bYwzEn5tn58PjHGgPFq5fH068UmghdTBHPbIWqeSo3p6mwWF+64YXGG+QAI6BLl8LIv
         ov01p91pJp5KEDwymvQ+HP7xFhaT74Km+TfC7qWRNrqnMSl6TWP3tfNgS9gAPqor5pFg
         IScmMWqT+tZXIHbZ52B2JbMNzWTTILUWl2ZyVpA/IHx5pHYQUKYMvvV/fqf8G0bL2DFG
         WFYA==
X-Gm-Message-State: AOAM531WBE/d3ervkU7Bav1lPtotp8217jCHX9cibUksM2mwOJvOtRuf
        7/V7jOjt6kbLvoTa4K+sSY1aUTAB61U=
X-Google-Smtp-Source: ABdhPJzgnH6LO5Q9T0RHAKza0klM/MRdhz7JaOnKxE0xu+F/36Z3S3hBnpOCXzUUK+WDQhEZ0hPS/Q==
X-Received: by 2002:a05:6402:40cd:: with SMTP id z13mr1384319edb.119.1643243802763;
        Wed, 26 Jan 2022 16:36:42 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 06/10] ipv6: pass full cork into __ip6_append_data()
Date:   Thu, 27 Jan 2022 00:36:27 +0000
Message-Id: <af6573436085d52c2e144c47db27078e6e00b047.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert a struct inet_cork argument in __ip6_append_data() to struct
inet_cork_full. As one struct contains another inet_cork is still can
be accessed via ->base field. It's a preparation patch making further
changes a bit cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index b8fdda9ac797..62da09819750 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1424,7 +1424,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 static int __ip6_append_data(struct sock *sk,
 			     struct flowi6 *fl6,
 			     struct sk_buff_head *queue,
-			     struct inet_cork *cork,
+			     struct inet_cork_full *cork_full,
 			     struct inet6_cork *v6_cork,
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
@@ -1433,6 +1433,7 @@ static int __ip6_append_data(struct sock *sk,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
+	struct inet_cork *cork = &cork_full->base;
 	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu, pmtu;
 	struct ubuf_info *uarg = NULL;
 	int exthdrlen = 0;
@@ -1797,7 +1798,7 @@ int ip6_append_data(struct sock *sk,
 		transhdrlen = 0;
 	}
 
-	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork.base,
+	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
 				 from, length, transhdrlen, flags, ipc6);
 }
@@ -1993,7 +1994,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	if (ipc6->dontfrag < 0)
 		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
-	err = __ip6_append_data(sk, fl6, &queue, &cork->base, &v6_cork,
+	err = __ip6_append_data(sk, fl6, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
 				flags, ipc6);
-- 
2.34.1

