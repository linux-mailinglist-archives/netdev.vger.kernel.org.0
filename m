Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B8F323B6D
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhBXLqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbhBXLp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:26 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33321C061797
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d2so2050204edq.10
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=667OGP0Gur8Sq+vHsTVkN4C3tR422yk3lVbW1cl/0Uw=;
        b=o+6vY7wsB9AQBYTO360K6jEVdDhsIdH3YjnbrCuQz8j9lrGrh7hP/dnaUYwDVegkyb
         eEnwm8Vo6zEdXwlBWkjIb/pkwy0oYTmOKUxyhCpUTPOQDjaM0y2hPuio++fCIbXyGKm3
         25KwVs5Jizedg4ZrCZM3crtcIiefcqBoowDLC1ceZlC2PBxOs6TCh/FiQkZw9eEi+IKy
         VvVlTaBhnWOcLVjXveDfKlbmeWvlwUSU1FA1SfbmO72Umfr8hmUMrtbSnx4v+XhymYko
         WjFznW20cpDv+2LLCFmdSGVJ7zlDOsSoPuFHANHSHmISmQPU7rJywCYZTgdxRCXJWG8L
         wFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=667OGP0Gur8Sq+vHsTVkN4C3tR422yk3lVbW1cl/0Uw=;
        b=fsKM5w8wg8UW/sxbaK2EBT6HmS0FmZPm8QEVKe4woO/hpwH8eslXE1i44j8lUKAMk1
         Rd5liUBX0/HlKBaPkNxNCsEr7N3n5eMhKaLACQqjzS5A7+fnYLfjXT3QZwismYd5YavJ
         KsUQCmq/rqbLoyWdajRlmy13aokJIW5KcZg0k8CKoWjaU3vnwJlWbcyYv77eE9W6R23t
         RiRxavGJt+TDAOaRamwiHUUUfgf7PfvCePzxzFa1wXpuq4hsfZzSlSa4YvlOAAF9jJT8
         Z9xK+RE3IIQXrZfKYDc5CPDKETs5POBhCtuvxJmSPNm2LBH7Den0tT9GYPjST3m5ELI/
         CO1Q==
X-Gm-Message-State: AOAM5322YGJPNGtWN/NBJ6tTQDvmPRiCZll9z5JMSmdE+p1hyEMpZA74
        fkLG0sXYdF1WG9Ri3xglNnISOVPk8zg=
X-Google-Smtp-Source: ABdhPJyfut56mhd0R1WD+LbadiL0LDK3gh1OJuqZuwHc8Jru3rynLgOUYTslt6l7wGA1RK1xrDvQvA==
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr31705045edv.131.1614167048745;
        Wed, 24 Feb 2021 03:44:08 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 07/17] net: bridge: switchdev: refactor br_switchdev_fdb_notify
Date:   Wed, 24 Feb 2021 13:43:40 +0200
Message-Id: <20210224114350.2791260-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Instead of having to add more and more arguments to
br_switchdev_fdb_call_notifiers, get rid of it and build the info
struct directly in br_switchdev_fdb_notify.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b89503832fcc..1386677bdaf8 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -107,46 +107,27 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
-static void
-br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
-				u16 vid, struct net_device *dev,
-				bool added_by_user, bool offloaded)
-{
-	struct switchdev_notifier_fdb_info info;
-	unsigned long notifier_type;
-
-	info.addr = mac;
-	info.vid = vid;
-	info.added_by_user = added_by_user;
-	info.offloaded = offloaded;
-	notifier_type = adding ? SWITCHDEV_FDB_ADD_TO_DEVICE : SWITCHDEV_FDB_DEL_TO_DEVICE;
-	call_switchdev_notifiers(notifier_type, dev, &info.info, NULL);
-}
-
 void
 br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
+	struct switchdev_notifier_fdb_info info = {
+		.addr = fdb->key.addr.addr,
+		.vid = fdb->key.vlan_id,
+		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
+	};
+
 	if (!fdb->dst)
 		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
-		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

