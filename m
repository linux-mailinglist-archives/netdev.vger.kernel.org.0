Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497AF58C213
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiHHDb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiHHDbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:31:25 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7427679;
        Sun,  7 Aug 2022 20:31:23 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n133so9168202oib.0;
        Sun, 07 Aug 2022 20:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DG0amPyG3yrFr3Vfk3jNOUNVe3MFz9pJ1sYI46Pla6A=;
        b=EkXagkcfh8hgTyLEGYGHySv2Lluaau/vK+LIc3V28JMxAoaEvTz/8s1147fLeDnUn/
         PiVcIY4oK7ju8JqBltovNOf4/ZJ2d5Lpscqqkd86EcSrz8Hx0S6Gu1yY3fBAjDeBpZsw
         QC97xOFlsfmJ8gZE7qFG6T2QOIyRyGQsMZjdhswEaRlQaBqCuNhJABG5vLbuXOE/piv/
         rELBsVmzhzxmF+Ev5YwNo+l7C0j3+lCCiloJ+aZ3f5Zymnk/DL5oCN3kYY+IveOMZLEa
         1lyar+wYQ3sly0RwWSw0c4I+bj0QnsqXq1v00cxCgyfwgKg1MmH+rXLTV/7lo+pm+Zy3
         d9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DG0amPyG3yrFr3Vfk3jNOUNVe3MFz9pJ1sYI46Pla6A=;
        b=anpvsTsFyXv0y2gmig65VhZfNhLrHmqs635/kt66MShzVedxVwPuip+uab1O7c35Rc
         BqFJA2hxZUA7WOTNHF2OAQL5g9OskKR3LZgpoCmhAX0v2POmmoFFRvuSJeDPpXM5zsdC
         rr9stiMCz38i8KTvAa2Pz2FPtYPP2wbt7RdMgU0NK0vmReUv4FdNI8CBV4gWKyQqGVWy
         rcfQZeAMK3KkfU4KOUYyn5wAyOupmh7aEXD3T0sHBmuKqlJ6tjXa0mFgWXu5CCFNUhU4
         zIYQIB2PhvrkBNhJSwA6Ya8zRCKc4LJBlQUb0VRjrsYzLOTUvvzHYXbQms21RNGzX2BY
         i3oQ==
X-Gm-Message-State: ACgBeo0icQ/Uz5ger2EqzCXdAcDgOHjILJC5WMs0CfRS4UHiUpLJLzYY
        ukEqkdrd9XBLRA9xRE3mYvCFBwVQLGg=
X-Google-Smtp-Source: AA6agR6m9fcea7cA0v91SVykKrKvMPyYGmvznJVXPf9CVCWQcxjdMnTPSjGAbxXSY898Pgh/gIcxVA==
X-Received: by 2002:a05:6808:1285:b0:33a:c5c8:45ce with SMTP id a5-20020a056808128500b0033ac5c845cemr9944284oiw.136.1659929483231;
        Sun, 07 Aug 2022 20:31:23 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ad03:d88f:99fe:9487])
        by smtp.gmail.com with ESMTPSA id k39-20020a4a94aa000000b00425806a20f5sm1945138ooi.3.2022.08.07.20.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:31:22 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v2 1/4] tcp: fix sock skb accounting in tcp_read_skb()
Date:   Sun,  7 Aug 2022 20:31:03 -0700
Message-Id: <20220808033106.130263-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
References: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Before commit 965b57b469a5 ("net: Introduce a new proto_ops
->read_skb()"), skb was not dequeued from receive queue hence
when we close TCP socket skb can be just flushed synchronously.

After this commit, we have to uncharge skb immediately after being
dequeued, otherwise it is still charged in the original sock. And we
still need to retain skb->sk, as eBPF programs may extract sock
information from skb->sk. Therefore, we have to call
skb_set_owner_sk_safe() here.

Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
Reported-and-tested-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
Tested-by: Stanislav Fomichev <sdf@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 970e9a2cca4a..05da5cac080b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1760,6 +1760,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		int used;
 
 		__skb_unlink(skb, &sk->sk_receive_queue);
+		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.34.1

