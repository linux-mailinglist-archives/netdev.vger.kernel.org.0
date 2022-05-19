Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1452CA2D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiESDQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiESDQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:16:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CC19299
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gg20so3996166pjb.1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DhMAH9oZeK2H9XQyPbZeKbPmsdMY9wxoMSIAbnfOe5s=;
        b=Ch922lE+CFPiOdcPzg1+mqzxaCX/UK7EOhQ5IfntoFOopkjx5NDz3JtvNcGBcmngcb
         Xc9LeZ6uwLvc2w7vaNdRBD20H/GcJV20vqW+tgMFATNgrbKQ+4AeieAhUw7lSdBR4zPa
         DCV/t25E2GweYzTkB5JseDHmqic+Ck9dnHhJF45AUycWU9cyAGMLBhhhdqH8pk2ckEky
         LTwTdde3QUsAl5E41/Uv8OjC8CwlDSzGK52Li844jN15XUbJ6H6u2xPDxLAROBP/Q6RN
         D2uJq67Z/Le2RmYW2WuCrOGvTExXA+cQB1RjO/fQzOk82VBbt9OAlzUMSaO0XQaohDmi
         OLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DhMAH9oZeK2H9XQyPbZeKbPmsdMY9wxoMSIAbnfOe5s=;
        b=WZkcaRsnuyIw+2U/9CxXgjr8Qob13Zgxu+HUkoFwqW0ydjY85ef3JnRClmmcAS83Yw
         QE4IjakPD/LuY5Lq+NY0LDjlNnj38qTAP8BAu02y1r9ndEkWhHyuUxmBdn/y/QQwrZLH
         DtluWvzmtY+ZVUq619PEZIDQRWRsbHdZ2EQXcsBzOOq/2Fu2E73hKi1JdM6gMHgKMy1B
         JGuwZ2Ac/Fk+lOVxJZMvyqOBYUEGIryMhrLMOJqg9jJoQhVu11F+5Twj/GPdXMSAlQ+N
         LlqzMhndbTsvfWlzwG30TKCCzPwEttBxA+7lGxzKjjqLLRKjr4ffsyvAQ1D84PmCzr11
         nvWA==
X-Gm-Message-State: AOAM530knqeOdDWN7j5gYAd3mNIAWrVDx2IJ7pXdcKVJjv+g2YAa9sEq
        7GCaykwT+8Z7jqB2nRFY5eKW8Y6pgh4=
X-Google-Smtp-Source: ABdhPJzCpEJvP9nscV//K2NaJPZxaHtFazXEH7ixjVCRJggzEZPS90DQDOJJviGRsCXHcAd3k3IKPQ==
X-Received: by 2002:a17:90a:2e83:b0:1da:3273:53ab with SMTP id r3-20020a17090a2e8300b001da327353abmr3445705pjd.14.1652930173127;
        Wed, 18 May 2022 20:16:13 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050dc7628133sm2833459pfg.13.2022.05.18.20.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:16:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 2/2] amt: fix memory leak for advertisement message
Date:   Thu, 19 May 2022 03:15:55 +0000
Message-Id: <20220519031555.3192-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220519031555.3192-1-ap420073@gmail.com>
References: <20220519031555.3192-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a gateway receives an advertisement message, it extracts relay
information and then it should be freed.
But the advertisement handler doesn't free it.
So, memory leak would occur.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - Update git log message.
 - Do not increase rx_dropped stats twice.

v2:
 - Separate patch.

 drivers/net/amt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2b4ce3869f08..de4ea518c793 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2698,9 +2698,8 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			if (amt_advertisement_handler(amt, skb))
-				amt->dev->stats.rx_dropped++;
-			goto out;
+			err = amt_advertisement_handler(amt, skb);
+			break;
 		case AMT_MSG_MULTICAST_DATA:
 			if (iph->saddr != amt->remote_ip) {
 				netdev_dbg(amt->dev, "Invalid Relay IP\n");
-- 
2.17.1

