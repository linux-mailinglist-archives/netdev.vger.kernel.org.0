Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8C5312B3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiEWQRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbiEWQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:17:31 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDAA544CC
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id a9so12074268pgv.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=23CBLMwb3guE5iJvJwXPI+qbRLvKp4RVuSYLI9nOoJw=;
        b=BuuSoLFK4Vp/mmoV6ukmUMED2WupMs+dhkwNuuf+MLSu6tNlyF5yHTxVa8qs75Jb1t
         wK5f1mFjStAf+YDHP0f/KOB0UKlDAx0Lt3KHkbG9H2/cLw62x6meZMBaxUtkQRafzNTu
         l+XMwi75wkkVXpUXDad27poMBy7Yo+oDUcnEbPk3lzWYovd1e9OyBNABR5egkn8UABf3
         em+8gqZd0UXUFHdkPnxRr4+tOhO/ymasVsxlummMZMiROglon619RUaT2AocZ6PggluD
         kNUxMP8Jm1vu4CK5iGqOokUZpdGRcDJQ/Chn1u/vX6ZFHua2b82vuZa6lDD5lLIelq62
         Hu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=23CBLMwb3guE5iJvJwXPI+qbRLvKp4RVuSYLI9nOoJw=;
        b=IhWtmIfd3G+a6uJYd8LS5wSsK3DnFqIgHBGxiXdawX1JiMUBOtLSWdhYapgqpD53ZP
         OBm/cay740Q+NUcaCdZly4lBdFAjaYfoiNqY8zEDsaBjIcdQFFv+IL4wbuKr4RSB0us6
         MppHH1kVui6i3UZbqRPBozRGXqKkzAxYOn9XxlrJAJt2IS6qESrBa/9P2TaHRGVWwpA6
         VADBycRV9di3h26e8ie/xRrz1UN6joEkOJXpaq6ALYrOKrLOT29uTxV6+EtxRvvnVT67
         xMojN3PdpWZ7MPPG6EJl8j9VTv4BBfHDVVu4MT2cvQdpDxTOEf8KVNDJi0hHgsa9f5Ug
         nSBA==
X-Gm-Message-State: AOAM532YUWpimUW+Llw+7N8Ra7rNFPzBqw4wc0MGzhDCHYfeLGZTqaB3
        b/doj+Whp1Ci9jXXjDwIEiA=
X-Google-Smtp-Source: ABdhPJzz+KnYrmdnbmtN5FbdS54UppsKGY/Ep49TOjEo65o9Y15AwQbufyDL3uVE4Lv7BULtKaqtgg==
X-Received: by 2002:a05:6a00:1305:b0:512:ebab:3b20 with SMTP id j5-20020a056a00130500b00512ebab3b20mr24450505pfu.82.1653322645817;
        Mon, 23 May 2022 09:17:25 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c8-20020a170902c2c800b0015e8d4eb2ccsm5252127pla.278.2022.05.23.09.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:17:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/3] amt: fix possible memory leak in amt_rcv()
Date:   Mon, 23 May 2022 16:17:08 +0000
Message-Id: <20220523161708.29518-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523161708.29518-1-ap420073@gmail.com>
References: <20220523161708.29518-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an amt receives packets and it finds socket.
If it can't find a socket, it should free a received skb.
But it doesn't.
So, a memory leak would possibly occur.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 635de07b2e40..ebee5f07a208 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2679,7 +2679,7 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt) {
 		err = true;
-		goto out;
+		goto drop;
 	}
 
 	skb->dev = amt->dev;
-- 
2.17.1

