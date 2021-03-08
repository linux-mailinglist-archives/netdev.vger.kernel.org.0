Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB0330A54
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 10:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhCHJbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 04:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCHJbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 04:31:15 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEDDC06174A;
        Mon,  8 Mar 2021 01:31:15 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q204so6677629pfq.10;
        Mon, 08 Mar 2021 01:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=74+wRt4hYV9u6HIa3XGAHvJvLBD8vqSmgIDXPC7I9yw=;
        b=B+8b3pgYE4zWcmunrAQfjRJiGPgT8bnxRUooaoRNKMJR+U1/hQui4L0PIdfdcGYje4
         hV0Mo36mr6m6o9pRLIvUJaKUH8/Rm+dHbY2N4xvys68beGLjdQ0pJ4SDEqpwotg6k8Iu
         KtFjH3yrbQ5HOOB9t4+X3/+nIh3F84LHPDd1ZogNUptC5zMOruXpgfzUkuKoqlg8lEio
         h1Y2b1cVnMFb9UA4pkwxQuFFLyF3p5KVqjgY+SBKY+4pkwOPJ0kQkq16SBQGvfAXif4l
         Vwx7L/i8obNNdXQk3rjf1jy6o3XClmk93lprLmlGiPziVQ6gx0lTW3qIzdFW06lS+IRw
         0vlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=74+wRt4hYV9u6HIa3XGAHvJvLBD8vqSmgIDXPC7I9yw=;
        b=O2o2S3KSIwjZj8phcZlAYIRZU+Ys+aqTWwpFvh2V/7AbaH60eUoenMooYreZD9uAu9
         Jg47Zl1+XBYGDbtSJ2OkkDpGb+LQNHJpxN3LS0NcP+TeuPeYyP6+J4ufEYloTOv3gvQk
         57MHdbsM34qMNJMh6vH5g+7x4Fd2Fizb0tTN5RhWS2Iq/IcDOA8cEplznfOZG+b3E5Vt
         Emq4lsAeS6fduQ4oLIhE4/3t3Ru4cbMh6Ia98lLMzQTk8OAI+9E13iuykEUSdTTLrLIs
         0uxLuC4rh6Opt/Yr0gyTw/0i1jd5N4b3xgxX3lMTl+7D6QTkPTiWIZ5r3uhuZZ2udL+C
         ZQlg==
X-Gm-Message-State: AOAM531kP/twumv+eOqtX5wDxP7Nxql1GNGTEWnFBWIOuFGjI2M+9Z+/
        tzsFdHBgdjUGdwQFbTnBrRM=
X-Google-Smtp-Source: ABdhPJwQBUsQKOZ6YMBcxif7BLfermeJcrA2xRl2FFlYZeqCXZtuysH6IBKVdPEJyhpbQF4HiS5Y7A==
X-Received: by 2002:a62:6413:0:b029:1f3:a5b4:d978 with SMTP id y19-20020a6264130000b02901f3a5b4d978mr8208518pfb.44.1615195874997;
        Mon, 08 Mar 2021 01:31:14 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id k13sm10116901pfg.3.2021.03.08.01.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 01:31:14 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: ieee802154: fix error return code of dgram_sendmsg()
Date:   Mon,  8 Mar 2021 01:31:06 -0800
Message-Id: <20210308093106.9748-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sock_alloc_send_skb() returns NULL to skb, no error return code of
dgram_sendmsg() is assigned.
To fix this bug, err is assigned with -ENOMEM in this case.

Fixes: 78f821b64826 ("ieee802154: socket: put handling into one file")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ieee802154/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a45a0401adc5..a750b37c7e73 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -642,8 +642,10 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
 				  msg->msg_flags & MSG_DONTWAIT,
 				  &err);
-	if (!skb)
+	if (!skb) {
+		err = -ENOMEM;
 		goto out_dev;
+	}
 
 	skb_reserve(skb, hlen);
 
-- 
2.17.1

