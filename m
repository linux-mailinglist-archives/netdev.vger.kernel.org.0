Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2205571B6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiFWElB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347402AbiFWEfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD2530F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3178a95ec78so129982287b3.4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=261UTc4ygE5ZNxBbiTD0X/wTjRF7aQkJ1aLKjWjIVn8=;
        b=GtvcgA6R4Zmr7fxvQzoFAZH92dPnJi89CavOfgZDxl4Fk5bCU6P8SdJ5ANlrAbID8+
         PZE2tRMGnsE60CDIVHMZudiAqVEi7EFiWJqnZWsF46amfaD/+8q8kjJFWJvdhYfa9T8u
         ZRWeb7r8f1B+KjpfoZ1VOSIrlCqN+Yx2RH4HBi5KIfs8/PnrL329BBjvhud8rCIGSZxO
         4jw4JOggSufJ90fI2+3t6nF6soSvGimCFgnnCxHQzD8KlvYdz9GN+2t1HyvlEZtVS6RY
         OZ5yY53gSf1FVaKVzjdNNrBVTQgRLcP9h9tiOn79/64G4pstLF3JtiAY2G84k5Jjsmxd
         iXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=261UTc4ygE5ZNxBbiTD0X/wTjRF7aQkJ1aLKjWjIVn8=;
        b=S4HVZjrQXvX+YE10LpHJHyt8mMml+4XJyX+SDFtoHSHkO1Udi4wee/G0G5gHnWOlxI
         WzzDIbMaGtk1TmXrQPWkIR/XNOhXSuE/zhHKwH8IUjlnhZSv9vAWe1DbpiytDm028CMM
         0Mlbylodtx2mc9F/4tlIs5Rpb/IsHuoaEf+TEk+571wac2ADdAKmE7BDMjM+sXsox63W
         yVE5AYg+vIfwyK/zveAoZUG5olVgi8uLysHvbt7Y2W+gYEzJ/GK4xskrtE0fdrTs++1Y
         mEucSLGX0np1KwTeNeXUHg6NNofmY2tAVpTun6Zptpt+9tsu0IwsxIHtIAGrIyptX4Wx
         1Nsg==
X-Gm-Message-State: AJIora+NVE+wOUuVyz7NBQW7F+RwaQs/nT8oBUB7iAqwMqYn7ZogCT3v
        0M6vzKSBLm+OO9aS1L3FhzwKpN4dxpOuqw==
X-Google-Smtp-Source: AGRyM1tfK78Fs1vnrVdxJEhzrvb9l97KcYMn62iw+8DFXSa6gbWNDygP95yplG+H8k5BmPLAzQYMHVetpd2ODw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:729:b0:669:1646:b04 with SMTP id
 l9-20020a056902072900b0066916460b04mr7693919ybt.107.1655958945509; Wed, 22
 Jun 2022 21:35:45 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:41 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-12-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 11/19] ip6mr: do not acquire mrt_lock in pim6_rcv()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu_read_lock() protection is more than enough.

vif_dev_read() supports either mrt_lock or rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a6d97952bf5306c245996c612107d0c851bbc822..fa6720377e82d732ccafa02b37cc28e0ab1cea07 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -559,12 +559,11 @@ static int pim6_rcv(struct sk_buff *skb)
 
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
 		goto drop;
-	reg_vif_num = mrt->mroute_reg_vif_num;
 
-	read_lock(&mrt_lock);
+	/* Pairs with WRITE_ONCE() in mif6_add()/mif6_delete() */
+	reg_vif_num = READ_ONCE(mrt->mroute_reg_vif_num);
 	if (reg_vif_num >= 0)
 		reg_dev = vif_dev_read(&mrt->vif_table[reg_vif_num]);
-	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
 		goto drop;
-- 
2.37.0.rc0.104.g0611611a94-goog

