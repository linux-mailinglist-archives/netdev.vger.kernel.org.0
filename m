Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB74AD112
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiBHFd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347040AbiBHEvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:04 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60550C0401E9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:04 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i17so16798854pfq.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvcC9+Awj3oLlqD6kMLWnWRMbi+Vd2Rz0NaLG9avzbk=;
        b=fChm/+PTCwaivYAF/1sUAnQmaWSERFzRQUQFuf7GW5ZwByDkuIIXRZHN7AGDnwj1TZ
         xcwtZSIuVBaPnQ8My+RC/nj8xSiwdRipQini1xZAaglifqe2l+rEfzMfXdqt82H7cQJC
         AYP3pIlMlf9UgYjEomUmWiFyeNrRics69nY8Y7/o8gmBlF5fNnzp5C6Crmb9cbEBdtEK
         2jxlu2yHyCMAne5X9+iPZBPWAijoglvBcWt3fDkK6RTyCuKszsiZvw/HsHkbREwclIS2
         NTXdnMjeHRbZyymk9BM44sPYnnqfgOebR0aG5U7JrT56DnBVInLz9befUrvfODAb9Yk2
         PW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvcC9+Awj3oLlqD6kMLWnWRMbi+Vd2Rz0NaLG9avzbk=;
        b=BHdjqt9ivrrezqc8RxTk6Ch6FrXLz3NR2l/ZP2k/+taKUKtkPzullSgxkl1h6yRJv5
         IpR9F6tu546213X7G8tXRqlORY+l7hxPNKdY6uz6/z0/6zQeTZGE1LKZo1lngEIkUg64
         DSceVEO8hNgFxbtL8SL1dQWS+8e+grxh8k7qLH3q9In8u/zfRGuYfwa0ID735xpc4uIK
         NFC8VEKHW2vRzjaXsri1dnKeoM1QSkbvfHnw+39z3OFUvxRggeGWEc0sL3jq8NnPm+rX
         iL9CG1ZzqKj6/kWQ2hevpN6WoKxsMqoIr1sPp1WrqmrmFpkmX767IMx4i1BYWALLO6KS
         vycg==
X-Gm-Message-State: AOAM5337GjvkeJeRNu2HqIMpELGkhsfCblHIdRg6r/7GybTx+ZtJdFKb
        c6Llj0YMTIWQVk2q1k+1rGg=
X-Google-Smtp-Source: ABdhPJwtpvTyc6Y3aAAEUHwIroZpyhcoIU83HjobP6mzNtwVCcIwEM0hKMI+YLXyaCt04AD+jo9KhQ==
X-Received: by 2002:a63:33c4:: with SMTP id z187mr2112140pgz.474.1644295863895;
        Mon, 07 Feb 2022 20:51:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 04/11] nexthop: change nexthop_net_exit() to nexthop_net_exit_batch()
Date:   Mon,  7 Feb 2022 20:50:31 -0800
Message-Id: <20220208045038.2635826-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

cleanup_net() is competing with other rtnl users.

nexthop_net_exit() seems a good candidate for exit_batch(),
as this gives chance for cleanup_net() to progress much faster,
holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index eeafeccebb8d44629085f504e26cb4e171c8c782..e459a391e607d34e16828bef13a5ce22ba6dde89 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3733,12 +3733,16 @@ void nexthop_res_grp_activity_update(struct net *net, u32 id, u16 num_buckets,
 }
 EXPORT_SYMBOL(nexthop_res_grp_activity_update);
 
-static void __net_exit nexthop_net_exit(struct net *net)
+static void __net_exit nexthop_net_exit_batch(struct list_head *net_list)
 {
+	struct net *net;
+
 	rtnl_lock();
-	flush_all_nexthops(net);
+	list_for_each_entry(net, net_list, exit_list) {
+		flush_all_nexthops(net);
+		kfree(net->nexthop.devhash);
+	}
 	rtnl_unlock();
-	kfree(net->nexthop.devhash);
 }
 
 static int __net_init nexthop_net_init(struct net *net)
@@ -3756,7 +3760,7 @@ static int __net_init nexthop_net_init(struct net *net)
 
 static struct pernet_operations nexthop_net_ops = {
 	.init = nexthop_net_init,
-	.exit = nexthop_net_exit,
+	.exit_batch = nexthop_net_exit_batch,
 };
 
 static int __init nexthop_init(void)
-- 
2.35.0.263.gb82422642f-goog

