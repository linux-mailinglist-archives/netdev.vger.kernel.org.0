Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACC353133F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiEWQRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238796AbiEWQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:17:31 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AAA66F92
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id x12so14082678pgj.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xyBPWf3AN19Kx98veRFzdwWoDGnFy6v28BCT/4ZU3/o=;
        b=SmGIT4CCRy/LiSzLIDzLRa+mM3Uy5hJDzrWwQ1+9Znf17p8GqzVaU9CRbRrvaTGqZ2
         3HJZbeEjs2jABru3iy92332p2UxsErO+Ng+NSDK82xlJ3PpjgzojoZFx/mvYhHDPBT3n
         hQUqdZSHdLp3qbE5tFQD651NgxpFq9soYLfwxbmY3d8IAQP1K2lbNxCrhz07ATqEQMP3
         rz2BfMgaece0P/59Na9ioVF1kiQ7ikX4SEArZEwDWRV1+DkaG8kf8rRzo7DVTMuwLgJC
         IVLfElPiut2H89L/awmqIYZ1fPgRUNNAHcQ68FeWsXUbNcwKaj+WZT+Lm+tJWvf6esLH
         Lq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xyBPWf3AN19Kx98veRFzdwWoDGnFy6v28BCT/4ZU3/o=;
        b=bT/aY5J7mRXPYdKh4P6Nqbnln0g9BAB/OfsrvQVtZ6LcIeelb6ZxRPztZ37G9Z2Kx6
         ff3QcM87GDx8fGQeLooDTrUKBI+CwT5zbU7tf1a6l1W2QnuLB3PoeRS1d9PcnsWjUq2s
         p4QRCqkMR+JiGyl5iBO2i/cTeb3UbSboZfrAWC1UB1NDXHQMtmdRqQgRkO+o43Z1dn4H
         9F4pjHHNSTWVSApwmVJNF6ykaADIHobFxnUaL1JyYy7Rdwpp58p5R1u0orEmCtKkksEt
         dfSo9gYHs/0QCzbz33eLuza/QU4hzv/nns5pzYN69ikVTJNmY85VN4P18UtTbvH4FGEY
         c6sw==
X-Gm-Message-State: AOAM530oS9SijbhSo1zIcNiST+zjnWIlbE2gx1r/lPCeMQ164K60nBLm
        kdu9625rLgtmzLHshKbEO2w=
X-Google-Smtp-Source: ABdhPJwG3h83gjJzYaXBn8E9O0DFb9WB6FGz+hg+jqMFot8DsdtDnNU2oUUwbCilhMNBf/JLBi5oUw==
X-Received: by 2002:a62:8686:0:b0:518:29a8:93b5 with SMTP id x128-20020a628686000000b0051829a893b5mr24132242pfd.71.1653322643273;
        Mon, 23 May 2022 09:17:23 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c8-20020a170902c2c800b0015e8d4eb2ccsm5252127pla.278.2022.05.23.09.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:17:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/3] amt: fix return value of amt_update_handler()
Date:   Mon, 23 May 2022 16:17:07 +0000
Message-Id: <20220523161708.29518-3-ap420073@gmail.com>
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

If a relay receives an update message, it lookup a tunnel.
and if there is no tunnel for that message, it should be treated
as an error, not a success.
But amt_update_handler() returns false, which means success.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f41668ddd94a..635de07b2e40 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2423,7 +2423,7 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 		}
 	}
 
-	return false;
+	return true;
 
 report:
 	iph = ip_hdr(skb);
-- 
2.17.1

