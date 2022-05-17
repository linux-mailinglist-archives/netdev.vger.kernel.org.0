Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B42529A61
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiEQHFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiEQHFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:05:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2877EB9D
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:43 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so16570174plh.1
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WYJ4z7YHxeW73d4SCA9PbTBn7gV3Fnj9cuo6Jt6lL9Y=;
        b=b9SRA64jUBEP/H955g6Z9gR4qHu3isD2yCmErvWvnbRj90J+YQ6E39LE2qWg+BgfYc
         x4hRibF0pWkomixJGLkUx54FjhvT9VowwiI3rnSgQ85ZgtHiBl0LgNMiBjfWbwswyaWt
         0cs8BlvBqydt8j0xo+8rU9kemirKlD/L6ocFdJYJIm+gxf7sWBWVaeZ5AOeLhwz08Bt7
         2lefcmehEK7yEOOJmG56kdanMpcAbRkOA20eLsirgAG0tPykLCfcR7yCeqZnD8hFFAWK
         mqy2x9yC0MJ/clrt6mZUzc/EgZAhYwdURpIKjIqypGFIrCa/HJCeuwSKDhxocf2N+Vgr
         YfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WYJ4z7YHxeW73d4SCA9PbTBn7gV3Fnj9cuo6Jt6lL9Y=;
        b=nz/udu7I0ziUj3hPorrHCo//3LaUC3tRt4cxnZkZ5IjnvSDGmTxyrUuyjz6d4QptRj
         T/hNRewZu3jyNd3PvJUle4LS5N4KAPR3FrAdQwPTDUCGSnLjahiFzxzC9pkyKrkNRB28
         pEoO3cAVKul0CayfcUYWPtWiTefDO7uHY3JKUNu+T1RWsnH3yNJBf+BcafRIuOO5fnzX
         Thwzpe5x+afaYfTSIVTrDZqeboIhNuDUBZFK/1PNInUPTKfB4atJsqjz5CRQC+f0ifeP
         HYpKACnY/t77MiTKfRVgcJ+tQRs1b5o/DF+ajr5Nq+rTfPwnvBQKidWzAohO10BN4Bzi
         KEEw==
X-Gm-Message-State: AOAM532NyrCraHI46PZGtYSntR3pCe8/6mS3BDsaGnSBJsQ97w1KJ2NO
        wvW+tUmcJJv+RmBPoHAYXvc=
X-Google-Smtp-Source: ABdhPJxsYslzfYKdk+fPDBwSxFhn+gcTc1v2KzvNfaT4FPLN4AXd1tIYNLhIMvbIIkIW02fGalwDxA==
X-Received: by 2002:a17:90a:4a03:b0:1df:4583:cb26 with SMTP id e3-20020a17090a4a0300b001df4583cb26mr10969150pjh.173.1652771142649;
        Tue, 17 May 2022 00:05:42 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001619b38701bsm1680886pli.72.2022.05.17.00.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 00:05:41 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 2/2] amt: do not skip remaining handling of advertisement message
Date:   Tue, 17 May 2022 07:05:27 +0000
Message-Id: <20220517070527.10591-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517070527.10591-1-ap420073@gmail.com>
References: <20220517070527.10591-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a gateway receives an advertisement message, it extracts relay
information and then it should be deleted.
But the advertisement handler doesn't do that.
So, after amt_advertisement_handler(), that message should not be skipped
remaining handling.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Separate patch

 drivers/net/amt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2b4ce3869f08..6ce2ecd07640 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2698,9 +2698,10 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			if (amt_advertisement_handler(amt, skb))
+			err = amt_advertisement_handler(amt, skb);
+			if (err)
 				amt->dev->stats.rx_dropped++;
-			goto out;
+			break;
 		case AMT_MSG_MULTICAST_DATA:
 			if (iph->saddr != amt->remote_ip) {
 				netdev_dbg(amt->dev, "Invalid Relay IP\n");
-- 
2.17.1

