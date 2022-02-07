Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054434AC767
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377525AbiBGR12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384348AbiBGRS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:26 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B04C0401D8
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:25 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a8so14100100pfa.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AevgfzwpFF0x/3DbgQzBrGCua8A9+rsxA+kfGfkdq6k=;
        b=g4KXOKOKBlrBJ37eUlBXDb51cLBcQqzWQEDt6gUJF3/I2RmCqbj/JGHcDQ/6o+pbA+
         PzHCJ7aU26+F6rbpb1Q30q4Nj59ep1GmaB4RuRBPXVxb1B89tbnZErLlPF7IB/2iMmRA
         YU7K1UdMruHPNLLYl4sdS3gwKkU9U9uRz8x6kDWtCnFkcNGhnl03Zw5fZVtwoMI66qGM
         GgGroF9mx6uHWq8P4ZHYQFoT1XfTF2aVs8UvounOJdDQafPWvvn4iaKmRMwS5irWZ1Fb
         frfjEts4PVhXMAP9UPjc9BPq7dKyOed0JEG42zLG3e+0/AStJNrmaEzS+OBW5FNzX9px
         +62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AevgfzwpFF0x/3DbgQzBrGCua8A9+rsxA+kfGfkdq6k=;
        b=dtVpC1vY9/MICMtp/gsor4yl43OWjqm/vB3mX3SXBdFwCNgirZ/9BTeouwqS/Yqlfe
         ZIAOsnmwl85e5YJsT5g1HTmJXiMGOvxEuMF0htk9KnZWpXVKHtmquzQPfHuxNNqzyCDE
         IDyIDDN0AqjoMWVsUDYB2Ij8FXngZHP4Lco5RG7AzXzorRYr/ant05Mxth2T4etn0yiB
         SVrHiHHF9BHuw5tKaIJ+9gI/Y9oi6cY0Hvp8KD3i2I60lR+sV+HOsJDbpJQHEtvEdtGZ
         pl2XrFch6Lywa9gmbf5QV1ld6Kbpe354LFgWBGAGp4e8mU+gEKvEfR4Kgg9Yg8a54UDt
         JokQ==
X-Gm-Message-State: AOAM5337nkDiidvucC2RCw0om4pz4G5kMtCjmOEc50vULsdL+WIUFZUu
        /VofHgKZXPUmYC15evhIk9g=
X-Google-Smtp-Source: ABdhPJy6ojAe9I5rirt9sYRNUYb8gKYP6SGXXDfaZktMdPDlhbTDoOPFGsiPgrCZafTBlivZIVwlqw==
X-Received: by 2002:a63:c156:: with SMTP id p22mr311849pgi.215.1644254305339;
        Mon, 07 Feb 2022 09:18:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/11] ipmr: introduce ipmr_net_exit_batch()
Date:   Mon,  7 Feb 2022 09:17:53 -0800
Message-Id: <20220207171756.1304544-9-eric.dumazet@gmail.com>
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

Avoiding to acquire rtnl for each netns before calling
ipmr_rules_exit() gives chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv4/ipmr.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 07274619b9ea11837501f8fe812d616d20573ee0..37bc9ad0df9933290ce91ae02321dee339294163 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -266,13 +266,12 @@ static void __net_exit ipmr_rules_exit(struct net *net)
 {
 	struct mr_table *mrt, *next;
 
-	rtnl_lock();
+	ASSERT_RNTL();
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

