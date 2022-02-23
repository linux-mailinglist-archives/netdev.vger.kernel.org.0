Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40984C1291
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbiBWMSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240383AbiBWMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:17:52 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E789F51E5C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:17:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id j17so12590537wrc.0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3EvTLjCE04FQaQLZNcKs5KtscjgLIzQ7nMdfZDgRHBM=;
        b=eTr+NNbH39z8mQh66PwnzEUUT5N8bFmssFPlh6IO8x8ZybrDQBfgFTqUfuKABanS9M
         kTWBq8Itgk+MnG0UgtkwMgtYyaI4O4pAwj/g7nujwzoxOxTaKtFrVAdMeWMBcrKYld69
         uSbvfBKa2zZo8RjwkJ2kvy9zGtH3KE6sM8Qs4E2vnTmGDOmiQvWBU1fCSkpm9XLoiRUE
         rUT0i7z3Hi09hjlC84hMb2dkQ0a1I0l6CkHDruUdjeGddOeIAd7ucNd2uBvKC/rPEILv
         3OAZgNUr9UwwDTN+aEhWejdGhSb1uP61BtAUgq/FXQh9puAvE8XK8e1NxXT9mRGVD9s/
         RSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3EvTLjCE04FQaQLZNcKs5KtscjgLIzQ7nMdfZDgRHBM=;
        b=NvFfLztkakSXJbE9Q+Hp7v5mmYWVwmcaVS7j/H/b8SXXiLkLKU0DlSYNWePhmqXiPn
         WJ40t7mloZkvumbQ/4o3ULEppbmi7tZH5kqN6HCSoCdEz1byBNwlL3WVFvKOVQYbhkOy
         fw518dJ13YjqFU8anJhptAFVK2ehSudtaW4Jzi/WzQGK0n1Xy8lGX4ygku48i2ZF+ank
         szXLCt1kAXKLdiyBm8aXoUCzV3f0tCEg78bBIqxAMBvC30WLQpzRTb3i2HkLIqyAnTIr
         6xxiAJGeoLHD1oLGCDO7mumwpYsWGxTSfWomcm0Vt7AjrlHVzgNrJKy4JnwkQElEm/Tt
         5oSw==
X-Gm-Message-State: AOAM532UjfdO7L0ac8mCEsvlSi57Rz8FETha0+inoIt4jtQFvporMFQt
        dM7A9FYnwT/yte4K5+WCJHNBtw==
X-Google-Smtp-Source: ABdhPJzQiDhJE1vFn+HALta5NlrpPTVn0P/LvhkrP+LUCGZwYGeGU0cvgzWhvwW2q3q6yYYxUQHMoQ==
X-Received: by 2002:a05:6000:1863:b0:1ed:9e8a:9413 with SMTP id d3-20020a056000186300b001ed9e8a9413mr3605301wri.282.1645618642470;
        Wed, 23 Feb 2022 04:17:22 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id l12sm54230867wrs.11.2022.02.23.04.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 04:17:22 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net/ip6mr: Fix build with !CONFIG_IPV6_PIMSM_V2
Date:   Wed, 23 Feb 2022 12:17:21 +0000
Message-Id: <20220223121721.421247-1-dima@arista.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following build-error on my config:
net/ipv6/ip6mr.c: In function ‘ip6_mroute_setsockopt’:
net/ipv6/ip6mr.c:1656:14: error: unused variable ‘do_wrmifwhole’ [-Werror=unused-variable]
 1656 |         bool do_wrmifwhole;
      |              ^

Cc: Mobashshera Rasool <mobash.rasool.linux@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Fixes: 4b340a5a726d
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv6/ip6mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a9775c830194..4e74bc61a3db 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1653,7 +1653,6 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 	mifi_t mifi;
 	struct net *net = sock_net(sk);
 	struct mr_table *mrt;
-	bool do_wrmifwhole;
 
 	if (sk->sk_type != SOCK_RAW ||
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
@@ -1761,6 +1760,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 #ifdef CONFIG_IPV6_PIMSM_V2
 	case MRT6_PIM:
 	{
+		bool do_wrmifwhole;
 		int v;
 
 		if (optlen != sizeof(v))

base-commit: 922ea87ff6f2b63f413c6afa2c25b287dce76639
-- 
2.35.1

