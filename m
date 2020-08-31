Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E19E257BE4
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgHaPMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgHaPJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:09:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F823C061755
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h15so6274205wrt.12
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=MIaPXvH4gfJyOHGaKsBWkcZkz3u8rsNPxppHOv0rpp/WhjoEEW0remHOQgTpV6DtzV
         qXi//NPlOTbqkElmlGeejQybeXjfml9qSSnelTFSAvYbpI1UcCNRkEZMqQXqHefrUzRs
         o0Hk584S/HXHeRgYwfp+smuF7NGIWOyMgaaR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=KSg2KWi8goC4ziQuuu+dbEqNgVejji3HcoWkInUwH1fkwBDe/6jZaMiYVzcntyFG1J
         89yA+eYNDKjQaZmI5GzYBH7bvOt6u75QvqpBWZsFdVm+iAEInbDAa/MeSkVSYS5BYAsS
         T59BmnjObEGvA5+7fVc8/2eCcz6ALzqal3Jm8aWY2a36fMZnd4XHoQrzgCFYYYIbPn4l
         hwux99XRSzhfwAbGmyrGeddQf+ypquo43RX9EzbhZuSn0Gh5cN6iUV38HvDJhy1/hi12
         AyaHIvOg5jQlXdiGPNv79sC2gsq1JWLwtblbNapN6toPUTynSilr5EP0oFjerPdq5Jqn
         7HBA==
X-Gm-Message-State: AOAM532zxtQjfV7E9S1PJr1odYxi193lpjRYOuJfN1Z/BXn2gTSkcLmT
        gmleSbtCqp2PMMi3gBFTsiNN0wNHzWjw1Tfs
X-Google-Smtp-Source: ABdhPJz/j5pjZIxRjBl0mJ/8WrDfDVDYxuv5q18PD8QfmyOb/TFHbUZailcfuMG0Hi9gB3zUcHBWrw==
X-Received: by 2002:adf:9ed1:: with SMTP id b17mr2040010wrf.227.1598886591835;
        Mon, 31 Aug 2020 08:09:51 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:09:51 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 01/15] net: bridge: mdb: arrange internal structs so fast-path fields are close
Date:   Mon, 31 Aug 2020 18:08:31 +0300
Message-Id: <20200831150845.1062447-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
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

