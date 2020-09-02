Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F306925AA47
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIBL3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgIBL3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C71BC061245
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t10so3998670wrv.1
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=Gu53H7KUgfZBNNpa4067GYBOmGvciq/0MwHhdQww5zmdtIRjqRUV5GKBOMB4icFePH
         fQOO/dxkUznueovCd9bc4fTGkCK9wyLhJgKXozG5uosU7znnWMcHJ47IUkpNsd22CB8f
         J0JNlUMm04xwqlzfEGrmkl6Ci/2UlTvcjgkKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=Hty6XS/aF+9OUE6g3N62rWyGKR/Nr//YT8+4i4r09EKQw/dqATMfsxmFi0uptYIB+m
         mG/kZDeh5Kf20KdfC/iz7PDuay7nJOWvDW2JA1hVNwSrqF/Xp2dUKytoRWTOzY9XKS+o
         UR4ucMqhxEmBRTx+pXwG3k1vzc4yr6JgeV4perUmbrAv/RObR9W3gQ69AzlClP4rcKcz
         arVj/41F69L1m2y66IYiQ58ynAQkDEvsLUQgmGI3fFeisB2GPxpzlxzE7dnw4Zr28WE2
         CYT9GZjzuPUhsTl7ranawOEe+hgYxbMSX/K9cFCbuxKfJFjEtRZ8Dr7PWs018+AZAxMT
         sJZQ==
X-Gm-Message-State: AOAM533vP5+M69PYAg5H5+7YHJwud3csjUkwP8W+ruGADuAKq3Bb4Vrp
        CMXfd1YAA1sVaFLTBkdBDbWPD9LlAITivkLJ
X-Google-Smtp-Source: ABdhPJztgZIAZY6hQYZlguadJQSoUJtvPZ5Aw+s3Bx1BMlATLWTtkDtXEg6V01LmTnfrH1uDB4/sKA==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr6378759wrq.381.1599046149367;
        Wed, 02 Sep 2020 04:29:09 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:08 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 01/15] net: bridge: mdb: arrange internal structs so fast-path fields are close
Date:   Wed,  2 Sep 2020 14:25:15 +0300
Message-Id: <20200902112529.1570040-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
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

