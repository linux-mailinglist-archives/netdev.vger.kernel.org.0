Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E6751DC2A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389422AbiEFPfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443058AbiEFPfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:15 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DEA6EC5A
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:06 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so3893640pgc.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=N8SjvDENK8SjrJCHxFsP3T30ghh+vtcnhhF0urPrC+SuJgUByt5nq9ZfZqlSFjW64b
         tl3iUdsjrvyREKnl06PzwtI+kaP7lwas7rBnMiSbT3uwAi3AKzGYvXsq0/Q7vVY9SbsY
         5cWyki7K9e8G51WWxFkrmSBDAkMjzC6sI6xCDSXw+atR8vuDl1mg+vpOKFZZ4+PnXd7q
         CFuva4NekKSyyYK1fQp+sXAIeKtV9QR/jLdTaOBTDgWl83oYXwFQqCU186crj94pWLbC
         dH5jUIw7sIAPzGUwb+4zuxIGuT3wgNmqTOA4N4JBKNodeCq27WvVtbLtUqI9rRzso0+Z
         6eRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=B81pZLwP6LSxF6l4EJ1TmoPGvYYOn9QIMx/Zm7rEQIjWGXP3OXpfm0UZes1sJVy2yK
         J/exX+uZB0Ss33zpkPt/9pnZ+FTYq5syZkWMZgxqq45WgRmVnsjHeyDl1sE3jDioCROK
         loxSy7r14TPyd0X726frNxtifY8Svos1EiNcMb63m3hvjo5gJGNmButEyHPezOR/WQxe
         xXAh8WJR9yECdmxdlpWZQ0g5CR17jp3nhU6CtmeFDwq7dmfs1iNCrTi8kyhpG3/+THut
         WO93FKpowWH6u3ukq9XtjFKVhb2eo9MEfrj9CDqV/Sgpv1hK7Cd6ZxkBsxe5KaWk8xfe
         wuuQ==
X-Gm-Message-State: AOAM532wgWH/wZfTN1wqjvtWWNF8hjJsK7o4bvyuxOgkYbUexUWs1bDm
        OswK9Uj7h28T7c/f9vlL2x8=
X-Google-Smtp-Source: ABdhPJy0KNTyX5eih2R0lEhYwmH5XE5Hr5GOfqM+KlTdA7s2l43SHAoOI7qr0IbqsRN2oU2B0oN7+A==
X-Received: by 2002:a63:1b1f:0:b0:3c1:bb2a:3afb with SMTP id b31-20020a631b1f000000b003c1bb2a3afbmr3175752pgb.596.1651851066510;
        Fri, 06 May 2022 08:31:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 03/12] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Fri,  6 May 2022 08:30:39 -0700
Message-Id: <20220506153048.3695721-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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

