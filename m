Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDD5131FC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345088AbiD1LEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345313AbiD1LEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:04:21 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA75A5E97;
        Thu, 28 Apr 2022 03:59:44 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so6212777wrg.12;
        Thu, 28 Apr 2022 03:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjZmQddY+Qa40STFRzTaM10MN4/OwVjfFMoJFMnoO/U=;
        b=KI0wVcHP8w3j4ZlynXgywnOvvU2ta9F5GDA09NQQw0742Mmz7Z04vyz7e7tkE4zsjT
         WdSXBoMR6uQISplTlOvIkBZdnsAIoBp3DYBcsm+C68YUDG4grnyaauS70k7/oa4W50Gk
         NKP3MoIYBng9d/kpU1/PE+oZ1v8oVNY+Q5QfmgqDbNl1c/5Unx2+v2N3OD4iA8vjTo52
         o1JDvQsb20S2/+KtDHhct8QbxE4htUj9705Nbg37mMq5rDAnCSDWMvjQl19hpfQAxZCk
         rJb1lOWfgcVsv03tHrFv6YIQshVrkElH9EcEuyABlvMPo8hD6R5MQTJvO6fJjQA2JcfJ
         1Ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjZmQddY+Qa40STFRzTaM10MN4/OwVjfFMoJFMnoO/U=;
        b=1d7RFdPScKwoepumPuHsdUYVjd3vfZpJ9IQpqLEJx0w332fsAApHezH0GUg1rWwUgw
         A+YogEcMNBfzqdT2lztezzKL0Z9e01ZJC8eht6G3pRXY35/yoE+/3LoNgSEUgOjxzuHR
         9NpXhye/Lk4tNsBGvW2vp00ckeYxdzUxAF6+kbfSHPq/Sc0nyfRXB+2dnKxNfTkhDMal
         w7FEOS3AT9+vAz+nqURVQjQM5ZLCw0t3Jv/ExYyKFQfGU1pykmHsiCIlAjaQtSnTIO/Q
         xPHr0C3WUXchLniSiCzgQquqb9j8m7jyadFFiLCFq95I/hO3e4vcfXMjcW3j1MXqnqqk
         nMIA==
X-Gm-Message-State: AOAM532PgaUmIjC86AkXQjFebH/cDyGNLpT3zis/KJTpwY0nfrjw0f1w
        Q7BpaU4TrSrSkQKySxpLXAW6xWlwjKw=
X-Google-Smtp-Source: ABdhPJxrrImJGZcfa7m7BIGoNvOgrswftTi8ZrjfXNbHxBi4g1WMVQfAoSaHDHgSIXduwu/cKPoGFg==
X-Received: by 2002:adf:e104:0:b0:206:109a:c90f with SMTP id t4-20020adfe104000000b00206109ac90fmr25718439wrz.259.1651143582963;
        Thu, 28 Apr 2022 03:59:42 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 5/5] ipv6: refactor ip6_finish_output2()
Date:   Thu, 28 Apr 2022 11:58:48 +0100
Message-Id: <bd02b2a2e1c8ba93f48cad589f0354635a65d6f1.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
References: <cover.1651141755.git.asml.silence@gmail.com>
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

Throw neigh checks in ip6_finish_output2() under a single slow path if,
so we don't have the overhead in the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index bda1d9f76f7e..afa5bd4ad167 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -119,19 +119,21 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	rcu_read_lock_bh();
 	nexthop = rt6_nexthop((struct rt6_info *)dst, daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
-	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
-	if (!IS_ERR(neigh)) {
-		sock_confirm_neigh(skb, neigh);
-		ret = neigh_output(neigh, skb, false);
-		rcu_read_unlock_bh();
-		return ret;
+
+	if (unlikely(IS_ERR_OR_NULL(neigh))) {
+		if (unlikely(!neigh))
+			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
+		if (IS_ERR(neigh)) {
+			rcu_read_unlock_bh();
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
+			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
+			return -EINVAL;
+		}
 	}
+	sock_confirm_neigh(skb, neigh);
+	ret = neigh_output(neigh, skb, false);
 	rcu_read_unlock_bh();
-
-	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
-	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
-	return -EINVAL;
+	return ret;
 }
 
 static int
-- 
2.36.0

