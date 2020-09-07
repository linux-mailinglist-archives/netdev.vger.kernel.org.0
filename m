Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2531D25F716
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgIGKAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgIGKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BB8C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t10so15190648wrv.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=bVyxGhCWIZ9VYIj9RlCNV77IOzk3rO8UCxYK4QMPM68d7kuxLho76goHZ2ZQSEMcP0
         LcyCh6vTxgJl9qgN5USGI/zCz67NR0w+hpKgILoKf+2CNpUU+33BJv/xPbsMUIrKwLPf
         m3etfqQvDVyuAsN7qoDah3eylovclJsJr6kMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=YFUGujdoMPQxApzK6DrZy4iw7pGSP0Kb4oKM5cAkvDEg/omyGtTK5ZarJjmUXiUwgV
         +MAugtV4QUZg+JVoOYUgsF5D/fWdjL27tX9mBOlcyYthpLwf4wG50dha6axnVfEebwpP
         LNJANWidSpA2RGp/bPmSeRVVKL9DaqB+u6jmcIFKpfN2o5FYkNPHvAX79tuFv35wGzwn
         LM607dRSZ0WQW4izeg5mRvKd5HyPT9a3PCFMFXyVEv+xmvEuFlpWmG6vjnX9jzDcdn+G
         EXftoHVZLJnQKwibTq3gLnNqiWX6fEMs53WjINJ1SgsKTt9zNY10lavo1UYF9QiJBoh7
         vABA==
X-Gm-Message-State: AOAM531IMSS9YByOZJfdmwQiGOzeNsGCNvF2OQIsTeXh8CyD0vF3Fbx2
        6nigAKAFBT08K3aMi1Xn1kW71alqJHdijoTg
X-Google-Smtp-Source: ABdhPJz2C0FszsgBZ7NbUgMCJvp18aUjmH/YzNyVi0xwqtj1p1FInLGmU5VY+WhcgshjrmpiiMWAKA==
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr1714408wrx.140.1599472811288;
        Mon, 07 Sep 2020 03:00:11 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:10 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 01/15] net: bridge: mdb: arrange internal structs so fast-path fields are close
Date:   Mon,  7 Sep 2020 12:56:05 +0300
Message-Id: <20200907095619.11216-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch we'd need 2 cache lines for fast-path, now all used
fields are in the first cache line.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_private.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index baa1500f384f..357b6905ecef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -217,23 +217,27 @@ struct net_bridge_fdb_entry {
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
 	struct net_bridge_port_group __rcu *next;
-	struct hlist_node		mglist;
-	struct rcu_head			rcu;
-	struct timer_list		timer;
 	struct br_ip			addr;
 	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
+
+	struct timer_list		timer;
+	struct hlist_node		mglist;
+
+	struct rcu_head			rcu;
 };
 
 struct net_bridge_mdb_entry {
 	struct rhash_head		rhnode;
 	struct net_bridge		*br;
 	struct net_bridge_port_group __rcu *ports;
-	struct rcu_head			rcu;
-	struct timer_list		timer;
 	struct br_ip			addr;
 	bool				host_joined;
+
+	struct timer_list		timer;
 	struct hlist_node		mdb_node;
+
+	struct rcu_head			rcu;
 };
 
 struct net_bridge_port {
-- 
2.25.4

