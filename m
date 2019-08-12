Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E47889E49
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfHLM2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:28:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38049 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfHLM2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:28:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so104384250wrr.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7A4eNSWeK9YndIt26eOwp3EoCV7KRIZ4gIbcdaur4oE=;
        b=whguzWLQTtSkJsDnn1u66szC8L7hbXzc096RJ9nPjp/za8BJUUypU8bLZ6kvCjLAc9
         Qqtal4/YTAds3YxSYDXdvspxB403TZwEA8CLg8G+fujj3cREpBAxn7TRYjrlG/IHH+dv
         4OGo8qvdZR9iq+QiTnS4YGzTKQZ49vZlX3QYGfCSNE2me401XhMSMAwUGLaDkap7fPXI
         Pysl8hur+E3tmtRNksrRirWX4aKU+6fdrKlEvdN0Zi7O4UG8yBL3kX9e7JumvWRyKSry
         R7wEf+MeEuBGsdmOGjgMUBimR5H9PpG4BZApPIRXTnlVKXkLC3bCAeoWUQREI5VMZOzT
         qb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7A4eNSWeK9YndIt26eOwp3EoCV7KRIZ4gIbcdaur4oE=;
        b=Lh7QAw5SREKvvVDb5o+Sx8tLUQjc1ZvuqrSg8Z08eDseo83YGncz9MsxxAYJPzteJr
         mhqaGVdoBfYZCYbBaPnirasuRabb9p3pgrruUFRlf9YonD8A1ZPiLKGWWqdUGHJZYBWp
         4TwYFyHkKOmbTo2g5kvgsrrIeGpHV0m3QfO/X+2+d6cxFKYiWrnxXRrexXTlitYtvBIc
         3KLIKKKYHdh/4eG7EELFgVrizFJ5vBvBRkLfdbNZC0seaxIzA2D1WrHmV5GDsqT4GyNw
         hG56wq+7eR6juScl6D2RLS/QUQKk8wJNO8cvlTtEfZjLNnpt6llACl5pVDf6hkHOGXUj
         yC3A==
X-Gm-Message-State: APjAAAUe3uGmJeyLfzIAQta96oTJ6VZcLLA71TS3o1AEMKzGTmMaGzJ+
        lv2d/hr2qo2npFhAUr7M1KqDoVilI5I=
X-Google-Smtp-Source: APXvYqyXzPnDPkIRowRk4JJsVkJ4GHThVgFz0leoo+/6lezwmgwaH3+8SAe07PR8Q47SM7NsVBsLdw==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr40690540wrv.39.1565612912461;
        Mon, 12 Aug 2019 05:28:32 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id e13sm10345020wmh.44.2019.08.12.05.28.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 05:28:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net-next] devlink: send notifications for deleted snapshots on region destroy
Date:   Mon, 12 Aug 2019 14:28:31 +0200
Message-Id: <20190812122831.1833-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the notifications for deleted snapshots are sent only in case
user deletes a snapshot manually. Send the notifications in case region
is destroyed too.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index aba2d45f9087..d33284ac3e7c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -379,14 +379,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 	return NULL;
 }
 
-static void devlink_region_snapshot_del(struct devlink_snapshot *snapshot)
-{
-	snapshot->region->cur_snapshots--;
-	list_del(&snapshot->list);
-	(*snapshot->data_destructor)(snapshot->data);
-	kfree(snapshot);
-}
-
 #define DEVLINK_NL_FLAG_NEED_DEVLINK	BIT(0)
 #define DEVLINK_NL_FLAG_NEED_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_SB		BIT(2)
@@ -3677,6 +3669,16 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
+static void devlink_region_snapshot_del(struct devlink_region *region,
+					struct devlink_snapshot *snapshot)
+{
+	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
+	region->cur_snapshots--;
+	list_del(&snapshot->list);
+	(*snapshot->data_destructor)(snapshot->data);
+	kfree(snapshot);
+}
+
 static int devlink_nl_cmd_region_get_doit(struct sk_buff *skb,
 					  struct genl_info *info)
 {
@@ -3772,8 +3774,7 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	if (!snapshot)
 		return -EINVAL;
 
-	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
-	devlink_region_snapshot_del(snapshot);
+	devlink_region_snapshot_del(region, snapshot);
 	return 0;
 }
 
@@ -6836,7 +6837,7 @@ void devlink_region_destroy(struct devlink_region *region)
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
-		devlink_region_snapshot_del(snapshot);
+		devlink_region_snapshot_del(region, snapshot);
 
 	list_del(&region->list);
 
-- 
2.21.0

