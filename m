Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B207D445572
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 15:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhKDOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 10:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKDOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 10:42:11 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A644C061714;
        Thu,  4 Nov 2021 07:39:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 75so5594619pga.3;
        Thu, 04 Nov 2021 07:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Fqpqv/gt8hJwZaLefRk2NmyzIftP11u5WqVipkvWWM=;
        b=kKmip+WuEQPmSdqcwLtr8SvoyhEfmp7Z/lbB/xRpnyID2ATEuKEMcddLg6BcA3bGX0
         IOXzPXeHTuYsb/gtg1Klv1JG3PTPezJYDrxMFR3Uv3iZapHXdhyJelC2TTZj5mouLbm5
         dlILgGvqexSeXpqe2kqeYXlG17ZFdWoSO76lk86aF/UXMSuknbF7qBCmx4gkebYEQNJd
         Ha1q5JxnWIDpv83MqqIh23+rrCq2op3LZuDQkjrBFJS/nLyDOkOJNHg1txpKF76lWEmj
         GT2da605Z3DdkS10nF00MKT6FA2yxFhzb5oQgP55Qh3Kp6XolJjtFCfxaRbS5k1cJTsW
         LlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Fqpqv/gt8hJwZaLefRk2NmyzIftP11u5WqVipkvWWM=;
        b=NkQkuJ/qPWyRgvz6kHUmJXzgTksXUqMlKX3nhdg8V+zXVOMgBQEAg+3f907y+WXH88
         WOzLL2tid+DHrAl1odSdBkIo3L3QHdRbXMi1/+0Rtz55LV9JWZa5kMInTlBzVfwzRK5d
         G2XTfyztm6YR7WHvg0MHqT+5KxR7xyQMbgKXCSRNB/h3ZZLHp8Xje9B3zzDkyN7e4Fqu
         qCi4QAQIbxdC6MA2Re1YTdlUCifqJ/ouBPdXpF38xgVhc0JuIdtbraQPcjUJM6xD9o6Z
         vNYVs2TH7JsEIXCwCMN323cong7T4L2p3KVjHHzu1n6wdr6MIRUg5Enn/bFCr8G4NDR2
         3JRg==
X-Gm-Message-State: AOAM531w5Jcww2XLmCoCucoT1sKOm5fX1pcs+t9ilCYtWkH5TzaCG4wf
        qnzmxajPS8RJPgKSu+RdgRQ=
X-Google-Smtp-Source: ABdhPJyub1hxbVB14OQWmp15CGZ3guz9xpVZ0+gAnnRD8//ypmhJy1EPeN4ke9kLMsKgbqS4wOc45Q==
X-Received: by 2002:a62:3306:0:b0:480:f89c:c251 with SMTP id z6-20020a623306000000b00480f89cc251mr35487780pfz.74.1636036772687;
        Thu, 04 Nov 2021 07:39:32 -0700 (PDT)
Received: from localhost.localdomain ([171.224.180.34])
        by smtp.gmail.com with ESMTPSA id z24sm4427845pgu.54.2021.11.04.07.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 07:39:32 -0700 (PDT)
From:   Nghia Le <nghialm78@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     Nghia Le <nghialm78@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: [PATCH] ipv6: remove useless assignment to newinet in tcp_v6_syn_recv_sock()
Date:   Thu,  4 Nov 2021 21:37:40 +0700
Message-Id: <20211104143740.32446-1-nghialm78@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newinet value is initialized with inet_sk() in a block code to
handle sockets for the ETH_P_IP protocol. Along this code path,
newinet is never read. Thus, assignment to newinet is needless and
can be removed.

Signed-off-by: Nghia Le <nghialm78@gmail.com>
---
 net/ipv6/tcp_ipv6.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2cc9b0e53ad1..551fce49841d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1263,7 +1263,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
 
-		newinet = inet_sk(newsk);
 		newnp = tcp_inet6_sk(newsk);
 		newtp = tcp_sk(newsk);
 
-- 
2.25.1

