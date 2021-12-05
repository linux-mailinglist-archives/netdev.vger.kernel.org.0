Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BE9468CFC
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 20:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbhLETby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 14:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbhLETby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 14:31:54 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A3EC061714
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 11:28:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id o14so5685814plg.5
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 11:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G8qM4hLYrduERjwSeQguYYpZCxFH9CSvxJihnHz1THc=;
        b=BThkCyJCjcYDq2zVgo1ju1mvh3HB2T9rBDgVAR+c0GvSrgyN5slfa8ngEpmjXpmsqm
         Qj8ncaxNlJWk0ndGY1/xRRqqQ/gA/oijUSINBPlwmmGNcJAWYxoSjyLp8EWl2I9igZ59
         b80k+JiqOWZ/NCUPKPrVXqx+OySdzDiigU7kf6QcRwHg+tJwFaIBKR0jyt29K5yUKLrF
         5WnKRJhmrlgy0UlLvpsaN9MIeGlxv/qDu3WkXO0qGQ4et4T8vF+7ESDJWfcRS9XH/jeU
         lQz/+f+9Kvvn3eD1NW9OSoVYq8lKSICNJ3e3nC6WUGaE3Bpv7Fbjd9xAm5LIrfFJrrGY
         zZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G8qM4hLYrduERjwSeQguYYpZCxFH9CSvxJihnHz1THc=;
        b=ErLzxqcDITZ0tffpZUnLCzppLHwok0O5SSH3znOSX5WwCn20u9x1CNECPJfBRy4de9
         IW4S+AJD5dv/oBV+xdKxG1jmSPBJ5+J7eCxuP6hSt1r9L2XV3t+VPxacnqdZJbrkWToV
         7EvlSrV7F5ifSaXt4hXwffbirOOZsLEZLkpu2ZwQJQMFJfYOqa5ORyk+p3QgMucBZcXl
         PLqmDWovGCIPPg2AXdMSeRr/hor+2Np2++sdf8AzmdUB+Px0ra0eu4dZR9fHys1jhh2e
         lxrtnIJuUo34bXePh8hyBxq98SOavCnuQ900+soEKRGZWWaue3H9/CsWi9nZAeVoe3ew
         V3nw==
X-Gm-Message-State: AOAM531UVvnC+yVnOH5uXiv28rHp6IqUvht3vpPp4HuJcxx9xVCAIEMO
        Ti1kmab0lA1nkI6uXnUpt4s=
X-Google-Smtp-Source: ABdhPJyGS6Rh+mWuTawLFAnKV8WQbl+90Fl0cDFpqGz/dhf6XQNEBd7iRA6EgRWqx8mbKLZpPgcIWg==
X-Received: by 2002:a17:90b:190f:: with SMTP id mp15mr31455905pjb.210.1638732505845;
        Sun, 05 Dec 2021 11:28:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a314:9d83:ab71:fd64])
        by smtp.gmail.com with ESMTPSA id t38sm9669465pfg.218.2021.12.05.11.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 11:28:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] devlink: fix netns refcount leak in devlink_nl_cmd_reload()
Date:   Sun,  5 Dec 2021 11:28:22 -0800
Message-Id: <20211205192822.1741045-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While preparing my patch series adding netns refcount tracking,
I spotted bugs in devlink_nl_cmd_reload()

Some error paths forgot to release a refcount on a netns.

To fix this, we can reduce the scope of get_net()/put_net()
section around the call to devlink_reload().

Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Moshe Shemesh <moshe@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ad72dbfcd0797ae045734b83fbbdc090ae3ff53..c06c9ba6e8c5ea00a3999700a6724a404c1f05f9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4110,14 +4110,6 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		return err;
 	}
 
-	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
-		dest_net = devlink_netns_get(skb, info);
-		if (IS_ERR(dest_net))
-			return PTR_ERR(dest_net);
-	}
-
 	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
 		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
 	else
@@ -4160,6 +4152,14 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		}
 	}
+	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		dest_net = devlink_netns_get(skb, info);
+		if (IS_ERR(dest_net))
+			return PTR_ERR(dest_net);
+	}
+
 	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
 
 	if (dest_net)
-- 
2.34.1.400.ga245620fadb-goog

