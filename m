Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A112956CBAB
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 00:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiGIWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGIWUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 18:20:43 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93AC1262E;
        Sat,  9 Jul 2022 15:20:42 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id p22so1503550qkj.4;
        Sat, 09 Jul 2022 15:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jar/wn5SAcivKcUXRjmaj2VcVCJGgbSuRsAEeqFIITo=;
        b=fDx+XSxkgVz0uMbEkQdHTdezbvggIZPd1KpFvZ3z9Itl+m27xDpAe91+MUieN9QIsZ
         54qQWzxV0rNRUAC6DatCvLE9ez7jQtb3mwqZ8Xifgh8SWqkhI8TgUX3L5J2+RX93WEAI
         woq0up533Bl/R5uiBkdyysrhbWOj+xr4Rud3EHYUScPM1Qsot8mQ82kZtN3+L5qyTGmh
         ElqlX2+9OvFQyPhUanTbx0tx3aj28bCBa7eYGbRa1RHFyKpPGEznPQ8WAP9wCbJF9rGa
         Lc27Iptp6x1uiOXAM0plPZKxwwifyg48vxJ1SkZW2oCvDLOi+NAlvkTOZ2IYEaWbM2sy
         cKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jar/wn5SAcivKcUXRjmaj2VcVCJGgbSuRsAEeqFIITo=;
        b=W2/27EZj+4FQ3yvVULS2gx2upySbLJ7obguqgJGwQqmiI6YdaXU2z2y89d9t99t/6S
         xUObsVfaVlA+hwj1vuQ/gubT26sJY1IGMdWOUtgh0UTEzp/hRHq512dRZAReqqVlMGg9
         gx9Jz6c0FX7X3SI5cU0WfkaLR6+Wv3bTMguoy3kmvy/ggZUT9AGg2Fwa8J1JUkEV+rCc
         e0cXM5F/7qGWYsKh1V1Hazpi0iPxMJWUvVf+hEDKwe/vtBvEXRI3NxUT9H2xu3CoWnng
         /ZaX5z3PO010FHaYbLLhp2Eu+wtuor5KS6R/MTkYnX9NISfOJObwL+i1NciJsIQf5+QK
         6vPg==
X-Gm-Message-State: AJIora/9YLvbjq0a411/xKn4r7P72IkXrtTkGp9Dc1qOda9OmWgAxaYi
        p71lYe+qEC0hhP8AWTziC8+elswIp54=
X-Google-Smtp-Source: AGRyM1uw5Vs+H7iCq7TA6+adLnZkbtbzMAu+IS1LdXpiVFVNW0sEmH2eYQVd4v3367tKHIEDjSSHNw==
X-Received: by 2002:a05:620a:2987:b0:6b5:7d81:e34b with SMTP id r7-20020a05620a298700b006b57d81e34bmr37736qkp.271.1657405241439;
        Sat, 09 Jul 2022 15:20:41 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:7207:3bf4:9b32:cf29])
        by smtp.gmail.com with ESMTPSA id w13-20020a05620a424d00b006af0ce13499sm2151006qko.115.2022.07.09.15.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 15:20:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
Date:   Sat,  9 Jul 2022 15:20:29 -0700
Message-Id: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
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
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9d2fd3ced21b..c6b1effb2afd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		int used;
 
 		__skb_unlink(skb, &sk->sk_receive_queue);
+		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.34.1

