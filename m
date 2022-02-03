Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6496C4A7D8A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348885AbiBCBwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348890AbiBCBv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:51:56 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C380C06173D
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:51:56 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i30so900081pfk.8
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3kQZX+vCZwOhXWjeBN6cg2olIO+FpuLDjmuSQhrA2Ag=;
        b=V6ltMruJMnrAnGA48O7b3CejJThV9Lu0sGPCVYa2uXWSCS1V87eMlu9eyoEbXCYwJb
         uVPr5kidRtrv8hTH9MeQLYve+hRhcvIcJi8p4m+ch7m8ANl98SQhx04bKppd0TPEk++T
         TXJODElduXOuu1a3tNfn9/kwG6XJNMk2NpzQiYR1+Jcyg8RqCYyl9txN7mdSAfc3XGE6
         DaGmp9KZJ6rMg69R6qdvZ9npvmsLf2XOTrjUcaCvaVrxfWQ156SP323CZcEbvJgrEbNh
         1bte7MePN4bcxBxyt/WQmGJ8sb/nKGdtYfvjjgaEDZw5NaTVleXEjgk2iAMGMpwPW1KZ
         AdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kQZX+vCZwOhXWjeBN6cg2olIO+FpuLDjmuSQhrA2Ag=;
        b=WPljLGN5M0f9n4Jt8NpkgVG5ESygzjPkJPjmUErpS1kmilFa2SRCk+ONNjvFOZB5h1
         ge6dCS5hbyYA/RmA3HmKdeO7UPDyECQGZ1bafLusKuEcp9J2Jkbwq3Nt6+LOw+em9UhF
         9gWp5F8TC1eJ+vJxOB1PDPETMYwR64Pk13ACgIylHs/oj3TkFaWZZaghDSQJXqwL+sAW
         vbrbLAmy0uxXqJxpW9hUn9jSEK/96ttbMb8+496GEYMPLXeR7IQyvCSTqObtCK/M2LG1
         CW+eIqdsBXwehf61bTChpN2uhLxre/F7+PA5g+Bz+9Pl0Y84PPNSIcKoRenFuI4ThlOd
         mnTA==
X-Gm-Message-State: AOAM532ol3Y0J2BCITgCLxbNi//ffObhQA1wXE92wKZ+PRaNwdfkMzig
        cezALvs/swij6zYjAg8qo7o=
X-Google-Smtp-Source: ABdhPJxK8S3RDBskrcC0Y4g/xpCG2gAb6lh3+L3DgcY44ZFY7NmSwJy+HUDL2t3HaKfxSQko0ScGSw==
X-Received: by 2002:a65:4286:: with SMTP id j6mr14009357pgp.619.1643853115796;
        Wed, 02 Feb 2022 17:51:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:51:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/15] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Wed,  2 Feb 2022 17:51:28 -0800
Message-Id: <20220203015140.3022854-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 24d562dd62254d6e50dd08236f8967400d81e1ea..dfc9dc951b7404776b2246c38273fbadf03c39fd 100644
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
2.35.0.rc2.247.g8bbb082509-goog

