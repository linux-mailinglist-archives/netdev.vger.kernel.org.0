Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84579F167C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 14:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbfKFNC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 08:02:56 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40174 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfKFNC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 08:02:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so18814573pfl.7
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 05:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+6IhpubehfBA0fyJjLMHiNK4Ws0tjewQBWjUKRYVdLw=;
        b=BwRluK8aUtLLdcxG2z8/nph89NqKM7PzqM2Y3bEnjidQLVVaFI7ajGDX/sdwwmKU/6
         zi0jeKGdvDiBoyBKLBrz3SduZjt2kBcwvwAQ++8bbLKR5srdaGO5NekFt6y7br6jOTuy
         8/8hho6+P398artNk2iCDr2uBbfq0RT5YPaVioud0SI6s2EK3/8AEznU3exyxjpt0A8B
         xW08equWTJCztCuCqsBbVFD3m8665fB3iGmlA/3KyIUH3E14OA1g5TMObTdxtOlzgIX+
         Lsil1oBMAnR3abMl1iupai6WEWkTSCF106RumpXbhBWXA7l/g7G23UQLefdsLXipk4Zz
         GoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+6IhpubehfBA0fyJjLMHiNK4Ws0tjewQBWjUKRYVdLw=;
        b=cizO+1V7we9Dk2aANbxirKYQX7AKCR5+7wKEUSyBntpicvQaSqeYkQZoV6Ki8/vpP7
         oUFaot3ql4tWPoEGkcUUbO1okhOt1WvM4hny/EzMVOVR/WexSw9+LI+18UfHbfpdfPEX
         9ianr1zBsZnyWXpxF+1z/94stgcEztpRyLsCIuf8v/iW37luvxksYYMonTzlkJyMXaCo
         J1/OHHIEPdyd8yyKn88JkO/FR3KxHxzhayWn9BvSQQ4XWnqqAFCAYOIL5sF0o/N46fsx
         OLsXWx02PHrN4GtkigtpCAzaMPlKnXy4Hj/kbkj5aiarjShNUpXBNkQe7uBUFBvwk+km
         ZKMg==
X-Gm-Message-State: APjAAAXLW9hRMsxW5b8Pig/qt91cEtExzs/zcfDs6nDBEyJIO+4p8WhK
        oILyQxYgBIg9VnJPhnMoC7M=
X-Google-Smtp-Source: APXvYqy7x0s4utY6gJRlVq6qhvBzfoGtbX3vso05sKYlYcqFahKR1GZLIJsSgx6V1h/sWUllWbfACg==
X-Received: by 2002:a63:1e59:: with SMTP id p25mr2687705pgm.361.1573045375871;
        Wed, 06 Nov 2019 05:02:55 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id i13sm21560pfo.39.2019.11.06.05.02.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 05:02:55 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     ee07b291@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] net: openvswitch: select vport upcall portid drectly
Date:   Sun,  3 Nov 2019 14:59:44 +0800
Message-Id: <1572764384-130234-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The commit 69c51582ff786 ("dpif-netlink: don't allocate per
thread netlink sockets"), in Open vSwitch ovs-vswitchd, has
changed the number of allocated sockets to just one per port
by moving the socket array from a per handler structure to
a per datapath one. In the kernel datapath, a vport will have
only one socket in most case, if so select it directly in
fast-path.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/vport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 3fc38d16c456..5da9392b03d6 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -403,8 +403,9 @@ u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
 
 	ids = rcu_dereference(vport->upcall_portids);
 
-	if (ids->n_ids == 1 && ids->ids[0] == 0)
-		return 0;
+	/* If there is only one portid, select it in the fast-path. */
+	if (ids->n_ids == 1)
+		return ids->ids[0];
 
 	hash = skb_get_hash(skb);
 	ids_index = hash - ids->n_ids * reciprocal_divide(hash, ids->rn_ids);
-- 
2.23.0

