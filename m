Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3275141FE7E
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 00:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhJBWfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 18:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbhJBWf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 18:35:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C04C061714
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 15:33:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oj15-20020a17090b4d8f00b0019f8860d6e2so2618757pjb.5
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PzVNB2R4Ft9UsCNEZCdYlsZL6jzNshtK4wQXaAVFDAE=;
        b=QkQU+WtLqsKziAzBoya6hKIokIM2Y9xO3gC9rkOrIbFAyYw3A/YqcvxTq1yeojCZGf
         ApDI8Ot6y3/JE+GDdvFpvg4G8IcHlo+wGagRZnfe/FB/I/3yeWTKYCWle2kfbU4QDnRI
         UqJwVjkO9+a1sBKNfnCJ7yrn6WaWtpU+5oHZ6ijNXwsGrX6EgwrEVcXkUQBTfSRm0hgu
         RaRpmeQzLlRZEZvizmxG/JOdpQAIs7xBuu+CcopC7HgGstBc8FTQRodblgf/iTOBXIXu
         HluNcx2ZP1iYXupZBtP8fkJCRU1mZVcIcMHnKj31zUcKvaQNkTpNWNxjc1nWmJp2prwU
         jYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PzVNB2R4Ft9UsCNEZCdYlsZL6jzNshtK4wQXaAVFDAE=;
        b=tY2YRFb8AGL4SKlxvNakomChz5sVD4J/psqElmsI5uz+Gz4PEK8+ub29+YM+uMqDUq
         whJAQBla9CKvn8XTZjVivXbN4RI9kEt75MfEWxhiqWlp6cJCAXw8yWZ7hs9Oz8YIGzlj
         h1b0UYfCjV7pLnhmqf5i4Scog8GJ0QmwL/3A/Q/UX/TxcpLhfjB/2GmFHkmSzW/2qbvF
         QNhz9UN9lpr0TDbZ6c6QjlWHo5899/PNisnis5FuXEhFvVhiWhS69HErBG3EzgHT2bhB
         +zWAqgxehlw6tkdO8FGTae8WK3So1iBx9CoZ08itrxB7dwOHAYuLSOYAAhdMwO2FsfZy
         ieMA==
X-Gm-Message-State: AOAM5326mfwrboWwQ2Yu+DDZ9R0XmPKGGKmaQbvMEZPR9/owa/lgtTU2
        i3/85uzlEEqSzSqPUYLaqPy0CbMa3x8=
X-Google-Smtp-Source: ABdhPJzAPtYjMJrN6YrWfvhZ8s5llqhk/kHESKe7cMU6eCtBg/dV4ML2IlJijtMu5kvgMOziygaJqQ==
X-Received: by 2002:a17:902:c193:b0:13e:8e77:6c82 with SMTP id d19-20020a170902c19300b0013e8e776c82mr7783083pld.29.1633214022196;
        Sat, 02 Oct 2021 15:33:42 -0700 (PDT)
Received: from jsh.42seoul.kr ([121.135.181.61])
        by smtp.googlemail.com with ESMTPSA id z12sm9939431pge.16.2021.10.02.15.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 15:33:41 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: ipv6: fix use after free of struct seg6_pernet_data
Date:   Sat,  2 Oct 2021 22:33:32 +0000
Message-Id: <20211002223332.548350-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdata->tun_src should be freed before sdata is freed
because sdata->tun_src is allocated after sdata allocation.
So, kfree(sdata) and kfree(rcu_dereference_raw(sdata->tun_src)) are
changed code order.

Fixes: f04ed7d277e8 ("net: ipv6: check return value of rhashtable_init")

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---

 commit f04ed7d277e8
 ("net: ipv6: check return value of rhashtable_init")
 is not yet merged into net branch,
 so this patch is committed to net-next.

 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 65744f2d38da..5daa1c3ed83b 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -375,8 +375,8 @@ static int __net_init seg6_net_init(struct net *net)
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
 	if (seg6_hmac_net_init(net)) {
-		kfree(sdata);
 		kfree(rcu_dereference_raw(sdata->tun_src));
+		kfree(sdata);
 		return -ENOMEM;
 	};
 #endif
-- 
2.25.1

