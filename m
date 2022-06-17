Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F254F4E3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381580AbiFQKG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381589AbiFQKGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7413F6A00E;
        Fri, 17 Jun 2022 03:06:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e24so3612763pjt.0;
        Fri, 17 Jun 2022 03:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZSd1yz1StmlsSTd9BfuHe3OLRwFqoxjg2aovIcJmQPk=;
        b=nr4qFfoz7Jj0rGWJj6nHPKLrPzuliNtD+weNnfNBRV5HuxSaAmJdyixsurGap6UEES
         VwvyoHsAYr390nW/baAi13ZDJegHt+gbSEGdSrWQGy6TJuOTKVrOq7I2OaeAOvpn55ib
         d3sMP4wVs/Y9hptdCn7K/0RYSfNsXh1DheJTMujQxzJC8XzlB8+xYpbQJMiprlAYR2ys
         dacTUOF89daOHuVhPGvy1TDa6gyO/4vKNrJ3opAJkOc36V//1RWUbSZNFQAFfQlVKt9k
         x+IyaKgDhgIVUtLoEmZYvbbmhXA1Or7GyhDozsaje+Y9thRDSjvMFS6nxUdDGXScuBfe
         pb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZSd1yz1StmlsSTd9BfuHe3OLRwFqoxjg2aovIcJmQPk=;
        b=PjVBjyM9wa8jIkBJqeKe3g3hJVYns+c0td2iBZ4pK8Ye0/ud5B+u+er4OBf5qibadX
         AUxUNNFlShLXc48Ms0RB5+QD6FW2J6841GAiAotGlCj3u9V3nYNPM+ca7Op392LpAv/1
         OpTxp2L9GzqBy0CPzosN1UjA8icalEzgHbP1SjUOTHt80odV0XR93g5QVoipAAwb8t1s
         minKeboh1C7fospWr2GdIh1hxro+xV4rY1wMslLSi77k95l8Lz293gdCjxH9GJouyrDJ
         MQDt9X2aaqJQfj7DvzxDrp8+Bjkkb5QhAqHNKN5YvuHfKJJZ/rEqrRrX3iY4zDY9Hjpu
         L4EQ==
X-Gm-Message-State: AJIora9SXpxO+7gQibBOGHkms0E2BTym3ielKCq+b8fIDUoUmgoTG9ak
        Yw580xquOzHaWEQORlz1HXk=
X-Google-Smtp-Source: AGRyM1uc6PJPwDol3jfNMupP56Qua4mdaNKPTbLIj+TOVvUclQrHqFKvzd9/8ex69tcvWEypuPj47Q==
X-Received: by 2002:a17:90a:4402:b0:1ea:9d75:9941 with SMTP id s2-20020a17090a440200b001ea9d759941mr20757861pjg.187.1655460389902;
        Fri, 17 Jun 2022 03:06:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:29 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 8/8] net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()
Date:   Fri, 17 Jun 2022 18:05:14 +0800
Message-Id: <20220617100514.7230-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

The statistics for 'tp->linger2 < 0' in tcp_rcv_state_process() seems
more accurate to be LINUX_MIB_TCPABORTONLINGER.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ed55616bc2a0..cf4bc4b9be0c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6580,7 +6580,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
-			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONLINGER);
 			return 1;
 		}
 		if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
-- 
2.36.1

