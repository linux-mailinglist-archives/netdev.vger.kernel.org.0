Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D123C6DD
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 09:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHEHTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 03:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEHTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 03:19:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3287DC06174A;
        Wed,  5 Aug 2020 00:19:49 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id p25so332206qkp.2;
        Wed, 05 Aug 2020 00:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FaEGzOgyBR8AMrEH/saCACEjpxQkzKeYijkuZ/V+U+o=;
        b=ilW8vnnJJfaLmaAF552XrtvQJaLxZzmJQYy9RZXrp9+zWxJSn7ZBqnocioKgTZD7di
         M+gu5qpz8NGmWu8e5WFOIHch8DUejIzqTm4RA9XDm7qvF3qd0onAuG1HvZBA81ykTbe8
         ALSOyP42Da9aX1NBhuS99F4K8XEkal3QwiTCBi+OO2ud8gAvin9ReEiDk82Qw8/5+23h
         wi3ydf7gcOvfCey581GZTctje7xG35/DzCuxRGmvSmtSn2w02SGHDAtvtkMGjwq5lYI1
         OT0qk1uFZY66uxVv9UUw47h2Yd7BWoAXTsMJCg1/gS+Dzhu5FEimycK/4tNaOU7UR9Sn
         Qulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FaEGzOgyBR8AMrEH/saCACEjpxQkzKeYijkuZ/V+U+o=;
        b=n8h5oCPrw2lWN63UXVsdn28ANbQ6UMhJZfepC97oCvVJQZTh5X/7xO8V6QD+XOeSBJ
         j9sOgxiAkhVaKBA5N/C+xA19jaOJKJ3pztmucp0y8TV1UaSs4JnJr/OoSti+tpR9A+7l
         qmicFC3E/CrYsZG3wiDNCs/2zoA33D0k22igu7V43enTllfazC6c6YYK9ipe0TlikniM
         91gokPJ1QgLwyEbWvdA35X1z+yjwwK95nU317IdLwDPK6ceJsXT4ZXB7mOudjKMAczJ4
         HCK2gHK1a+W/0dojAWNk3hfVVlp5g7pSBWbMvW7Rka3Jk5POz5Ri8t6zAbW1hKwZmQc1
         9jeg==
X-Gm-Message-State: AOAM533la/Stk8MxOAhalJS1xH7VOZnvXodWJt9EIZp9JNchLqi9Suc6
        Xj/v6Bv/2Bq+4xQLOziOkuA=
X-Google-Smtp-Source: ABdhPJxTwbNbMDnDvBuxSOb/SHAzcUaYN56CL+kG8AQqLnCQWcOsXUp0JwT+Hecp1bNzf8wZlGuGcw==
X-Received: by 2002:a05:620a:490:: with SMTP id 16mr1848131qkr.89.1596611988431;
        Wed, 05 Aug 2020 00:19:48 -0700 (PDT)
Received: from localhost.localdomain ([111.205.198.3])
        by smtp.gmail.com with ESMTPSA id y14sm1389009qtc.84.2020.08.05.00.19.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 00:19:47 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, echaudro@redhat.com, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Cc:     dev@openvswitch.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net: openvswitch: silence suspicious RCU usage warning
Date:   Wed,  5 Aug 2020 15:19:11 +0800
Message-Id: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

ovs_flow_tbl_destroy always is called from RCU callback
or error path. It is no need to check if rcu_read_lock
or lockdep_ovsl_is_held was held.

ovs_dp_cmd_fill_info always is called with ovs_mutex,
So use the rcu_dereference_ovsl instead of rcu_dereference
in ovs_flow_tbl_masks_cache_size.

Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
Cc: Eelco Chaudron <echaudro@redhat.com>
Reported-by: syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com
Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 6527d84c3ea6..8c12675cbb67 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -518,8 +518,8 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 {
 	struct table_instance *ti = rcu_dereference_raw(table->ti);
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
-	struct mask_cache *mc = rcu_dereference(table->mask_cache);
-	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
+	struct mask_cache *mc = rcu_dereference_raw(table->mask_cache);
+	struct mask_array *ma = rcu_dereference_raw(table->mask_array);
 
 	call_rcu(&mc->rcu, mask_cache_rcu_cb);
 	call_rcu(&ma->rcu, mask_array_rcu_cb);
@@ -937,7 +937,7 @@ int ovs_flow_tbl_num_masks(const struct flow_table *table)
 
 u32 ovs_flow_tbl_masks_cache_size(const struct flow_table *table)
 {
-	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+	struct mask_cache *mc = rcu_dereference_ovsl(table->mask_cache);
 
 	return READ_ONCE(mc->cache_size);
 }
-- 
2.26.1

