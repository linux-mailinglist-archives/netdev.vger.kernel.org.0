Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E7520781
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiEIW0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiEIWZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:25:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1045A16A5EB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j6so13392047pfe.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=MxKE9FyARoH1pgPBTG5ltmhUw2/DUak4JNnMzE+N4QCEYa80Zi1/TnLWzQn3pLOT9H
         Qphcg5mVoxiPA25TqbfL4wD0difRw9mw/ns3aQGFqFbwiZseVUSsxIrs+rdWKtzPKOkc
         It8W0Y6ez/gcDBMHmeNAoUGNxamHOlScfZ4aP4zVF3YsJVrjZdxnl7QmArGRdwKz9HYb
         ob6R+k01G0W9V1v/156r9KG92V/wA9KSS6CxQNuOyawEspODep9aieG11xmRo80iWkbf
         wxL6bN47ZYbfmLXQ8YS3aPcixjSREWgPA3RmyOBlGzZICy8VRRs1vE0Ie/ZUP7IzQdgh
         +f/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=5PLRpl3yWZbUvNIwHeZyXCkC9rZLl0G7FysFrn299LFR96VNjROyeDdz/FyL1uQUdI
         qGthEgGJbZJUiZpvTH7jqWg+RentAkIujuruzaetKTtLUouebj9QVuyLlbJJw9sXzA2/
         3IhdPhCOlRcVOZZ5ORsFKeoZ0g4CyuwD6xoq+5Eji5kidb9IuUKb69Q6BWAt9gA4Tczr
         s7yminX5Y+hpii76GWuYQA83YfDGeGGqTJz1MhEWrAMqfcqET9s148u4svlR0Fg6bn/6
         PS8DAQ+WgCeuRZUqKq+MaMMwRuCFqaA/Uge7M2qASWEHeNXbYW5Nk4V92Mp6pFjCzVbR
         OHSg==
X-Gm-Message-State: AOAM532W6gmQIgDF+rG/DFPBadK8eBgyQ4Ae3mTW8+NHt8I7bzqmhqms
        dnF8poZ53zk4+c7kV0UOl2mGFDrkEp0=
X-Google-Smtp-Source: ABdhPJzP1DyJNoX78CMnDJqE5THIudx+J8ckiYCTUjVRsveal1P3jvrUDODNhMUXFkej1/wA+M1lyw==
X-Received: by 2002:a63:db17:0:b0:3c1:dc15:7a6e with SMTP id e23-20020a63db17000000b003c1dc157a6emr15069908pgg.107.1652134921593;
        Mon, 09 May 2022 15:22:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 04/13] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Mon,  9 May 2022 15:21:40 -0700
Message-Id: <20220509222149.1763877-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

hystart_ack_delay() had the assumption that a TSO packet
would not be bigger than GSO_MAX_SIZE.

This will no longer be true.

We should use sk->sk_gso_max_size instead.

This reduces chances of spurious Hystart ACK train detections.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b0918839bee7cf0264ec3bbcdfc1417daa86d197..68178e7280ce24c26a48e48a51518d759e4d1718 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,7 +372,7 @@ static void cubictcp_state(struct sock *sk, u8 new_state)
  * We apply another 100% factor because @rate is doubled at this point.
  * We cap the cushion to 1ms.
  */
-static u32 hystart_ack_delay(struct sock *sk)
+static u32 hystart_ack_delay(const struct sock *sk)
 {
 	unsigned long rate;
 
@@ -380,7 +380,7 @@ static u32 hystart_ack_delay(struct sock *sk)
 	if (!rate)
 		return 0;
 	return min_t(u64, USEC_PER_MSEC,
-		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+		     div64_ul((u64)sk->sk_gso_max_size * 4 * USEC_PER_SEC, rate));
 }
 
 static void hystart_update(struct sock *sk, u32 delay)
-- 
2.36.0.512.ge40c2bad7a-goog

