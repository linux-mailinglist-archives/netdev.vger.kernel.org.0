Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BD8468914
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhLEE0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhLEE01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:27 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22995C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u17so4836305plg.9
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OWkHOXx8BHIA++SSrqZPcWFF38smQw8WE4tSbefbPTs=;
        b=LQdjkRT5Dt0mkis9aYIq2W1mfdhZC3OUzuGFrNHpd83rXKc1ILJ/Pj8gX7ddsumXS6
         3G87z9x5/nSu8kaqoPGEhLOcC9D2h9/LWN0m2k2lpcKH11xrsxIn5+SsZWTiiRXLg7i4
         tSkpVi/uLwKB8oIB6L4/4jtyXjo5jDr89rolVhaiKvciVzcPOadCQKnSyG8bAvh1q+xF
         +IoKivPd9qsJiiiiB2Px6eMiqBJbGOywaL1X3WpomhiWVgGNp0cv/r0Q/8fNftennLg1
         XqwfZZwoiv/EXyRzeKqXaQNwaBd3Du3QxTBHoN3dSrCkwEabNNuBe3mvDcWwSwPYsaPG
         tWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OWkHOXx8BHIA++SSrqZPcWFF38smQw8WE4tSbefbPTs=;
        b=oXKJMM9DJlPPQG2kFOw8Lr98WIlecf1LmoaWo+BLHLep/0gwk5pLze9AggOxWdnq9R
         XySFC/yXcXDf26SxkB+GO4KThEbjEYL9REk2kOUYofHZwzjixcSTImxlU/5KvJZYaPmv
         iuw1YO1cQES71shLo+AJa8vxvpNptcv7Xyj6RMosR+bUcTvNqiNCdpFoadffBdj0WNVO
         2vfhJqa9M7AZnWcy6AujD+9WhP6R57Wm3xHwkAOZySb1Lb7qkh62Cnz6SOBKY9TCDjfZ
         J+4+JZc1qashem+GYNArNo8YvQhDbKRz3YEb3j+ehppmlW56XZnxGpyTvGiYD9b1jNwC
         3PEA==
X-Gm-Message-State: AOAM530w2S9Sl8hjjue9IiANTCBmlaFxlA6SfxdhJMFZPjYvqmI2JTyd
        la3T0OEhMsGi9OoPoGoHxBQ=
X-Google-Smtp-Source: ABdhPJwHQCNWAEZ8ysjZQDdLQqELjf+jyERYWIqe3J+S9xftoSROib4zltEuOATEmO81UJgllaVoqw==
X-Received: by 2002:a17:90b:4c8d:: with SMTP id my13mr27491166pjb.107.1638678180701;
        Sat, 04 Dec 2021 20:23:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 08/23] drop_monitor: add net device refcount tracker
Date:   Sat,  4 Dec 2021 20:22:02 -0800
Message-Id: <20211205042217.982127-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We want to track all dev_hold()/dev_put() to ease leak hunting.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/devlink.h   | 4 ++++
 net/core/drop_monitor.c | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 043fcec8b0aadf041aba35b8339c93ac9336b551..3276a29f2b814cda1fdce80f52c126c1cd444272 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -664,13 +664,17 @@ struct devlink_health_reporter_ops {
  * @trap_name: Trap name.
  * @trap_group_name: Trap group name.
  * @input_dev: Input netdevice.
+ * @dev_tracker: refcount tracker for @input_dev.
  * @fa_cookie: Flow action user cookie.
  * @trap_type: Trap type.
  */
 struct devlink_trap_metadata {
 	const char *trap_name;
 	const char *trap_group_name;
+
 	struct net_device *input_dev;
+	netdevice_tracker dev_tracker;
+
 	const struct flow_action_cookie *fa_cookie;
 	enum devlink_trap_type trap_type;
 };
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 49442cae6f69d5e9d93d00b53ab8f5a0563c1d37..3d0ab2eec91667bdfac93878a046fc727fc22b99 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -850,7 +850,7 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 	}
 
 	hw_metadata->input_dev = metadata->input_dev;
-	dev_hold(hw_metadata->input_dev);
+	dev_hold_track(hw_metadata->input_dev, &hw_metadata->dev_tracker, GFP_ATOMIC);
 
 	return hw_metadata;
 
@@ -864,9 +864,9 @@ net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 }
 
 static void
-net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)
+net_dm_hw_metadata_free(struct devlink_trap_metadata *hw_metadata)
 {
-	dev_put(hw_metadata->input_dev);
+	dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
 	kfree(hw_metadata->fa_cookie);
 	kfree(hw_metadata->trap_name);
 	kfree(hw_metadata->trap_group_name);
-- 
2.34.1.400.ga245620fadb-goog

