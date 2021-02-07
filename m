Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083A4312745
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 20:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBGTsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 14:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGTs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 14:48:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DA6C06174A;
        Sun,  7 Feb 2021 11:47:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y8so15739195ede.6;
        Sun, 07 Feb 2021 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c9WOOXaljgWkUz7GKIj1bERwrld5Mm5ktuTMXSqIFb4=;
        b=BwFg/RhK8pd6whM6m4oSg1lq+EeRNAviO+SgvZhFXQPCabtNQj9jmAEuVepKXkAEPZ
         UQlDxjx2rJQZdbWMtO2wpXgVsYhx/Ne5QRigmvZklC3yUfKvatqVwHBsYFwQ8el1NnLU
         KXO84ZvEP/RR/XpOmhN5EI6YT340d5nz0+Z6xRd/8ExVpiSDly8wJ23ktXYPa4vUWpum
         mBnJvdAltVr5eFEv93bblL6yWWdeHbE7AYoWqJP3AHZMsFFk62fpws99BRnclIj3+EAf
         9Cn/HNuqeyL86jBFG+mGSQTkDfY9mRcVyQKRNoWLObHRxMRmgOlbkpzZOkiZmxGxpSGs
         VqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c9WOOXaljgWkUz7GKIj1bERwrld5Mm5ktuTMXSqIFb4=;
        b=uT8BrRiE/1sUbamD9lB6R1FUs219I+95rEq5R+Kk0j4MEASkFU97ruXw5EsmD7l9Ie
         eiZ2VLHqW3Lt6qCM8rdHClOfyCPx5Z6ReTEkOK/Aze5O0SP8KeritAIPrTFe9gGJeWmi
         EeTIS4v9+Cson1NSRqSi5wLyDRIP//+F5xs4t6aXhq3SxHmFn4MELdSi+xzYe5Z//pve
         gKRkvxIuyetX9fQUdMj/b5tqHwC21SUIiW3nZumhOwrqz40t5PDYkmXeXPi6MXiJYoWD
         z3ptR+Ag1EgbKB8uSu8LkLv8Bq/HgkNXvxDG9gw7GrqGdYh+9/OfihqTToxYuBuOkvK1
         y4VA==
X-Gm-Message-State: AOAM531AJ+iX2bfdC0obpmsUEsOUdIF3K4kQxzPP8l4D2K/hdeoY+5Mh
        /suQwV7vSG7uofoYkVzgTSqQm5z5aO8=
X-Google-Smtp-Source: ABdhPJzjdZDTKi7uQxM8xft5Bg0nWZfqvOXyPuoEXtWjObw0ylJC/lPAPsiJtAfTBiBOLXqXy3SLjg==
X-Received: by 2002:a05:6402:151:: with SMTP id s17mr13474918edu.107.1612727265224;
        Sun, 07 Feb 2021 11:47:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t3sm7991648eds.89.2021.02.07.11.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 11:47:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net] net: bridge: use switchdev for port flags set through sysfs too
Date:   Sun,  7 Feb 2021 21:47:33 +0200
Message-Id: <20210207194733.1811529-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Looking through patchwork I don't see that there was any consensus to
use switchdev notifiers only in case of netlink provided port flags but
not sysfs (as a sort of deprecation, punishment or anything like that),
so we should probably keep the user interface consistent in terms of
functionality.

http://patchwork.ozlabs.org/project/netdev/patch/20170605092043.3523-3-jiri@resnulli.us/
http://patchwork.ozlabs.org/project/netdev/patch/20170608064428.4785-3-jiri@resnulli.us/

Fixes: 3922285d96e7 ("net: bridge: Add support for offloading port attributes")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_sysfs_if.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 96ff63cde1be..5aea9427ffe1 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -59,9 +59,8 @@ static BRPORT_ATTR(_name, 0644,					\
 static int store_flag(struct net_bridge_port *p, unsigned long v,
 		      unsigned long mask)
 {
-	unsigned long flags;
-
-	flags = p->flags;
+	unsigned long flags = p->flags;
+	int err;
 
 	if (v)
 		flags |= mask;
@@ -69,6 +68,10 @@ static int store_flag(struct net_bridge_port *p, unsigned long v,
 		flags &= ~mask;
 
 	if (flags != p->flags) {
+		err = br_switchdev_set_port_flag(p, flags, mask);
+		if (err)
+			return err;
+
 		p->flags = flags;
 		br_port_flags_change(p, mask);
 	}
-- 
2.25.1

