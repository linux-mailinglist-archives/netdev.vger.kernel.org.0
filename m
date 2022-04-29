Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E415150A8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378602AbiD2QYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379029AbiD2QYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:24:01 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C11CD64D
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:20:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so10937005pjb.5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ltO31cGke0CV9Ig5Y/sghhWU7CLEY/ynW5EXlnzLcM=;
        b=GsETNpB0po0QhAPBTPNvnruMjmEd7jyr8gYUhVUnPPt2KqS0m2K03lajmPkkFYXX6i
         nKWPIdifv8h7hdp3E8hEqpQFQiv9hGPqLAjHh5ByukKw3Y8Asj5iBrmeYbQ8n6MF7dr7
         uabUo9ejtoIPfd8EFLasysVSzx0NiTgZeytlLoMrUKweX7WhVbVmTRu1VNzhVJqglE/o
         EKzux818xglrs/ukl3ckTq/Xg2J2AgMe7WrPUo0b7Cl9MuDKCMjtT+AXxg4kx6TNhthy
         Dbmihi+yjFE/JpHoFgq4Q1kNl58cYKSwPUlNb+WayMsQZ8SiKf8f70SRPrkz/vBlvtEr
         Qyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ltO31cGke0CV9Ig5Y/sghhWU7CLEY/ynW5EXlnzLcM=;
        b=SfNLChP+xp99mjkkObI9ExxQVRro5alP81trbRvoxc2MX0zVpH1kv6yeSPk+kWpLpQ
         IX9MjinsvOVIcmZMkEpBf4NZAMVOAcYLBlkZ3zpv1O/kcru3V+C03qAoRxbO7XM1U2ce
         9VE8BQeD3nh5h8IlWhm1vnIMXjkLU42HVPte9HyM9kmQo5lr1ltWMU5Eg9/QCvZ1nV6y
         40BZHcD/b5Rb4t2fcZ8NxdAPG3mm8VE54WNBJExvwjZxSvmiLLLi6dff5iuNvVY9DTLb
         Mwjc2VQhnvXUg72pkplgB3zq98/XlSSlBtAQMiKtYGuAd8+cX6aj/9tdsk0umX6RKP8c
         25Lw==
X-Gm-Message-State: AOAM532ZIPlCjXVEzgHOUZfaD0KOVBlvtV/5V0Ac038CO+benjwwhJcJ
        He4nye433kW0RM++nm+Ha91a+Y8RoWw=
X-Google-Smtp-Source: ABdhPJyPqIdSdig8QwrViP8rXiuJBd2tVUTJPA5oSjzvTZcegwRdmV8NETYniinq01/myfECQUleeQ==
X-Received: by 2002:a17:90b:3b4f:b0:1d2:7117:d758 with SMTP id ot15-20020a17090b3b4f00b001d27117d758mr4744517pjb.105.1651249242003;
        Fri, 29 Apr 2022 09:20:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a265:137a:7be3:938f])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a670100b001d96bc27a57sm10974818pjj.54.2022.04.29.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 09:20:41 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net] mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()
Date:   Fri, 29 Apr 2022 09:20:36 -0700
Message-Id: <20220429162036.2226133-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
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

From: Eric Dumazet <edumazet@google.com>

Whenever RCU protected list replaces an object,
the pointer to the new object needs to be updated
_before_ the call to kfree_rcu() or call_rcu()

Also ip6_mc_msfilter() needs to update the pointer
before releasing the mc_lock mutex.

Note that linux-5.13 was supporting kfree_rcu(NULL, rcu),
so this fix does not need the conditional test I was
forced to use in the equivalent patch for IPv4.

Fixes: 882ba1f73c06 ("mld: convert ipv6_mc_socklist->sflist to RCU")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 909f937befd71fce194517d44cb9a4c5e2876360..7f695c39d9a8c4410e619b88add23e39f2beabae 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -460,10 +460,10 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 				   &sk->sk_omem_alloc);
-			kfree_rcu(psl, rcu);
 		}
+		rcu_assign_pointer(pmc->sflist, newpsl);
+		kfree_rcu(psl, rcu);
 		psl = newpsl;
-		rcu_assign_pointer(pmc->sflist, psl);
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -565,12 +565,12 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 			       psl->sl_count, psl->sl_addr, 0);
 		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 			   &sk->sk_omem_alloc);
-		kfree_rcu(psl, rcu);
 	} else {
 		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
 	}
-	mutex_unlock(&idev->mc_lock);
 	rcu_assign_pointer(pmc->sflist, newpsl);
+	mutex_unlock(&idev->mc_lock);
+	kfree_rcu(psl, rcu);
 	pmc->sfmode = gsf->gf_fmode;
 	err = 0;
 done:
-- 
2.36.0.464.gb9c8b46e94-goog

