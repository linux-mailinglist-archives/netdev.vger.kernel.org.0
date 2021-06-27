Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5A03B5330
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhF0L5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhF0L5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E499CC061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id q14so20889383eds.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tXaZu1JnY1fDMsbDpIZGo2i5ejiWMyAWPkBUMBuPFTo=;
        b=Pb+njgp0SNTgafEqwOSsEjOm5DPp+L2rn9q9RrbFKLDdxbF4wzaxDZDb9HwbMZkYtY
         If8sOm5TCYHwpNB67bSWS5K6YT9MC3u9Jl/iW0I7TweWG8yHsviwHitONqGgH0WO5LB3
         PZEWJF0r4stm8vF8uZgnYOOg7OPMH2gintXogh2b/07VALvrJMUZLgxHL/YwpkwE/l4E
         d2UZGVEB01/zmxBdMVE9WYUx5LwFTnxnK9QYHXNTTFyips/i6tbZDSKhj8WVDqNUHHZ4
         p1KB2zZW7twX/a5SwWFQkPuaZjPwEIkHurh3idSQlxck3q0U9Den0w5rhZhNzI/dKAw2
         rJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXaZu1JnY1fDMsbDpIZGo2i5ejiWMyAWPkBUMBuPFTo=;
        b=pFgDvNB2ZsIE0Klhbq3QpLhzWVuWsdaeZSEa+p9eIQVhHLW/xZYOHCYpzxt6Aim658
         Vvfmu3F5ye6hSkg2faeQ4gkuQFCV8BjDyq2+TL5xiJXSZAucSiXOcNdSf3w7hGAwKs+6
         UpF3A9j/t8EzfUZnPqWwUuYdi4lKshqM3dGHIDQTz9D/0CC3VSv7REOctphGjWOnIimL
         iEUHrPxa9Tx9Tb2zarABixFXWYEqfQLf7/+j5129ylugJcChKWVprUA78Ha8G9nIyQ/X
         3ez3yTtjdE8gwmK9olh59/thZlIl3nwIWa8KCu11698RRlgegiWrfPsw93ln4gtyonR0
         rdbw==
X-Gm-Message-State: AOAM533H/C99+tPk2t84ZBLFUdgekd/VFWxY6ekZ+peybJgTk/fzBlXx
        7K++Pdun8dV5M7Up6+oIy4o=
X-Google-Smtp-Source: ABdhPJxAOitTo+IeRNDhSyLiqpjJXvFPCoJn8WGFqd/lznlXPs1CHLiEP/24s1sH+v3G4L8+6WGKdg==
X-Received: by 2002:a05:6402:30a8:: with SMTP id df8mr26764352edb.7.1624794877494;
        Sun, 27 Jun 2021 04:54:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 1/8] net: bridge: include the is_local bit in br_fdb_replay
Date:   Sun, 27 Jun 2021 14:54:22 +0300
Message-Id: <20210627115429.1084203-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since commit 2c4eca3ef716 ("net: bridge: switchdev: include local flag
in FDB notifications"), the bridge emits SWITCHDEV_FDB_ADD_TO_DEVICE
events with the is_local flag populated (but we ignore it nonetheless).

We would like DSA to start treating this bit, but it is still not
populated by the replay helper, so add it there too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/bridge/br_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 698b79747d32..b8d3ddfe5853 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -737,6 +737,7 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	item.vid = fdb->key.vlan_id;
 	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
 	item.info.dev = dev;
 
 	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
-- 
2.25.1

