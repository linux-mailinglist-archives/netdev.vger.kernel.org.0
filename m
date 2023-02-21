Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BA069DE64
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjBULEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjBULEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:04:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC37025E19;
        Tue, 21 Feb 2023 03:04:05 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n5so2429969pfv.11;
        Tue, 21 Feb 2023 03:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nHPFydhBkhM2PshUYGS/haIdEexuBTK4GOmlepQ4TI4=;
        b=dSqO0PuUqfZpp9vDG0LYJ3ZqGUquoJQ0gYyDLnDQ4D8BhJrQKBBBi1Nq3ItpGYkV2P
         JekWR9fnN/PBcDVsX766YcRwfnvjZb95YqujLsiutWlxS18jlBX2I9L5PsyypG6I5aSi
         pjPgwEZMc3nAzhhzwskGt8bb1TGJ2khNedYvx8RHLh7n063VRNArz5JSOgxW+R2kUCff
         2LnLqfLjOOH81SerQHfqmqmyMbsXUBEUjjkbGvTFqOQgzmh3Kxg7R1QJORNcO/F7I/xX
         eCY/DJNlsVy8cBnvoSCZAKz0cqKV/YnCLKEo/jVcrGoRHmpDsQ2YOheelHylg/IF/IVv
         wtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHPFydhBkhM2PshUYGS/haIdEexuBTK4GOmlepQ4TI4=;
        b=KyAe9GntkBOkGF8B14ykhITzUVZ7D1iQTm+uaBMdsTLnynyfMZCuMLS7H4jOOXH7Sc
         CMnagZ77aq1GMCeGOIM9u/W2+ROvgMUpKX8SjcFpeeLG6EZAkEv1lqX0g85vKxgBMmdS
         shW6EFzlbnLMIx55oR8LrMOVgEdPpjLQKfopIdxbRwGtjFVWnkshcS/4I952cMmzVb89
         PzzFuvcD9GYjph/wK7Yr2zf3gBMqt6k9B8DNv/5t2Rlap7Tb+8Vxvvqzmm3rcfldPyFH
         cCLZzRR3qdxzstprnVZ237fqx2ysvelRf0rb5b2rxCLHuLX98YVHA20T5Rb1gJkMG3/N
         Q7tw==
X-Gm-Message-State: AO0yUKVWdUR4+qHlS6i0UT3HvfpPlDxDsii63xEi4frVVi8pu/HOrdF5
        a5VBnfRh5tpdOznewj++QKzimFo9B9IChg==
X-Google-Smtp-Source: AK7set9lPVMP1XookXozPeeIDJ6x090vTcFspIF1Gs5HG0kWW4p7gle+nRbnGVS9opLCB1I19W2L7g==
X-Received: by 2002:a05:6a00:1786:b0:5a9:d0e6:6a85 with SMTP id s6-20020a056a00178600b005a9d0e66a85mr4943518pfg.7.1676977445194;
        Tue, 21 Feb 2023 03:04:05 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id e15-20020aa78c4f000000b005aa80fe8be7sm7505193pfd.67.2023.02.21.03.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:04:04 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net] udp: fix memory schedule error
Date:   Tue, 21 Feb 2023 19:03:44 +0800
Message-Id: <20230221110344.82818-1-kerneljasonxing@gmail.com>
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

Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
and sk_rmem_schedule() errors"):

"If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
we want to allocate 1 byte more (rounded up to one page),
instead of 150001"

After applied this patch, we could avoid receive path scheduling
extra amount of memory.

Fixes: f970bd9e3a06 ("udp: implement memory accounting helpers")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/ipv4/udp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9592fe3e444a..a13f622cfa36 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1567,16 +1567,16 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);
-	if (size >= sk->sk_forward_alloc) {
-		amt = sk_mem_pages(size);
-		delta = amt << PAGE_SHIFT;
+	if (size > sk->sk_forward_alloc) {
+		delta = size - sk->sk_forward_alloc;
+		amt = sk_mem_pages(delta);
 		if (!__sk_mem_raise_allocated(sk, delta, amt, SK_MEM_RECV)) {
 			err = -ENOBUFS;
 			spin_unlock(&list->lock);
 			goto uncharge_drop;
 		}
 
-		sk->sk_forward_alloc += delta;
+		sk->sk_forward_alloc += amt << PAGE_SHIFT;
 	}
 
 	sk->sk_forward_alloc -= size;
-- 
2.37.3

