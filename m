Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5365571CE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiFWEk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347358AbiFWEfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D0030F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d67-20020a251d46000000b006694b8ea9f2so6406705ybd.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RObd3TiRkqvkoKMe+QwcB26i+/ARD+OA3IafA9Z7HpI=;
        b=BK7w3uLpZyehLpi5ouPL0wVHrSbaSEV8AYwkgbNMQA/Iahw3oTXQLQO7zcyZ5nUMve
         xIPehQIXm/c4/RpyEzSCB0f2Zz1bgwNBOisxzOfw8l37gF5Zk/P1fJ/Scw/XYBjIi7ya
         1+BNLuuz8Z3EU6QbnnWLpVRjIx5PPhlKpcLUBlG2mbj1PcbEf5U6Jz3jENztPdw716yq
         D6RXnC7HKaJUfbkelWf2OlJ9uAqUmCB/kyBXD0yCDzR8nTFwxNKFDxlIHUHzSyvXmQ3L
         0ahJat0PvQiTnBjlDS00DbX/LNmVFx/mfodi6+bQAp8oarnH//asQGgs+6iNA2V9qkj1
         cUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RObd3TiRkqvkoKMe+QwcB26i+/ARD+OA3IafA9Z7HpI=;
        b=P+w6l+QsxcFFIH3F4ZQIP39OTnsRkRJ1MzzbLYo0lvp/wEeQl1zWSuPIWb0p2ZMhsK
         AEVxvnFFrk4mpPgy+HdslXStd9AJuYQxwAFzuA2aK8lKzD1tNyOvS+ohhVT7NSmHS0w1
         pjkj1dM6rZQFbaDKT/MZlKgp3+pTlwi5gFk+YIl0bnVgrHWwVuJf6rcGUTJyJ1BGWyU1
         +WaL7OyiPJpC/hlhXYNAo8fO3GM54bsQxjzQyd3YrNiBmsCrZ38RbXwcqhTj+stNFUN6
         IbSA8vAMF4GdDWvv/MeC3cN2u1gk9qRVDpLMiLHoaJHyZWMHX8flxYf9PAoFuXC2LQS5
         bYrw==
X-Gm-Message-State: AJIora+p2IpBsh9In0cTJ5wZ6vGh2qVrpLZ2yUxjJxIAJxb4dDz+qbA9
        jp+SyRyCwLxzcA/GOaxTA4sgRlAXqXl3EQ==
X-Google-Smtp-Source: AGRyM1v35qz2db7X2RVAt2R27DDIhZkj8V8dv2+aGRvpJM9PvslRC12UM1a9xPi/Y4cr3NYYJHZ1z2ATqP8JSg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:c646:0:b0:669:b341:a595 with SMTP id
 k67-20020a25c646000000b00669b341a595mr298538ybf.304.1655958933558; Wed, 22
 Jun 2022 21:35:33 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:39 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-10-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 09/19] ipmr: do not acquire mrt_lock in ipmr_get_route()
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

mr_fill_mroute() uses standard rcu_read_unlock(),
no need to grab mrt_lock anymore.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b0f2e6d79d62273c8c2682f28cb45fe5ec3df6f3..69ccd3d7c655a53d3cf1ac9104b9da94213416f6 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2289,9 +2289,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		return err;
 	}
 
-	read_lock(&mrt_lock);
 	err = mr_fill_mroute(mrt, skb, &cache->_c, rtm);
-	read_unlock(&mrt_lock);
 	rcu_read_unlock();
 	return err;
 }
-- 
2.37.0.rc0.104.g0611611a94-goog

