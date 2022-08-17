Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FAF597728
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiHQTzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbiHQTzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:55:13 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E2CA2633;
        Wed, 17 Aug 2022 12:55:12 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id a4so11191439qto.10;
        Wed, 17 Aug 2022 12:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DG0amPyG3yrFr3Vfk3jNOUNVe3MFz9pJ1sYI46Pla6A=;
        b=GwYrWFgND4NFj2dvpd8dzKxREaU8Q/aHLsTdZOfeIuXEY9iOTSwda/B+GrgJTA0VuF
         DXKZ1L5uPrzlqziwljddQnKb1jTaCvNdhf14Z+OssaZ7jd4rYO8qyAsHKuLibOGzIb3K
         1ka3my8ic4RPcSwjDJPCXvn6UrNT6K7b9AxrAkZ1AU1LKiEZCgbbZ9GUZO108oK1ekwt
         BgcK1lEW8Cg/YpoqExCtjC0rG3qy4dIMAq6KloCPQLL/emSAFsCVXCANxfp+vbXKBnvX
         +ckiAbuodPGY/S/LOyOip+2b6Kh+hGTkLiC+2KaJ9UzgRQr6fkMKP/k5fc5BkHl1ZQCB
         gJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DG0amPyG3yrFr3Vfk3jNOUNVe3MFz9pJ1sYI46Pla6A=;
        b=JyTtTLrCiPhT+sebyYD91G3d1aSIMhPrKQ7ATrlWpnDWPspyHoogHJW+pxKMjGF8UX
         EdmqhtHNKiB+5l3n1sVxtaVG159bNfkz5qBmlu/sqqneUDlyCTiE9RGRE1pH+XVKhw8g
         XsxWU9600k8T5acaFqLlNpLP21Yhlfe14eWxht/H2NX3qqHviAdN36oSviyXzD7BOsDW
         4UQKX6UqybaT1QIma6VcOd/AXDQEt+RDPgoIbTPmm349+PDY/kFU8eRTkTJoziWZiQcZ
         WhrsspaUdQoPicJR982QBV4cRaoFKKgRhLbDqa7DElxby7SyHl1mmBz4hlO8r8nMBv0/
         C6ZA==
X-Gm-Message-State: ACgBeo13m+FIFws1mt5vgswGQHLyT4bwXZDKGI2kkdrs2I+OBZcev6YL
        1GvunJSa3aFiQQzG/0YgNE+/4woAZ1U=
X-Google-Smtp-Source: AA6agR5GbZGz2HuK4I/5JtV6ResayeTrpKniL6OiCy3+VqRcYPSjsLGF7O5/iGGryroGikV09Ea8eA==
X-Received: by 2002:ac8:7f53:0:b0:343:652:ce62 with SMTP id g19-20020ac87f53000000b003430652ce62mr23365379qtk.514.1660766111031;
        Wed, 17 Aug 2022 12:55:11 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b87a:4308:21ec:d026])
        by smtp.gmail.com with ESMTPSA id az30-20020a05620a171e00b006bb8b5b79efsm2225473qkb.129.2022.08.17.12.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:55:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v3 1/4] tcp: fix sock skb accounting in tcp_read_skb()
Date:   Wed, 17 Aug 2022 12:54:42 -0700
Message-Id: <20220817195445.151609-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
References: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
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

