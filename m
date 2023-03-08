Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114126AFCC4
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjCHCNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHCNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:13:18 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CEF84F46;
        Tue,  7 Mar 2023 18:13:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h8so16283959plf.10;
        Tue, 07 Mar 2023 18:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678241596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WUi/jbYtXBOmmnZErU5v1Etksb+Orfwsi2v3q122Dds=;
        b=antxJzNYxwpmrrIofTxl7WnzRWnd3JangQVBLAbjPacqvRH8OoDyVIfMQ1KmzKlu3Y
         TI3or5HSTobP9+Xiw4M/FaypOtbX6Vtpd1ed1VsAZLZ8wMRx4cTyjcwpXFfZ8i+qg2M7
         72FUTHh+RT0lkV5IurRLWBdNSGTGcu0aX2lKNNZKnAvwXf8sZuX6yHH7GfLxdhlYjxqU
         wDB9Zdx5mKbPMzhKYFzgl995WHSWrMlvZtO5Sh3DmiEO4TaQeQPa8f9UTjDFEIWj5aWM
         AUM21aP1HJkaVBxyWDUKGwMaREbijqWC+OtIvsFT0k9PBRQ8fbUWXuD9D4u8ite9ww8b
         DQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678241596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUi/jbYtXBOmmnZErU5v1Etksb+Orfwsi2v3q122Dds=;
        b=tOnhchhYJqBfZOQDjV8I4QykHQfiBFqQTH+ZfV8SuaT70oO13Ch2Yrh9RxDXNMeDKJ
         /YRx20MI9ryAm6XsYHmTDTwu5uoMlvnxw6bXu4j/CEcx4HGsBgDNJfIfQezPbp7w85mS
         qyAdUQlXrM19xLnIAzdKLtYWltXVDjs6L68qrrQD2Xg1nyfjt8iFMtiNy4/UfLh7WWB5
         G4baqNZUU2KJ3FBavZVW1RvfWhqCHdieGZXMgJTntJ/Pg+BPC2cBa3IM4AGNj4W0+9Of
         /DR8C0OT30w+87klrJMa0u3d6m29NViEfxHRiXS0/LEsc2ZTrR3V7hxhd6uPLA5ywPWF
         +szw==
X-Gm-Message-State: AO0yUKUfit+hWwNHWnhSinN0z9ubrsJWQ6GkjlMzY2HLk4yIiXaw0L52
        RIjLvzE+jpzOoJ7uRbaR6wM=
X-Google-Smtp-Source: AK7set/OQB7Yy/JOEV6yCQmOoRVo9Usg/OnzO5tpYPfLJSgAk4oISQSImkLWH87e/7+k3sjYSY2gFA==
X-Received: by 2002:a05:6a20:8407:b0:cc:eb3b:56e9 with SMTP id c7-20020a056a20840700b000cceb3b56e9mr22961764pzd.1.1678241596431;
        Tue, 07 Mar 2023 18:13:16 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id a22-20020a62bd16000000b00592eb6f239fsm8337785pff.40.2023.03.07.18.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 18:13:16 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     simon.horman@corigine.com, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v4 net-next] udp: introduce __sk_mem_schedule() usage
Date:   Wed,  8 Mar 2023 10:11:53 +0800
Message-Id: <20230308021153.99777-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Keep the accounting schema consistent across different protocols
with __sk_mem_schedule(). Besides, it adjusts a little bit on how
to calculate forward allocated memory compared to before. After
applied this patch, we could avoid receive path scheduling extra
amount of memory.

Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxing@gmail.com/
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v4:
1) Move one statement outside of the helper suggested by Paolo Abeni

v3:
1) get rid of inline suggested by Simon Horman

v2:
1) change the title and body message
2) use __sk_mem_schedule() instead suggested by Paolo Abeni
---
 net/ipv4/udp.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..dc8feb54d835 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1531,10 +1531,21 @@ static void busylock_release(spinlock_t *busy)
 		spin_unlock(busy);
 }
 
+static int udp_rmem_schedule(struct sock *sk, int size)
+{
+	int delta;
+
+	delta = size - sk->sk_forward_alloc;
+	if (delta > 0 && !__sk_mem_schedule(sk, delta, SK_MEM_RECV))
+		return -ENOBUFS;
+
+	return 0;
+}
+
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff_head *list = &sk->sk_receive_queue;
-	int rmem, delta, amt, err = -ENOMEM;
+	int rmem, err = -ENOMEM;
 	spinlock_t *busy = NULL;
 	int size;
 
@@ -1567,16 +1578,10 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);
-	if (size >= sk->sk_forward_alloc) {
-		amt = sk_mem_pages(size);
-		delta = amt << PAGE_SHIFT;
-		if (!__sk_mem_raise_allocated(sk, delta, amt, SK_MEM_RECV)) {
-			err = -ENOBUFS;
-			spin_unlock(&list->lock);
-			goto uncharge_drop;
-		}
-
-		sk->sk_forward_alloc += delta;
+	err = udp_rmem_schedule(sk, size);
+	if (err) {
+		spin_unlock(&list->lock);
+		goto uncharge_drop;
 	}
 
 	sk->sk_forward_alloc -= size;
-- 
2.37.3

