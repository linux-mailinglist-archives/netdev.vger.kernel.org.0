Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1331A59772A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiHQTzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiHQTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:55:23 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60419A5708;
        Wed, 17 Aug 2022 12:55:16 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id x5so11194565qtv.9;
        Wed, 17 Aug 2022 12:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=5A9tdu7hCq0qZKmIL9fh8BCnyR2CCjsb3cc8QUKQaKw=;
        b=XqmCKAQiy3rfCugslBWfzKGxE+Ge0uaJxbh3yVuCYTITAmvN37WPfYI3UQz+giycQ6
         lCs+e5Q2H1xpNv3QL8ilz7r30EhWnbsLWFar+ImBDDt49Yw66va1BqS0j/9iZJKWBtnu
         AggMW3Y+FHt1rAofLVKZPfMoHvG7LFsiFI7aecXl6Y4A0M80vsOK80/B27gGP4EOGOFB
         60cZg9IlFM3QTt5Oq7nUuW0ZExpbxuTGnWq0usOPF2pidJjEWB4C/VrawqcIl+HNcM0D
         EX4iBQkj+qxORBJobfoDERSJ/dQ6xlLPYnpUoBrwLitxidJnPzVZSP8gxyZH7+StX3RB
         pnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=5A9tdu7hCq0qZKmIL9fh8BCnyR2CCjsb3cc8QUKQaKw=;
        b=QhKHR//DWnoyvAuEzPMRVwgOUjcW1dD7/Yb0/K9o76FyNyHuciMN7KSzRK1FjTXVd3
         xdE2GL+2xPiM/3pOa87qXWUaoyOUMRzDaGIgiR2Zl6fnNXrWpFSiE0iviKh5tIzKYLVO
         evZlJBd3Ehxds8dyy/lklRyAI/zQg4xltUEi6RfjC2EKjFYC/nCwivsL0DAHf0VKAqJ8
         Ck/dgGSEB7UXv5TR2p/Unv2wju3keQngs1zSdWdnX1GSOgveMg7r1pxl41jiamWGLq4j
         ekuGUiV/RY0le9wlVlzeZ+qWm/BHuGarFf2Cdu0CNsrujSFbqHuCe0TYKZjuy6Q+fq7I
         O2dw==
X-Gm-Message-State: ACgBeo0SKc3y8jgUZT1LINNk8Rfm/6Sqc+r5utq8pDnz+sJMPNcTE+Pm
        MMoCDz+CjhaOZcoKR99WWTX/34OrYqo=
X-Google-Smtp-Source: AA6agR6o9xwvngA1p8yKTGihsSa2dsexgKjakkAe44SUf6w9CnRAKySqKC3qdsR+XNM829ogOh7SRA==
X-Received: by 2002:ac8:5f8f:0:b0:342:fb0c:77d0 with SMTP id j15-20020ac85f8f000000b00342fb0c77d0mr24066446qta.93.1660766115167;
        Wed, 17 Aug 2022 12:55:15 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b87a:4308:21ec:d026])
        by smtp.gmail.com with ESMTPSA id az30-20020a05620a171e00b006bb8b5b79efsm2225473qkb.129.2022.08.17.12.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:55:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v3 4/4] tcp: handle pure FIN case correctly
Date:   Wed, 17 Aug 2022 12:54:45 -0700
Message-Id: <20220817195445.151609-5-xiyou.wangcong@gmail.com>
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

When skb->len==0, the recv_actor() returns 0 too, but we also use 0
for error conditions. This patch amends this by propagating the errors
to tcp_read_skb() so that we can distinguish skb->len==0 case from
error cases.

Fixes: 04919bed948d ("tcp: Introduce tcp_read_skb()")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 5 +++--
 net/ipv4/tcp.c   | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f47338d89d5d..59e75ffcc1f4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1194,8 +1194,9 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
-	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
-		len = 0;
+	ret = sk_psock_verdict_apply(psock, skb, ret);
+	if (ret < 0)
+		len = ret;
 out:
 	rcu_read_unlock();
 	return len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 56a554b49caa..bbe218753662 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1768,7 +1768,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	__skb_unlink(skb, &sk->sk_receive_queue);
 	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 	copied = recv_actor(sk, skb);
-	if (copied > 0) {
+	if (copied >= 0) {
 		seq += copied;
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			++seq;
-- 
2.34.1

