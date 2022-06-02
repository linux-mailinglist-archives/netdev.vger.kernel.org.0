Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788AB53BA67
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiFBOBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiFBOB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:01:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8C29FE6C
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:01:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d129so4824974pgc.9
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F52X7hEaD0sKd+J0O0835GFHljzQLnjTla5FR9Q8rYw=;
        b=JvcMCcv6Y0L5Ud/GWvPHERnSbE6PBvM/6Qcg5Hum7HNFOQOMbMm0q4lVV4VEZG2hWM
         iFWvPKfLGRUrlITqmY+Uys6dKqU1a/uqet3mERj8b4WaNpU2NI/hrbb7SVdE65HsEgRN
         UMo0+SO6aJTXAGKbzJmF9K8AoK544eis5acst35PQBlg+Hll3fSyfaCZv0IH6/K3YjoX
         K+4ip/Maw1Ne4lPLJCtVWOytgFaFoS96CWQqRgfie0pdU7j/wE6IroDUJYy2P0HaNciE
         fEu7i+mAlVAWggqzm6Qt5l8978MIBQ/tzSUKfmlPdp2UWLEdNbVajqFOfHDBF433BzBw
         j7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F52X7hEaD0sKd+J0O0835GFHljzQLnjTla5FR9Q8rYw=;
        b=AC5s40OM0xXm/64vxF31OIr7ZXZKdxF5EjQaLWJ1c2hVOGf/NiaoNuD/c1KaqErmtm
         TUUJtwkeCYExNzhO6htit0Nc+ieoTC9KOU0Cb21byRSvHnHNdgRt59FJd9VxgTD720+l
         P8GKV0NEKirY//WPdNs9uor9mzjH3aiaK/8ecIE7kF56zvpbyvcXLAQZKYMdcCbeVxIr
         FdCWhoM84hJz2DWyVVLgim+CHU5OE975Ddm6OEq7Ji3Jqq3Z7do0UixTnp3ND0H+u2YF
         jrYCgtQr9wxwzci1TLGN4URNA0QcGEw8Wo9NyJ/zHmdyF6N+h2UK6PxaMrF5zq+oPsye
         o56w==
X-Gm-Message-State: AOAM533Z7fv3xZ2aVOgA00zLtU50tJYzZrz8yXtZ88Rh0/oKNq2GLd2E
        wCgKDRvRhkB50xYfsbF5780=
X-Google-Smtp-Source: ABdhPJw1828uS3misZLSnAFL33YzOgqjkiIlFRW93kjSbxhJmMPdq3WitMfiyP/TVIcbagCCbgO9zw==
X-Received: by 2002:a63:f158:0:b0:3db:8563:e8f5 with SMTP id o24-20020a63f158000000b003db8563e8f5mr4497389pgk.191.1654178486878;
        Thu, 02 Jun 2022 07:01:26 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7998d000000b0050dc76281ecsm108463pfh.198.2022.06.02.07.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:01:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/3] amt: fix possible null-ptr-deref in amt_rcv()
Date:   Thu,  2 Jun 2022 14:01:07 +0000
Message-Id: <20220602140108.18329-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602140108.18329-1-ap420073@gmail.com>
References: <20220602140108.18329-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When amt interface receives amt message, it tries to obtain amt private
data from sock.
If there is no amt private data, it frees an skb immediately.
After kfree_skb(), it increases the rx_dropped stats.
But in order to use rx_dropped, amt private data is needed.
So, it makes amt_rcv() to do not increase rx_dropped stats when it can
not obtain amt private data.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 1a1a0e80e005 ("amt: fix possible memory leak in amt_rcv()")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 900948e135ad..ef483bf51033 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2698,7 +2698,8 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt) {
 		err = true;
-		goto drop;
+		kfree_skb(skb);
+		goto out;
 	}
 
 	skb->dev = amt->dev;
-- 
2.17.1

