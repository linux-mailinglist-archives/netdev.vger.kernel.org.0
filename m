Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FEC4AC747
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243187AbiBGR1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384317AbiBGRST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:19 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A2C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e28so14109955pfj.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hF7w07jG5pYTKkawKidH4XIxVWWjxIRivkIAyqYYm/c=;
        b=kdhZmpA8HNkKqEKvX7URHb/fLyWnojd+mDjjk758XQ4Gm1ZTLyXrGh4nQQkEHzEtMj
         9zX9IkkmA7X4J9guSdA620/03SQoNzoNLrKUQzo8ciDOZhJZ0ej9tpL4h55eG1WFj9oE
         NuLaiWLev3p18blcWtYW654freOqrGmkI90dFU7d12ZpcDXxhsByCnSeKV+8h1QLJvAw
         8YRTmlRNznIzFoPKnjQBMgCDKYXaHWl9Ez9nw9KaMdEQfR+Cqgx+Ox6zV1XwLrRL+afL
         uGLG1yyn2kLvtgAYfSiwrgZnuSkrgENfzNE1jRjDNWZzPMDkEhACyIOrBCREQ/OXnvyw
         KBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hF7w07jG5pYTKkawKidH4XIxVWWjxIRivkIAyqYYm/c=;
        b=XCpwgxlHdhea3EzM7vwnx6k3BV+AjTQHfqUZ2UMGH5JkaZmgoCaXamp4JLZEqez5Cd
         Hw6HMiVlaEbSrROowdnm9nF+Jq+TcwNdzunB1Ugp+KH2X1r6xRLEwynDNs7WJzKVMfSQ
         99YW2sXhA8FJXJ3mHuWNUC9px0SjBKWsZpuV8D+3tU+8DzlAwFAAaNrdXoZpjMChG5an
         /EB11rnuPGZPiK9otRnM0oGdAzjX2v4Qv1OMbjpNUdndB//1o4RIyIuHWmDhvAkdpKE9
         ekRNGeZBTHOgv9Z9BWw5JYYeR3yqsxXYhFpjmlbHWkv3TH4cFnLzOO+HFWMP6HTDuKWB
         qtwQ==
X-Gm-Message-State: AOAM5335pFDq1Z021UYQqqTY7fp+liTpxXVJE3GLujX5YpzFu8Gc7iOj
        ITsDFjwQO0ZD/OQSrfABkTE=
X-Google-Smtp-Source: ABdhPJxZ4X37xTCSkj446Z7DgRp58q73BVK3DuxDOCvDJfz4dWYL4QtrBihw050p3wGtKqMWsiiygw==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr346960pgm.92.1644254294319;
        Mon, 07 Feb 2022 09:18:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/11] nexthop: change nexthop_net_exit() to nexthop_net_exit_batch()
Date:   Mon,  7 Feb 2022 09:17:49 -0800
Message-Id: <20220207171756.1304544-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
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
Cc: David Ahern <dsahern@kernel.org>
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

