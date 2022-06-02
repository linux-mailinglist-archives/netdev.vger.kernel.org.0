Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCEF53B115
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiFBBVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiFBBVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:21:18 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215CD14086B;
        Wed,  1 Jun 2022 18:21:18 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id q15so1869090qvy.8;
        Wed, 01 Jun 2022 18:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2p5T12Sr5Y7Jc+Rm7GQI0KwEROHnmY0n8erF/Ry4hZE=;
        b=WyEBAzBs29SBdtqWDjbHbR6YHiqKRaGHsWP9xmxyczibpFipVF6WkKH/216dNKTR5b
         HiBod/PtHRxvXO/L+dy0m7a7s2kcecIU+KW6kYgHEFWpHmqEzTctwcBPVBmicfB2ekls
         rUANfb0Ra7/D2R9ueolMPuePFInkbhmjgUgwdAj2NBZJMoNE+mWtIi0XL5mgkwdm/PJe
         kdgGewP/wofqL5o25afHfWqzX3ygSeWoLkKjHarLiI872CWl18pk/kncAhwb3TDevDgP
         OYbiRUnozaX9y3v/aCbpxaHKmLiqpikZchJmJDKVYOYXI0l00TtVFXRlQDcAgSvlICOv
         bRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2p5T12Sr5Y7Jc+Rm7GQI0KwEROHnmY0n8erF/Ry4hZE=;
        b=SiKyNY5F3ABXMXPi6eeOyVhBRwa374t8v7qVQgmmYgCF8kVxyoN46qG2RKwbPSoHfI
         2zRtqm5Ck4FOYjxqHWpPYGo5U5NjAYeQbsL327NcrMzhnRP2kmgfbDUQohfX/nnXn0Kv
         a0tf93Z5wLOBVhG7NNXMP5+fLybR7ehq61sJ6iVhsD9ms3i25d9Mi0vs74xnrjKsC5sm
         HAng7DGFaHxDehW6+Sgj+N884XddV20hvqJFaQBLji14yYd54BI+dh8XAHbYBi2ks7YQ
         diWuNK9jWT+QIU2ebqHwvH1/nNYMwnLpHu+fK4c8Ec7dlegDe+BAOf9oBJcx5kRbZtRm
         Clcg==
X-Gm-Message-State: AOAM532qKeqrr7Q4WPcrvcMItMhrLSQLiH2Us+/DvWDFlOBVbNRb6Um0
        fMR54e0Xx9RDRQnl34O87c2MW3+3nAo=
X-Google-Smtp-Source: ABdhPJx+zdY6Mw1V9xbiJamePo+weyauMMYmpi8hsd4+vwESGABYnE3xAywVX0HzJxBSKcoEDQXTjw==
X-Received: by 2002:a05:6214:e47:b0:464:6235:ef0c with SMTP id o7-20020a0562140e4700b004646235ef0cmr8690277qvc.46.1654132877095;
        Wed, 01 Jun 2022 18:21:17 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a168:6dba:43b7:3240])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87304000000b002f39b99f670sm2077654qto.10.2022.06.01.18.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:21:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v3 3/4] skmsg: get rid of skb_clone()
Date:   Wed,  1 Jun 2022 18:21:04 -0700
Message-Id: <20220602012105.58853-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
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

