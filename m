Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5DB4AC764
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377401AbiBGR1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238630AbiBGRSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:33 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD51C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y5so13171200pfe.4
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=86erZqV65XT7HOKTwd7EuyR31bW9wtxCPKCH1CEIE5E=;
        b=gkLqfuWhQQidwxSdWh4J62YGSEzZJeqIMM57SzeZpJp57/v6n9neIcUHdE98kdaJKq
         t2zwHfG459QWSdT3h49R172jdHv0YzHTcOL64w9N49nLGioas7oeDARVBGQ3LOThKD8n
         JBgT4Q/g9lCjSHCZXTwg5syAP+YsRksPPiF6MpmAhoKjjU958LzM/g6zPkLA4elK0JMU
         JClcGH7LpE0hDhQn6e/FnmwLlAWE2/xHm/kcvxXHAfmwR+Hwiu2FjXX90jMRyj0TXWj8
         dI+yKeY9QiP09bJi/s99zHRG3A/d+UcmTPxmS8C4s8k+mtQso05uMaYXNMuQaeUgD70L
         N3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=86erZqV65XT7HOKTwd7EuyR31bW9wtxCPKCH1CEIE5E=;
        b=kWkkX47/eX8//Q53eJGun/otH8Utvvi88n00d6YCjcfmxV/Ogi2+CQ+sP9LYaMCg3z
         fg4FLcJkV/IrkmKri33qxjVMQ6IvTlFzJheFVeOicCIQsgZMJ10vaYzvuwVySDAGW07s
         unOHSnlbJ/kqnTfh4rYwas/kr8+2DqOM1I5qaRYMwrlrsbH/xQB1vvu0BU/opJHYyJ/f
         2r6jte8JFFTyaIimoW9Or/LA6k8eyvW6FOZH3MYxcpa5JmiGsXVgvWlwPDOFCFOT20bg
         gG6B4G+FYKWJyG6ky+AE/d2piiXdAH6a1oDc6zbK/w3LmpDp0GGBqlHbBUAQzzVxK4po
         YZqg==
X-Gm-Message-State: AOAM532pDDjQCp/C2oKAXwSSFRbigfWq++Owu96bxt08FJLkvu54WAY+
        yP+EVK/NCQ11NOhCrRWOVFA=
X-Google-Smtp-Source: ABdhPJyErN2zyhcXnzpgMf5RblAPyk1bsfuDVfDXZChp12EqWl4WlqrkwwuuAG0Pb/u3JcZ6axBjhw==
X-Received: by 2002:a63:1043:: with SMTP id 3mr343801pgq.16.1644254312584;
        Mon, 07 Feb 2022 09:18:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net-next 10/11] bonding: switch bond_net_exit() to batch mode
Date:   Mon,  7 Feb 2022 09:17:55 -0800
Message-Id: <20220207171756.1304544-11-eric.dumazet@gmail.com>
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

