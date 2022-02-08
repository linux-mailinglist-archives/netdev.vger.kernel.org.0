Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A474AD0EF
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347333AbiBHFdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347049AbiBHEvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBD7C0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y9so7472451pjf.1
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/e0ictUQzluRJgt7JrTdVRCzpOV3bwWprr9d9iNmdK4=;
        b=Z2mISDPxthQYLdzypQLMKyrMiRtT9ypk7HYCnbJwDEP9G47P6W7n00qrBgOZHtBRuM
         bWuEsOkmWKF08/pDd/B+Qq7Qqq1wR540fffvMKS2AYgQEDkaVntMwvIgvpHObTWvuByx
         HkhJ+SqnJ9ElEsWJZCsuInYPgnwBhEkbhIXaKM2s/cZ6h83/WptzSIGDbNg4NkGQC1V5
         ELYUrZfZrtjbkoqa2pj2PiDrMfilHhPgORvxDwJOpDWyutsNKlZMMmgoeoIxpW6t1m40
         rBEoBRRDE8fQOC5XvNetV5ETrOfKIl6LPfTR5/whzWqBjfpM7CL1/9KRA1MLwUyt41tu
         tXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/e0ictUQzluRJgt7JrTdVRCzpOV3bwWprr9d9iNmdK4=;
        b=ZAcd3c9VZVe5uYUHSkwGrHbx3wNh9RQzIkpj9kgcg54qW0bHQ3mB4HDTiP1F87Gmnx
         fZqLs2MSYvO3Jxv/haOYw9AxPZRr+uzERB6L4zG3ych3CWiJmeJG79sRz1BBhP4h147f
         V5/KGdEL5nemif31bdue8L3Q3B0e95WZ+xbTmQOsc3APsT2z6NnSjdoGmqX/vyljz5Mx
         dxx4qyFPYEDB54WevJXRZswTCUSSycystDrGv7ntEESzmQnSMX5tou52l6Pj5g7QXBPm
         VCEANPvXshvAqBcDh2klQo4Ccm37v5+SUYLtdEfBJsxDtVnt/euPmUMiqLDA4VrQhBgc
         sxCA==
X-Gm-Message-State: AOAM532lGgWc67EbKN1tbEcYIOONJW6LlfGrlUNSbLACvO9AxjbO0G1U
        kAKRKbtrQdDHqAd/BtMI4X8=
X-Google-Smtp-Source: ABdhPJzyM6HEXiicR6ax7vZdfZo0kuSxuwOcAfuliiCXotBYOUizKXl+NwOvExiAKfLvh1p8CDek9g==
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr2501384pjb.179.1644295877408;
        Mon, 07 Feb 2022 20:51:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 08/11] ipmr: introduce ipmr_net_exit_batch()
Date:   Mon,  7 Feb 2022 20:50:35 -0800
Message-Id: <20220208045038.2635826-9-eric.dumazet@gmail.com>
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

Avoiding to acquire rtnl for each netns before calling
ipmr_rules_exit() gives chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/ipmr.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 07274619b9ea11837501f8fe812d616d20573ee0..4a55a620e52675b7a4bdbea8ca0476b8c92dcb13 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -266,13 +266,12 @@ static void __net_exit ipmr_rules_exit(struct net *net)
 {
 	struct mr_table *mrt, *next;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 	list_for_each_entry_safe(mrt, next, &net->ipv4.mr_tables, list) {
 		list_del(&mrt->list);
 		ipmr_free_table(mrt);
 	}
 	fib_rules_unregister(net->ipv4.mr_rules_ops);
-	rtnl_unlock();
 }
 
 static int ipmr_rules_dump(struct net *net, struct notifier_block *nb,
@@ -328,10 +327,9 @@ static int __net_init ipmr_rules_init(struct net *net)
 
 static void __net_exit ipmr_rules_exit(struct net *net)
 {
-	rtnl_lock();
+	ASSERT_RTNL();
 	ipmr_free_table(net->ipv4.mrt);
 	net->ipv4.mrt = NULL;
-	rtnl_unlock();
 }
 
 static int ipmr_rules_dump(struct net *net, struct notifier_block *nb,
@@ -3075,7 +3073,9 @@ static int __net_init ipmr_net_init(struct net *net)
 proc_cache_fail:
 	remove_proc_entry("ip_mr_vif", net->proc_net);
 proc_vif_fail:
+	rtnl_lock();
 	ipmr_rules_exit(net);
+	rtnl_unlock();
 #endif
 ipmr_rules_fail:
 	ipmr_notifier_exit(net);
@@ -3090,12 +3090,22 @@ static void __net_exit ipmr_net_exit(struct net *net)
 	remove_proc_entry("ip_mr_vif", net->proc_net);
 #endif
 	ipmr_notifier_exit(net);
-	ipmr_rules_exit(net);
+}
+
+static void __net_exit ipmr_net_exit_batch(struct list_head *net_list)
+{
+	struct net *net;
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list)
+		ipmr_rules_exit(net);
+	rtnl_unlock();
 }
 
 static struct pernet_operations ipmr_net_ops = {
 	.init = ipmr_net_init,
 	.exit = ipmr_net_exit,
+	.exit_batch = ipmr_net_exit_batch,
 };
 
 int __init ip_mr_init(void)
-- 
2.35.0.263.gb82422642f-goog

