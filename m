Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0161E5A6CA3
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiH3S5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiH3S5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:57:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E4577541
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j9-20020a17090a3e0900b001fd9568b117so9103969pjc.3
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oFAjsfB8BS8tX9OoopuJddVkztzEvBj6H74armu4PhA=;
        b=neBo0cR6WlsZ/cIz05lh4J7S2cDq5Y0RRz6D24axDCAx0mXi8599WXtD5ByuRLI4/i
         21Z2Zg+Kzn8R5/qhd1Z9ICeDpVaDzab9j7o/pfv0iG7kqLpPCgVH8VAl7Npo2O8D6oxs
         63tq4c+YTrqz1o2ReVy1/oaDqMAtFly+waEGoWlPbQ1/bN4wOqTSAzzBAsjDa1jm3/pM
         1TmQ90xRdMvbpF+g6hNdGjTJKmwMQ3q+FxU2hTHAw05103lN1CjGeChzhCiI9uWnw4gf
         vWMqxgCnlZ4Lk08/3W/shF9TDrZhUa/uL7GlNbiCU9CFVfdyiKkRLnqEkn6OE8DXgqR6
         xxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oFAjsfB8BS8tX9OoopuJddVkztzEvBj6H74armu4PhA=;
        b=J3aQhi4UkIhI6SyKgRUbd/fY847GOS7O/fDVhSZ9H9S3tOuqeihDVVuYOSGG+AMMN4
         +IyAmd3h8jN52Xx35Jx8CI6rZ1UvM6TjlXyLh1Hc5TZAfD0VJ6wz/akiwi2EJeD3zfTe
         U9JZdtSTnkwWZ8OjfDbwMpOuZX0E6pvtAAjn9WTyR3/xkaUJLc9z6nQ2IOa4SCk0RHDY
         KAmoRGqUExs0/KPBayV6o3O2FJF1Q3NXpUNRIldWgC9D9WPx248BLjU1NBU98JiwntkR
         16G+b4jfWCt96VTQdAEwS10umtdosWCMLb8LJ771Jb6MOdbAzyZTbzoMZV1wYinAyDI3
         aLug==
X-Gm-Message-State: ACgBeo3TwgPQU5WI663jTvWwGE1Lha0fn2EaAtYqzLm6g6T0OJwz39Or
        Xw6FeHXzbcXISd0eygqbpcg=
X-Google-Smtp-Source: AA6agR71dmfZSofTAu4BO8oxaaexjdQw1i7Nuk5UVvx3fwRbQgjccNDl2J3WsHAnJeWzfRYnwshm/Q==
X-Received: by 2002:a17:90a:7f89:b0:1fa:ad33:7289 with SMTP id m9-20020a17090a7f8900b001faad337289mr24669995pjl.173.1661885822775;
        Tue, 30 Aug 2022 11:57:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6f37:1040:8972:152e])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b00173164792aasm10085449pln.127.2022.08.30.11.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:57:02 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] tcp: annotate data-race around challenge_timestamp
Date:   Tue, 30 Aug 2022 11:56:55 -0700
Message-Id: <20220830185656.268523-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220830185656.268523-1-eric.dumazet@gmail.com>
References: <20220830185656.268523-1-eric.dumazet@gmail.com>
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

challenge_timestamp can be read an written by concurrent threads.

This was expected, but we need to annotate the race to avoid potential issues.

Following patch moves challenge_timestamp and challenge_count
to per-netns storage to provide better isolation.

Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ab5f0ea166f1a0535e299a9051406b5e2895f1f0..c184e15397a28ccfbac142ff0f1d05d555623147 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3629,11 +3629,11 @@ static void tcp_send_challenge_ack(struct sock *sk)
 
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
-	if (now != challenge_timestamp) {
+	if (now != READ_ONCE(challenge_timestamp)) {
 		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
-		challenge_timestamp = now;
+		WRITE_ONCE(challenge_timestamp, now);
 		WRITE_ONCE(challenge_count, half + prandom_u32_max(ack_limit));
 	}
 	count = READ_ONCE(challenge_count);
-- 
2.37.2.672.g94769d06f0-goog

