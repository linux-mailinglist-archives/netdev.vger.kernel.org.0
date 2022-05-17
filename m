Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB7529A6A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiEQHFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEQHFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:05:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D04E25C4E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so1590308pjb.2
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2IXKhup4oktin7HECj9TPItc3ND78JIvXDX7qg+RJ8s=;
        b=Dy2xWtEcowzYkBIOqbwhaCgQXMy7m9WSC3l8DUYci+0Bjo7xtcUBT6oM7+RFS4vpWM
         QQfYT4opsYBoEglonO1KcNe4dC82obVVGFYXwWm9aOBkqSxEOVYAZyxj1BIPHRlCyiCl
         mQXggwCMwb9X4yLh5I3H3tfVlVHrwRg645M6MOkR2arq0fszuQ6mEIEBSzoc38YwhbK2
         lJtpEfog0iS0cH1XgkLkAagpY3XB0tY5MzvsIGZv7oYebMuLELvxYh8pGSuyqsy4mMd1
         MMOdXjOdjAU5wSWS5OZolFZ095QtpGC2VgoxmhvByhQ895FoZT0hTmCLJ9insCpYnk0u
         uh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2IXKhup4oktin7HECj9TPItc3ND78JIvXDX7qg+RJ8s=;
        b=e5ee9pQWlvUm0F3rqN6H8TYbOlsE7UseTpo6cI82Xex+BKImWqtlObyIqWZVb5BR/y
         lqSpSmHZDDYC7T7pJx8rT6ua4Q7NozX3CUku9KdJaSA/Goq7V5TBTIOhp2ZGi+9CUxDX
         k+y23M435QXhsY9SQWdi1gyRTwnc4ynPHtud+dOM55NxfEBhuHiwvbsV7fFY/Q/V+aCh
         7ToV9Ev1lSzsn+yz5zpMmWQbFNkFBGdqHabK9VXnsyHrXxExOVS126mWiRwZCrxnOM6U
         BRQd/q7u25nzcuxehrvrNDOVbetUtqsyMD4GNBOk9yLYM73GbEzr4JpYDy/SkkiXwzl1
         sCiA==
X-Gm-Message-State: AOAM533FSEdPeF/tfacei/WCOz5c2RM7XlDdCDcSik4ovO2b74ExqVIM
        wHKIvKLJR66AZcoQKRZvk5k=
X-Google-Smtp-Source: ABdhPJww3E6F8B3DN+el0TGr+sshSpfHeIOQZvrPMUdM4JmVrHqPL5ATqugTcQLsD9x8XIvIhPpPzA==
X-Received: by 2002:a17:902:f0d1:b0:15e:dfcc:fda3 with SMTP id v17-20020a170902f0d100b0015edfccfda3mr20861434pla.93.1652771139690;
        Tue, 17 May 2022 00:05:39 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001619b38701bsm1680886pli.72.2022.05.17.00.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 00:05:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/2] amt: fix gateway mode stuck
Date:   Tue, 17 May 2022 07:05:26 +0000
Message-Id: <20220517070527.10591-2-ap420073@gmail.com>
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

If a gateway can not receive any response to requests from a relay,
gateway resets status from SENT_REQUEST to INIT and variable about a
relay as well. And then it should start the full establish step
from sending a discovery message and receiving advertisement message.
But, after failure in amt_req_work() it continues sending a request
message step with flushed(invalid) relay information and sets SENT_REQUEST.
So, a gateway can't be established with a relay.
In order to avoid this situation, it stops sending the request message
step if it fails.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Separate patch.

 drivers/net/amt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 10455c9b9da0..2b4ce3869f08 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -943,7 +943,7 @@ static void amt_req_work(struct work_struct *work)
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
-	if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
+	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
 		amt->ready4 = false;
@@ -951,13 +951,15 @@ static void amt_req_work(struct work_struct *work)
 		amt->remote_ip = 0;
 		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		goto out;
 	}
 	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
-- 
2.17.1

