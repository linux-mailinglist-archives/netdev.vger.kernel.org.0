Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD155A765
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiFYFpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiFYFpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:45:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590BF36B52;
        Fri, 24 Jun 2022 22:45:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 68so4220749pgb.10;
        Fri, 24 Jun 2022 22:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/c8xzPLlU/kuZTvMUJd+d6TCe9y+y1G3nLnGGemPtI=;
        b=S8UTcS12CIgYxjHJhemLZGZPcSWDtp1Jx1dJjEBfcal6rPCcQQnjen7c3+hYhqm0Gv
         FpY1E+m4DhIW0piz+WszW6U0z0K/J7Y8Ko2MqqirgKg+A+p7soE8OPFZulU1pTIoShbJ
         IJcuyMxobCd9NwYvPzFKCxY8enfVbQCc0qLEXGIM+9jCecbpZFyJoxfTO3/Y+92H97Cb
         72FR2Ltn8iUYbru1+25e1HaRnj74Nuacan6LJDEPiPbtGe4rKlpj5L8EJePXK5MMl7yb
         TU7QVHiDR3HN4f4VQb8KiJJdcKBdQIT3q8U6gB4yzUt3K2rPi7fhAfnP3lbmZ8nU06en
         xmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/c8xzPLlU/kuZTvMUJd+d6TCe9y+y1G3nLnGGemPtI=;
        b=ziAKxXy79stpvo77/TNkZakvHRiPcuIy68TtUyxo1FecgG2gVYIDXOmewWCVcvrR7x
         qgtD+tXmnN7AI2zkfVskUn9A5y+nPFABhK6FOGYEVJIlz3EpviCNgXsiokYZl0pRSydD
         oi3U3tTcjmtxEuvz0zmfxj27Kmp16C65ULkhti9QaEwTf9HQ8svniK/sO/Ac2VLf/akd
         KnEgGV06N76BKhkqur5CiJlPMoFCB1K2LLGkaFXd7llZlYr8xHK1rEpB6TziUidNnRqT
         XbqDCSqJwv20434KuXR/tf5f/PfowXBM5+fQAcBqmj/1kCi/L3WhZxL+NZo2vNul1Z3z
         iY/g==
X-Gm-Message-State: AJIora9zPHaOfh+bpSIeiWHk+5hSnFu9DIh/yZxMsilBIgkOb9DB7Dst
        czWhu7O3xevhfJfVAsDgVPyUiICf+RqUwJ/R
X-Google-Smtp-Source: AGRyM1vx43oMsY8zwfCqj+Vv8tUHdqdzJ7dtqeCwBV17RcZRv7tkA9d3sLmWGixU8JHV5WQc+yXKyQ==
X-Received: by 2002:a62:4e45:0:b0:525:3b6c:25b7 with SMTP id c66-20020a624e45000000b005253b6c25b7mr2712208pfb.75.1656135930742;
        Fri, 24 Jun 2022 22:45:30 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id b205-20020a621bd6000000b0051bb1785286sm2690519pfb.167.2022.06.24.22.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 22:45:30 -0700 (PDT)
From:   zys.zljxml@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, pabeni@redhat.com,
        katrinzhou <katrinzhou@tencent.com>
Subject: [PATCH v2] ipv6/sit: fix ipip6_tunnel_get_prl when memory allocation fails
Date:   Sat, 25 Jun 2022 13:45:24 +0800
Message-Id: <20220625054524.2445867-1-zys.zljxml@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: katrinzhou <katrinzhou@tencent.com>

Fix an illegal copy_to_user() attempt when the system fails to
allocate memory for prl due to a lack of memory.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
---

Changes in v2:
- Move the position of label "out"

 net/ipv6/sit.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c20992..3330882c0f94 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -342,6 +340,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 	}
 
 	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -353,7 +352,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -362,7 +361,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 
-- 
2.27.0

