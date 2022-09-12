Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5C15B5F6C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiILRgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiILRgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:36:07 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FA438475
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:36:03 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id o7so2889079qkj.10
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=++FcEJQ/W/MtAHDPHxofG8XpDMLkFGx/csr/y9/qQrQ=;
        b=dxyUEYEoE6j0fJzqpQJrcOtGMEQO5vKH/08jqF2IQ7L5zSeMQkZtiwGR8X1nPNGJub
         mryxt62WmGpRAJPgPzA3hptFsZSBOLXst/YifCEhudaCD6e6QZlBoQH5H1JQwAqzhz0E
         fymaAjfE2u2jWEGnZLC364auxy6h7ZQrvFPUI5c9/NKDG7SZ2zCQyXqPBqsLfNQOJjzI
         HwNyx69yVtCB0Czqd31eWfQGqze86IlxL2Q00vI3ukWa1Xd0fBiLmrVnAZfFLDz+nj5l
         umxoDHYQL+og9qwgkz1i0k0ca/2oJ5RMQfiLEbJu6Fq16XPVfryXDghYFYg6KknMo7sb
         TP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=++FcEJQ/W/MtAHDPHxofG8XpDMLkFGx/csr/y9/qQrQ=;
        b=XT5Kk7IFfSnMJwjqB1PvbIeiIkjDZWYC99NggK/Njr3itcx+1iEXmGX+bZyaVwfjso
         +q78zGU1pHbZiUdE96AMY39vW9ygWxcSgLTJs0e2Q1DB6GvV1x90X0dYqfb1v8EqX0Zu
         d7SbURp/50X66lGwhyqcNqHQWxBlAj33YWknaPRnBRsacHArkZ6ZKUQJY1RfBYZYJDdp
         KPyA8IiGTp+IvzPmzeWMTEs0VxDlgRHzo1OtkeQRbA3f+epq+agSnQZyEH4AvPBudYg1
         KZcm9kcUm1TO5PoknHVXja4oeE66/DXG3PPipHPK26QJurdwMPtqifLduCpNlqyH1+1Z
         BXoA==
X-Gm-Message-State: ACgBeo3jNj42klWDfPbIyIPFKiLecS0IOAbQUTeG84pMHJJh4TGr152I
        MZruIPch/jP83+/sdELKvvcouR0xeeA=
X-Google-Smtp-Source: AA6agR5IA8tgiuTWqWlzlxEAqol/7CtRLuVDKiXYKqxBQ0RsAPOqaykEfouAaTtLVzQxvXUF145F4g==
X-Received: by 2002:a37:de09:0:b0:6c9:cac5:ceb7 with SMTP id h9-20020a37de09000000b006c9cac5ceb7mr19639713qkj.693.1663004162481;
        Mon, 12 Sep 2022 10:36:02 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:db7a:361d:46fa:c628])
        by smtp.gmail.com with ESMTPSA id f5-20020a05622a1a0500b003445bb107basm7454889qtb.75.2022.09.12.10.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 10:36:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net] tcp: read multiple skbs in tcp_read_skb()
Date:   Mon, 12 Sep 2022 10:35:53 -0700
Message-Id: <20220912173553.235838-1-xiyou.wangcong@gmail.com>
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

Before we switched to ->read_skb(), ->read_sock() was passed with
desc.count=1, which technically indicates we only read one skb per
->sk_data_ready() call. However, for TCP, this is not true.

TCP at least has sk_rcvlowat which intentionally holds skb's in
receive queue until this watermark is reached. This means when
->sk_data_ready() is invoked there could be multiple skb's in the
queue, therefore we have to read multiple skbs in tcp_read_skb()
instead of one.

Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
Reported-by: Peilin Ye <peilin.ye@bytedance.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3488388eea5d..e373dde1f46f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1761,19 +1761,28 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
 
-	skb = tcp_recv_skb(sk, seq, &offset);
-	if (!skb)
-		return 0;
+	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+		u8 tcp_flags;
+		int used;
 
-	__skb_unlink(skb, &sk->sk_receive_queue);
-	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
-	copied = recv_actor(sk, skb);
-	if (copied >= 0) {
-		seq += copied;
-		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+		__skb_unlink(skb, &sk->sk_receive_queue);
+		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+		tcp_flags = TCP_SKB_CB(skb)->tcp_flags;
+		used = recv_actor(sk, skb);
+		consume_skb(skb);
+		if (used < 0) {
+			if (!copied)
+				copied = used;
+			break;
+		}
+		seq += used;
+		copied += used;
+
+		if (tcp_flags & TCPHDR_FIN) {
 			++seq;
+			break;
+		}
 	}
-	consume_skb(skb);
 	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
-- 
2.34.1

