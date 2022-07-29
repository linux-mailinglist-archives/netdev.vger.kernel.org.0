Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC984584F4C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiG2LAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiG2LAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:00:42 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41102A408;
        Fri, 29 Jul 2022 04:00:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k79so100675pfd.8;
        Fri, 29 Jul 2022 04:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=+/iPCd/Fzs9lGqRmUEuLJiLQfcVAsWgZMz3tPz5hhRQ=;
        b=MHjjq2LT4+2Lau6NVZpwhf+0AWyWdR3H0vDiDs5DI2gcp1Na9tGHe1Tw0A9ViBHDXA
         PS+V7i3Y3M5fER+mEqpzZu4ReChmqYPMzQ1+geknjkpXjnbxhNTkmiGp7SZZUoui8/SX
         eRuITytkPVXC1DXYw6mEkAXE4tXgc9aPYEkleZh2aE21bmSDrvLNPsW6zhSc6kmjdyrY
         MKYHi1WAnAF3p73oEncEY7g1FtkkvTyFL4PvWlrA6LbvXoJL1S4h/gBPUsmhr6BNhpPB
         8Dc0IZO/6lHkj/IYSMkanvuSYRNQ3vBEf8IiphFoYxMPZTvBCcrUCTQfqkh8JuV26A8T
         Jp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=+/iPCd/Fzs9lGqRmUEuLJiLQfcVAsWgZMz3tPz5hhRQ=;
        b=qlZhBHbAxLYdqlY9DtNGtaRsXE1J2zCAe78ndKLiVgEMloNL+Xnq4VrZqpT+Fqaxs2
         yIBkJMfk1mJl3CQv4zMRXwpMi5VyGlT10cM6UWcjEZfzXBPpddbVNf8OwNlY/OzRsvz5
         QbK20OQC247Uz7RDx1/DAPRJXt5rnsit1eIJ53ptLVHm4ZR3nENHojFtc45IJQfYsH9J
         QRaMn429YDZbl2MiSq+hoZc8YQq4hEB7HiE1Pfl8Ej+Z9NPZApGM8uamzPHCBAAEK+2U
         V91Skd4P63Awc7tA8K9mxuVe750RZ8+Ael3lPcq7ycZmVK/WddADM1K1bB/6lh0s8Hkh
         +k5Q==
X-Gm-Message-State: AJIora/XmYwZeFAkZ8Fjx7wGuSqw0cD7QGDmRTj+yY8ZYjlrH9lwQ9Ka
        bIFm2YY5TTwK7kNpygf0agI=
X-Google-Smtp-Source: AGRyM1tEhNVtRjJtquaYNWRwmabmY/N9Fcuj5cMr0H+F/vXVpXqWTNRTC801SAun88tZtNfOW2Vtmw==
X-Received: by 2002:a65:6398:0:b0:415:7d00:c1de with SMTP id h24-20020a656398000000b004157d00c1demr2546776pgv.610.1659092440239;
        Fri, 29 Jul 2022 04:00:40 -0700 (PDT)
Received: from localhost.localdomain ([129.227.148.126])
        by smtp.gmail.com with ESMTPSA id l1-20020a170902ec0100b0016d338160d6sm3201118pld.155.2022.07.29.04.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 04:00:39 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.co.jp, joannelkoong@gmail.com,
        richard_siegfried@systemli.org, socketcan@hartkopp.net,
        ian.mcdonald@jandi.co.nz, acme@mandriva.com, gerrit@erg.abdn.ac.uk
Cc:     dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
Date:   Fri, 29 Jul 2022 19:00:27 +0800
Message-Id: <20220729110027.40569-1-hbh25y@gmail.com>
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

Fixes: b1308dc015eb ("[DCCP]: Set TX Queue Length Bounds via Sysctl")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: 
1. call dccp_qpolicy_full first after relocking.
2. change "Fixes:" tag.

 net/dccp/proto.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index eb8e128e43e8..e13641c65f88 100644
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
@@ -759,6 +754,11 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (skb == NULL)
 		goto out_release;
 
+	if (dccp_qpolicy_full(sk)) {
+		rc = -EAGAIN;
+		goto out_discard;
+	}
+
 	if (sk->sk_state == DCCP_CLOSED) {
 		rc = -ENOTCONN;
 		goto out_discard;
-- 
2.25.1

