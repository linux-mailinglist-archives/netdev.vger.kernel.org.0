Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349D154CE84
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355265AbiFOQUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354909AbiFOQU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:20:27 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F8E26F;
        Wed, 15 Jun 2022 09:20:26 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n197so9121926qke.1;
        Wed, 15 Jun 2022 09:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2p5T12Sr5Y7Jc+Rm7GQI0KwEROHnmY0n8erF/Ry4hZE=;
        b=Rj1VPoRrO1P4DrfUCSaX6hMsSL/3dSgruT7Yb3qAUwUAWOJ03w/Sqi9UK+XpSU2JeV
         k0X5YpThk5qpKkxj1ZU+hBtJgEGaT9+AsWq2XWjglFWW6RDVPXkoK0WbNsKObhBqWX7T
         ldL3sgLz7/SBi5YvNz3MZotFO0iGwpUEOovX9k3CqOyznZmM0fYcQLKm7Im6lkXsoygh
         y+y2dDofHpgQaLdM9uap3NCHSfyENKxYIGGexlrL6VdLEHVVVz+OKdko706yOjcUfDGF
         5+zvpK6UmHSnEc/f260HbWEQLNH3pm9wSi6z45uMqAt+bw1YGBqLB9tsfNv+37J7SPAH
         2kpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2p5T12Sr5Y7Jc+Rm7GQI0KwEROHnmY0n8erF/Ry4hZE=;
        b=HK2knS7BTeLW2zwgGcFtb3M7/Jgj6JVjU1z/UfdfDvaDm2FeuAAvaI3dvQxfONHOS1
         WT36ZC4E2UFLqmO12vfQrR4zvqrgJXO7dajHYlHzUeTk4LwEMKcD9T/Z6Z9HU5ejgED5
         uU+9RMxdMy9QkCezpWpdTTvuxREMSWB6/7KIw2bimv3t4OL3mBSThprNz7qscM/E9BHb
         3FtFth3Byi7eODYTGtahbdvX9Z3pU5ElNq3rg0YDQmZiurGHFxolbcykWSBqb68X+uHD
         c8utBlyp/pVRSnzaZAKNwGOoheGkPG/tNtjYj/UgMymjf8rOmnRfoImQHmPS10SKu6rA
         3HAg==
X-Gm-Message-State: AJIora8C7kyElo3Gtr5qRYODDYgrizGfRVH2cVuJmuIiaVNC/9v2LVLD
        Yido+8tWG9B5KJuUag6VzafwVd13SSQ=
X-Google-Smtp-Source: AGRyM1vEeG2o/DKpdD/N2i6QI0WSqWBGz6hxPpP5xe5zrraLBj5goGYEKe3xA4hr8iC46S+ZzvjWqw==
X-Received: by 2002:a05:620a:12ed:b0:6a6:b27e:a030 with SMTP id f13-20020a05620a12ed00b006a6b27ea030mr340424qkl.659.1655310025306;
        Wed, 15 Jun 2022 09:20:25 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a62b:b216:9d84:9f87])
        by smtp.gmail.com with ESMTPSA id az7-20020a05620a170700b006a69ee117b6sm11893918qkb.97.2022.06.15.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:20:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v4 3/4] skmsg: get rid of skb_clone()
Date:   Wed, 15 Jun 2022 09:20:13 -0700
Message-Id: <20220615162014.89193-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
References: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
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

With ->read_skb() now we have an entire skb dequeued from
receive queue, now we just need to grab an addtional refcnt
before passing its ownership to recv actors.

And we should not touch them any more, particularly for
skb->sk. Fortunately, skb->sk is already set for most of
the protocols except UDP where skb->sk has been stolen,
so we have to fix it up for UDP case.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 7 +------
 net/ipv4/udp.c   | 1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f7f63b7d990c..8b248d289c11 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1167,10 +1167,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
-	skb = skb_clone(skb, GFP_ATOMIC);
-	if (!skb)
-		return 0;
+	skb_get(skb);
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
@@ -1183,12 +1180,10 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	if (!prog)
 		prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb->sk = sk;
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
-		skb->sk = NULL;
 	}
 	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
 		len = 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 0a1e90b80e36..b09936ccf709 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1817,6 +1817,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			continue;
 		}
 
+		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.34.1

