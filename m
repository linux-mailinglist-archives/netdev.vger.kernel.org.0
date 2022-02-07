Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054364AC75B
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376411AbiBGR1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384300AbiBGRSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9AEC0401DB
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:17 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id t9so9431669plg.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nhf1JSHmzyYOiRZJUl9QvXuJlSfQJ/xOOZHY4kfhBUA=;
        b=N1ramoYW8p47+1cqUgGPOJnl0PEB1okXHm0kgoyVQECeH5IMVs3VX8diuU5kL509Ro
         qG83bq8gKM7Q+nvioBO1jMkJO4QnSw4QGcFbRk6SaXRQurQOTr/NWgKHnmfB/hRVeO3l
         OAHDgp0ehXXR2lQ9HcC7DQ6L9VbaQ5JF03Mgc2Whhbv4DN+yCUfrxXUp/+kWG92iUzeK
         /zn/p2o0fMEghpmv+eHcLwaGeXyCLF4lxDPenKDiZ+bKZNXGQBCzfB5qHWgBQMM4LZKk
         8Qz//wjV4UxU2LTGiYDenJxDm96fxTpPb+rvQ7QJPs/NkUepmL9E9ShASTsbD75vR3Tu
         7NtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nhf1JSHmzyYOiRZJUl9QvXuJlSfQJ/xOOZHY4kfhBUA=;
        b=TGDr1KkCsDlC+TeklbIbVmLqMhETMDyNYinAXb3DV5d7oy3DSjaaNw7aqzs8Y+d9Go
         ioBY44As6aVF6FhrotaU+RemyluorBvUmv7PKS7PYTxo2R0xoBt+RlPcrg2dN6LWuaxX
         6xK8BSEPlZ4yKB09Nrn8HIvZ2gaGCBvLgC8iZr2cn4TEuExoro83D5PWgsT4ReXnmAHu
         MEdhlQyphjqNipmbRrQqn1/8yJIIzkZTu/gBTC/PA6Df2ot1SoWxy7YYK6wvqG/B+xtG
         tOniRIkwbp6fW0VsARjUWIVMHelEgitQdIJtR0CtRxHL+VG6Mif/8pE5DFeLLdHqONCC
         YhEg==
X-Gm-Message-State: AOAM531uCTt72KjqQI39ZqHP58ueKD/zyaN6q+bzVzvYcaLAzmULCulr
        ypYoxL4XYnNjQprZ5St3F7o=
X-Google-Smtp-Source: ABdhPJwwPUZaDCzlULztzopOaD4/FQUWMYhmIzA+X5oIM7rQJ2pxFIuMC8giAMIe34SlCzVaCO8Y+w==
X-Received: by 2002:a17:90b:3907:: with SMTP id ob7mr5099546pjb.29.1644254296881;
        Mon, 07 Feb 2022 09:18:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/11] ipv4: add fib_net_exit_batch()
Date:   Mon,  7 Feb 2022 09:17:50 -0800
Message-Id: <20220207171756.1304544-6-eric.dumazet@gmail.com>
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

Instead of acquiring rtnl at each fib_net_exit() invocation,
add fib_net_exit_batch() so that rtnl is acquired once.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_frontend.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ecfc4cc47b4802eb5a573beb84ee44..8c10f671d24db7f5751b6aed8e90a902bd1be5b4 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1547,7 +1547,7 @@ static void ip_fib_net_exit(struct net *net)
 {
 	int i;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	RCU_INIT_POINTER(net->ipv4.fib_main, NULL);
 	RCU_INIT_POINTER(net->ipv4.fib_default, NULL);
@@ -1572,7 +1572,7 @@ static void ip_fib_net_exit(struct net *net)
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	fib4_rules_exit(net);
 #endif
-	rtnl_unlock();
+
 	kfree(net->ipv4.fib_table_hash);
 	fib4_notifier_exit(net);
 }
@@ -1599,7 +1599,9 @@ static int __net_init fib_net_init(struct net *net)
 out_proc:
 	nl_fib_lookup_exit(net);
 out_nlfl:
+	rtnl_lock();
 	ip_fib_net_exit(net);
+	rtnl_unlock();
 	goto out;
 }
 
@@ -1607,12 +1609,23 @@ static void __net_exit fib_net_exit(struct net *net)
 {
 	fib_proc_exit(net);
 	nl_fib_lookup_exit(net);
-	ip_fib_net_exit(net);
+}
+
+static void __net_exit fib_net_exit_batch(struct list_head *net_list)
+{
+	struct net *net;
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list)
+		ip_fib_net_exit(net);
+
+	rtnl_unlock();
 }
 
 static struct pernet_operations fib_net_ops = {
 	.init = fib_net_init,
 	.exit = fib_net_exit,
+	.exit_batch = fib_net_exit_batch,
 };
 
 void __init ip_fib_init(void)
-- 
2.35.0.263.gb82422642f-goog

