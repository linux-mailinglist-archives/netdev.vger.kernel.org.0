Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46D7522A99
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiEKDzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241887AbiEKDzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:55:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EFD116
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:39 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so675216plg.5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Oj5fYgOyP9r6j4Oo2YFgfJ89J2j62xWeof0Jo9AY3w=;
        b=v9w+8OSo8NSVmDmBQbc8obXr4Wi1nhD7MIDl5mmowMNt72/kNMxqluqzW8jS3Kp7UB
         /7VISt6MIJKtVD9o0A7m6LzNO5Lqp9ow+x5B9kBGB7t7PtEZGsvXfcXksfmbNr4z51g2
         LTzKHBx8TvH8VwSw5qQxFSvqLW2aYGDGcyTCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Oj5fYgOyP9r6j4Oo2YFgfJ89J2j62xWeof0Jo9AY3w=;
        b=1+kBaCJRc8nAW/DCaYP2rGe/CGKjXDzF3heg2UpOB0ZuaqGDwJWLzionC0FnlfmUyo
         bBu4g3f9Ycfx7rlw8FTCRhvemO3riIyoTudiH9aiopziyMLs7fLZ+bNucCrmT7nUZCsi
         xypT3BlvWru+ehk5xoCNikEcbQTrXphfcso75JACNfbm4S/F4ePhgGuUOgcHdbDQ1fll
         PiwY4XskHmsp56J9gt1nBoHSD73wtjVcdJh2Nf5kArcjnEn3XGxAcv1s32r7u3P6+DC9
         MnZGZz/M9NsCNS8Q1UPiI55zjh1YCCvm0xT9Ng4uoOjh5dKvTNTY6CqqHJJBvu5O7Cfe
         +Etg==
X-Gm-Message-State: AOAM5323CPoA90WQ78iX/5vq4Eb7RLjyJsJeZZfX9AP5YkZ7+PqjBdIG
        V4y3wPbEa8cZ6fzpvbYS1Iaudmkw3euZSKsLlaB0X4gghYlvmj4nk8yiasZPYYWds6xv7bWVr4S
        CPn7+bbswyZaF9usHc47ZOSSvt2Wd2ofHCx/B741cqW9f06A0wtrD94au5NNmc0OEcW6W
X-Google-Smtp-Source: ABdhPJzDBQpUZk7W8Mq0NWHrteV9nx9UH/BVPj5fyK4gC7QCMNmi9ReuRK03KcV0ElJJJiZ8qW3FTA==
X-Received: by 2002:a17:902:8644:b0:153:9f01:2090 with SMTP id y4-20020a170902864400b001539f012090mr22917397plt.101.1652241338601;
        Tue, 10 May 2022 20:55:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0015e8d4eb1f7sm442789plh.65.2022.05.10.20.55.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 20:55:38 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next 6/6] net: unix: Add MSG_NTCOPY
Date:   Tue, 10 May 2022 20:54:27 -0700
Message-Id: <1652241268-46732-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new sendmsg flag, MSG_NTCOPY, which user programs can use to signal
to the kernel that data copied into the kernel during sendmsg should be
done so using nontemporal copies, if it is supported by the architecture.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/linux/socket.h |  1 +
 net/unix/af_unix.c     | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 12085c9..c9b10aa 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -318,6 +318,7 @@ struct ucred {
 					  * plain text and require encryption
 					  */
 
+#define MSG_NTCOPY	0x2000000	/* Use a non-temporal copy */
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e1dd9e9..ccbd643 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1907,7 +1907,11 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	skb_put(skb, len - data_len);
 	skb->data_len = data_len;
 	skb->len = len;
-	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, len);
+	if (msg->msg_flags & MSG_NTCOPY)
+		err = skb_copy_datagram_from_iter_nocache(skb, 0, &msg->msg_iter, len);
+	else
+		err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, len);
+
 	if (err)
 		goto out_free;
 
@@ -2167,7 +2171,12 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		skb_put(skb, size - data_len);
 		skb->data_len = data_len;
 		skb->len = size;
-		err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, size);
+
+		if (msg->msg_flags & MSG_NTCOPY)
+			err = skb_copy_datagram_from_iter_nocache(skb, 0, &msg->msg_iter, size);
+		else
+			err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, size);
+
 		if (err) {
 			kfree_skb(skb);
 			goto out_err;
-- 
2.7.4

