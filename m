Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830603A2055
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFIWoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhFIWoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:44:10 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169AFC061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:42:01 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id l3so6677189qvl.0
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SMC3JeRl4BXUE5gzvpVhPYJYHsododoTHUz/VQ5IoqM=;
        b=iQ0Hbn+ftsqDVEruhOkpyywd7WHrqBPO2xZu6mpsTdVjEm4TI4HPfztf2Xh6ksyyw3
         BhlBq4PfPAMEwK+elY+cx0WUoH4ZV6N9RJr4X7N1Rim3HkqMgwlQuFpyiW+m0etb2OP6
         7wQcHflMJ0ECk1VEg0jLjQAZsH3Ha0G6Sgyl9UHTEm4huhTifyI6nl8pc7T9QBZYD+SD
         WLpsDnbqhxE5nvU0qQHr0u/XAH/8e/0NCr6vKwK/Wl82ogIbDMkc450PvryM3MhJPogZ
         EQsNGBrhPHESHinaAAmq/TZjauhbg0x+ZExnLjJiWXH4udwH7//smdr3/sXv7fZNc0ku
         eBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SMC3JeRl4BXUE5gzvpVhPYJYHsododoTHUz/VQ5IoqM=;
        b=ccuK+nkL2PM/0cBrwOFxLOzEd8W+IaGImFrwxBAcqdKeihIXkubObduSbuYRW8A+0o
         pMIIBKJABnIHkYKroD9hbfHEaMyZ6SOI7hhUWSZRMLpKtoudMkahz35tAO/zoXeMfs9K
         QoW+owYdWwzrWzGWJL3rAc0fRr2WXeWE45AGmP+/v/Q67qYcP1z1DYUyMgOJr+zAEp9T
         MdodxUxkCj4aFaHBeVENleo8sI4r1+Xw0JskcM0ohTHTfXz0GZlvs9K4ci2w7D8GIaO1
         3uNz1IzlqSGpk+xRI0oyb1IGp5DrPcLoTyUplHUqCJh6vycuF86+fTQdZ112eH9pyLTd
         ccpg==
X-Gm-Message-State: AOAM5325sl24T0+ntyilZmE6/Bp1cojFKD888QYE8TqFQN/v3lnK+4wz
        L+fx9xTEpdyhdxAcHLuztDqoHGq6gr46vA==
X-Google-Smtp-Source: ABdhPJxu796BiIW7XpjZB4IO/a/F9e3MwrgDOn92IVVZsCZx0eS1Rx+cbOKkYSE7sBkIEMsyVTexjA==
X-Received: by 2002:a05:6214:207:: with SMTP id i7mr2422000qvt.10.1623278520247;
        Wed, 09 Jun 2021 15:42:00 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:31c:cffa:1a8e:d98e:2fde])
        by smtp.gmail.com with ESMTPSA id p13sm1001150qkg.80.2021.06.09.15.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:41:59 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, soheil@google.com,
        jonathan.lemon@gmail.com, Willem de Bruijn <willemb@google.com>,
        Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net] skbuff: fix incorrect msg_zerocopy copy notifications
Date:   Wed,  9 Jun 2021 18:41:57 -0400
Message-Id: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

msg_zerocopy signals if a send operation required copying with a flag
in serr->ee.ee_code.

This field can be incorrect as of the below commit, as a result of
both structs uarg and serr pointing into the same skb->cb[].

uarg->zerocopy must be read before skb->cb[] is reinitialized to hold
serr. Similar to other fields len, hi and lo, use a local variable to
temporarily hold the value.

This was not a problem before, when the value was passed as a function
argument.

Fixes: 75518851a2a0 ("skbuff: Push status and refcounts into sock_zerocopy_callback")
Reported-by: Talal Ahmad <talalahmad@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..bbc3b4b62032 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1253,6 +1253,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	struct sock *sk = skb->sk;
 	struct sk_buff_head *q;
 	unsigned long flags;
+	bool is_zerocopy;
 	u32 lo, hi;
 	u16 len;
 
@@ -1267,6 +1268,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	len = uarg->len;
 	lo = uarg->id;
 	hi = uarg->id + len - 1;
+	is_zerocopy = uarg->zerocopy;
 
 	serr = SKB_EXT_ERR(skb);
 	memset(serr, 0, sizeof(*serr));
@@ -1274,7 +1276,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
 	serr->ee.ee_data = hi;
 	serr->ee.ee_info = lo;
-	if (!uarg->zerocopy)
+	if (!is_zerocopy)
 		serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
 
 	q = &sk->sk_error_queue;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

