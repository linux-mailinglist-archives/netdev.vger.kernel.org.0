Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D621825E663
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgIEIYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbgIEIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:43 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E4EC061245
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:43 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c19so8923603wmd.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=Uh0gVtRexg/t5N4Bs34Iy8svBAf0j1Ndu1L92Nr5n6+LSgHVlabnS52xlp/8krpXs2
         Y/7kXOLKeAfG9jqhutMhT06FHrDpqCaldBq3FysFp3buenTkPHK6uMdb6XhVaquHCiTI
         AQE1qRp3J7XOOJn59y5w9VJy3qtzANpDKjlHE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDPaNY6uULGl6w+zVk/xRhftdiMNqXaciWDwCjq2kwk=;
        b=ZWCa8K/dwE3BDC8zJNVwEmdM5RIo7Cek6BmcD/nY+YqIykbsYAJxiXvuDqTr+g6jMh
         k2bopTYdsYyrAzlgZSnRYPExlXX8gjFk30eUG5Le5KVRnZ2tm2cKshEgmiE70a5oEB3/
         VE8T89qoQEAWwQKZVG551X4wu7ukyVV2l2hzYXFglOh/egfITawJofIoHH6I3yDxTDVL
         OdASZekrilYjOXdfu+umRldVw6b/T1BqWVuhziZ+EzngRM3X6DiVNVLPDpLxbTDIxmPb
         qV8DgLBVqCsLPCMGUtX5FXzKqeFeyK90OkH27ceweMV5PY90VOnzUQAq5od4eI3bkkoG
         zY+A==
X-Gm-Message-State: AOAM533+L0W9kbdTtnPBeZs0EBdeXn2U7nkAPYFpNqvwlMsu6H4fb1eK
        C7quUDkE4cNBfYQ+1ENBrhMwOJYXG4MiwplA
X-Google-Smtp-Source: ABdhPJw6M/ORbXjh8tWXkD3EVxqSA8OMa9OKJZUFBMNaKjg62fV+xJXGe6Cm0bOSFVu9xnqFv9dj6Q==
X-Received: by 2002:a1c:156:: with SMTP id 83mr11356984wmb.49.1599294281495;
        Sat, 05 Sep 2020 01:24:41 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:40 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 01/15] net: bridge: mdb: arrange internal structs so fast-path fields are close
Date:   Sat,  5 Sep 2020 11:23:56 +0300
Message-Id: <20200905082410.2230253-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
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

