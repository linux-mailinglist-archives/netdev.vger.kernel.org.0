Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028A54AD102
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347400AbiBHFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347052AbiBHEvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:25 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5487BC0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:24 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i30so16811441pfk.8
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=86erZqV65XT7HOKTwd7EuyR31bW9wtxCPKCH1CEIE5E=;
        b=hdPi1y6Yn4f5iLrmKF6i4zEObFSqqkyjp2w44rPcWP3Z+QwrNgy64/V0UUFdzqb6//
         s+fiOivyFwFapryI3NtPkVL7pfrS23jVCcLhdBFria5CdVA+S8gBMB45VmD51djK9Cg5
         PIBcyF2vhEvLFB46MNAAmmMm7PTjyUzQXSQRwRl1+2RAaS0fmBP8eIn3zbm7+DGyCz34
         kj1YywTI4K1BkI4dUXnKGuQiIBmFtQ9pMRyId1ncSDscPRHuOXNG5Rl11TMV1Dfm4hqP
         IirpbKAtuw8lbnYuFCTzsKpG+G+YPh8nj1eURGa7t5LukFh5t4Y68fnhu9KtvDYPgr+u
         E0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=86erZqV65XT7HOKTwd7EuyR31bW9wtxCPKCH1CEIE5E=;
        b=CwhIol7pfrAzckBXR5rmZisB9mKlB/LBQ8X2cZoBcPAvEbNyFnxX43qGvpaBlttcp1
         vT+AGdII0tQ3oUB3bQKgtAzoMC4RNaYJC0k3izdTvCTGppBtkbeEgsulPyMJ9D+Yjb01
         /DQR2rhxtnokm7eLsnlm8yWuJJZ3Ygb9y0Kd6Ij6tgBlitYbMmbvGkczxcml5XPALvuS
         nVX2ZAxcT4+WA1f3H+EUn0lzJc0G+ERptnqkRaFTveuLUp8wTUr4c+gW/rFLHjC7MJ2Z
         kzel1sMGxo8L9DakGFroXnrYLNGWK7lZRlTjzPWyQEn1AZqFcAwxqlQBenApqV8h3UVr
         0/9g==
X-Gm-Message-State: AOAM531Bub+k4Z1Zx2Cu3OKHFVKsA4A6OxyUwcSciH4ZtYU+GuPHWA/Q
        ur+twINqmawhqgl/JN7dFLE=
X-Google-Smtp-Source: ABdhPJyvWo9hjB4OR6IzM9Rxbd3Tr8zcfJi5bEO1n30RDqJnE6U/Dhxh/EcVyOOqNCd16S8SOSEpnw==
X-Received: by 2002:a05:6a00:1902:: with SMTP id y2mr2650946pfi.57.1644295883860;
        Mon, 07 Feb 2022 20:51:23 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH v2 net-next 10/11] bonding: switch bond_net_exit() to batch mode
Date:   Mon,  7 Feb 2022 20:50:37 -0800
Message-Id: <20220208045038.2635826-11-eric.dumazet@gmail.com>
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

Batching bond_net_exit() factorizes all rtnl acquistions
to a single one, giving chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_main.c   | 27 +++++++++++++++++++--------
 drivers/net/bonding/bond_procfs.c |  1 -
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 238b56d77c369d9595d55bc681c2191c49dd2905..617c2bf8c5a7f71ece82a20dbd3a9740b928ef6a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6048,27 +6048,38 @@ static int __net_init bond_net_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit bond_net_exit(struct net *net)
+static void __net_exit bond_net_exit_batch(struct list_head *net_list)
 {
-	struct bond_net *bn = net_generic(net, bond_net_id);
-	struct bonding *bond, *tmp_bond;
+	struct bond_net *bn;
+	struct net *net;
 	LIST_HEAD(list);
 
-	bond_destroy_sysfs(bn);
+	list_for_each_entry(net, net_list, exit_list) {
+		bn = net_generic(net, bond_net_id);
+		bond_destroy_sysfs(bn);
+	}
 
 	/* Kill off any bonds created after unregistering bond rtnl ops */
 	rtnl_lock();
-	list_for_each_entry_safe(bond, tmp_bond, &bn->dev_list, bond_list)
-		unregister_netdevice_queue(bond->dev, &list);
+	list_for_each_entry(net, net_list, exit_list) {
+		struct bonding *bond, *tmp_bond;
+
+		bn = net_generic(net, bond_net_id);
+		list_for_each_entry_safe(bond, tmp_bond, &bn->dev_list, bond_list)
+			unregister_netdevice_queue(bond->dev, &list);
+	}
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
 
-	bond_destroy_proc_dir(bn);
+	list_for_each_entry(net, net_list, exit_list) {
+		bn = net_generic(net, bond_net_id);
+		bond_destroy_proc_dir(bn);
+	}
 }
 
 static struct pernet_operations bond_net_ops = {
 	.init = bond_net_init,
-	.exit = bond_net_exit,
+	.exit_batch = bond_net_exit_batch,
 	.id   = &bond_net_id,
 	.size = sizeof(struct bond_net),
 };
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 46b150e6289ef4607c8ddbcd2b833ff4dd64cc9b..cfe37be42be4e0edb218c45127a378b53e487df8 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -307,7 +307,6 @@ void __net_init bond_create_proc_dir(struct bond_net *bn)
 }
 
 /* Destroy the bonding directory under /proc/net, if empty.
- * Caller must hold rtnl_lock.
  */
 void __net_exit bond_destroy_proc_dir(struct bond_net *bn)
 {
-- 
2.35.0.263.gb82422642f-goog

