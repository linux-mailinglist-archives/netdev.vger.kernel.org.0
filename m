Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D392D5821BF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiG0IG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiG0IG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:06:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C49543E56;
        Wed, 27 Jul 2022 01:06:25 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w185so15476321pfb.4;
        Wed, 27 Jul 2022 01:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FwR1Y66QSR+w65P4mlADhcFcirFe738ibQ4qa+Us5c=;
        b=F2Vwyc6iaumjGZrbqNC6sk6MccKaAoNvW94Fx2lIB9yZmI3U6lnXpVO89ztimRPFIf
         V7NFB0YfO++E1vR2wawRulbNHoaFacQLnW7FhOM4H3bB2aUucc3oYAGjCjiBvvWa6y4p
         YzvC2Y3cbnx4AZsMXq8Du0qHh8j02nZIi7oMVqXBx+myxAKHFCV86xGsTCulHwnGoWrG
         GJr1MEwffxGKcGWH6Su73LzOjZqvQsrnzX2g6VB3Op7XZs618ddYDWTXdcAfCqNcxP7u
         PM/SKuKbHc1qJx4tylPXpQEZ/wcbD0wo9oL+gtpjPBpemTPpla4awQ3f12oq3b1I89lM
         1x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FwR1Y66QSR+w65P4mlADhcFcirFe738ibQ4qa+Us5c=;
        b=qQ+Vgdp4b+8Lozj1faWno5SKkJYpXqjkvefNbb5y1cvW2JQZHldTG5whggV/g7rSuO
         8fNZN2qtU10lxPBnBiP0Lt9PeyVTlVOtXDReuUSQLd/xSBBwooOZOW+wKD3cUIFdDR8E
         KLC2cqGQYuDA5jLJ2jDIef+UFFu2AxsPHPgL0+ef6eJd5yaqn/bD3tnX0O0owLytDnKW
         pm7t8CcTq9lvwtDwnpTNVn+L6G6kZABFueiuXEfhumNBepUPBq0eVS6IJPtaR48eA375
         n/3j6j+Zz2pB4+HPiKs9jhkBHkAKBLAlZzIU+WHnl0qZlqG3zi6trvgYcNP6RplLdjOh
         Qfzg==
X-Gm-Message-State: AJIora+hre/Ao0J4L1SYFIfwmwLJBOPDFA7PoOPEY2UrMVpgm7SedfyE
        Hq6375/h34iruN9szESoVpnm3ZHP8P1mRw==
X-Google-Smtp-Source: AGRyM1tR9GBaKDvPYl8+4PrtLr71EC7QJvJ7IYrr5CwYO9R6ucchrtBgPTVmXiwk4wmcOiDuEsgBtw==
X-Received: by 2002:a63:6aca:0:b0:419:cb1b:8b4f with SMTP id f193-20020a636aca000000b00419cb1b8b4fmr18024228pgc.92.1658909184887;
        Wed, 27 Jul 2022 01:06:24 -0700 (PDT)
Received: from localhost.localdomain ([129.227.148.126])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090a410400b001f2e20edd14sm990563pjf.45.2022.07.27.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 01:06:23 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.co.jp,
        richard_siegfried@systemli.org, joannelkoong@gmail.com,
        socketcan@hartkopp.net, gerrit@erg.abdn.ac.uk,
        tomasz@grobelny.oswiecenia.net
Cc:     dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
Date:   Wed, 27 Jul 2022 16:06:09 +0800
Message-Id: <20220727080609.26532-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

In the case of sk->dccps_qpolicy == DCCPQ_POLICY_PRIO, dccp_qpolicy_full
will drop a skb when qpolicy is full. And the lock in dccp_sendmsg is
released before sock_alloc_send_skb and then relocked after
sock_alloc_send_skb. The following conditions may lead dccp_qpolicy_push
to add skb to an already full sk_write_queue:

thread1--->lock
thread1--->dccp_qpolicy_full: queue is full. drop a skb
thread1--->unlock
thread2--->lock
thread2--->dccp_qpolicy_full: queue is not full. no need to drop.
thread2--->unlock
thread1--->lock
thread1--->dccp_qpolicy_push: add a skb. queue is full.
thread1--->unlock
thread2--->lock
thread2--->dccp_qpolicy_push: add a skb!
thread2--->unlock

Fix this by moving dccp_qpolicy_full.

Fixes: 871a2c16c21b ("dccp: Policy-based packet dequeueing infrastructure")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/dccp/proto.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index eb8e128e43e8..1a0193823c82 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -736,11 +736,6 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 
-	if (dccp_qpolicy_full(sk)) {
-		rc = -EAGAIN;
-		goto out_release;
-	}
-
 	timeo = sock_sndtimeo(sk, noblock);
 
 	/*
@@ -773,6 +768,11 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (rc != 0)
 		goto out_discard;
 
+	if (dccp_qpolicy_full(sk)) {
+		rc = -EAGAIN;
+		goto out_discard;
+	}
+
 	dccp_qpolicy_push(sk, skb);
 	/*
 	 * The xmit_timer is set if the TX CCID is rate-based and will expire
-- 
2.25.1

