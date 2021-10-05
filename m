Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED199421B68
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhJEBHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJEBHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:07:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B3FC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 18:05:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so1119276pjb.4
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 18:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+iXeEDAIqZFpKzfejZ9nv1CbLkL2C5Anu0poQ3NKkOI=;
        b=eE288HgbKoqxiK5TVO8s069yGSAwwx+kS4MaBQIw1vZ5I08745ahWflusuGtTv501q
         6f6KMUD8Xp7uuqpziy06kE/nZkUA32ATqoMvE90f2QGwnoJn7zwmLv/CtVVobJ6xZf9u
         pYT7ce6pexLl9EEIVCVZS8XzVV4GGT+qCmIpyS7Ls4vfLb22C6i4eIjCJbvnNvJew6So
         XNtS7YxQLjQN4x4oSGtu+JfEl5ZzWsBF9jsf7V9sNGw0d0JD6etO2H+ruTe+Wu/CYxST
         BeACY1g9l4rDAPMs8JW7x37xrYM0jqal4laNN3dNEkjhMBYVhMhq2PleOeQUEEf/dYVK
         3wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+iXeEDAIqZFpKzfejZ9nv1CbLkL2C5Anu0poQ3NKkOI=;
        b=z/RCsW+tpqu3tUOumYSelni+J0ShYbs71nUeedeVcio/hrTmbDmmdICh1W4ZGDxNO9
         MZFL6ERXHjv7eMeu1OifV+n17ufKq3LF5ZoRBQ3x/WtDuYmLrxl92O5nAGACUThxZV5l
         6iMR66uoncn+Puk1SnQRji8SmZrWVpY5+IVocwNTUdFhjAq+bMSny6/gX3n54YeXrGtD
         UAryPn8oySOLvoHdlehyCQ2T32oDAkNw9sbfNABqdU5CGX1FJKDP7QcY1yolztNXd05g
         sgrDqazkpB3J68T2Av5PFjsTdVMhNXWAgxzdfs1HbrBeWTVvGId/4LXd4Cn8HAdkTSAF
         WrLw==
X-Gm-Message-State: AOAM533T3V8xhytrNMcjR1LfhhPbseWkhXrZESWmcuqXR+FP4DB8tySP
        8Vm5DrSD5CVnhZG3GOVfsI8=
X-Google-Smtp-Source: ABdhPJz+hiJTWxvmxJlEVOx5uV+b2AtziXMzVQgvx2to56lEbZ45HL+y8t7nEJG/SGF1ypkCqVd4hg==
X-Received: by 2002:a17:90b:38cf:: with SMTP id nn15mr302163pjb.81.1633395915005;
        Mon, 04 Oct 2021 18:05:15 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7236:cc97:8564:4e2a])
        by smtp.gmail.com with ESMTPSA id d67sm6509348pga.67.2021.10.04.18.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 18:05:14 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 1/2] net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
Date:   Mon,  4 Oct 2021 18:05:07 -0700
Message-Id: <20211005010508.2194560-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211005010508.2194560-1-eric.dumazet@gmail.com>
References: <20211005010508.2194560-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

bridge_fill_linkxstats() is using nla_reserve_64bit().

We must use nla_total_size_64bit() instead of nla_total_size()
for corresponding data structure.

Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6c58fc14d2cb2de8bcd8364fc5e766247aba2e97..29b8f6373fb925d48ce876dcda7fccc10539240a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1666,7 +1666,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 	}
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
-	       nla_total_size(sizeof(struct br_mcast_stats)) +
+	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0.800.g4c38ced690-goog

